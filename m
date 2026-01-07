Return-Path: <kvm+bounces-67262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F337CFFE2C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 20:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86DD430693D1
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 19:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A67337BB0;
	Wed,  7 Jan 2026 19:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vX1yjyBh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3B3339862
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813956; cv=pass; b=CI9O6Rrz+IGf8OZIpB36Pe3+zk+1YyO437iPabD/wHrKQlk7lJobEy40xHh82K5FqBIybVvtIvmHj9/Kf6RRrNUrPwHbLH+SgZn3g5EwdTkrcaQopH/iVjaWMYbFAE2T8MzdzpeIObz4Nt0uMTIl2HqRgxCYG/Rn1NvjrLB7ayU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813956; c=relaxed/simple;
	bh=y8s3ifhfbIRmZEac0G5rIHRfhu/0TKZaV0wEbXVBJlI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q72zNSmamyCszdam99j9bJajXwmpTPMRYP6TKAAgyUfOyIf57l31TX+ETIoDlduqoY+2zD9T3UxluuOLvrd/JNgD+N/61SXMWKmlWxoXUw1gQGh4dgEDKOsLQAA52pvGSWPQp7Vl0EgbAwKAwpL2vqXOMA2ET2jYPyLAsJHiN9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vX1yjyBh; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee243b98caso480991cf.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 11:25:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813953; cv=none;
        d=google.com; s=arc-20240605;
        b=C+G5r4h0kzuhgJ3vZCwitnzxo7JLXIwFSyRGhGWcdao3NnGHi1NhfHe1Jd0qgKB4bX
         FJRjn9Y6pULw/yLTHcuKXyr4I+j7tRhIv2Q5cWnnKG365+8mkcylvwRhpsh+ObrH2K5v
         LxVqBIEoa7C9Sks32mve3O8mtn1cgH2aNp6gd5ly7xjwaoADkpPIbp5Tt1me+JrT7M+w
         jTQJ27uk4K/gQ5MOh/YVCWfSBJTCCWxCQMPG8fLMF5Hnv7u3tncleUY8ViELQ8L3OtoH
         +e/YDcJqdUgAup99hSLS4r/d91/ZkEJf/FZoSByNEdENxB9HokpTfkM9GZ1MA7PtT6lr
         2qnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DwyOUMrzmFja205ZMg1MEdCnMMj8lyhbUqchQTaZ7Og=;
        fh=Iw3jL2UCv84Kis5zeJ9Sq/BfcSOqG7VzYspw2Y+lRzU=;
        b=cnl58ejWz94hYTjY4rEy99P3qgEv+ZFrXoZk/l6DqVF1klHv/RHMXxnvWmzYdJVl1a
         I7kjg65spkDwBj8gHplIc631dsbxZEqLFJ7pw3Z6DHar1DgEGyZGWV5S05jqf7yAnMqV
         g69X6HM9vKW2+sbFyvjGB3QkG9RRdjuN2W8eOzfCmRJrvNO6/qlANin2WWcqqkFgL1ZS
         46wt8HPTfUZZ4z9QOm3biIqG4CJTSNgR0flDxPavXi/CMXCGJ6MzrVZMm58CttyKZtSl
         xzWAOlyncrHUFBw3ASsi9mdCG6zAT4kG4DtAtdfSu39drbkACdMPU0zmu4xlUb9zlNfA
         GQEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813953; x=1768418753; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DwyOUMrzmFja205ZMg1MEdCnMMj8lyhbUqchQTaZ7Og=;
        b=vX1yjyBhmp4CWQ4DaMo8exjlJpva15g3y7A8NIWIfFtzZc0X1a9orno9wSfz+cw3OV
         WNDPy7lGp3OYsX5b2+nd/yizBSFaHc7yHrGOSkQ3olLdVoJsvy7mAsFNCdfmE8P81BSX
         32o3vWMMHtzFj1PYnniArCiMwjmvRFzstZrhXAS+pBtqLh832gytaaIwsMCZej6PUgnI
         r3BxARqmyjA6lP1iFfz8pylBy4pq+YcCeU0DB45P4lHDqwBlFZCeBfpmdRUmYxYvaLc0
         AlYrAzq7PG4R1U9xtApgeNttuusHLanB4wkOynd4RQCGV91+S8n0GJ5pATM/CNIyNSPZ
         LUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813953; x=1768418753;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwyOUMrzmFja205ZMg1MEdCnMMj8lyhbUqchQTaZ7Og=;
        b=kP4iPwslqnl2fP+oVmFVWQ/V6kvkeyOcR57UCXSRhnDcir8YKp7NsebBgKRI1G5rLj
         ApcaZ7521bSue/StJIJlDZyj7Lt6/n7BLQiTrdaJOhlFPP10A0x0ItW2S9qRFAmIhxZg
         DyyLWHR9fIr4R8g8a2wbN0ee7LJpSBTcgsNq2qusCEy2OyWGzaOnNq+b52hB1/yUBk9w
         TVCGqkQfeY2TqEa7Sqqr7gx5fiCl2zqUYcThJMBaBD8X6eH0H5C3EPsrAXya/bCufe1c
         uzseCl1xuDd3dXmP4BkDwWbO/9ML/ujxIGUSNR9AdAeP2gGZ6JSsgGzb8eLg1q3omApc
         xnIA==
