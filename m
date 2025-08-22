Return-Path: <kvm+bounces-55439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 312EFB30A02
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 02:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A81742A03F4
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D71A28EB;
	Fri, 22 Aug 2025 00:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JT73iF4r"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7FD1B808
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755820936; cv=none; b=BphL2OhvCwh2XmHyZ6/FtSFsOWtomWqzUvS/4iRGCpuOfzcA9v19Wagksr/GKe/fsYuRumymvQ7aJvaK9yDYxZ7tBhVtyUZVLAURYrYuzt1V8gMR7mtv1EQPtuw+Dx70Gdz2WlWU075pIUYfrI2pIeLD1oOKgQeiyzPoPJ9orFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755820936; c=relaxed/simple;
	bh=R6gkMxCHMB3bEPIOgtU0MGTgtQA11whemnMGltciFGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBb/5enZUZUyzPWAuXMvYpOx5LuigV9BBKuf/B1TOGShXiIAZvuENTF7VE/ddPRKqY8dALGFc53s+fj7beqHbT8HEGVDrruW1Ld6oxLEmJ0t7Ig/8n7bme6tLcmJ55THU2s6g/7zGoT6IpCRW4uC58rA0BQR93/4IBJfsfjCQcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JT73iF4r; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755820931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucW5TqvXSFl4ARAEgmgO1++0Jhipt96vounQfr6Zybo=;
	b=JT73iF4rjnd4Iy29P/fnGsFVmZ0yBnBwk5yn05z2bblCN/Z9ixfOS9rERLTbPQvUMP/DCq
	W6QZBWJwRk6XAT0CHe4j+jLmYlyion1XoXC8E1WyOpJaG/nlXm1DBvApM7Y4iJblp3V/bm
	v/xo5pRaZktkHiPEVv4RxstIblUeIjY=
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v3 0/6] KVM: arm64: FEAT_RASv1p1 support and RAS selection
Date: Thu, 21 Aug 2025 17:01:59 -0700
Message-Id: <175582091318.1266576.11766063075536898345.b4-ty@linux.dev>
In-Reply-To: <20250817202158.395078-1-maz@kernel.org>
References: <20250817202158.395078-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 17 Aug 2025 21:21:52 +0100, Marc Zyngier wrote:
> This is the next iteration of this series trying to plug some of our
> RAS holes (no pun intended...). See [1] for the original series.
> 
> The difference with the previous drop is that we don't try to expose a
> canonical encoding RASv1p1. Which means you must migrate between
> similar implementations for now.
> 
> [...]

Applied to fixes, thanks!

[1/6] arm64: Add capability denoting FEAT_RASv1p1
      https://git.kernel.org/kvmarm/kvmarm/c/8049164653c6
[2/6] KVM: arm64: Handle RASv1p1 registers
      https://git.kernel.org/kvmarm/kvmarm/c/d7b3e23f945b
[3/6] KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
      https://git.kernel.org/kvmarm/kvmarm/c/9049fb1227a2
[4/6] KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
      https://git.kernel.org/kvmarm/kvmarm/c/1fab657cb2a0
[5/6] KVM: arm64: Make ID_AA64PFR1_EL1.RAS_frac writable
      https://git.kernel.org/kvmarm/kvmarm/c/7a765aa88e34
[6/6] KVM: arm64: Get rid of ARM64_FEATURE_MASK()
      https://git.kernel.org/kvmarm/kvmarm/c/0843e0ced338

--
Best,
Oliver

