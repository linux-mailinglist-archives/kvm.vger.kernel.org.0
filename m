Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DBE4C1FB7
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 00:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiBWXdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 18:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbiBWXdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 18:33:03 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FBB593AC
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:32:35 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id p9so655041ejd.6
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yzRwPt1xyo1MwjZwTxBdyzm35g3CwaoK2RDZmfXCBxc=;
        b=lDkfUwI1q43gJKh/8O9Xboz1NJHSGAlp9ANmZpeABKOmv7FxItBIe/l1cMpJEJ85PV
         FsNCPpsECupu0YECfM8temqXICkDaB8ppXOPkr5zUqUltIUpcjzOOc1icYOCgXpDguh6
         YM9uhSs7fip5XR7OH54oj4+bRU6XUdP6gCdMjnxvvC638pEoiWKDTvFmfuwjHW5Ynsv1
         PtsdDU1LG5b3uAUYCuJ6yxDQdVnFq8XHEPyOucDkK40DoT68Hfb2kcT/fFUhgC9N/juT
         moJr0758wBqOmWOhlATd0pcAZ4vrbkqu3bFQOX5nNkRaUiyZ91o8ihufM8K+k54MUQPu
         FIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yzRwPt1xyo1MwjZwTxBdyzm35g3CwaoK2RDZmfXCBxc=;
        b=kfeRIu1UKkJA6dxWS32G/P54/BDpZv5P7T2sKXXCtMH3K5lU6pnV9qns9IEnJ3xwi8
         xxzSev6qsv7cNlwNdfTFVzQHhEHtmEaE7PK9A40ooK3MIsT49RnMdw1tkeKSjy2RETPR
         TPp05P1N7gpqpFWl43U9+Hi2pVaYMPoW1PsszcWPvq/Woo3MeHFxeG1ZMSgQE2Adk6Wj
         mKwhdMlmlefnyR0c+4hDC9mXsmhbd8mukZXEbyyVhqQetvv0h2FEE3gPHFrhmjJUuTQw
         LeOE66xFxu/gM2giU/yEM/Jq2ekRCs2STdBRZRfQ4pNB0wJZd9m1BlLNKIX64bEwAhS1
         GEpw==
X-Gm-Message-State: AOAM533R63HUddFrbJ8iD51UxfRsPziqekBCQ+cRIPx9HqrkcCsn1vje
        g2sFKCmiqJWzXh2EWZCXTpvOUQbuydo0+/4CNX8mJw==
X-Google-Smtp-Source: ABdhPJys3xMKM2aRZUs8Uaci0gRDunT/5pdrvmvnKnfkoela4czzxA7DVLjAt1LFB7FzPwpcPv164CnEKXkQIvxWVO0=
X-Received: by 2002:a17:906:eda9:b0:6ce:e24e:7b95 with SMTP id
 sa9-20020a170906eda900b006cee24e7b95mr60896ejb.314.1645659153923; Wed, 23 Feb
 2022 15:32:33 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-14-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-14-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 23 Feb 2022 15:32:22 -0800
Message-ID: <CANgfPd-h7J=j8r_APaHRWSsvJtaP69aYtNGpb=m3h_H6QuR_DA@mail.gmail.com>
Subject: Re: [PATCH 13/23] KVM: x86/mmu: Update page stats in __rmap_add()
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

On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
>
> Update the page stats in __rmap_add() rather than at the call site. This
> will avoid having to manually update page stats when splitting huge
> pages in a subsequent commit.
>
> No functional change intended.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c2f7f026d414..ae1564e67e49 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1621,6 +1621,8 @@ static void __rmap_add(struct kvm *kvm,
>         rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
>         rmap_count = pte_list_add(cache, spte, rmap_head);
>
> +       kvm_update_page_stats(kvm, sp->role.level, 1);
> +
>         if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
>                 kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
>                 kvm_flush_remote_tlbs_with_address(
> @@ -2831,7 +2833,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>
>         if (!was_rmapped) {
>                 WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
> -               kvm_update_page_stats(vcpu->kvm, level, 1);
>                 rmap_add(vcpu, slot, sptep, gfn);
>         }
>
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
