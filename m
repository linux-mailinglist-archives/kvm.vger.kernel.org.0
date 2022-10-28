Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F05611B5E
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 22:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJ1UFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 16:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJ1UFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 16:05:53 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF0955AA
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 13:05:52 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id j7so7312816ybb.8
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iq09YyTbxlhygVIxE+oSr303T+V0KsDhU1YWHrlUm4k=;
        b=Zl7p7xYXx+ZRDbJJhsmGs7Q2RsPA0XQfchF+yvv859tmneJWPRbSSeWmDlKaJU4276
         9+4P2olxo8uN5+ruLPQEKWIc+GdwQSXGJtoavpULk1RgBGP8eWecXF8osOKxAWasm7RX
         5tn4WluL65+i6Rmd7xIcQ7UDFFspnMS1xIDqiAuEfjOavj01w+V3L/yT7Z0kdLyOrNIW
         luQ37wRCgFSFdNlf/98//4fpP4XugyD0prRLpvJpoFNh2uspv7FR3rS7yn7aBlppyq+u
         N65C18SEfTgSIFAUcxR458wnSKWrBmz2z7W1YTOXZrNSXpEboVmI7YdPJ/acCiGAGxsh
         4pDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iq09YyTbxlhygVIxE+oSr303T+V0KsDhU1YWHrlUm4k=;
        b=pn35tkm+yGh4vOeFcWzEuvec9iNBKRXBEJXDVjUn/WU75ah3P8ZI05iZ92BZPXHQh0
         QdOIZvMZbszS0DG6CaAFz+yL0RS9n/tsst+gMclH8PdmgLIVXqIjlAxuxIcWaD99xlax
         NQ+I+6TqZ1tVSBLbQ2YP5pvLo9DrUiD5b+fAi5fkUQG91ZDSfzyH2lffTjyKQFgAGB/6
         CeBcvBSxJy+516y8BVA5l3hzvf7tRzk7z490Ggw9S1hrVfY3P+WYfxJKmiVaKN7Tl+9/
         adJf0oKy/SOoFzsknyEnjfEwEBBVvdZM7tafbez8mJihdf7s2zPSavIyvm1g5dFG/1LM
         6iWA==
X-Gm-Message-State: ACrzQf1DTIymqKqpH+fzyH/NryrBThy4hxldw+m7djUphZsUp13OR5Zk
        6F6T3c+VaT1sp32eH/vqw7Lc83AGg6v8x6eHUx95Hv9PE6o=
X-Google-Smtp-Source: AMsMyM48PMWjZ5/cDHm4O6ZDG9B8TKw3IruT3XgiUQksft1+hA6GuyJMBYKdKNqOhkhiM0gSnkISq0yKiSVyE5moEvw=
X-Received: by 2002:a25:1609:0:b0:6cb:a9d9:5f04 with SMTP id
 9-20020a251609000000b006cba9d95f04mr923001ybw.305.1666987551686; Fri, 28 Oct
 2022 13:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200316.2221027-1-dmatlack@google.com> <7314b8f3-0bda-e52d-1134-02387815a6f8@redhat.com>
In-Reply-To: <7314b8f3-0bda-e52d-1134-02387815a6f8@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 28 Oct 2022 13:05:25 -0700
Message-ID: <CALzav=e-gJ77LCo7HsL4X37B96njySebw8DGbPV_xcHbhaCBag@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Do not recover NX Huge Pages when dirty
 logging is enabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
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

On Fri, Oct 28, 2022 at 3:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/27/22 22:03, David Matlack wrote:
> > This series turns off the NX Huge Page recovery worker when any memslot
> > has dirty logging enabled. This avoids theoretical performance problems
> > and reduces the CPU usage of NX Huge Pages when a VM is in the pre-copy
> > phase of a Live Migration.
> >
> > Tested manually and ran all selftests.
> >
> > David Matlack (2):
> >    KVM: Keep track of the number of memslots with dirty logging enabled
> >    KVM: x86/mmu: Do not recover NX Huge Pages when dirty logging is
> >      enabled
> >
> >   arch/x86/kvm/mmu/mmu.c   |  8 ++++++++
> >   include/linux/kvm_host.h |  2 ++
> >   virt/kvm/kvm_main.c      | 10 ++++++++++
> >   3 files changed, 20 insertions(+)
> >
> >
> > base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
>
> This can be a bit problematic because for example you could have dirty
> logging enabled only for a framebuffer or similar.  In this case the
> memory being logged will not be the same as the one that is NX-split.

Ah, thanks for pointing that out. It's good to know there are other
use-cases for dirty logging outside of live migration. At Google we
tend to hyper focus on LM.

>
> Perhaps we can take advantage of eager page splitting, that is you can
> add a bool to kvm_mmu_page that is set by shadow_mmu_get_sp_for_split
> and tdp_mmu_alloc_sp_for_split (or a similar place)?

I don't think that would help since eagerly-split pages aren't on the
list of possible NX Huge Pages. i.e. the recovery worker won't try to
zap them. The main thing I want to avoid is the recovery worker
zapping ranges that were actually split for NX Huge Pages while they
are being dirty tracked.

I'll experiment with a more accurate solution. i.e. have the recovery
worker lookup the memslot for each SP and check if it has dirty
logging enabled. Maybe the increase in CPU usage won't be as bad as I
thought.

>
> Paolo
>
