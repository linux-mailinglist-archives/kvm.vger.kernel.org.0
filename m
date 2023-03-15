Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820C16BB73F
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 16:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjCOPNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 11:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjCOPNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 11:13:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AC41E293
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 08:13:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n203-20020a25dad4000000b0091231592671so20540840ybf.1
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 08:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678893219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=igb29Lv6teQ/KLxEPbILcI69WT+IeDSiIl02ryINK0U=;
        b=qwx+pwGWTkfuBIFZ8WJJIlE22H6OxlI4L+byyyu7CpI+6kNCjD5QcFUWkE849GJGnk
         w/QbXXS4/3a2Z7I0UKpf3OW6Mp4RexCo5T1LV3ot7X9oXXR/IDb4BIFmAgJ+lTukS4R9
         7I1yrA0w2HyUSHOds9PXcpR3yvpLs4jT+sFJ33OaBrYM0HyJfhySfiih3+jYblrp8joN
         EnbUrasj0tSqJborj2MP4+ejpZ9at2WQvxVZZpIYfe5+J7zUbW7v1bPjdoWmBMycNtHL
         z2zGhnR5fZfIQ7zvf98mHBmrSxUKlVpsbwoj3Yw+jZRk0IL2UOkNjDaBgWmgA9zQJNO1
         wliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=igb29Lv6teQ/KLxEPbILcI69WT+IeDSiIl02ryINK0U=;
        b=c9eoUZp8TAAuRtU28dsj5LuuMGkWk6gdhHYNve/FsW3y7vqVWQbokpdHygAmV6nXhG
         rC4KtfZN56PLCwl/IB9w/GjzUiEdDIcE40c1iSe6yQPpS6aHLb6bpWTTzuhCU92oSEMM
         g33pf/iVJzHnkpss9TTw4UA8Ykqxcu80/KbEKbeByK6UDK4PgsHWJTVHcldKHtjwI6h3
         XUJvkIAcbPeVOuO72IKFbG3TUcpKg+ZZS5zc/tpGXKB4DSdZZlIOIqaIH5D3kzx74uS6
         nXInioyniKgls1e8qDGD6c+eeZAJYlguwB9qncGRyFgq9KRE2ELTXf6nEBoPJoTr7MM5
         0nwA==
X-Gm-Message-State: AO0yUKUdamISC7WwHBWLu7GuiVFb3T4TxirQF3PngFBLcswS0UM99p/2
        JLCstxA8UGjpW/5VQa+V5wHGlqDbII0=
X-Google-Smtp-Source: AK7set92lEDFc7yP4SaEhv7nzCL2HlcwCZvuRQrW8ZqYLEa9wbXKpFtBlkwMtMCw7w58n3f+4HvOUaVGDM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ca4f:0:b0:541:7237:6e6b with SMTP id
 y15-20020a81ca4f000000b0054172376e6bmr200343ywk.0.1678893219401; Wed, 15 Mar
 2023 08:13:39 -0700 (PDT)
Date:   Wed, 15 Mar 2023 08:13:37 -0700
In-Reply-To: <ZBGFXrpSXpF5NUlV@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-20-seanjc@google.com>
 <ZBGFXrpSXpF5NUlV@yzhao56-desk.sh.intel.com>
Message-ID: <ZBHgoS/4R35KByOp@google.com>
Subject: Re: [PATCH v2 19/27] KVM: x86/mmu: Move KVM-only page-track
 declarations to internal header
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023, Yan Zhao wrote:
> On Fri, Mar 10, 2023 at 04:22:50PM -0800, Sean Christopherson wrote:
> > Bury the declaration of the page-track helpers that are intended only for
> > internal KVM use in a "private" header.  In addition to guarding against
> > unwanted usage of the internal-only helpers, dropping their definitions
> > avoids exposing other structures that should be KVM-internal, e.g. for
> > memslots.  This is a baby step toward making kvm_host.h a KVM-internal
> > header in the very distant future.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_page_track.h | 26 ++++-----------------
> >  arch/x86/kvm/mmu/mmu.c                |  3 ++-
> >  arch/x86/kvm/mmu/page_track.c         |  8 +------
> >  arch/x86/kvm/mmu/page_track.h         | 33 +++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.c                    |  1 +
> >  5 files changed, 42 insertions(+), 29 deletions(-)
> >  create mode 100644 arch/x86/kvm/mmu/page_track.h
> > 
> > diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> > index e5eb98ca4fce..deece45936a5 100644
> > --- a/arch/x86/include/asm/kvm_page_track.h
> > +++ b/arch/x86/include/asm/kvm_page_track.h
> 
> A curious question:
> are arch/x86/include/asm/kvm_*.h all expected to be external accessible?

Depends on what you mean by "expected".  Currently, yes, everything in there is
globally visible.  But the vast majority of structs, defines, functions, etc. aren't
intended for external non-KVM consumption, things ended up being globally visible
largely through carelessness and/or a lack of a forcing function.

E.g. there is absolutely no reason anything outside of KVM should need
arch/x86/include/asm/kvm-x86-ops.h, but it landed in asm/ because, at the time it
was added, nothing would be harmed by making kvm-x86-ops.h "public" and we didn't
scrutinize the patches well enough.

My primary motivation for this series is to (eventually) get to a state where only
select symbols/defines/etc. are exposed by KVM to the outside world, and everything
else is internal only.  The end goal of tightly restricting KVM's global API is to
allow concurrently loading multiple instances of kvm.ko so that userspace can
upgrade/rollback KVM without needed to move VMs off the host, i.e. by performing
intrahost migration between differenate instances of KVM on the same host.  To do
that safely, anything that is visible outside of KVM needs to be compatible across
different instances of KVM, e.g. if kvm_vcpu is "public" then a KVM upgrade/rollback
wouldn't be able to touch "struct kvm_vcpu" in any way.  We'll definitely want to be
able to modify things like the vCPU structures, thus the push to restrict the API.

But even if we never realize that end goal, IMO drastically reducing KVM's "public"
API surface is worthy goal in and of itself.
