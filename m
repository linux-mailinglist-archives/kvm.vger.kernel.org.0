Return-Path: <kvm+bounces-65769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A69CB60E3
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CEF8304FEAC
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AB8311C36;
	Thu, 11 Dec 2025 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UPF7ZntP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1556A3126A6
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765460312; cv=pass; b=mtYYOFNFuL2TJYsqwc6ywRPe0VhBHQ6uj0Vyus5yHeGvSNxpKvxjziRg7vYaXqguRpzH32EAA3Az/v6Wf9HJ92k1KkTmtJYExkICfTiZSvmSHK3dVkBsl0a8iMndZEXIa0cL7x2hMt9Yk5Mhm7o4TEY9UKtU2Uu3Bnz9Ir1Khfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765460312; c=relaxed/simple;
	bh=hcICbtk53nhUUs/NMDQ1oP8T2GuoW7seYibfAF2T1Xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZL713Fn84kBj0W/jiGJq1AxdzT1XwtMGLi4zblTMtYkVveur99WAjRvKXCouX3FwCpWeHzeN6b5GvrFWImKFz1uVk/qiuf47pVxahQu4E98FGxCzYRxiPR2NTay0VrIv3M0dfwzgf9m0i6OsCRuoxAWQgScJBNbFt4wtggY2BDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UPF7ZntP; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee147baf7bso408431cf.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:38:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765460307; cv=none;
        d=google.com; s=arc-20240605;
        b=hVgvsr6NY565WWw6p/lF7i2a4blPZ3yp9Ua+VV1HtYjmgb6QV4vefq+NmR/DqF3aRQ
         Xez4HtdMDcleLsPKGipN+TeB/cMSO2lJVowouZ5CHvuDxb6fDZDu5WYV0Ph2XRG3Lwz2
         p6vVmH1dmnV1r5QZuhhHoGHT9Inlq/UvUiutstUrAYhM+beLxXkGLkfSx43h6+MJaSBq
         kQ6plUNqq32vv8UOO7Pb9U4QMVG6SeTfIdKB1JLPxkFa0zWKhfN1zrJubiboUdeYPFPr
         nN8+s4Ncai1YBBnxP8glxDbClGnLxycVQ76iVRvJreC40wyCW1i8wplYiRgPti9IJ78z
         XwzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ATH4Gg6w1rZmrC11/iAIWnrEEpvY40NWpwaW65dF7vY=;
        fh=2GoDbPZ5OaXvw5qg+t7FJp6K6r/uRqJ+2aYjCQA5NLc=;
        b=JnS36mgDSxYHR1NfJj4223Dpd4V47gQ+JH8r7IAVB173+52/MZ4QQXYaFkVMetSQMB
         D2w7fN+0TKRYsuHsCoFQrLjHLGlYFsyTDYQwVeQu+DRP5rjrCNCBZtYa6dtfvQZdLB79
         mg3GicJ2ELVfWjPr73+yTYoZlTEAk8pLVXhU7C3LZfkCQp734JOomOuV5yQQb/+ibC2B
         7MXdjPW/jdZvulCLXXm4TQl0+9rXGzUmd8NfUEFgYPLOM7xvti/64QOS2RAtfVfPnsB+
         NcsYlDy7J4slXK9GgHShjbjkVn+dRh1jExrakG1Q0/q0bdZIAMBzedHumEs39skWUNEY
         3FUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765460307; x=1766065107; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ATH4Gg6w1rZmrC11/iAIWnrEEpvY40NWpwaW65dF7vY=;
        b=UPF7ZntPHXGx/PyRc3l04ZS8DHJlLmaQHHYpocXqiG/cr22B5yOjppic5ctANsscC8
         1CDdQa1JlVT/J/uUdW6rb0rBJ3QcAWY6irVyyYPXrKnhLfe5Y6qh8yxIrj3Jttdg8GYR
         ljzKsMJLAc9K72p+WWqxzlMYEXbjq0HVaMgnYZHxAhXdyRX5+P0OvytTGPNO7/KHCAqH
         k0vZWJX2ti79cN6apLdn7RElt4f7WViCEdh+HOYF8T9F10Vksv9kdBTgQsdt/lsGVDsd
         PF6NehKvAzv4MUSo8Y063+G9gRVIQLkAPE46rrISoR0oIGNEw6NKpGC4SQkH/ltGPAi8
         SzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765460307; x=1766065107;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATH4Gg6w1rZmrC11/iAIWnrEEpvY40NWpwaW65dF7vY=;
        b=k2ifXrmQ8VyNX3+iv6Y7+nM3wFpX8n+D64fgYedV6OQwyn6R+fF+zPt9qC+GRY9zSL
         Oh5rx61da+DcJG1aQZQU5PsK2168Oi3ITOd+8zB2kLyin9kcb5WACJJQwoMScLIbuLU9
         hQ+5ONK2iVpePSOGnQKhsNrJaPExw+c6AEQyMW6rN92j3hSiEgFzHt2T/CJW+F85Fm67
         eGDXyQUUAv1XDceFV8BIL+bgGUmouswDvBSYv2Bsn3cVCne16EwCUh+CfNfrs4QC0BFk
         qgmBg4Mh/ou7QcMXADq+fxhlsBQ5KK+pofhGcIdQny9QZD2LfYz4hsAqnkO+/GfsSN1V
         dn0g==
