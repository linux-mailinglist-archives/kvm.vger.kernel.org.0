Return-Path: <kvm+bounces-40060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19661A4E88E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A52E424B82
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 17:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFD227E1BA;
	Tue,  4 Mar 2025 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eUSnRGGM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E008427C17A
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741107390; cv=none; b=ABdWzUcWFnoKwCe7by+y9atYMWx3yesBMEzGt/9vZciGExnC1fu7g8MCO7SbsoqS76gXLSZqvzSH6/9WEmjDful6lLUwoXDz/1MV0xTSNeJE40bFmsjfgBHVQFdCiMEHSQ3HnnWhbGmMPw8sbZrG2lYeGg27qi44JhO3sBWe3Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741107390; c=relaxed/simple;
	bh=i8jamBfI+P0eeepl+Uhp4JL8/Pr1Lgs5TPF4k0VKrP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JuXBJIpMbwOcs/eZyKcEmk6HgXrN2jpnLmPU1kLcva2WYX5k6el8LTb7ItFNdT+bFONuQfIotjCcL3TBvqDgSiAS+OpmuLoX5hdW4d74xCkwWVws/XM20nETq5MlsZFgaBzeTowpZocmDIjlEb/zIzn3TX93/OX9dkPcOiyxmQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eUSnRGGM; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4750a85a0ddso4891cf.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 08:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741107388; x=1741712188; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9DtRkP6CYCN2VX6LAP0NMel2JbBrN6HKmyX2jA5Yc7E=;
        b=eUSnRGGMpspuowJrPZqYRwOjNFU2sn2PpkSC8uApJIIe5py4rVtuLZRvD6LnFPhZoX
         DRNz89R+eMcEHJ0kIJ2sgxE2nXZmzJl72/J62srrAx1UcOu1WWy8eswqciznT2qKBjCU
         MvkL8XUU021ajMk1q/Oo/Uh0WAD4sG9awgzH4Ong+DrrAc+8BbKMQlHl2QRS6S3NhwHM
         yjKeZAUrGVim0qIbMi6V8G7wikRnSB0HZLJOzlzL/YZCU/Hn5dJNGgrc/Dsmnv1EcYpk
         F438ZjeaFWDrAmGzFwDcfCuLDSzFvaZ7sfN9q+S9bBq/ddikL+ens0w+W3SDENdjq+i2
         uhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741107388; x=1741712188;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9DtRkP6CYCN2VX6LAP0NMel2JbBrN6HKmyX2jA5Yc7E=;
        b=JYyLrRWax0HDRSXfqroc/r4b8AOgIjU3CqQdqGSx2luB/2N5X0Wuidasrzm9gkYqgN
         P6bx5VmKbCgYAoSjLTjM3AJ/46YYzRXM/0yaY9tbedRSTorJ3BeHXNPxHOcehOR5pDkr
         4k8n7xTqzAY2rkI+wZh35NrR3gO9PhrPfUzsJMm0c8e/cHZWE79B/8EPiPUhl2yh4QPT
         /eXX6QVlHbDccI+eR6eOr8RF8/0wKTasBVrnBX1vzT820n4xKmBjlUgwbYtFOn2Sn9w/
         m1sjUkbRO9WiPDA6ljWyeDpW4dFqeiALiA/P1t97eb0NbBb6p12x88HKf1JSXFGMukth
         hrUw==
X-Forwarded-Encrypted: i=1; AJvYcCU/amsDdvTHJiUTJNCtcWq4Ya0IAEYGl/gQSEq5HWKFiH5rixJYU93LKTrC0t6EA6fYHLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNkoXjTSTVjjbru+ODqzO+JI8B+CTgYSdb7e6PYyXsOR0qBsTr
	/IoHjo3qOqIS9f5U2IDyFQrR7H+pOLRNt4SODWTEElPrdcBmVpmh/0e7Pou8mhCRUQh46Qc2ekc
	WMIOVjsA3pbeKSPVJBMzy3ULHEkAQN/wzMAeE
