Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7C47AE3E6
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 05:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjIZDBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 23:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjIZDBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 23:01:41 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB13612A;
        Mon, 25 Sep 2023 20:01:33 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-7741b18a06aso462660485a.1;
        Mon, 25 Sep 2023 20:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695697293; x=1696302093; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7aanxsiInJCFfKFMnMZwZLA/BO1udgnu96xf6w1IwgY=;
        b=At14nhubfU4Cem+X+m+khgNMItOnBT80l26yAqmlRrH8a3irBrD8eQfp5N/wDc1FjL
         1LFENeXTrvlT5jYPrvuEYZSl5vzlI7uFXUOnjIqUIQPfzZeW5Skb3nQG7oX1OZTg6kV3
         PLFb1d/XUT+cGpgzuiQghcHeikC73CS4azbNY0nB9sRk+q4svde6ndjwLjMCklTQQxB5
         WO7rRwUjboQfx7EvZzBtO28nWPkvO0SdsN5EoSs/ngqZoHvCoNb1yuQnh5AvRekyxTOj
         k2q8jqwtG+6RZpwdqtfW5XCtn1uGHNb5siUexRI2xKYabSu5KlcT4saZHLmUbjQt2M2t
         w8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695697293; x=1696302093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7aanxsiInJCFfKFMnMZwZLA/BO1udgnu96xf6w1IwgY=;
        b=jIObMXOwt+rjHyFhPBM96gn9IAWNySD+Wo0s+4C8cV5gg3nqwZ2mcV2qQgOwpgyZvW
         38CwxI1Tk+BlZIKDZWykDNPyesDdh49BlKSxl+bXLNJkWJHYiNVTRIFHwoDQPW3hnGoZ
         KNqYTK1HMEs35GyrWD01Qmuh19KpculvKqUTjYq4hYWwIUmUwAxIVICOirn7QrufcJOX
         J68edpCTKPnMU9vriXKaFrHBWsSw9kDWtwFdPb2ELe4w6p6hHRtmPL9WOpMYfLXqBVpN
         1DehPgPQf72YiTwdHBI30lVi8BTn6kSAAR6NtJ2FkRiP/1FNpzRQYieaYIeqvwLbPSeq
         oC0g==
X-Gm-Message-State: AOJu0YwluZTbsQNQbThs2Os9ucR2sWVAcBVjIdUdkx6WsxO8gfv479LD
        TEeq0v7HSVTlGuPDC8vn1Z4=
X-Google-Smtp-Source: AGHT+IGIEgKcG7JTgF88jl/x37NrfHR2dV1clwUwKPWu+sY9LbDS4NN0ov3k+gz2YItOA6aAFIRyLA==
X-Received: by 2002:ae9:e918:0:b0:774:1e8f:222d with SMTP id x24-20020ae9e918000000b007741e8f222dmr8681543qkf.62.1695697292668;
        Mon, 25 Sep 2023 20:01:32 -0700 (PDT)
Received: from luigi.stachecki.net (pool-108-14-234-238.nycmny.fios.verizon.net. [108.14.234.238])
        by smtp.gmail.com with ESMTPSA id ow10-20020a05620a820a00b0076d9df37949sm4345226qkn.36.2023.09.25.20.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 20:01:32 -0700 (PDT)
Date:   Mon, 25 Sep 2023 23:02:13 -0400
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dgilbert@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZRJJtWC4ch0RhY/Y@luigi.stachecki.net>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com>
 <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
 <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
 <ZQQKoIEgFki0KzxB@redhat.com>
 <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
 <ZRH7F3SlHZEBf1I2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRH7F3SlHZEBf1I2@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 02:26:47PM -0700, Sean Christopherson wrote:
