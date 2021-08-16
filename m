Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A0E3EDBC8
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 18:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhHPQyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 12:54:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232554AbhHPQyd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 12:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629132841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PADTFWtkgacjxL5aCb4BndbTfuIMvOWWJjkXMj5LjiI=;
        b=Rm1RStGRxmgjw5WJBFlTLGXKCEbSm3aZUNeglFM2065dCrmMolHuCMSL5whW4ugXmYCMP9
        lTn/ptI5bx//kkTxx73CZaHGcgZ9A9DNXhV8+Nvobt0hkibFTm+fXNiZHN+IVbIFR5a0oK
        O4ByO+Rq280AGnsqddduJyHXh+skusc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-NWcI9yM7M4GEWYqHGDGWBw-1; Mon, 16 Aug 2021 12:54:00 -0400
X-MC-Unique: NWcI9yM7M4GEWYqHGDGWBw-1
Received: by mail-wm1-f70.google.com with SMTP id z186-20020a1c7ec30000b02902e6a27a9962so7790493wmc.3
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 09:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PADTFWtkgacjxL5aCb4BndbTfuIMvOWWJjkXMj5LjiI=;
        b=gpekg2DvAcQcYFyO0LPd+4YJmvDj+xnJq0EU4DjvLLSU0Yp9nJeiTKVqxbjrsDOWUC
         R4WWOnbKr4x6mDOesOhQE4R152l3N5+a3QIsUW8CcjcdEd9bT6BgY8fKcuHxBCAetPu2
         HTkEMSJmrXuaOkHAuX6wnGQ/dikF4bprG2FZyg37z90Lt1Q21/l5jABM6RPRUoEAR9EA
         fzs45f0bg1h3Nq8fm8H/z4Qz8F3cevddBfRTrmZBd2gdYpRWHFtjDbhqkLX6V6sfFPiQ
         dHotJcbcXcs6VzxSAtXUtznLv7NHyyh4jIq9kyhFAFNzlYM9PjBGR5B6jha0crAQnG27
         ZMJQ==
X-Gm-Message-State: AOAM5318bGyJVA0kVBK4mN6XYFsMXwGFjZbbgyfQXNV3HnuL92HHPxUz
        q3faGC5117nNxEb123x/F7w3i2itoN24DV1z3HQXoHu0Iybw0dFKZSdi2jwQWwE43XHyuBE89Iv
        3BklgFW7PtHA4
X-Received: by 2002:adf:e3d2:: with SMTP id k18mr19260248wrm.212.1629132839090;
        Mon, 16 Aug 2021 09:53:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiktEdXIUdYenTuirwoDwoW4Gw7S40sfPqijk61K8unLBFFJ1r0nluf5F4o61Bw+qZPW9CrA==
X-Received: by 2002:adf:e3d2:: with SMTP id k18mr19260223wrm.212.1629132838897;
        Mon, 16 Aug 2021 09:53:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i8sm9234140wrv.70.2021.08.16.09.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:53:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, shan.gavin@gmail.com,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v4 02/15] KVM: async_pf: Add helper function to check
 completion queue
In-Reply-To: <20210815005947.83699-3-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-3-gshan@redhat.com>
Date:   Mon, 16 Aug 2021 18:53:57 +0200
Message-ID: <87bl5xmiu2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gavin Shan <gshan@redhat.com> writes:

> This adds inline helper kvm_check_async_pf_completion_queue() to
> check if there are pending completion in the queue. The empty stub
> is also added on !CONFIG_KVM_ASYNC_PF so that the caller needn't
> consider if CONFIG_KVM_ASYNC_PF is enabled.
>
> All checks on the completion queue is done by the newly added inline
> function since list_empty() and list_empty_careful() are interchangeable.
>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/x86/kvm/x86.c       |  2 +-
>  include/linux/kvm_host.h | 10 ++++++++++
>  virt/kvm/async_pf.c      | 10 +++++-----
>  virt/kvm/kvm_main.c      |  4 +---
>  4 files changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..7f35d9324b99 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11591,7 +11591,7 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  {
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return true;
>  
>  	if (kvm_apic_has_events(vcpu))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 85b61a456f1c..a5f990f6dc35 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -339,12 +339,22 @@ struct kvm_async_pf {
>  	bool				notpresent_injected;
>  };
>  
> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)

Nitpicking: When not reading the implementation, I'm not exactly sure
what this function returns as 'check' is too ambiguous ('true' when the
queue is full? when it's empty? when it's not empty? when it was
properly set up?). I'd suggest we go with a more specific:

kvm_async_pf_completion_queue_empty() or something like that instead
(we'll have to invert the logic everywhere then). 

Side note: x86 seems to already use a shortened 'apf' instead of
'async_pf' in a number of places (e.g. 'apf_put_user_ready()'), we may
want to either fight this practice or support the rebelion by renaming
all functions from below instead :-)

> +{
> +	return !list_empty_careful(&vcpu->async_pf.done);
> +}
> +
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
>  void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
>  bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			unsigned long hva, struct kvm_arch_async_pf *arch);
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #else
> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
>  #endif
>  
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index dd777688d14a..d145a61a046a 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -70,7 +70,7 @@ static void async_pf_execute(struct work_struct *work)
>  		kvm_arch_async_page_present(vcpu, apf);
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -	first = list_empty(&vcpu->async_pf.done);
> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>  	list_add_tail(&apf->link, &vcpu->async_pf.done);
>  	apf->vcpu = NULL;
>  	spin_unlock(&vcpu->async_pf.lock);
> @@ -122,7 +122,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  		spin_lock(&vcpu->async_pf.lock);
>  	}
>  
> -	while (!list_empty(&vcpu->async_pf.done)) {
> +	while (kvm_check_async_pf_completion_queue(vcpu)) {
>  		struct kvm_async_pf *work =
>  			list_first_entry(&vcpu->async_pf.done,
>  					 typeof(*work), link);
> @@ -138,7 +138,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_async_pf *work;
>  
> -	while (!list_empty_careful(&vcpu->async_pf.done) &&
> +	while (kvm_check_async_pf_completion_queue(vcpu) &&
>  	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
>  		spin_lock(&vcpu->async_pf.lock);
>  		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
> @@ -205,7 +205,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	struct kvm_async_pf *work;
>  	bool first;
>  
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return 0;
>  
>  	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> @@ -216,7 +216,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -	first = list_empty(&vcpu->async_pf.done);
> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>  	list_add_tail(&work->link, &vcpu->async_pf.done);
>  	spin_unlock(&vcpu->async_pf.lock);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b50dbe269f4b..8795503651b1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3282,10 +3282,8 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
>  	if (kvm_arch_dy_runnable(vcpu))
>  		return true;
>  
> -#ifdef CONFIG_KVM_ASYNC_PF
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return true;
> -#endif
>  
>  	return false;
>  }

-- 
Vitaly

