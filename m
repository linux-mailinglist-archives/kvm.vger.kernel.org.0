Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9379B5A03E9
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 00:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiHXWZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiHXWZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 18:25:33 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520FE66105
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:25:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v4so16212824pgi.10
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=qiO4ppR0T8BP0+C3qIBhC5C9nbxN/Jb16A7FZnxBJK8=;
        b=n8ebhRfmV7w8m+N14bzabc1U8Q2dZYqaTiY5bBvktt2WetO+N8zs0ZFgyEmHogbQg7
         PhogcQxRJ5maeKPNpcReR0Z01c4YTwopu7UtCkEXzGLtoAr5yJ6j13ga1V0RGpw3N2a+
         e6SAvjX+GhCz4Bf29qHKByJwiIuNULbHVygmCygVocFemoGRfS7J20xF9F04oD1q0hZ7
         5yh2sXq79plrZ8y+p/qsvhmppMBhk/QLP53vA22QdlpfEiDwH1P3W5HaE7Fi3QmZgWZ4
         KCnlWFCnXM5FtxbOVZZb74rMlcn9c8+u5d2MOioA8boJPDsAwQ+fSr0cycGpnWJ0mdqN
         bNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qiO4ppR0T8BP0+C3qIBhC5C9nbxN/Jb16A7FZnxBJK8=;
        b=4bmstO3mvb2i7juD6BjytvyYGl0USfyLu+J6VBrmi9mYgPWdX+s0Hp5G8AN9ArjQJE
         JpmHIxfspMTargwutiP25RBKYgMA/Xz4bNirXJY0VCebm7JjhXFoXr+w5o3/xKG9Q4fr
         zq1MNCqgjLo9XRnYGOGc6UC5WVfoU7TnS1D2nJZtUtGY9pjVvmKf65otAh8joYeZFrOm
         7gjMbdq1yNhfPbz+wQ0k/OeXh5R3JAqHx0chFEDQTrpkeQuckBv8lYgJWvXRsQvPMvFo
         Zw1QdZR4HIpyQ7nz2M/b19ZK9DX/Wcfuni3dgoRFUa5/aycFa7L5PAPZXduMyojbAnBF
         e5Uw==
X-Gm-Message-State: ACgBeo0MZu6l4e4xm7R3yc4zOIAHeBWqFIDRMP5wSscwLOyv4XYppQNK
        SLdUj2//+uviJTpY/9hCep7vmg==
X-Google-Smtp-Source: AA6agR5nbWCZWOrhJIOYmflUtFmVApPFjLX2pDGDgrqrjv5V2LC99ew+kBuVcPLXgZvTrNBmvUiU/Q==
X-Received: by 2002:a63:1e5f:0:b0:419:d6bf:b9d7 with SMTP id p31-20020a631e5f000000b00419d6bfb9d7mr789552pgm.593.1661379930521;
        Wed, 24 Aug 2022 15:25:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij19-20020a170902ab5300b0016c50179b1esm13088867plb.152.2022.08.24.15.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 15:25:30 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:25:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 08/13] KVM: x86: emulator/smm: use smram structs in
 the common code
Message-ID: <YwalVvBbfL1u3H8b@google.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
 <20220803155011.43721-9-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803155011.43721-9-mlevitsk@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> Switch from using a raw array to 'union kvm_smram'.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 +++--
