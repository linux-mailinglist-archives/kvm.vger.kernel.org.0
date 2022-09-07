Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182875AF904
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 02:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIGAhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 20:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiIGAhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 20:37:47 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAC48605F
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 17:37:45 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1278a61bd57so13797743fac.7
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 17:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uGgfGldOff2mVxZyVVSAqWj/XJ4BgayJCyvmb6JurzI=;
        b=WGZd1/dO/NI+78DXs3vJRpCy11kM7V+gJDTstBI+Thu6ifPTHExhi2rTWsoOHYblbT
         zGXquzL+PXM7xtXU0jPtq8foZxAbhe/j1ekopE4vncQlBSkLtLCgKyD6ozoU7wwCIs8n
         fvfMD9xxMiRGiT6QHKHKngdjO2OdhhzkQi74qOjnz09uZZ1j+bwZTjzV4YnoeWknY/DK
         8/kGb+EcL4tPc6K0O8lNPTfvsqX2NycCkBtKzAgjNVGR8B+Ln12ljO4gUZVu3w7UN/4w
         9DPCtD8Oxfzw/hH8jNPeM4k02i6BToKFbv/ndYyBbPq7PioMzEreXUfqYY+RIpqtHBGR
         7rlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uGgfGldOff2mVxZyVVSAqWj/XJ4BgayJCyvmb6JurzI=;
        b=Q7oSC5sFjUKLjtncFGETBTxz8spEjdn53jCnl7tBqlrf9rcVjcw49d+biT4x5rR/qB
         G+bwazCSfoPLEmblqIF0dLOAm4Bg9lOWGpczzH3oMG2PU9FKehWC1FCjaGosUfPYQNiR
         OvHz5FPpF0jk+w0ZDThWJC+dyVHvhapOgxFENij+4lKro+D17M6jv32TL+l40JbNST5o
         +9GUS84yaM8lg1aPcsZ/5AIvsX5Wb8+ebgxIkrUtjPk8BAYLYpJAu6DktJMxOLX46+KL
         mvY66oHCpsxrOC1wjZuf8ZcNXw2Emxs5wXmyfwUPtu6ODOrnXkjvtZC661LRFURgzG3D
         ggRQ==
X-Gm-Message-State: ACgBeo2GocojvF8W5pDq02eXaz4S0+2bv2QNv9fS/f6gTBlf6GU1b5QE
        L4HSwSVex4kDDosEXCgyL1NpQINt6dKhEzVlbCTNHA==
X-Google-Smtp-Source: AA6agR59d9raM42PVaHIYoR50vWSZ+rIfc+UKbqN0AqnbobHfZAb6bwDEe25Px99HfKZFoSE1DHjpa+LPv0QVP50jag=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr12916953oab.112.1662511064988; Tue, 06
 Sep 2022 17:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220906081604.24035-1-likexu@tencent.com>
In-Reply-To: <20220906081604.24035-1-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 6 Sep 2022 17:37:33 -0700
Message-ID: <CALMp9eSQYp-BC_hERH0jzqY1gKU3HLV2YnJDjaAoR7DxRQu=fQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: omit "impossible" Intel counter MSRs from
 MSR list
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jamttson@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 6, 2022 at 1:16 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> According to Intel April 2022 SDM - Table 2-2. IA-32 Architectural MSRs,
> combined with the address reservation ranges of PERFCTRx, EVENTSELy, and
> MSR_IA32_PMCz, the theoretical effective maximum value of the Intel GP
> counters is 14, instead of 18:
>
>   14 = 0xE = min (
>     0xE = IA32_CORE_CAPABILITIES (0xCF) - IA32_PMC0 (0xC1),
>     0xF = IA32_OVERCLOCKING_STATUS (0x195) - IA32_PERFEVTSEL0 (0x186),
>     0xF = IA32_MCG_EXT_CTL (0x4D0) - IA32_A_PMC0 (0x4C1)
>   )
>
> the source of the incorrect number may be:
>   18 = 0x12 = IA32_PERF_STATUS (0x198) - IA32_PERFEVTSEL0 (0x186)
> but the range covers IA32_OVERCLOCKING_STATUS, which is also architectural.
> Cut the list to 14 entries to avoid false positives.
>
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Jim Mattson <jamttson@google.com>

That should be 'jmattson.'

> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Fixes: cf05a67b68b8 ("KVM: x86: omit "impossible" pmu MSRs from MSR list")

I'm not sure I completely agree with the "Fixes," since
IA32_OVERCLOCKING_STATUS didn't exist back then. However, Paolo did
make the incorrect assumption that Intel wouldn't cut the range even
further with the introduction of new MSRs.

To that point, aren't you setting yourself up for a future "Fixes"
referencing this change?

We should probably stop at the maximum number of GP PMCs supported
today (8, I think).

If Intel doubles the number of PMCs to remain competitive with AMD,
they'll probably put PMCs 8-15 in a completely different range of MSR
indices.

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..98cdd4221447 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1431,8 +1431,6 @@ static const u32 msrs_to_save_all[] = {
>         MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
>         MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
>         MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
> -       MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
> -       MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
>         MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
>         MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
>         MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
> @@ -1440,8 +1438,6 @@ static const u32 msrs_to_save_all[] = {
>         MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
>         MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
>         MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
> -       MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
> -       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>         MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
>
>         MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
> @@ -6943,12 +6939,12 @@ static void kvm_init_msr_list(void)
>                                 intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>                                 continue;
>                         break;
> -               case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
> +               case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 13:
>                         if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
>                             min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
>                                 continue;
>                         break;
> -               case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
> +               case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 13:
>                         if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>                             min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
>                                 continue;
> --
> 2.37.3
>
