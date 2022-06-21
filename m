Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468E5553886
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352193AbiFURHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351511AbiFURHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:07:21 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E602CE2B
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:07:19 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id a11so7412239ljb.5
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FnOmw3gVk8tU+AE3cNeQjrjRVGb6taWwsuCOIfWCWxA=;
        b=YXKgy8GzJNpXWgsQ+ad6BrqIukKRln0aMHUpAz3ufqwzfs7i7BGubSSuGze4kyE/wN
         0vyoLZwVca0S2XXVcnvAoER6/ZyF44XgJGUi2tzkE2Xe6npHx30ng7Nr5M7fVo16rgk6
         gjIk5DT1zN/pCNT4kwvyq45YRaR5nZ4/Z59ys9rxb1ZKpiyk06/x/sR1xuyYtFmWpk9V
         Ln78wPfGHhHjaW3LDgPfga0c9htn6Ss8nTnj4aodGmeaoQlI3MWpLz42Y4dpS1D9jwQa
         8oKLu/8Fbg6PRfmjj8qzJUo/xsWDGvV5XIV+kyqzRt7lTYz85g2gYnvH4P5+ecQiZWN2
         H39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FnOmw3gVk8tU+AE3cNeQjrjRVGb6taWwsuCOIfWCWxA=;
        b=JewBzWxv0yTzejOxi8UhhITBv1hLZl67GMIaUU+Z6t+EpEXk/f72RJlapxazqBtZ2x
         3Il6hfyMJ5a8B5Az8O2qzYqKfY3LWe0Rcp39qwUQ7Mg3jpKoeywzklyaw7Q7KMZVWIjL
         8ksNUHURYj80ZPlH6i44JQ+tTJNEio0P0UFVjhUE58wvQca7Q8PkBdMcGt+7gOyBL1ur
         jdxVNVLNlH57FcXM8Edd4ahpmtQ47Zkico5qOIysUEcCxwbnp2Cu7cGBdZkLBPWr/Xym
         bU+1M2LxiJQpkYCMmznRwTe8IiD+HWFzHlBq0YdYKUrwXlveFmNw6EWZwHu5iYDDQj84
         Y0mw==
X-Gm-Message-State: AJIora8dCFMyPKSo5XN4sul+MttoD1xgfJ+BBpDeMJx98eVoCCxmOdxC
        DnwKa+B/H62ecdVZq1c5szKZhqJEvH8jazOOGU+HNg==
X-Google-Smtp-Source: AGRyM1vsnNiJzYI8a4JothArzJ6EPJeG8wTiRAa2dkNSnIZYaQB/MuJ0ERB2pxoUlEJx6kKfxtszHOI0qWmk6ygmp0w=
X-Received: by 2002:a05:651c:886:b0:258:df66:5040 with SMTP id
 d6-20020a05651c088600b00258df665040mr15428117ljq.16.1655831237279; Tue, 21
 Jun 2022 10:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com> <20220516232138.1783324-11-dmatlack@google.com>
 <YqyXYJsoZGgp7l62@google.com>
In-Reply-To: <YqyXYJsoZGgp7l62@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 21 Jun 2022 10:06:50 -0700
Message-ID: <CALzav=fVzX+GXCdKRwRGofAgKatX206_kBKagT7R-eYO9RnYkA@mail.gmail.com>
Subject: Re: [PATCH v6 10/22] KVM: x86/mmu: Pass memory caches to allocate SPs separately
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 17, 2022 at 8:02 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 16, 2022, David Matlack wrote:
> > Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
> > will allocate the various pieces of memory for shadow pages as a
> > parameter, rather than deriving them from the vcpu pointer. This will be
> > useful in a future commit where shadow pages are allocated during VM
> > ioctls for eager page splitting, and thus will use a different set of
> > caches.
> >
> > Preemptively pull the caches out all the way to
> > kvm_mmu_get_shadow_page() since eager page splitting will not be calling
>
> Uber nit, "eager hugepage splitting" to provide a mental cue/reminder for why
> those pages are direct.

I think it may be too late to move away from the term "eager page
splitting" (it is already in commit messages and the module param is
called "eager_page_split"). Using a slightly different name here might
produce more confusion, or at least cause readers to do a double-take.

But naming aside, I don't follow what you mean here. i.e. What does
the fact that page splitting uses direct shadow pages have to do with
this patch?


>
> > kvm_mmu_alloc_shadow_page() directly.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
