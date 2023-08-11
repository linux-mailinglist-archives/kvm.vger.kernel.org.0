Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF617785C3
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 05:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjHKDH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 23:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHKDH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 23:07:27 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEBDE76
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:07:26 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1c106287f25so732648fac.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691723246; x=1692328046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHeO7UY2tsm58hfH7H0nwe5QKdXphxLD9vhP6nCKdC4=;
        b=o01bKWiI/LISpCw3V0zQjWENOFkNWWloy9galEzdm9JUnG14oBHdijMLr3PJ6bGANO
         Y0YQvGFCCCwpWM/J4wOjBR2XZ63nJZwq9zFtWeXOrcl8IXbGjITKnnk7HEE/yDDEVa+Q
         sKW7I7UyLWurYd5SBfzdxpCsUTFQzdBbbbE7eLuan86Ngw0arLg8f+W8Wk6i0Eyo324p
         Aux/rLUUcwVhUxWRyVs7fnbDwhjeBasIuSPHAVZjncD0mn2uiZqkxA6+s+h+qBq/aRue
         ou7fNzQE8VbnkX9/VhCD8gpGo0GwKbzPC1jSymNMJGaETev0thnwPfzARWD34l2geAaT
         NRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723246; x=1692328046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHeO7UY2tsm58hfH7H0nwe5QKdXphxLD9vhP6nCKdC4=;
        b=SExt/yOLuffSv6UGyBzOi1z3kA1RfDV3b8gI0ZslXLbr/ebraZ70d25SMEdKa8K0n1
         BXCgVd6ryauzyoUBUbcbev3AWJ9BA5lWNHBn+QGxC5ac6lIu1Tf2rT60wlO22YyVXRm+
         xd02iaMDz27H1XOX4qV077ITTC+J6lGqIabIhItpR3dWaDjbYFQkofBhnqYhHSY4uB7G
         NQyIf6aG6F2UcrzvxZ8D2PBv+DBKbXXnF76MK2GeRhwOW4k71BUiFXdzWQKIH7CHaY/6
         HATma2ToAeZvruCksQ4d7oA0Q9IW5XoobAkDEOvkFwIHGjJIkAAfCGX79ndh6KvOT4TO
         63OQ==
X-Gm-Message-State: AOJu0YzhZCzHB6Mn45bER2hplsQWNANvmtleAEkN+/e/9XNUt91WXECb
        +NRyvjL1pQvpnltfCK+m2BXHXN1BNaiQgqfLYVLW2Q==
X-Google-Smtp-Source: AGHT+IGsCw74vqVL18ZpnHQYN9TDoWnX9JA+M811vhcj5uVlc65Nuji3bO6OIrG5QP/pM9+rvGSLFZsiYe5aXdIrwNo=
X-Received: by 2002:a05:6870:9722:b0:1b7:4168:e2db with SMTP id
 n34-20020a056870972200b001b74168e2dbmr720652oaq.43.1691723246102; Thu, 10 Aug
 2023 20:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-8-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-8-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 10 Aug 2023 20:07:13 -0700
Message-ID: <CAAdAUthUnAk6ob0mxk07soomCeOOPwB4CM2B3QVmEqkeC5JZdQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/27] arm64: Add missing BRB/CFP/DVP/CPP instructions
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

Hi Marc,

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> HFGITR_EL2 traps a bunch of instructions for which we don't have
> encodings yet. Add them.
>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index bb5a0877a210..6d9d7ac4b31c 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -735,6 +735,13 @@
>  #define OP_TLBI_VALE2NXS               sys_insn(1, 4, 9, 7, 5)
>  #define OP_TLBI_VMALLS12E1NXS          sys_insn(1, 4, 9, 7, 6)
>
> +/* Misc instructions */
> +#define OP_BRB_IALL                    sys_insn(1, 1, 7, 2, 4)
> +#define OP_BRB_INJ                     sys_insn(1, 1, 7, 2, 5)
> +#define OP_CFP_RCTX                    sys_insn(1, 3, 7, 3, 4)
> +#define OP_DVP_RCTX                    sys_insn(1, 3, 7, 3, 5)
> +#define OP_CPP_RCTX                    sys_insn(1, 3, 7, 3, 7)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_ENTP2        (BIT(60))
>  #define SCTLR_ELx_DSSBS        (BIT(44))
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
