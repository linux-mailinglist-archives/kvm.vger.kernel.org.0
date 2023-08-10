Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C4A776F10
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 06:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjHJE3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 00:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjHJE3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 00:29:18 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382AF1728
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 21:29:18 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1bb782974f4so466315fac.3
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 21:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691641757; x=1692246557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSfTgAgX08RA8KJNECzRqx6VSrVwrPxTtbQrQqdYk/Q=;
        b=fLHMHPvEQHLnIoTQe/pKnhjKXg9Dns+4MsWdkepWoSPXQKplvhSt4ILJQjaDa5jb+i
         TI4C8rmyA0CLw4wXhLEj7Xf0994xn1m70Mwg0SGLVIwR3546xXSL7KaiCsHJjRVOmClK
         0/dv0fmet7PtR7x7DLdmuvqM7j3Kh0pL4IbSRAKKsFDLsZSHigOSecjUGjaQnVeaiDzL
         xvS40K9MdEW5zLVDgbpnbMXASj3X7C1fDG01/o8GiLY5988IKImRAg6fPV3ZiSEl1M/P
         2nnSK9Ys4HCktXjedf6toHzBO6HQzvdIRJ1woTDtPqEIxYaTpPuiHK/edhZce6tyB98Q
         A3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691641757; x=1692246557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSfTgAgX08RA8KJNECzRqx6VSrVwrPxTtbQrQqdYk/Q=;
        b=flrejBOWldNJ93ZY2VZ71kAFX2l1viw++sM94jICfy3T8xyDaquPfrG/tYYenZL6PE
         pzRTAWO1L4nEN2MG6WYEpYcGpQ9xkMjYdOYEDwwFIcNdL8ik57rhwH5jz0WCVu/gEsqp
         l3jhZt0JL/+nXFSCUS8qR2LqgnuWsVr2oBJWgHipIFfNBn4n3Q3HAbo+8OqLU/F+WVja
         saPBwO4Mcz8780co8EEs+g0euRSNMeybV0WAIY5DokKrxy+fTjYbxa4lUL6el/ToaBdu
         +PECgW4kwK5p+spS90UiLesc44azVc7Y7cYwL4590LAVFT2tpcwoBsFX+TKOt2XtzjyG
         DTzQ==
X-Gm-Message-State: AOJu0YyVkNxyP3vTSG75+gLg5U3ELlsHZdvL0XaFKSeMSeZJ24dliIWO
        KSzwyAr5RhpWM96Be2srlY3nRFwCJA3e6N196f+plw==
X-Google-Smtp-Source: AGHT+IEbbgtaxDzsvT16sQ8NkvMgXB+NbTz5AAm7Isq3L+6p2LRbNo6wBcMMoliVkWQBKhPDC0cZngV1h2tuItRkqtU=
X-Received: by 2002:a05:6870:248e:b0:1be:cf5d:6f7b with SMTP id
 s14-20020a056870248e00b001becf5d6f7bmr1660262oaq.17.1691641755955; Wed, 09
 Aug 2023 21:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-4-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-4-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 9 Aug 2023 21:29:03 -0700
Message-ID: <CAAdAUtj-pPqj92dt1XxvDUDKAHP3gsjnpgQYi3YSLXnWGiVtww@mail.gmail.com>
Subject: Re: [PATCH v3 03/27] arm64: Add missing DC ZVA/GVA/GZVA encodings
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> Add the missing DC *VA encodings.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index ed2739897859..5084add86897 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -150,6 +150,11 @@
>  #define SYS_DC_CIGVAC                  sys_insn(1, 3, 7, 14, 3)
>  #define SYS_DC_CIGDVAC                 sys_insn(1, 3, 7, 14, 5)
>
> +/* Data cache zero operations */
> +#define SYS_DC_ZVA                     sys_insn(1, 3, 7, 4, 1)
> +#define SYS_DC_GVA                     sys_insn(1, 3, 7, 4, 3)
> +#define SYS_DC_GZVA                    sys_insn(1, 3, 7, 4, 4)
> +

Reviewed-by: Jing Zhang <jingzhangos@google.com>

>  /*
>   * Automatically generated definitions for system registers, the
>   * manual encodings below are in the process of being converted to
> --
> 2.34.1
>
>
