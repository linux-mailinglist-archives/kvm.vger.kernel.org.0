Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A7442FA3D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 19:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhJORaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 13:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbhJORaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 13:30:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C9DC061764
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 10:28:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso9805065pjb.4
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 10:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DP6t/NXe90slXcP72oHx/RcWeNEoJHh1SU/+94tdSzU=;
        b=Rsq3M9IMqXWvFbQX4QPOwwS2GyHkNiaDKcXMCoIIDcUpfFRjPkpPagnj8H7RM71dvS
         B/WyJMpAXqYJH0QspZ4spN/eMlP660dhZXJZ82wIznR4E3UHwWn3BGv8zj2ShH9v+Jvx
         nA4HntP1f2Q6X4bvioWI/O++E9+cdXbpdf17ocQHFXttf0HMB7mB71nWHMuCnjZj/snR
         ObWYV+kfnUlM9Pja8m3xvmkxYfK0Agb+IHxkN8iU/4aHnZWYTP1DiN6Cx7R6cmtMIior
         2rv8DMeqhKfApBP2mzIqzyj/7m9yPudqNWIsRQ5wSm5w3a7oss+jdvkN4sSzn/++bMmq
         EwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DP6t/NXe90slXcP72oHx/RcWeNEoJHh1SU/+94tdSzU=;
        b=5DwjuiPC+SqTA3uBnbOWku/DfBKJJ/p2cI5KnwsVibAtOy8U90YCjpPrdUJKoEAKOZ
         iwAHJAIpVBta+2iTFr60QgaNmtGHgfHZRA7Jxl3CQSLjWvQt2yMlH9KhiW6Yq0rWEUlX
         5kBHOivSMOOuggao28AMyppLpEOEtgMcnOSaIRxk5vPKVnXXhgTV6dp/HdrC9D9GZcmS
         wQZ2LJQEMHXfX6T1d+hzSFvSMuimZGe9uWDP1smiqmmQV96Sjrw+HzLBkA0firVh+WG3
         mBQumppk7u2hZ1llHELGpprlk0oNfZ0zkTsi6W8ZI7Ys0hhpR2F+///fTJtLKaP/o2Rp
         YKHw==
X-Gm-Message-State: AOAM532wWNGJbTBTIn7Azjx8HKYFJUBmm6unZ5MSvEg9OpzZnzV0QZST
        fQI9K0NzX5oggFS//WrSoqhUfQ==
X-Google-Smtp-Source: ABdhPJzzdKd8TVQsTd0uv0BYhv6ultDEDftxJbAg01g5dSdgsQ5uIIUiG18b1X8cn3FJ4SWeSN+roA==
X-Received: by 2002:a17:902:9a83:b0:13e:5b1e:aa40 with SMTP id w3-20020a1709029a8300b0013e5b1eaa40mr12278810plp.41.1634318893792;
        Fri, 15 Oct 2021 10:28:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p18sm5107067pgk.28.2021.10.15.10.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 10:28:13 -0700 (PDT)
Date:   Fri, 15 Oct 2021 17:28:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: replace large kvmalloc allocation with vmalloc
Message-ID: <YWm6KcNvaHDMhfsG@google.com>
References: <20211015165519.135670-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015165519.135670-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 21427e84a82e..0d9842472288 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -36,8 +36,7 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
>  
>  	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
>  		slot->arch.gfn_track[i] =
> -			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
> -				 GFP_KERNEL_ACCOUNT);
> +			vcalloc(npages, sizeof(*slot->arch.gfn_track[i]));

This loses the memcg accounting, which is somewhat important for the theoretical
4MiB allocations :-)

Maybe split out the introduction of vcalloc() to a separate patch (or two) and
introduce additional helpers to allow passing in gfp_t to e.g. __vzalloc()?

>  		if (!slot->arch.gfn_track[i])
>  			goto track_free;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aabd3a2ec1bc..07f5760ea30c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11394,7 +11394,7 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
>  
>  		WARN_ON(slot->arch.rmap[i]);
>  
> -		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
> +		slot->arch.rmap[i] = vcalloc(lpages, sz);
>  		if (!slot->arch.rmap[i]) {
>  			memslot_rmap_free(slot);
>  			return -ENOMEM;
> @@ -11475,7 +11475,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
>  
>  		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
>  
> -		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
> +		linfo = vcalloc(lpages, sizeof(*linfo));
>  		if (!linfo)
>  			goto out_free;

All of the associated free paths should be converted to vfree().
