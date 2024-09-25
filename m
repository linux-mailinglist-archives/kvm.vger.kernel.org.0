Return-Path: <kvm+bounces-27470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C63998654B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:05:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0B9BB23B93
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CEFB5476B;
	Wed, 25 Sep 2024 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blE4aVRY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12AC42067
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727283929; cv=none; b=jVmrJTHthPnrTqIu6YHBMnmrG8vgksuAtxXvh+pxRansjYzlB1uW3HCd2g973OjJ6W2AwageayYFAuAWKYDTtQ48yC5gMaHTkD9QxjxxYfSwnGvUzBubPKiB9CauUPKhnqrD7ir/HwI6f38laVsRC+IXUvBka3C/A7pCjs/RAnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727283929; c=relaxed/simple;
	bh=iFxM43rWyH5d2CGiANYwsZrL5kh1zj+7s9Tna+MKIp0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NMowHYf6W0DB2m1DTT8IZoG6pmtbdJGWxx4QOvDfjSLFKT+yTfbYI525aZO2WOo12Vg80wDouAZ8B0m24ZXA48mPqWTVDQW9ymL0q/w14M7X4CflQvacXF8CTl53uewSXO2CTzSWvVsRw6pzYKimRoZSi2S1SDPFBApzQyt8XdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blE4aVRY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727283926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14jM8sP/zRLQ3FgfpULDlZiLAMnh3LZ2O0kIN73+8Cg=;
	b=blE4aVRYCvIDt7QY2T6uM5q2cnu7fr/H6K+vPjU9pkDlU6C2vKp39DdFH76YA3sY0xuOW3
	ovAV++dHlcuDV5aeJkGqoPU9+ITkCu9Cti9HVKYSUsZLan5yMabtfFvtesiTabR5ivU56e
	bz8xpbNPJfQ7wYdMrYLOBZFROtisMDE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-pF409HsMOy-uCCY1Zt28lw-1; Wed, 25 Sep 2024 13:05:25 -0400
X-MC-Unique: pF409HsMOy-uCCY1Zt28lw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4581e5e3e48so66801cf.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727283925; x=1727888725;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=14jM8sP/zRLQ3FgfpULDlZiLAMnh3LZ2O0kIN73+8Cg=;
        b=YYAxg57uNg7sHa3Up7s+mzplba43RHDthUgqy/hmf0jLthvDsyReULju22pg325ubx
         ABN79DuV7MeDGrkMCW2wqz9RNsfet+k2aPr+CiQq2lTqXNb3lWgrep9d4YQ5OuhpxryQ
         jzfJZW6vCWdFn4UNbo7b2QGEKoYXXQZceADRGAV03buC85hrqDd7My3zlBVbaZ60xH8E
         An1KeDUj4PWKJLuR/9JsxfSJCESNHbnWRi28iyrumewmIsXmCKGIeFsikkpIgvcmMEgG
         4jkYKsQfUJ3nktfJAn/EthniSAFBi4c3kwQ/u/QR5oGd1Lj6WeUtTyTB179gKpcGRkhq
         WtjA==
X-Forwarded-Encrypted: i=1; AJvYcCWMsKjhHZ58PL8R8rvAh5hugq9IrYuR9LubtEglMw+Kkfl9ZS69SUXe30YVwB7IWb9ieKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuHWbbabwQEMeMDku9uxZVlOt/fAvgZe3hlixlKX/TykPCB1JZ
	fes+bWfAYLh0nbhg0YgFGImWPxBk+86NxBd6Y80k0pqNq43WYhD7BOkiavxHqTv5PQHVB8c3CxE
	hwiYUKmGqvx5wx470lUgWwwo/fSDCs4KCBg4D30zCR1AJmsIIWA==
X-Received: by 2002:a05:622a:30e:b0:458:2aac:e502 with SMTP id d75a77b69052e-45b5dede3f7mr41942371cf.23.1727283924797;
        Wed, 25 Sep 2024 10:05:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaH3mKi4H3/3muZEKBLjgJRkxenn+2wKaM3uGfcZKSTTQzdFMGMQ0SjsyMzwf30cFFYlrZ1Q==
X-Received: by 2002:a05:622a:30e:b0:458:2aac:e502 with SMTP id d75a77b69052e-45b5dede3f7mr41941971cf.23.1727283924269;
        Wed, 25 Sep 2024 10:05:24 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45b52594b73sm17813341cf.47.2024.09.25.10.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:05:23 -0700 (PDT)
