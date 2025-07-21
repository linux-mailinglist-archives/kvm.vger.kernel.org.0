Return-Path: <kvm+bounces-53039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 326E9B0CD42
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 00:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 623235426B5
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 22:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4520524290B;
	Mon, 21 Jul 2025 22:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HZptrzZr"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987DF23C8D3
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 22:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753136702; cv=none; b=X6FnGoNMp3Cwl9ZReiXDSdqNtpq9i2gzsNE1JTAipMMcDGL7lwg9dVevKAgqrt0jcjGMPCH/RwbgUGBXTs3HGuTD0YCul7v73L1uMrPG1PESe849cnvTG/lHE4kQNoK8l6Z28+2/cNPZ6ErOjr/ngqPzgkd/ojBORXD9oO/bclc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753136702; c=relaxed/simple;
	bh=F+ws2eLWfD2NkWojYPpMSKKKu95g8Nt03OBK7Uspbo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h69T9M3JfqbcbqUQCn0kLUKVMfHrLkvMSlVN9N3uRM7BQZ4pspv9ANPvXdJodw+57HxpHjxfOouNPRnNiyjjLgyC5WPbdm+skqcKdoTBpEfOHBItPkT0d1Krl2tbnz/SPlKYDU5trqd8Qur1xhSZWkaJLxYCbqscCwWM2o+lsX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HZptrzZr; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753136698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0Swdc+rgZd6RYXOhWJTdQCOj/YJAeib/YMEr/j+xKM=;
	b=HZptrzZrIHb7zDppmEpiXbGBgqebupTQ8pylKpzfG1WZ/EjdDd5SeiMXYBLDklKXGyITLi
	8X+IcIKCMWgDj89IagWjCFxQnHacJ7CT8bZBk2TkoyPreH7B9QssECZFafwEcr3k17Kf+d
	b0IyMm2aybdhaf6d8GJ8DTu8aeKfnxQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
Date: Mon, 21 Jul 2025 15:24:45 -0700
Message-Id: <175313657127.2592298.3949452294355380877.b4-ty@linux.dev>
In-Reply-To: <20250720102229.179114-1-maz@kernel.org>
References: <20250720102229.179114-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 20 Jul 2025 11:22:29 +0100, Marc Zyngier wrote:
> Mark Brown reports that since we commit to making exceptions
> visible without the vcpu being loaded, the external abort selftest
> fails.
> 
> Upon investigation, it turns out that the code that makes registers
> affected by an exception visible to the guest is completely broken
> on VHE, as we don't check whether the system registers are loaded
> on the CPU at this point. We managed to get away with this so far,
> but that's obviously as bad as it gets,
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
      https://git.kernel.org/kvmarm/kvmarm/c/c6e35dff58d3

--
Best,
Oliver

