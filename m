Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF7D113ECB
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 10:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfLEJyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 04:54:54 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50434 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbfLEJyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 04:54:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so2940735wmg.0;
        Thu, 05 Dec 2019 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DQAhGy9NIgRWmctc8n8PEHCVr8wavboJn+39LOkMnnE=;
        b=hac7YA/61scaeO1ZPDjnWRMzcy75dsYruAt43uzR4MuSNEz5hLw5EdT0z6Pk1oKaf2
         fTx/UHnJFbfc4yz5OxSDaux8zk2LpeT53fJ2LG+/5yqQgpjOTz3h53GTnIdVAcTKJu7t
         xG/FEOdrDW23jBF3o46Cmb8RLZ0MeIO1x8zWgY8AzwOkcpJXe8WvLpubqc2McKiHLLNr
         eXSDqObg1oCx4MHRo8Iua/WzAIC2j2e4ETJSFvHsUBnEfO5ALS1gU+pCdLNKtcDPo9fg
         ea2NuzaE3VVvgcbVAosn8fyIucElmMVU0IXGeAX739GIzKDJD5KlcSees5Ss3hDd40c5
         9IwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQAhGy9NIgRWmctc8n8PEHCVr8wavboJn+39LOkMnnE=;
        b=hF73vov5gw6rh9rLXvUqvE2eengLL8UZdDKPKSNZIjb8anHpRibYxP+NQPai7ddkoU
         0y/n0M8lHMqOlyuQ3yjqxdR6RoRksjIL+/qAUUTiAcBLlTRzYUfUPf/aLucOVjjUoupV
         crzEDFJ9Spp3cqWynF57/Cj+ITn1JLidFjSDH4D+v2walAToRDkD3rUnLwIRrRYbc0Kc
         FoMJN6OzvGTWySCdo0egpWRHT9hs6buvv0Hst0kYTRkh2K+RC8bTenqJK8qVqmy0M/ZB
         3dkY2jF+HdTdVbBimHIzDHuArW+MkW4jlyFUPsZM76nqiakTMGRo2CIHLNRsR5e4pkpS
         4Urg==
X-Gm-Message-State: APjAAAXCoAznZsNjRacC2bEQ3E4kZuJ7YDEZCYJH8U8vk0uNuwfWUaoz
        p+mDtOpcuAeGsZJdqSiFEgE=
X-Google-Smtp-Source: APXvYqx3wMGWvFWz+VWzb3/gBJ7AfPMRQqK+25vc1Q2imL/LDYGpX95tPaj1m7INL2O5Ql2/5WubRg==
X-Received: by 2002:a05:600c:282:: with SMTP id 2mr3954319wmk.73.1575539690435;
        Thu, 05 Dec 2019 01:54:50 -0800 (PST)
Received: from [192.168.1.35] (182.red-88-21-103.staticip.rima-tde.net. [88.21.103.182])
        by smtp.gmail.com with ESMTPSA id u26sm9723665wmj.9.2019.12.05.01.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 01:54:49 -0800 (PST)
Subject: Re: [PATCH v3 08/15] KVM: Move setting of memslot into helper routine
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
 <20191024230744.14543-9-sean.j.christopherson@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <a606c931-ffeb-95e9-79eb-df68fed7af65@amsat.org>
