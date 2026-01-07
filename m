Return-Path: <kvm+bounces-67259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD3BCFFC06
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 20:27:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE7CA304E5EC
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 19:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FC03346B0;
	Wed,  7 Jan 2026 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="md6V+HBO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD0C33123A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 19:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813934; cv=pass; b=gfToJupj28yDvDkcIR8VnGT9+JWbVODYyaF3oaX5jUtU9rKMN1bK+cera/c8beGaHJ3hKFJ1PsnS4NQArGz30MEQOQiimNMxTzSJCtNwdsMQ27zkm3ae0Cbe8LgY71dSRpv4osGz8XqXkeGHHHtDwuljeG/MvGLe24FlM/+nOFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813934; c=relaxed/simple;
	bh=z8fphxS7A/1Qur4z0EwbQJFYY7ZrGXkIomdruCTWhiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RwqfHWtmEfQ3w3J1Ah+07ilbGcRHbCMjiujF3OJk57VFtqVW6AkPjONSzsqPhStJH9ojEh3cfKK1Gre878gSrlA+R7mlQAj3gYnJfx+CUQ2YCnpXX6QJA/0los8COEAmhRMASAqx4q5W9B3iqDa+ckm+LGj5o8O5mNCR+JWeZNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=md6V+HBO; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ffbaaafac4so345791cf.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 11:25:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813930; cv=none;
        d=google.com; s=arc-20240605;
        b=R6cQA5fkwE++hTNkiLw0stXHaJXSDaXAStu3aNDmzzXqBtKl11mhSM30rHEG9toawH
         9e3UrWxzpa+H/QA51bX1NN/b967qMmhwmfmy5o0MmXHUtWeLl8xqvrBw8LeT8487NLcc
         rLkLxyLEH7ggnYiXqkLBt0BfTOXbclZSWgWPUgOVdRlxIX8X+c2PyJHfwyG1rctD8MnI
         guS87PPi8rNUDh/uVZBl2R+3OxKKgs6rgbNEcTElkJrXL8eoOUT3H27cR4t7RPJP7POf
         2y24UaoJoUVqQOhlT3Rf8+YIcn7yMRunRYD1FG4FeAgBoEs9iL+gX/IDLm1N0TnGXMCq
         Jntw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=sdQze0tFMfdCcZRE+Fz1xsHkvoih7BkzLiCp0crO/Bc=;
        fh=3F741lVmWQzhaANt3EUZap78WgERQh1d4s2k1Wq2fUw=;
        b=PDBSCymoXn/K2Uv/W7i2Bu1KufqBG9+ClaUROIny61OSKoXQIggAxfe2OujI9sAuZD
         Qhty3E/2nFGZ37XnW5qKOBQQSsi/b7iUtOGebSYGMDsfQ+E9N8Sr0yAfAy3dBR1UqF8l
         5yaEaJVIhfsm3/EbkduenhGGpqzSzt6v15kDM9vXeqUYWFNTQgdgjN6wvoTe5hofq5so
         o2wySTJ+96jrQnYbHF87MxyatpH1ZglUcYFh1lhTdbqS6zpE8MAlZupviKt4OVLtReZq
         n3GIlsWdlmcHWR7xXDbpjO49wce99R2MtM061yZ/MmlW+wu3bU375++AfCmcgGNPNYMh
         OKYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813930; x=1768418730; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sdQze0tFMfdCcZRE+Fz1xsHkvoih7BkzLiCp0crO/Bc=;
        b=md6V+HBOPniNT9Y/pRAoZBDQhjcszlVdyKa+xECql/xfCKUBkHI49FBoMgYD9STLgV
         iP9h5KoAv32fDrbf2kHOGhvP4wcYPWZz/g8dZYgqMD8Wi/3mOyNWmEdY+9BXlIhq1nPL
         4Aukl4E3l3MU9V8jR5URmnHstzKmTxFvYCRMr3LjNxJE0B5P79uX8SVYW172m3lM7alB
         Zu9y0e+RkvL/j7jJGpaUUe/k5O6mQBGWO8I4t6Mba6z4kTmiXWQCkLsOm1dvOo0s6Ocp
         JjRIHshv4SJjpToVrA7dNTGHU8xBkuEdUPGw3GAz8P8Earvyydb0ZXriMqCSk1VlnRZB
         v/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813930; x=1768418730;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sdQze0tFMfdCcZRE+Fz1xsHkvoih7BkzLiCp0crO/Bc=;
        b=NbT8vovVqpkLVOIyLjeci63IVPDuBLGXvf5XF6gcRYRVTbYYWdfzKASRIEZsktkDDL
         BpSGAd/Jut/qwYngHOXHgo4AfxLGIcstoQLyXsTzXsqOCc5l8b0jOd9eH9YMstosn4WZ
         DlGVny6iNX/yvL5WDDc93M7yh7KrHPYlL15wLaQrxImwNYdvu+qoWlTD03UXmql790yR
         KSScgW/JIWkwuQYwFcsKuR1N7XqYFeDWhsYgKFN4XPNNHjMkDOIpMYLkrwilpr2OrvSO
         APGhY3ilramaDS33xUSQm9JnA2B6wPQib9UGmXdJ5YQkgReMxJPpBoTsR40tjB4SHn2c
         nUBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcirmL0kZIR5qL0+ZVmewpv7kw0qevmcfYkO2/3FhhxEOEXpyeMhcRPL8eQdaoors4tWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvXoHTaoJMrlk+ZJJ9v2Y29YL7sNhhlg8W5CccFfik/LNJ2P5k
	8k203PT41BocwKvzuBXNrfN5bnJt568M/TJjZ019+7nh6AOy/a7VcYDfjOeqffZiHqQbIKoGuIA
	xnW70t52FMZl5EO/hA0poYyXFn/wnfhDeT4gyUt82
