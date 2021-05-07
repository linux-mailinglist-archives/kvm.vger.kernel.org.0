Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1D137616E
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 09:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhEGHt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 03:49:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235877AbhEGHtY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 03:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620373704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WD7r2JQtvlTzyvMK3Pf5d+3elrc1CD6XezsQIERJnSo=;
        b=fbUkQJoplCAaLdgVBbGoTH37k+HgwaOXm0H97upBLYBBYlQVR+e6X1ayBZIi5c1tcU0q9Z
        GvNfQGRkZ1Zt/C1F56tPSTFDn5UA/YCJXBTRsxpppCl0mC5xsfqX4HDvHeVNZrxpLniBbM
        znRfjXm+azdZFhZ9OgIcKKMcE2DxdiY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-NwQ2hqKhOaGiI7ySZ-eVKg-1; Fri, 07 May 2021 03:48:22 -0400
X-MC-Unique: NwQ2hqKhOaGiI7ySZ-eVKg-1
Received: by mail-wr1-f72.google.com with SMTP id n2-20020adfb7420000b029010e47b59f31so556725wre.9
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 00:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WD7r2JQtvlTzyvMK3Pf5d+3elrc1CD6XezsQIERJnSo=;
        b=aQ3OpbXHXKFhpRg5z5cuG/e/lim1FeGEfI54jLgaAjQ6yJUvfxDX0HDNoADVCsiUfh
         XM9ms4HyPkYvg8SKLQGQZK4d14d1Nsv0U/vAkvD7JSK9Y9gF4QO/6R3BHYJLgIoR85LY
         jbDoTSFXyUHH3BaZtw5aiLq6xfq0EX+3KqfSZ2YcYlbb2GAD8t0Z5FJ3mjIKC1nam811
         jMIhwHzWYAIDIXZbb6aDy5R5wqgJ1Cu9vi74B/X5N471+x9ry7Gkvpc8KD3PNAEoLW81
         6SdAzBGD+694ZWzLP6yC1MYuF6K3TQ7cF4eBngDQnxLkMakoX6Ngelkah7qaq2N5qWQU
         AE1A==
X-Gm-Message-State: AOAM5309x05ugmMNYiHD8sjdanee9zScbX4a/wLsNojfbhyqMGzjhWLz
        bSVLJgiyudReVso/isf5UOVWSxDYTl4PukSYnk5oaTa7K5ex+I2tkbgCuItRtBXE+MjL119j5xt
        mLHyH4g+MYYVW
X-Received: by 2002:adf:ed43:: with SMTP id u3mr10521144wro.334.1620373701383;
        Fri, 07 May 2021 00:48:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7Xp4Xil7ssE0k+V5LYNHt8+OhdUr7lfJvCRSeJy9RusgymqI+68/egfYrjCnZ7siNjWEuqA==
X-Received: by 2002:adf:ed43:: with SMTP id u3mr10521116wro.334.1620373701194;
        Fri, 07 May 2021 00:48:21 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c63c0.dip0.t-ipconnect.de. [91.12.99.192])
        by smtp.gmail.com with ESMTPSA id s6sm13145893wms.0.2021.05.07.00.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:48:20 -0700 (PDT)
Subject: Re: [PATCH v3 3/8] KVM: mmu: Refactor memslot copy
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
 <20210506184241.618958-4-bgardon@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <7c2be781-7a10-a1b3-a8e8-d26ff4100746@redhat.com>
Date:   Fri, 7 May 2021 09:48:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506184241.618958-4-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.05.21 20:42, Ben Gardon wrote:
> Factor out copying kvm_memslots from allocating the memory for new ones
> in preparation for adding a new lock to protect the arch-specific fields
> of the memslots.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   virt/kvm/kvm_main.c | 23 ++++++++++++++++-------
>   1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2799c6660cce..c8010f55e368 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1306,6 +1306,18 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>   	return old_memslots;
>   }
>   
> +static size_t kvm_memslots_size(int slots)
> +{
> +	return sizeof(struct kvm_memslots) +
> +	       (sizeof(struct kvm_memory_slot) * slots);

no need for the extra set of parentheses

> +}
> +
> +static void kvm_copy_memslots(struct kvm_memslots *from,
> +			      struct kvm_memslots *to)
> +{
> +	memcpy(to, from, kvm_memslots_size(from->used_slots));
> +}
> +
>   /*
>    * Note, at a minimum, the current number of used slots must be allocated, even
>    * when deleting a memslot, as we need a complete duplicate of the memslots for
> @@ -1315,19 +1327,16 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>   					     enum kvm_mr_change change)
>   {
>   	struct kvm_memslots *slots;
> -	size_t old_size, new_size;
> -
> -	old_size = sizeof(struct kvm_memslots) +
> -		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> +	size_t new_size;
>   
>   	if (change == KVM_MR_CREATE)
> -		new_size = old_size + sizeof(struct kvm_memory_slot);
> +		new_size = kvm_memslots_size(old->used_slots + 1);
>   	else
> -		new_size = old_size;
> +		new_size = kvm_memslots_size(old->used_slots);
>   
>   	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
>   	if (likely(slots))
> -		memcpy(slots, old, old_size);
> +		kvm_copy_memslots(old, slots);
>   
>   	return slots;
>   }
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

