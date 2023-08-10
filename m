Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8B1776F7E
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 07:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjHJFWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 01:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHJFWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 01:22:18 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9DCE69
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 22:22:17 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1bf0c4489feso503247fac.0
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 22:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691644936; x=1692249736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0iVg1SdmE7vRMP627k+mf/Mh/hG4PT9hvgDSTdO2hnc=;
        b=N/RHYZdhZSmjJLV37oayCQfTKX9/zO0eIHefavrCNU/CZfDSMarUgpnhNwpUAb8byb
         KvHQpoMUByrjzWlEdkD+9p/uebXoWRRTEzoLSsyASnkzKR/lyGyD4hMl+DGhEkUGa0x2
         SBHy0xXUgMMziVUSYAk7dFIBTAaORRI5UQpX5kYj/ImLjd+U3yxBEUjm6OjIwuWpiQAp
         t8t56uDMoFO/7NartoxzvpDHjexiQkN/eX2xM8xV+KlkFgizW3Qxlguqwh55UHPxweQs
         VtMQ3W73A5y4vIqpLzzVCmhBYzsnYk6LyxGSJZibhS2lskhkxCyxzOQR5gUrlmtI1Pk9
         YvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691644936; x=1692249736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0iVg1SdmE7vRMP627k+mf/Mh/hG4PT9hvgDSTdO2hnc=;
        b=G/VicLKZJ528mjkQwWeTMQue+dycjLHn86Z8+Aqhr4a3HEpqnZK58s+YSNhAXAlPGa
         NoGTKXCom4S3NUOmmruVrjHFWenE9KLRM2E9bfQaDOZK41CAmv6EM3Em3pk4l0wCqaYU
         1p5ry7d4wxC3eWIkG5vpX76QPlV9qhed9kDa6ORfCGN8lFbkecbM3f+SaQ9czXe1Sgt/
         FPuu+EfympI//yD8Ued1GCu4fLn0O+ja9CvZoN9o/bwFQISE9pAD/aMp23Tn1vPLKa91
         DRUTbRDYxRd7cVv3txSDamL8jundWAkHvY1VzDBlGnj7P3VF6OxXNG/yNT9+Ycz+AfBo
         0cnQ==
X-Gm-Message-State: AOJu0YzEptpJKGgmGTLUbO7CuvJBj6yeeW+cXA69rBExf1Dvbq4PlS3J
        QyEMTN6OcKvyi42skdNdlv9zvLEQzhHEGUD0W2Emtg==
X-Google-Smtp-Source: AGHT+IFayVnpVsmXXPJmOuJLzFBZPgf5ckBpS7WD/x1yDb9KDh1iReEKJmuUlsA2CmkqHFxjx/0KDLJAEIpHiz05+Hs=
X-Received: by 2002:a05:6871:a4:b0:1bb:7200:7601 with SMTP id
 u36-20020a05687100a400b001bb72007601mr1873042oaa.51.1691644936414; Wed, 09
 Aug 2023 22:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-5-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-5-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 9 Aug 2023 22:22:04 -0700
