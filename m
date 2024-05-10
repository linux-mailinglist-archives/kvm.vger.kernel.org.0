Return-Path: <kvm+bounces-17190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6DB8C27D8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8815F287F67
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC235176FA1;
	Fri, 10 May 2024 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jjAbYPIL"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55410171672
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715354909; cv=none; b=YZWRpuWDmjxADGj62B12f2uuB9Loldx62rDmo29/OMg+N7+frPpHh5+S4m3NO6byHLnRTeerqQBaYlP+qiWK79zFCGdnMKuLHPOW9HZw0ERGAPGieTo+AXjkxcBsfBQ/BGAKNlz7dxat6Nz3fjRkLAOz51yp9AuA6qDO3fxiT84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715354909; c=relaxed/simple;
	bh=ws7Iokhl9E1h03uSqTNAIMjmdKKnyVrK2rs70qYdhK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5x7H8HPjuDXUQ+Sdl8Ivpk0FVEqlbKdvca2uYhTIGwnKYTGPpatRmjdmXh57x41LlxNyy1jDbffwmGInUnzfnfgLnEwJYJbbHzBT8fn+ryyTXiwvOTzT39XZeNSoKM8L5rNrBIbpUFJxdpOqawYrnouad3vQ12Zd2JUonMPtwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jjAbYPIL; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 10 May 2024 17:28:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715354905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q7zlmbOxYaCUaA6KiEDvnaYhEN7MXQAn/SNUNpeRloc=;
	b=jjAbYPILFLqBzFRHxjKGiPy8Euiw86a9SEaZ7kNFRZMn9PyQ9iuRmy6ldKVw1Ld4rYCjpH
	8UuvEoiQ0KKo6AZD7/YBGAzuJs62TDzGmyYDFyV+to3RrA/bWuRVmcp8Q5CYJZDR5pJJFM
	yCH5+f9h69klVNudqPOp1WWNVbQ5E3I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com, james.morse@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, 
	Subhasish Ghosh <subhasish.ghosh@arm.com>
Subject: Re: [kvm-unit-tests PATCH 18/33] arm: realm: Add test for FPU/SIMD
 context save/restore
Message-ID: <20240510-7e7f794ddf51316b15b57113@orel>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <20240412103408.2706058-19-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412103408.2706058-19-suzuki.poulose@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 12, 2024 at 11:33:53AM GMT, Suzuki K Poulose wrote:
> From: Subhasish Ghosh <subhasish.ghosh@arm.com>
> 
> Test that the FPU/SIMD registers are saved and restored correctly when
> context switching CPUs.
> 
> In order to test fpu/simd functionality, we need to make sure that
> kvm-unit-tests doesn't generate code that uses the fpu registers, as that
> might interfere with the test results. Thus make sure we compile the tests
> with -mgeneral-regs-only.
> 
> Signed-off-by: Subhasish Ghosh <subhasish.ghosh@arm.com>
> [ Added SVE register tests ]
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arm/Makefile.arm64        |   9 +
>  arm/cstart64.S            |   1 +
>  arm/fpu.c                 | 424 ++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg         |   8 +
>  lib/arm64/asm/processor.h |  26 +++
>  lib/arm64/asm/sysreg.h    |   7 +
>  6 files changed, 475 insertions(+)
>  create mode 100644 arm/fpu.c

When I build and run this test with EFI I get an SVE exception.

./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
qemu-system-aarch64 -nodefaults \
	-machine virt -accel tcg -cpu max \
	-display none -serial stdio \
	-kernel arm/fpu.efi -append fpu.efi \
	-bios /usr/share/edk2/aarch64/QEMU_EFI.silent.fd \
	-smp 2 -machine acpi=off

UEFI firmware (version edk2-20230524-3.fc38 built at 00:00:00 on Jun 26 2023)
...

Address of image is: 0x43cfd000
PASS: fpu: FPU/SIMD register save/restore mask: 0xffffffff
PASS: fpu: FPU/SIMD register save/restore mask: 0xffffffff
Load address: 43cfd000
PC: 43d0b4e4 PC offset: e4e4
Unhandled exception ec=0x19 (SVE)
Vector: 4 (el1h_sync)
ESR_EL1:         66000000, ec=0x19 (SVE)
FAR_EL1: 0000000000000000 (not valid)
Exception frame registers:
pc : [<0000000043d0b4e4>] lr : [<0000000043d0b4d8>] pstate: 000002c5
sp : 0000000043d2bec0
x29: 0000000043d2bec0 x28: 0000000043d2bf58 
x27: 0000000043d2bf60 x26: 0000000043d2bf68 
x25: 0000000043d2bf70 x24: 8000000000000002 
x23: 0000000043d2bf88 x22: 0000000000000000 
x21: 000000004661b898 x20: 0000000043d2bfa8 
x19: 0000000043d38e60 x18: 0000000000000000 
x17: 00000000ffffa6ab x16: 0000000043d07780 
x15: 0000000000000000 x14: 0000000000000010 
x13: 0000000043d0d4b0 x12: 000000000000000f 
x11: 0000000000000004 x10: 0000000000000066 
x9 : 0000000000000066 x8 : 0000000043d3abf0 
x7 : 0000000000000080 x6 : 0000000000000040 
x5 : 0000000000003bce x4 : 0000000000043cfd 
x3 : 0000000040101000 x2 : 0000000000040105 
x1 : 0000000000000040 x0 : 1301001120110022 

	STACK: @e4e4 752c 1050

EXIT: STATUS=127


Thanks,
drew

