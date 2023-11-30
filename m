Return-Path: <kvm+bounces-2981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C5C7FF839
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9321E1C20EF6
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E799F5676F;
	Thu, 30 Nov 2023 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NQfZ6WCE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E477F10D1
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701365310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nOkzrp5Y8jfN08t486/mNG/roBJRP2+WAIqpeQfAERA=;
	b=NQfZ6WCE22affuCvLHqE8j0hjl7/HVX1MWZ/C7P8VquHjuWb18UC6e2VDitc1xHAeq21U6
	603IB3K71ns/Xz5RcAZ+iwOv+zOmyWYuudu0eyUOzjzNC2jrIjQ3khwum5qmitBeGFKS1D
	81yOoJsJNC6S3/SbsL6fFptT6Osn5A8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-vLXbFK-YNuCUFsI-0H1EwQ-1; Thu, 30 Nov 2023 12:28:28 -0500
X-MC-Unique: vLXbFK-YNuCUFsI-0H1EwQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-548cf45e962so961008a12.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:28:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701365307; x=1701970107;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nOkzrp5Y8jfN08t486/mNG/roBJRP2+WAIqpeQfAERA=;
        b=MImOFRUPonh46ISjSELTMVQAeG218tJEF7YdRj3+DSKOjrEjn6Bs8/SxpxsLZCQAhW
         7s2mFGoecF3vKeBYjF5KTU1wP6looU/4LGfnzJQlHdsDM7Od3wXFt3Mok4O0ZA8Amnih
         oRQd9LOvb36nvYLKH5OC5eJQUtoiVB7Fkh9O9y8WkxQSBSjqIiy/QiEc8eW+b3Lx76uX
         S0FrecErZ9UUulei0V0/xHYV3KbYS8YTPE4e1RnL0YBtooSef19sOhWJ1eBG8QT6WCBB
         DJe8NkI8OfEZtgrVoLkjxRZb18IkuSjZ8eoLCa/SJ9B7xtVP9v3WpEoL9aijyVp/BCch
         FeAg==
X-Gm-Message-State: AOJu0YxjzYpl3qmFCdjLgTratbkU75YX63p6l+Gg+PHPc+COpCS7Vv2C
	iUH+9wxTb6qpLhVI5bbFANHMqnLGMvntQk+X7/zC6BrvoR9ZLz+8bQCgSqkMBUsnVsM7aM/7157
	toT+Yr9ugRO0C
X-Received: by 2002:a05:6512:524:b0:50b:cb87:96d8 with SMTP id o4-20020a056512052400b0050bcb8796d8mr7593lfc.55.1701365109379;
        Thu, 30 Nov 2023 09:25:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlU9RbIY4G8M3m/YV+Qx+YXqiJA2vw2pBwjTQQyqNqD0x3IRcPZSAaut+o+XrJ86Yzqgy8OA==
X-Received: by 2002:a05:6512:524:b0:50b:cb87:96d8 with SMTP id o4-20020a056512052400b0050bcb8796d8mr7259lfc.55.1701365100744;
        Thu, 30 Nov 2023 09:25:00 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id x20-20020ac25dd4000000b0050bba0bbe71sm211222lfq.107.2023.11.30.09.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:25:00 -0800 (PST)
