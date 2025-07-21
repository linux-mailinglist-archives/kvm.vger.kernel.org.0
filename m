Return-Path: <kvm+bounces-53040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42AE7B0CD44
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 00:25:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CFB6542588
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 22:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD6724169A;
	Mon, 21 Jul 2025 22:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MfLqUbtl"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F14721CC43
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753136710; cv=none; b=PXtssEwJSUheaNJHOUPyVU0a7JD9G4m9O8P9TPm+l582s4UBAjz4HWYjntfCqhD568NqW7Kn8Ys46qNyBmtgx3UnEmsaMLz5HBeRntYcsDOzwylBsYTH+fSvmjfI7267SGOkDAquDbBP8R0w0yVaQy98jlVFHFo9uB/as1CUeJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753136710; c=relaxed/simple;
	bh=CM4FfxQMwGrmSe4Wmcz2SbeLnqycl8bMpDZXmXIx9Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuPb4ky7BGGTREKoV8hRHv9xUf1MCJVzzQPmftQUdq6K+tp+GoOncKdDz1X5JT0/EIyn4Y1vg6d5AxQKqr1HhHPvGmBwtS1fqjS/49DGkEoyPuRoNLG+muyM+m598459VdgMJoSOF8SK04CQ4FxsTDD+F3eh6rvofYO2n73WqBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MfLqUbtl; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753136696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6h0Y/vUQmTbtoADLUGCwDI72dzoGASBmyiGNAfF51R4=;
	b=MfLqUbtlhwAYv0liHJSXD0gXHU4lVULzmtS+CvpD5osa3CNSR9orcz561bZvDpoqfIqZ9i
	9/CuHFWEv+dtKm3rf5T6c5p5Z1tBsW9ykVmDSo68SxwZOlZp1gVJRMW/Jd7t7C8D2TLJET
	GI/QPwJ/m58FwDO00A1JdRoLH/OhtiM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: (subset) [PATCH 0/7] KVM: arm64: FEAT_RASv1p1 support and RAS selection
Date: Mon, 21 Jul 2025 15:24:44 -0700
Message-Id: <175313657130.2592298.13962133220387248424.b4-ty@linux.dev>
In-Reply-To: <20250721101955.535159-1-maz@kernel.org>
References: <20250721101955.535159-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 21 Jul 2025 11:19:48 +0100, Marc Zyngier wrote:
> As I was debugging some RAS-related issues[1], I realised that:
> 
> - My test box is implementing RASv1p1
> 
> - We unconditionally advertise it to guests
> 
> - Issuing RASv1p1 accesses doesn't end very well
> 
> [...]

I haven't reviewed this series in full yet but wanted to pick up the
HCR fix that we need urgently and the obvious FEAT_RAS change.

Applied to next, thanks!

[2/7] KVM: arm64: Filter out HCR_EL2 bits when running in hypervisor context
      https://git.kernel.org/kvmarm/kvmarm/c/303084ad1276
[3/7] KVM: arm64: Make RAS registers UNDEF when RAS isn't advertised
      https://git.kernel.org/kvmarm/kvmarm/c/d9c5c2320156

--
Best,
Oliver

