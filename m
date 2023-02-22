Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393ED69EDEA
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 05:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjBVEaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 23:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBVEaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 23:30:18 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C792A305F7
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 20:30:17 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id h14so7580496plf.10
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 20:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5i4ldczDQYuSG/1FXAxAWO2RItdkLbuSLSCwjoOZQas=;
        b=RvCSgLpRV8MIeD43Y5Si07PAj+VVGYhM/xxdS6X6HjXuhB+esvrc4TqEBztu+psTWF
         3RAck/24/L5h6vJT0IjYp+nNYSC4Dvw49olE4ZX/xshlB5RAuUp+qRbzIbtVlsr3N/Rb
         UKG6XQj7Dlv6E3cR6+5xJhyJIV/7e5kbytMqU2dZtZ7BaEd+ue4xzLDirNDmeWVIFczd
         +WyF6C2s3XtYeKUUU4Ooc/Zc3ghwmUB37+h8N04QV4xzXM4CmhjozC1ziwQLmQ3aq1cm
         mlNqA56/Ky8CIYq/g7CSMNCMXFxhBc+X0EX8suFwkNAkvxe+KHphHUfnfumMyxJSEfGa
         8jnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5i4ldczDQYuSG/1FXAxAWO2RItdkLbuSLSCwjoOZQas=;
        b=Je8AdPxCbCDO7JU17UpolnH92izPdIdcl4KVfprvcJ5ZqS2jagPj1R1wgG3OYo0m9u
         BVQXYzT1nAdRcQ44QUWgWlV1WaXyNy79VEozZbrNXx5S7IwcojGQzTDIp0OYB35dPwL0
         ezLlC2+aombCKS2m+ArsmQbVwv3ywxxmIMeSrCeEvyp2bZQiLrkZpnZAW4FmHDuqNkQF
         Mzy1VtGZCxwXpkopmxsJH2purxU+FQRjN3gmGhTw7RwnmvUlCgNiPo6++gumf9d+zUWt
         ayz+9G2pYtVpKMd1kDLDuD9RgSJlDtVga8zqwA4muCIQnnhq5zszId2iwTUYSXNNVdcK
         YhxQ==
X-Gm-Message-State: AO0yUKUlRlb3XlC49xTUD5QEtpV8ajTL6wElYygqDYcAHnmBUr/sTz6O
        FA+mdykV9JLzbLC0+eUY7pyvnnnKL2H7A6ecSbIciQ==
X-Google-Smtp-Source: AK7set8IwOqtf9Iqg5nsqLtHapf2xboF7aeB2Qj338HK5zISpBAYiHRU84sE/TIOasEXXX/xOKht6UwgpXQxVMstVPQ=
X-Received: by 2002:a17:90b:3904:b0:231:f52:ddec with SMTP id
 ob4-20020a17090b390400b002310f52ddecmr2370549pjb.91.1677040217088; Tue, 21
 Feb 2023 20:30:17 -0800 (PST)
MIME-Version: 1.0
References: <20230216142123.2638675-1-maz@kernel.org> <20230216142123.2638675-3-maz@kernel.org>
In-Reply-To: <20230216142123.2638675-3-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 21 Feb 2023 20:30:00 -0800
Message-ID: <CAAeT=FwB+ym5D8xOBEJPAgxoBsD3v_s9J=oP7AXZy3=G78ajow@mail.gmail.com>
Subject: Re: [PATCH 02/16] arm64: Add HAS_ECV_CNTPOFF capability
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Feb 16, 2023 at 6:21 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Add the probing code for the FEAT_ECV variant that implements CNTPOFF_EL2.
> Why is it optional is a mystery, but let's try and detect it.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 11 +++++++++++
>  arch/arm64/tools/cpucaps       |  1 +
>  2 files changed, 12 insertions(+)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 23bd2a926b74..36852f96898d 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2186,6 +2186,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>                 .sign = FTR_UNSIGNED,
>                 .min_field_value = 1,
>         },
> +       {
> +               .desc = "Enhanced Counter Virtualization (CNTPOFF)",
> +               .capability = ARM64_HAS_ECV_CNTPOFF,
> +               .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +               .matches = has_cpuid_feature,
> +               .sys_reg = SYS_ID_AA64MMFR0_EL1,
> +               .field_pos = ID_AA64MMFR0_EL1_ECV_SHIFT,
> +               .field_width = 4,
> +               .sign = FTR_UNSIGNED,
> +               .min_field_value = 2,

Nit: You might want to use ID_AA64MMFR0_EL1_ECV_CNTPOFF (instead of 2) ?

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji

> +       },
>  #ifdef CONFIG_ARM64_PAN
>         {
>                 .desc = "Privileged Access Never",
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 82c7e579a8ba..6a26a4678406 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -23,6 +23,7 @@ HAS_DCPOP
>  HAS_DIT
>  HAS_E0PD
>  HAS_ECV
> +HAS_ECV_CNTPOFF
>  HAS_EPAN
>  HAS_GENERIC_AUTH
>  HAS_GENERIC_AUTH_ARCH_QARMA3
> --
> 2.34.1
>
>
