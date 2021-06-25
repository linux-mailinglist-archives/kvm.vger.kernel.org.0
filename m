Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3FA3B3A21
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 02:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhFYAXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 20:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFYAW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 20:22:58 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A00C061574;
        Thu, 24 Jun 2021 17:20:37 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a127so6605260pfa.10;
        Thu, 24 Jun 2021 17:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=QS1Ns1WqNL5is+0vi/ZTUFuxlVcqVbsqm8g6SHrti5w=;
        b=esFkhH15NMc8wS4V/cwcupYK/DM+pO31de2/rn7330Vbdh9CSH9nvb+7DxAuWpBq5q
         I7HhRjIAf3sfraAsSUg5Y3qXSa9eVE9+YVQ00KJALtXy9kkDyH52E89nrtf01dGKriH8
         b00IMLN+V/HOLpi8TtU0LZ1hk9cAx0kkRlMaPdbbDzt+jClVFu+NXDMdkVwZY7xsN+Pb
         tP4yZoVaJBNxRaG8tctEZTIYWsIItqZBewSg9WSZ8LdCnbR+ioG4SZD7hACLKDcVik91
         hFNd/jFL7BVxEVmattHQ7LktCFlqiNNlX/MEUpDQB/QeQIQwm0YNoc++AkYkd7w7Rqkx
         Ypjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=QS1Ns1WqNL5is+0vi/ZTUFuxlVcqVbsqm8g6SHrti5w=;
        b=YgkVjfNbEdDHP7YVXaHLq02YZdUEBIafBn0lGy/Gdvciz30U+C+2dAnVJxJ1ZO62NL
         C2+eLE0cmR6nUeElURkBDox785SxTQskNEiWYPyPB1yP1eUvqUyrZIZAHfnacwizzSQC
         Dhjlix84TV0axSeTb6xDuSlEe0W16TO19IUiv8naWKicpVW9zfrmL4MY+JKJ+dw8CGGn
         Z0P42M8Snchw2QMzjHTUxIKFplLSU37xaefcLYtcZvaL/fLOHVeM002SPchKgRDIUECB
         362N5X6kAl5dAjl0i6tHWRWmEc5En+T2pQan3/f8GnQReZFTOMzJdWFAZrImKuiA8btu
         a9rA==
X-Gm-Message-State: AOAM533q+Rh9wMMUrSVkFjesz4Mprw7pkSSRXpqi+ONRh1ZKuRoOOoCz
        LFbIY6cKcRlotgxW8GpD5TI=
X-Google-Smtp-Source: ABdhPJxQU7+bPuGhEylfTnovn9GkVLr4KlmlOjHYTX0Un3AOHd4dWxP2gfr/obThDIjB30qffkhRJQ==
X-Received: by 2002:a62:2fc1:0:b029:305:fd1e:e3f4 with SMTP id v184-20020a622fc10000b0290305fd1ee3f4mr4774381pfv.17.1624580437511;
        Thu, 24 Jun 2021 17:20:37 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id z18sm3630623pfe.214.2021.06.24.17.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 17:20:37 -0700 (PDT)
Date:   Fri, 25 Jun 2021 10:20:32 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64
 MMU
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        David Stevens <stevensd@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
        <1624530624.8jff1f4u11.astroid@bobo.none>
        <1624534759.nj0ylor2eh.astroid@bobo.none>
        <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
        <1624539354.6zggpdrdbw.astroid@bobo.none>
        <81d99029-ec40-19c5-5647-20607d78dab0@redhat.com>
In-Reply-To: <81d99029-ec40-19c5-5647-20607d78dab0@redhat.com>
MIME-Version: 1.0
Message-Id: <1624580015.hf7udh0vc3.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Paolo Bonzini's message of June 25, 2021 1:35 am:
> On 24/06/21 14:57, Nicholas Piggin wrote:
>> KVM: Fix page ref underflow for regions with valid but non-refcounted pa=
ges
>=20
> It doesn't really fix the underflow, it disallows mapping them in the=20
> first place.  Since in principle things can break, I'd rather be=20
> explicit, so let's go with "KVM: do not allow mapping valid but=20
> non-reference-counted pages".
>=20
>> It's possible to create a region which maps valid but non-refcounted
>> pages (e.g., tail pages of non-compound higher order allocations). These
>> host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
>> of APIs, which take a reference to the page, which takes it from 0 to 1.
>> When the reference is dropped, this will free the page incorrectly.
>>=20
>> Fix this by only taking a reference on the page if it was non-zero,
>=20
> s/on the page/on valid pages/ (makes clear that invalid pages are fine=20
> without refcounting).

That seems okay, you can adjust the title or changelog as you like.

> Thank you *so* much, I'm awful at Linux mm.

Glad to help. Easy to see why you were taking this approach because the=20
API really does need to be improved and even a pretty intwined with mm=20
subsystem like KVM shouldn't _really_ be doing this kind of trick (and
it should go away when old API is removed).

Thanks,
Nick
