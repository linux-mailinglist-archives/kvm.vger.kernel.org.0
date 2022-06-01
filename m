Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D398853AF24
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiFAVwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 17:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiFAVwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 17:52:10 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFF6265A
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 14:52:09 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id g12so3401809lja.3
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 14:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+dyqxyikF+kVFqbQg9zxtZLrH5cxspSn8v4kjijbZwk=;
        b=jHw47GL/gVrHAJzujaQuk8oCrqYlAE9SfAUeA23UPfJj0WzZzwGHUMuIMbToeAYf8S
         CP+N9BlI2Ci78VEB5worbbv2tK5NaW6nCX2idshB7IvEquEUWi/3ktLVQeTn3FcrFRm2
         n3kt4si84S5D5COVfpkyiUBNbljgtjcr4uwPIG40rlehwu8rLRFzj6+WSeS8W/sS2Cyw
         C/U5lH8PxL8q8tMd1jgwVzi5FWcmv9UdthG+T7U7/rBwLYISGMBXH1H8+E0zNHKXmwVz
         Aszod8QpDgWW8aaUy7bcUb1bGoqmzC+1fAhi2GHWAK5FSK8/066dSkKsoBAR/ZgV8sdt
         4N8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+dyqxyikF+kVFqbQg9zxtZLrH5cxspSn8v4kjijbZwk=;
        b=YLQXF3YDOmVuBbk4713qmazWs5pGEh8ODszGWqfnFLWYhfAmBbMOvZgknOQOhS5nBu
         M0ZyqVuRBy0iHDTM60ZgUrEgcjH7s1uj4b87yKLWanGJScGxy7UGh2nDyMqeuKT/NPxo
         8CMaDmNloXPczbsUy6S7kBkhVscf9Vu+Xrli7Abd7QNxOHD0T4p0yp+sbY9faS7dLneL
         l/mVQLx4LVkktrTHNqUykV8BhP1S7KTk7qB6wBiY77G+qjK390RcuH3nI8FAfl411V5a
         iD7kDvLYRD0Y4FHA2i12rjHug2Ps2LakvMOH2xuHg5HV/7Iii7XEU9q8Ncz0COMDUoGW
         af8A==
X-Gm-Message-State: AOAM531pJtz6J0bVLrujOPmg2VyX9sDK2eiy0cu9q2EdtEUsNn06zGO5
        ITSezJl33ojYJ7ypj9VbxSeLXnVtCkRbziyNfZKjNKbbgmo=
X-Google-Smtp-Source: ABdhPJyNZOZ2qFtw7Fdhp0/nlhPkZCQuohGuRN3tzj7yJR+pOWks0Ryan7U8YrcfcRz/U6ngmPrEFoTo0lReXcjRABs=
X-Received: by 2002:a2e:b786:0:b0:255:70ad:74f0 with SMTP id
 n6-20020a2eb786000000b0025570ad74f0mr1642404ljo.525.1654120327733; Wed, 01
 Jun 2022 14:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220526071156.yemqpnwey42nw7ue@gator> <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-2-cross@oxidecomputer.com> <686aae9b-6877-7d7a-3fd4-cddb21642322@redhat.com>
 <CAA9fzEE3tdJuNwNDzbcoUQ39He7hKf2X=u-RAvq8fSHwD=3JZA@mail.gmail.com> <20220601174320.hniqb3roqdxkgdbj@gator>
In-Reply-To: <20220601174320.hniqb3roqdxkgdbj@gator>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Wed, 1 Jun 2022 17:51:56 -0400
Message-ID: <CAA9fzEHQ49hsCMKG_=R_6R6wN8V8fDDibLJee1a1xLCcrkom-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm-unit-tests: invoke $LD explicitly in
To:     Andrew Jones <drjones@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 1, 2022 at 1:43 PM Andrew Jones <drjones@redhat.com> wrote:
> On Wed, Jun 01, 2022 at 01:09:13PM -0400, Dan Cross wrote:
> > Thanks. I think the easiest way to fix this is to plumb an
> > argument through to the linker that expands to `-m elf_i386`
> > on 32-bit, and possibly, `-m elf_x86_64` on 64-bit. The
> > architecture specific Makefiles set the `ldarch` variable,
> > and that doesn't seem used anywhere, but I see that's set
> > to match the string accepted by the linker scripts/objcopy,
> > not something acceptable to `-m`. However, one can add
> > something to `LDARGS`, but I see that that's set to include
> > the contents of CFLAGS, which means it includes flags
> > that are not directly consumable  by the linker itself.
> >
> > I think the simplest way forward is to introduce a new
> > variable in x86/Makefile.i386 and x86/Makefile.x86_64 and
> > refer to that in x86/Makefile.common; possibly `LDEXTRA`?
>
> We do that for arm, but call that argument arch_LDFLAGS.

Ah cool; I see the pattern now.  Okay, I've modified x86 to
follow ARM in this regard and tested locally.

> > I've got an updated patch here that does that, and it seems
> > to work (building under both illumos and arch locally), but
> > before I send up another patchset, let me know if that
> > sounds acceptable?
>
> It does to me.
>
> Thanks,
> drew

Great. Next patch rev inbound.

        - Dan C.
