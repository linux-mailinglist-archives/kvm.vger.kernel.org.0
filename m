Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE82C508DFC
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380858AbiDTRJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377175AbiDTRJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:09:47 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9762163C5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:07:00 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id bf11so2635978ljb.7
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nwXZACexIQTCKX7fmQhCIlLscOf1Xe3RKBnrv/G98uk=;
        b=BtWx0WnVulW7TX9tHR5fuA8v+iY5c2SN57DW1HG5FmHTqp2dOl0qBvyuCtPv2i5gia
         1CtfT9QV502kMtFFgjO1mMbq3RcuyuQXXotHgc2ylqNltYpgO5lpJNuqflA/hqfflys+
         sBh9pqmeGjf4bmJLUUbSWV26+p51R1lXH9VHVOGqI3QjvFsJh7gsUC/9KNbRYNqRr2ZL
         D92Qa/cfU74JSTUqLbcB0QqbINGM1+VXX8RbhVaoDOsQBgDw2/jzuoD/3r7iohdD9xF/
         6Nw/8azbHPVI2VVdpOODG3Gng/IRWlU9HMDGOTSAEz/E8U1z3VP/4D/AWOdDSNPddNtm
         v7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nwXZACexIQTCKX7fmQhCIlLscOf1Xe3RKBnrv/G98uk=;
        b=V2Wnu8//ZAVxC6xXeiwmay/FB21kSZRuHXe0+GjFjLb+QoKQ8O7xn6dyOGFMV8MexY
         SAPfjYH6zOyv3Ao5s5sQ86Wd2QqrSQ2R9rctXGywb+DXkaPO9gR8SYRG7QGN6FjYoyf5
         fAmISmBiZAFdJmDvkracJSF/St/uEBR9UEJ3CKDOEumLJWDU6jpq4Xq6RJaT3h2rr2Tq
         FqdfyALVremM0RkMwld2ZBrJ8vxE93lJcooSqCqBJZNmyZ3MijcC5+dnFVbcGvf2HXh+
         rqxqJb44ePwl4OHqvmskXj6xuxPvtWdBdSyQoLoVXAujIlh+t1/NMMpEYcjXnEgCjwqv
         939g==
X-Gm-Message-State: AOAM530vtg/kYR9dYNqbIaRSUIkgSa3Gcrgu6ivwbf5SglvVfwRz4oHo
        vEvao7ecAUIrbx7dzdpcnF0FhYPm6rXl9SchNoOHFfLFHKc=
X-Google-Smtp-Source: ABdhPJyGf8++29sfZ4IombK+Ehkrq5O/Fj1OHcyZrq+mqvGz2SwZasPtkzcHYZNH6OzyhQngA6L8RJ0mM5f8tZXe9i8=
X-Received: by 2002:a2e:5cc1:0:b0:24b:112f:9b36 with SMTP id
 q184-20020a2e5cc1000000b0024b112f9b36mr14125759ljb.337.1650474418585; Wed, 20
 Apr 2022 10:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-7-oupton@google.com>
 <YmA7D7DyY7MDfli4@google.com>
In-Reply-To: <YmA7D7DyY7MDfli4@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 20 Apr 2022 10:06:47 -0700
Message-ID: <CAOQ_QsgaRF1ZkKATk38PTi2GqhajXPrxVuZFa6d-KPnY-Sfutg@mail.gmail.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
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

On Wed, Apr 20, 2022 at 9:55 AM Quentin Perret <qperret@google.com> wrote:
>
> On Friday 15 Apr 2022 at 21:58:50 (+0000), Oliver Upton wrote:
> > +/*
> > + * Used to indicate a pte for which a 'make-before-break' sequence is in
>
> 'break-before-make' presumably :-) ?

Gosh, I'd certainly hope so! ;)

> <snip>
> > +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_mm_ops *mm_ops)
> > +{
> > +     /* Yikes! We really shouldn't install to an entry we don't own. */
> > +     WARN_ON(!stage2_pte_is_locked(*ptep));
> > +
> > +     if (stage2_pte_is_counted(new))
> > +             mm_ops->get_page(ptep);
> > +
> > +     if (kvm_pte_valid(new)) {
> > +             WRITE_ONCE(*ptep, new);
> > +             dsb(ishst);
> > +     } else {
> > +             smp_store_release(ptep, new);
> > +     }
> > +}
>
> I'm struggling a bit to understand this pattern. We currently use
> smp_store_release() to install valid mappings, which this patch seems
> to change. Is the behaviour change intentional? If so, could you please
> share some details about the reasoning that applies here?

This is unintentional. We still need to do smp_store_release(),
especially considering we acquire a lock on the PTE in the break
pattern. In fact, I believe the compare-exchange could be loosened to
have only acquire semantics. What I had really meant to do here (but
goofed) is to avoid the DSB when changing between invalid PTEs.

Thanks for the review!

--
Best,
Oliver
