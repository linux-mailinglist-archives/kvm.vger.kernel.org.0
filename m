Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46181113E88
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 10:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfLEJt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 04:49:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45324 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfLEJt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 04:49:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so2629126wrj.12;
        Thu, 05 Dec 2019 01:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VDCRarATB8BrPGGFa2oJ0ZXIsVlkqssojKkWxJIt7Sw=;
        b=IUFpBprd5cUy49LefBNJcPOz24gxeLYCdnSeVp1swiaikpzNAnnAlqYiGzP2niYWe1
         UvdkMutU0vvWqvDe5BEGqWYvlx9yhm3cpLv7F5nFIBe47KnZpscevQ5mDt8wa25lMhfe
         OnnNqqFGtiXDZ6ApeG7JZWxVHK7UdgDoHf/HFRbFRwa7A81/W5jojgvuKTj1Auy2wECl
         4MMqj9BXx1Ejr3J6Qjk2ENvFaFaLhp8IbqYv51GqaO3KSvVxPFoGi6+bvxgWyiFHdgmU
         Zrh76yVlrfzDW+Ku65z/PfC4NnPmC69s+TonPU3vk+mwQfNOcN3DGhmpFhEMmaaVHTqP
         KD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VDCRarATB8BrPGGFa2oJ0ZXIsVlkqssojKkWxJIt7Sw=;
        b=Vi+iH/u9yqWDx8X+gcaQ2OrvWw4/YvLvaMHM1h38IHHFWd4GK4lRSihqOZ1d7GIW+C
         p0F6RUlayRp/l9DB89++Xgk3FAViUaYmo1N+k0ne8U/tFxe8uw9zwEK1xVuJUSM7+uVe
         ZwCuJzu+yEJMD5m53B47XCz3rOUsfUqFDKGGl+5KsO7ebi/NeOYD3foqFjDqsSStf71e
         lo5OSCbaZWo0vLTjAVawuEJhjwGJk+K0CJIlE1aZ3j13MdpYbb+GGWcIaVB1CgURQaLx
         hBsN0ppflUtGhp5j18rzWKeKJvlTAc/xohZzO/Q9nnv2NKrZVEp2CzTYaMijHOiaOKvN
         9Axg==
X-Gm-Message-State: APjAAAW0cU2rB9a43M4mZg/SIAFU+PbkuNocqJb5BxLpnP5EVLnP/y9/
        ius1XdlOocaLuEtAWPrM0b6hEdUO
X-Google-Smtp-Source: APXvYqxBtpkgOdAW7CRYJrvAlE0K8uKX4b6YMw5evwxxJGel49FacekG2njBKu1+ODO53PFLBi35DQ==
X-Received: by 2002:adf:eb46:: with SMTP id u6mr9246213wrn.239.1575539393159;
        Thu, 05 Dec 2019 01:49:53 -0800 (PST)
Received: from [192.168.1.35] (182.red-88-21-103.staticip.rima-tde.net. [88.21.103.182])
        by smtp.gmail.com with ESMTPSA id u18sm11562183wrt.26.2019.12.05.01.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 01:49:52 -0800 (PST)
Subject: Re: [PATCH v3 07/15] KVM: Refactor error handling for setting memory
 region
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
 <20191024230744.14543-8-sean.j.christopherson@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <3b6cd050-2551-d262-aded-051e25044519@amsat.org>
Date:   Thu, 5 Dec 2019 10:49:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191024230744.14543-8-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/19 1:07 AM, Sean Christopherson wrote:
> Replace a big pile o' gotos with returns to make it more obvious what
> error code is being returned, and to prepare for refactoring the
> functional, i.e. post-checks, portion of __kvm_set_memory_region().
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   virt/kvm/kvm_main.c | 40 ++++++++++++++++++----------------------
>   1 file changed, 18 insertions(+), 22 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a43902d9036d..e2f47d60f696 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -942,34 +942,33 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   
>   	r = check_memory_region_flags(mem);
>   	if (r)
> -		goto out;
> +		return r;
>   
> -	r = -EINVAL;
>   	as_id = mem->slot >> 16;
>   	id = (u16)mem->slot;
>   
>   	/* General sanity checks */
>   	if (mem->memory_size & (PAGE_SIZE - 1))
> -		goto out;
> +		return -EINVAL;
>   	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
> -		goto out;
> +		return -EINVAL;
>   	/* We can read the guest memory with __xxx_user() later on. */
>   	if ((id < KVM_USER_MEM_SLOTS) &&
>   	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
>   	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
>   			mem->memory_size)))
> -		goto out;
> +		return -EINVAL;
>   	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
> -		goto out;
> +		return -EINVAL;
>   	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
> -		goto out;
> +		return -EINVAL;
>   
>   	slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
>   	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
>   	npages = mem->memory_size >> PAGE_SHIFT;
>   
>   	if (npages > KVM_MEM_MAX_NR_PAGES)
> -		goto out;
> +		return -EINVAL;
>   
>   	new = old = *slot;
>   
> @@ -986,20 +985,18 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   			if ((new.userspace_addr != old.userspace_addr) ||
>   			    (npages != old.npages) ||
>   			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
> -				goto out;
> +				return -EINVAL;
>   
>   			if (base_gfn != old.base_gfn)
>   				change = KVM_MR_MOVE;
>   			else if (new.flags != old.flags)
>   				change = KVM_MR_FLAGS_ONLY;
> -			else { /* Nothing to change. */
> -				r = 0;
> -				goto out;
> -			}
> +			else /* Nothing to change. */
> +				return 0;
>   		}
>   	} else {
>   		if (!old.npages)
> -			goto out;
> +			return -EINVAL;
>   
>   		change = KVM_MR_DELETE;
>   		new.base_gfn = 0;
> @@ -1008,29 +1005,29 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   
>   	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
>   		/* Check for overlaps */
> -		r = -EEXIST;
>   		kvm_for_each_memslot(slot, __kvm_memslots(kvm, as_id)) {
>   			if (slot->id == id)
>   				continue;
>   			if (!((base_gfn + npages <= slot->base_gfn) ||
>   			      (base_gfn >= slot->base_gfn + slot->npages)))
> -				goto out;
> +				return -EEXIST;
>   		}
>   	}
>   
> -	r = -ENOMEM;
> -
>   	/* Allocate/free page dirty bitmap as needed */
>   	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
>   		new.dirty_bitmap = NULL;
>   	else if (!new.dirty_bitmap) {
> -		if (kvm_create_dirty_bitmap(&new) < 0)
> -			goto out;
> +		r = kvm_create_dirty_bitmap(&new);
> +		if (r)
> +			return r;

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

>   	}
>   
>   	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> -	if (!slots)
> +	if (!slots) {
> +		r = -ENOMEM;
>   		goto out_bitmap;
> +	}
>   	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
>   
>   	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> @@ -1081,7 +1078,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   out_bitmap:
>   	if (new.dirty_bitmap && !old.dirty_bitmap)
>   		kvm_destroy_dirty_bitmap(&new);
> -out:
>   	return r;
>   }
>   EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
> 
