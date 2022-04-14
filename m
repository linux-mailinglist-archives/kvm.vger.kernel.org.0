Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1835D501DEA
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 00:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244202AbiDNWDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 18:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243420AbiDNWDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 18:03:42 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D115986C9
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 15:01:16 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id c24-20020a9d6c98000000b005e6b7c0a8a8so4319723otr.2
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 15:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6v2JIcnO74S/p5+dirBbOGSaV+ed6VcSDjiH/u/D+aI=;
        b=ZdWf8c6V/Syu7A3HkxAQFa/Bgv5Qbwbrt6vdDRNRWkJL7ZPkFVcoSkpQJimgIKwt6U
         t2vvPcGYn/9DRRPbcaL2Vgs95NE0398gIwKWVAYgCxSpJI2P5SNXSSRkkVIBcboR4K4Q
         iebdiKEDddEtKCnig7/Z8+KzV3Gj5Fw+aNSrQRMtiE1y44jXguho42vmfGGIUG00yh6d
         8B8RHtzrr67BQdc+NhEkxjRQXaV7AU1jQHDo2GJ+JgWj5A8DSmA86BkekOhfjEwVFYxo
         zGhjCFVKatUioNh1i1RFgSmc5T9dYVgKKri87aCOHsYwS5Y+n5aal79M0w/h+JDBOSKL
         2mEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6v2JIcnO74S/p5+dirBbOGSaV+ed6VcSDjiH/u/D+aI=;
        b=UZej0foEsN4xtjGaPrJ7slAfx/qicFQuEwiQtvTXjRwtHlSjuzQchzib8ol8MWtODc
         JyqNjXpGLk/wDUHIj1Hf+l3x/pPn80te18SqN7txd92uf4XzZC1O2RqYVXnLNk4thbwk
         FVOO2MLD14c3monFgwvqoem5eqjZUtf+BoTqSl6sCVQc0nOEZMWGtbO2Pde5LVhwmbh2
         wF41x5qr7NCiJHjCWqxgAeETICmGLVBx5bPinJ513ABOnCzmyH3cnHY7LRt/Z28UJF2D
         U4gcWwNI3xaIedYlRDUwQ8Mep3QgtBnYMcY/ZPrKxPs5NZuEfGUWlc1hvTVThp8vVYVH
         MwwQ==
X-Gm-Message-State: AOAM532WDnKrytsG+FCp5263J6JPmy1knerBffgO7xqbENbrOgs5VcrE
        yXeASbiPl7EDVsMR5iSWP4GjmRyksIqZtkLi4i56Ng==
X-Google-Smtp-Source: ABdhPJyqrcwqArrcLRNNcSEbE2YukhZ6PQK+xbbqWzkAXEL9KKXaFiylu5SQb94jq2n8a+UclADYeWviMm/r3bgy7Zs=
X-Received: by 2002:a05:6830:240f:b0:5ce:60e8:294a with SMTP id
 j15-20020a056830240f00b005ce60e8294amr1638687ots.14.1649973675627; Thu, 14
 Apr 2022 15:01:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220414010703.72683-1-peterx@redhat.com> <Ylgn/Jw+FMIFqqc0@google.com>
 <bf15209d-2c50-9957-af24-c4f428f213b1@redhat.com> <YliTdb1LjfJoIcFc@xz-m1.local>
In-Reply-To: <YliTdb1LjfJoIcFc@xz-m1.local>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 14 Apr 2022 15:01:04 -0700
Message-ID: <CALMp9eRjNd5_VFOsAoANkoaCTkKSHp3awrABZ5LR20+VoXZuAA@mail.gmail.com>
Subject: Re: [PATCH] kvm: selftests: Fix cut-off of addr_gva2gpa lookup
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 2:36 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Thu, Apr 14, 2022 at 04:14:22PM +0200, Paolo Bonzini wrote:
> > On 4/14/22 15:56, Sean Christopherson wrote:
> > > > - return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> > > > + return ((vm_paddr_t)pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> > > This is but one of many paths that can get burned by pfn being 40 bits.  The
> > > most backport friendly fix is probably to add a pfn=>gpa helper and use that to
> > > place the myriad "pfn * vm->page_size" instances.
> > >
> > > For a true long term solution, my vote is to do away with the bit field struct
> > > and use #define'd masks and whatnot.
> >
> > Yes, bitfields larger than 32 bits are a mess.
>
> It's very interesting to know this..

I don't think the undefined behavior is restricted to extended
bit-fields. Even for regular bit-fields, the C99 spec says, "A
bit-field shall have a type that is a qualified or unqualified version
of _Bool, signed
int, unsigned int, or some other implementation-defined type." One
might assume that even the permissive final clause refers to
fundamental language types, but I suppose "n-bit integer" meets the
strict definition of a "type,"
for arbitrary values of n.