Message-ID: <4a2fae8e40d7e883d10081aad415a62444c838e0.camel@redhat.com>
Subject: Re: [PATCH v7 01/26] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:24:57 +0200
In-Reply-To: <20231124055330.138870-2-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-2-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When granting userspace or a KVM guest access to an xfeature, preserve the
> entity's existing supervisor and software-defined permissions as tracked
> by __state_perm, i.e. use __state_perm to track *all* permissions even
> though all supported supervisor xfeatures are granted to all FPUs and
> FPU_GUEST_PERM_LOCKED disallows changing permissions.
> 
> Effectively clobbering supervisor permissions results in inconsistent
> behavior, as xstate_get_group_perm() will report supervisor features for
> process that do NOT request access to dynamic user xfeatures, whereas any
> and all supervisor features will be absent from the set of permissions for
> any process that is granted access to one or more dynamic xfeatures (which
> right now means AMX).
> 
> The inconsistency isn't problematic because fpu_xstate_prctl() already
> strips out everything except user xfeatures:
> 
>         case ARCH_GET_XCOMP_PERM:
>                 /*
>                  * Lockless snapshot as it can also change right after the
>                  * dropping the lock.
>                  */
>                 permitted = xstate_get_host_group_perm();
>                 permitted &= XFEATURE_MASK_USER_SUPPORTED;
>                 return put_user(permitted, uptr);
> 
>         case ARCH_GET_XCOMP_GUEST_PERM:
>                 permitted = xstate_get_guest_group_perm();
>                 permitted &= XFEATURE_MASK_USER_SUPPORTED;
>                 return put_user(permitted, uptr);
> 
> and similarly KVM doesn't apply the __state_perm to supervisor states
> (kvm_get_filtered_xcr0() incorporates xstate_get_guest_group_perm()):
> 
>         case 0xd: {
>                 u64 permitted_xcr0 = kvm_get_filtered_xcr0();
>                 u64 permitted_xss = kvm_caps.supported_xss;
> 
> But if KVM in particular were to ever change, dropping supervisor
> permissions would result in subtle bugs in KVM's reporting of supported
> CPUID settings.  And the above behavior also means that having supervisor
> xfeatures in __state_perm is correctly handled by all users.
> 
> Dropping supervisor permissions also creates another landmine for KVM.  If
> more dynamic user xfeatures are ever added, requesting access to multiple
> xfeatures in separate ARCH_REQ_XCOMP_GUEST_PERM calls will result in the
> second invocation of __xstate_request_perm() computing the wrong ksize, as
> as the mask passed to xstate_calculate_size() would not contain *any*
> supervisor features.
> 
> Commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE
> permissions") fudged around the size issue for userspace FPUs, but for
> reasons unknown skipped guest FPUs.  Lack of a fix for KVM "works" only
> because KVM doesn't yet support virtualizing features that have supervisor
> xfeatures, i.e. as of today, KVM guest FPUs will never need the relevant
> xfeatures.
> 
> Simply extending the hack-a-fix for guests would temporarily solve the
> ksize issue, but wouldn't address the inconsistency issue and would leave
> another lurking pitfall for KVM.  KVM support for virtualizing CET will
> likely add CET_KERNEL as a guest-only xfeature, i.e. CET_KERNEL will not
> be set in xfeatures_mask_supervisor() and would again be dropped when
> granting access to dynamic xfeatures.
> 
> Note, the existing clobbering behavior is rather subtle.  The @permitted
> parameter to __xstate_request_perm() comes from:
> 
> 	permitted = xstate_get_group_perm(guest);
> 
> which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm,
> where __state_perm is initialized to:
> 
>         fpu->perm.__state_perm          = fpu_kernel_cfg.default_features;
> 
> and copied to the guest side of things:
> 
> 	/* Same defaults for guests */
> 	fpu->guest_perm = fpu->perm;
> 
> fpu_kernel_cfg.default_features contains everything except the dynamic
> xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:
> 
>         fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>         fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> 
> When __xstate_request_perm() restricts the local "mask" variable to
> compute the user state size:
> 
> 	mask &= XFEATURE_MASK_USER_SUPPORTED;
> 	usize = xstate_calculate_size(mask, false);
> 
> it subtly overwrites the target __state_perm with "mask" containing only
> user xfeatures:
> 
> 	perm = guest ? &fpu->guest_perm : &fpu->perm;
> 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
> 	WRITE_ONCE(perm->__state_perm, mask);
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Weijiang Yang <weijiang.yang@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: kvm@vger.kernel.org
> Link: https://lore.kernel.org/all/ZTqgzZl-reO1m01I@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index ef6906107c54..73f6bc00d178 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>  	if ((permitted & requested) == requested)
>  		return 0;
>  
> -	/* Calculate the resulting kernel state size */
> +	/*
> +	 * Calculate the resulting kernel state size.  Note, @permitted also
> +	 * contains supervisor xfeatures even though supervisor are always
> +	 * permitted for kernel and guest FPUs, and never permitted for user
> +	 * FPUs.
> +	 */
>  	mask = permitted | requested;
> -	/* Take supervisor states into account on the host */
> -	if (!guest)
> -		mask |= xfeatures_mask_supervisor();
>  	ksize = xstate_calculate_size(mask, compacted);
>  
> -	/* Calculate the resulting user state size */
> -	mask &= XFEATURE_MASK_USER_SUPPORTED;
> -	usize = xstate_calculate_size(mask, false);
> +	/*
> +	 * Calculate the resulting user state size.  Take care not to clobber
> +	 * the supervisor xfeatures in the new mask!
> +	 */
> +	usize = xstate_calculate_size(mask & XFEATURE_MASK_USER_SUPPORTED, false);
>  
>  	if (!guest) {
>  		ret = validate_sigaltstack(usize);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


