Return-Path: <kvm+bounces-54804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F16B28615
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 20:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E210D56431B
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 18:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA442F9C2D;
	Fri, 15 Aug 2025 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="baJlH9tO"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC322F9C35
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 18:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755283981; cv=none; b=oTJkwb4mfZolpASA9//ydYI1vjtedWYrdRnduylkUSGBnB4veSFwYUdrogySjVlhKSoX23CTJfa+zDU0CM8oUM1KVNMl24AVDxg24GKE3CDuDtOEBMneFbvyB29YlBuv+ZTHSTyVckZ3kxkKIm4xB7Usdw7ihO8q3ddcNAz8/GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755283981; c=relaxed/simple;
	bh=yy100eIycRYfQ+GHhchXeEuZF4KDvur6SJ6JEyimJZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvU4t3FEYjk5foqckshyMQUKSxzXq1lsKaqi4TJzSLNY8qHbX5c0AICPCde1AGkX4iSWPKTSOYjlzWVp1zdJocqUcT1Unf7mU4nxyaght59Kul4RSS3rKw2vuRasY2JUEpNmuQ5I9itZIFKcnvx8Fdf83jovXQ52uRKMVwz1sD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=baJlH9tO; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755283967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UQnrvh8fmmyw5mye4l3ThIw5bAHTdjRGTFjcTvSf2X4=;
	b=baJlH9tOVl/5B3c1jvUHXPDwLuEj7u1V4YReehcCH9W7Lyv4ukNVCxHgPfx5lLC5AgfOqo
	vLCSPJK8wMju85aVdnjOnsvbRw/kDnCh2Q7yLkE5fyaGS4Kn7QTtha5jeJE/OHjBgvknA4
	w5B58ztz22/Qg9zSajyFJl/yekRpOGc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Correctly populate FAR_EL2 on nested SEA injection
Date: Fri, 15 Aug 2025 11:52:33 -0700
Message-Id: <175528391095.1010493.11054501106078213907.b4-ty@linux.dev>
In-Reply-To: <20250813163747.2591317-1-maz@kernel.org>
References: <20250813163747.2591317-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 13 Aug 2025 17:37:47 +0100, Marc Zyngier wrote:
> vcoy_write_sys_reg()'s signature is not totally obvious, and it
> is rather easy to write something that looks correct, except that...
> Oh wait...
> 
> Swap addr and FAR_EL2 to restore some sanity in the nested SEA
> department.
> 
> [...]

Sorry I didn't pick this up immediately, had to find my brown bag...

With the typo addressed: applied to fixes, thanks!

[1/1] KVM: arm64: Correctly populate FAR_EL2 on nested SEA injection
      https://git.kernel.org/kvmarm/kvmarm/c/d19c541d269e

--
Best,
Oliver

