Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EC7779300
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 17:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbjHKP0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 11:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbjHKP0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 11:26:19 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756E430D2
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 08:26:16 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1bbaa549c82so1777198fac.0
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 08:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691767575; x=1692372375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpoA+kB5Y3LohYYmJ2jZQQwWYFTkmc71zbP7gd9ynAU=;
        b=I2f1SipTdhlztcE6kE0k5cqLVM1vZmFqwcUp9a08U28pRGdIS2Pjgq6af/5gXIBcnb
         tQv6lnLZ9SxuYL3egbnuv8flrAgthQwfUDGS3xY/SABJj9CD6/3tasFvBmECHWYs/aBO
         DPPpk5Vf7uiM+PzvIhyKyuXht3MMWzVmeJ34CCCEcrxw4Nc5wZ7SeIeGX2HNgzTWexED
         AGH3hCBfkb96r798DFFuGbTp4y76Mg/ZdhY+UpZzu64Gcp6HPKihoscap6K2sNWC/xNo
         4EGs//HfAvXGns+AwpVF3q4lvHo5LnQ2y4VsH1BhRNyI1lxwlN3H7CJtbyOA9RojZs7f
         o9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691767575; x=1692372375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gpoA+kB5Y3LohYYmJ2jZQQwWYFTkmc71zbP7gd9ynAU=;
        b=TQR43hmYv9yfMJjgZWYBUG55Tmk6vH/d0yZzFrX/QpOLu114JnB3QSQp0wOJESzinG
         Z4+SyvS2drV47Eqes9lOXYFniobkjbSXaxiU4b+jGPlHFKCUxRbRJyd8iWHhgCt++enS
         m6zKewB6QecHA7QyGo/alVV875kwJUhrwVao0Va+7nV2f5MtJ6ErJjJ7KMOCPIdUteUQ
         Yim6MiRAeVtpBQn9rb78zCS7ASFUe17UOjR23ZbXXHRAo1YVqxHOlWXSTToPBTGqXwXi
         dBiuO6gytY3mBUG3Aa0s4QT1vsJS5qw/SBvDzXB68io5iA4rDGtq/6rbcE3WKo3RMwDU
         Upnw==
X-Gm-Message-State: AOJu0Yz1SKND+tZmGn0v4K2xifsjDKmGJPSTi+wwyLk7wNoOd29/m69V
        HataqGW380gcK+TCwXOBYmSJvUWKIMeAtJFtmFpVGrs5+ZbkKXUi/Bg=
X-Google-Smtp-Source: AGHT+IHwmUHFuGP6d1T0ZviFc0eLJU8HYh8L5e4xCBXWnjha11RA2HDj3jQefsVWy1uMHw4cfnFJkM8Lr0MsLFSDGoE=
X-Received: by 2002:a05:6870:65a9:b0:1be:d522:fdf with SMTP id
 fp41-20020a05687065a900b001bed5220fdfmr2446876oab.12.1691767575411; Fri, 11
 Aug 2023 08:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-10-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-10-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 11 Aug 2023 08:26:02 -0700
Message-ID: <CAAdAUthoZwX5k1b9AJAA2yB1wuAAaeXiFDimv5Y6N_QrS1P10A@mail.gmail.com>
Subject: Re: [PATCH v3 09/27] arm64: Add feature detection for fine grained traps
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> From: Mark Brown <broonie@kernel.org>
>
> In order to allow us to have shared code for managing fine grained traps
> for KVM guests add it as a detected feature rather than relying on it
> being a dependency of other features.
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> [maz: converted to ARM64_CPUID_FIELDS()]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v4-1-1bf8d235ac1f@=
kernel.org
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 7 +++++++
>  arch/arm64/tools/cpucaps       | 1 +
>  2 files changed, 8 insertions(+)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index f9d456fe132d..668e2872a086 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2627,6 +2627,13 @@ static const struct arm64_cpu_capabilities arm64_f=
eatures[] =3D {
>                 .matches =3D has_cpuid_feature,
>                 ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LRCPC, IMP)
>         },
> +       {
> +               .desc =3D "Fine Grained Traps",
> +               .type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> +               .capability =3D ARM64_HAS_FGT,
> +               .matches =3D has_cpuid_feature,
> +               ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, IMP)
> +       },
>  #ifdef CONFIG_ARM64_SME
>         {
>                 .desc =3D "Scalable Matrix Extension",
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index c80ed4f3cbce..c3f06fdef609 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -26,6 +26,7 @@ HAS_ECV
>  HAS_ECV_CNTPOFF
>  HAS_EPAN
>  HAS_EVT
> +HAS_FGT
>  HAS_GENERIC_AUTH
>  HAS_GENERIC_AUTH_ARCH_QARMA3
>  HAS_GENERIC_AUTH_ARCH_QARMA5
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
