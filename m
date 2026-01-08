Return-Path: <kvm+bounces-67384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C52ACD03747
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B14343287BA4
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300624946EC;
	Thu,  8 Jan 2026 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NRz6DqXa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E948AE13
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881421; cv=pass; b=hLkSVuoTnl2Ya/5fvxgoGSiq7Lyv8X9WqbdSi1Fs2D6vTe0G+RZwPWyOJM8d0UR6pniLLQC6A/5GnNLK/P+92LTehW5xh1ruxadgoqb4cxDKp+7NmSwhND/Pg2t6W/9gR77c10P4+X3Dg7Qt3WkK4p5svOWon5TYrBoaXWHmjg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881421; c=relaxed/simple;
	bh=nd9v6rOTsgtmeIcSOzUf+JTIDj5sX0xCl7dm1iZzN1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bFQSCERJ46hF0WGDa3nbVGguPbAKvexjjU+D+MBEpsB3iNyzSHvOc9hUgEGIRL493B2VggEMUs4NLnSM9jEkVoFsRFRLsEzpwsFFonZBnPW8z7PjyGtMK1xFuR8WLFnqstc7sMjQjgo2bi1b7B1A255qNFZjDRy3XOMsz8LcuSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NRz6DqXa; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ffbaaafac4so742941cf.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:10:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881418; cv=none;
        d=google.com; s=arc-20240605;
        b=VYEgnMzwwhP3grKrNM1LadCoEKvRXHROvWywOnChc8y+U5A9EaYdjTRKLULio9hSbw
         j4/G1EAbcZ/URc6AGXRo5aEV+xvxuZCvjHhMLsFx96ITvq9j3j71muS8acOGIFXtsxqG
         6kVY998VZJVdrW171UA/lCYNIPxd11DahUkeN1zFcBlX1uYUl9OIFHgQa26KLt1V04uo
         Rre9KTEDpIwt6dvBeFamvpDlWrpEPm1juib4i+Uva4zCFBZTgB7rrijE5W+Oy0O+IZO5
         vpm+uEGn1sIX9tTwbOWHXyDAJoz9mB5DjV3kXSF+kbLQeC2lB6AyayVfFVKVLemnp6Yx
         baIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=M6v8yJzivCkGRPQD2RD9WlokTdTcLOTAtGeFegCEmXw=;
        fh=s+vOvWEbV3WGwEs/0OfnlAugpTNSC53rCNztOxhkB38=;
        b=FBAPAS9+0TT0BMhqUJV0iDlg1TN9jN6v1QS9o6+J5v/iyBo4IwALyy4FObB2TlNAqe
         twJOYoNLLl6RRo+sLMYP/u8JJ1pQLAltVW60d1EraQL1SGGon0cCkK3f6D19LOhuCMBt
         BMlE7ehAvgwfjlUEikWAZY8pzl2GUQJvgtHBwpkT/wvnqvCiEKN1m/2oQ4vErjUzVOKz
         0adAW/7wh3ToWhuguXroQ9oVpl43aLOx54WuIz6fZeqnbIQbvWKGEvzLDGBue+J8LTa1
         tClyGqwrQ3sPNtuZLXt5VBR29yYHfvkvegmxtVa7QZmPeZMlRHKAa950Sotw4x5YZ6Fp
         bydw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881418; x=1768486218; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M6v8yJzivCkGRPQD2RD9WlokTdTcLOTAtGeFegCEmXw=;
        b=NRz6DqXa4ClVdKehiDwldRMqmgo3ZwyGOugTTSKJGN7TMEzEW730F1zQwwvuFOPK/t
         K+Ug2iifvUaf+MWX0jmC6f42mdd8oXTHeeZIxbypxamL9QvATvZO0EnRW0VHEhAo37MT
         pOD9fdVkJyXCsMQ8pFWzPv/8to/m9zXiHo9y5X/nkzObA1dOfrsjuCR2bmepspAWt60r
         huLuUEqGosGpeB0yBFBt9BYswxRdbBasEHIUJKLstIMjR3uktGB7D5fSPEtZWFXt5I5W
         1miepmmRdpppRQCPv2/KLURU7U8bt+T3sb6stn9yUzAQNyy89j0yJ30leftE/x6kj2cm
         LqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881418; x=1768486218;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6v8yJzivCkGRPQD2RD9WlokTdTcLOTAtGeFegCEmXw=;
        b=EyUr/hhyZB2slRPekgSXxu1yDPNeOJlWfRqOxgFRzEBiBLs23Yx6frCUoKwZFXyzSG
         xl6YiRQwJW7VFhWJg+0mize6HpcwL77RaXUs6HD/1RxEQu/2ZAe81N+vAvkypxPZNJ+k
         FtYiufxjwzihtxziEyJ5tT7fjWsRNe1LgKlQ5oypQo3S7bT+jm3IhebJFxhESjx2kFon
         ISPsQ/psEIElnrKfP3tNj58iV6RZxP/+E6L6++xFYaqCU+XDyO9oMiS1gs3pQp8VIWxg
         HYXIdqRQjjxLN/r/ffKVKpcLLYYXiiMOzhdRIgbvgIkSqsAJyM6UeTbcwcHorNBq4uH4
         Ayww==