> On Fri, Sep 15, 2023, Tyler Stachecki wrote:
> > On Fri, Sep 15, 2023 at 04:41:20AM -0300, Leonardo Bras wrote:
> > > Other than that, all I can think of is removing the features from guest:
> > > 
> > > As you commented, there may be some features that would not be a problem 
> > > to be removed, and also there may be features which are not used by the 
> > > workload, and could be removed. But this would depend on the feature, and 
> > > the workload, beind a custom solution for every case.
> > 
> > Yes, the "fixup back" should be refined to pointed and verified cases.
> >  
> > > For this (removing guest features), from kernel side, I would suggest using 
> > > SystemTap (and eBPF, IIRC). The procedures should be something like:
> > > - Try to migrate VM from host with older kernel: fail
> > > - Look at qemu error, which features are missing?
> > > - Are those features safely removable from guest ? 
> > >   - If so, get an SystemTap / eBPF script masking out the undesired bits.
> > >   - Try the migration again, it should succeed.
> > > 
> > > IIRC, this could also be done in qemu side, with a custom qemu:
> > > - Try to migrate VM from host with older kernel: fail
> > > - Look at qemu error, which features are missing?
> > > - Are those features safely removable from guest ?
> > >   - If so, get a custom qemu which mask-out the desired flags before the VM 
> > >     starts
> > >   - Live migrate (can be inside the source host) to the custom qemu
> > >   - Live migrate from custom qemu to target host.
> > > - The custom qemu could be on a auxiliary host, and used only for this
> > > 
> > > Yes, it's hard, takes time, and may not solve every case, but it gets a 
> > > higher chance of the VM surviving in the long run.
> > 
> > Thank you for taking the time to throughly consider the issue and suggest some
> > ways out - I really appreciate it.
> > 
> > > But keep in mind this is a hack.
> > > Taking features from a live guest is not supported in any way, and has a 
> > > high chance of crashing the VM.
> >
> > OK - if there's no interest in the below, I will not push for including this
> > patch in the kernel tree any longer. I do think the specific case below is what
> > a vast majority of KVM users will struggle with in the near future, though:
> >
> > I have a test environment with Broadwell-based (have only AVX-256) guests
> > running under Skylake (PKRU, AVX512, ...) hypervisors.
> 
> I definitely don't want to take the proposed patch.  As Leo pointed out, silently
> dropping features that userspace explicitly requests is a recipe for disaster.
> 
> However, I do agree with Tyler that is an egregious kernel/KVM bug, as essentially
> requiring KVM_SET_XSAVE to be a subset of guest supported XCR0, i.e. guest CPUID,
> is a clearcut breakage of userspace.  KVM_SET_XSAVE worked on kernel X and failed
> on kernel X+1, there's really no wiggle room there.
> 
> Luckily, I'm pretty sure there's no need to take features away from the guest in
> order to fix the bug Tyler is experiencing.  Prior to commit ad856280ddea, KVM's
> ABI was that KVM_SET_SAVE just needs a subset of the *host* features, i.e. this
> chunk from the changelog simply needs to be undone:
> 
>     As a bonus, it will also fail if userspace tries to set fpu features
>     (with the KVM_SET_XSAVE ioctl) that are not compatible to the guest
>     configuration.  Such features will never be returned by KVM_GET_XSAVE
>     or KVM_GET_XSAVE2.
> 
> That can be done by applying guest_supported_xcr0 to *only* the KVM_GET_XSAVE{2}
> path.  It's not ideal since it means that KVM_GET_XSAVE{2} won't be consistent
> with the guest model if userspace does KVM_GET_XSAVE{2} before KVM_SET_CPUID, but
> practically speaking I don't think there's a real world userspace VMM that does
> that.
> 
> Compile tested only, and it needs a changelog, but I think this will do the trick:
> 
> ---
>  arch/x86/include/asm/fpu/api.h |  3 ++-
>  arch/x86/kernel/fpu/core.c     |  5 +++--
>  arch/x86/kernel/fpu/xstate.c   |  7 +++++--
>  arch/x86/kernel/fpu/xstate.h   |  3 ++-
>  arch/x86/kvm/cpuid.c           |  8 --------
>  arch/x86/kvm/x86.c             | 37 ++++++++++++++++++++++------------
>  6 files changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
> index 31089b851c4f..a2be3aefff9f 100644
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -157,7 +157,8 @@ static inline void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd) {
>  static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
>  #endif
>  
> -extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
> +extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
> +					   unsigned int size, u64 xfeatures, u32 pkru);
>  extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
>  
>  static inline void fpstate_set_confidential(struct fpu_guest *gfpu)
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index a86d37052a64..a21a4d0ecc34 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -369,14 +369,15 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
>  EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
>  
>  void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
> -				    unsigned int size, u32 pkru)
> +				    unsigned int size, u64 xfeatures, u32 pkru)
>  {
>  	struct fpstate *kstate = gfpu->fpstate;
>  	union fpregs_state *ustate = buf;
>  	struct membuf mb = { .p = buf, .left = size };
>  
>  	if (cpu_feature_enabled(X86_FEATURE_XSAVE)) {
> -		__copy_xstate_to_uabi_buf(mb, kstate, pkru, XSTATE_COPY_XSAVE);
> +		__copy_xstate_to_uabi_buf(mb, kstate, xfeatures, pkru,
> +					  XSTATE_COPY_XSAVE);
>  	} else {
>  		memcpy(&ustate->fxsave, &kstate->regs.fxsave,
>  		       sizeof(ustate->fxsave));
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index cadf68737e6b..7d31033d176e 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1049,6 +1049,7 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
>   * __copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
>   * @to:		membuf descriptor
>   * @fpstate:	The fpstate buffer from which to copy
> + * @xfeatures:	Constraint which of user xfeatures to save (XSAVE only)
>   * @pkru_val:	The PKRU value to store in the PKRU component
>   * @copy_mode:	The requested copy mode
>   *
> @@ -1059,7 +1060,8 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
>   * It supports partial copy but @to.pos always starts from zero.
>   */
>  void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
> -			       u32 pkru_val, enum xstate_copy_mode copy_mode)
> +			       u64 xfeatures, u32 pkru_val,
> +			       enum xstate_copy_mode copy_mode)
>  {
>  	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
>  	struct xregs_state *xinit = &init_fpstate.regs.xsave;
> @@ -1083,7 +1085,7 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
>  		break;
>  
>  	case XSTATE_COPY_XSAVE:
> -		header.xfeatures &= fpstate->user_xfeatures;
> +		header.xfeatures &= fpstate->user_xfeatures & xfeatures;
>  		break;

This changes the consideration of the xfeatures copied *into* the uabi buffer
with respect to the guest xfeatures IIUC (approx guest XCR0, less FP/SSE only).

IOW: we are still trimming guest xfeatures, just at the source...?

That being said: the patch that I gave siliently allows unacceptable things to
be accepted at the destination, whereas this maintains status-quo and signals
an error when the destination cannot wholly process the uabi buffer (i.e.,
asked to restore more state than the destination processor has present).

The downside of my approach is above -- the flip side, though is that this
approach requires a patch to be applied on the source. However, we cannot
apply a patch at the source until it is evacuated of VMs -- chicken and egg
problem...

Unless I am grossly misunderstanding things here -- forgive me... :-)

