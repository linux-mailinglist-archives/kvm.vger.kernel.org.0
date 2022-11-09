Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79260623730
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 00:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiKIXAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 18:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiKIXA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 18:00:29 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC2F2F3B3
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 15:00:28 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id v8so154203qkg.12
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 15:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cmFG+lMjzf/ZVIEgSvSUi/Kw8nPzVjb1fGFMbu/W5vY=;
        b=dudkNi4O683uD+TNndcPtPCeCpa9QA7FbrHjaVOmIRg+UIGVhAfjaXmH9wBmtQDeLP
         uNHcUO7j+uCpDHYxGSZ329F4Pqk6v23Tz3bL13gqm3RiGz3qJQ/5WwLouTw/AcT5Af9A
         rQwCxIpQ+YDTTjArHhx2QEoIvvIdpsL61e+NndZ9oI8EQss2i6rc9Xfaom1mQcgOEuKg
         X725WqyvZrKDxE82nLTfL2duzd2WFlc4dcdajM8jpWTqjR8pxMwjOHMgSw7/94Xya4Fw
         OtHNgVbPfchbdE78tQKPU3oB9S3RIz76UsqxoZzTcwc1Vr43CTJ+spRrWppH+q9QCzYf
         4lBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmFG+lMjzf/ZVIEgSvSUi/Kw8nPzVjb1fGFMbu/W5vY=;
        b=5OXd6XiBLC90/fE825Kx+u+ceTHbZBWxo6u+Sc9bwvAh4Hioong3MwBIRwx+sGAaGl
         C2f/1hG4OzIuwoS+soEbyjSsHZTJmMoNVUTgBjxe33Vue59Xmwg63On4zTEsA6uvC9/8
         6iWVA3tCFDxNUb50spjtoo+SWQYI9FoewiVTBKFZfc3wp5BBEaW3bnzBTMhFh/85pVKK
         Ktyu3572g3qW2Cc0UdeBM4gQy0ds8C4tSl8tEohD3vWWx7j/SZeISeRmq++d7mjN3A1l
         8L0mruXxeSzbhjcnVmSKRHyShn4J6wlDGeJkYCPjVVtW72ZsbYfmHOMYNT7JzME9xMgl
         0ntw==
X-Gm-Message-State: ACrzQf34Bh97LaCY472ZiNy9+SiexhGeWbXN3//mnVzkgrYsuAXKjiNR
        jw/7gzXPID1yTbxExKCmfx+kd2VXcWvs2QLIzOi1hg==
X-Google-Smtp-Source: AMsMyM4kdVFylTXfA6FM8xY8axVjaBWiaQEF+FUnFYjRSXBpMV5wYMwqbp4Gdq5EBHSBdeNF/gET466fMdMwNRFqj/U=
X-Received: by 2002:ae9:eb48:0:b0:6fa:d61:4510 with SMTP id
 b69-20020ae9eb48000000b006fa0d614510mr43595869qkg.768.1668034827137; Wed, 09
 Nov 2022 15:00:27 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-10-oliver.upton@linux.dev> <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
 <Y2wswsHgDHIIXram@google.com>
In-Reply-To: <Y2wswsHgDHIIXram@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 15:00:16 -0800
Message-ID: <CANgfPd_=6r1pmuNbrEdiom4JpryUBkVxxxmKTCN+xfiAQYrP0w@mail.gmail.com>
Subject: Re: [PATCH v5 09/14] KVM: arm64: Atomically update stage 2 leaf
 attributes in parallel walks
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
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

On Wed, Nov 9, 2022 at 2:42 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 09, 2022, Ben Gardon wrote:
> > On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > @@ -1054,7 +1066,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> > >  bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> > >  {
> > >         kvm_pte_t pte = 0;
> > > -       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
> > > +       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
> >
> > Would be nice to have an enum for KVM_PGTABLE_WALK_EXCLUSIVE so this
> > doesn't just have to pass 0.
>
> That's also dangerous though since the param is a set of flags, not unique,
> arbitrary values.  E.g. this won't do the expected thing
>
>         if (flags & KVM_PGTABLE_WALK_EXCLUSIVE)
>
> I assume compilers would complain, but never say never when it comes to compilers :-)

Yeah, I was thinking about that too. IMO using one enum for multiple
flags is kind of an abuse of the enum. If you're going to put multiple
orthogonal flags in an int or whatever, it would probably be best to
have separate enums for each flag. That way you can define masks to
extract the enum from the int and only compare with == and != as
opposed to using &.
