Return-Path: <kvm+bounces-69565-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLqWIHSNe2mlFQIAu9opvQ
	(envelope-from <kvm+bounces-69565-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:40:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F2935B24E4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9EE78301C93F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604E43446B0;
	Thu, 29 Jan 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XPYYX1fN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D322833D508
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704778; cv=none; b=TYfNquBq6t4HaSA1AX1bRh5ckOTx9BWaCiYpENDZYwUBpmy8bOCcABKDZp049T7B9QYWhSBka021+Zhl98BgQyNJ7RnwAjzyLXzJaqb/ysdpPgPg8pE7qhMTEoe2UsxsK8G+ygRtD2IQxqa0boubSMvjVqknZpkZxPAKAV0rp4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704778; c=relaxed/simple;
	bh=B/VHJ92gUrkCQ08cznGlZPMEjHU0vpIWoo2Ylnqd+/4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZIKaS/Uz3+NXoLupJr6ce6348PVNDRrRTM4Dpio2+y+1uqw35auMJjl8Z52Vg7QdXyCLBkbCIWvyBZZ47aGNbrk6Sa11mZkPPTUNGPARWyQ86kq2sXlFBHfJT/gcYk+BeiIWMEA/TRoILijJjUEr1gxuyEwZ/LFm/t3mCtWBrFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XPYYX1fN; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-432da746749so807155f8f.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 08:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769704775; x=1770309575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twFvpc0i3TryasBkxK98iJJPXOi65K0zMxpJo29cyB0=;
        b=XPYYX1fNq1dgLxdSTF1N1yUorRWvWx5EkK+2Kuggn1NUHsQcWi6kp0TNUsxMDB+Qj/
         q0fShi7qygpWlXHgi69hsgcy8ZtbF9wfItkUznZxHwXX4uex4P2YONiobHI4rrqqNLv2
         Gm0pfk7Xb07ViNIDhdmS2zbQgKdU5HPQgZu6He3kVhyoa18Z0ogLlR+1CotAc2ETDyPL
         UKTPtcRzxRt1AACkZ2losHDEGlzNIx6vPlHmOYvNXG6Kbh0MS1ZbHK4YbHEzlLz0438+
         12KO0UMTZwtc3wboiTKDjSyNEcPV3KkkgtLBL/8Li74N+BcO32d3VQYEsd+s/euFvgHG
         NMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769704775; x=1770309575;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twFvpc0i3TryasBkxK98iJJPXOi65K0zMxpJo29cyB0=;
        b=vykTb8+hKq+zNZu0+lDQEm6AYG2CgESxC+ofnYDrve7HmBPi1ya+yMTOwglit4oPad
         z08PWtUiC46PZWyVKbPLGE/g2Y+xjkClQxl+4/ZiT83hVigMIFo4prICt3CVSgdkZsre
         7mpzMLHkAdynUV28KWIxLBYzbIwSMWj/vJt2O0JVC3rnlmtdZgvV4jIMa4CKCgl/+3i8
         xSqTuRR9fA7gRwM5r3PP+p3lD9k+EiLX45vY96B0kPXESr4SIIc8oC5AqD7YIAl/kskm
         Hi5ogAnHahocceoMLKzodCKopAM3F8fwRb8G+Cbch7aBN3Zd5qRXRW4/b3bW4t8VHQ5A
         T9jw==
X-Forwarded-Encrypted: i=1; AJvYcCWrrTLVzo1R6QRpSxWco/LFwu+WWaH9wiDNaNDrR1907EJ86BqmIsPrlq9psQNnilrXim8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeWXpjh4cmG+ux3niB1+Q/3s9c9reaALVqgb1BNelEMYMPbfiE
	Wpb+4BrhWfQ0a/uHZoFgc6BveaVkNzCM3sJkZ6SmCocD1txZlKu4BpkUJ7vkqDUm2tQ=
X-Gm-Gg: AZuq6aLXLTrxi1qYUyyrC2mI8H7kHaeGrNRetFV4kirKj96BJy6TW/NnVIat0ArT2n6
	4o+A8MASboeNk9W2F4p0FCE0vrOdI7NT1Bg1fWG+cMEIaFA2+jSTSwBViDvPNsglxClyMTdx3Fj
	0jr4r+wvc4lXXhvSvU3SqXLEmJr5uRUwAa28UAbMLZmShIZPJbMwYeHAm2d1weMfbo1L0gB9LnE
	NzeakvBYicMZZ2Yxeuwgad500t7KeQ6osUwuV8fwlUNkJDTa8fzaJyve3+qLXb/mlwObteUbPS8
	z/FFs1qVND8sjLiztNA2DSCPy7IfQbo8QFWcc1TLxMpfUwtP/ii2cqUTgPzgw65VYI1uR/kEyZL
	P5R8v5HYNBp1fAacuwFGxbxdehlZuh9zBRcnyOJl+RMlkZalDewDLPmnSvO6e3hq6KYNqEemmri
	rxu/SI5crnfHI=
X-Received: by 2002:a05:6000:184e:b0:432:5b81:48b with SMTP id ffacd0b85a97d-435f3ad5c6dmr249217f8f.61.1769704775134;
        Thu, 29 Jan 2026 08:39:35 -0800 (PST)
Received: from draig.lan ([185.124.0.126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131cfd4sm14914838f8f.25.2026.01.29.08.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 08:39:34 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id A5D885F878;
	Thu, 29 Jan 2026 16:39:33 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,  Joey Gouly <joey.gouly@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Suzuki K Poulose
 <suzuki.poulose@arm.com>,  Will Deacon <will@kernel.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Oliver Upton <oupton@kernel.org>,  Dave Martin
 <Dave.Martin@arm.com>,  Fuad Tabba <tabba@google.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Ben Horgan <ben.horgan@arm.com>,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 04/30] arm64/fpsimd: Check enable bit for FA64 when
 saving EFI state
In-Reply-To: <20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org> (Mark
	Brown's message of "Tue, 23 Dec 2025 01:20:58 +0000")
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
	<20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
Date: Thu, 29 Jan 2026 16:39:33 +0000
Message-ID: <87343o8jay.fsf@draig.linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[22];
	TAGGED_FROM(0.00)[bounces-69565-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex.bennee@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[draig.linaro.org:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:dkim]
X-Rspamd-Queue-Id: F2935B24E4
X-Rspamd-Action: no action

Mark Brown <broonie@kernel.org> writes:

> Currently when deciding if we need to save FFR when in streaming mode pri=
or
> to EFI calls we check if FA64 is supported by the system. Since KVM guest
> support will mean that FA64 might be enabled and disabled at runtime swit=
ch
> to checking if traps for FA64 are enabled in SMCR_EL1 instead.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/fpsimd.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 887fce177c92..f4e8cee00198 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1948,6 +1948,11 @@ static bool efi_sm_state;
>   * either doing something wrong or you need to propose some refactoring.
>   */
>=20=20
> +static bool fa64_enabled(void)
> +{
> +	return read_sysreg_s(SYS_SMCR_EL1) & SMCR_ELx_FA64;
> +}
> +
>  /*
>   * __efi_fpsimd_begin(): prepare FPSIMD for making an EFI runtime servic=
es call
>   */
> @@ -1980,7 +1985,7 @@ void __efi_fpsimd_begin(void)
>  				 * Unless we have FA64 FFR does not
>  				 * exist in streaming mode.
>  				 */
> -				if (!system_supports_fa64())
> +				if (!fa64_enabled())
>  					ffr =3D !(svcr & SVCR_SM_MASK);
>  			}
>=20=20
> @@ -2028,7 +2033,7 @@ void __efi_fpsimd_end(void)
>  					 * Unless we have FA64 FFR does not
>  					 * exist in streaming mode.
>  					 */
> -					if (!system_supports_fa64())
> +					if (!fa64_enabled())
>  						ffr =3D false;
>  				}
>  			}

This is conflicting with the now merged 63de2b3859ba1 (arm64/efi: Remove
unneeded SVE/SME fallback preserve/store handling) so I think this patch
can now be dropped?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

