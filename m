Return-Path: <kvm+bounces-26232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DD0973573
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 676421C25140
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575AC188A28;
	Tue, 10 Sep 2024 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JoH/IowN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA81A143880
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965374; cv=none; b=q3XO2gnVwBrog/aq04rqrB0pGFyrF7htUK18dsTM3UhKZc3xLL2jhAM049FqCtmvhU8D0EG54adi4t6GvygEX34KYaCXbv1FdGSq4uOABi3WjMBT5a/tA82i329ZIYeddQAFcBHk4CUiv6s+jWnGEYfVD+3akBy50VKfd2Ms6XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965374; c=relaxed/simple;
	bh=h2I4l+F4I3vf8PFeFEB+/ZN6u70oYt1viZx4df4lcOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZDj8q1Ms2IR3DafZE9BgZqbYKq/yxchLR9f+9tXkSOltqKSIBCsitmsJgy8pe6xSXNvEt3662juiAT5S7B7iyTpC1cpXfrb/CnD/ZYv1UcpFnGwprF8VEHUtY3Hj7UH+DB7NuGOpeoGL+DaKb3NnXl+n0g5z3hprr+6rjjEYy1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JoH/IowN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725965371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LOmcBxv9dCrK96rLts0gHO5lvQM5BwbFhTJhXF46Ga0=;
	b=JoH/IowNKVa6cDur2wSFN9SLc1C+PAfDU189YgD2ETDikv+LYdgKnB6LdGBVlnkwjPWzgo
	CH9FCSp8YeiMZOWkaTztsLf9gRX0xqxp6dCEU7VbECsEuKBShi10Nu1mV+uQzM2XxIh31Z
	TyhxCh8yeVz/koQObgdo5w6UT1WpPZk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-Oc4FUPvXPDK_HDxJLi-H3A-1; Tue, 10 Sep 2024 06:49:28 -0400
X-MC-Unique: Oc4FUPvXPDK_HDxJLi-H3A-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42caf073db8so26277065e9.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725965367; x=1726570167;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LOmcBxv9dCrK96rLts0gHO5lvQM5BwbFhTJhXF46Ga0=;
        b=e+BgMQt/S3S6aF5GM/w+3WGek2fbZrYbnWetzGslK/gKPS8nFtuOjNR8/D9AnVVpGk
         +5YwEqUa6PT3JpGDnwEkGIoCm7JNeA9IUT2UrfIzAA+QvNtanyw/P22qjrXt9SgkE5C1
         6yfKl3/dYqE3Daf9uDOsEP9JZ247kx4gbqiIz6+aRJxY7BlnjU3LvYtWakegAXFTBjmN
         bLrtTl5ns5NVhh9idMw8HyGMkYhtYR9KQ5Q+L3zoklLLxb8RRiOoe5Qt4l241KFfHvtw
         WTPfkkatgp/DU6HDwA+gT0TqttVp9zosa/7nVO5vYDzWvnaz0Sc8QoPpeQ3JNy2NzimW
         wyOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCDdM6o1xAwyt5HFXMJ30JcwqH/SsuVf8PbQ8bSHoDNb9BNuf0kYaK3A9pY7keK7EpGUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYXYlW+kAqJZOE0Xb0aCMsvajnGs7obG/hO6wadDpyYkOJhnA3
	Fej7+Iq9UoQ/T9wk54ZXsgvCioTPs9eiZraQ5UvGnmL6kp4m/lu2g/VbBGn533vTX9Rvm/P124i
	6QU+sR4dOwKvrsfK6BxtRUi/QguxMZ5i5S7QYR4l6pfsYIX2Qtg==
X-Received: by 2002:a05:600c:3ca7:b0:428:f0c2:ef4a with SMTP id 5b1f17b1804b1-42c9f97caa0mr112636285e9.13.1725965367241;
        Tue, 10 Sep 2024 03:49:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3TF6YkVmUetJXRdL2vleI3SxkX6kg071NsA6CgMW58eqsqFgskcQSrZBYjV9Ty+GkWXBGUA==
X-Received: by 2002:a05:600c:3ca7:b0:428:f0c2:ef4a with SMTP id 5b1f17b1804b1-42c9f97caa0mr112636015e9.13.1725965366668;
        Tue, 10 Sep 2024 03:49:26 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb32678sm107181275e9.16.2024.09.10.03.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:49:25 -0700 (PDT)