Message-ID: <b06172780e3af37fe91d1cc434aceff4169f88b3.camel@redhat.com>
Subject: Re: [PATCH v3 2/2] VMX: reset the segment cache after segment
 initialization in vmx_vcpu_reset
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
 <hpa@zytor.com>,  linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>,  x86@kernel.org
Date: Wed, 25 Sep 2024 13:05:22 -0400
In-Reply-To: <ZvQne77ycOKQ1nvU@google.com>
References: <20240725175232.337266-1-mlevitsk@redhat.com>
	 <20240725175232.337266-3-mlevitsk@redhat.com> <ZrF55uIvX2rcHtSW@chao-email>
	 <ZrY1adEnEW2N-ijd@google.com>
	 <61e7e64c615aba6297006dbf32e48986d33c12ab.camel@redhat.com>
	 <65fe418f079a1f9f59caa170ec0ae5d828486714.camel@redhat.com>
	 <ZvQne77ycOKQ1nvU@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-09-25 at 08:08 -0700, Sean Christopherson wrote:
> On Mon, Sep 09, 2024, Maxim Levitsky wrote:
> > On Mon, 2024-09-09 at 15:11 -0400, Maxim Levitsky wrote:
> > > On Fri, 2024-08-09 at 08:27 -0700, Sean Christopherson wrote:
> > > > > > @@ -4899,6 +4896,9 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > > > > 	vmcs_writel(GUEST_IDTR_BASE, 0);
> > > > > > 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
> > > > > > 
> > > > > > +	vmx_segment_cache_clear(vmx);
> > > > > > +	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
> > > > > 
> > > > > vmx_segment_cache_clear() is called in a few other sites. I think at least the
> > > > > call in __vmx_set_segment() should be fixed, because QEMU may read SS.AR right
> > > > > after a write to it. if the write was preempted after the cache was cleared but
> > > > > before the new value being written into VMCS, QEMU would find that SS.AR held a
> > > > > stale value.
> > > > 
> > > > Ya, I thought the plan was to go for a more complete fix[*]?  This change isn't
> > > > wrong, but it's obviously incomplete, and will be unnecessary if the preemption
> > > > issue is resolved.
> > > 
> > > Hi,
> > > 
> > > I was thinking to keep it simple, since the issue is mostly theoretical
> > > after this fix, but I'll give this another try.
> > 
> > This is what I am thinking, after going over this issue again:
> > 
> > Pre-populating the cache and/or adding 'exited_in_kernel' will waste vmreads
> > on *each* vmexit,
> 
> FWIW, KVM would only need to do the VMREAD on non-fastpath exits.
> 
> > I worry that this is just not worth the mostly theoretical issue that we
> > have.
> 
> Yeah.  And cost aside, it's weird and hard to document and use properly because
> it's such an edge case.  E.g. only applies preemptible kernels, and use of
> exited_in_kernel would likely need to be restricted to the sched_out() preempt
> logic, because anything really needs to check the "current" CPL.
> 
> > Since the segment and the register cache only optimize the case of reading a
> > same field twice or more, I suspect that reading these fields always is worse
> > performance wise than removing the segment cache altogether and reading these
> > fields again and again.
> 
> For modern setups, yeah, the segment cache likely isn't helping much, though I
> suspect it still gets a decent number of "hits" on CS.AR_BYTES via is_64_bit_mode().
> 
> But for older CPUs where KVM needs to emulate large chunks of code, I'm betting
> the segment cache is an absolute must have.
> 
> > Finally all 3 places that read the segment cache, only access one piece of
> > data (SS.AR or RIP), thus it doesn't really matter if they see an old or a
> > new value. 
> > 
> > I mean in theory if userspace changes the SS's AR bytes out of the blue, and
> > then we get a preemption event, in theory as you say the old value is correct
> > but it really doesn't matter.
> > 
> > So IMHO, just ensuring that we invalidate the segment cache right after we do
> > any changes is the simplest solution.
> 
> But it's not a very maintainable solution.  It fixes the immediate problem, but
> doesn't do anything to help ensure that all future code invalidates the cache
> after writing,

