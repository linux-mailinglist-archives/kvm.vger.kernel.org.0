Return-Path: <kvm+bounces-8570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5376D851C6B
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 19:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 088CE282E23
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 18:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1FC3F9FD;
	Mon, 12 Feb 2024 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IOMZJLh9"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8445B3F9E6
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707761161; cv=none; b=EB90JqFuRoT2cLRMNaFvYCwpXEaiDxXzTtJzNMBsolDIp8Q7aNECHKjp48gz/BJZMH4MxYSdCj1hpQsdIL6wuOCLJremOqyyG7OUk8h96RWJu5Y9l/Ce5otb5RNbRgp2UdCZMbwJxPWBZ0cB994YuARHh/zf3OmljuzOjGaBkFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707761161; c=relaxed/simple;
	bh=Bgr4GvMQac6syWW4micE3Z/3TOPNn4+EOekg2y6fOTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SV2JuTgMJDjy8hdN3sOBekMfgy0F6L32JCZGQpb0I9TNd8S7emeRP/FHynFd6FlcYy8HZ64vND3nuJ7BFKL/nO27mxYLaluIuYHSoOfo5xUzCoRWwn46kBMOttrck7pbW8HRFSedb1HfCzNofGvMeHmZXatIBXDthPNc17gXLlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IOMZJLh9; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707761156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wb/muvq9ooz4eM0Ys3tybUTyrCipON3+4mc5fnC8K+k=;
	b=IOMZJLh984nJOGuhIzI6uGRNioUDClVj2rS2P6IP8K4CPboJa1TS/xSeAkv7fFSijXnOuW
	jk4f79jv7yXezZx9p2+cBPomUX5SYiOCGXGxfU+sD1iyBFJIsWQc0Mi18gxMPh6qrlN+AV
	uVAyr72gFfjrLi0xgarSQoIkagZ1DqM=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/2] ARM64: Fixes for FEAT_E2H0 handling
Date: Mon, 12 Feb 2024 18:05:42 +0000
Message-ID: <170776111436.2280274.3289030811512349732.b4-ty@linux.dev>
In-Reply-To: <20240212144736.1933112-1-maz@kernel.org>
References: <20240212144736.1933112-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 12 Feb 2024 14:47:34 +0000, Marc Zyngier wrote:
> As the FEAT_E2H0 handling series has made it to -next, some of its
> shortcomings are becoming apparent:
> 
> - A missing ID register in __read_sysreg_by_encoding() is causing CPU
>   hotplug to explode (reported by Marek)
> 
> - NV1 is getting advertised on HW that doesn't have FEAT_NV, which is
>   fairly harmless, but still annoying
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] arm64: cpufeatures: Add missing ID_AA64MMFR4_EL1 to __read_sysreg_by_encoding()
      https://git.kernel.org/kvmarm/kvmarm/c/87b8cf2387c5
[2/2] arm64: cpufeatures: Only check for NV1 if NV is present
      https://git.kernel.org/kvmarm/kvmarm/c/3673d01a2f55

--
Best,
Oliver

