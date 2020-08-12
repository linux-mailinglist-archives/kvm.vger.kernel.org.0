Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9900324306C
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 23:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHLVPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 17:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgHLVPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 17:15:47 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ADFC061384
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 14:15:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g14so4667785iom.0
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 14:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ATFnAwg2Qd0ShiTikqRcosJRn11gItg3MuBgdXg3xrE=;
        b=OmjqwHnLTGaU3gISWHh6IbuFCbNeRwPwl7DN2n7vFlD2T4z7FIJ2+ojZG92zhUkEYP
         9VDJPV8sk4DTFa4Y4woLuKtanStU3X7AN6INks5i4MeR8q837H6F8hJz0uVDBJ5DUcRF
         4cpFDYirAaa+aJ+2S5CaTs9tNiHa9IpMzjw/CQwPV26/JEriMVrtbmU8FqDLdqqbhfFh
         pMSpmuRfSAQ7P14NJiGMQ21bI7THJsZnvrG7PWDLgRKycREOsAWROjnKpmj05+mx23hJ
         QATfhTQqkiKBVglbGeFo8j9xBAiUQ/rnHHeMZM5Ee4QTvpXVYXSF62kBJ+eR5bFCpN3v
         qC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ATFnAwg2Qd0ShiTikqRcosJRn11gItg3MuBgdXg3xrE=;
        b=dMBBSipIwKVbkjc8KAA/aMw7x4fO2QOYQ/EZmgysdyZQZ+CONi+EDeQYSc5+WWRuZq
         FCvKKXOgsx14Y4tnN1McltOyqxzehpG2Aictpt/8l5J57GtL+qdBEukIPzyGYs16jI7Y
         nWHWBpQ/Rnm6h2mz4lMVuSQz1C3IHDj+YkUIbE72Ez5sjdhshRRhp+EImCHa+m3I1gVN
         YENM4I3cxQC1e3AipirJKOda74P2x/2YD8rL0+DMhPT6N6fQqQPSVm7MnV/L8Z+i9MwL
         kqDiXEIf9WEeNiG2Id9PYdeuXRHOknIs/F7d0EycUx1bTxQo22q3GpKmd7hshQ/yDQzm
         gNVQ==
X-Gm-Message-State: AOAM5305I1CXryKgJxebfOGRK4W0zfeQkD9VWDGGQm/rsHPanyKCse8C
        tZV+hgVhHkYgl5jasPCgTl2O5VAt9idq6EK6LqtpQw==
X-Google-Smtp-Source: ABdhPJzXCwEfMKfiLbS1llHeqVdhn7VQbQfg9jl+NulOWs5WcUDmBqauEhiEdqI7kCEDhQ/dTgUkXNG9h6j3Xq6/3qc=
X-Received: by 2002:a05:6602:599:: with SMTP id v25mr1699787iox.19.1597266945637;
 Wed, 12 Aug 2020 14:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200812192758.25587-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200812192758.25587-1-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 12 Aug 2020 14:15:34 -0700
Message-ID: <CANgfPd8vsgdduEfWLaQSyJkAD1zMgDmGJM+wbCyAXM2zq=rtSg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: x86/mmu: Zap orphaned kids for nested TDP MMU
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 12:28 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> As promised, albeit a few days late.
>
> Ben, I kept your performance numbers even though it this version has
> non-trivial differences relative to what you tested.  I assume we'll need
> a v3 anyways if this doesn't provide the advertised performance benefits.
>
> Ben Gardon (1):
>   KVM: x86/MMU: Recursively zap nested TDP SPs when zapping last/only
>     parent
>
> Sean Christopherson (1):
>   KVM: x86/mmu: Move flush logic from mmu_page_zap_pte() to
>     FNAME(invlpg)
>
>  arch/x86/kvm/mmu/mmu.c         | 38 ++++++++++++++++++++++------------
>  arch/x86/kvm/mmu/paging_tmpl.h |  7 +++++--
>  2 files changed, 30 insertions(+), 15 deletions(-)
>

Thanks for sending this revised series Sean. This all looks good to me.
I think the main performance difference between this series and the
original patch I sent is only zapping nested TDP shadow pages, but I
expect it to behave more or less the same since the number of direct
TDP pages is pretty bounded.

>
> --
> 2.28.0
>