If we wrap segment cache access with something like segment_cache_access_begin()/end(),
we can ensure that segment cache is only modified then (with some macros even maybe),
or that at least it is clear to the developer that all writes should be wrapped by these
functions.

I also do think that we should still re-order the segment cache accesses in vmx_vcpu_reset()
and other places just for the sake of consistency.


>  nor does it guarantee that all future usage of SS.AR can tolerate
> consuming stale values.
> 
> > I can in addition to that add a warning to kvm_register_is_available and
> > vmx_segment_cache_test_set, that will test that only SS.AR and RIP are read
> > from the interrupt context, so that if in the future someone attempts to read
> > more fields, this issue can be re-evaluated.
> 
> There's no need to add anything to vmx_segment_cache_test_set(), because it uses
> kvm_register_is_available().  I.e. adding logic in kvm_register_is_available()
> will suffice.
> 
> If we explicitly allow VMCS accesses from PMI callbacks, which by we *know* can
> tolerate stale data _and_ never run while KVM is updating segments, then we can
> fix the preemption case by forcing a VMREAD and bypassing the cache.
>  
> And looking to the future, if vcpu->arch.guest_state_protected is moved/exposed
> to common code in some way, then the common PMI code can skip trying to read guest
> state, and the ugliness of open coding that check in the preemption path largely
> goes away.
This is assuming that most VMs will be protected in the future?

> 
> If you're ok with the idea, I'll write changelogs and post the below (probably over
> two patches).  I don't love adding another kvm_x86_ops callback, but I couldn't
> come up with anything less ugly.

This was one of the reasons I didn't want to write something like that.
If we indeed only add callback for get_cpl_no_cache, then it is tolerable.


