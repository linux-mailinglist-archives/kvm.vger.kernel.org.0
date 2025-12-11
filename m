Return-Path: <kvm+bounces-65780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF45CB6415
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:52:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 849D630319BF
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A5C2DCC08;
	Thu, 11 Dec 2025 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oe3IU0G0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9F7291C33
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765464725; cv=pass; b=T3CwuHTU+VOq/z5MhObK8fNjT12mzxcGDWKsPDGA6dzvvXs6QQVNytmy/ikdnmSUKVYgH0NdJ4xkKXLjjSuBR+Ps9aPp8e1i9zPrzFEyjAd46w23eK6oYh9COwtPoroaStSiuK/+IxoyHck1a9KqIls7T+dsVtUeJvPQb9xcq4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765464725; c=relaxed/simple;
	bh=wAMwNSRawWZ1QoE1+8GigGIznpCapxk6QfzLASpXrww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NY8GJlIyH15OTPXWQjVtfYnsyqpV7C8y0irTfPbmmPjfe28UFtvgg+ryfQqMVfdDx5h44Jgr2YYQ35ZHfKuoqE39RZaW7rkytiXf61phmHa2bsbstCX7i60bfgxIFtewkr9pvzjRKCUMbP5UPk1gX+nicTQMVSdqs7T517hIORw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oe3IU0G0; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee147baf7bso445051cf.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:52:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765464722; cv=none;
        d=google.com; s=arc-20240605;
        b=PFhm3RCUM+bseo0Fw81+V9VD+dCyq1VEoU3xEkxFvBCusrjxtmbaslp4bk4VU59tQx
         bR+8/x+Wnn/ekb4pYZqRuFsHFkaiZ0Ma+Gi7enmwohuEXOf2xKFLIfs2gkzxX1ANTCrr
         9zB7o2jMOc9Ae1UNQ8Ma8Hwm9cYuMXyEyyjfYj137jqKNFpRj+mxu6nVs/qy/R5DO72R
         3JKudIGYlufoYVOm4/6LuKndDX14piHgb472JptW6UGtOHQgrZFEmWly7JEzP0m+6k1P
         hkbxTP53HXj3I3H7r8o0CUytqpi89WWynM9e5n1LykgLuRB5o1cPxgplZjo3hPD46jWx
         uRMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yWMX1jyjXeIgNw1WZzMJikLtB4FVJ9nrhVzaVMwg74Q=;
        fh=1z5FKgs6grzOavcaHPjl6simHPTzRRl81M7Vj5gi274=;
        b=gBOjYRBjm+dZTW19RshxA3zPZxEMmZPj7kXrGKILvV4yvnfu7Scntk+I2mnWD5REvO
         mZOOFMl/MwF0+LD8+Nqe32j/Xkjg7Rj5ZHRn3q2A2t+aLJUpDlug/4+B3WEgjRkbpT7T
         PFXi+a7/U4nKOsNi3hkiXYhhp323luKlivVn7QqMLSVY1K3BmW0vG8OYxhtpjhRm0zzX
         Ce3ZSeDn0WOYoypmU0w0CmsqUXulpJuaWUc3hr0JHypWIAdw5s6WB3A5y5uVlbvlN8Hv
         kaEgKNHknzqhhk5ePhQfyTPvQ2/4qVC2gnbTeXeTwHdgE3tdP2PaTXkV6J68cZ5hbeuC
         jJWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765464722; x=1766069522; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yWMX1jyjXeIgNw1WZzMJikLtB4FVJ9nrhVzaVMwg74Q=;
        b=oe3IU0G0THGY342xpxd8B581CajJ/CQedxyyTwZmX9iyexrnI7D+xh86FGfUGxwduW
         3ABw72/H1paGKeCtlSxP2uWtu2xXBB3McBKAYJ/4A/SU/8WNfmGANWgDgRttekBSpulP
         Lkrl+U34ZTZnzlQT094MQSe6i6/78P+2Uqq6bSOJUoSGq1CZFO2niKta/VXaOShHg3tU
         HRxWXD1SvLU4eoHHMSkpIG2e+DVtB2DxNmuAi9OZ5a2F3GTYm59VFqO9f7EdECUfXboF
         rZYem+ljbpu/XieXrzmj8XUJZvcawBnBn+5enH8NZJDv+S4KDKg+gCV/8ckRgvbA/TfE
         UdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765464722; x=1766069522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWMX1jyjXeIgNw1WZzMJikLtB4FVJ9nrhVzaVMwg74Q=;
        b=oCKbVw96cYo3F9nIOw98Q0ZHoFqMdPJPuwgwVkjBesWPu6h1wFbiNoW8k1OWbikjLP
         xd+WQXoULe5LE1U57YoRAUinLxnAGDfl4WVS7nrwKIP5Wq+9swUTnkchdpO6y+FH8h4b
         9LtzG/ViYHwjtnfFMOTuyFdhq4QAW/rfR98CSCj8hh88O7ATdjYSBLMMVs1FrECvYA7q
         r/faPgCDU2Hn+8Gpv8MlOZNtDbPMAi4HhnI/jcVuGzPKr8L2TyT2Gt/RaBie+q0sAArc
         ZLjpxOaTX2vr/bkgOOm8eDvNy1aHNL0dDAHoOBYvJLGoKeiXdf8r4pqOfugKb36eSFZy
         S3wA==
