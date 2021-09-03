Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789E2400037
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 15:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349463AbhICNJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 09:09:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36554 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349417AbhICNJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 09:09:30 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A5E3E226EF;
        Fri,  3 Sep 2021 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630674509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tdRd8V4DfFLfvS4ckb7uA1RJKO/r/+sN4YgtnHYUSHo=;
        b=HQLpokubMLbTcIZbV8us+hyFFoqyOem0YyDB+HwyRUnwkOOi3DulTHsIbVrrySfpcJ0vnN
        nmah2V7Crihp/qW+u9/K+TZelCzJ2IaEY/kslaLf6QGKSwpYOQVJWxQVZnnCaA5h0o9osp
        X/BtXES2eZuNirPaQMUfbziFS5j9hEA=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0E5B0137D4;
        Fri,  3 Sep 2021 13:08:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id aO4BAk0eMmHYOAAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 13:08:29 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        Juergen Gross <jgross@suse.com>,
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
Subject: [PATCH v2 5/6] kvm: allocate vcpu pointer array separately
Date:   Fri,  3 Sep 2021 15:08:06 +0200
Message-Id: <20210903130808.30142-6-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210903130808.30142-1-jgross@suse.com>
References: <20210903130808.30142-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare support of very large vcpu numbers per guest by moving the
vcpu pointer array out of struct kvm.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- rebase to new kvm_arch_free_vm() implementation
---
 arch/arm64/kvm/arm.c            | 21 +++++++++++++++++++--
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/x86.c              | 18 ++++++++++++++++++
 include/linux/kvm_host.h        | 17 +++++++++++++++--
 4 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38fff5963d9f..8bb5caeba007 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -293,10 +293,27 @@ long kvm_arch_dev_ioctl(struct file *filp,
 
 struct kvm *kvm_arch_alloc_vm(void)
 {
+	struct kvm *kvm;
+
+	if (!has_vhe())
+		kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	else
+		kvm = vzalloc(sizeof(struct kvm));
+
+	if (!kvm)
+		return NULL;
+
 	if (!has_vhe())
-		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+		kvm->vcpus = kcalloc(KVM_MAX_VCPUS, sizeof(void *), GFP_KERNEL);
+	else
+		kvm->vcpus = vzalloc(KVM_MAX_VCPUS * sizeof(void *));
+
+	if (!kvm->vcpus) {
+		kvm_arch_free_vm(kvm);
+		kvm = NULL;
+	}
 
-	return vzalloc(sizeof(struct kvm));
+	return kvm;
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f16fadfc030a..6c28d0800208 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1517,10 +1517,7 @@ static inline void kvm_ops_static_call_update(void)
 }
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
-static inline struct kvm *kvm_arch_alloc_vm(void)
-{
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-}
+struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc552763f0e4..ff142b6dd00c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11126,6 +11126,24 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d75e9c2a00b1..9e2a5f1c6f54 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -536,7 +536,7 @@ struct kvm {
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct kvm_vcpu **vcpus;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
@@ -1042,12 +1042,25 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm);
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
 #endif
 
 static inline void __kvm_arch_free_vm(struct kvm *kvm)
 {
+	if (kvm)
+		kvfree(kvm->vcpus);
 	kvfree(kvm);
 }
 
-- 
2.26.2

