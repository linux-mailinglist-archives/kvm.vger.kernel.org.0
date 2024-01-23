Return-Path: <kvm+bounces-6732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 082EC838E26
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 13:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 832D71F231CF
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 12:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716505D91C;
	Tue, 23 Jan 2024 12:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/wQDg2o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A9E14A96
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 12:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706011615; cv=none; b=r4csTX2Vfxu5qrgEIS3Pue56arjBMjPrITY7qU06OrhPGlM0Dcjsb3pvAe2Qq6a281QhJZG2tvkeBtdR1PiIKkS818iS/ShZmTbPmLP8Xj+MDqGHuzy/Riq3h4d2heDr1HSfWto5MSgSOtaguQvVWot3Qw/4QDTk86tZyTKUYRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706011615; c=relaxed/simple;
	bh=573tgLMxi0SUz1qyhu82/DusszllblI2XdB2g0MnwJ0=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=RheNv6FQH2fMsB8OCI6dSHFvLG3fqgT/z6573Ct4Nwt+PrTi+FMJMx6UutiFpFYAPqAax2TLvv3idf8Fh3D7AiZxO6ribwnVR/+j5pcV2Svf3WSiCim+Zd/bMFxOftHnfcpuhPCg21nAkFfD0iJh9+PCcbL+HlaX50Q5/t/1O+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/wQDg2o; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6dbb26ec1deso4345498b3a.0
        for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 04:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706011613; x=1706616413; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuQdVqnNuzDqdrPKt8YlC3R5dF8phyxX7z3Sej1qaTA=;
        b=h/wQDg2oxGrw03l0jMP1k0jQBcre36c+uCYlZT/SnYDBK1LD5kzWSCpeGoEtk1OTs7
         K3tHncCpdny1grVFUQlipVikPDPtiIaG/9viKbVwBikoCkfMi6Yv0YgmRD1Zjn8kkQk3
         YzwHrHqHydh8PfBm2WC/bml6mTVD21jo0gnLHDUzuon88mIRU4jHVR1AciwR1kCC0vt2
         e9g59EKdOQz5v6d/PmTjfNNS5PeqlF/y5LcQGIpVt3mCSNI9g9WPSuTgqH4qk8ZJaI0y
         Vqbk/GtQGKKUEpi1/gtHJNThuMNlgoEXKO1Ggosd5+FFxgbB25sMZlMAnG+XbSMG7DIy
         M4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706011613; x=1706616413;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iuQdVqnNuzDqdrPKt8YlC3R5dF8phyxX7z3Sej1qaTA=;
        b=J23Huc4qI5bsgFwnN3gQhffTi0Z9clD+hr0bGe1deixHt5mLZixkODOw7Fu4vDgYWi
         SG82agtDxpgvoq8Bid3wMVNXGTUbpFcdv2UKQodm4Oiby5BEOcB44n+s2bO09ccO4nnH
         SFGgZYLnNLGNjkgPSun1HcwwazjheZWm02aaCAijUkkmp0SlcmzJx545Pun3axSTUlYY
         fbFw6Yb6aO/aF0fChegzmwSLKMYN11fL8vS8DUr791xK5RzfWwjKnt5yz/DTGhWScC4u
         nCbbwOs+t9TQUjTIBwSBjH2rL/Y0qJoDxhn90M1FHLRITaWcJKnmL0/jwgAWBqjfzUbl
         M2SQ==
X-Gm-Message-State: AOJu0YygdCG4Hcc2nFCXha309LV8P3TO/WJwbxv7gnMach5A405KdLEs
	xRt8ngLumZbBM4iQq6oHqaYZkwlSLGujl5kd+lpvTwpw6P8vvzJJ
X-Google-Smtp-Source: AGHT+IE9LK0azHbJ6N9UsOq+sqJiXLwjR5xZiX/EBZPxx8rjSW312NKG0RR4EEIiyeguHn9EFTWpkQ==
X-Received: by 2002:a05:6a20:3d01:b0:19c:5c71:8221 with SMTP id y1-20020a056a203d0100b0019c5c718221mr581257pzi.76.1706011613445;
        Tue, 23 Jan 2024 04:06:53 -0800 (PST)
