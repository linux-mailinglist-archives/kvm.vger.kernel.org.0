Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781E14D3C60
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 22:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiCIVuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 16:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbiCIVu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 16:50:29 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0734E986FF
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 13:49:29 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id 17so3024097lji.1
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 13:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NePZURQmz9Qw+EqqE01Ftdoscki7YMo42qYlDdTlIFI=;
        b=LVWO6vOEwtvC2Nx63v73Y98YXXT0KxQT4rWtWkw+iHOotUp4ZeggtejIn9FHtK42QU
         ejdjlMlpFZmWXefQzhP0Fyl96kLR3J5zSWs/Er/RBN9+EX3uI6tmIRXqjMu3EiX02r/j
         r4RF3lFG7k8pjQNdFJZSlzF0qxuYL0X5Rn064s4pNRpE79b6paChiYOYak5YmsMBsmMw
         qjixRYPP8hNRLpzQ33qTGFwR6zvlkZs3TlcKHbbfuG3T1c05b7vGzqzrQjrd/HIYyH9J
         eGy0/9KN1fZIvA1YXiG6IB50tzwpw7wJvxnUlk+L2y2/5XMBfmegGzD9nBYwGxZ9Tfv2
         7q5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NePZURQmz9Qw+EqqE01Ftdoscki7YMo42qYlDdTlIFI=;
        b=PZmi3wDYVlR4pEaTSWIELp6JZJifjiG2yIbeHrmBFyWc7Ljk3Ckdy/zPr5sr3+8KNU
         t3Hp5OIS7/5e9ETU2ETqFAZNlDcpeu7EHkVUfX6Oxs5nEnBNXNdEzK8j3qMHl+vNlDzT
         xnNDBf5MxGE6RSCqTFpKSRr5EVzciU4rPPEXqe0nmQ89SQLLDwLpZt+UrS9v4xrpW3XX
         X0v+R5J0LRJTuTG9j/VayGg0FHtRqxPQtK93RBleGmmetWf7/YLH5lZmaAvWpuS6BRMP
         YC7Xf5dSDKiSS7sfIGZY7KKSbXnupHh+kBYmF7rlq5EoKCcrHNtd3venP6FgtdztRJWt
         pIJA==
X-Gm-Message-State: AOAM532ZCKZURvR08Afwj9u/Br3KwvgxiF/ZpZbGiFO/PiF+eFEqQQ/C
        owTyOCgBXN9Yt2ZNrhFgwEE9OUrnBDpJgdtnWI9LdQ==
X-Google-Smtp-Source: ABdhPJyqQ68uZOnqXeUybfaP59aDugYhBOAIhbTPHduu3VePhUL/j6ha7inrZ0nd6KNSriCmARVOugVTS0k5c5uoGMc=
X-Received: by 2002:a05:651c:1501:b0:247:da43:5ffa with SMTP id
 e1-20020a05651c150100b00247da435ffamr1003051ljf.223.1646862568161; Wed, 09
 Mar 2022 13:49:28 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-20-dmatlack@google.com>
 <8735k84i6f.wl-maz@kernel.org> <CALzav=d9dRWCV=R8Ypvy4KzgzPQvd-7qhGTbxso5r9eTh9kkqw@mail.gmail.com>
 <CALzav=ccRmvCB+FsN64JujOVpb7-ocdzkiBrYLFGFRQUa7DbWQ@mail.gmail.com>
 <878rtotk3h.wl-maz@kernel.org> <CALzav=e7vH87uyphgL8vXPMmn8vX8TmkpUY_3OWuRXrKFhy_ag@mail.gmail.com>
In-Reply-To: <CALzav=e7vH87uyphgL8vXPMmn8vX8TmkpUY_3OWuRXrKFhy_ag@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 9 Mar 2022 13:49:01 -0800
Message-ID: <CALzav=dZXEx80JsTzQe1vyDg6c_NR89HXCcu=W1EsvShysW7HQ@mail.gmail.com>
Subject: Re: [PATCH 19/23] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm list <kvm@vger.kernel.org>
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

On Mon, Mar 7, 2022 at 3:49 PM David Matlack <dmatlack@google.com> wrote:
>
> On Sat, Mar 5, 2022 at 8:55 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Fri, 04 Mar 2022 21:59:12 +0000,
> > David Matlack <dmatlack@google.com> wrote:
> > > I see two alternatives to make this cleaner:
> > >
> > > 1. Dynamically allocate just this cache. The caches defined in
> > > vcpu_arch will continue to use DEFINE_KVM_MMU_MEMORY_CACHE(). This
> > > would get rid of the outer struct but require an extra memory
> > > allocation.
> > > 2. Move this cache to struct kvm_arch using
> > > DEFINE_KVM_MMU_MEMORY_CACHE(). Then we don't need to stack allocate it
> > > or dynamically allocate it.
> > >
> > > Do either of these approaches appeal to you more than the current one?
> >
> > Certainly, #2 feels more solid. Dynamic allocations (and the resulting
> > pointer chasing) are usually costly in terms of performance, so I'd
> > avoid it if at all possible.
> >
> > That being said, if it turns out that #2 isn't practical, I won't get
> > in the way of your current approach. Moving kvm_mmu_memory_cache to
> > core code was definitely a good cleanup, and I'm not overly excited
> > with the perspective of *more* arch-specific code.
>
> Ok I'll play with #2. Thanks for the feedback.

#2 is very clean to implement but it ends up being a bit silly. It
increases the size of struct kvm_arch by 336 bytes for all VMs but
only ever gets used during kvm_vgic_map_resources(), which is only
called the first time a vCPU is run (according to the comment in
kvm_arch_vcpu_run_pid_change()). I think stack allocation makes the
most sense for this object, I don't think it's worth dancing around
that solely to avoid the inner struct grottiness.
