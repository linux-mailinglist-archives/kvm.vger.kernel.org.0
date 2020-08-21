Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F6B24D341
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 12:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgHUKx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 06:53:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726975AbgHUKwi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 06:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598007155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m+sWpLL8B15YiBoZkjZFY9ODFpvPLxIevI4EtwVXHWs=;
        b=El0qSMCJGzsYDAaoaZMJq8enBQysbCREZe9LIdwAow3Yyskwb2ZnpSP892PQcb0mX6fVEo
        LyTFs3+BCcjbt0S3ZMQ+OdfZ3k0rtQbBhyRVtTzWL+6IOTiiVkgGVwrvTTBok6dCAph6wm
        3Zq2sfuCJdM2XFoos1fCSwKPw12BdcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-Arr460QEMU-dEeMrVD4xNw-1; Fri, 21 Aug 2020 06:52:33 -0400
X-MC-Unique: Arr460QEMU-dEeMrVD4xNw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B9761885D89;
        Fri, 21 Aug 2020 10:52:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 397977C533;
        Fri, 21 Aug 2020 10:52:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2] x86/entry/64: Do not use RDPID in paranoid entry to accomodate KVM
Date:   Fri, 21 Aug 2020 06:52:29 -0400
Message-Id: <20200821105229.18938-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Don't use RDPID in the paranoid entry flow, as it can consume a KVM
guest's MSR_TSC_AUX value if an NMI arrives during KVM's run loop.

In general, the kernel does not need TSC_AUX because it can just use
__this_cpu_read(cpu_number) to read the current processor id.  It can
also just block preemption and thread migration at its will, therefore
it has no need for the atomic rdtsc+vgetcpu provided by RDTSCP.  For this
reason, as a performance optimization, KVM loads the guest's TSC_AUX when
a CPU first enters its run loop.  On AMD's SVM, it doesn't restore the
host's value until the CPU exits the run loop; VMX is even more aggressive
and defers restoring the host's value until the CPU returns to userspace.

This optimization obviously relies on the kernel not consuming TSC_AUX,
which falls apart if an NMI arrives during the run loop and uses RDPID.
Removing it would be painful, as both SVM and VMX would need to context
switch the MSR on every VM-Enter (for a cost of 2x WRMSR), whereas using
LSL instead RDPID is a minor blip.

Both SAVE_AND_SET_GSBASE and GET_PERCPU_BASE are only used in paranoid entry,
therefore the patch can just remove the RDPID alternative.

Fixes: eaad981291ee3 ("x86/entry/64: Introduce the FIND_PERCPU_BASE macro")
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Chang Seok Bae <chang.seok.bae@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Debugged-by: Tom Lendacky <thomas.lendacky@amd.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/entry/calling.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 98e4d8886f11..ae9b0d4615b3 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -374,12 +374,14 @@ For 32-bit we have the following conventions - kernel is built with
  * Fetch the per-CPU GSBASE value for this processor and put it in @reg.
  * We normally use %gs for accessing per-CPU data, but we are setting up
  * %gs here and obviously can not use %gs itself to access per-CPU data.
+ *
+ * Do not use RDPID, because KVM loads guest's TSC_AUX on vm-entry and
+ * may not restore the host's value until the CPU returns to userspace.
+ * Thus the kernel would consume a guest's TSC_AUX if an NMI arrives
+ * while running KVM's run loop.
  */
 .macro GET_PERCPU_BASE reg:req
-	ALTERNATIVE \
-		"LOAD_CPU_AND_NODE_SEG_LIMIT \reg", \
-		"RDPID	\reg", \
-		X86_FEATURE_RDPID
+	LOAD_CPU_AND_NODE_SEG_LIMIT \reg
 	andq	$VDSO_CPUNODE_MASK, \reg
 	movq	__per_cpu_offset(, \reg, 8), \reg
 .endm
-- 
2.26.2

