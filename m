Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDFF2DB3EC
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgLOSpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731621AbgLOSpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:45:11 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD18C061282
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 10:44:26 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so15059840pfu.1
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 10:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IVZnctmfk0yIQtj/yNYoj8vI1ASqyPivl3mLB8gsmgg=;
        b=kQdu4FVrZaDf94OglYYj4VmJzt57PCwr5ElOcMG1XjIh130u6xY4kqOJx1EP4je2fy
         U+uTD4pz8k+qwHMnsIFlGKc518FFySmgPigdgVGg1c42BD+PeuqmlqGERF654QDXXxj4
         4uP7WlF//MDAtdNQUZDSwZ5Zn7qpOnl1dwPhDAzSY8EGfwB6UxskcNc0w6TJrlNoq80n
         wZvGxZozyZU5lXMASiCPBN5+7l6iGKtth4DINbgpDDi3nntYb1HW2Gf6Kzqtb134wq4c
         ShczGVT4uk7rGI/pkqTsVVryiI59XsDsd8AcPxlFFNqILKCEMT5/vvNRvFfxZBDhlrGe
         W7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IVZnctmfk0yIQtj/yNYoj8vI1ASqyPivl3mLB8gsmgg=;
        b=GDnkBmBkKB53fX1WS2Omr7d2gkqvIGl6f9Bwfvsdch06zMESpcSuKZWFxSrUvZRIj1
         iTFE6wcfp85aR+6xLqRad1w252X3dql8gQQVNSZ/Z/cUX7RzGeISSxQOUNuYKDMNpFlu
         3CnwDhQBXkSJJ/Pio5sn4iw9piSIXBKyU3P1MK3CNLxyFPZS6XenM9X/jJIfCtq3emgx
         MREOmLhyDtSiWs3S/rruKxlymdwRPpqn9bo07Rx47guFK4nwcHqMXaBYvkTGVpSQRd+H
         BNFF5t7YxOuBmQOmxU8uGo+47nGOs8TztgvZNp//3utfdPOfWQCLPecuPhRy4SVBV03l
         FmVw==
X-Gm-Message-State: AOAM531gwzi2ZSsdw7cBzj5eH/c+zbknZ08Rf8VoDPR4C8W3swBVDzTm
        jtG8hHhgtckhs8Rtb/jseZFvpQ==
X-Google-Smtp-Source: ABdhPJxKNkTxXkjEjLNAjtmohl1H3VRCv0y9bGHizEAISRmWlhvt0TCdWWdOGpxwcvHfS3ihBKKPGw==
X-Received: by 2002:a63:f84d:: with SMTP id v13mr30226286pgj.234.1608057865256;
        Tue, 15 Dec 2020 10:44:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id na6sm21029310pjb.12.2020.12.15.10.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 10:44:24 -0800 (PST)
Date:   Tue, 15 Dec 2020 10:44:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>, stable@vger.kernel.org
Subject: Re: [PATCH V2] kvm: check tlbs_dirty directly
Message-ID: <X9kEAh7z1rmlmyhZ@google.com>
References: <ea0938d2-f766-99de-2019-9daf5798ccac@redhat.com>
 <20201215145259.18684-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215145259.18684-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note, you don't actually need to Cc stable@vger.kernel.org when sending the
patch.  If/when the patch is merged to Linus' tree, the stable tree maintainers,
or more accurately their scripts, will automatically pick up the patch and apply
it to the relevant stable trees.

You'll probably be getting the following letter from Greg KH any time now :-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>


On Tue, Dec 15, 2020, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
>         need_tlb_flush |= kvm->tlbs_dirty;
> with need_tlb_flush's type being int and tlbs_dirty's type being long.
> 
> It means that tlbs_dirty is always used as int and the higher 32 bits
> is useless.  We need to check tlbs_dirty in a correct way and this
> change checks it directly without propagating it to need_tlb_flush.
> 
> And need_tlb_flush is changed to boolean because it is used as a
> boolean and its name starts with "need".
> 
> Note: it's _extremely_ unlikely this neglecting of higher 32 bits can
> cause problems in practice.  It would require encountering tlbs_dirty
> on a 4 billion count boundary, and KVM would need to be using shadow
> paging or be running a nested guest.
> 
> Cc: stable@vger.kernel.org
> Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from V1:
> 	Update the patch and the changelog as Sean Christopherson suggested.
> 
>  virt/kvm/kvm_main.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2541a17ff1c4..1c17f3d073cb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -470,7 +470,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  					const struct mmu_notifier_range *range)
>  {
>  	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> -	int need_tlb_flush = 0, idx;
> +	int idx;
> +	bool need_tlb_flush;

It's a bit silly given how small this patch already is, but I do think this
should be split into two patches so that the kvm->tlbs_dirty bug fix is fully
isolated for backporting.  I.e. patch 1/2 would simply be:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3abcb2ce5b7d..19dae28904f7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -485,9 +485,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
        kvm->mmu_notifier_count++;
        need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
                                             range->flags);
-       need_tlb_flush |= kvm->tlbs_dirty;
        /* we've to flush the tlb before the pages can be freed */
-       if (need_tlb_flush)
+       if (need_tlb_flush || kvm->tlbs_dirty)
                kvm_flush_remote_tlbs(kvm);

        spin_unlock(&kvm->mmu_lock);

>  
>  	idx = srcu_read_lock(&kvm->srcu);
>  	spin_lock(&kvm->mmu_lock);
> @@ -480,11 +481,10 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  	 * count is also read inside the mmu_lock critical section.
>  	 */
>  	kvm->mmu_notifier_count++;
> -	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
> -					     range->flags);
> -	need_tlb_flush |= kvm->tlbs_dirty;
> +	need_tlb_flush = !!kvm_unmap_hva_range(kvm, range->start, range->end,
> +					       range->flags);
>  	/* we've to flush the tlb before the pages can be freed */
> -	if (need_tlb_flush)
> +	if (need_tlb_flush || kvm->tlbs_dirty)
>  		kvm_flush_remote_tlbs(kvm);
>  
>  	spin_unlock(&kvm->mmu_lock);
> -- 
> 2.19.1.6.gb485710b
> 
