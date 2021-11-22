Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533134595C5
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 20:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbhKVTvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 14:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbhKVTvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 14:51:51 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD73FC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:48:44 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id x6so3181138iol.13
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7b8ONzI4O1Cf/Wv2mQ+ZJBesgO4gEQA4zliRNKUs7A=;
        b=ZA8vvZhM/dx5Z79tuvrByHtEj+m9vebq95Cl6xjd4BBf6XzkwJK3CfO0ftQVWllsam
         Z0c6PNnkPj26Dm4l3bKah13gMadP1VRi/Gg6VFdglxYNZ3sFK87S9uz4IApbcYKZr8CG
         VocPq9MCmXsc1HbBDnFwfcPMgflawmPIdK1Tiupfz+PmVM0BmHZrJP6uNbaTG2l0THsg
         wmjx+dCTAbRnzLni0AXizp1tp3b5m2tAFqU4ByZLE4/G1HIbP04EYd0NTKLJvmqvT5uJ
         xZ3FGgE49OvY6iVRlWfoRvsj0P5lGr7sUV7/MxRNL8yFhyRYAYUo24QGpEeaV9Ke0cHX
         EnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7b8ONzI4O1Cf/Wv2mQ+ZJBesgO4gEQA4zliRNKUs7A=;
        b=6hUvnFybxuyYwCiBazpFKwsIzmG2SMLHZxFkdnrpa0AejRXds1Xb42RYV09xJWB0nj
         j0Tsi3/AnurEtAhOEumFD7AeH2kl6InAwNvXV+M7T7MlySdKEqTutTbMNOTSv9RfFy97
         07rXUTC6VOiDWDMnFlH1lOG3tR1Yp1wVYs3kiwcSXvwP4y/gFvFvDbrgmRJwHlxGMs/a
         M65F3cybPY8yvponuJjEVVMFBmRy1xYW06uxFYj0KJU/cj+rXt+/x9VHN01EyBrx+29w
         MqYMKDNX4eX8ojbsom9V3bfApyvjdNCZB+ZfOb5DvBqqjRtbynmuN2bmIwGT9apqxXbS
         9Qcg==
X-Gm-Message-State: AOAM532tnsMwIFeDCRSVniACU2XOETW7pUCdWo2u1hikeK/MqIWpA9cF
        AoDRyHaWL82hR5S4m5SS8Zu6HUNMG8Py+flWrDvYXA==
X-Google-Smtp-Source: ABdhPJzEXIZWMRTl2+TlMEQiNVQw6LVHIdMgpG2rxLA+qxqYEr0Kt4kk7MyAG/gclsqOODk5xSIKHV+bJzLIm62PLuk=
X-Received: by 2002:a5d:8049:: with SMTP id b9mr25075552ior.41.1637610523811;
 Mon, 22 Nov 2021 11:48:43 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-2-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-2-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 11:48:33 -0800
Message-ID: <CANgfPd-LdHPySzoL3_e4q2fHOzjdXe-Z=4j01Sw1f7A8bdhOOw@mail.gmail.com>
Subject: Re: [PATCH 01/28] KVM: x86/mmu: Use yield-safe TDP MMU root iter in
 MMU notifier unmapping
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use the yield-safe variant of the TDP MMU iterator when handling an
> unmapping event from the MMU notifier, as most occurences of the event
> allow yielding.
>
> Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 377a96718a2e..a29ebff1cfa0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1031,7 +1031,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>  {
>         struct kvm_mmu_page *root;
>
> -       for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
> +       for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
>                 flush |= zap_gfn_range(kvm, root, range->start, range->end,
>                                        range->may_block, flush, false);
>
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
