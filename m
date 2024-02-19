Return-Path: <kvm+bounces-9047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D253859EFE
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D706C281949
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81E5224C9;
	Mon, 19 Feb 2024 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/Ox/69o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEB2232B
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 09:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708333241; cv=none; b=lVaK1qNiNwnVkJaw5kzHr6WcAnyc8CvlQ0YlSJ3zmops3L51bFO6RJ2EVabCFM9kEHupGDuXi6xYG7rBUyFiSJNKlREN6HP4odYFtVMoA/zGhec9K2UH3ngYRaoo35VyIVBpkKsrcfKR+CkViXYe+iDxYvr+6cP7d0PDf1TIK9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708333241; c=relaxed/simple;
	bh=bQVchDmRpI3eFwvt/On1NFftv5is9+1ce6JpTNm01iU=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ifULGMR/s0uQbIXAIpQxxRRAe/W8CSEVPUXEFgIsjyA7IqbqFS1TNoZR/ZwY548H5XDZvltqtK93UWcp3T6AlCVqCRgY6j+LVsewSPSrBYu1uVhQ3CY3srCpKTZumRZNKbkgkR6mIqkVLSgc4tsdL4xxlwzYsL0cZcnrlYynHqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U/Ox/69o; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40fb3b5893eso19974695e9.0
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 01:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708333237; x=1708938037; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=io6PG17kPlTD2eQRx4OpTm4H59Obcg8d8aCXOG7mSRs=;
        b=U/Ox/69okdeKol3uIuPEjug8ROEPENQPDMrzIN/YwghNQoofcrDQBJeASnha9yOfeW
         mWrqwj0Il7rxT3OeDTeTbgwG5XHFkGRkC1JrxzwzagqS5Uru97c60e+LVJytGyPDFhr8
         CxcuFC2oj+KU2CGbjmj6PD2BPc/f1+p9D3YyOvrJOF6+WQ9IVTMCpjyafQjzmjlYxsmP
         SuiyG4k/tKPgMLCAp31U1eX7T8loJh1h6j5pIF1HsgjtSMBRrlEAih6KrLQUXXYr4lSC
         sliDPOsVUBOkHCFeCALDU5hNK3sDgYcp0IoJusqr5/F6S5VxfaPKMWbhDX5RLUMQS31/
         EKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708333237; x=1708938037;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=io6PG17kPlTD2eQRx4OpTm4H59Obcg8d8aCXOG7mSRs=;
        b=adaPA+mbfTZtAZfeh0aXuk+gsVOFFmyESYIEt5/ckVWc/0COvCJtuXEgJIp72rtxAc
         wFjmQL7tOw85E3IO/W9sDwvlu+ur/Db2fE9SwSc6Ht1Xu31+tZGto54IXUJwLcinIAsd
         84rxesfwJJ+XMeAZr1wfXRuLfXErzao8DituFcdcHP2pgZ/7f+CbmxvZGRg2g/iO7DlP
         pXMQ/qaewJ0dU34EUQub2XNz4jwrsXKAl4lin2uplObifRgUneFbqy+dW+3gwYKCPkxc
         250rX5T8b1krm0Nb/M45VLphbrXJ0Lbw6qUtRR3WBAanquVCS7vNlh89NBvdlfZQsXW3
         TGbA==
X-Forwarded-Encrypted: i=1; AJvYcCVoTgrpQMDrYo5wDv4K2VAJhnWnTlweOpa2KaT9pJgZmaT1bBc0KOLrsCIvJ8hqdXTtGLt1zf1yWCjBPKD//MuJZqtR
X-Gm-Message-State: AOJu0YyBa5ejlTzyUjEVgeulnrJ3ub9TPBsJWgjFUUz3Rt0TwZzX5Tr4
	gaZiV1xDYqqn2/WBmljhED0fge290t7Q7N5yNNGKfc8VhZB5k7aa
X-Google-Smtp-Source: AGHT+IHp12v9U8Mwo+jv3pya3QBaw4tGIQG7Vkbdip7znwiCBoUvoZeZxWYdX6xJxPqZ66SY1zUbVQ==
X-Received: by 2002:a05:600c:4507:b0:412:6170:a178 with SMTP id t7-20020a05600c450700b004126170a178mr2613767wmo.29.1708333236541;
        Mon, 19 Feb 2024 01:00:36 -0800 (PST)
Received: from [192.168.6.211] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id h5-20020a05600c350500b004124219a8c9sm10431210wmq.32.2024.02.19.01.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 01:00:36 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <fae10155-f5b3-4fc6-8a9c-dfcbb39b0718@xen.org>
Date: Mon, 19 Feb 2024 09:00:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 4/6] KVM: pfncache: simplify locking and make more
 self-contained
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
 David Woodhouse <dwmw@amazon.co.uk>
References: <20240217114017.11551-1-dwmw2@infradead.org>
 <20240217114017.11551-5-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20240217114017.11551-5-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/02/2024 11:27, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The locking on the gfn_to_pfn_cache is... interesting. And awful.
