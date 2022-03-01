Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C524C928D
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiCASHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiCASHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:07:23 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F305DE4E
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:06:42 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gb39so33151445ejc.1
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 10:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hc+la0U9z5sF1wjuzpoAsI8bZOypHdVZX1vD0aADe74=;
        b=qKpw9l26wiRybylQJZiYYTneChfm1HgNCnDKaEpsBSDFGb6rKM/cmHEFJ208nnRnwp
         xQfa1UWshwsZL5m5CtpsnVwLGMpQ/OGX35605LcC2XqstLRT4n3v1wKI+OLrYbqxVaPC
         MgUaCwJk5wuauXVDWcc/4N7NWDZcn8ldsfrPtzbXRwVD47MOXSeNihZ+9CusBpfPeR0N
         ZiLnwialy6z4jd32aXsc1SjMyL3eXgSFE7netwfjP388Twl8GBoCTT8iKN7kfacRjQqP
         oEZEXc2R6nsLB7jwrghgfpQqlLwikO2yrDOStfV69i/T1ZeHT9cfCnYl+fv0sQkMUDup
         qx5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hc+la0U9z5sF1wjuzpoAsI8bZOypHdVZX1vD0aADe74=;
        b=T8mDBs8budh/TQq2pqp9njDZ89/4X/zcvGR2LoH6cVAt33iNGGURyL50axkkbWHoKE
         wxNZB4ZtFbrx7cuVhizZk5aTRe3C/NjwkOvIfj0GqGIF8qaIzjBRNHFtFmvsHxInn1jj
         jbjImFAGi7Ecr7wHHZnk+9Axf29tepQ7sA5cZFZE4ZzazXbsBVNT6yH5rzhwrASRYlQd
         X8baVex+WJeN1xPy2S3x5rkybT6i1senSWlDyCnyYTK+CqZnHbxHelPDmzyigqw3Yr8W
         3R93jS6XnsLEDcrhVTcv9lo8bn6NXnW4qYCEt3DjUSPZSY97IXFpozCEwLGioDntzvgA
         LWkw==
X-Gm-Message-State: AOAM532DJnSiMqJ+UqLNSizShvdp5xo1ySoCWUE805L58ubqRiepm0Fy
        iiolnt8+w5OZ/R3YEhVqoyYzAc1z3v5x98GNNZecIA==
X-Google-Smtp-Source: ABdhPJy4LDHHSE+zUliqU4kzYZ+GgNq6vdP3ndMDVZDwLY6n8X23fU4ClJ3EPBJ1VR8nKdMWj/Yd7ROpFo9sygYVoi4=
X-Received: by 2002:a17:906:2486:b0:6cf:ced9:e4cc with SMTP id
 e6-20020a170906248600b006cfced9e4ccmr19870864ejb.201.1646158000527; Tue, 01
 Mar 2022 10:06:40 -0800 (PST)
MIME-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com> <20220226001546.360188-24-seanjc@google.com>
In-Reply-To: <20220226001546.360188-24-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 1 Mar 2022 10:06:29 -0800
Message-ID: <CANgfPd-hZ0Epib2ZoQULhZkY1x4TFn6_wENnbGsiN9sHsHu2+Q@mail.gmail.com>
Subject: Re: [PATCH v3 23/28] KVM: x86/mmu: Check for a REMOVED leaf SPTE
 before making the SPTE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

On Fri, Feb 25, 2022 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Explicitly check for a REMOVED leaf SPTE prior to attempting to map
> the final SPTE when handling a TDP MMU fault.  Functionally, this is a
> nop as tdp_mmu_set_spte_atomic() will eventually detect the frozen SPTE.
> Pre-checking for a REMOVED SPTE is a minor optmization, but the real goal
> is to allow tdp_mmu_set_spte_atomic() to have an invariant that the "old"
> SPTE is never a REMOVED SPTE.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4151e61245a7..1acd12bf309f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1250,7 +1250,11 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 }
>         }
>
> -       if (iter.level != fault->goal_level) {
> +       /*
> +        * Force the guest to retry the access if the upper level SPTEs aren't
> +        * in place, or if the target leaf SPTE is frozen by another CPU.
> +        */
> +       if (iter.level != fault->goal_level || is_removed_spte(iter.old_spte)) {
>                 rcu_read_unlock();
>                 return RET_PF_RETRY;
>         }
> --
> 2.35.1.574.g5d30c73bfb-goog
>
