Return-Path: <kvm+bounces-60293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1701EBE7EC6
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 12:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 03A164E31BE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 10:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9EA2DE6F2;
	Fri, 17 Oct 2025 10:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ieBy5EYc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC42D7803
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 10:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760695205; cv=none; b=bTsWpkilMmIPlKIFfwpgT1qfUwjAUV3GeuuuiQv2QJefQvrJrxM6rqK4qLMw2VVR4+Hw9af5SKMAHUMQsnMo4yhL66zajBKnG8mZVuKHuEMjSz8D2J/xECSu2Cc5kZEWe8esSmIs5bQo4gSjzH3cNTXFCawxIQ6EAsHyKzkgbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760695205; c=relaxed/simple;
	bh=VJa3DKX/KUQkLSI+xZa6UVrAyJoP/rqbHYIp2RkqgOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cRjE42yoBP0InbfbAJkP2iGsZJuCtN5cFY8nAHjLshLoK1eKTMPGWGnSIHXCmWFxjlPgfrz0W6r7sTecxefZaHSgw1/XsyvugGab4DKaaU35gQEHUg7nM77nt1xEfh7GDJaqOF6/wcT0nPRUusoNLdorXGtCec9YWjtRWOb7b74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ieBy5EYc; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7815092cd2fso20637677b3.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 03:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760695202; x=1761300002; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VJa3DKX/KUQkLSI+xZa6UVrAyJoP/rqbHYIp2RkqgOo=;
        b=ieBy5EYcbKwbxVxR6gIlcLevKg4ktWU82+93SCXIGQto9h+y4nwIhoeHkzFhYRg/p/
         7RnDWKLxDA1cCrxf68WgZ2N2sEG80tse8T/2xsP2cFpJO4Ldfts5cOnXFUmPTW9K5Qbc
         BFvPrOJ76JauBD97eWuYH9KfDS/NmGnoYTPAxL7W5GXVZ5sgFhwNJFsd8HZ6quNa4XDZ
         8h4XOupkl06L5IwZIXLB4IiDRR+xa9tpLzqIFcwWy9HvMF+Ds87lfe2QwofBDjYMVhmr
         T7w8BwS1Y5p+tZTlb84PsksyjKg06uSPuPFXwBBInQq8iPgtZVnJtacz8oglrxn1wzcN
         bExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760695202; x=1761300002;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJa3DKX/KUQkLSI+xZa6UVrAyJoP/rqbHYIp2RkqgOo=;
        b=hvwCsLwhPokhQiinVjIMjWNRgFjgBGH+k+iEy6tgcG2f6DaN5zjm6yCxCzA98MAFFz
         KTz655enc5ekAGL1aIaoUmvN8+3UvM9RFH6rBZxS/+uD/GEnvFexgWZGdCOk2UXfWng/
         PSz991Tgs98PUt8LMrpaSB/jyVRZY4ufOctUkXoQbil8iNxdbRsKvan7Bs0/3lmj2qL1
         f55+UYXw3m1g5q1/Ko3JmU9218t7Kjb5yzbjNu+bv2xdGCGn+ZoOP7J4kA2tKgewU+Up
         xsKSeiAZiBx57tRDbAPCWNdguhjDhpah5fSPqPJdzMNXVX0CrkvSCIEqvk71FSdLseeE
         cN3A==
X-Forwarded-Encrypted: i=1; AJvYcCV1dQs6TNUWuxYSIfJR+Mop6pv3O++UvlwUEmVcmEy+Zygj9OcuOnxjHdWBDEEIe12Rk0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUEBRcD/HgYwqQGAm8upCIbuKF6BDEFbjWZFCFzeGDw7P7HrdZ
	SO8sY92rtCK/8w4dGCFtAcd1UIG2ziQDVkILYlzid2yHbLnz2UKuMIV3VTWnFE3UXUdnjU72DjJ
	lVV0tJE5FYxGp888U7dfB4KaM6VKg0WH7p6sliSGSPA==
X-Gm-Gg: ASbGncvoUhOQ45pX0wxvZ3OKvAGXAEGs9rcMuib70TENc1t+8kv6PNTJrdvuJCYu2RA
	bj1IMYq7/UDvDexLNhi5bQUtI3cLvdNEWAD+IM8e1SFWIGz/E+s0s1hjq9O4n58FOcDWM/VaXpa
	1ovEB6g93CT85nSU9RkRKYRWW/YTzah9cA+6zqs1WpoSATvYLuPFT2OChC5CdChSmvlvZHDlFhd
	QCLMPmDVNAcsbghb0GVrGivdco2aREKU2u6559SpjxiO5Bovz1V2i93g9TAoWwGPYEJ3r+MmrOq
	QShU6n0=
X-Google-Smtp-Source: AGHT+IH4OEBDLw07h3F0P2nswJ30GRiaPlMQzRr3gsANdHzUh6/Ser9QSnqiUsgXdYQ9JpTls3EO/RERzdJy4f9eMJ0=
X-Received: by 2002:a05:690e:429a:10b0:63e:9e0:4727 with SMTP id
 956f58d0204a3-63e1610ebc0mr2543424d50.18.1760695202280; Fri, 17 Oct 2025
 03:00:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
In-Reply-To: <20251016165520.62532-1-mohamed@unpredictable.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 17 Oct 2025 10:59:50 +0100
X-Gm-Features: AS18NWDtFsdK63CgYP4c_rTmG--Mnbl7EfCsXWh2HUfMSt_ZscexxzPxI5R_BrM
Message-ID: <CAFEAcA9VWiQoOytHh9PbbQZVXm4ET7Ud9eLQP0C0njOO8R8qzA@mail.gmail.com>
Subject: Re: [PATCH v7 00/24] WHPX support for Arm
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: qemu-devel@nongnu.org, Alexander Graf <agraf@csgraf.de>, 
	Richard Henderson <richard.henderson@linaro.org>, Cameron Esfahani <dirty@apple.com>, 
	Mads Ynddal <mads@ynddal.dk>, qemu-arm@nongnu.org, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Ani Sinha <anisinha@redhat.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	Eduardo Habkost <eduardo@habkost.net>, Sunil Muthuswamy <sunilmut@microsoft.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Roman Bolshakov <rbolshakov@ddn.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 16 Oct 2025 at 17:56, Mohamed Mediouni <mohamed@unpredictable.fr> wrote:
>
> Link to branch: https://github.com/mediouni-m/qemu whpx (tag for this submission: whpx-v6)
>
> Missing features:
> - PSCI state sync with Hyper-V
> - Interrupt controller save-restore
> - SVE register sync

The interrupt-controller save-state we can probably live
without if we have a migration-blocker for it, but the
SVE and PSCI state sync missing seems like it would be
a source of bugs?

> Known bugs:
> - reboots when multiple cores are enabled are currently broken
> - U-Boot still doesn't work (hangs when trying to parse firmware) but EDK2 does.

You need to fix your known bugs before we take this, I think...

thanks
-- PMM

