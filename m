Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F354945952C
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhKVS7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbhKVS7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:59:37 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CEFC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:30 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id k1so19170081ilo.7
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QXGojB54XEp7uVtClcY+seqLgYrjpFXfATYE9FcCNHA=;
        b=cO73z0173hwZR0DV2vvHm6GdeBhhfkgHI53j2aeteYTJ17s6YVR40Hv5AzIsXROni0
         Sn0dXNIkMDZoz6/nctGJuTLjOU8nLqowYg/SKEqND6NPHeA5NjagrzWJFPL6ppKoMQn3
         sBIS/caVmKCFrgcvrV0RFWsSJYpme+vbgJPvYkoDYr+x4rpv7EzVBTWhVUjWqD6WKTFo
         P90ilLfztzlD+RtzW12mu30FnzJ5KPa7qOxh+MH8CzRYbdhDG7kUaQEQ0QEZzmHH0xWx
         Y+aPj9NstqOXmNRJewwHkw+925c7sAa60E/4m2HFVPXNQJILZEpBWOQDZlDluE17VIaA
         FKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QXGojB54XEp7uVtClcY+seqLgYrjpFXfATYE9FcCNHA=;
        b=0gct9MzerNzt+DbzWSPVZzAD3GGCprWBuYjWmi459DZ1KlcybEB3VbZ8lgG9GNWQOX
         m3ATfVvk9zQeNt5RlCn86DH1kn/1HoSpZ2m5Z71unq3mP7/20hZ1jFx1pmML8ONDb8xq
         CwBUy0vV7i2qGMXBknRw/1d2PCWCSYDQcGv/irI4xsboAXIO7EjaGfA5DJ4+94wgqx7A
         GscwGXgpxEWCdc6xkMY3p6DnO+DdQUADYH1eE9D+PnTAMGYkgX1SujGwCCimGRdRWOhj
         ItAsXxnEbR/T88wcB04mROq0eYB5engmoQLFSwSGmuMxiP+e/yX9l6e2sOGcys8grilK
         mewA==
X-Gm-Message-State: AOAM531yWyKMkmZxCKRjqEHn/vWQqaICw6+Vwt7epyFNAxex9ON7HvWL
        2WyjxmV/EmRTBQlFKT7JZQgY9Ck2jG/Wv4fvJSsQgA==
X-Google-Smtp-Source: ABdhPJx6lN/oF0jicKCZYGZs2vJ/F00HR/0cpGlvpTo/cMcqUv/73D1RBlEoDbTjMy4/vsCyB1XkhInTPIIz5+YMtOs=
X-Received: by 2002:a92:dccc:: with SMTP id b12mr21484858ilr.129.1637607389662;
 Mon, 22 Nov 2021 10:56:29 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-9-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-9-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:56:18 -0800
Message-ID: <CANgfPd-f6LzYk-3yNjOvcC5bFpQ6u3BNe537Csj0Xfva3=6_pA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/15] KVM: x86/mmu: Helper method to check for large
 and present sptes
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
>
> Consolidate is_large_pte and is_present_pte into a single helper. This
> will be used in a follow-up commit to check for present large-pages
> during Eager Page Splitting.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/spte.h    | 5 +++++
>  arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index cc432f9a966b..e73c41d31816 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -257,6 +257,11 @@ static inline bool is_large_pte(u64 pte)
>         return pte & PT_PAGE_SIZE_MASK;
>  }
>
> +static inline bool is_large_present_pte(u64 pte)
> +{
> +       return is_shadow_present_pte(pte) && is_large_pte(pte);
> +}
> +
>  static inline bool is_last_spte(u64 pte, int level)
>  {
>         return (level == PG_LEVEL_4K) || is_large_pte(pte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ff4d83ad7580..f8c4337f1fcf 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1011,8 +1011,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                  * than the target, that SPTE must be cleared and replaced
>                  * with a non-leaf SPTE.
>                  */
> -               if (is_shadow_present_pte(iter.old_spte) &&
> -                   is_large_pte(iter.old_spte)) {
> +               if (is_large_present_pte(iter.old_spte)) {

I'm amazed there's only one instance of a check for present and large.


>                         if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
>                                 break;
>                 }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
