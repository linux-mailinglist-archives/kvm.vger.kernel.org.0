Return-Path: <kvm+bounces-20919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 628A1926C69
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 01:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936201C210E0
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 23:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F6F194A43;
	Wed,  3 Jul 2024 23:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j3RO1CEO"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7ED17838D
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 23:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049173; cv=none; b=idaAqwixLi3PD+9WgQoJgfazDgOpTW/wE4Ks7qTS7Xv7zLlO78pqseCenyOaj3yAngUmIewTomZOdNOVJDoRoNbxdHGhPSZDEPkfBMdSZlo23wgiXJuWr3Wx5cRJ5tkFCxv9jkvjnwC9kLjp5x2A56AZuk+lJA3iaOh98gXaA5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049173; c=relaxed/simple;
	bh=J8ZytsHv/eiIugqmuZNx1f9UJ1w/St+hFYhzQlfKsO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTZMG6CmA0uWokvkHw/Z6dhZ4bCMOTRLJSghc3HxQ7Qyu02c8eH/QoL1j5NEaQBKOnLWAoSW3nf84I2Y85rKN60ejfYBZczgw38JqviwyCGeTFryWqwO0Jv6sEgtG2mGC7t7zZ97Xyj7RI7ACnJ31Y3q3pf/wIddDDiH1wtGdvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j3RO1CEO; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvm@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720049170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tcq0ZOKXKwseUjH1zgxoSvLVWz7sVlSTBdvlYKuy7So=;
	b=j3RO1CEOknLlNqRoQuOoFPjR3HfDohNi09ZJdGWuf1Mo7IwlihYRhPpb6wkv1qGuN5Zc3o
	Qz0OXviSNGkBWHGUPXLjj8jCf4PfDhwW8V3qGPGTvwR9XSESpsPnqAHFLZplQLLzkorbFy
	A5ikl1wEzaOifuyt7AO4PjyI2lZ9yaQ=
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: maz@kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Truely enable nXS TLBI operations
Date: Wed,  3 Jul 2024 23:25:54 +0000
Message-ID: <172004909841.2946123.11548804717263824415.b4-ty@linux.dev>
In-Reply-To: <20240703154743.824824-1-maz@kernel.org>
References: <20240703154743.824824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 3 Jul 2024 16:47:43 +0100, Marc Zyngier wrote:
> Although we now have support for nXS-flavoured TLBI instructions,
> we still don't expose the feature to the guest thanks to a mixture
> of misleading comment and use of a bunch of magic values.
> 
> Fix the comment and correctly express the masking of LS64, which
> is enough to expose nXS to the world. Not that anyone cares...
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: nv: Truely enable nXS TLBI operations
      https://git.kernel.org/kvmarm/kvmarm/c/3cfde36df7ab

--
Best,
Oliver

