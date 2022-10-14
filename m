Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211285FF501
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJNVGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJNVGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:06:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDD71CCCD2
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:06:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so5882727pjl.0
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gBsIgMFkR4hW6DkbKUL3jsquGqWZiZYs8XXLe7DQw4A=;
        b=EZEnHyPWVM20eYK0drT8VKRVFesb8BxKsJzc0N+c8Wa34hBYJ9Q6wgFLIdZOwP2E2A
         snZ8B9uD5ZMLmdIeDQTPBg5PfNB4eBY2/6kO+U06aK1ADIhjSOZUjL1tOQoN/z2a7Kun
         WjJsTnYEQLDEx7jASlQs0iLsRJ2AIE2dVwfgPgoxt4krLRyaIs6K5r1V0XDInXNPdJmG
         jrRPrXsfD+0AUNroc6Ysr03801gaTAC7fZuMbfHuID6fMhC4bphXtGYn5aGZlqD0ViXp
         fLfvaZUXPywdh4phfAmRqFHubAUgEvH+UGdKgvBBBWHEcOYKY2L0o0bu+NREHGB4zAsm
         6dzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBsIgMFkR4hW6DkbKUL3jsquGqWZiZYs8XXLe7DQw4A=;
        b=6AEJEjG3AO5w9XMsbz8NIgES212qdD4SQKe1eUVfCPVwC+33luJZMqNl17M2ur/yM9
         TFglduX0Eq+dTENJlg/H2UTPuyn6+xX/v6imYkcd1j5aKu9GpTTTTWL4P490/AK8ihJ0
         D68zWu7loOXtDzKkJyDT+bR77xe71CFTziDdHcewS7oK9B3ph3qt0Kbv3OJRMP10NT39
         yU46zReduMLgQJlQFE+c2ycVn9OCRZLBIuw2VlOSauDbzZ69OXyJOzbg5CW4hhRmOVrG
         4s8PnyvbcpJlWXTC5AyVO3uKQgKhKlSceyG2A01zc20xNsT9lj6MUw3OL1sz1aAgUlt/
         cHkg==
X-Gm-Message-State: ACrzQf3UaJCeW7sd2O6xcbjmID+6d3mcodPyyxuJDOijq3AQ/iuI0rYb
        NGZUWOu2Zz2lFx7V6pPs+Ehjiw==
X-Google-Smtp-Source: AMsMyM4TRUGumiH9zPUpVbD+pbo9y8PKyNt58Hq6N9oJ6PlfFsmKD5LHpHH6bXmjSd0NXZc8ax2ong==
X-Received: by 2002:a17:902:d48e:b0:178:b5d:ab3 with SMTP id c14-20020a170902d48e00b001780b5d0ab3mr6947676plg.22.1665781602184;
        Fri, 14 Oct 2022 14:06:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i18-20020a63e912000000b0045724d09cb4sm1835259pgh.29.2022.10.14.14.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:06:41 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:06:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        maciej.szmigiero@oracle.com
Subject: Re: [PATCH v2 8/8] KVM: x86: do not define KVM_REQ_SMI if SMM
 disabled
Message-ID: <Y0nPXfVT1pUaGppn@google.com>
References: <20220929172016.319443-1-pbonzini@redhat.com>
 <20220929172016.319443-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929172016.319443-9-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

	On Thu, Sep 29, 2022, Paolo Bonzini wrote:
> This ensures that all the relevant code is compiled out, in fact
> the process_smi stub can be removed too.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/smm.h              | 1 -
>  arch/x86/kvm/x86.c              | 6 ++++++
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d11697504471..d58d4a62b227 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -81,7 +81,9 @@
>  #define KVM_REQ_NMI			KVM_ARCH_REQ(9)
>  #define KVM_REQ_PMU			KVM_ARCH_REQ(10)
>  #define KVM_REQ_PMI			KVM_ARCH_REQ(11)
> +#ifdef CONFIG_KVM_SMM
>  #define KVM_REQ_SMI			KVM_ARCH_REQ(12)
> +#endif
>  #define KVM_REQ_MASTERCLOCK_UPDATE	KVM_ARCH_REQ(13)
>  #define KVM_REQ_MCLOCK_INPROGRESS \
>  	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index 7ccce6b655ca..a6795b93ba30 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -28,7 +28,6 @@ void process_smi(struct kvm_vcpu *vcpu);
>  static inline int kvm_inject_smi(struct kvm_vcpu *vcpu) { return -ENOTTY; }
>  static inline bool is_smm(struct kvm_vcpu *vcpu) { return false; }
>  static inline void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm) { WARN_ON_ONCE(1); }
> -static inline void process_smi(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }

