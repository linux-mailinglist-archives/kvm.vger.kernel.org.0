Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B871923CF02
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgHETL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729250AbgHESaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C7B230FF;
        Wed,  5 Aug 2020 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652031;
        bh=+La9Q4eY0rPcjTlQyZQYOR9azky57a4bBmE93pWcyX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlXdRpcs48t59SHxb4RDRmvkZqF5v8kOKSjqZKr94qPDHHHBpJgtKKkU/SinWYj0I
         UvDtbKWy5Qmq0rcTW6KZWRMblLMVBu2XksYzUzgrm65zdASnSfpzKPsUjesMIK3zJF
         SqHqZnGInNM+EANc8t6eCOMwzoGn3x7gND9JxqIU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Ng1-0004w9-29; Wed, 05 Aug 2020 18:58:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 52/56] KVM: arm: Add trace name for ARM_NISV
Date:   Wed,  5 Aug 2020 18:56:56 +0100
Message-Id: <20200805175700.62775-53-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Graf <graf@amazon.com>

Commit c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts
to userspace") introduced a mechanism to deflect MMIO traffic the kernel
can not handle to user space. For that, it introduced a new exit reason.

However, it did not update the trace point array that gives human readable
names to these exit reasons inside the trace log.

Let's fix that up after the fact, so that trace logs are pretty even when
we get user space MMIO traps on ARM.

Fixes: c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts to userspace")
Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200730094441.18231-1-graf@amazon.com
---
 include/trace/events/kvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 2c735a3e6613..9417a34aad08 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -17,7 +17,7 @@
 	ERSN(NMI), ERSN(INTERNAL_ERROR), ERSN(OSI), ERSN(PAPR_HCALL),	\
 	ERSN(S390_UCONTROL), ERSN(WATCHDOG), ERSN(S390_TSCH), ERSN(EPR),\
 	ERSN(SYSTEM_EVENT), ERSN(S390_STSI), ERSN(IOAPIC_EOI),          \
-	ERSN(HYPERV)
+	ERSN(HYPERV), ERSN(ARM_NISV)
 
 TRACE_EVENT(kvm_userspace_exit,
 	    TP_PROTO(__u32 reason, int errno),
-- 
2.27.0