>  arch/x86/kvm/emulate.c          | 12 +++++++-----
>  arch/x86/kvm/kvm_emulate.h      |  3 ++-
>  arch/x86/kvm/svm/svm.c          |  8 ++++++--
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  arch/x86/kvm/x86.c              | 16 ++++++++--------
>  6 files changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e8281d64a4315a..d752fabde94ad2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -204,6 +204,7 @@ typedef enum exit_fastpath_completion fastpath_t;
>  
>  struct x86_emulate_ctxt;
>  struct x86_exception;
> +union kvm_smram;
>  enum x86_intercept;
>  enum x86_intercept_stage;
>  
> @@ -1600,8 +1601,8 @@ struct kvm_x86_ops {
>  	void (*setup_mce)(struct kvm_vcpu *vcpu);
>  
>  	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
> -	int (*enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
> -	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
> +	int (*enter_smm)(struct kvm_vcpu *vcpu, union kvm_smram *smram);
> +	int (*leave_smm)(struct kvm_vcpu *vcpu, const union kvm_smram *smram);
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>  
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 55d9328e6074a2..610978d00b52b0 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2594,16 +2594,18 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>  static int em_rsm(struct x86_emulate_ctxt *ctxt)
>  {
>  	unsigned long cr0, cr4, efer;
> -	char buf[512];
> +	const union kvm_smram smram;

This is blatantly wrong, ctxt->ops->read_phys() writes to the buffer.  I assume
you did this to make it more difficult to modify the buffer after reading from
guest memory, but IMO that's not worth misleading readers.

>  	u64 smbase;
>  	int ret;
>  
> +	BUILD_BUG_ON(sizeof(smram) != 512);
> +
>  	if ((ctxt->ops->get_hflags(ctxt) & X86EMUL_SMM_MASK) == 0)
>  		return emulate_ud(ctxt);
>  
>  	smbase = ctxt->ops->get_smbase(ctxt);
>  
> -	ret = ctxt->ops->read_phys(ctxt, smbase + 0xfe00, buf, sizeof(buf));
> +	ret = ctxt->ops->read_phys(ctxt, smbase + 0xfe00, (void *)&smram, sizeof(smram));

The point of the union + bytes is so that KVM doesn't have to cast.

	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00,
			     smram.bytes, sizeof(smram));

>  	if (ret != X86EMUL_CONTINUE)
>  		return X86EMUL_UNHANDLEABLE;
>  
> @@ -2653,15 +2655,15 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
>  	 * state (e.g. enter guest mode) before loading state from the SMM
>  	 * state-save area.
>  	 */
> -	if (ctxt->ops->leave_smm(ctxt, buf))
> +	if (ctxt->ops->leave_smm(ctxt, &smram))
>  		goto emulate_shutdown;
>  
>  #ifdef CONFIG_X86_64
>  	if (emulator_has_longmode(ctxt))
> -		ret = rsm_load_state_64(ctxt, buf);
> +		ret = rsm_load_state_64(ctxt, (const char *)&smram);
>  	else
>  #endif
> -		ret = rsm_load_state_32(ctxt, buf);
> +		ret = rsm_load_state_32(ctxt, (const char *)&smram);

Same thing here, though this is temporary.  And it's kinda silly, but I think it
makes sense to avoid the cast here by tweaking the rsm_load_state_*() helpers to
take "u8 *" instead of "char *".

>  	if (ret != X86EMUL_CONTINUE)
>  		goto emulate_shutdown;

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 38f873cb6f2c14..688315d1dfabd1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4433,12 +4433,14 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  	return 1;
>  }
>  
> -static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
> +static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_host_map map_save;
>  	int ret;
>  
> +	char *smstate = (char *)smram;

Again temporary, but since this is new code, just make it

	u8 *smstate = smram->bytes;

> +
>  	if (!is_guest_mode(vcpu))
>  		return 0;
>  
> @@ -4480,7 +4482,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  	return 0;
>  }
>  
> -static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> +static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_host_map map, map_save;
> @@ -4488,6 +4490,8 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  	struct vmcb *vmcb12;
>  	int ret;
>  
> +	const char *smstate = (const char *)smram;
> +

And here.

>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
>  		return 0;
>  

E.g. this compiles cleanly on top

---
 arch/x86/kvm/emulate.c | 17 +++++++++--------
 arch/x86/kvm/svm/svm.c |  4 ++--
 arch/x86/kvm/x86.c     |  7 ++++---
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index dd0a08af1dd9..b2ef63cf6cff 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2357,7 +2357,7 @@ static void rsm_set_desc_flags(struct desc_struct *desc, u32 flags)
 	desc->type = (flags >>  8) & 15;
 }

