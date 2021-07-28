Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B2B3D9732
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 23:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhG1VBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 17:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhG1VBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 17:01:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FFCC061765
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 14:01:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso6021532pjs.2
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 14:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FJEdJNA4sywUWglVLwn78S3p+lPMZ01rTY+4k5h2Png=;
        b=vM44vlNslYWPbrjWIUu3iZFP6177zbLGeg6hyqrWdrVuDIZbAVbau4oMY3s6yBUNag
         cAWhQkel7/cgeaXF3reLPEscphuVuKsHMJB303I8gNYS5XZBHLxst+dWkokgP2eoW9tl
         RRcSnX2yLFCeOTUfLqSdMOEDr/avbk8h+vsooe3UpIAQ56O6b6/ThWXRMPf4Rc4fZCOp
         euc3dkrMYRfyP0IgN9H2ymWsJeGaaoSXkEpeCAKuSSFd8YFfLUEj5aHwJfggS1bjlBVA
         Rrkd2MaQIr4jgEQtyeHXjj1RqfAxdMGDxGxwbGmUjUUl8qMsPBIJfUgwtyctiCRu6Ue/
         os+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FJEdJNA4sywUWglVLwn78S3p+lPMZ01rTY+4k5h2Png=;
        b=uOWbsPRtt4IM/iTBkUtoqHknN5PH0wWiuP6OuwPctrXcj6NHxeIEA/YUeDAc+snzZb
         mjmysYOsyEexq1KAveMqBvzVs6iL6xaDpfoNLD6OozayrLh05/jE142cnRnrSNiXyeKw
         5G83P4pcIs0l2jVVc3oE6vVSvwQQptxagypxFHilB7EaUWF7wnqMqAN9QDjuzFoWbEXt
         Ij03gxxWUWhfV1+pY9QiNFFifQB5/a+unPaqE+CI1o3l6vsOJ4ZgSndLKr+QyRI4bha8
         O6579w6aB9/ktBM+o3EX+C8DvsyrC3mAlb0NdGj2JXVr/Bc3at4ub1XwMAnX7yIpQKJk
         lTKw==
X-Gm-Message-State: AOAM533yF/4SHjNWbWEkuyOaGFvKgcdoI8ss4sfOncpiY3whKmu7NPnE
        SvZGFLcmBA/b9IU7unqUcgF0jw==
X-Google-Smtp-Source: ABdhPJwx4GRnRHuDauI9xgKnOWibZNxddcRVd4P3ZBzKBS71Eqdi0J1GWpZUKB18NEIaKPOMp/cs9A==
X-Received: by 2002:a17:902:ab88:b029:12b:d2ee:c26f with SMTP id f8-20020a170902ab88b029012bd2eec26fmr1549354plr.38.1627506085157;
        Wed, 28 Jul 2021 14:01:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l2sm882101pfc.157.2021.07.28.14.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:01:24 -0700 (PDT)
Date:   Wed, 28 Jul 2021 21:01:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 7/9] KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger
Message-ID: <YQHFoDqp4yxfXcjc@google.com>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153413.43570-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625153413.43570-1-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021, Peter Xu wrote:
> Currently rmap array element only contains 3 entries.  However for EPT=N there
> could have a lot of guest pages that got tens of even hundreds of rmap entry.
> 
> A normal distribution of a 6G guest (even if idle) shows this with rmap count
> statistics:
> 
> Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
> Level=4K:       3089171 49005   14016   1363    235     212     15      7       0       0       0
> Level=2M:       5951    227     0       0       0       0       0       0       0       0       0
> Level=1G:       32      0       0       0       0       0       0       0       0       0       0
> 
> If we do some more fork some pages will grow even larger rmap counts.
> 
> This patch makes PTE_LIST_EXT bigger so it'll be more efficient for the general
> use case of EPT=N as we do list reference less and the loops over PTE_LIST_EXT
> will be slightly more efficient; but still not too large so less waste when
> array not full.
> 
> It should not affecting EPT=Y since EPT normally only has zero or one rmap
> entry for each page, so no array is even allocated.
> 
> With a test case to fork 500 child and recycle them ("./rmap_fork 500" [1]),
> this patch speeds up fork time of about 22%.
> 
>     Before: 367.20 (+-4.58%)
>     After:  302.00 (+-5.30%)
> 
> [1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b3f738a7c05e..9b093985a2ef 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -137,8 +137,8 @@ module_param(dbg, bool, 0644);
>  
>  #include <trace/events/kvm.h>
>  
> -/* make pte_list_desc fit well in cache line */
> -#define PTE_LIST_EXT 3
> +/* make pte_list_desc fit well in cache lines */
> +#define PTE_LIST_EXT 15

Ha, I was going to say that this should be '14' to fit pte_list_desc within two
cache lines, but looks like Paolo fixed it up on commit.

Also, if the whole cache line thing actually matters, sptes[] and spte_count
should be swapped since spte_count is always read, whereas spte_count[7:14] will
be read iff there are 8+ SPTEs.

>  struct pte_list_desc {
>  	u64 *sptes[PTE_LIST_EXT];
> -- 
> 2.31.1
> 
