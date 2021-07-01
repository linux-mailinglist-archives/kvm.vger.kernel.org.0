Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60C43B942F
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 17:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhGAPnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:43:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51998 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbhGAPnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:43:42 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D7FB021C73;
        Thu,  1 Jul 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20iVhRkgvk7R55d8QRN7JiSBSHg1fFPl28ZXdD64E5I=;
        b=nqFW6MET9/FBOStxUz0qTUdgV2ZP7kSbZQ0KCLji03HNA64JnBHyJL+TBon5RgiRKfQtm9
        x4gZ1ndgpbenV1xf+wmyzkFA29Wz3O7N/X7o689zDbxwepJu5SsD3L51VNJEY+vcvM8VDY
        as4O1VFzEA4mSnr5jdekClrYoHnxV58=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 56FA811CD5;
        Thu,  1 Jul 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20iVhRkgvk7R55d8QRN7JiSBSHg1fFPl28ZXdD64E5I=;
        b=nqFW6MET9/FBOStxUz0qTUdgV2ZP7kSbZQ0KCLji03HNA64JnBHyJL+TBon5RgiRKfQtm9
        x4gZ1ndgpbenV1xf+wmyzkFA29Wz3O7N/X7o689zDbxwepJu5SsD3L51VNJEY+vcvM8VDY
        as4O1VFzEA4mSnr5jdekClrYoHnxV58=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id SGobFBbi3WAOFwAALh3uQQ
        (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:10 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5/6] kvm: allocate vcpu pointer array separately
Date:   Thu,  1 Jul 2021 17:41:04 +0200
Message-Id: <20210701154105.23215-6-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare support of very large vcpu numbers per guest by moving the
vcpu pointer array out of struct kvm.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/arm64/kvm/arm.c            | 28 ++++++++++++++++++++++++----
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/x86.c              | 19 +++++++++++++++++++
 include/linux/kvm_host.h        | 17 +++++++++++++++--
 4 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e720148232a0..4f055408fe9f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -280,18 +280,38 @@ long kvm_arch_dev_ioctl(struct file *filp,
 
 struct kvm *kvm_arch_alloc_vm(void)
 {
+	struct kvm *kvm;
+
 	if (!has_vhe())
-		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+		kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	else
+		kvm = vzalloc(sizeof(struct kvm));
 
-	return vzalloc(sizeof(struct kvm));
+	if (!kvm)
+		return NULL;
+
+	if (!has_vhe())
+		kvm->vcpus = kcalloc(KVM_MAX_VCPUS, sizeof(void *), GFP_KERNEL);
+	else
+		kvm->vcpus = vzalloc(KVM_MAX_VCPUS * sizeof(void *));
+
+	if (!kvm->vcpus) {
+		kvm_arch_free_vm(kvm);
+		kvm = NULL;
+	}
+
+	return kvm;
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
 {
-	if (!has_vhe())
+	if (!has_vhe()) {
+		kfree(kvm->vcpus);
 		kfree(kvm);
-	else
+	} else {
+		vfree(kvm->vcpus);
 		vfree(kvm);
+	}
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79138c91f83d..39cbc4b6bffb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1440,10 +1440,7 @@ static inline void kvm_ops_static_call_update(void)
 }
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
-static inline struct kvm *kvm_arch_alloc_vm(void)
-{
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-}
+struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3af398ef1fc9..a9b0bb2221ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10741,9 +10741,28 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
+struct kvm *kvm_arch_alloc_vm(void)
+{
+	struct kvm *kvm;
+
+	kvm = __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!kvm)
+		return NULL;
+
+	kvm->vcpus = __vmalloc(KVM_MAX_VCPUS * sizeof(void *),
+			       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!kvm->vcpus) {
+		vfree(kvm);
+		kvm = NULL;
+	}
+
+	return kvm;
+}
+
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 	kfree(to_kvm_hv(kvm)->hv_pa_pg);
+	vfree(kvm->vcpus);
 	vfree(kvm);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8583ed3ff344..e424ef1078a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -525,7 +525,7 @@ struct kvm {
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct kvm_vcpu **vcpus;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
@@ -1022,11 +1022,24 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm);
  */
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+
+	if (!kvm)
+		return NULL;
+
+	kvm->vcpus = kcalloc(KVM_MAX_VCPUS, sizeof(void *), GFP_KERNEL);
+	if (!kvm->vcpus) {
+		kfree(kvm);
+		kvm = NULL;
+	}
+
+	return kvm;
 }
 
 static inline void kvm_arch_free_vm(struct kvm *kvm)
 {
+	if (kvm)
+		kfree(kvm->vcpus);
 	kfree(kvm);
 }
 #endif
-- 
2.26.2

