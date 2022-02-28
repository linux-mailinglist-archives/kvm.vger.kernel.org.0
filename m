Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F624C7AF5
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiB1Us1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiB1UsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:48:25 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3FA3193C
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:47:40 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gb39so27346222ejc.1
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kir/jAe6aODscdE44bBqKbY4KfhEB7Tdja9m7/6pVYU=;
        b=sYYL9My94tk/iaD9/8pM0DeumYTMkS3K37zue6iS6skGwtFzZN9Ut0p/jZb6FFFDRJ
         LMVTrMpsHus9LkisSG5VY2xAkskiOaAn3v1/kd2vOLfh2tdBcqSgr2KgTbiA4Y5JH3zk
         phs+GGBoAG/zBMmvvufR+cpbxNMxB1w1o3a7WacoPmpl4MT7hsfR490FbKD2U33pv/kB
         85GOnGpWe/S+bcabaYN3fiPi+NkXKSo5U+fQYckzk8Nd7p0KkaOnqbbCSdlzWC+fgqzS
         oNjCIJ7AAw/FpOSrHikTq0GZHdv5aAZjB5sedWA9/RS3LRzwno7D2Oo+eCQciB1GfVLj
         3ZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kir/jAe6aODscdE44bBqKbY4KfhEB7Tdja9m7/6pVYU=;
        b=3d/HSJKMDSKDC5X0+4CMvG4DAJLelRCngoGigGZNda2hvTAsqNePLQ4NbfaFAHyGqv
         Vn9lGmr03RnC3MM4OpPpGG8fo69A0y8r33PZ/0YH8IX0rx6BFOq7nI3rkejb+mHW6fSA
         KIR8A+E6o4XklwftAelqsCY8nC0TLjtFzGTtpiAG9zuFa6khBcwaZ4E8hRQDOWxVbw6C
         aKWYBVjXyV/KWVrjIm6Pee6l+VRDIo5EfCiLmrK0GZ2IWd/HOLxDEXJI5BJG3gatVq8t
         tMshF+MtDwxqBe1LdP6+8XSi7YbDfi0+QF7FAQz5zqptXTCD8QRsJg8i0TJjbVOMQwFD
         prgg==
X-Gm-Message-State: AOAM533yh3dkCiCrLWDu00nQu3ARjrmMvnKULtEPpoYZBa5oSUSmHHcp
        xuLMfIQhm05JWc8thY1XDbm1i4FSqgLFdcU61pQ6nA==
X-Google-Smtp-Source: ABdhPJyLNEGz16HLoiCxF+KzeWkJGAvwQu16vQp3WKpsjXvPBzE3zppQKTmdke9rtN1Rp6N1QhdX+kJ0CLJVjqin5dU=
X-Received: by 2002:a17:906:5cb:b0:6cf:954:d84d with SMTP id
 t11-20020a17090605cb00b006cf0954d84dmr17316330ejt.560.1646081259179; Mon, 28
 Feb 2022 12:47:39 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-18-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-18-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 12:47:27 -0800
Message-ID: <CANgfPd90UA2_RRRWzwE6D_FtKiExSkbqktKiPpcYV0MmJxagWQ@mail.gmail.com>
Subject: Re: [PATCH 17/23] KVM: x86/mmu: Pass bool flush parameter to drop_large_spte()
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
> drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
> Its helper function, __drop_large_spte(), does the drop without the
> flush. This difference is not obvious from the name.
>
> To make the code more readable, pass an explicit flush parameter. Also
> replace the vCPU pointer with a KVM pointer so we can get rid of the
> double-underscore helper function.
>
> This is also in preparation for a future commit that will conditionally
> flush after dropping a large SPTE.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 25 +++++++++++--------------
>  arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
>  2 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 99ad7cc8683f..2d47a54e62a5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1162,23 +1162,20 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
>  }
>
>
> -static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
> +static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)

Since there are no callers of __drop_large_spte, I'd be inclined to
hold off on adding the flush parameter in this commit and just add it
when it's needed, or better yet after you add the new user with the
conditional flush so that there's a commit explaining why it's safe to
not always flush in that case.

>  {
> -       if (is_large_pte(*sptep)) {
> -               WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
> -               drop_spte(kvm, sptep);
> -               return true;
> -       }
> +       struct kvm_mmu_page *sp;
>
> -       return false;
> -}
> +       if (!is_large_pte(*sptep))
> +               return;
>
> -static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
> -{
> -       if (__drop_large_spte(vcpu->kvm, sptep)) {
> -               struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> +       sp = sptep_to_sp(sptep);
> +       WARN_ON(sp->role.level == PG_LEVEL_4K);
> +
> +       drop_spte(kvm, sptep);
>
> -               kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> +       if (flush) {
> +               kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
>                         KVM_PAGES_PER_HPAGE(sp->role.level));
>         }
>  }
> @@ -3051,7 +3048,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 if (it.level == fault->goal_level)
>                         break;
>
> -               drop_large_spte(vcpu, it.sptep);
> +               drop_large_spte(vcpu->kvm, it.sptep, true);
>                 if (is_shadow_present_pte(*it.sptep))
>                         continue;
>
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 703dfb062bf0..ba61de29f2e5 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -677,7 +677,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>                 gfn_t table_gfn;
>
>                 clear_sp_write_flooding_count(it.sptep);
> -               drop_large_spte(vcpu, it.sptep);
> +               drop_large_spte(vcpu->kvm, it.sptep, true);
>
>                 sp = NULL;
>                 if (!is_shadow_present_pte(*it.sptep)) {
> @@ -739,7 +739,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>
>                 validate_direct_spte(vcpu, it.sptep, direct_access);
>
> -               drop_large_spte(vcpu, it.sptep);
> +               drop_large_spte(vcpu->kvm, it.sptep, true);
>
>                 if (!is_shadow_present_pte(*it.sptep)) {
>                         sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
