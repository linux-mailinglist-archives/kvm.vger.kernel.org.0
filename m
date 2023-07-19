Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EB2759A0F
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 17:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjGSPmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 11:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjGSPmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 11:42:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567CF1B5
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 08:42:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c5fc972760eso6363725276.1
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 08:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689781358; x=1692373358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D5fxkTnGgPpXTXRs+pAAOpKveu4sBAlnJ9TAdnEyBnc=;
        b=lHyhjCYeBP7i/K/0t117SJ2Lo9qZWJUGNdXY0iv+0+zNE60S1cOmziGlbGeN2uN9nn
         Kqr9JUKTOHvutwoyRE/MiATy7kCuewOpsSoguamfe7GM2cRjdoWR0VIfhY1R1YGuyUxM
         9Hffie45CBgwONB4rPVioxMTCmiNTYLqyF0n06Gepul95/7RzfNDR5pH+ymsgEWo2M3X
         r/GLWyPFOWs+tuF4HdxBZlyO+aadFna3rEJGqnWVKRabFngPqsoaAE44fDtAjHS0fhiI
         rwfp0nTrN5jN3Ypx5SzR1hFHvVcWZBrnmOzcAQkVc9lMyC7Ic53q1T66hW0A6exIngEB
         J47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689781358; x=1692373358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D5fxkTnGgPpXTXRs+pAAOpKveu4sBAlnJ9TAdnEyBnc=;
        b=NY8AZy7QhC0Zj0nj4oPZSB7ndxrqfKGXh3FT2KjzlHUe4rFetJ6Y42gGRMRdDQjxi4
         iAwo5YXC8WtRtQ7bs5w8aOb6LzUzTK3kdea3UlmRR5pmQF6lhEN6+gw75R3BLdfrcKEc
         FIS7Dhk53FRJoNvhwMvw/7dEQIWgUSW5UJFZHItCN2REkRv7zx0JXtoYYrPD4yXcfuli
         wyTjkkM3STPGL06bSRXTqprxWwm07s9ZIAbWguxFWZaL/dZA0Q8m1Q7Z0ZFyUP90nKON
         8IZwaNoKM62VXqagS2VF588Yr3uhpDb0AlxzHPvEqiL1uSOrqx9aoeQV9dESm+rUmT77
         VVtw==
X-Gm-Message-State: ABy/qLZKZX7LaVEVk/Zzm1e+WzBylNqDEyOphQpICqppEMy5xHwpcmD4
        xhhW56TPRHoy0DYTXW0MPIknnMoDIvs=
X-Google-Smtp-Source: APBJJlEvkfa0YzxhGi1mapD7wqxseWSC9O4G8YQAxUPbYQNHgI3Bi13yP67pEEMYkzOX6AVkNVMrnrNQtRI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:230e:0:b0:c4d:4b23:337 with SMTP id
 j14-20020a25230e000000b00c4d4b230337mr25446ybj.11.1689781358655; Wed, 19 Jul
 2023 08:42:38 -0700 (PDT)
Date:   Wed, 19 Jul 2023 08:42:37 -0700
In-Reply-To: <20230719083332.4584-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230719083332.4584-1-yan.y.zhao@intel.com>
Message-ID: <ZLgEbalDPD38qHmm@google.com>
Subject: Re: [PATCH] KVM: allow mapping of compound tail pages for IO or
 PFNMAP mapping
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, stevensd@chromium.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023, Yan Zhao wrote:
> Allow mapping of tail pages of compound pages for IO or PFNMAP mapping
> by trying and getting ref count of its head page.
> 
> For IO or PFNMAP mapping, sometimes it's backed by compound pages.
> KVM will just return error on mapping of tail pages of the compound pages,
> as ref count of the tail pages are always 0.
> 
> So, rather than check and add ref count of a tail page, check and add ref
> count of its folio (head page) to allow mapping of the compound tail pages.
> 
> This will not break the origial intention to disallow mapping of tail pages
> of non-compound higher order allocations as the folio of a non-compound
> tail page is the same as the page itself.
> 
> On the other side, put_page() has already converted page to folio before
> putting page ref.

Is there an actual use case for this?  It's not necessarily a strict requirement,
but it would be helpful to know if KVM supports this for a specific use case, or
just because it can.

Either way, this needs a selftest, KVM has had way too many bugs in this area.

> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 138292a86174..6f2b51ef20f7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2551,7 +2551,7 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
>  	if (!page)
>  		return 1;
>  
> -	return get_page_unless_zero(page);
> +	return folio_try_get(page_folio(page));
>  }
>  
>  static int hva_to_pfn_remapped(struct vm_area_struct *vma,
> 
> base-commit: 24ff4c08e5bbdd7399d45f940f10fed030dfadda
> -- 
> 2.17.1
> 