> 
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/kvm_cache_regs.h      | 17 +++++++++++++++++
>  arch/x86/kvm/svm/svm.c             |  1 +
>  arch/x86/kvm/vmx/main.c            |  1 +
>  arch/x86/kvm/vmx/vmx.c             | 23 ++++++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.h             |  1 +
>  arch/x86/kvm/x86.c                 | 13 ++++++++++++-
>  8 files changed, 52 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 861d080ed4c6..5aff7222e40f 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -34,6 +34,7 @@ KVM_X86_OP(set_msr)
>  KVM_X86_OP(get_segment_base)
>  KVM_X86_OP(get_segment)
>  KVM_X86_OP(get_cpl)
> +KVM_X86_OP(get_cpl_no_cache)
>  KVM_X86_OP(set_segment)
>  KVM_X86_OP(get_cs_db_l_bits)
>  KVM_X86_OP(is_valid_cr0)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6d9f763a7bb9..3ae90df0a177 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1656,6 +1656,7 @@ struct kvm_x86_ops {
>  	void (*get_segment)(struct kvm_vcpu *vcpu,
>  			    struct kvm_segment *var, int seg);
>  	int (*get_cpl)(struct kvm_vcpu *vcpu);
> +	int (*get_cpl_no_cache)(struct kvm_vcpu *vcpu);
>  	void (*set_segment)(struct kvm_vcpu *vcpu,
>  			    struct kvm_segment *var, int seg);
>  	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index b1eb46e26b2e..0370483003f6 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -43,6 +43,18 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
>  BUILD_KVM_GPR_ACCESSORS(r15, R15)
>  #endif
>  
> +/*
> + * Using the register cache from interrupt context is generally not allowed, as
> + * caching a register and marking it available/dirty can't be done atomically,
> + * i.e. accesses from interrupt context may clobber state or read stale data if
> + * the vCPU task is in the process of updating the cache.  The exception is if
> + * KVM is handling an IRQ/NMI from guest mode, as that bounded sequence doesn't
> + * touch the cache, it runs after the cache is reset (post VM-Exit), and PMIs
> + * need to several registers that are cacheable.
> + */
> +#define kvm_assert_register_caching_allowed(vcpu)		\
> +	lockdep_assert_once(in_task() ||			\
> +			    READ_ONCE(vcpu->arch.handling_intr_from_guest))

This is ugly, but on the second thought reasonable, given the circumstances.

How about using kvm_arch_pmi_in_guest() instead? It is a tiny bit more accurate
and self-documenting IMHO.


Also, how about checking for in_task() in __vmx_get_cpl() and then avoiding the cache?
This way we will avoid adding a new callback, and in theory if there is more code that
tries to read CPL from interrupt context, it will work for free. 

But on the other hand we might actually not want new code to get this for free. 
Is this the reason you added the callback?

>  /*
>   * avail  dirty
>   * 0	  0	  register in VMCS/VMCB
> @@ -53,24 +65,28 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
>  static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
>  					     enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
>  static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
>  					 enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
>  }
>  
>  static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
>  					       enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
>  static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>  					   enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
>  }
> @@ -84,6 +100,7 @@ static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>  static __always_inline bool kvm_register_test_and_mark_available(struct kvm_vcpu *vcpu,
>  								 enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	return arch___test_and_set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9df3e1e5ae81..50f6b0e03d04 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5031,6 +5031,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.get_segment = svm_get_segment,
>  	.set_segment = svm_set_segment,
>  	.get_cpl = svm_get_cpl,
> +	.get_cpl_no_cache = svm_get_cpl,
>  	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
>  	.is_valid_cr0 = svm_is_valid_cr0,
>  	.set_cr0 = svm_set_cr0,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 7668e2fb8043..92d35cc6cd15 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -50,6 +50,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.get_segment = vmx_get_segment,
>  	.set_segment = vmx_set_segment,
>  	.get_cpl = vmx_get_cpl,
> +	.get_cpl_no_cache = vmx_get_cpl_no_cache,
>  	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
>  	.is_valid_cr0 = vmx_is_valid_cr0,
>  	.set_cr0 = vmx_set_cr0,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c67e448c6ebd..e2483678eca1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3568,16 +3568,29 @@ u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
>  	return vmx_read_guest_seg_base(to_vmx(vcpu), seg);
>  }
>  
> -int vmx_get_cpl(struct kvm_vcpu *vcpu)
> +static int __vmx_get_cpl(struct kvm_vcpu *vcpu, bool no_cache)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	int ar;
>  
>  	if (unlikely(vmx->rmode.vm86_active))
>  		return 0;
> -	else {
> -		int ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
> -		return VMX_AR_DPL(ar);
> -	}
> +
> +	if (no_cache)
> +		ar = vmcs_read32(GUEST_SS_AR_BYTES);
> +	else
> +		ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
> +	return VMX_AR_DPL(ar);
> +}
> +
> +int vmx_get_cpl(struct kvm_vcpu *vcpu)
> +{
> +	return __vmx_get_cpl(vcpu, false);
> +}
> +
> +int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu)
> +{
> +	return __vmx_get_cpl(vcpu, true);
>  }
>  
>  static u32 vmx_segment_access_rights(struct kvm_segment *var)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2325f773a20b..bcf40c7f3a38 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -385,6 +385,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>  void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
>  			unsigned long fs_base, unsigned long gs_base);
>  int vmx_get_cpl(struct kvm_vcpu *vcpu);
> +int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu);
>  bool vmx_emulation_required(struct kvm_vcpu *vcpu);
>  unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
>  void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83fe0a78146f..941245082647 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5094,7 +5094,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	int idx;
>  
>  	if (vcpu->preempted) {
> -		vcpu->arch.preempted_in_kernel = kvm_arch_vcpu_in_kernel(vcpu);
> +		/*
> +		 * Assume protected guests are in-kernel.  Inefficient yielding
> +		 * due to false positives is preferable to never yielding due
> +		 * to false negatives.
> +		 */
> +		vcpu->arch.preempted_in_kernel = vcpu->arch.guest_state_protected ||
> +						 !kvm_x86_call(get_cpl_no_cache)(vcpu);
>  
>  		/*
>  		 * Take the srcu lock as memslots will be accessed to check the gfn
> @@ -13207,6 +13213,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>  {
> +	/* TODO: Elide the call in the kvm_guest_get_ip() perf callback. */
>  	if (vcpu->arch.guest_state_protected)
>  		return true;
>  
> @@ -13215,6 +13222,10 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>  
>  unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
>  {
> +	/* TODO: Elide the call in the kvm_guest_get_ip() perf callback. */
> +	if (vcpu->arch.guest_state_protected)
> +		return 0;
> +
>  	return kvm_rip_read(vcpu);
>  }
>  
> 
> base-commit: 3f8df6285271d9d8f17d733433e5213a63b83a0b

Overall I think I agree with this patch.

Best regards,
      Maxim Levitsky



