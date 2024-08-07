Return-Path: <kvm+bounces-23530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 214A294A76B
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 14:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCF2D1F21C54
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 12:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AED11E4EF4;
	Wed,  7 Aug 2024 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lCBXe2yE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94159376E6
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723032225; cv=none; b=KIP/Anx2jdptk6bDgp2Tlp6/1w/HKu6DXfqfT/bP0QjQza+sAXvJXZ4kuM/BYZETAcb6w3ZFbWDlk8gcwJhXlaZzdNFwk/+3aiFTNvlxJh3y6CXd5vy/moQ9aBdH8luUiv8N/N1L8+W4GW5Bvp2LXECQ6rp3hMCi0fW85Gz209g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723032225; c=relaxed/simple;
	bh=eHnzZxvF15NpFQFuEEUPzUKpxsYKctPkdoG+AlVdl7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cw6Yiw4/fhTtR8/3Yqgdy7zOtzqisdQZ+DeiEJm/AWq86NUMwzJv7s4TIR3e5+MucPf2blB4CpeuWWl5Rbp/1Tbh97GX53lBv8aO3sbTjM1IEpuGbaXNpG4yHhWMEnhF3anJkA6+sIr8fxS/mTcVmXZqdC5k8P5NrHf2dyBXJNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lCBXe2yE; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7ab76558a9so137404766b.1
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 05:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723032222; x=1723637022; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0TEK7VexrgHrcuRN/0zKNDoFgC5jZ1V28n+hBRwak0=;
        b=lCBXe2yEvRjICHiAS2v3NjdbHsWVeQDfW+NK2Kxezijps1MZF7h6Epew/tAQN3Ajjp
         WxAR39Qa54iQd0wM61VY6ypqcL7Mqk6nlEmdLHgCk/ZsFJhIzmmdXH5Qah91NcYhEz0e
         iWOqx5QhqmYZGn+6Jx7viYdzVR9sTG0eK6gxpD4EfA3N1OlirxRP8Gc++bjKP2FNVYVQ
         1sOBL65gUGi10lfZWa+riYPtRDq6F/guEa0axxbCijiWQFcSPNXBB5Ij6YO4LsgFoGU9
         esoOxNV51ypEtMtlfnS0Nhw+HgxVllsE4rz/15a+xuj81UQevjBK40OuTUib5OGrxGvK
         /AIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723032222; x=1723637022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0TEK7VexrgHrcuRN/0zKNDoFgC5jZ1V28n+hBRwak0=;
        b=EIph5zSyZuWTdC7Ay32hPeY940CDFOERxG/2Ii5a+Kqn7cLe5L3YnEGq52xe+cf3zr
         SyZx2JdhWJgjkblcKdaIWqDNgpjaovv4BJzwr59AqACVF0xVnCa5kVFimD9kBQetU09p
         WuhXHWU/lDfJ9uHyq426kys6eJvm00hby2l14CC+xwhsmO5L52vImA9nY06C8pgOi4ij
         gTRc8vJlLjbk8rEqRhsAswxvS6rzQOddbf4IX7NdWHfwu3U8aabLB7V+jxzOQ5aCcIuw
         0wjJgTdUMzM5n32hu0Na42SHdQWwwPIQhuvDQ554AeTuzOAiAj3Cbz7yMSL7piP/ePml
         G3+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/+pMQhHpcxr1onnxklEL/Dc3Z5sF99bFq/TrK3MuscUMGbPw2kWO/yl0XEE9fK8MfsLaZlYzoNaGuVYflWTCsHbdZ
X-Gm-Message-State: AOJu0YwCK6JDhR0DxjCDercQNZ8yLKn3VD0D1k59ppxP+EoiBjHUqEoL
	UrPtNsvRn87MyBEBZrdiWSAjFWPHOihaoMr5pFwskIR6zZAk4wjGa7hxSF119vk8CFd8gXKql7L
	sf6vX+mBHKZNPRf5eDXp4feXdncHLyVkHkjdVMw==
X-Google-Smtp-Source: AGHT+IGTVN+IAvtqUg54NSlcZRxqUYzfVGO8u0Dk8yXtigYp1alhJB0nuEHChv2kofRqFw7L4Y+G/Gne2p43XudD/dY=
X-Received: by 2002:a17:907:3f86:b0:a7a:1c7b:dc17 with SMTP id
 a640c23a62f3a-a80791a644emr143296466b.22.1723032221748; Wed, 07 Aug 2024
 05:03:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807115144.3237260-1-maz@kernel.org>
In-Reply-To: <20240807115144.3237260-1-maz@kernel.org>
From: Arnd Bergmann <arnd@linaro.org>
Date: Wed, 7 Aug 2024 14:03:28 +0200
Message-ID: <CAKWjNY-=WWxUX-u0g4A_a26U1GNsv2Faak49dkjP-x=ZuQfPvA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Aug 2024 at 13:51, Marc Zyngier <maz@kernel.org> wrote:
>
> With the NV support of TLBI-range operations, KVM makes use of
> instructions that are only supported by binutils versions >= 2.30.
>
> This breaks the build for very old toolchains.
>
> Make KVM support conditional on having ARMv8.4 support in the
> assembler, side-stepping the issue.
>
> Fixes: 5d476ca57d7d ("KVM: arm64: nv: Add handling of range-based TLBI operations")
> Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

>  menuconfig KVM
>         bool "Kernel-based Virtual Machine (KVM) support"
> +       depends on AS_HAS_ARMV8_4
>         select KVM_COMMON
>         select KVM_GENERIC_HARDWARE_ENABLING
>         select KVM_GENERIC_MMU_NOTIFIER

I think this is good enough here, only slightly more limiting than
we strictly need. A slightly more fine-grained approach would
turn off VHE mode on old binutils but keep NVHE. That is still
inaccurate of course since VHE only depends on v8.2, so
I'm in favor of keeping the version you posted.

For reference, even the gcc-5.5 toolchain I built for kernel.org
in 2019 came with recent enough binutils, and we are likely to
soon require gcc-8 or higher anyway.

        Arnd

