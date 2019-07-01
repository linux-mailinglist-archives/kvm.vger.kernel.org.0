Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833AE17EBA
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfEHRC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:02:58 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53066 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbfEHRC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:02:58 -0400
Received: from zn.tnic (p200300EC2F0F5800A4469260603C8E24.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:5800:a446:9260:603c:8e24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6C4361EC05E1;
        Wed,  8 May 2019 19:02:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1557334976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=QsH1WRMJgZkl2tX1i0OToAGG8BFivK5Xbifm/yUt7oA=;
        b=REDLYE51XtLVWUDWWulI3/3wY8CRHmaZfrJAI0z2dO8K9UeEGfN8pKnrY6LPE4lC6AvZvS
        wJkPbBz3kfHRDhLZXOqNC3b9YFq7k4UsitR5cnZ7DNvd49/lS+tLLJDvjj6a8TMr/Y1DN+
        gcX9bYoyvndsu8ooPpOH2WDIiXfISuk=
From:   Borislav Petkov <bp@alien8.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Subject: [PATCH] x86/kvm/pmu: Set AMD's virt PMU version to 1
Date:   Wed,  8 May 2019 19:02:48 +0200
Message-Id: <20190508170248.15271-1-bp@alien8.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

After commit:

  672ff6cff80c ("KVM: x86: Raise #GP when guest vCPU do not support PMU")

my AMD guests started #GPing like this:

  general protection fault: 0000 [#1] PREEMPT SMP
  CPU: 1 PID: 4355 Comm: bash Not tainted 5.1.0-rc6+ #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  RIP: 0010:x86_perf_event_update+0x3b/0xa0

with Code: pointing to RDPMC. It is RDPMC because the guest has the
hardware watchdog CONFIG_HARDLOCKUP_DETECTOR_PERF enabled which uses
perf. Instrumenting kvm_pmu_rdpmc() some, showed that it fails due to:

  if (!pmu->version)
  	return 1;

which the above commit added. Since AMD's PMU leaves the version at 0,
that causes the #GP injection into the guest.

Set pmu->version arbitrarily to 1 and move it above the non-applicable
struct kvm_pmu members.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: kvm@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
---
 arch/x86/kvm/pmu_amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 1495a735b38e..50fa9450fcf1 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -269,10 +269,10 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
-	pmu->version = 0;
 	pmu->global_status = 0;
 }
 
-- 
2.21.0

