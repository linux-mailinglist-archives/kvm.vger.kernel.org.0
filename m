Return-Path: <kvm+bounces-23643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86ACA94C356
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 19:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 434FC281FD7
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC2D19066F;
	Thu,  8 Aug 2024 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b6N7k662"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF23D1F19A
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136827; cv=none; b=WBXe89/leLtXyQkysrUUUEi8NgW9f0RFVcWf5OVX8AnoopQomsLgaruTAMrqquakjGGuqW2Vk9wGUiJtvgMc0k6NkEoI8AQbn7zng45NSIOEcnGvYqIcxXHw3HQbxQh0EqCZpzDPVFQ7Li4yw9ArgbTK+6A48zfIJWW8KtpjsFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136827; c=relaxed/simple;
	bh=wnnu8Q6cMNXH1tynrcuGDrfrzw6D3kepdyhA4VQ9cKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KUNKfRVEh8zPU6/sy0CqNt1ac1/umu6SO0yGQzrmVE6wUTp//V31cTdVLIwfZPBcHpP1xFnGa8YeuAYCe6Mf/z9tIl92c/AO+8SoKrWHuMS8/D83fiH5SzoD3jCA5Kv8BaHjgsVKy9tU+EbzWnYhIy5ZzDKSdiu22kCWqsj051U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b6N7k662; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723136822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=72x7LfG3DZtMAgfypwYZrBFFEaH3rSmVlC13ZuKpaLc=;
	b=b6N7k662kRIEC6Rl/2Osnf3aXfK1SX/7EGPpOotarpbx5FA+Klle3FlbwieMahLhhadw+x
	jcXlw1CdNXbXQ0BAKTtRxB+XRmy8O4QYSWQbTSd7b0uka1LwbXfCbVB40rUyLqhdYzFOyX
	0lFYE7fTlbtjnjd0sMSKiaZ20rTO9+k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
Date: Thu,  8 Aug 2024 17:06:30 +0000
Message-ID: <172313677515.561165.4109734932636662415.b4-ty@linux.dev>
In-Reply-To: <20240807115144.3237260-1-maz@kernel.org>
References: <20240807115144.3237260-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 7 Aug 2024 12:51:44 +0100, Marc Zyngier wrote:
> With the NV support of TLBI-range operations, KVM makes use of
> instructions that are only supported by binutils versions >= 2.30.
> 
> This breaks the build for very old toolchains.
> 
> Make KVM support conditional on having ARMv8.4 support in the
> assembler, side-stepping the issue.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
      https://git.kernel.org/kvmarm/kvmarm/c/10f2ad032def

--
Best,
Oliver

