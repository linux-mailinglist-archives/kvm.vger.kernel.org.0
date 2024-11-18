Return-Path: <kvm+bounces-32009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE8A9D10CF
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:43:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F3E8283B0C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA75F1A9B52;
	Mon, 18 Nov 2024 12:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="QBMliTE2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84280176ADE;
	Mon, 18 Nov 2024 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933685; cv=none; b=ATKSafOHG6nWZH3U9wERJlJ9AZMQ8jqHGn91zyKac+Yhis+5aYGAa6OTW45m8Fx1r0tys6+4Qfj2fR7gCMpngAXTHj5ba6nO5WA4JiYR7o1mWYOCqLxnsT90ibzUqvpHUFL5QPyP2OHVFHAmYLgG17ywiMhMTzbB4yBkF1SdFuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933685; c=relaxed/simple;
	bh=Gvz8uazVE8B1pvZ+y+usnmLv8rqzH5i23ETEexpJWsI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RnJpYNSab4MGxBWLkB16eJ7gyToKN2UhADDsLl3oy+pACoHEeDOrBmqYBiVMt/8OZg/uOn5/iSfcZJBwEtpcjjTj+hcK4B93D1ogQ0Zer20dMIDi3pgEhS7kvIy0L/KQogrk4ipMnCg43MRBi0NnRKUeZDaX/8N0sy5zbVlvwDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=QBMliTE2; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731933684; x=1763469684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OnUiGqwydGwkm0msPhftvhu6OlRE3sxag6FK0PEhEvs=;
  b=QBMliTE2TDw9KznxDNfzyuh8WEGoYIqxe0LZYUvwI55gZ9y98KlPZpNR
   SuXMIL0ycEpOTMYoUEOIMn0pvTdoZAHH/1XO3lm/LJ3O/P98Z0ymOk48h
   W9P3UWPCjSJDlV/DQYty07M3SBL7VyUYoRf60DcPsS2cpp+SS6cztQqjJ
   U=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="776563783"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 12:41:23 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:50740]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.2:2525] with esmtp (Farcaster)
 id 88669b73-3dba-495e-891e-bea667cdf808; Mon, 18 Nov 2024 12:41:22 +0000 (UTC)
X-Farcaster-Flow-ID: 88669b73-3dba-495e-891e-bea667cdf808
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:41:15 +0000
Received: from EX19MTAUEB002.ant.amazon.com (10.252.135.47) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:41:14 +0000
Received: from email-imr-corp-prod-iad-all-1b-a03c1db8.us-east-1.amazon.com
 (10.124.125.2) by mail-relay.amazon.com (10.252.135.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 12:41:14 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-iad-all-1b-a03c1db8.us-east-1.amazon.com (Postfix) with ESMTPS id 01B18815FE;
	Mon, 18 Nov 2024 12:41:11 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <corbet@lwn.net>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <david@redhat.com>, <peterx@redhat.com>,
	<oleg@redhat.com>, <vkuznets@redhat.com>, <gshan@redhat.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [RFC PATCH 6/6] KVM: x86: async_pf_user: hook to fault handling and add ioctl
Date: Mon, 18 Nov 2024 12:39:48 +0000
Message-ID: <20241118123948.4796-7-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241118123948.4796-1-kalyazin@amazon.com>
References: <20241118123948.4796-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

This patch adds interception in the __kvm_faultin_pfn for handling
faults that are causing exit to userspace asynchronously.  If the kernel
expects for the userspace to handle the fault asynchronously (ie it can
resume the vCPU while the fault is being processed), it sets the
KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER flag and supplies the async PF token
in the struct memory_fault in the VM exit info.
The patch also adds the KVM_ASYNC_PF_USER_READY ioctl that the userspace
should use to notify the kernel that the fault has been processed by
using the token corresponding to the fault.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c   | 45 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c       | 16 +++++++++++++-
 arch/x86/kvm/x86.h       |  2 ++
 include/uapi/linux/kvm.h |  4 +++-
 4 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index adf0161af894..a2b024ccbbe1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4282,6 +4282,22 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
 				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
 }
 
+static bool kvm_arch_setup_async_pf_user(struct kvm_vcpu *vcpu,
+					struct kvm_page_fault *fault, u32 *token)
+{
+        struct kvm_arch_async_pf arch;
+
+        arch.token = alloc_apf_token(vcpu);
+        arch.gfn = fault->gfn;
+        arch.error_code = fault->error_code;
+        arch.direct_map = vcpu->arch.mmu->root_role.direct;
+        arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
+
+        *token = arch.token;
+
+        return kvm_setup_async_pf_user(vcpu, 0, fault->addr, &arch);
+}
+
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
@@ -4396,6 +4412,35 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	bool async;
 
+	/* Pre-check for userfault and bail out early. */
+	if (gfn_has_userfault(fault->slot->kvm, fault->gfn)) {
+		bool report_async = false;
+		u32 token = 0;
+
+		if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+			!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
+			trace_kvm_try_async_get_page(fault->addr, fault->gfn, 1);
+			if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
+				trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn, 1);
+				kvm_make_request(KVM_REQ_APF_HALT, vcpu);
+				return RET_PF_RETRY;
+			} else if (kvm_can_deliver_async_pf(vcpu) &&
+				kvm_arch_setup_async_pf_user(vcpu, fault, &token)) {
+				report_async = true;
+			}
+		}
+
+		fault->pfn = KVM_PFN_ERR_USERFAULT;
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+
+		if (report_async) {
+			vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER;
+			vcpu->run->memory_fault.async_pf_user_token = token;
+		}
+
+		return -EFAULT;
+	}
+
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b8cd3af326b..30b22904859f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13372,7 +13372,7 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
 	return !val;
 }
 
-static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
+bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 {
 
 	if (!kvm_pv_async_pf_enabled(vcpu))
@@ -13697,6 +13697,20 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
+	void __user *argp = (void __user *)arg;
+	struct kvm_vcpu *vcpu = filp->private_data;
+
+#ifdef CONFIG_KVM_ASYNC_PF_USER
+	if (ioctl == KVM_ASYNC_PF_USER_READY) {
+		struct kvm_async_pf_user_ready apf_ready;
+
+		if (copy_from_user(&apf_ready, argp, sizeof(apf_ready)))
+			return -EFAULT;
+
+		return kvm_async_pf_user_ready(vcpu, &apf_ready);
+	}
+#endif
+
 	return -ENOIOCTLCMD;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d80a4c6b5a38..66ece51ee94b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -325,6 +325,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
+bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu);
+
 extern u64 host_xcr0;
 extern u64 host_xss;
 extern u64 host_arch_capabilities;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ef3840a1c5e9..8aa5ce347bdf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -430,12 +430,14 @@ struct kvm_run {
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 #define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
+#define KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER (1ULL << 5)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
+			__u32 async_pf_user_token;
 		} memory_fault;
 		/* Fix the size of the union. */
-		char padding[256];
+		char padding[252];
 	};
 
 	/* 2048 is the size of the char array used to bound/pad the size
-- 
2.40.1