X-Gm-Gg: ASbGncus2jGAzgwFRXUuv8zs2uwsFuA+NnTVMht0GL6jy6cC1dqwbaX/D/jWJlJ4qTz
	9X17FHFZhT03A0NhqYIrcNRALqNnqJLCHOsnEiHucrNZhwANLpl1wCH6vg2/x3hUlvMW2j11E8D
	bizkAI7dh9Y6PF1wcStBiUueFORnci8AMvFyl8wgvbjomErRaRmjosBQ==
X-Google-Smtp-Source: AGHT+IF23vzPgXJFq7laGxxdPorzVUnziNDjwTEtrDs+9M/YfHZweGHZAZN5eGiioteQmHR0kHXdQj+z0gs3Xcfs9rk=
X-Received: by 2002:a05:622a:48e:b0:474:cbac:a983 with SMTP id
 d75a77b69052e-4750a4d1015mr307611cf.6.1741107387427; Tue, 04 Mar 2025
 08:56:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210184150.2145093-1-maz@kernel.org> <20250210184150.2145093-8-maz@kernel.org>
In-Reply-To: <20250210184150.2145093-8-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Mar 2025 16:55:50 +0000
X-Gm-Features: AQ5f1JpeNlKdk-l5r71vf2tqDSYKeajf6KLHiNZ0LiUdyjmTYrSWEAH6GprWQ2A
Message-ID: <CA+EHjTwm4CosWDGcaH_tnLU7zMNCq8twDyEcKd7-V0Lu7b-LcA@mail.gmail.com>
Subject: Re: [PATCH 07/18] KVM: arm64: Compute FGT masks from KVM's own FGT tables
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 10 Feb 2025 at 18:42, Marc Zyngier <maz@kernel.org> wrote:
>
> In the process of decoupling KVM's view of the FGT bits from the
> wider architectural state, use KVM's own FGT tables to build
> a synthitic view of what is actually known.

synthitic -> synthetic


> This allows for some checking along the way.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h  |   4 ++
>  arch/arm64/include/asm/kvm_host.h |  14 ++++
>  arch/arm64/kvm/emulate-nested.c   | 102 ++++++++++++++++++++++++++++++
>  3 files changed, 120 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 8d94a6c0ed5c4..e424085f2aaca 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -359,6 +359,10 @@
>  #define __HAFGRTR_EL2_MASK     (GENMASK(49, 17) | GENMASK(4, 0))
>  #define __HAFGRTR_EL2_nMASK    ~(__HAFGRTR_EL2_RES0 | __HAFGRTR_EL2_MASK)
>
> +/* Because the sysreg file mixes R and W... */
> +#define HFGRTR_EL2_RES0                HFGxTR_EL2_RES0 (0)
> +#define HFGWTR_EL2_RES0                (HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)

__HFGRTR_ONLY_MASK is a hand-crafted bitmask. The only bit remaining
in HFGxTR_EL2 that is RES0 is bit 51. If that were to be used as an
HFGRTR-only bit without __HFGRTR_ONLY_MASK getting updated, then
aggregate_fgt() below would set its bit in hfgwtr_masks. Could this be
a problem if this happens and the polarity of this bit ends up being
negative, thereby setting the corresponding nmask bit?

Cheers,
/fuad