Received: from localhost (124-171-76-150.tpgi.com.au. [124.171.76.150])
        by smtp.gmail.com with ESMTPSA id y22-20020a62b516000000b006dbd2405882sm5697389pfe.148.2024.01.23.04.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 04:06:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jan 2024 22:06:47 +1000
Message-Id: <CYM2N4QA6ZDB.8JC8WRV7JPK3@wheely>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <danielhb413@gmail.com>,
 <clg@kaod.org>, <david@gibson.dropbear.id.au>, <harshpb@linux.ibm.com>,
 <pbonzini@redhat.com>, <qemu-ppc@nongnu.org>, <kvm@vger.kernel.org>
Cc: <qemu-devel@nongnu.org>
Subject: Re: [RFC PATCH v7] ppc: Enable 2nd DAWR support on p10
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <170063834599.621665.9541440879278084501.stgit@ltcd48-lp2.aus.stglab.ibm.com>
In-Reply-To: <170063834599.621665.9541440879278084501.stgit@ltcd48-lp2.aus.stglab.ibm.com>

On Wed Nov 22, 2023 at 5:32 PM AEST, Shivaprasad G Bhat wrote:
> Extend the existing watchpoint facility from TCG DAWR0 emulation
> to DAWR1 on POWER10.
>
> As per the PAPR, bit 0 of byte 64 in pa-features property
> indicates availability of 2nd DAWR registers. i.e. If this bit is set, 2n=
d
> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
> whether kvm supports 2nd DAWR or not. If it's supported, allow user to se=
t
> the pa-feature bit in guest DT using cap-dawr1 machine capability.

Sorry for the late review.

>
> Signed-off-by: Ravi Bangoria <ravi.bangoria at linux.ibm.com>
> Signed-off-by: Shivaprasad G Bhat <sbhat at linux.ibm.com>
> ---
> Changelog:
> v6: https://lore.kernel.org/qemu-devel/168871963321.58984.156283826146212=
48470.stgit@ltcd89-lp2/
> v6->v7:
>   - Sorry about the delay in sending out this version, I have dropped the
>     Reviewed-bys as suggested and converted the patch to RFC back again.
>   - Added the TCG support. Basically, converted the existing DAWR0 suppor=
t
>     routines into macros for reuse by the DAWR1. Let me know if the macro
>     conversions should be moved to a separate independent patch.

I don't really like the macros. I have nightmares from Linux going
overboard with defining functions using spaghetti of generator macros.

Could you just make most functions accept either SPR number or number
(0, 1), or simply use if/else, to select between them?

Splitting the change in 2 would be good, first add regs + TCG, then the
spapr bits.

[snip]

> diff --git a/target/ppc/misc_helper.c b/target/ppc/misc_helper.c
> index a05bdf78c9..022b984e00 100644
> --- a/target/ppc/misc_helper.c
> +++ b/target/ppc/misc_helper.c
> @@ -204,16 +204,24 @@ void helper_store_ciabr(CPUPPCState *env, target_ul=
ong value)
>      ppc_store_ciabr(env, value);
>  }
>
> -void helper_store_dawr0(CPUPPCState *env, target_ulong value)
> -{
> -    ppc_store_dawr0(env, value);
> +#define HELPER_STORE_DAWR(id)                                           =
      \
> +void helper_store_dawr##id(CPUPPCState *env, target_ulong value)        =
      \
> +{                                                                       =
      \
> +    env->spr[SPR_DAWR##id] =3D value;                                   =
        \
>  }
>
> -void helper_store_dawrx0(CPUPPCState *env, target_ulong value)
> -{
> -    ppc_store_dawrx0(env, value);
> +#define HELPER_STORE_DAWRX(id)                                          =
      \
> +void helper_store_dawrx##id(CPUPPCState *env, target_ulong value)       =
      \
> +{                                                                       =
      \
> +    env->spr[SPR_DAWRX##id] =3D value;                                  =
        \
>  }

Did we lose the calls to ppc_store_dawr*? That will
break direct register access (i.e., powernv) if so.

>
> +HELPER_STORE_DAWR(0)
> +HELPER_STORE_DAWRX(0)
> +
> +HELPER_STORE_DAWR(1)
> +HELPER_STORE_DAWRX(1)

I would say open-code all these too instead of generating. If we
ever grew to >=3D 4 of them maybe, but as is this saves 2 lines,
and makes 'helper_store_dawrx0' more difficult to grep for.

Thanks,
Nick

