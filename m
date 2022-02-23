Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B235E4C1F9B
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 00:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244790AbiBWX02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 18:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbiBWX01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 18:26:27 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABC15371B
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:25:58 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id d10so591167eje.10
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtxl5bLxw9fD5PofatpxT9R4hXByAK2/MT0MkgFo4iw=;
        b=QBtfSI9flhLvSMoNQ95YO3Nzom2SsoBEJSr1M6qn/2O7H+VNwjbwgfQu7hNvRp9sBf
         ZExSlO6XYtTiG257CuHfRNUhqJpxuFHjf9srqdnOMuUWMQaCiF2KDT44GftBcKpOM804
         Pm3UvA7UdHecm15vYoj32cRQKa6lB58j/UJsH4fGUbqlwrUl5Ew1zLcsDmdBiSf1O8XQ
         9WGw8WVFCBOsQkMDzXNOFob54cXxXsrElqkV7hh0lnAKMeXcn3QQJy7bWZay4h9UaUmC
         xaRkfCnU6f4mO+mslz+gs1oqHy6ZXfkd5C5pgcpTzCEJkHsnUXJpub2tzwaX2y+8uOic
         s9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtxl5bLxw9fD5PofatpxT9R4hXByAK2/MT0MkgFo4iw=;
        b=tfnqmNy/BOqot4G25gTk1bR+1hTvACquw4bv+py/YyUyw3lltjWnNl1IHmYfSOB7QF
         nnzTK+SbhBeAU/bFBxHV9wLTXjStDWnZWtRKextAYY+hrk9Hgmt4J/UnctKDXOFAQbWO
         qw8llxwr3CfXbSIkygbK+Ec1EK6QCNC87jHGqM7KESlAYGH208KsAabNUoHnGS1v21yY
         CWD0rFwqUtU9wCRim5ojjazfr4Ms7PcH7EQFWso5wnQ2yh98uZZiCd59jphVSDre9SY4
         rhdercsUZAfZljCP7inTF52PsdG7M4wmvxsquQPJxkm7t9KdUf1n1JVJckdviDhkUUPm
         iOLg==
X-Gm-Message-State: AOAM531xFGXadYthjk5WD7u7E13rEcmej7TSBvkVSSb+oriU/rS7U9wX
        a5WMLbjkDaZ3WRLVCbsK12XapwQiPPiABA7FDzj/GA==
X-Google-Smtp-Source: ABdhPJwFQAy+zONdktDfIXKoEkJ8x6kmAE9uX0L/FH9b/6jRkHqYWdPNyKyTX536Wzk9ieDQFpRwzwUbGe4mBFdPPCs=
X-Received: by 2002:a17:907:7618:b0:6cf:5756:26c4 with SMTP id
 jx24-20020a170907761800b006cf575626c4mr40151ejc.492.1645658756823; Wed, 23
 Feb 2022 15:25:56 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-11-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-11-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 23 Feb 2022 15:25:45 -0800
Message-ID: <CANgfPd97L4WZyYDirs=PU6J4orZTnJmFApL+Baiv+8970eqBDQ@mail.gmail.com>
Subject: Re: [PATCH 10/23] KVM: x86/mmu: Pass const memslot to rmap_add()
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
> rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
> memslot.
>
> No functional change intended.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 48ebf2bebb90..a5e3bb632542 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1607,7 +1607,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>
>  #define RMAP_RECYCLE_THRESHOLD 1000
>
> -static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> +static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
>                      u64 *spte, gfn_t gfn)
>  {
>         struct kvm_mmu_page *sp;
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
