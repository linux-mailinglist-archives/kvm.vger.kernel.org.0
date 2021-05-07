Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADFC376169
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 09:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhEGHsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 03:48:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235625AbhEGHsB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 03:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620373622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MjTfOWRFplHW4qhrQ7zOMVBfSNAJ5R+pkXcG3p+0xi0=;
        b=KaHU0o2CaTdtt545qUKhcPaJTv/qc4egjVWQqsUi1P7Hh4fHZdnkitz8VnMmNnmfmFoMrf
        5Yer1mK2lYkVRqcJxn8uv0eZ2xtEvN4FAMooFu268Xu0xHuHRdU5bLmDKlVV4WMuDLcdfd
        wYumEAWHD6saxKQRcaHo51jUhcyXrvE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-apQZS3cUMhKWNpsNdFxteA-1; Fri, 07 May 2021 03:47:00 -0400
X-MC-Unique: apQZS3cUMhKWNpsNdFxteA-1
Received: by mail-wm1-f70.google.com with SMTP id b16-20020a7bc2500000b029014587f5376dso2747988wmj.1
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 00:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MjTfOWRFplHW4qhrQ7zOMVBfSNAJ5R+pkXcG3p+0xi0=;
        b=GWqD/pxyqcf/nsWGWZRcRI3W1BxwY9tJ7FZUmVRctzZxosQzC6kNoiI6D+Jh9c4HC1
         VkpixAM42xhMbX5Fql4/3BltPc7Yh1t7YEflA4kNyroOmgyFnRNlJPPjw7tYauTs9pf5
         q0Dpakcm+t/u08NEJQEWk3/FJ0rLcRJBEAgb0vNhE7OBvTKhAC/N/2LS5Be1jl+sdZyd
         9BZDBDkLvmNJI/7omiZl9l8lvEj6oGWLZMK2byH2BHZTqisa7pSWrHIMr1TabSzVVess
         fL2lFICsIeTnB/fsJYJTVi+F3VAwpe62iVDNibJ8VPnrg9QxNU63imnWTuG4ajSiGre+
         0wNg==
X-Gm-Message-State: AOAM530qX1ThPXFotAeyr1znjK3mte7vPaYX89ck4nzMuTeX5vDSuwzr
        4Cc9lQ8SkgtaVYIPLhZ+3nEqLDOkernlBmk8frfA06nxS/3ls8ToLCwfPi3aXSkHKYtv7C6RKUx
        Jn+sbHsJOzCpF
X-Received: by 2002:a7b:cf3a:: with SMTP id m26mr8536943wmg.49.1620373618863;
        Fri, 07 May 2021 00:46:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3ABXXREF6G0BEptIn/dlgqnNGYgI3mMFUWhMtILgC74LuGx9M/WBEq0+EnJc/mDur6Bezew==
X-Received: by 2002:a7b:cf3a:: with SMTP id m26mr8536923wmg.49.1620373618604;
        Fri, 07 May 2021 00:46:58 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c63c0.dip0.t-ipconnect.de. [91.12.99.192])
        by smtp.gmail.com with ESMTPSA id x4sm12287407wmj.17.2021.05.07.00.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:46:58 -0700 (PDT)
Subject: Re: [PATCH v3 2/8] KVM: x86/mmu: Factor out allocating memslot rmap
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-3-bgardon@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <97d085a0-185d-2546-f32e-ea1c55579ba0@redhat.com>
Date:   Fri, 7 May 2021 09:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506184241.618958-3-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.05.21 20:42, Ben Gardon wrote:
> Small refactor to facilitate allocating rmaps for all memslots at once.
> 
> No functional change expected.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/x86.c | 41 ++++++++++++++++++++++++++++++++---------
>   1 file changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5bcf07465c47..fc32a7dbe4c4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10842,10 +10842,37 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>   	kvm_page_track_free_memslot(slot);
>   }
>   
> +static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
> +			      unsigned long npages)

I'd have called the functions memslot_rmap_alloc() and memslot_rmap_free()


> +{
> +	int i;
> +
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> +		int lpages;
> +		int level = i + 1;
> +
> +		lpages = gfn_to_index(slot->base_gfn + npages - 1,
> +				      slot->base_gfn, level) + 1;
> +
> +		slot->arch.rmap[i] =
> +			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
> +				 GFP_KERNEL_ACCOUNT);
> +		if (!slot->arch.rmap[i])
> +			goto out_free;

you can just avoid the goto here and do the free_memslot_rmap() right away.

> +	}
> +
> +	return 0;
> +
> +out_free:
> +	free_memslot_rmap(slot);
> +	return -ENOMEM;
> +}
> +
>   static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>   				      unsigned long npages)
>   {
>   	int i;
> +	int r;
>   
>   	/*
>   	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
> @@ -10854,7 +10881,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>   	 */
>   	memset(&slot->arch, 0, sizeof(slot->arch));
>   
> -	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> +	r = alloc_memslot_rmap(slot, npages);
> +	if (r)
> +		return r;
> +
> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>   		struct kvm_lpage_info *linfo;
>   		unsigned long ugfn;
>   		int lpages;
> @@ -10863,14 +10894,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>   		lpages = gfn_to_index(slot->base_gfn + npages - 1,
>   				      slot->base_gfn, level) + 1;
>   
> -		slot->arch.rmap[i] =
> -			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
> -				 GFP_KERNEL_ACCOUNT);
> -		if (!slot->arch.rmap[i])
> -			goto out_free;
> -		if (i == 0)
> -			continue;
> -
>   		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
>   		if (!linfo)
>   			goto out_free;
> 

apart from that LGTM

-- 
Thanks,

David / dhildenb

