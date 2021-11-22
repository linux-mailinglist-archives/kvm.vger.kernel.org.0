Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0C14597DC
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 23:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhKVWwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 17:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhKVWwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 17:52:44 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE82C061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:49:37 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id i9so14238623ilu.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q8VwkMHpFNnFdzRNWiCp6tnpWpX9qcaoYvQPMyder14=;
        b=sRTD4QJQBQ1UG5qfHLvRYQMWeMIJeLpzw+oSGs8Z0kj6bI8dunoJHkoMBg3Iwk2LXJ
         yZpzzUsanlPC9+TRlPpSOxAGCMvAWfknoms7fS0FxNI1nNic5Cj0nIgrsWYpvDJYyVL1
         SA1Bve0QbKEPEUj5YYwIYGxZcCh2LE24kSCCrXyqNo72DahiqGJau7s7/k2PDmKplS3T
         0CmbAODlbdLN5c7ef6s/q4B9cnX1L3MbBVjFt4IbWlfVcaFpN7qDGdQisEEtB/AD7gdY
         qhNM2jz2f5TkFcFFVPCH5H34v6yJb4djbYZIpb9V5BsBmZOHfhmLsg1QoHBWPBnrLz+b
         g2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q8VwkMHpFNnFdzRNWiCp6tnpWpX9qcaoYvQPMyder14=;
        b=tEycz2DiFRT03c9+qmWp3GA1y55Db0DyCHgHhWKupMzA2xNjNtpkcoCyhNkd8snz8i
         NkRzPr5WVH/NOn29LThDhry2ENEqAhYAnpAFB73586ptY+vejC9/C/Fhw2ewdzCE7Lfx
         DM2vTQOcklNiqpMwisSVqo7uwJHIOrsiDKlF9cAjDcYkqqZ9vieC2W3eFY21GNRVXrV/
         aWoyyiphgel4WzoXUqje10HNXe7pskyekkS8UbdmPEmsBzN9AwDlmxi2HphfD7J3WwV5
         AbkX79/WL/9YT9n2zTvm/ipCMeagFEsgyJi4vKSuPJ2lJYJWGVS59dsZoOvTBuWxUE9y
         itBA==
X-Gm-Message-State: AOAM532Wp10lbhryOtJVHPzKzzPjOgOVzkNwabE1C0kMDjvYPBGJ0f/O
        62wkYzIakDfeoZcu/LWIq9XV9XnECe3sTwkhBBHu5A==
X-Google-Smtp-Source: ABdhPJxYT4J2t4C6ULQlvRTl1gS6hjflGyeDEV1HOwqBN9omtqd+llYfd9eBFtfw8ecMl0UaDwLlzxJe3n9sVI+T0Zo=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr521603ils.274.1637621376511;
 Mon, 22 Nov 2021 14:49:36 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-21-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-21-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 14:49:25 -0800
Message-ID: <CANgfPd_XRtQ9JM03ZaaW73JZ8Npu+47t73SySiax9rvVEXyaHw@mail.gmail.com>
Subject: Re: [PATCH 20/28] KVM: x86/mmu: Use common TDP MMU zap helper for MMU
 notifier unmap hook
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

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use the common TDP MMU zap helper when hanlding an MMU notifier unmap
> event, the two flows are semantically identical.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ea6651e735c2..9449cb5baf0b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1112,13 +1112,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>                                  bool flush)
>  {
> -       struct kvm_mmu_page *root;
> -
> -       for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
> -               flush = zap_gfn_range(kvm, root, range->start, range->end,
> -                                     range->may_block, flush, false);
> -
> -       return flush;
> +       return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
> +                                          range->end, range->may_block, flush);
>  }
>
>  typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