-static int rsm_load_seg_32(struct x86_emulate_ctxt *ctxt, const char *smstate,
+static int rsm_load_seg_32(struct x86_emulate_ctxt *ctxt, const u8 *smstate,
 			   int n)
 {
 	struct desc_struct desc;
@@ -2379,7 +2379,7 @@ static int rsm_load_seg_32(struct x86_emulate_ctxt *ctxt, const char *smstate,
 }

 #ifdef CONFIG_X86_64
-static int rsm_load_seg_64(struct x86_emulate_ctxt *ctxt, const char *smstate,
+static int rsm_load_seg_64(struct x86_emulate_ctxt *ctxt, const u8 *smstate,
 			   int n)
 {
 	struct desc_struct desc;
@@ -2446,7 +2446,7 @@ static int rsm_enter_protected_mode(struct x86_emulate_ctxt *ctxt,
 }

 static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
-			     const char *smstate)
+			     const u8 *smstate)
 {
 	struct desc_struct desc;
 	struct desc_ptr dt;
@@ -2507,7 +2507,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,

 #ifdef CONFIG_X86_64
 static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
-			     const char *smstate)
+			     const u8 *smstate)
 {
 	struct desc_struct desc;
 	struct desc_ptr dt;
@@ -2580,7 +2580,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 static int em_rsm(struct x86_emulate_ctxt *ctxt)
 {
 	unsigned long cr0, cr4, efer;
-	const union kvm_smram smram;
+	union kvm_smram smram;
 	u64 smbase;
 	int ret;

@@ -2591,7 +2591,8 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)

 	smbase = ctxt->ops->get_smbase(ctxt);

-	ret = ctxt->ops->read_phys(ctxt, smbase + 0xfe00, (void *)&smram, sizeof(smram));
+	ret = ctxt->ops->read_phys(ctxt, smbase + 0xfe00,
+				   smram.bytes, sizeof(smram));
 	if (ret != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;

@@ -2646,10 +2647,10 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)

 #ifdef CONFIG_X86_64
 	if (emulator_has_longmode(ctxt))
-		ret = rsm_load_state_64(ctxt, (const char *)&smram);
+		ret = rsm_load_state_64(ctxt, smram.bytes);
 	else
 #endif
-		ret = rsm_load_state_32(ctxt, (const char *)&smram);
+		ret = rsm_load_state_32(ctxt, smram.bytes);

 	if (ret != X86EMUL_CONTINUE)
 		goto emulate_shutdown;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5d748b10c5be..ecf11c8a052e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4439,7 +4439,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	struct kvm_host_map map_save;
 	int ret;

-	char *smstate = (char *)smram;
+	u8 *smstate = smram->bytes;

 	if (!is_guest_mode(vcpu))
 		return 0;
@@ -4490,7 +4490,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	struct vmcb *vmcb12;
 	int ret;

-	const char *smstate = (const char *)smram;
+	const char *smstate = smram->bytes;

 	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
 		return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca558674b07b..09268c2335a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9985,10 +9985,10 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	memset(smram.bytes, 0, sizeof(smram.bytes));
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		enter_smm_save_state_64(vcpu, (char *)&smram);
+		enter_smm_save_state_64(vcpu, smram.bytes);
 	else
 #endif
-		enter_smm_save_state_32(vcpu, (char *)&smram);
+		enter_smm_save_state_32(vcpu, smram.bytes);

 	/*
 	 * Give enter_smm() a chance to make ISA-specific changes to the vCPU
@@ -9998,7 +9998,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_enter_smm)(vcpu, &smram);

 	kvm_smm_changed(vcpu, true);
-	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram));
+	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00,
+			     smram.bytes, sizeof(smram));

 	if (static_call(kvm_x86_get_nmi_mask)(vcpu))
 		vcpu->arch.hflags |= HF_SMM_INSIDE_NMI_MASK;

base-commit: 0708faef18ff51a2b2dba546961d843223331138
--