I think it's worth adding one more patch to kill off kvm_smm_changed() too.  Most
of the affected code already has references to CONFIG_KVM_SMM nearby.

---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/smm.c              |  4 ++++
 arch/x86/kvm/smm.h              |  2 --
 arch/x86/kvm/x86.c              | 18 +++++++++---------
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0b0a82c0bb5c..6c572cf1cf8d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1994,10 +1994,11 @@ enum {
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
+
+#ifdef CONFIG_KVM_SMM
 #define HF_SMM_MASK		(1 << 6)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
 
-#ifdef CONFIG_KVM_SMM
 # define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 # define KVM_ADDRESS_SPACE_NUM 2
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 740fca1cf3a3..12480446c43b 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -10,6 +10,10 @@
 
 void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 {
+	BUILD_BUG_ON(HF_GUEST_MASK != X86EMUL_GUEST_MASK);
+	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
+	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
+
 	trace_kvm_smm_transition(vcpu->vcpu_id, vcpu->arch.smbase, entering_smm);
 
 	if (entering_smm) {
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index 131fbe1817d5..9935045fcf20 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -29,8 +29,6 @@ void process_smi(struct kvm_vcpu *vcpu);
 #else
 static inline int kvm_inject_smi(struct kvm_vcpu *vcpu) { return -ENOTTY; }
 static inline bool is_smm(struct kvm_vcpu *vcpu) { return false; }
-static inline void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm) { WARN_ON_ONCE(1); }
-
 /*
  * emulator_leave_smm is used as a function pointer, so the
  * stub is defined in x86.c.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 56004890a717..ec74d579ca1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5103,10 +5103,12 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 
 	events->sipi_vector = 0; /* never valid when reporting to user space */
 
+#ifdef CONFIG_KVM_SMM
 	events->smi.smm = is_smm(vcpu);
 	events->smi.pending = vcpu->arch.smi_pending;
 	events->smi.smm_inside_nmi =
 		!!(vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK);
+#endif
 	events->smi.latched_init = kvm_lapic_latched_init(vcpu);
 
 	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
@@ -5194,12 +5196,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.apic->sipi_vector = events->sipi_vector;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
-		if (!IS_ENABLED(CONFIG_KVM_SMM) &&
-		    (events->smi.smm ||
-		     events->smi.pending ||
-		     events->smi.smm_inside_nmi))
-			return -EINVAL;
-
+#ifdef CONFIG_KVM_SMM
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
 			kvm_x86_ops.nested_ops->leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
@@ -5214,6 +5211,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 				vcpu->arch.hflags &= ~HF_SMM_INSIDE_NMI_MASK;
 		}
 
+#else
+		if (events->smi.smm || events->smi.pending ||
+		    events->smi.smm_inside_nmi)
+			return -EINVAL;
+#endif
+
 		if (lapic_in_kernel(vcpu)) {
 			if (events->smi.latched_init)
 				set_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
@@ -8228,9 +8231,6 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 		     (cs_l && is_long_mode(vcpu))	? X86EMUL_MODE_PROT64 :
 		     cs_db				? X86EMUL_MODE_PROT32 :
 							  X86EMUL_MODE_PROT16;
-	BUILD_BUG_ON(HF_GUEST_MASK != X86EMUL_GUEST_MASK);
-	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
-	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
 
 	ctxt->interruptibility = 0;
 	ctxt->have_exception = false;

base-commit: f7641bcac507589d34b20d30cceb7067f8bcfd08
-- 