It almost feels like userspace needs a flag to say: yes, old pre-Leo's-patched
kernel was broken and sent more state than you might need or want -- eat what
you can by default. If an additional flag is set, be conservative and ensure
that you are capable of restoring the xfeatures specified in the uabi buffer.

Cheers,
Tyler

>  	}
>  
> @@ -1185,6 +1187,7 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
>  			     enum xstate_copy_mode copy_mode)
>  {
>  	__copy_xstate_to_uabi_buf(to, tsk->thread.fpu.fpstate,
> +				  tsk->thread.fpu.fpstate->user_xfeatures,
>  				  tsk->thread.pkru, copy_mode);
>  }
>  
> diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
> index a4ecb04d8d64..3518fb26d06b 100644
> --- a/arch/x86/kernel/fpu/xstate.h
> +++ b/arch/x86/kernel/fpu/xstate.h
> @@ -43,7 +43,8 @@ enum xstate_copy_mode {
>  
>  struct membuf;
>  extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
> -				      u32 pkru_val, enum xstate_copy_mode copy_mode);
> +				      u64 xfeatures, u32 pkru_val,
> +				      enum xstate_copy_mode copy_mode);
>  extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
>  				    enum xstate_copy_mode mode);
>  extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0544e30b4946..773132c3bf5a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -360,14 +360,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.guest_supported_xcr0 =
>  		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>  
> -	/*
> -	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
> -	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
> -	 * supported by the host.
> -	 */
> -	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0 |
> -						       XFEATURE_MASK_FPSSE;
> -
>  	kvm_update_pv_runtime(vcpu);
>  
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9f18b06bbda6..734e2d69329b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5382,26 +5382,37 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> -					 struct kvm_xsave *guest_xsave)
> -{
> -	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> -		return;
> -
> -	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
> -				       guest_xsave->region,
> -				       sizeof(guest_xsave->region),
> -				       vcpu->arch.pkru);
> -}
>  
>  static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
>  					  u8 *state, unsigned int size)
>  {
> +	/*
> +	 * Only copy state for features that are enabled for the guest.  The
> +	 * state itself isn't problematic, but setting bits in the header for
> +	 * features that are supported in *this* host but not exposed to the
> +	 * guest can result in KVM_SET_XSAVE failing when live migrating to a
> +	 * compatible host, i.e. a host without the features that are NOT
> +	 * exposed to the guest.
> +	 *
> +	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
> +	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
> +	 * supported by the host.
> +	 */
> +	u64 supported_xcr0 = vcpu->arch.guest_supported_xcr0 |
> +			     XFEATURE_MASK_FPSSE;
> +
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>  		return;
>  
> -	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
> -				       state, size, vcpu->arch.pkru);
> +	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
> +				       supported_xcr0, vcpu->arch.pkru);
> +}
> +
> +static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> +					 struct kvm_xsave *guest_xsave)
> +{
> +	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> +					     sizeof(guest_xsave->region));
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
> 
> base-commit: 5804c19b80bf625c6a9925317f845e497434d6d3
> -- 
> 
