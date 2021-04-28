Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA936E121
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 23:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhD1Vre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 17:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhD1Vrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 17:47:33 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1406C06138C
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 14:46:46 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso45646985otm.4
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 14:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jE1E10cGmiSxQu3rQMfcH0+7CTwQjkmgUeVjmmNpp6c=;
        b=l/8TzlssY3PiJZtW54q7AoA6lZZauP2ipudz7fax18/n36l3wFP+NFeJKcr0NQGpzs
         LttGshZngyDW4v/9Fp6Nx+O43NfXC86dgxGG7lHkn/23tMgWxXL4f6M4Q2nshTc/tiB+
         YKzGBqlbYPPhYjSaFEI0M+5FEjwt86AcDMfbzGBhcAk2yOyLOTswO6BnywhSQnCz7CXG
         8kyU/OYuzsaybobtl2O71BpVIJip5teIk80KgZG8JDT471+CGpMr3Qzq94WiE4YfqWt0
         E5G+2HIw95CualvAqUfzl1+FzNnPTozfKWGaolIp+edUiwtcyBs3hZQWScbh3GEDX2J0
         dt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jE1E10cGmiSxQu3rQMfcH0+7CTwQjkmgUeVjmmNpp6c=;
        b=K68pFm1/u1rdelk0Hmdb4fJGye0NsDnD38z/dVBu1SEBsnTAA+qq48yvZrn/hf4af9
         1wAFv3LgWFF2iuzv0fO4gDdpy6vXmmwyM+V25+oSkJ9s/IDQRnyZePBXwLaEWgQDsIMu
         h530UrywQ8KJ9QDUI6EhDHFfmekVmuuZfAeZbER35fhagTuWF1EP7SPseGLoJzd7L7pq
         J4LLS1yeyEeHtl9IQCn6249A2VibsQVh12l8GF3azDRtW/0uvbSMFJvI0sczmzumTiZz
         x3SE0Obo+C5y+dmsBG4FrVZ1Y/s/Yb+ha0vnKdX6I+J8kieT7znTIsI+cyZgfi74FqYu
         ErEA==
X-Gm-Message-State: AOAM532JIXB4yt2YchL/MPPx6t76WBx/MoZ1Rt+wospuZcmhluJREICi
        W2ZEZL3RePdnCi0RE/9Bty/6Fsf9kH46hatS/nXlzg==
X-Google-Smtp-Source: ABdhPJyVeEMpGccCeYGNaaZT+WV/zN9QlttdEHQB/v6dvzGpqw+lSuV7EjrlOrp+iX2mwJthQfOdbdlbhCatSgwH0/M=
X-Received: by 2002:a05:6830:2159:: with SMTP id r25mr25458409otd.313.1619646406176;
 Wed, 28 Apr 2021 14:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com> <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com> <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
 <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com> <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
 <5b4a0c30-118c-da1f-281c-130438a1c833@redhat.com>
In-Reply-To: <5b4a0c30-118c-da1f-281c-130438a1c833@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 28 Apr 2021 14:46:35 -0700
Message-ID: <CANgfPd_S=LjEs+s2UzcHZKfUHf+n498eSbfidpXNFXjJT8kxzw@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 2:41 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/04/21 22:40, Ben Gardon wrote:
> > ... However with the locking you propose below, we might still run
> > into issues on a move or delete, which would mean we'd still need the
> > separate memory allocation for the rmaps array. Or we do some
> > shenanigans where we try to copy the rmap pointers from the other set
> > of memslots.
>
> If that's (almost) as easy as passing old to
> kvm_arch_prepare_memory_region, that would be totally okay.

Unfortunately it's not quite that easy because it's all the slots
_besides_ the one being modified where we'd need to copy the rmaps.

>
> > My only worry is the latency this could add to a nested VM launch, but
> > it seems pretty unlikely that that would be frequently coinciding with
> > a memslot change in practice.
>
> Right, memslot changes in practice occur only at boot and on hotplug.
> If that was a problem we could always make the allocation state
> off/in-progress/on, allowing to check the allocation state out of the
> lock.  This would only potentially slow down the first nested VM launch.
>
> Paolo
>
