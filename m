Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A26698321
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 19:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBOSUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 13:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBOSUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 13:20:03 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570723CE3A
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:19:52 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id u20so4854546vsp.5
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QexbYYGKRhTPyK9qoiEanQk7KDl1Is1wY2YZxvsIfXU=;
        b=mFyJ6OIO7yB2VWEaz6UL+z3Wa25WYnVJXGNQsTHc25aO4V3+I0c4AQL8EKqyjDJaT7
         tRsOG1YLaPBo9FbRNLA2ZIW4yRCfpflBCwkTUkgH6FRhAbatENYkWsNfteYLgjavbnae
         ypZnRQOlbfRgDVf6UQwZg2/CC2POTWtowXhAG2YICyXavov5RCdNwlIQiAx2WwFwpWpv
         JbkV5MnJgbEOCrVagRukB3iIf/OWuiJZjmWjDemoKUwQ7mcmwarwHJDC+vVDq+52s6pP
         pj3o598LibgN/JG5sh+s8Ry+zUPN/LEA7AJGKwC8pAFw8F67pXql5s5uF9EdHT3HEXK/
         2r9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QexbYYGKRhTPyK9qoiEanQk7KDl1Is1wY2YZxvsIfXU=;
        b=yWcocrhX2gyIJZG4KXj0hclLbOqvIAP/dBe9pzjsV5Xn/BetXu9gvfGikU8/lUV5wH
         gOcVGORhu71WAj4J821ofpEuu20zboAEVeKeeGWz7UBKZ1+Apv6/cyvCPcjnpEr0Hlif
         XZG3AWJ9UepVYIMA4F7+2YpYM+2aaH6No9aQZzDxy9N+IOEBGciT9vZCLC4o7yVWtW8e
         lRNwTPPeQuJ/CXpuoiXKGiO3KoAgcEqrLovXbgVqEdTSPYHlPFwhvX1fOqWlaEmMJyaP
         tfwbdr0kihwOx7ngU/V8/7Dp8L8WitDS+c4FEiuKXrYu2KX82r2Rsz0NCwjzcVRXd1jk
         b4CA==
X-Gm-Message-State: AO0yUKUTh76pKLZP2RZOCEzRqAYhCRWbHxF62TxA1RF6H51pk2JazNvi
        kIOSU2bcW+hdoobs3CdJ57hcWFXzpr6uYviD0KtaPQ==
X-Google-Smtp-Source: AK7set8ObJP7iGMvIUA6ruyvO8dY6AGJgXSEHO2ybg33E1OElXwnHQnJ+uNh4aYLeegXyK4SEQSkBTFZmZzJxetes74=
X-Received: by 2002:a05:6102:3b01:b0:412:6a3:2267 with SMTP id
 x1-20020a0561023b0100b0041206a32267mr730394vsu.5.1676485191228; Wed, 15 Feb
 2023 10:19:51 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-5-amoorthy@google.com>
 <Y+yfhELf/TbsosO9@linux.dev> <Y+0QRsZ4yWyUdpnc@google.com>
In-Reply-To: <Y+0QRsZ4yWyUdpnc@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 15 Feb 2023 10:19:40 -0800
Message-ID: <CAF7b7mprKmdoQ=aedfDkN85vi01fskAL_s_ROgkysWuTmSt9FQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] kvm: Allow hva_pfn_fast to resolve read-only faults.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 1:02 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> You could have a smaller diff (and arrive at something more readable)
> using a local for the gup flags:
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9c60384b5ae0..57f92ff3728a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2494,6 +2494,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>  static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>                             bool *writable, kvm_pfn_t *pfn)
>  {
> +       unsigned int gup_flags;
>         struct page *page[1];
>
>         /*
> @@ -2501,10 +2502,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>          * or the caller allows to map a writable pfn for a read fault
>          * request.
>          */
> -       if (!(write_fault || writable))
> -               return false;
> +       gup_flags = (write_fault || writable) ? FOLL_WRITE : 0;
>
> -       if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
> +       if (get_user_page_fast_only(addr, gup_flags, page)) {
>                 *pfn = page_to_pfn(page[0]);
>
>                 if (writable)

Good idea, will do.

On Wed, Feb 15, 2023 at 9:03 AM Sean Christopherson <seanjc@google.com> wrote:
>
> State what the patch does, avoid pronouns, and especially don't have "This commmit"
> or "This patch" anywhere.  From Documentation/process/submitting-patches.rst:
>
>   Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>   instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>   to do frotz", as if you are giving orders to the codebase to change
>   its behaviour.
>
> Heh, this whole series just screams "google3". :-)
>
> Anish, please read through
>
>   Documentation/process/coding-style.rst
>
> and
>
>   Documentation/process/submitting-patches.rst
>
> particularaly the "Describe your changes" and "Style-check your changes" your
> changes sections.  Bonus points if you work through the mostly redundant process/
> documentation, e.g. these have supplementary info.
>
>   Documentation/process/4.Coding.rst
>   Documentation/process/5.Posting.rst

Thanks for the resources Sean- I'll go through the series and rework the commit
messages/documentation appropriately.
