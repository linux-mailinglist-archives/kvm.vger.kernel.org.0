Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A5F778559
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 04:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjHKCVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 22:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjHKCVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 22:21:13 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9062724
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 19:21:12 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6bcb15aa074so1032851a34.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 19:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691720471; x=1692325271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgbJyR6W4C1HwUjnKNNC/3dYbHlURtSgtbESGSNJAZQ=;
        b=ASiZnNVlc3U89cGgSgN4Hg0QZtg0k4bsKO9RD5nyUpuas8Z9qrjJXhJ09c09+z8e1r
         0peZHBZPWjgz0r6WR5jPlSImCYq/4uYsyD87rxDbXKZ7xTjSEVUIKf9PqDL7wujx+3b/
         ziy0BoelS+nC5RROe2DjiqEHSkeX5Uv5dTMxgqWcUWRD1bcn6PdpEZImP3xhRQ7yosYn
         lPqd2ToqWRR47ApO3nRaERF2GtfTuyeVMYdpIu0as+LWlC+qDIWktPz7TzKWIm9/nc90
         0OD1blJaSEtU4WTGJgHOBqsNfyEs/oYriebWSYReJz3BTPVjduU+H2ycPgn9aoYXTjVk
         NL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691720471; x=1692325271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgbJyR6W4C1HwUjnKNNC/3dYbHlURtSgtbESGSNJAZQ=;
        b=KCzla29By2xjJZGZ9FZxSf0Lu3KVuIutPGceE8K7OaGly8FF9wjqCCr0QAaYQeV+fw
         K05TLumYEzBVrKOlaAd8HkgEPYJ10x+8WD1+arOPllPVOt9a89w5voMSZmbTPS8bFrrs
         rVhHfxbbYjO5oInbsnASOYz/wMK0B4RpFSGRcVMCKCV/f6ROe0luSVEE8ENkbhYwyk3Y
         l/G0aE7breEKwsaiZOI3/avPRmSt+NNP7wRbjmqMuSZxVVPPs3gnqIB9Gwa+IJLbAbRV
         yGjfc5atWl5q2MsbcAk3+r4XU1lz99q9jGM6tlZEhePjWf+i7dFSPjM8XZM6gJTakmx6
         OdiA==
X-Gm-Message-State: AOJu0YyOItRzFvrZYoYeiQy6gjkWtFwFAmhSqaHHmBtqOIAg/ueodYyM
        2PctuSanzHdmXYL/Jxn3cPRRmvQ3WU3c1n6eUQNhf7SJzyDseKp6IbQ=
X-Google-Smtp-Source: AGHT+IFrOFgvDJFAmHMHzMHUQ8H85J6v2YCJ0YLT+8oQfOopiIso1FqbFt7jS7015JTqi/DpscqgZqc1oZh1bzfGKU4=
X-Received: by 2002:a05:6830:3499:b0:6b9:dbfc:497b with SMTP id
 c25-20020a056830349900b006b9dbfc497bmr3025018otu.4.1691720471653; Thu, 10 Aug
 2023 19:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-6-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-6-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 10 Aug 2023 19:20:59 -0700
Message-ID: <CAAdAUthig5FL9QYMRR20gpJHFCaOO4qCTwZxF=dqEwvfNzAOvw@mail.gmail.com>
Subject: Re: [PATCH v3 05/27] arm64: Add AT operation encodings
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
> Add the encodings for the AT operation that are usable from NS.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 72e18480ce62..76289339b43b 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -514,6 +514,23 @@
>
>  #define SYS_SP_EL2                     sys_reg(3, 6,  4, 1, 0)
>
> +/* AT instructions */
> +#define AT_Op0 1
> +#define AT_CRn 7
> +
> +#define OP_AT_S1E1R    sys_insn(AT_Op0, 0, AT_CRn, 8, 0)
> +#define OP_AT_S1E1W    sys_insn(AT_Op0, 0, AT_CRn, 8, 1)
> +#define OP_AT_S1E0R    sys_insn(AT_Op0, 0, AT_CRn, 8, 2)
> +#define OP_AT_S1E0W    sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
> +#define OP_AT_S1E1RP   sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
> +#define OP_AT_S1E1WP   sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
> +#define OP_AT_S1E2R    sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
> +#define OP_AT_S1E2W    sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
> +#define OP_AT_S12E1R   sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
> +#define OP_AT_S12E1W   sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
> +#define OP_AT_S12E0R   sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
> +#define OP_AT_S12E0W   sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
> +
>  /* TLBI instructions */
>  #define OP_TLBI_VMALLE1OS              sys_insn(1, 0, 8, 1, 0)
>  #define OP_TLBI_VAE1OS                 sys_insn(1, 0, 8, 1, 1)
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
