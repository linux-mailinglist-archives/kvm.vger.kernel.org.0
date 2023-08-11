Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF31A7794C5
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbjHKQg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 12:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbjHKQgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 12:36:25 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7B4114
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 09:36:24 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6bd0a0a675dso1983615a34.2
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 09:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691771784; x=1692376584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjqXtzMOXLdQHe6ZvZ1Y6Hz/xBtyYiNeyOsO2Cr/en4=;
        b=z+HMwQN3565AfGE/19hcGAOM2hX0FwRfs+LDYzIL1Pr/MRqMAeFsBQZAAwicFn7AZN
         p1L4oQn0fMELODXgvbDt5qno1sJJHxf+UXTppWWRiwKyugZSDahi0Ip+CWAdNmcWUF5R
         6/ijZ8rm/gW5BqLaclrOLp6z2uGUtRQqVuH2VETpB97vG5U/m9ZIixlP+1DB2jJAmsbZ
         kJg27MH5s+13/uAQbUr9VwdWp/HJ3/TtVJBhTW8peWv9M5pFo3l6ph9LTMcmGcfL+xsO
         ZM64Z4fOmH74qZ+zFBsaXvbWJpFG0fsJ/NA16petQboqI+iLR7QNrc3MmkTLBAu3ecDe
         ahqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691771784; x=1692376584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjqXtzMOXLdQHe6ZvZ1Y6Hz/xBtyYiNeyOsO2Cr/en4=;
        b=Mpoo71iW79pGKi+2LB88fjOEhOhl+PHgU5fq3QhBqJPOG1EoJgs7B9wFnMBnng58AO
         1bmp9N950h9qHubrGac5pH1z+/FZPTlJpIb4fCm+Nt4iRjyOAOdHQk3lLAyUWi1iNCJc
         8DKu72j2SkGkjG97KRP+5eiXhvzOaViuKOD8Wpcsro6ObpXGbFwO5na/4rZQaVzMYh4l
         V6FGluxJMO1DJWc66lpk4GXucLOEvHqHorXq6PL5q9xjv7o2/aSudMiPUx6aCkyUn/Sm
         hiHgT3uTAPNKQ70HNwv66gznpRpjBKVcxLqK0dTeFCB5quGjgdHWctTK8E0wu3lnUYFE
         GQeQ==
X-Gm-Message-State: AOJu0YzOcMDrmqCSNgaXWL9zoKyeB0bxb3sR8+hm3/HVzRcSAE/IT/u7
        4xUBI/dGUMYAwGJ4e/iXZk7eG5jVqoADuUp4QxhQ4g==
X-Google-Smtp-Source: AGHT+IGUZUZB4PjbogoCw8S4V6nWl6xBKy15coDJtyCGvtLJYLUCFvRV/u2xNx3M5Y/jVV+EyAdqo7cb7iHDLW6Jqv8=
X-Received: by 2002:a05:6870:e3cc:b0:1be:fe7c:d0a6 with SMTP id
 y12-20020a056870e3cc00b001befe7cd0a6mr2516010oad.2.1691771784092; Fri, 11 Aug
 2023 09:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-13-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-13-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 11 Aug 2023 09:36:12 -0700
Message-ID: <CAAdAUtgv2vsGq-w39APwWM3CB4XO+oMX1WQzozF3SNGBKHSRSQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/27] KVM: arm64: nv: Add FGT registers
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

On Tue, Aug 8, 2023 at 4:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> Add the 5 registers covering FEAT_FGT. The AMU-related registers
> are currently left out as we don't have a plan for them. Yet.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  arch/arm64/kvm/sys_regs.c         | 5 +++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index d3dd05bbfe23..721680da1011 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -400,6 +400,11 @@ enum vcpu_sysreg {
>         TPIDR_EL2,      /* EL2 Software Thread ID Register */
>         CNTHCTL_EL2,    /* Counter-timer Hypervisor Control register */
>         SP_EL2,         /* EL2 Stack Pointer */
> +       HFGRTR_EL2,
> +       HFGWTR_EL2,
> +       HFGITR_EL2,
> +       HDFGRTR_EL2,
> +       HDFGWTR_EL2,
>         CNTHP_CTL_EL2,
>         CNTHP_CVAL_EL2,
>         CNTHV_CTL_EL2,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 38f221f9fc98..f5baaa508926 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2367,6 +2367,9 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>         EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
>         EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
>         EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
> +       EL2_REG(HFGRTR_EL2, access_rw, reset_val, 0),
> +       EL2_REG(HFGWTR_EL2, access_rw, reset_val, 0),
> +       EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
>         EL2_REG(HACR_EL2, access_rw, reset_val, 0),
>
>         EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
> @@ -2376,6 +2379,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>         EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>
>         { SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> +       EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
> +       EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
>         EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
>         EL2_REG(ELR_EL2, access_rw, reset_val, 0),
>         { SYS_DESC(SYS_SP_EL1), access_sp_el1},
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
