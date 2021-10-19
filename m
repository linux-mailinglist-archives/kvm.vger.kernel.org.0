Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71953434254
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 01:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhJSX51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 19:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJSX50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 19:57:26 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB52AC06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:55:11 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m14so1353574pfc.9
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FD+dLvVnnCC/StfyVK70KDJDUKEKowHXu1o53Gq30mA=;
        b=VB/HUAggfIPegcPbYKVjT4DV1b471yus1m7ifa3zfMqwPSXH+lm+/mouqjOlJinjys
         j2XfS5PC2W8r+Y71yY+AQCUO2gu2MmCIYBGf/BPIYB/2CiwoW2mk1h4aFtrSX1lsscq+
         TiE82aKzNVh3Og7as7mxcMpp6nUSLSrL6KG+wGVc8yYQwsNRi5N27h885DNfXpPrj5+c
         dxnHXynpgQN2WhJFmII1m9yYb3zG6QfF3aOLBWtiAvxD3R4YEpvamUh3XDpnLbxj5iSw
         sLyCjfNcgqtBQVN8x4HGTgPUcRxrKWgorj80o2O+K7XLXhkTxNZZ4ru5JrxdiXlNBtyX
         IzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FD+dLvVnnCC/StfyVK70KDJDUKEKowHXu1o53Gq30mA=;
        b=5G6M77qA03zHI/HPKnFYod09WLSQbk5Db7HsPE1RN7nYo0FIITJaRrK4ld4KcXvNdG
         +3T2ZMJ8ZKQ53SvMb+1p6Nyj/4w1eJKe60FjSK3vp/XSsvGONDdkS3KZNNDG+IhSJUb2
         1IeEaGx74BVWkSJtMN6M1o7SDQAVYcCwoipI0azuuTFxiPXP2Iay/R69eKVNVzLc2HKj
         W+371PadzYs9GYAYsxMEIaCsYSdAi7qhAOLhTz5oYAXj/ftIGsOg/llIDIs5cyd8s55l
         hYMhncjqosgVNe9UlHIwYtDPSyGTdkcdB6oe375XzyiJr+O4xhQYayGyxJ7TxkTFt0BG
         Fopw==
X-Gm-Message-State: AOAM53053Rr99wAWdIDBRbPlNpKwoVVz9WsYFFACqds+zEPTUQBBbfL0
        W10bO3hAgm1ApVBt58yrSxODOQ==
X-Google-Smtp-Source: ABdhPJwkpdNTZJOlEM11e8/ojC8NQRaFrNhKzoN9YNlb2Eh8os4Okwxuv257WYzTCuAHPo3m8sittQ==
X-Received: by 2002:a63:18d:: with SMTP id 135mr31151991pgb.78.1634687710983;
        Tue, 19 Oct 2021 16:55:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id bt5sm262736pjb.9.2021.10.19.16.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 16:55:10 -0700 (PDT)
Date:   Tue, 19 Oct 2021 23:55:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/13] KVM: Just resync arch fields when
 slots_arch_lock gets reacquired
Message-ID: <YW9a2s8wHXzf8Xqw@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <311810ebd1111bed50d931d424297384171afc36.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <311810ebd1111bed50d931d424297384171afc36.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> There is no need to copy the whole memslot data after releasing
> slots_arch_lock for a moment to install temporary memslots copy in
> kvm_set_memslot() since this lock only protects the arch field of each
> memslot.
> 
> Just resync this particular field after reacquiring slots_arch_lock.

I assume this needed to avoid having a mess when introducing the r-b tree?  If so,
please call that out.  Iterating over the slots might actually be slower than the
full memcpy, i.e. as a standalone patch this may or may not be make sense.

> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  virt/kvm/kvm_main.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 348fae880189..48d182840060 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1482,6 +1482,15 @@ static void kvm_copy_memslots(struct kvm_memslots *to,
>  	memcpy(to, from, kvm_memslots_size(from->used_slots));
>  }
>  
> +static void kvm_copy_memslots_arch(struct kvm_memslots *to,
> +				   struct kvm_memslots *from)
> +{
> +	int i;
> +
> +	for (i = 0; i < from->used_slots; i++)
> +		to->memslots[i].arch = from->memslots[i].arch;

This should probably be a memcpy(), I don't know what all shenanigans the compiler
can throw at us if it gets to copy a struct by value.

> +}
> +
>  /*
>   * Note, at a minimum, the current number of used slots must be allocated, even
>   * when deleting a memslot, as we need a complete duplicate of the memslots for

There's an out-of-sight comment that's now stale, can you revert to the
pre-slots_arch_lock comment?

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 48d182840060..ef3345428047 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1555,9 +1555,10 @@ static int kvm_set_memslot(struct kvm *kvm,
                slot->flags |= KVM_MEMSLOT_INVALID;

                /*
-                * We can re-use the memory from the old memslots.
-                * It will be overwritten with a copy of the new memslots
-                * after reacquiring the slots_arch_lock below.
+                * We can re-use the old memslots, the only difference from the
+                * newly installed memslots is the invalid flag, which will get
+                * dropped by update_memslots anyway.  We'll also revert to the
+                * old memslots if preparing the new memory region fails.
                 */
                slots = install_new_memslots(kvm, as_id, slots);

> @@ -1567,10 +1576,10 @@ static int kvm_set_memslot(struct kvm *kvm,
>  		/*
>  		 * The arch-specific fields of the memslots could have changed
>  		 * between releasing the slots_arch_lock in
> -		 * install_new_memslots and here, so get a fresh copy of the
> -		 * slots.
> +		 * install_new_memslots and here, so get a fresh copy of these
> +		 * fields.
>  		 */
> -		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
> +		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, as_id));
>  	}
>  
>  	r = kvm_arch_prepare_memory_region(kvm, old, new, mem, change);
> @@ -1587,8 +1596,6 @@ static int kvm_set_memslot(struct kvm *kvm,
>  
>  out_slots:
>  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> -		slot = id_to_memslot(slots, old->id);
> -		slot->flags &= ~KVM_MEMSLOT_INVALID;
>  		slots = install_new_memslots(kvm, as_id, slots);
>  	} else {

The braces can be dropped since both branches are now single lines.

>  		mutex_unlock(&kvm->slots_arch_lock);
