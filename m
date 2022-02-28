Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DE24C7AA7
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiB1Ukp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiB1Ukn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:40:43 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CFF1BE9B
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:40:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s14so19348816edw.0
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QHWRIsgExEW/r8rEtARZBdUV8xqvMrT0E0q1tM9lfYo=;
        b=NRvy8X8wInnCA+8LdqedLQG8Ir8G2R8ThdqidPIodSY2ccQsoG3SHWcZUOweRCuWQo
         eU+JihbmhJXDv60FaICZoOxBd/bsZmtag9GVo03Znw/tYTXYyCKgnDsSOEduZHSnKJ+W
         2LSLgE7Csp8wOCLnBbzEWFOIKSteiyJOKoU+nr+oOS/mzI3BjTU85Lf5CU1WMPerJ9kr
         C/FBlgSUVM2knMxG7RJrtEpK3z4rCguHGU0Y7rg2r/kCnLVo2cZaj+KXgbos38qLg4n5
         NGjTtnQyymkrlSB3dDaSi3mwCY1Tm0s2MD0Ytsmu37+YCNuGzlf0Vwhvg5jhWcftGapq
         NACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QHWRIsgExEW/r8rEtARZBdUV8xqvMrT0E0q1tM9lfYo=;
        b=kuipGOMN3SIN7hPUEYCfT1Gs0GvxdZsTHr19n35tQl+8YKklopeg3hQr3DQeRtWsPA
         WiUS0u/4agUKU9MhNjXZyEjpv7IUGTgLbUgThkX+ea+lOWQkQ99pzxl3FtkWmxKBIZJ6
         DgyxZIk2IeS3IEdHtYz1H956v07RPvMrOZ+s9cVtlRg+9cL1bWwHrH+XkaLNsIbA2TMg
         lHNWcyRnfyvrLXCYAZ7LKLUfJJjxDIlrvjomHaiE67Pxm5khgn3FGH1u+pYuJmwjNNIU
         RKA0/91UWxhcSu3wAMAuihzbonrUuLYl6ZquIQi3nk0sD9Q44SLZWfVinVeuWU1JiPSO
         AYog==
X-Gm-Message-State: AOAM530jjtrTZJG9YEw5c/0K2dDrfV0Jq+nd4b5WEGhvB6Ef/4hzUwko
        MZ6sznsNLb+rl5WsDQRkyWDE8LVne4tVVgY6LWWE/g==
X-Google-Smtp-Source: ABdhPJxp3HmlKQ/fUicuR/voY9gTGCCUcqm4OCOzY7/yu3PXx8BFrSu6sNU+xacP2yC/q1oOqQbNxsuv0Tp8gQ793EA=
X-Received: by 2002:a05:6402:1cc1:b0:413:2b12:fc49 with SMTP id
 ds1-20020a0564021cc100b004132b12fc49mr21495413edb.118.1646080800470; Mon, 28
 Feb 2022 12:40:00 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-17-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-17-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 12:39:49 -0800
Message-ID: <CANgfPd_bfxT0n3sH+D9mBTrtFkE722u7Rts1EbRm-ERpGF+X-g@mail.gmail.com>
Subject: Re: [PATCH 16/23] KVM: x86/mmu: Zap collapsible SPTEs at all levels
 in the shadow MMU
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
>
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> in the rmap). This leads to correct behavior because KVM never creates
> intermediate huge pages during dirty logging. For example, a 1GiB page
> is never partially split to a 2MiB page.
>
> However this behavior will stop being correct once the shadow MMU
> participates in eager page splitting, which can in fact leave behind
> partially split huge pages. In preparation for that change, change the
> shadow MMU to iterate over all levels when zapping collapsible SPTEs.
>
> No functional change intended.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e2306a39526a..99ad7cc8683f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6038,18 +6038,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>         return need_tlb_flush;
>  }
>
> +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> +                                          const struct kvm_memory_slot *slot)
> +{
> +       bool flush;
> +
> +       flush = slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> +                                 PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL, true);

The max level here only needs to be 2M since 1G page wouldn't be
split. I think the upper limit can be lowered to
KVM_MAX_HUGEPAGE_LEVEL - 1.
Not a significant performance difference though.

> +
> +       if (flush)
> +               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +
> +}
> +
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>                                    const struct kvm_memory_slot *slot)
>  {
>         if (kvm_memslots_have_rmaps(kvm)) {
>                 write_lock(&kvm->mmu_lock);
> -               /*
> -                * Zap only 4k SPTEs since the legacy MMU only supports dirty
> -                * logging at a 4k granularity and never creates collapsible
> -                * 2m SPTEs during dirty logging.
> -                */
> -               if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
> -                       kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +               kvm_rmap_zap_collapsible_sptes(kvm, slot);
>                 write_unlock(&kvm->mmu_lock);
>         }
>
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