Message-ID: <09df9848-b425-4f8b-8fb5-dcd6929478de@redhat.com>
Date: Tue, 10 Sep 2024 12:49:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-17-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Update TDX's hook of set_external_spte() to record pre-mapping cnt instead
> of doing nothing and returning when TD is not finalized.
> 
> TDX uses ioctl KVM_TDX_INIT_MEM_REGION to initialize its initial guest
> memory. This ioctl calls kvm_gmem_populate() to get guest pages and in
> tdx_gmem_post_populate(), it will
> (1) Map page table pages into KVM mirror page table and private EPT.
> (2) Map guest pages into KVM mirror page table. In the propagation hook,
>      just record pre-mapping cnt without mapping the guest page into private
>      EPT.
> (3) Map guest pages into private EPT and decrease pre-mapping cnt.
> 
> Do not map guest pages into private EPT directly in step (2), because TDX
> requires TDH.MEM.PAGE.ADD() to add a guest page before TD is finalized,
> which copies page content from a source page from user to target guest page
> to be added. However, source page is not available via common interface
> kvm_tdp_map_page() in step (2).
> 
> Therefore, just pre-map the guest page into KVM mirror page table and
> record the pre-mapping cnt in TDX's propagation hook. The pre-mapping cnt
> would be decreased in ioctl KVM_TDX_INIT_MEM_REGION when the guest page is
> mapped into private EPT.

Stale commit message; squashing all of it into patch 20 is an easy cop 
out...

Paolo

> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Update the code comment and patch log according to latest gmem update.
>     https://lore.kernel.org/kvm/CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com/
>   - Rename tdx_mem_page_add() to tdx_mem_page_record_premap_cnt() to avoid
>     confusion.
>   - Change the patch title to "KVM: TDX: Premap initial guest memory".
>   - Rename KVM_MEMORY_MAPPING => KVM_MAP_MEMORY (Sean)
>   - Drop issueing TDH.MEM.PAGE.ADD() on KVM_MAP_MEMORY(), defer it to
>     KVM_TDX_INIT_MEM_REGION. (Sean)
>   - Added nr_premapped to track the number of premapped pages
>   - Drop tdx_post_mmu_map_page().
> 
> v19:
>   - Switched to use KVM_MEMORY_MAPPING
>   - Dropped measurement extension
>   - updated commit message. private_page_add() => set_private_spte()
> ---
>   arch/x86/kvm/vmx/tdx.c | 40 +++++++++++++++++++++++++++++++++-------
>   arch/x86/kvm/vmx/tdx.h |  2 +-
>   2 files changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 59b627b45475..435112562954 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -488,6 +488,34 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
>   	return 0;
>   }
>   
> +/*
> + * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to get guest pages and
> + * tdx_gmem_post_populate() to premap page table pages into private EPT.
> + * Mapping guest pages into private EPT before TD is finalized should use a
> + * seamcall TDH.MEM.PAGE.ADD(), which copies page content from a source page
> + * from user to target guest pages to be added. This source page is not
> + * available via common interface kvm_tdp_map_page(). So, currently,
> + * kvm_tdp_map_page() only premaps guest pages into KVM mirrored root.
> + * A counter nr_premapped is increased here to record status. The counter will
> + * be decreased after TDH.MEM.PAGE.ADD() is called after the kvm_tdp_map_page()
> + * in tdx_gmem_post_populate().
> + */
> +static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
> +					  enum pg_level level, kvm_pfn_t pfn)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	/* Returning error here to let TDP MMU bail out early. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm)) {
> +		tdx_unpin(kvm, pfn);
> +		return -EINVAL;
> +	}
> +
> +	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
> +	atomic64_inc(&kvm_tdx->nr_premapped);
> +	return 0;
> +}
> +
>   int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   			      enum pg_level level, kvm_pfn_t pfn)
>   {
> @@ -510,11 +538,7 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (likely(is_td_finalized(kvm_tdx)))
>   		return tdx_mem_page_aug(kvm, gfn, level, pfn);
>   
> -	/*
> -	 * TODO: KVM_MAP_MEMORY support to populate before finalize comes
> -	 * here for the initial memory.
> -	 */
> -	return 0;
> +	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
>   }
>   
>   static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> @@ -546,10 +570,12 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (unlikely(!is_td_finalized(kvm_tdx) &&
>   		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
>   		/*
> -		 * This page was mapped with KVM_MAP_MEMORY, but
> -		 * KVM_TDX_INIT_MEM_REGION is not issued yet.
> +		 * Page is mapped by KVM_TDX_INIT_MEM_REGION, but hasn't called
> +		 * tdh_mem_page_add().
>   		 */
>   		if (!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) {
> +			WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
> +			atomic64_dec(&kvm_tdx->nr_premapped);
>   			tdx_unpin(kvm, pfn);
>   			return 0;
>   		}
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 66540c57ed61..25a4aaede2ba 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -26,7 +26,7 @@ struct kvm_tdx {
>   
>   	u64 tsc_offset;
>   
> -	/* For KVM_MAP_MEMORY and KVM_TDX_INIT_MEM_REGION. */
> +	/* For KVM_TDX_INIT_MEM_REGION. */
>   	atomic64_t nr_premapped;
>   
>   	struct kvm_cpuid2 *cpuid;