> +
>  /* Similar definitions for HCRX_EL2 */
>  #define __HCRX_EL2_RES0         HCRX_EL2_RES0
>  #define __HCRX_EL2_MASK                (BIT(6))
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cfa024de4e34..4e67d4064f409 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -569,6 +569,20 @@ struct kvm_sysreg_masks {
>         } mask[NR_SYS_REGS - __SANITISED_REG_START__];
>  };
>
> +struct fgt_masks {
> +       const char      *str;
> +       u64             mask;
> +       u64             nmask;
> +       u64             res0;
> +};
> +
> +extern struct fgt_masks hfgrtr_masks;
> +extern struct fgt_masks hfgwtr_masks;
> +extern struct fgt_masks hfgitr_masks;
> +extern struct fgt_masks hdfgrtr_masks;
> +extern struct fgt_masks hdfgwtr_masks;
> +extern struct fgt_masks hafgrtr_masks;
> +
>  struct kvm_cpu_context {
>         struct user_pt_regs regs;       /* sp = sp_el0 */
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 607d37bab70b4..bbfe89c37a86e 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2033,6 +2033,101 @@ static u32 encoding_next(u32 encoding)
>         return sys_reg(op0 + 1, 0, 0, 0, 0);
>  }
>
> +#define FGT_MASKS(__n, __m)                                            \
> +       struct fgt_masks __n = { .str = #__m, .res0 = __m, }
> +
> +FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
> +FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
> +FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
> +FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
> +FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
> +FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
> +
> +static __init bool aggregate_fgt(union trap_config tc)
> +{
> +       struct fgt_masks *rmasks, *wmasks;
> +
> +       switch (tc.fgt) {
> +       case HFGxTR_GROUP:
> +               rmasks = &hfgrtr_masks;
> +               wmasks = &hfgwtr_masks;
> +               break;
> +       case HDFGRTR_GROUP:
> +               rmasks = &hdfgrtr_masks;
> +               wmasks = &hdfgwtr_masks;
> +               break;
> +       case HAFGRTR_GROUP:
> +               rmasks = &hafgrtr_masks;
> +               wmasks = NULL;
> +               break;
> +       case HFGITR_GROUP:
> +               rmasks = &hfgitr_masks;
> +               wmasks = NULL;
> +               break;
> +       }
> +
> +       /*
> +        * A bit can be reserved in either the R or W register, but
> +        * not both.
> +        */
> +       if ((BIT(tc.bit) & rmasks->res0) &&
> +           (!wmasks || (BIT(tc.bit) & wmasks->res0)))
> +               return false;
> +
> +       if (tc.pol)
> +               rmasks->mask |= BIT(tc.bit) & ~rmasks->res0;
> +       else
> +               rmasks->nmask |= BIT(tc.bit) & ~rmasks->res0;
> +
> +       if (wmasks) {
> +               if (tc.pol)
> +                       wmasks->mask |= BIT(tc.bit) & ~wmasks->res0;
> +               else
> +                       wmasks->nmask |= BIT(tc.bit) & ~wmasks->res0;
> +       }
> +
> +       return true;
> +}
> +
> +static __init int check_fgt_masks(struct fgt_masks *masks)
> +{
> +       unsigned long duplicate = masks->mask & masks->nmask;
> +       u64 res0 = masks->res0;
> +       int ret = 0;
> +
> +       if (duplicate) {
> +               int i;
> +
> +               for_each_set_bit(i, &duplicate, 64) {
> +                       kvm_err("%s[%d] bit has both polarities\n",
> +                               masks->str, i);
> +               }
> +
> +               ret = -EINVAL;
> +       }
> +
> +       masks->res0 = ~(masks->mask | masks->nmask);
> +       if (masks->res0 != res0)
> +               kvm_info("Implicit %s = %016llx, expecting %016llx\n",
> +                        masks->str, masks->res0, res0);
> +
> +       return ret;
> +}
> +
> +static __init int check_all_fgt_masks(int ret)
> +{
> +       int err = 0;
> +
> +       err |= check_fgt_masks(&hfgrtr_masks);
> +       err |= check_fgt_masks(&hfgwtr_masks);
> +       err |= check_fgt_masks(&hfgitr_masks);
> +       err |= check_fgt_masks(&hdfgrtr_masks);
> +       err |= check_fgt_masks(&hdfgwtr_masks);
> +       err |= check_fgt_masks(&hafgrtr_masks);
> +
> +       return ret ?: err;
> +}
> +
>  int __init populate_nv_trap_config(void)
>  {
>         int ret = 0;
> @@ -2097,8 +2192,15 @@ int __init populate_nv_trap_config(void)
>                         ret = xa_err(prev);
>                         print_nv_trap_error(fgt, "Failed FGT insertion", ret);
>                 }
> +
> +               if (!aggregate_fgt(tc)) {
> +                       ret = -EINVAL;
> +                       print_nv_trap_error(fgt, "FGT bit is reserved", ret);
> +               }
>         }
>
> +       ret = check_all_fgt_masks(ret);
> +
>         kvm_info("nv: %ld fine grained trap handlers\n",
>                  ARRAY_SIZE(encoding_to_fgt));
>
> --
> 2.39.2
>

