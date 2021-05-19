Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000FB38984F
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 23:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhESVCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 17:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhESVCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 17:02:18 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0601C061760
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:00:57 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y32so10309511pga.11
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8fPkrJZl4xbjKZWSb4LautfbTP6fpPHvxZUlNFpdvSA=;
        b=wCA+ul9992t4Z3RZZg7u/sCLnlCW1UpUlXad2PEtqU7sXx/IpINVWngj3nGutMGJSM
         DyOznK2ZiHYjYqGw6jCarfrR/HPvBbZMG06mpWvqewKGFovKCO+wl3aNaJCz+9mzzNJI
         UHYeVGSB+LmxV9XDidTKfTS/9e9V9o1scQdbUAcivKUkN4rb45ZFLenLJLiNWKU4Fu9W
         /RWKbyu3hA+jGi/ErLBE8GyqbXE1hmgWycS7xieAiJg8nruu8TXAO6h0BT2o9xki7RCx
         ce0kPdRUCD0VWcmxZeZsZknMp1uqHWioYiZwh5PzpF2m83LrONvnHU9lm7lLbzhVXIc7
         3xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8fPkrJZl4xbjKZWSb4LautfbTP6fpPHvxZUlNFpdvSA=;
        b=P6cChDMbm0TRVd6qKiHtioA4ErQaMge4f/NVddmytDIyb7lhe3Mm99p4gjo4RILbl+
         FecgEdA1IKnRKvk+4c9aUYXAz8KQYc71aUY9FotAel8ayquJK+olHUQldQX5o+p0SebG
         m+RLvdtTZ6C488R1ozmFlBiPa29k6Zux1gQ8Kd53S0agGaUJhFtlBzeKy7tviaH7bvtQ
         MLh6sFTy9nFsyhU96he+VVO5YPzDTML70mWX0B82f9rRVCwYrU5JMHVxTUgKkOb6EZbg
         ESUfLpDAnu7oqtCA0uBJHb1kAjL6987okZh7A3mVQ41gCt1rtk8nla4Lcv1ZzaXUrxEA
         DW1Q==
X-Gm-Message-State: AOAM533t/XWpGCnnLrEEXvx5aRa3XDLyL4Y2T+vJNAmpeUznqP7y3SLv
        Sb8ZTirhE9TOoUR6n76yoiCzOg==
X-Google-Smtp-Source: ABdhPJy0Bnrx+iCOczdDbABKesxv6ntU9siwPKi1NgqUCXqUrNZZfXMKKBMKmXgXn85/O4dnm1j3yA==
X-Received: by 2002:a63:5060:: with SMTP id q32mr1088180pgl.32.1621458056727;
        Wed, 19 May 2021 14:00:56 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e7sm251429pfl.171.2021.05.19.14.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 14:00:56 -0700 (PDT)
Date:   Wed, 19 May 2021 21:00:52 +0000
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
Subject: Re: [PATCH v3 1/8] KVM: x86: Cache total page count to avoid
 traversing the memslot array
Message-ID: <YKV8hHDS489g9JBS@google.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <eb1c881ce814705c83813f02a1a13ced96f1b1d1.1621191551.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb1c881ce814705c83813f02a1a13ced96f1b1d1.1621191551.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> There is no point in recalculating from scratch the total number of pages
> in all memslots each time a memslot is created or deleted.
> 
> Just cache the value and update it accordingly on each such operation so
> the code doesn't need to traverse the whole memslot array each time.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5bd550eaf683..8c7738b75393 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11112,9 +11112,21 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				const struct kvm_memory_slot *new,
>  				enum kvm_mr_change change)
>  {
> -	if (!kvm->arch.n_requested_mmu_pages)
> -		kvm_mmu_change_mmu_pages(kvm,
> -				kvm_mmu_calculate_default_mmu_pages(kvm));
> +	if (change == KVM_MR_CREATE)
> +		kvm->arch.n_memslots_pages += new->npages;
> +	else if (change == KVM_MR_DELETE) {
> +		WARN_ON(kvm->arch.n_memslots_pages < old->npages);

Heh, so I think this WARN can be triggered at will by userspace on 32-bit KVM by
causing the running count to wrap.  KVM artificially caps the size of a single
memslot at ((1UL << 31) - 1), but userspace could create multiple gigantic slots
to overflow arch.n_memslots_pages.

I _think_ changing it to a u64 would fix the problem since KVM forbids overlapping
memslots in the GPA space.

Also, what about moving the check-and-WARN to prepare_memory_region() so that
KVM can error out if the check fails?  Doesn't really matter, but an explicit
error for userspace is preferable to underflowing the number of pages and getting
weird MMU errors/behavior down the line.

> +		kvm->arch.n_memslots_pages -= old->npages;
> +	}
> +
> +	if (!kvm->arch.n_requested_mmu_pages) {

If we're going to bother caching the number of pages then we should also skip
the update when the number pages isn't changing, e.g.

	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
		if (change == KVM_MR_CREATE)
			kvm->arch.n_memslots_pages += new->npages;
		else
			kvm->arch.n_memslots_pages -= old->npages;

		if (!kvm->arch.n_requested_mmu_pages) {
			unsigned long nr_mmu_pages;

			nr_mmu_pages = kvm->arch.n_memslots_pages *
				       KVM_PERMILLE_MMU_PAGES / 1000;
			nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
			kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
		}
	}

> +		unsigned long nr_mmu_pages;
> +
> +		nr_mmu_pages = kvm->arch.n_memslots_pages *
> +			       KVM_PERMILLE_MMU_PAGES / 1000;
> +		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
> +		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
> +	}
>  
>  	/*
>  	 * FIXME: const-ify all uses of struct kvm_memory_slot.
