Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05BB400035
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349466AbhICNJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 09:09:33 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43210 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349434AbhICNJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 09:09:30 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 037C11FD88;
        Fri,  3 Sep 2021 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630674509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYBAeJZ/jt0gKsW8sstxDlF07qX0fOSGC+9QZTZ20e0=;
        b=Fk7784k4btp/8V70SaI0iDfzk5vtAKnClPvggrNn9pWx2neT3VOma8ioBe8Rt+GWVBIRcr
        caxdOnEd5dt/G9EZKCOgzCHgzYs4WyjSRQXmiC7Rgj28X9VCwdRdiHjn4aeb//Wf3otPbe
        iCB/I4lAiPDDChf/M5lnqFnJ0FpPfWA=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 4F2A4137D4;
        Fri,  3 Sep 2021 13:08:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id eD3FEUweMmHYOAAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 13:08:28 +0000
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
Subject: [PATCH v2 4/6] kvm: use kvfree() in kvm_arch_free_vm()
Date:   Fri,  3 Sep 2021 15:08:05 +0200
Message-Id: <20210903130808.30142-5-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210903130808.30142-1-jgross@suse.com>
References: <20210903130808.30142-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By switching from kfree() to kvfree() in kvm_arch_free_vm() Arm64 can
use the common variant. This can be accomplished by adding another
macro __KVM_HAVE_ARCH_VM_FREE, which will be used only by x86 for now.

Further simplification can be achieved by adding __kvm_arch_free_vm()
doing the common part.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- new patch
---
 arch/arm64/include/asm/kvm_host.h | 1 -
 arch/arm64/kvm/arm.c              | 8 --------
 arch/x86/include/asm/kvm_host.h   | 2 ++
 arch/x86/kvm/x86.c                | 2 +-
 include/linux/kvm_host.h          | 9 ++++++++-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..39601fb87e69 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -767,7 +767,6 @@ int kvm_set_ipa_limit(void);
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
-void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0ca72f5cda41..38fff5963d9f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -299,14 +299,6 @@ struct kvm *kvm_arch_alloc_vm(void)
 	return vzalloc(sizeof(struct kvm));
 }
 
-void kvm_arch_free_vm(struct kvm *kvm)
-{
-	if (!has_vhe())
-		kfree(kvm);
-	else
-		vfree(kvm);
-}
-
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a809a9e4fa5c..f16fadfc030a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1521,6 +1521,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 {
 	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
+
+#define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd19b72a5733..cc552763f0e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11129,7 +11129,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 	kfree(to_kvm_hv(kvm)->hv_pa_pg);
-	vfree(kvm);
+	__kvm_arch_free_vm(kvm);
 }
 
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..d75e9c2a00b1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1044,10 +1044,17 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 {
 	return kzalloc(sizeof(struct kvm), GFP_KERNEL);
 }
+#endif
+
+static inline void __kvm_arch_free_vm(struct kvm *kvm)
+{
+	kvfree(kvm);
+}
 
+#ifndef __KVM_HAVE_ARCH_VM_FREE
 static inline void kvm_arch_free_vm(struct kvm *kvm)
 {
-	kfree(kvm);
+	__kvm_arch_free_vm(kvm);
 }
 #endif
 
-- 
2.26.2

