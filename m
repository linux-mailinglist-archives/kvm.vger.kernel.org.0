Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA18154EC1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgBFWMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:12:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39287 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727505AbgBFWMW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 17:12:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581027141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xnxqE/nCX2EzFDbA9kwFrPUv5TZytfq4VJeA0RRzpMU=;
        b=E4ZDUGpmp2oHoTMhETV2mrexFeQo6QizBUAS1AngJSea8F8fHZNwkElTcLVOG4QxURnA46
        4tzRZSHrgfhX0cm7C3LMj6ZAhYB/9/Y3jPqbyZjC+8GTMIyWFbSDU2oSiFuoGwJv6uWDbu
        4JlbyfRqwW21aWWNVr6YvRzUmlyEITg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-Iv81YtAfNAmCVz5rzUR1XQ-1; Thu, 06 Feb 2020 17:12:15 -0500
X-MC-Unique: Iv81YtAfNAmCVz5rzUR1XQ-1
Received: by mail-qk1-f197.google.com with SMTP id y6so5405qki.13
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 14:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xnxqE/nCX2EzFDbA9kwFrPUv5TZytfq4VJeA0RRzpMU=;
        b=dd+bs5HXoOxDbKQmTLU4mOoxdjelx9fhA8ZnBr8SX0En3QUee3sRffSJkZSdC2vRRK
         MVjy4JKcezKps4gse7pCzaGJxhcdfzXW8BduWYsR2YG3pFTfcMZCY85JHZrDv8kgSUBe
         ac4XpYF4TTXiWZFPN/vnFh5N9cg8Xf6hPpNZAmyFyJh/WV4zHSJ8UaIpM3c7Qb9Ies9R
         NrI2OHVY4Q7G55407dJi9qWm0RIo/mTrRMXEdAZeidclPVQ0VIMjypq/UAVvqB9jeQAq
         yH9znR6f9CVDJfSSIL3w08WpRMjcqxcg/j+wqzTNh4TedEnK289WZrmfOh3O/tEaDXb8
         eOgw==
X-Gm-Message-State: APjAAAXcSOr2rKeIzTvzLfO1jt8Q4kMbUpEo9tRAOL2HCQrJNZ+Sex/+
        MpZKEIILjpXAU8G3RzSB9kB1BfQplBfoFydIAlp/TKSqMEA5Dn1O/cTuYugA0N3g7mf9Ok3qQIX
        OjxE+B/Du8HMS
X-Received: by 2002:ac8:1c1d:: with SMTP id a29mr4676765qtk.183.1581027135107;
        Thu, 06 Feb 2020 14:12:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/2cyK6F4lh5rp4dz7WvwTupqk8fbtvVzQEcyTi4bd7WqahSqSpQi7XlP32hR4RTgKgW30Yg==
X-Received: by 2002:ac8:1c1d:: with SMTP id a29mr4676750qtk.183.1581027134836;
        Thu, 06 Feb 2020 14:12:14 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id w1sm357608qtk.31.2020.02.06.14.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 14:12:14 -0800 (PST)
Date:   Thu, 6 Feb 2020 17:12:08 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200206221208.GI700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-19-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:56PM -0800, Sean Christopherson wrote:
> Now that the memslot logic doesn't assume memslots are always non-NULL,
> dynamically size the array of memslots instead of unconditionally
> allocating memory for the maximum number of memslots.
> 
> Note, because a to-be-deleted memslot must first be invalidated, the
> array size cannot be immediately reduced when deleting a memslot.
> However, consecutive deletions will realize the memory savings, i.e.
> a second deletion will trim the entry.
> 
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> Tested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/kvm_host.h |  2 +-
>  virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++++---
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 60ddfdb69378..8bb6fb127387 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -431,11 +431,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   */
>  struct kvm_memslots {
>  	u64 generation;
> -	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
>  	/* The mapping table from slot id to the index in memslots[]. */
>  	short id_to_index[KVM_MEM_SLOTS_NUM];
>  	atomic_t lru_slot;
>  	int used_slots;
> +	struct kvm_memory_slot memslots[];

This patch is tested so I believe this works, however normally I need
to do similar thing with [0] otherwise gcc might complaint.  Is there
any trick behind to make this work?  Or is that because of different
gcc versions?

>  };
>  
>  struct kvm {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9b614cf2ca20..ed392ce64e59 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -565,7 +565,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
>  		return NULL;
>  
>  	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> -		slots->id_to_index[i] = slots->memslots[i].id = -1;
> +		slots->id_to_index[i] = -1;
>  
>  	return slots;
>  }
> @@ -1077,6 +1077,32 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	return old_memslots;
>  }
>  
> +/*
> + * Note, at a minimum, the current number of used slots must be allocated, even
> + * when deleting a memslot, as we need a complete duplicate of the memslots for
> + * use when invalidating a memslot prior to deleting/moving the memslot.
> + */
> +static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
> +					     enum kvm_mr_change change)
> +{
> +	struct kvm_memslots *slots;
> +	size_t old_size, new_size;
> +
> +	old_size = sizeof(struct kvm_memslots) +
> +		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> +
> +	if (change == KVM_MR_CREATE)
> +		new_size = old_size + sizeof(struct kvm_memory_slot);
> +	else
> +		new_size = old_size;
> +
> +	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
> +	if (likely(slots))
> +		memcpy(slots, old, old_size);

(Maybe directly copy into it?)

> +
> +	return slots;
> +}
> +
>  static int kvm_set_memslot(struct kvm *kvm,
>  			   const struct kvm_userspace_memory_region *mem,
>  			   struct kvm_memory_slot *old,
> @@ -1087,10 +1113,9 @@ static int kvm_set_memslot(struct kvm *kvm,
>  	struct kvm_memslots *slots;
>  	int r;
>  
> -	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> +	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
>  	if (!slots)
>  		return -ENOMEM;
> -	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
>  
>  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>  		/*
> -- 
> 2.24.1
> 

-- 
Peter Xu