Date:   Thu, 5 Dec 2019 10:54:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191024230744.14543-9-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/19 1:07 AM, Sean Christopherson wrote:
> Split out the core functionality of setting a memslot into a separate
> helper in preparation for moving memslot deletion into its own routine.
> 
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   virt/kvm/kvm_main.c | 106 ++++++++++++++++++++++++++------------------
>   1 file changed, 63 insertions(+), 43 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e2f47d60f696..860de4fadce6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -920,6 +920,66 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>   	return old_memslots;
>   }
>   
> +static int kvm_set_memslot(struct kvm *kvm,
> +			   const struct kvm_userspace_memory_region *mem,
> +			   const struct kvm_memory_slot *old,
> +			   struct kvm_memory_slot *new, int as_id,
> +			   enum kvm_mr_change change)
> +{
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	int r;
> +
> +	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> +	if (!slots)
> +		return -ENOMEM;
> +	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> +
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> +		/*
> +		 * Note, the INVALID flag needs to be in the appropriate entry
> +		 * in the freshly allocated memslots, not in @old or @new.
> +		 */
> +		slot = id_to_memslot(slots, old->id);
> +		slot->flags |= KVM_MEMSLOT_INVALID;
> +
> +		/*
> +		 * We can re-use the old memslots, the only difference from the
> +		 * newly installed memslots is the invalid flag, which will get
> +		 * dropped by update_memslots anyway.  We'll also revert to the
> +		 * old memslots if preparing the new memory region fails.
> +		 */
> +		slots = install_new_memslots(kvm, as_id, slots);
> +
> +		/* From this point no new shadow pages pointing to a deleted,
> +		 * or moved, memslot will be created.
> +		 *
> +		 * validation of sp->gfn happens in:
> +		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> +		 *	- kvm_is_visible_gfn (mmu_check_roots)
> +		 */
> +		kvm_arch_flush_shadow_memslot(kvm, slot);
> +	}
> +
> +	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
> +	if (r)
> +		goto out_slots;
> +
> +	update_memslots(slots, new, change);
> +	slots = install_new_memslots(kvm, as_id, slots);
> +
> +	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
> +
> +	kvfree(slots);
> +	return 0;
> +
> +out_slots:
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +		slots = install_new_memslots(kvm, as_id, slots);
> +	kvfree(slots);
> +	return r;
> +}
> +
>   /*
>    * Allocate some memory and give it an address in the guest physical address
>    * space.
> @@ -936,7 +996,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	unsigned long npages;
>   	struct kvm_memory_slot *slot;
>   	struct kvm_memory_slot old, new;
> -	struct kvm_memslots *slots;
>   	int as_id, id;
>   	enum kvm_mr_change change;
>   
> @@ -1023,58 +1082,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   			return r;
>   	}
>   
> -	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> -	if (!slots) {
> -		r = -ENOMEM;
> -		goto out_bitmap;
> -	}
> -	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> -
> -	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> -		slot = id_to_memslot(slots, id);
> -		slot->flags |= KVM_MEMSLOT_INVALID;
> -
> -		/*
> -		 * We can re-use the old memslots, the only difference from the
> -		 * newly installed memslots is the invalid flag, which will get
> -		 * dropped by update_memslots anyway.  We'll also revert to the
> -		 * old memslots if preparing the new memory region fails.
> -		 */
> -		slots = install_new_memslots(kvm, as_id, slots);
> -
> -		/* From this point no new shadow pages pointing to a deleted,
> -		 * or moved, memslot will be created.
> -		 *
> -		 * validation of sp->gfn happens in:
> -		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> -		 *	- kvm_is_visible_gfn (mmu_check_roots)
> -		 */
> -		kvm_arch_flush_shadow_memslot(kvm, slot);
> -	}
> -
> -	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
> -	if (r)
> -		goto out_slots;
> -
>   	/* actual memory is freed via old in kvm_free_memslot below */
>   	if (change == KVM_MR_DELETE) {
>   		new.dirty_bitmap = NULL;
>   		memset(&new.arch, 0, sizeof(new.arch));
>   	}
>   
> -	update_memslots(slots, &new, change);
> -	slots = install_new_memslots(kvm, as_id, slots);
> -
> -	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
> +	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
> +	if (r)
> +		goto out_bitmap;
>   
>   	kvm_free_memslot(kvm, &old, &new);
> -	kvfree(slots);
>   	return 0;
>   
> -out_slots:
> -	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> -		slots = install_new_memslots(kvm, as_id, slots);
> -	kvfree(slots);
>   out_bitmap:
>   	if (new.dirty_bitmap && !old.dirty_bitmap)
>   		kvm_destroy_dirty_bitmap(&new);
> 

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