X-Forwarded-Encrypted: i=1; AJvYcCUpFGpDwM3Fy0gWYRYzn9Hw+RqPwxwiOW4R+uq7SvihjYeoZ+pPBOdDLs54eykdRFz++oo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw5kBgeFu/i9xCq4LvQgTpIpdSIJ/7iIb5HBQwBRsEVHum/ZtH
	6Owl6LZIhXGF47vq/5sOzmA4d4oVQi7WiE3jGyhSpnBBZlHi8bcJRNyfCna4BPuf4ye4OP+A7rv
	kp0W9w+VPRc7Td5o70D0rvoUsekDem/jthn4Hr+Mw
X-Gm-Gg: AY/fxX6wRqmBWSq+fr3MHnPLvk7ICohKi3w7dlozctwrvKhPG96MzhnpTdVN6RyqkBr
	WtThXC10xe+BxXEz6+w3eQwvzmMWwzrStOw8PZYk4lHTb0IswmXk4c2nOXC0oHirLW10u6Yqx3V
	0veGySLxRXVju0Y4aEYXVd7fHOH8+RGcn3kLnz5yisQOlthGlR1WW556wmK3d76k4bC0613CFeh
	6sy63llqDDxGlidnjYxLb9O8yU2TDHq5uAz7IxRIwrvaDPC6RexPSleFcoFG6SxhuGWuQ1A
X-Received: by 2002:a05:622a:1191:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-4ffc0897ee3mr8604171cf.1.1767881418089; Thu, 08 Jan 2026
 06:10:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-6-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-6-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:41 +0000
X-Gm-Features: AQt7F2rcFTpAi-WrxH-BJGuce-rrvqsGKbxHYZVaorpjl6SSauHiDAfYA3cghe4
Message-ID: <CA+EHjTznG=6+bYW+mmmBs_QqZ2rXkKTzNxA5KSh3S67H_BBaHg@mail.gmail.com>
Subject: Re: [PATCH v9 06/30] KVM: arm64: Pay attention to FFR parameter in
 SVE save and load
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> The hypervisor copies of the SVE save and load functions are prototyped
> with third arguments specifying FFR should be accessed but the assembly
> functions overwrite whatever is supplied to unconditionally access FFR.
> Remove this and use the supplied parameter.
>
> This has no effect currently since FFR is always present for SVE but will
> be important for SME.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/hyp/fpsimd.S | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index e950875e31ce..6e16cbfc5df2 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -21,13 +21,11 @@ SYM_FUNC_START(__fpsimd_restore_state)
>  SYM_FUNC_END(__fpsimd_restore_state)
>
>  SYM_FUNC_START(__sve_restore_state)
> -       mov     x2, #1
>         sve_load 0, x1, x2, 3
>         ret
>  SYM_FUNC_END(__sve_restore_state)
>
>  SYM_FUNC_START(__sve_save_state)
> -       mov     x2, #1
>         sve_save 0, x1, x2, 3
>         ret
>  SYM_FUNC_END(__sve_save_state)
>
> --
> 2.47.3
>

