Return-Path: <kvm+bounces-24571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A66C957CD4
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 07:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E347E1F2413B
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 05:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AAC148FE8;
	Tue, 20 Aug 2024 05:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="27JyjCVU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496DE1465A2
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 05:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724132425; cv=none; b=cfT2/Rki+dpE7uE2jYcWdAGB405hL/HQNL1mEEl5bhjHlLHWMqdm8yqMqImaDlIx1eTrYSYYBUUsLEN6cqxcfpMwe8JhzzcNieho+IN3HLCmXh3WNUBFxA1fx9JBEC6iSENOgzS6Ehr8zY4SkuJVkO/AhSud+QVO//BVKclxL8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724132425; c=relaxed/simple;
	bh=EwYRKj3OkbU3CrMKamHMEEEe0n4YknB01OQxscBvsDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MuiCBae5EI9C2c7UJ2F7+GtKTMbr31/I7dbKXq3ciCP53piPsyA8SEst+2/RV8fY382Lam6XeRSH72TRgCZAvoMXqUpVQhIPMWylX4lvbG3Ii9iGHG2lhw+2JrvjXc81aLAHUPlAooKwP3V1KTthR0IUYG+mx+zeqCdU8Z48DB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=27JyjCVU; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-81f921c418eso118671439f.0
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 22:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1724132423; x=1724737223; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/GHJdsQ/Q26V4Dt/c4tmH8VqkuznizJko1phacknKag=;
        b=27JyjCVU9oktXk0aIHFCIoZCrz9o+iWPxG4v8F5Vw0w9jpD6kORB668X2BWtxtJIPF
         lQQDiiewadvfA2bzk/52Y7nmr2PlW9wTcCJAt+TJ5eIQvxYCcarstDXwRiDpfJsxjZZk
         NoBr0P1BzY2xFY9jFkXd739Zy/v+oLaK/7NG7ofklhEAGiBmQoRClKRvVh/3GNHfFw0Z
         n7SXsiO6RNTKVnajCILBbMRjX5iK/I3OOuvzBf2hLq6ye71OCUChuWmFiw0wT/POttUS
         SJynKwkMIrfVg4nA0/o+QblWJUqVHnX9hi0+WRwNol6g52QwP3bzuyT5DkuYDQ25psJX
         tNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724132423; x=1724737223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/GHJdsQ/Q26V4Dt/c4tmH8VqkuznizJko1phacknKag=;
        b=FGZSgW41MhI3TtWgHZNOeGMh/IsOU1+J1CzPSsWAnq18OFUlnwXMBxYtgjiT55jcsg
         jQvOjb+q5pj/PieGbr32iaQTJn4VCwG0mm2SCRd3ZPCtXi7ouJRxqQSQkE0scgGsyFGs
         /vAQhq7ZVuI9svfNbIFw7SoWH7ql+Lh5YbO4DXoV8YaZ7rvmkoLgDHqBv9EVfviad1xN
         jF3dvruQSCAV77fVXr25kX1hFVANiILcQg5hia36xIzA3E8vuZR7TNmqKSkHz/BX3oh5
         W41TdmNT/gnyycjTt7O+KE5f00ytvOD6sIkF0SPoiZ/HZ17VZU6er5Kvz6ovU/1vIh90
         sy3w==
X-Forwarded-Encrypted: i=1; AJvYcCXM+dGdEPHXWe7oUAYJC8aWzeq+D+b/KVDhT5kVt5F2k5jn5/Yz/nXNoYRVcF+gPREfGjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOSja0IePa24TLBKPgVx2yeqzpRZjxGStuWaRxSN5zLwjtsgol
	+iPjJ+H1Ntem4i+aKuYQDkjnU1H/8QrbkALjbmdcByBxbWGCa699I7pxLLYCrz7IfYQX4f57+gD
	GvwfGktM/ZlZYxbom84B/V3WKCPV5hAdAExmVRQ==
X-Google-Smtp-Source: AGHT+IEpOyPwY1ti/ApjMw6FrfiNvrsrXNrEkxYxWphvGLVII6n7y4noKSFLykCAOH2pvk/Gik3Hh6G9f8HZPxG/4Es=
X-Received: by 2002:a05:6e02:1d8c:b0:395:e85e:f2fa with SMTP id
 e9e14a558f8ab-39d56de7f0emr22309735ab.1.1724132423336; Mon, 19 Aug 2024
 22:40:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
In-Reply-To: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 20 Aug 2024 11:10:11 +0530
Message-ID: <CAAhSdy33bSGOr6122MBzuLFP1-dQ45LRbd9zQMDPXf_zQDVNvA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fixes for KVM PMU trap/emulation
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 12:38=E2=80=AFPM Atish Patra <atishp@rivosinc.com> =
wrote:
>
> This series contains two small fixes to improve the KVM PMU trap/emulatio=
n
> code. The issue can be observed if SBI PMU is disabled or forced the kvm
> to use hpmcounter31.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> Atish Patra (2):
>       RISC-V: KVM: Allow legacy PMU access from guest
>       RISC-V: KVM: Fix to allow hpmcounter31 from the guest

Queued this patch for Linux-6.11 fixes.

Regards,
Anup

>
>  arch/riscv/include/asm/kvm_vcpu_pmu.h | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> ---
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
> change-id: 20240729-kvm_pmu_fixes-26754d2a077d
> --
> Regards,
> Atish patra
>