Message-ID: <CAAdAUtg29FVWhWEgf_cb0EdGUuCDpfQRYNXranYmpuKM0BzsLQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/27] arm64: Add TLBI operation encodings
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

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> Add all the TLBI encodings that are usable from Non-Secure.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 128 ++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 5084add86897..72e18480ce62 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -514,6 +514,134 @@
>
>  #define SYS_SP_EL2                     sys_reg(3, 6,  4, 1, 0)
>
> +/* TLBI instructions */
> +#define OP_TLBI_VMALLE1OS              sys_insn(1, 0, 8, 1, 0)
> +#define OP_TLBI_VAE1OS                 sys_insn(1, 0, 8, 1, 1)
> +#define OP_TLBI_ASIDE1OS               sys_insn(1, 0, 8, 1, 2)
> +#define OP_TLBI_VAAE1OS                        sys_insn(1, 0, 8, 1, 3)
> +#define OP_TLBI_VALE1OS                        sys_insn(1, 0, 8, 1, 5)
> +#define OP_TLBI_VAALE1OS               sys_insn(1, 0, 8, 1, 7)
> +#define OP_TLBI_RVAE1IS                        sys_insn(1, 0, 8, 2, 1)
> +#define OP_TLBI_RVAAE1IS               sys_insn(1, 0, 8, 2, 3)
> +#define OP_TLBI_RVALE1IS               sys_insn(1, 0, 8, 2, 5)
> +#define OP_TLBI_RVAALE1IS              sys_insn(1, 0, 8, 2, 7)
> +#define OP_TLBI_VMALLE1IS              sys_insn(1, 0, 8, 3, 0)
> +#define OP_TLBI_VAE1IS                 sys_insn(1, 0, 8, 3, 1)
> +#define OP_TLBI_ASIDE1IS               sys_insn(1, 0, 8, 3, 2)
> +#define OP_TLBI_VAAE1IS                        sys_insn(1, 0, 8, 3, 3)
> +#define OP_TLBI_VALE1IS                        sys_insn(1, 0, 8, 3, 5)
> +#define OP_TLBI_VAALE1IS               sys_insn(1, 0, 8, 3, 7)
> +#define OP_TLBI_RVAE1OS                        sys_insn(1, 0, 8, 5, 1)
> +#define OP_TLBI_RVAAE1OS               sys_insn(1, 0, 8, 5, 3)
> +#define OP_TLBI_RVALE1OS               sys_insn(1, 0, 8, 5, 5)
> +#define OP_TLBI_RVAALE1OS              sys_insn(1, 0, 8, 5, 7)
> +#define OP_TLBI_RVAE1                  sys_insn(1, 0, 8, 6, 1)
> +#define OP_TLBI_RVAAE1                 sys_insn(1, 0, 8, 6, 3)
> +#define OP_TLBI_RVALE1                 sys_insn(1, 0, 8, 6, 5)
> +#define OP_TLBI_RVAALE1                        sys_insn(1, 0, 8, 6, 7)
> +#define OP_TLBI_VMALLE1                        sys_insn(1, 0, 8, 7, 0)
> +#define OP_TLBI_VAE1                   sys_insn(1, 0, 8, 7, 1)
> +#define OP_TLBI_ASIDE1                 sys_insn(1, 0, 8, 7, 2)
> +#define OP_TLBI_VAAE1                  sys_insn(1, 0, 8, 7, 3)
> +#define OP_TLBI_VALE1                  sys_insn(1, 0, 8, 7, 5)
> +#define OP_TLBI_VAALE1                 sys_insn(1, 0, 8, 7, 7)
> +#define OP_TLBI_VMALLE1OSNXS           sys_insn(1, 0, 9, 1, 0)
> +#define OP_TLBI_VAE1OSNXS              sys_insn(1, 0, 9, 1, 1)
> +#define OP_TLBI_ASIDE1OSNXS            sys_insn(1, 0, 9, 1, 2)
> +#define OP_TLBI_VAAE1OSNXS             sys_insn(1, 0, 9, 1, 3)
> +#define OP_TLBI_VALE1OSNXS             sys_insn(1, 0, 9, 1, 5)
> +#define OP_TLBI_VAALE1OSNXS            sys_insn(1, 0, 9, 1, 7)
> +#define OP_TLBI_RVAE1ISNXS             sys_insn(1, 0, 9, 2, 1)
> +#define OP_TLBI_RVAAE1ISNXS            sys_insn(1, 0, 9, 2, 3)
> +#define OP_TLBI_RVALE1ISNXS            sys_insn(1, 0, 9, 2, 5)
> +#define OP_TLBI_RVAALE1ISNXS           sys_insn(1, 0, 9, 2, 7)
> +#define OP_TLBI_VMALLE1ISNXS           sys_insn(1, 0, 9, 3, 0)
> +#define OP_TLBI_VAE1ISNXS              sys_insn(1, 0, 9, 3, 1)
> +#define OP_TLBI_ASIDE1ISNXS            sys_insn(1, 0, 9, 3, 2)
> +#define OP_TLBI_VAAE1ISNXS             sys_insn(1, 0, 9, 3, 3)
> +#define OP_TLBI_VALE1ISNXS             sys_insn(1, 0, 9, 3, 5)
> +#define OP_TLBI_VAALE1ISNXS            sys_insn(1, 0, 9, 3, 7)
> +#define OP_TLBI_RVAE1OSNXS             sys_insn(1, 0, 9, 5, 1)
> +#define OP_TLBI_RVAAE1OSNXS            sys_insn(1, 0, 9, 5, 3)
> +#define OP_TLBI_RVALE1OSNXS            sys_insn(1, 0, 9, 5, 5)
> +#define OP_TLBI_RVAALE1OSNXS           sys_insn(1, 0, 9, 5, 7)
> +#define OP_TLBI_RVAE1NXS               sys_insn(1, 0, 9, 6, 1)
> +#define OP_TLBI_RVAAE1NXS              sys_insn(1, 0, 9, 6, 3)
> +#define OP_TLBI_RVALE1NXS              sys_insn(1, 0, 9, 6, 5)
> +#define OP_TLBI_RVAALE1NXS             sys_insn(1, 0, 9, 6, 7)
> +#define OP_TLBI_VMALLE1NXS             sys_insn(1, 0, 9, 7, 0)
> +#define OP_TLBI_VAE1NXS                        sys_insn(1, 0, 9, 7, 1)
> +#define OP_TLBI_ASIDE1NXS              sys_insn(1, 0, 9, 7, 2)
> +#define OP_TLBI_VAAE1NXS               sys_insn(1, 0, 9, 7, 3)
> +#define OP_TLBI_VALE1NXS               sys_insn(1, 0, 9, 7, 5)
> +#define OP_TLBI_VAALE1NXS              sys_insn(1, 0, 9, 7, 7)
> +#define OP_TLBI_IPAS2E1IS              sys_insn(1, 4, 8, 0, 1)
> +#define OP_TLBI_RIPAS2E1IS             sys_insn(1, 4, 8, 0, 2)
> +#define OP_TLBI_IPAS2LE1IS             sys_insn(1, 4, 8, 0, 5)
> +#define OP_TLBI_RIPAS2LE1IS            sys_insn(1, 4, 8, 0, 6)
> +#define OP_TLBI_ALLE2OS                        sys_insn(1, 4, 8, 1, 0)
> +#define OP_TLBI_VAE2OS                 sys_insn(1, 4, 8, 1, 1)
> +#define OP_TLBI_ALLE1OS                        sys_insn(1, 4, 8, 1, 4)
> +#define OP_TLBI_VALE2OS                        sys_insn(1, 4, 8, 1, 5)
> +#define OP_TLBI_VMALLS12E1OS           sys_insn(1, 4, 8, 1, 6)
> +#define OP_TLBI_RVAE2IS                        sys_insn(1, 4, 8, 2, 1)
> +#define OP_TLBI_RVALE2IS               sys_insn(1, 4, 8, 2, 5)
> +#define OP_TLBI_ALLE2IS                        sys_insn(1, 4, 8, 3, 0)
> +#define OP_TLBI_VAE2IS                 sys_insn(1, 4, 8, 3, 1)
> +#define OP_TLBI_ALLE1IS                        sys_insn(1, 4, 8, 3, 4)
> +#define OP_TLBI_VALE2IS                        sys_insn(1, 4, 8, 3, 5)
> +#define OP_TLBI_VMALLS12E1IS           sys_insn(1, 4, 8, 3, 6)
> +#define OP_TLBI_IPAS2E1OS              sys_insn(1, 4, 8, 4, 0)
> +#define OP_TLBI_IPAS2E1                        sys_insn(1, 4, 8, 4, 1)
> +#define OP_TLBI_RIPAS2E1               sys_insn(1, 4, 8, 4, 2)
> +#define OP_TLBI_RIPAS2E1OS             sys_insn(1, 4, 8, 4, 3)
> +#define OP_TLBI_IPAS2LE1OS             sys_insn(1, 4, 8, 4, 4)
> +#define OP_TLBI_IPAS2LE1               sys_insn(1, 4, 8, 4, 5)
> +#define OP_TLBI_RIPAS2LE1              sys_insn(1, 4, 8, 4, 6)
> +#define OP_TLBI_RIPAS2LE1OS            sys_insn(1, 4, 8, 4, 7)
> +#define OP_TLBI_RVAE2OS                        sys_insn(1, 4, 8, 5, 1)
> +#define OP_TLBI_RVALE2OS               sys_insn(1, 4, 8, 5, 5)
> +#define OP_TLBI_RVAE2                  sys_insn(1, 4, 8, 6, 1)
> +#define OP_TLBI_RVALE2                 sys_insn(1, 4, 8, 6, 5)
> +#define OP_TLBI_ALLE2                  sys_insn(1, 4, 8, 7, 0)
> +#define OP_TLBI_VAE2                   sys_insn(1, 4, 8, 7, 1)
> +#define OP_TLBI_ALLE1                  sys_insn(1, 4, 8, 7, 4)
> +#define OP_TLBI_VALE2                  sys_insn(1, 4, 8, 7, 5)
> +#define OP_TLBI_VMALLS12E1             sys_insn(1, 4, 8, 7, 6)
> +#define OP_TLBI_IPAS2E1ISNXS           sys_insn(1, 4, 9, 0, 1)
> +#define OP_TLBI_RIPAS2E1ISNXS          sys_insn(1, 4, 9, 0, 2)
> +#define OP_TLBI_IPAS2LE1ISNXS          sys_insn(1, 4, 9, 0, 5)
> +#define OP_TLBI_RIPAS2LE1ISNXS         sys_insn(1, 4, 9, 0, 6)
> +#define OP_TLBI_ALLE2OSNXS             sys_insn(1, 4, 9, 1, 0)
> +#define OP_TLBI_VAE2OSNXS              sys_insn(1, 4, 9, 1, 1)
> +#define OP_TLBI_ALLE1OSNXS             sys_insn(1, 4, 9, 1, 4)
> +#define OP_TLBI_VALE2OSNXS             sys_insn(1, 4, 9, 1, 5)
> +#define OP_TLBI_VMALLS12E1OSNXS                sys_insn(1, 4, 9, 1, 6)
> +#define OP_TLBI_RVAE2ISNXS             sys_insn(1, 4, 9, 2, 1)
> +#define OP_TLBI_RVALE2ISNXS            sys_insn(1, 4, 9, 2, 5)
> +#define OP_TLBI_ALLE2ISNXS             sys_insn(1, 4, 9, 3, 0)
> +#define OP_TLBI_VAE2ISNXS              sys_insn(1, 4, 9, 3, 1)
> +#define OP_TLBI_ALLE1ISNXS             sys_insn(1, 4, 9, 3, 4)
> +#define OP_TLBI_VALE2ISNXS             sys_insn(1, 4, 9, 3, 5)
> +#define OP_TLBI_VMALLS12E1ISNXS                sys_insn(1, 4, 9, 3, 6)
> +#define OP_TLBI_IPAS2E1OSNXS           sys_insn(1, 4, 9, 4, 0)
> +#define OP_TLBI_IPAS2E1NXS             sys_insn(1, 4, 9, 4, 1)
> +#define OP_TLBI_RIPAS2E1NXS            sys_insn(1, 4, 9, 4, 2)
> +#define OP_TLBI_RIPAS2E1OSNXS          sys_insn(1, 4, 9, 4, 3)
> +#define OP_TLBI_IPAS2LE1OSNXS          sys_insn(1, 4, 9, 4, 4)
> +#define OP_TLBI_IPAS2LE1NXS            sys_insn(1, 4, 9, 4, 5)
> +#define OP_TLBI_RIPAS2LE1NXS           sys_insn(1, 4, 9, 4, 6)
> +#define OP_TLBI_RIPAS2LE1OSNXS         sys_insn(1, 4, 9, 4, 7)
> +#define OP_TLBI_RVAE2OSNXS             sys_insn(1, 4, 9, 5, 1)
> +#define OP_TLBI_RVALE2OSNXS            sys_insn(1, 4, 9, 5, 5)
> +#define OP_TLBI_RVAE2NXS               sys_insn(1, 4, 9, 6, 1)
> +#define OP_TLBI_RVALE2NXS              sys_insn(1, 4, 9, 6, 5)
> +#define OP_TLBI_ALLE2NXS               sys_insn(1, 4, 9, 7, 0)
> +#define OP_TLBI_VAE2NXS                        sys_insn(1, 4, 9, 7, 1)
> +#define OP_TLBI_ALLE1NXS               sys_insn(1, 4, 9, 7, 4)
> +#define OP_TLBI_VALE2NXS               sys_insn(1, 4, 9, 7, 5)
> +#define OP_TLBI_VMALLS12E1NXS          sys_insn(1, 4, 9, 7, 6)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_ENTP2        (BIT(60))
>  #define SCTLR_ELx_DSSBS        (BIT(44))
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