X-Forwarded-Encrypted: i=1; AJvYcCV9yJj3TtOCDGAsXYi76ed7dElo5ho0Fjvuf5Zl6aUqZne4Ax57sLkm8D+40QXPgCLQeSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr4yKTYAwbNfPj0e7cWdj29H6e8FNa17gRkIEzFDrVUsCa3GkP
	7biZcsBfI6dnuRUtdKXWxFGnKV9fMJflgR0ryAs1p/PKo+VPPz5YjusYBxaSmErDvxdacSXmJJ0
	coBljul/59n26QWNUr0BUFCJg7o/ZrYQXfQ9xkve9
X-Gm-Gg: AY/fxX6O472rfJ2LBOyhfj715c4hP8v4JDtqC0eI6ls7nrTocFjU2vH0GnKNtyTigsC
	gMltXxllrAeaGyyYbmYj4XQhj6U/fTHbKlBPjOkW/HiN93MJrjimJn8m2Zw01pyJkchsDRujw+6
	VvWIYyGmf/sMjsuDeFWiWaziVTnp8rVwIDanYuxWHI+/98VGAVo30l/e8H8tw5ANC0spG3YT4po
	EgclRx0veUCZb1cPhPEB6NtqblT5xeiGkjhMBtc3t4EWYzBtgprsa6EpoXo1ygIMbMI0gUN
X-Google-Smtp-Source: AGHT+IHBNLZXUtBWlYCMhaz48//h3NT3a97dTmms6v9GAdwjCupUlBdtKCU9vgSfcoVTwxvogMmesy8WxjYwyhWFLco=
X-Received: by 2002:ac8:6059:0:b0:4f1:bf1a:f040 with SMTP id
 d75a77b69052e-4f1bf1af253mr7198561cf.2.1765460307167; Thu, 11 Dec 2025
 05:38:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-2-maz@kernel.org>
In-Reply-To: <20251210173024.561160-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 13:37:50 +0000
X-Gm-Features: AQt7F2oIVnn0zGnmHiuvEME1EKDfc3M1hrNZuxqGEx_qeLODVk3FAHpDGjocJ9Y
Message-ID: <CA+EHjTwh=Vop_v5+2_wj57Y-Wg=Q12aw7hUYdNB2CGA4Kq0ZKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,


On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> The current XN implementation is tied to the EL2 translation regime,
> and fall flat on its face with the EL2&0 one that is used for hVHE,
> as the permission bit for privileged execution is a different one.
>
> Fixes: 6537565fd9b7f ("KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index fc02de43c68dd..be68b89692065 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -87,7 +87,15 @@ typedef u64 kvm_pte_t;
>
>  #define KVM_PTE_LEAF_ATTR_HI_SW                GENMASK(58, 55)
>
> -#define KVM_PTE_LEAF_ATTR_HI_S1_XN     BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_XN   BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN  BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN  BIT(53)
> +
> +#define KVM_PTE_LEAF_ATTR_HI_S1_XN                                     \
> +       ({ cpus_have_final_cap(ARM64_KVM_HVHE) ?                        \
> +                       (__KVM_PTE_LEAF_ATTR_HI_S1_UXN |                \
> +                        __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :               \
> +                       __KVM_PTE_LEAF_ATTR_HI_S1_XN; })
>
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN     GENMASK(54, 53)

I was just wondering, is this patch really necessary, considering
patch 6/6 redos the whole thing and fixes the bug?

That said:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> --
> 2.47.3
>