X-Forwarded-Encrypted: i=1; AJvYcCUwTJ3DRN2sgtHUaBQTQvWADszfm3OFMfaMPevA9U1OTjq+F/4lMIhebO6/EvxBBd3GtpY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRY2tQXDu6Diw7sanxMEkq6sXc/CQmFYonyFu1QqfP5F6BeFm0
	qzcJkO1NiBf0QuAeHasXdXlZt7LiaClISGtznJi6dWzmdRpUncmsJyWvjYg9B0mMIjYRBop8NJz
	OwJ8dNI14EhoqKbOmIXuPYFKQY7NLe9cYfX6JNzsu
X-Gm-Gg: AY/fxX6hPQdZ5qS2FY5dZi7UpsDWBqD2RYCx7VJZ8FQkdL8TBLZWFZqbWZI9/0fnbX0
	DHcfKz1qnO4X2y5syoZhvbLbptjLIezfKaIK9WgyVEVwphazP959xWn2PcpRGWE9iZc9TJEh1Iz
	hPiwANMXf7/egSX/5JONbchCipmX5uUOccmmiOSOHem/oEtDmJywgRjTiHYU3WXK3hFGio0/5nk
	4I4pnqL3lrEd1/kaISQrl6H0AUUSfW7nvCRh/u+VUP30dTTBFtbO2JG3OV8Buv7WlLur/DP9vpI
	mOLMpEw=
X-Received: by 2002:ac8:5e06:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-4ffb3e48178mr14762551cf.14.1767813952742; Wed, 07 Jan 2026
 11:25:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:25:15 +0000
X-Gm-Features: AQt7F2r6YVCRnMI_bYmOfq7HyyiGhMeA9fZkYBf6xbcFUjdNaJYVtQzKKg3T4fA
Message-ID: <CA+EHjTzDxJsLi315RF43g14psdv44YOuxk6dP6SLgFz4WaY4Hw@mail.gmail.com>
Subject: Re: [PATCH v9 04/30] arm64/fpsimd: Check enable bit for FA64 when
 saving EFI state
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

On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> Currently when deciding if we need to save FFR when in streaming mode prior
> to EFI calls we check if FA64 is supported by the system. Since KVM guest
> support will mean that FA64 might be enabled and disabled at runtime switch
> to checking if traps for FA64 are enabled in SMCR_EL1 instead.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


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
>
> +static bool fa64_enabled(void)
> +{
> +       return read_sysreg_s(SYS_SMCR_EL1) & SMCR_ELx_FA64;
> +}
> +
>  /*
>   * __efi_fpsimd_begin(): prepare FPSIMD for making an EFI runtime services call
>   */
> @@ -1980,7 +1985,7 @@ void __efi_fpsimd_begin(void)
>                                  * Unless we have FA64 FFR does not
>                                  * exist in streaming mode.
>                                  */
> -                               if (!system_supports_fa64())
> +                               if (!fa64_enabled())
>                                         ffr = !(svcr & SVCR_SM_MASK);
>                         }
>
> @@ -2028,7 +2033,7 @@ void __efi_fpsimd_end(void)
>                                          * Unless we have FA64 FFR does not
>                                          * exist in streaming mode.
>                                          */
> -                                       if (!system_supports_fa64())
> +                                       if (!fa64_enabled())
>                                                 ffr = false;
>                                 }
>                         }
>
> --
> 2.47.3
>

