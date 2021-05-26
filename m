Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE11E391E2E
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhEZRew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhEZReu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 13:34:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFFCC061756
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:33:17 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x188so1469270pfd.7
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6bRkgK4UPyvfFe812RqlFX9dKaac3fJKoqFaNKJrN/M=;
        b=dis3AUX1DsE2YtlgCtgvgBvTwtYPf/HiTrK/M1T4RXJxzbONuUu3tZ56zequkYThQo
         jDlZGfVa+crjvumc9ZkcbVNpcEW82NB61FtqjyVFV1TyHv6xSkRbrtWHaPpSuTFhM2B8
         MLqkTkqAS/SUK3JRwKpS+sYaaDKdszpVtn2AbTQNQD1OEDgTnXHx00nmJjPJP5+73qRa
         APxBRLr9G0ocvdhlCXa26B4bET27dkSjNOBfM2HzS33yPd+okjm4ybGGpfyMC8P8bKbw
         UI3ZydQlhXgZ2g2kbj/OO/XzNs88s4x0FPsAB16x8955Ry1x6u3h/Aw2OVfXg2FJGe7E
         C9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6bRkgK4UPyvfFe812RqlFX9dKaac3fJKoqFaNKJrN/M=;
        b=P0GZ1eCi3pq2Kt+awSR7EEmD4STnzA8T7sHidhCWTT4ztOAk597G8h60GkfHPxvAco
         vauuzyYzSf+1wLoJl8Q4M1ZX8dho7dQe27rahIHXKW9W5/qdqeW7Yxv66tURzXx8maVv
         ida+XUMfEGFvPX0rUHuNmezeI5/He1c5na3mYIV9Fh8sQd2X0GsIrClbw+6MT4x3/RnM
         y+5ONPFFmhHFMqwjd2ISe7EuF5pGOx2NQmuyJB7oVZg5dBH5pNu5kwRFFTK9Qvxn1Nzy
         gs5Jk2O8lNe1Vez/necG8pR2UJMvnS5kPDPCf/40Kso/wctteAJDvp2Rx7crcjtCORCU
         fWkg==
X-Gm-Message-State: AOAM533NkVLiMNIblpCI48tuEF15RsO94ZhjR0pfClagtz4b8nNJmfcT
        0KgNiAUVbXxa6CLHKIWeW1lFGg==
X-Google-Smtp-Source: ABdhPJyqOWPvJcFCIVFmwVuhCRlI8WBmoCEtb4U5HayQLR072x4netDoBmzqbr9yj/Z0tPrZqrYLPQ==
X-Received: by 2002:a63:1e1a:: with SMTP id e26mr25663798pge.240.1622050397276;
        Wed, 26 May 2021 10:33:17 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v27sm7373923pfi.169.2021.05.26.10.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 10:33:16 -0700 (PDT)
Date:   Wed, 26 May 2021 17:33:13 +0000
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
Subject: Re: [PATCH v3 7/8] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <YK6GWUP107i5KAJo@google.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <38333ef36e7812e1b9f9d24e726ca632997a8ef1.1621191552.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38333ef36e7812e1b9f9d24e726ca632997a8ef1.1621191552.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Introduce a memslots gfn upper bound operation and use it to optimize
> kvm_zap_gfn_range().
> This way this handler can do a quick lookup for intersecting gfns and won't
> have to do a linear scan of the whole memslot set.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 41 ++++++++++++++++++++++++++++++++++++++--
>  include/linux/kvm_host.h | 22 +++++++++++++++++++++
>  2 files changed, 61 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7222b552d139..f23398cf0316 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5490,14 +5490,51 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>  	int i;
>  	bool flush = false;
>  
> +	if (gfn_end == gfn_start || WARN_ON(gfn_end < gfn_start))
> +		return;
> +
>  	write_lock(&kvm->mmu_lock);
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> -		int ctr;
> +		int idxactive;
> +		struct rb_node *node;
>  
>  		slots = __kvm_memslots(kvm, i);
> -		kvm_for_each_memslot(memslot, ctr, slots) {
> +		idxactive = kvm_memslots_idx(slots);
> +
> +		/*
> +		 * Find the slot with the lowest gfn that can possibly intersect with
> +		 * the range, so we'll ideally have slot start <= range start
> +		 */
> +		node = kvm_memslots_gfn_upper_bound(slots, gfn_start);
> +		if (node) {
> +			struct rb_node *pnode;
> +
> +			/*
> +			 * A NULL previous node means that the very first slot
> +			 * already has a higher start gfn.
> +			 * In this case slot start > range start.
> +			 */
> +			pnode = rb_prev(node);
> +			if (pnode)
> +				node = pnode;
> +		} else {
> +			/* a NULL node below means no slots */
> +			node = rb_last(&slots->gfn_tree);
> +		}
> +
> +		for ( ; node; node = rb_next(node)) {
>  			gfn_t start, end;

Can this be abstracted into something like:

		kvm_for_each_memslot_in_gfn_range(...) {

		}

and share that implementation with kvm_check_memslot_overlap() in the next patch?

I really don't think arch code should be poking into gfn_tree, and ideally arch
code wouldn't even be aware that gfn_tree exists.

> +			memslot = container_of(node, struct kvm_memory_slot,
> +					       gfn_node[idxactive]);
> +
> +			/*
> +			 * If this slot starts beyond or at the end of the range so does
> +			 * every next one
> +			 */
> +			if (memslot->base_gfn >= gfn_start + gfn_end)
> +				break;
> +
>  			start = max(gfn_start, memslot->base_gfn);
>  			end = min(gfn_end, memslot->base_gfn + memslot->npages);
>  			if (start >= end)
