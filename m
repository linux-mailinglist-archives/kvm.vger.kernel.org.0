Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87267B6F0E
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbjJCQ4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240693AbjJCQ4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:56:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85115BD
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696352103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKz6JlccCVdwAjHFNSIJ5aqOB7SHuX73H5DKrk7P0eA=;
        b=DQipQZ/B8VmbZA7pOMa941fp+ntcMa8kT0LsS9Db3NV72/QmYrjgPupR0vEToD3YDshe47
        PuNQLpIcpakTausbN4Z16lCLWm3Dvk6W1XzZCQmb8439/gtA73Y6p8tZFmL+Npvq/ROxrp
        a6IYTHkJZTayIj+kVQ1x1Z9GBPyo+WI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-Q1RgWzUqPYC-gryTwD7vNA-1; Tue, 03 Oct 2023 12:54:52 -0400
X-MC-Unique: Q1RgWzUqPYC-gryTwD7vNA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40566c578b7so9455715e9.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696352091; x=1696956891;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UKz6JlccCVdwAjHFNSIJ5aqOB7SHuX73H5DKrk7P0eA=;
        b=stM1VTBj5SI8IVs5AJIbnn2fhD4FN0PNIxFlWb0h0TFQbIyJ16KN/VJte9v14lnOFr
         MwDdEpBaeygBU2EYwTjjC3/pw8EyzIXuiyZzeebQkingEuEPn9ZzMFZhc5WyIoEOknsk
         qszrrXpQmdRoRqv8Ya6zBcfhEZ1tbMKdrGC5rrK2vkmI/iHMlVMf2vexEejtCo2JmnSv
         hYP1cjs3X5MPIUj7aNI4lf6VcLG0B2Wc+ee9fRgDut9Ey0tMzip1+V8K4gIX14fn63nW
         ygqRI8fy6QhGxP+u5OUII7U7NYi1vsgHFo1jBppIrfr92Om9rEJ12SdshFvaNkTnYpOr
         wR+g==
X-Gm-Message-State: AOJu0YwIzFoFTIVYO+n5zG1L6Eb74XenQV2kSAs/LDt5Rq9cWGhcmP/d
        EnO3rXoTcuCyyp5RU+5U5vq8ceie+Q2JmuFS2jqAO9rYiXMrRIJuSsy+Vb5Ce4MRNTd2shZDVqG
        S/moGZiCyLOk6
X-Received: by 2002:a5d:46cc:0:b0:31f:8999:c409 with SMTP id g12-20020a5d46cc000000b0031f8999c409mr12798723wrs.66.1696352091204;
        Tue, 03 Oct 2023 09:54:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEw8GrseodyMNQjRvXwM2R7y7QiATyOCHeguCOnxlPwguiOvboAnAcudNz+gmFlWejG4+qew==
X-Received: by 2002:a5d:46cc:0:b0:31f:8999:c409 with SMTP id g12-20020a5d46cc000000b0031f8999c409mr12798708wrs.66.1696352090912;
        Tue, 03 Oct 2023 09:54:50 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id c6-20020a5d4cc6000000b00325c7295450sm1977795wrt.3.2023.10.03.09.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:54:50 -0700 (PDT)
Message-ID: <fe832be36d46a946431567cbc315766fbdc772b1.camel@redhat.com>
Subject: Re: [PATCH v9 5/6] KVM: x86: Migrate to __kvm_follow_pfn
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     David Stevens <stevensd@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 03 Oct 2023 19:54:48 +0300
In-Reply-To: <20230911021637.1941096-6-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
         <20230911021637.1941096-6-stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У пн, 2023-09-11 у 11:16 +0900, David Stevens пише:
> From: David Stevens <stevensd@chromium.org>
> 
> Migrate functions which need access to is_refcounted_page to
> __kvm_follow_pfn. The functions which need this are __kvm_faultin_pfn
> and reexecute_instruction. The former requires replacing the async
> in/out parameter with FOLL_NOWAIT parameter and the KVM_PFN_ERR_NEEDS_IO
> return value. Handling non-refcounted pages is complicated, so it will
> be done in a followup. The latter is a straightforward refactor.
> 
> APIC related callers do not need to migrate because KVM controls the
> memslot, so it will always be regular memory. Prefetch related callers
> do not need to be migrated because atomic gfn_to_pfn calls can never
> make it to hva_to_pfn_remapped.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 43 ++++++++++++++++++++++++++++++++----------
>  arch/x86/kvm/x86.c     | 12 ++++++++++--
>  2 files changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e1d011c67cc6..e1eca26215e2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4254,7 +4254,14 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> -	bool async;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = fault->gfn,
> +		.flags = fault->write ? FOLL_WRITE : 0,
> +		.try_map_writable = true,
> +		.guarded_by_mmu_notifier = true,
> +		.allow_non_refcounted_struct_page = false,
> +	};
>  
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> @@ -4283,12 +4290,20 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> -	if (!async)
> -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> +	foll.flags |= FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))
> +		goto success;
Unrelated but I can't say I like the 'is_error_noslot_pfn()' name, 
I wish it was called something like is_valid_pfn().

> +
> +	/*
> +	 * If __kvm_follow_pfn() failed because I/O is needed to fault in the
> +	 * page, then either set up an asynchronous #PF to do the I/O, or if
> +	 * doing an async #PF isn't possible, retry __kvm_follow_pfn() with
> +	 * I/O allowed. All other failures are fatal, i.e. retrying won't help.
> +	 */
> +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> +		return RET_PF_CONTINUE;
>  
>  	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
>  		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
> @@ -4306,9 +4321,17 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	 * to wait for IO.  Note, gup always bails if it is unable to quickly
>  	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
>  	 */
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +	foll.flags |= FOLL_INTERRUPTIBLE;
> +	foll.flags &= ~FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))
> +		goto success;
> +
> +	return RET_PF_CONTINUE;
> +success:
> +	fault->hva = foll.hva;
> +	fault->map_writable = foll.writable;
>  	return RET_PF_CONTINUE;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6c9c81e82e65..2011a7e47296 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8556,6 +8556,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  {
>  	gpa_t gpa = cr2_or_gpa;
>  	kvm_pfn_t pfn;
> +	struct kvm_follow_pfn foll;
>  
>  	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
>  		return false;
> @@ -8585,7 +8586,13 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	 * retry instruction -> write #PF -> emulation fail -> retry
>  	 * instruction -> ...
>  	 */
> -	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
> +	foll = (struct kvm_follow_pfn) {
> +		.slot = gfn_to_memslot(vcpu->kvm, gpa_to_gfn(gpa)),
> +		.gfn = gpa_to_gfn(gpa),
> +		.flags = FOLL_WRITE,
> +		.allow_non_refcounted_struct_page = true,
> +	};
> +	pfn = __kvm_follow_pfn(&foll);
>  
>  	/*
>  	 * If the instruction failed on the error pfn, it can not be fixed,
> @@ -8594,7 +8601,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	if (is_error_noslot_pfn(pfn))
>  		return false;
>  
> -	kvm_release_pfn_clean(pfn);
> +	if (foll.is_refcounted_page)
> +		kvm_release_page_clean(pfn_to_page(pfn));
>  
>  	/* The instructions are well-emulated on direct mmu. */
>  	if (vcpu->arch.mmu->root_role.direct) {


Overall looks good, I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky




