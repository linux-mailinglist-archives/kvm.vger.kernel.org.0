Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADE7636FB1
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 02:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiKXBSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 20:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiKXBSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 20:18:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4361025D7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669252627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7LgKeLR3l+O3tHlukn5xyFc3fzOtotvhAO14T/Dt6X8=;
        b=dDzGFykb4NWBqlSCPjiv4qku1QvTrSlDuMpnH1PLCm8EL7oFyhRiKtFhZ2DYrB2nsxTrSn
        U+FHw61eI4Ev3TpxJM0cREnLfpxcO9KdWGLPHoCo6zmUBZhOz5ni0LmwD7vSN9bbpm5WgN
        92XSexgpE99KG18vE80G4MHZTRLMTOo=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-480-ZDdJSPBYM5KOAqzuRZa9lQ-1; Wed, 23 Nov 2022 20:17:06 -0500
X-MC-Unique: ZDdJSPBYM5KOAqzuRZa9lQ-1
Received: by mail-ua1-f70.google.com with SMTP id e44-20020ab049af000000b004185143f494so154270uad.22
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:17:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7LgKeLR3l+O3tHlukn5xyFc3fzOtotvhAO14T/Dt6X8=;
        b=r35kYl6aOCqCPcqiWebU6gcWhih7/MITKiCaxMBJ3LKp77khtkC3CZXBU6zatR4u4p
         EZSDdZQzdspQkvt4gouiPsciqhxk7b3WCQ78VR5cRIAJSqBVQbED5C4NQCZIbQe2T8nL
         ZZWFkPvE2KotCTS9TEC98jiEq9c7aaOrIR/GLV03qA7R4EfQLwC5LSIQggMr4y45hX5Z
         N3W3DuOxjJgOa39pfbgJEvUqQZsus+Y+JrSs+Cb9n0sbG2py614dlX0EDHT4lrJTjfRn
         aDartXo7oleDlXg9RXbaIwRVFpw3QpGddRVT/F5MkDO04z2DaQOhUCmaMTiDSXLnzQ9S
         VkBQ==
X-Gm-Message-State: ANoB5pn3fdqnVYfVXoODfZEtGf+TG10qll7nkAxC7+G0s3XTAW5BFu2o
        EHi7OyX+yrRykhi9g0yMKciG/lXJRuvqPtpeymMiRAePeUQh7IeC90Bh3RcFwskJyfeESkr90oY
        vrN+Hk/FJ12PDKEcUwfG7In9cTc3O
X-Received: by 2002:ac5:c915:0:b0:3bc:2476:f74a with SMTP id t21-20020ac5c915000000b003bc2476f74amr18263290vkl.19.1669252625518;
        Wed, 23 Nov 2022 17:17:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7S6OMh4owQUkHVV6dj/x+6Lvwp9mc0zf8jF8waIlN3tuHt/t1kLF519/UU/Edk4i+2Oxdspva5ZVKyb5EYCmM=
X-Received: by 2002:ac5:c915:0:b0:3bc:2476:f74a with SMTP id
 t21-20020ac5c915000000b003bc2476f74amr18263286vkl.19.1669252625226; Wed, 23
 Nov 2022 17:17:05 -0800 (PST)
MIME-Version: 1.0
References: <20221124003505.424617-1-mizhang@google.com>
In-Reply-To: <20221124003505.424617-1-mizhang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 24 Nov 2022 02:16:54 +0100
Message-ID: <CABgObfYpn98X2NFhoWNAPuyu_NtmovKD5MHoon0gtVP08Su0eA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] KVM: x86/mmu: replace BUG() with KVM_BUG() in
 shadow mmu
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> v1 -> v2:
>  - compile test the code.
>  - fill KVM_BUG() with kvm_get_running_vcpu()->kvm

Nope, the zapping code paths will run often with no running vCPU, for
example drop_parent_pte <- kvm_mmu_unlink_parents <-
__kvm_mmu_prepare_zap_page <- kvm_zap_obsolete_pages <-
kvm_mmu_zap_all_fast <- kvm_mmu_invalidate_zap_pages_in_memslot <-
kvm_page_track_flush_slot <- kvm_arch_flush_shadow_memslot <-
kvm_invalidate_memslot <- ioctl(KVM_SET_USER_MEMORY_REGION).

Paolo

> v1:
> https://lore.kernel.org/all/20221123231206.274392-1-mizhang@google.com/
>
> Cc: Nagareddy Reddy <nspreddy@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4736d7849c60..f3b307c588ac 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -955,12 +955,12 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
>
>         if (!rmap_head->val) {
>                 pr_err("%s: %p 0->BUG\n", __func__, spte);
> -               BUG();
> +               KVM_BUG(true, kvm_get_running_vcpu()->kvm, "");
>         } else if (!(rmap_head->val & 1)) {
>                 rmap_printk("%p 1->0\n", spte);
>                 if ((u64 *)rmap_head->val != spte) {
>                         pr_err("%s:  %p 1->BUG\n", __func__, spte);
> -                       BUG();
> +                       KVM_BUG(true, kvm_get_running_vcpu()->kvm, "");
>                 }
>                 rmap_head->val = 0;
>         } else {
> @@ -979,7 +979,7 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
>                         desc = desc->more;
>                 }
>                 pr_err("%s: %p many->many\n", __func__, spte);
> -               BUG();
> +               KVM_BUG(true, kvm_get_running_vcpu()->kvm, "");
>         }
>  }
>
> --
> 2.38.1.584.g0f3c55d4c2-goog
>

