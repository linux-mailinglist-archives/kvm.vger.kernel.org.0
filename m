Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69FD40EAA0
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbhIPTIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 15:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhIPTHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 15:07:54 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9B7C0698D0
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 12:01:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f129so7124140pgc.1
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 12:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LWGKCuQIs1J+mHjjQn6Kx7XI5kMAoj6YxGUaQJDbGFk=;
        b=MBRkHKjm9buVZ2i0rRj8IkbkJrsV/vqBiMGVV7iiQvRhzq2pDAWDoSKl6vKZpqOoTv
         GE6v5ljOJw3UCUdVlSwLLeN+QZTiq3eJFhRLx4stblW2Ji7suhDN3xmLLdVJPYABmpWs
         8JIhWsB8S9Z6S5lJjTSu96z9Tng83WUYSZW+/8ULKPPGwGqzB+G9g5DtC20TNxdOwZSC
         Wrs6SaaBBviwofJu2Slia3KQZM/V56B+tKIm9ATrULYxTSC2K55tBOQ0KRmTVbib4eWK
         5VLygWRjMqPL35hSBp/YukyOGIxNMLr356QgmmuVBbhDpfIOV3ja4hLI918NMzkFQUlt
         FSNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LWGKCuQIs1J+mHjjQn6Kx7XI5kMAoj6YxGUaQJDbGFk=;
        b=OQYm0s8/fNcaqE2d342cNzMp5L8Wa7jzq3JW8XqqnvxbSiFFP+QLcNA7e7jEungMjh
         gTYFJljVa3ob+JT7AKqqqwOKoU7GzyhVo+9ZAqUjZIOgJlo5tPBD0PBtOzVEbTAdXW6+
         vwg4Khnz9PMGq4eAODQ5H/7jADCBnJu0fpWwCzZcG9G2but20WbUoU4XgdTQgyCZrQA8
         D1hmr9OhfuOUAHuqbYrO2JaJAY/lF9fY+iH8xmtQGU1VOLp4lfEEfh9YrSSK7QQ7LzGT
         yMAtZ+LwwhbmmRCDV9ft3qIG/h8rPlxKe8Ivr29yjFrq+g9F21nhzmE696YonwVldkj9
         BfHQ==
X-Gm-Message-State: AOAM532xjHdcKkB4L0dJSQ3+XXWVCx8SRtPL/2ZShS3wtMfyHLmmFAZg
        eBXbP8WXR0XAvC0iEhLLd9rUhg==
X-Google-Smtp-Source: ABdhPJxdM+f5k++5dg9ZQ1aaLsllg+p45QsdJwHHJX3JOrhFr2rnv/z1wzRu03c/kyjxU9eCr3MDOg==
X-Received: by 2002:a63:b218:: with SMTP id x24mr6260838pge.335.1631818892985;
        Thu, 16 Sep 2021 12:01:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g4sm3511388pjt.56.2021.09.16.12.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 12:01:32 -0700 (PDT)
Date:   Thu, 16 Sep 2021 19:01:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
Message-ID: <YUOUiD0J5Qihao+4@google.com>
References: <20210914230840.3030620-1-seanjc@google.com>
 <20210914230840.3030620-3-seanjc@google.com>
 <875yv2167g.fsf@vitty.brq.redhat.com>
 <YUIunxwjea/wq3gd@google.com>
 <87wnnhyolr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnnhyolr.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > @@ -10897,6 +10899,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >         kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> >         kvm_rip_write(vcpu, 0xfff0);
> >
> > +       vcpu->arch.cr3 = 0;
> > +       kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > +
> >         /*
> >          * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
> >          * of Intel's SDM list CD/NW as being set on INIT, but they contradict
> >
> 
> A selftest for vCPU create/reset would be really helpful. I can even
> volunteer to [eventually] write one :-)

Hmm, I wonder if it would be possible to share code/infrastructure with Erdem's
in-progress TDX selftest framework[*].  TDX forces vCPUs to start at the legacy
reset vector with paging disabled, so it needs a lot of the same glue code as a
from-RESET test would need.  TDX forces 32-bit PM instead of RM, but it should
be easy enough to allow an optional opening sequence to get into 32-bit PM.

We could also test INIT without much trouble since INIT to the BSP will send it
back to the reset vector, e.g. set a flag somewhere to avoid an infinite loop and
INIT self.

Let me work with Erdem to see if we can concoct something that will work for
both TDX and tests that want to take control at RESET.

[*] https://lkml.kernel.org/r/20210726183816.1343022-3-erdemaktas@google.com