X-Gm-Gg: AY/fxX5TUheD4r7sQex6EV+TgoiZ5Kkl4PZJ+ZY27N+Da1GNqVA0EXVfIOkvBPyRzeX
	Ux54sDWxUPEUlKhhyx/XEK9pPBwD0FGqGZwSV5UtyYylQyv04Yx0KbA9kJpmrXEdWeG0B5MzL8k
	RZWaypigX8z2aToVjRPdifwpyx0+yFtfeECz9Y7QJP2ux40EvksrvM2DmAazmvPS3ca5iEApvOb
	Ftxr6gArrJfVU/Qtt6TmnS7BHK7apar+Nrku2jN5aZtXTXBv3tAcUVaig0yt1wmdbwiJsfm
X-Received: by 2002:a05:622a:5cc:b0:4ff:7d0c:c1cf with SMTP id
 d75a77b69052e-4ffb3aa6b6bmr15709851cf.0.1767813929956; Wed, 07 Jan 2026
 11:25:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:24:52 +0000
X-Gm-Features: AQt7F2osm9O_NLuokFKY_-m1ya4_XJF8FlJHLjM1yNQTzxjP3vc84G0MiN9eNTY
Message-ID: <CA+EHjTwsX9+3XZBZo8PHvaP24fVxBKSdg_raJGL46nX5hE-4rA@mail.gmail.com>
Subject: Re: [PATCH v9 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601 2025-06
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
> Update the definiton of SMIDR_EL1 in the sysreg definition to reflect the

nit: definiton->definition

> information in DD0601 2025-06. This includes somewhat more generic ways of
> describing the sharing of SMCUs, more information on supported priorities
> and provides additional resolution for describing affinity groups.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

It matches the spec.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/tools/sysreg | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 8921b51866d6..6bf143bfe57c 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3660,11 +3660,15 @@ Field   3:0     BS
>  EndSysreg
>
>  Sysreg SMIDR_EL1       3       1       0       0       6
> -Res0   63:32
> +Res0   63:60
> +Field  59:56   NSMC
> +Field  55:52   HIP
> +Field  51:32   AFFINITY2
>  Field  31:24   IMPLEMENTER
>  Field  23:16   REVISION
>  Field  15      SMPS
> -Res0   14:12
> +Field  14:13   SH
> +Res0   12
>  Field  11:0    AFFINITY
>  EndSysreg
>
>
> --
> 2.47.3
>