X-Forwarded-Encrypted: i=1; AJvYcCU4sS747rHk/DFP/GqS+P+WuK3cDUa80zoXxE/65YaeaI/1hAuRnwgo1al9mw9VaO43u08=@vger.kernel.org
X-Gm-Message-State: AOJu0YyitGyTbokfUsDfU/EPN3fBbbTztTSz7eeob/gFoIHiI+Kux+S3
	jYTf5iFiEDk2MME/yVFN/NZ5BnAZd46HKAiX6xE3MII6L9rSMiRUHG70wASZjT2PwXFrK+YP0i5
	BRxKxTZ55klzYqdvnRfDhZSDh9DmJrYDf+vx4MM+4
X-Gm-Gg: AY/fxX4/8cI+KYV/POBglcFTDZ3zt3j2gf8gXFU6RDsvcYnicZnJqxduQ2yeKNFAF8w
	RPv5uMsP7WEDu+7yMkK/9v1ocREb7xhvBbOLutdGV1S89AYP6eXK2VDhJg7A/NL8psOS/Z29gOw
	vWap6lOi1M7E7b+a9drnu48Y16HvciyjeiX0Zmr+EvDmDUZ+e1e8FHPFFkhUgm/dYjagH0uskiB
	s9ryP5twoOKBw8UG0yAKiYS+1sHb1CewxwbxiI3k6s6nho1R9U5ROWAsT2p7kVprneXwo95
X-Google-Smtp-Source: AGHT+IFQKP5fapGPHx5ImO6c09xm7GohUJLdBZ1CUTPePaNGb2mNfszOTXSYC0I42sptlzmkcKe68l3xaix/F5ByaNg=
X-Received: by 2002:a05:622a:1995:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4f1bed26845mr9697741cf.1.1765464722271; Thu, 11 Dec 2025
 06:52:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-7-maz@kernel.org>
In-Reply-To: <20251210173024.561160-7-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:51:25 +0000
X-Gm-Features: AQt7F2o1Eo4xEzZ0xMgWpr24G9qnYMnYlv-SMNtZ7eV3yobp_YNt8tudLckw7Mw
Message-ID: <CA+EHjTwi3S-BVYQWf6_TAyd4fi18Ng3G3HkxKh2MB8PrE_32Uw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we potentially have two bits to deal with when setting
> execution permissions, make sure we correctly handle them when both
> when building the page tables and when reading back from them.
>
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad

> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 12 +++---------
>  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++++---
>  2 files changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index be68b89692065..095e6b73740a6 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -87,15 +87,9 @@ typedef u64 kvm_pte_t;
>
>  #define KVM_PTE_LEAF_ATTR_HI_SW                GENMASK(58, 55)
>
> -#define __KVM_PTE_LEAF_ATTR_HI_S1_XN   BIT(54)
> -#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN  BIT(54)
> -#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN  BIT(53)
> -
> -#define KVM_PTE_LEAF_ATTR_HI_S1_XN                                     \
> -       ({ cpus_have_final_cap(ARM64_KVM_HVHE) ?                        \
> -                       (__KVM_PTE_LEAF_ATTR_HI_S1_UXN |                \
> -                        __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :               \
> -                       __KVM_PTE_LEAF_ATTR_HI_S1_XN; })
> +#define KVM_PTE_LEAF_ATTR_HI_S1_XN     BIT(54)
> +#define KVM_PTE_LEAF_ATTR_HI_S1_UXN    BIT(54)
> +#define KVM_PTE_LEAF_ATTR_HI_S1_PXN    BIT(53)
>
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN     GENMASK(54, 53)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index e0bd6a0172729..97c0835d25590 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -342,6 +342,9 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>         if (!(prot & KVM_PGTABLE_PROT_R))
>                 return -EINVAL;
>
> +       if (!cpus_have_final_cap(ARM64_KVM_HVHE))
> +               prot &= ~KVM_PGTABLE_PROT_UX;
> +
>         if (prot & KVM_PGTABLE_PROT_X) {
>                 if (prot & KVM_PGTABLE_PROT_W)
>                         return -EINVAL;
> @@ -351,8 +354,16 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>
>                 if (system_supports_bti_kernel())
>                         attr |= KVM_PTE_LEAF_ATTR_HI_S1_GP;
> +       }
> +
> +       if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
> +               if (!(prot & KVM_PGTABLE_PROT_PX))
> +                       attr |= KVM_PTE_LEAF_ATTR_HI_S1_PXN;
> +               if (!(prot & KVM_PGTABLE_PROT_UX))
> +                       attr |= KVM_PTE_LEAF_ATTR_HI_S1_UXN;
>         } else {
> -               attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
> +               if (!(prot & KVM_PGTABLE_PROT_PX))
> +                       attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
>         }
>
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
> @@ -373,8 +384,15 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
>         if (!kvm_pte_valid(pte))
>                 return prot;
>
> -       if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
> -               prot |= KVM_PGTABLE_PROT_X;
> +       if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
> +               if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_PXN))
> +                       prot |= KVM_PGTABLE_PROT_PX;
> +               if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_UXN))
> +                       prot |= KVM_PGTABLE_PROT_UX;
> +       } else {
> +               if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
> +                       prot |= KVM_PGTABLE_PROT_PX;
> +       }
>
>         ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S1_AP, pte);
>         if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RO)
> --
> 2.47.3
>

