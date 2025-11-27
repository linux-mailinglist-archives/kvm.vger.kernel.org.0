Return-Path: <kvm+bounces-64859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F957C8DAD8
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 11:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D506E34E307
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 10:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD6E2FE04C;
	Thu, 27 Nov 2025 10:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dK/m/r54"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C03EC13B
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 10:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764237892; cv=none; b=cGtQ8xqdxEPvRxgPDaA64cNJo64OaeV970x0KW0wvUMQQxrDgt5u37TgT82RhTQpUPoavhcApHO/+cza2VkYT691f/kvheNiKdhtvhIUPjZ6rwnYBZPy5LuHcFrIbIo2xHfRY/ZE4ipGB7gmcylpiWW9mlIStuCp4MYM99ugis8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764237892; c=relaxed/simple;
	bh=W7PJmEg+ySd6bSUClx93pUrJNIPJakZuzB+lUeIQ6+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PbDTg1tDkskJ4pJLUluTwliX61g/UlRH1uwROBBr41+7ZOTBGj7mjlqmHMwTo+Dmp5CMbTx6XyL0JUx9DJNkJj/7kfb1tIHJq3djTbs93YfEjJ6UqIZ7pXnRAMRCJgMYDZViM7qplDQjAZ6YTuPGt3FfOt+1lHav5NSC+oYt1Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dK/m/r54; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764237889;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QHU1dfEDnDJW+SngUG/WWslLp6yHfhX1XyYXZAm53gw=;
	b=dK/m/r54nBvVt3iSg0kdxwrMfITLulMk/hZ3jOz9UPQwRQkjUIY+fjGJLYWfSPJO+HNM2o
	R7UilHT5+lBU8NhcD9xYiTi1GHyLWVI/Imo4c4uI4AKWSfXfE66rw0JQdAZMNeFrZo8jG0
	Zp4Sc8HUKYd/HLXxBvfBTlHd9GT9iHc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-uem07KjEMw2GX6XnWvNo5Q-1; Thu, 27 Nov 2025 05:04:47 -0500
X-MC-Unique: uem07KjEMw2GX6XnWvNo5Q-1
X-Mimecast-MFC-AGG-ID: uem07KjEMw2GX6XnWvNo5Q_1764237886
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ee16c5a681so8803781cf.1
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 02:04:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764237886; x=1764842686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHU1dfEDnDJW+SngUG/WWslLp6yHfhX1XyYXZAm53gw=;
        b=SjH4FYmhXF1zsvVwSxlYljTxrwyflOASmr44iVvZ23pxF2QMCaFkEwlmoPySapX23W
         LLMW6xtF6+w4qU2pLCh8+UlMZJa3XwZJAMkwnWBZmdZINuoWnEbWcnjYBqsaU2xpiiij
         6kTe8DZUejHrxTEz5RYLjw0juXV1KWBrYHh67HR6BXRAHf+W4EiRdjUigj0Fw/LKJWlY
         h5ulpOaT9Xq6mZBfumebrgTnycEVmzATd04xYbbSii3TnC6nkTGqeMYinOaI/Ye8sRk1
         mdVvMI7Hl8LmfRqvb5K3Z4zD0vK5sSO6CeYZjiga9k5p0d/tyQwDPRD3LWmhapSW3qpf
         ZrIg==
X-Forwarded-Encrypted: i=1; AJvYcCXOWwbfJYlXz+6pAz+OyWDyCimxCnicEpZ8CQ/zZsQbT0C1A1BaOt95Yi/kAS0RUvNtLqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzHsMQSVLu/dSEfYdFXCMtfYSrzmp7ihKH+ouKuo7gKVWBnmZ9
	yRt9DiWxIo0fxQfM9SWohO5YWGissHu6BU8K6qdMuhBkgR+xe93X2G1T0yjNFsKJfeWcNNHFECl
	fXetAiaXocgYncrlzmgSVe17ppcLVThx/Iu6qE3uDZsqBfenoFq8NKQ==
