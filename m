Return-Path: <kvm+bounces-37086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C6DA250C2
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 00:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 510EF1884DDF
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 23:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5BB214813;
	Sun,  2 Feb 2025 23:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeaaxaV9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95A14A04
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 23:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738538127; cv=none; b=hXMlRVKboq+zJMcl72VyJo9E8fkZp9zyzGP3uORFfGVgfhYsbN1BddSWLKRaNW9JMOVu+ww7Vw9BYTAcV87u5OalN8f+1ZXsTAFOPiEa93ajGQLpwyt7dM4LkxtqtQs2uxSts+lMP86M8jAsRr4ivU0TWxrCI0hUlbKdPAaxw6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738538127; c=relaxed/simple;
	bh=z4db+2e0h419DE1q2WVYFefMz+/sAeD1xP8xxo9CJHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O2yhaJt7Zjs5lI4HVZRjTQmJRgn+nRxxgh+nkvAA3yo1eFW8mMPWFo8NaCwSxRivIoplp+bC4Cqy4juomJwEznuUakNZn1u5+MlwMPM5go9QmC2wTy7wsPCe0M7QWKj2UaUBUGZorpNr/7NG+FXPnlr8bQ86u/1Bd+5wCTVx+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KeaaxaV9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738538124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e1dos8mPCCNcJjz8w4voHe85/j4TJkmhqF45HVaBd4U=;
	b=KeaaxaV9Q03bbJjlcMGJl0ejq5dguI85UEZqQ3VVBeXMYdQJ5DC6uWPzI8NgBV/F8Vm+xz
	HTSskg36EMYv5B9poIaejL9+YuOb86DmFIh/wV8u2WOh2pSgCXF5IhrIA3PKPxKMG9prpJ
	AFHOFTbf1kdYeYrI/GaZAZ5wxjS2FSY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-j4MR2zAWO2mxhPe-yVsGNA-1; Sun, 02 Feb 2025 18:15:23 -0500
X-MC-Unique: j4MR2zAWO2mxhPe-yVsGNA-1
X-Mimecast-MFC-AGG-ID: j4MR2zAWO2mxhPe-yVsGNA
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2163d9a730aso77777385ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Feb 2025 15:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738538122; x=1739142922;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e1dos8mPCCNcJjz8w4voHe85/j4TJkmhqF45HVaBd4U=;
        b=KJvdobYITiDlb1cQMkIVUASsrTJ8nuNY5ajGpyu+D2rKLu87e7fW7lYQRhMzymmfC2
         uV2ipkl88VZ3U5FsoW3t/N7f+vAQVz63Yft6HudysYL1oB5ZhR3SR/hg3uqRoFXYErzd
         G37WUWvDQTGL45Ev6hSKmmKTl7zqRZr83UrTobzZM2PGWhF6mTqTHIGOkRCJuYK6JS2M
         Y+GL2cH2KsbvqsjZNuZGbOTrEcOFG3hddbNb5YLog/lZZ8zBNjTuBoRMoxtSXjMxpRgH
         1Kn1MR9szFcL5j9ejlj1SG2PSYEoHuDSdGcihzdICl3AzqNIBKeCqkoJcarBhAXk3ano
         ykWA==
X-Forwarded-Encrypted: i=1; AJvYcCWTTivPXfiQSPf2DDbNm82eePqtSV6I6IMgQ3Va2TZ2O4vcylV+Ut5IlK6ta4RK9pONK1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOovj8o8im6pOsNdwQVE2tF7ZOOySe90ul19obiVNjSbCA+/s4
	TDSnc7T0dO7mkkHSGdQHFUSZwOrkjp+nmlDMVGe4UAkc+xi3HjlvxktvVfP3KJt5sf/VADZXCzu
	8Wh0OzmD0j3MBJJBBi0hkFf69NnyukDesrL13ebselnA2HwFArg==
X-Gm-Gg: ASbGncuT73t6Naz565BWQiQnaNOldcrZl8H4Bbo8gXgGj2/xvnFiwZRUuhyLEN9Va9z
	fDzzPSL2/3rBtyyagYShOijaK9RPg6CXS2PNydUIPhDnNZUBs4dpEMs7nwb315z5UgMRuFVolPL
	FhPdakpHc8XCrr9MvePhaTIJhTneZBu01jvRrpKpUYXsT9gTLbnP5Frkq2Sxkqtv+P6mmudFxpK
	IyInUr7+bcum+HOaEBAAzjG3a2iNA5FcRi0HU+aJP5Q3x4OWvkImo2bVXo8KwnUjUtHEjI8/Upn
	E91V1g==
X-Received: by 2002:a17:903:120a:b0:216:3f6e:fabd with SMTP id d9443c01a7336-21edd7eafccmr173599035ad.7.1738538122329;
        Sun, 02 Feb 2025 15:15:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2mf76DirOg9TZyfOkrJfXsutpQ6g81h2feZA7/LYyJlI04cSOqf6NavNatW10Gphrl5eu/w==
X-Received: by 2002:a17:903:120a:b0:216:3f6e:fabd with SMTP id d9443c01a7336-21edd7eafccmr173598665ad.7.1738538121968;
        Sun, 02 Feb 2025 15:15:21 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ea5fesm62974185ad.132.2025.02.02.15.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2025 15:15:21 -0800 (PST)
Message-ID: <34990c4f-b65e-4af2-8348-87ea078afc16@redhat.com>
Date: Mon, 3 Feb 2025 09:15:12 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/43] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-35-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-35-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c        |  2 +-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 0d89ab1645c1..f8e37907e2d5 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   u32 kvm_realm_vgic_nr_lr(void);
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
> +
>   bool kvm_rme_supports_sve(void);
>   
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index e562e77c1f94..d21042d5ec9a 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -63,6 +63,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>   }
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> +{
> +	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
> +	u32 ctx_cmps;
> +
> +	if (!kvm_is_realm(vcpu->kvm))
> +		return val;
> +
> +	/* Ensure CTX_CMPs is still valid */
> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
> +	ctx_cmps = min(bps, ctx_cmps);
> +
> +	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
> +		 ID_AA64DFR0_EL1_CTX_CMPs);
> +	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
> +
> +	return val;
> +}
> +

The the filed ID_AA64DFR0_EL1_WRPs_MASK of the system register ID_AA64DFR0_EL1 is
writtable, as declared in sys_reg.c. We need to consolidate the field when the
system register is written.

         ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1,
                     ID_AA64DFR0_EL1_DoubleLock_MASK |
                     ID_AA64DFR0_EL1_WRPs_MASK |
                     ID_AA64DFR0_EL1_PMUVer_MASK |
                     ID_AA64DFR0_EL1_DebugVer_MASK),

>   static int get_start_level(struct realm *realm)
>   {
>   	return 4 - stage2_pgtable_levels(realm->ia_bits);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a4713609e230..55cde43b36b9 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1806,7 +1806,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>   	/* Hide SPE from guests */
>   	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
>   
> -	return val;
> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>   }
>   
>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,

Thanks,
Gavin


