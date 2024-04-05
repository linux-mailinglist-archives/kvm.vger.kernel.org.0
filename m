Return-Path: <kvm+bounces-13740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2EB89A105
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 17:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A808C2839BD
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 15:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885C516F91F;
	Fri,  5 Apr 2024 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Wm/RTCN1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8731A16F284
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 15:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712330770; cv=none; b=pr5KJGBY5Eg71OrGRghBzh2eyPzA1Gvtth1Iig0RGEudD2t6h9fOf63Q/tjLoDQq0fQJtTUPnBLP7RDYjVQ7lUyGKeXbdo0ufLU41zwV0+V9GUMaWShCcIp1qTVbPqXEvnPdsRH0UWzhF42Q2XusGYH3Vr9A5LWl3/Or/gf+qX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712330770; c=relaxed/simple;
	bh=FpZsHScShuiC5TLeSY6xcW0Dmrsa7iCr6rnrwxcP7HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5l5n7FocX65W20BEZ7IkznZPSv2Ii7c24a+GsAK4k8j1zhOEHXi8d+X685raN/ANglTJhl2bUq9c9y4gUx5dkBF3GpTOUClq8W3XPM+canOpeWXGyl/TUi3Cophw8nziVQZ+MhdkUR399M3YJY4ra8iCH2M+E2ShJSBFOQNW7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Wm/RTCN1; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56e3e03b989so179699a12.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 08:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712330766; x=1712935566; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ed5x3XFfsBgZRAt34RC2mOQsGKeyKPo4QsC0c+Fqv3c=;
        b=Wm/RTCN1H4zqI6tvTsI2Y1Wugd3J7bAQpDuRnLw/ck9uBGNWE/VM6C1KxhdQCJuWG7
         rKgt9xO8xILvQgnUy5PsfJ/YeEV3Pjsx0Y09VDcOFlG5Atf8KRg6B/nmOO8s2v3xBnh1
         ysR+iPvrpO6LzGBdrGMlgXzAwGxWuNPGLNd7xgaOmS83MjcSAqYh+M9hjZTt40oq7B2H
         PI5F6th+qQIwqdl4Uwp3OPT0z2HH0NINm8PwFP3XltsulFvCu81hyUsUziw7wtiL8hYT
         Tj/pXavMeoSa883CsU79YKMIqGQ9fln4AjUYl6GnPzi1R8lshp2PuiHtScOK06csT7ig
         LWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712330766; x=1712935566;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5x3XFfsBgZRAt34RC2mOQsGKeyKPo4QsC0c+Fqv3c=;
        b=Iq2KpRFXPLB1l9jemB4YqYcTOYwT3apyhhgiApBNI8E0FJp6acMnDmtiDmRRSehNF4
         wfyLNPbzopVq2+19EQ+p8AojSgmIB69+0QTDxAPxqLOihXe0xpvZ4Gcmd1+Ol4RQYYEN
         sXYkaxZUTzgSVXTtPb9UFqsZ4jn3bnwnQcoRNwaKrYiu45Pz+5BeVwxZMo1Rd4knn9JP
         PlDi+k/lmulT4CWgR6E/pmXeMrg21/TlF5aKPAZK6NlvpWy6Io8erWORAFyM+3nwXxsN
         wfX9EmdO9ScYbm4UZ46kg2Rg0OvdO5sG4flH7MsjBobth+GACQ8lZGdThfIZ0oo6x6iV
         mUcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLm8juJsQT/2VNvUUlQAN1V2gCu1J4BjcIINB9UgiKRNmCXjTkQPedDVQ7bDbs90tTUjWnEhVlBMPyWSft0K4kQY5e
X-Gm-Message-State: AOJu0YyMF4tSJaQPPvCpZu2K3ZDKMtpccX945fZ1lMGqxbU/E88HccX/
	zhikqsUKRA/smzjuX+WK5tITxBb9T81hOawmi6f41m1sLIeTeE9QSzsb2XsWK3W+TsQvtq3HDal
	d
X-Google-Smtp-Source: AGHT+IE6KiAsWau+yt3agpehbLfQdmB5U5LrPm1st7ROHU8ZRsWd/qG+KSVTOZ1UuqjphPekzLBQLg==
X-Received: by 2002:a17:906:684f:b0:a4e:2dbf:2eb0 with SMTP id a15-20020a170906684f00b00a4e2dbf2eb0mr2301320ejs.38.1712330765762;
        Fri, 05 Apr 2024 08:26:05 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id gx5-20020a1709068a4500b00a4e579ce949sm950515ejc.51.2024.04.05.08.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 08:26:05 -0700 (PDT)
Date: Fri, 5 Apr 2024 17:26:04 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>, 
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/5] Add parsing for Zimop ISA extension
Message-ID: <20240405-091c6c174f023d74b434059d@orel>
References: <20240404103254.1752834-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240404103254.1752834-1-cleger@rivosinc.com>

On Thu, Apr 04, 2024 at 12:32:46PM +0200, Clément Léger wrote:
> The Zimop ISA extension was ratified recently. This series adds support
> for parsing it from riscv,isa, hwprobe export and kvm support for
> Guest/VM.

I'm not sure we need this. Zimop by itself isn't useful, so I don't know
if we need to advertise it at all. When an extension comes along that
redefines some MOPs, then we'll advertise that extension, but the fact
Zimop is used for that extension is really just an implementation detail.

Thanks,
drew

> 
> Clément Léger (5):
>   dt-bindings: riscv: add Zimop ISA extension description
>   riscv: add ISA extension parsing for Zimop
>   riscv: hwprobe: export Zimop ISA extension
>   RISC-V: KVM: Allow Zimop extension for Guest/VM
>   KVM: riscv: selftests: Add Zimop extension to get-reg-list test
> 
>  Documentation/arch/riscv/hwprobe.rst                    | 4 ++++
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 5 +++++
>  arch/riscv/include/asm/hwcap.h                          | 1 +
>  arch/riscv/include/uapi/asm/hwprobe.h                   | 1 +
>  arch/riscv/include/uapi/asm/kvm.h                       | 1 +
>  arch/riscv/kernel/cpufeature.c                          | 1 +
>  arch/riscv/kernel/sys_hwprobe.c                         | 1 +
>  arch/riscv/kvm/vcpu_onereg.c                            | 2 ++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c        | 4 ++++
>  9 files changed, 20 insertions(+)
> 
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