X-Gm-Gg: ASbGncsatW9Mkf+QBOHGnoakaah0WGPJrk/prCJdvmYRhs3a6/lqXyWp3rkBiGrpHCI
	K1jWaOt79L+sT3n8iisUs/OaD0w2Md/j5NyyS50dLA0Rb1NeqUh8sO9Vq9aJoXwDFTPTux24GPr
	nxJP5HGMpln/SXKD17ELzArrk376kzow7Z1199JXUY+Lpa1EfCZhHTSYuCzkt2xvVTdFsfx/l9h
	/kleOas8I1vKjx+1z088iNhO+0njjVAz8q86cZqpzrAW9lc2oENs3QdVJfYwzh85FkDgvin7gwg
	B7b3xzD6kGpXXMx+PlBCyxMFyKtBCH8fay5UDyVe5iXfA9eRvgcXxuTGh1QvmK3p4f71usizE/O
	t3232ex9nYaYuqesWElZehTs3uIktfKtLVaSz8ZZSoULEPPx/wcCW8Ccf5A==
X-Received: by 2002:a05:622a:64d:b0:4ee:1f5b:73c3 with SMTP id d75a77b69052e-4efbdafae82mr136566641cf.60.1764237886568;
        Thu, 27 Nov 2025 02:04:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMNAI9vR0jwzy4e6ezn9h7hQWLE/WyRaFVqDnCXyvdwThkgiaIPE3CdjzdXtnP1MyZ3AN9LQ==
X-Received: by 2002:a05:622a:64d:b0:4ee:1f5b:73c3 with SMTP id d75a77b69052e-4efbdafae82mr136566411cf.60.1764237886178;
        Thu, 27 Nov 2025 02:04:46 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd34224bdsm6316801cf.19.2025.11.27.02.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 02:04:45 -0800 (PST)
Message-ID: <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
Date: Thu, 27 Nov 2025 11:04:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> Hi all,
>
> This series is for adding support to running the kvm-unit-tests at EL2. These
> have been tested with Linux 6.17-rc6 KVM nested virt.
>
> This latest round I also tested using the run_tests.sh script with QEMU TCG,
> running at EL2.
>
> The goal is to later extend and add new tests for Nested Virtualisation,
> however they should also work with bare metal as well.
>
> Changes since v2[1]:
> 	- Move the sctlr setup in EFI to a function.
> 	- Decided to not re-use el2_setup.h from Linux, looked more
> 	  complicated to use than needed for KUT.
> 	- Add EL2 env variable for testing, open to feedback for that.
> 	  This was untested with kvmtool as my testing setup only has
> 	  busybox ash currently, and the run_tests.sh script needs bash.
>
> Issues (that I think are fine to investigate/fix later):
> 	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
> 	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.

Have you noticed any failure with migration tests. On my end, as soon as
I set EL2=1 migration tests do fail.

Eric
>
> Thanks,
> Joey
>
> [1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/
>
> Alexandru Elisei (2):
>   arm64: micro-bench: use smc when at EL2
>   arm64: selftest: update test for running at EL2
>
> Joey Gouly (8):
>   arm64: drop to EL1 if booted at EL2
>   arm64: efi: initialise SCTLR_ELx fully
>   arm64: efi: initialise the EL
>   arm64: timer: use hypervisor timers when at EL2
>   arm64: micro-bench: fix timer IRQ
>   arm64: pmu: count EL2 cycles
>   arm64: run at EL2 if supported
>   arm64: add EL2 environment variable
>
>  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
>  arm/efi/crt0-efi-aarch64.S |  5 ++++
>  arm/micro-bench.c          | 26 ++++++++++++++++--
>  arm/pmu.c                  | 13 ++++++---
>  arm/run                    |  7 +++++
>  arm/selftest.c             | 18 ++++++++----
>  arm/timer.c                | 10 +++++--
>  lib/acpi.h                 |  2 ++
>  lib/arm/asm/setup.h        |  8 ++++++
>  lib/arm/asm/timer.h        | 11 ++++++++
>  lib/arm/setup.c            |  4 +++
>  lib/arm/timer.c            | 19 +++++++++++--
>  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
>  lib/arm64/processor.c      | 12 ++++++++
>  14 files changed, 191 insertions(+), 19 deletions(-)
>


