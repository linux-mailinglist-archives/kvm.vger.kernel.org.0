Return-Path: <kvm+bounces-24667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB73958FE9
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 23:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 426E11F23380
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 21:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C27318B467;
	Tue, 20 Aug 2024 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bVLhXX6A"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629DD1C7B65
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 21:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190401; cv=none; b=Ut71tQJsydcvjl393cQ15dnOJkE15eSVA8OVXjoOakTMPNyPQ/uvGdGIr1AaI6hwFf1J6LX24U6zrvtX3T8DR7wUPXwTM7s9tP/UV6x0UXScPhgSFTnPkOY8PHcE0qF5YDwarOYJfXYQZjB5cJ5tTvJ+KnZueq02x0Db+clm1QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190401; c=relaxed/simple;
	bh=qLb0yN4NqnbyBII1d2B+3lYvrB94iEo9uUhFRuL55zI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DmgOCJT+OImuykLJw1stMPFCJ/W3hww3IuV3Kl/8yEY1+Lfe7q7kk1moqCYbItxKfbMu2c1g4Mkskbo+e9wocvTtPlTrs0z9AbCej8BziNVCwMf7TVALxfupbkZ6TZ+xTge1AhaqtgbwXh/plJ8Smi1SRvODlebDzNmnmWTlgsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bVLhXX6A; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 20 Aug 2024 14:46:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724190396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H5Wfc7SpUB43gQpOzvYVCumAuS/D3QJGlE7NYs8JIZw=;
	b=bVLhXX6ACG+AY083jKB2/YB67GL6xAZr+SctARVwqeTMLpzBMAOsbVM3WfbSqm6zh4r76g
	mUOj8v69L8QwaHRe/MwKm2OIxiAjn57MgwvJeITtSabcZPct2IubEQED4HP0TiUhukeenb
	+Ke9R7UHP+O8lmiVp5iK3gTnBhrf2nk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the
 absence of a vGICv3
Message-ID: <ZsUOtp9kfpqm1enx@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820100349.3544850-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 20, 2024 at 11:03:38AM +0100, Marc Zyngier wrote:
> On a system with a GICv3, if a guest hasn't been configured with
> GICv3 and that the host is not capable of GICv2 emulation,
> a write to any of the ICC_*SGI*_EL1 registers is trapped to EL2.
> 
> We therefore try to emulate the SGI access, only to hit a NULL
> pointer as no private interrupt is allocated (no GIC, remember?).
> 
> The obvious fix is to give the guest what it deserves, in the
> shape of a UNDEF exception.
> 
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

LGTM, and just as an FYI I do plan on grabbing this for 6.11

-- 
Thanks,
Oliver

