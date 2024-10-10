Return-Path: <kvm+bounces-28374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5266B997FD3
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE1661F25000
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA5C1FEFC3;
	Thu, 10 Oct 2024 07:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MtHHMJLZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10B71BD503
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 07:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546785; cv=none; b=aePzJ1VKFIiVr47iVXpHgF+Q3q6PeJBksnyJ/rJTO9G0lVQ9dDhsNSaiSM2dchEqc69pLqBbygwqtO6A/OSwxyAr021DllEs8J3v03zp/9FP/QvVKiF2/vr+ruXZOq88vKzH/arxtBqrD3vh6XQk8NeSMGsHeI3ai2kbITVTFSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546785; c=relaxed/simple;
	bh=z8FV4Es0U6FwRarAxT8diH/adkZ8zSz5W1oFKmc0Uyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1aA3Sr3KT8a2vLdXQ8zHotNADA/dXCRhtNcXJ8Ey+9TusRc9Xs6bT0O5y3V95q+nnDvcok3a0WjBAuVGmHJM5UFgv8vcFcDo7fKgHirYHgxEvdQTfoneAKzoxtc1CZNZUzrQM5KUPyw3Ii4hQHu5kLpkfsAhFr+D5zI2u054SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MtHHMJLZ; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 10 Oct 2024 00:52:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728546780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZPf8gJqlrSlWlBTitKItaEuQMUuQitef5n6GBtWdWo=;
	b=MtHHMJLZbjGSVLABFJUOta8yqdBuXJi4Yjg8/9a6OKwbX4IDUvljT7NttUYNzOG3VG8QhF
	mj5Mc0YdJv7g5M1/ssiXiM9ou28Ls2NOaiLj10BgAi2qMPgL7ApBsw32qYCzI1CSkbwa8T
	QHTbqotJ+Ta+3lTihyHtynjSacUWUa0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 27/36] KVM: arm64: Add a composite EL2 visibility
 helper
Message-ID: <ZweH1OXhi6vKr4ab@linux.dev>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-28-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-28-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 08:00:10PM +0100, Marc Zyngier wrote:
> We are starting to have a bunch of visibility helpers checking
> for EL2 + something else, and we are going to add more.
> 
> Simplify things somehow by introducing a helper that implement
> extractly that by taking a visibility helper as a parameter,
> and convert the existing ones to that.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

nit: avoid churn and order this before introducing more open-coded
instances of EL2 + FEAT_something checks.

-- 
Thanks,
Oliver