> 
> There is a rwlock in ->lock which readers take to ensure protection
> against concurrent changes. But __kvm_gpc_refresh() makes assumptions
> that certain fields will not change even while it drops the write lock
> and performs MM operations to revalidate the target PFN and kernel
> mapping.
> 
> Commit 93984f19e7bc ("KVM: Fully serialize gfn=>pfn cache refresh via
> mutex") partly addressed that — not by fixing it, but by adding a new
> mutex, ->refresh_lock. This prevented concurrent __kvm_gpc_refresh()
> calls on a given gfn_to_pfn_cache, but is still only a partial solution.
> 
> There is still a theoretical race where __kvm_gpc_refresh() runs in
> parallel with kvm_gpc_deactivate(). While __kvm_gpc_refresh() has
> dropped the write lock, kvm_gpc_deactivate() clears the ->active flag
> and unmaps ->khva. Then __kvm_gpc_refresh() determines that the previous
> ->pfn and ->khva are still valid, and reinstalls those values into the
> structure. This leaves the gfn_to_pfn_cache with the ->valid bit set,
> but ->active clear. And a ->khva which looks like a reasonable kernel
> address but is actually unmapped.
> 
> All it takes is a subsequent reactivation to cause that ->khva to be
> dereferenced. This would theoretically cause an oops which would look
> something like this:
> 
> [1724749.564994] BUG: unable to handle page fault for address: ffffaa3540ace0e0
> [1724749.565039] RIP: 0010:__kvm_xen_has_interrupt+0x8b/0xb0
> 
> I say "theoretically" because theoretically, that oops that was seen in
> production cannot happen. The code which uses the gfn_to_pfn_cache is
> supposed to have its *own* locking, to further paper over the fact that
> the gfn_to_pfn_cache's own papering-over (->refresh_lock) of its own
> rwlock abuse is not sufficient.
> 
> For the Xen vcpu_info that external lock is the vcpu->mutex, and for the
> shared info it's kvm->arch.xen.xen_lock. Those locks ought to protect
> the gfn_to_pfn_cache against concurrent deactivation vs. refresh in all
> but the cases where the vcpu or kvm object is being *destroyed*, in
> which case the subsequent reactivation should never happen.
> 
> Theoretically.
> 
> Nevertheless, this locking abuse is awful and should be fixed, even if
> no clear explanation can be found for how the oops happened. So expand
> the use of the ->refresh_lock mutex to ensure serialization of
> activate/deactivate vs. refresh and make the pfncache locking entirely
> self-sufficient.
> 
> This means that a future commit can simplify the locking in the callers,
> such as the Xen emulation code which has an outstanding problem with
> recursive locking of kvm->arch.xen.xen_lock, which will no longer be
> necessary.
> 
> The rwlock abuse described above is still not best practice, although
> it's harmless now that the ->refresh_lock is held for the entire duration
> while the offending code drops the write lock, does some other stuff,
> then takes the write lock again and assumes nothing changed. That can
> also be fixed^W cleaned up in a subsequent commit, but this commit is
> a simpler basis for the Xen deadlock fix mentioned above.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   virt/kvm/pfncache.c | 32 +++++++++++++++++++++-----------
>   1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index a60d8f906896..79a3ef7c6d04 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -255,12 +255,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
>   	if (page_offset + len > PAGE_SIZE)
>   		return -EINVAL;
>   
> -	/*
> -	 * If another task is refreshing the cache, wait for it to complete.
> -	 * There is no guarantee that concurrent refreshes will see the same
> -	 * gpa, memslots generation, etc..., so they must be fully serialized.
> -	 */
> -	mutex_lock(&gpc->refresh_lock);
> +	lockdep_assert_held(&gpc->refresh_lock);
>   
>   	write_lock_irq(&gpc->lock);
>   
> @@ -346,8 +341,6 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
>   out_unlock:
>   	write_unlock_irq(&gpc->lock);
>   
> -	mutex_unlock(&gpc->refresh_lock);
> -
>   	if (unmap_old)
>   		gpc_unmap(old_pfn, old_khva);
>   
> @@ -356,16 +349,24 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
>   
>   int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
>   {
> -	unsigned long uhva = gpc->uhva;
> +	unsigned long uhva;
> +	int ret;
> +
> +	mutex_lock(&gpc->refresh_lock);
>   
>   	/*
>   	 * If the GPA is valid then invalidate the HVA, otherwise
>   	 * __kvm_gpc_refresh() will fail its strict either/or address check.
>   	 */
> +	uhva = gpc->uhva;
>   	if (!kvm_is_error_gpa(gpc->gpa))
>   		uhva = KVM_HVA_ERR_BAD;
>   
> -	return __kvm_gpc_refresh(gpc, gpc->gpa, uhva, len);
> +	ret = __kvm_gpc_refresh(gpc, gpc->gpa, uhva, len);
> +
> +	mutex_unlock(&gpc->refresh_lock);
> +
> +	return ret;
>   }
>   
>   void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
> @@ -377,12 +378,16 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
>   	gpc->pfn = KVM_PFN_ERR_FAULT;
>   	gpc->gpa = INVALID_GPA;
>   	gpc->uhva = KVM_HVA_ERR_BAD;
> +	gpc->active = gpc->valid = false;

Not strictly necessary if the comment above the function prototype in 
kvm_host.h is to be believed, but no harm.

Reviewed-by: Paul Durrant <paul@xen.org>

>   }
>   


