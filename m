Return-Path: <kvm+bounces-20325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B561C913590
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 20:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F5D8B21E2F
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 18:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DBA72D60A;
	Sat, 22 Jun 2024 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q3Z7g/Zr"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8E917C69
	for <kvm@vger.kernel.org>; Sat, 22 Jun 2024 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719079887; cv=none; b=VgybU0er71akbAKArTibSXndbC6SnFVsbGGSIo7JyYIhCqfbLTVoJYett8evqEk61AkXTsqthSDPQylOFqGUneUJDS3zXzoxPg6d7gyiST4UVq38fSudhrrH7TW8qrxjfe85V3p0YofgmcByHvaI6rkQdOfRpp9AiZvqpicGkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719079887; c=relaxed/simple;
	bh=dpnIIbuNmw/yXedwiT0BZEq/YFk4luywAuQejbAzBWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cXYD9OXmfkR1PcKbwtLOmKnsjkURb96ifahRNeL/imPfr1HXC82sWmqyGV1Um/jxJpUxmdyHEggBNG4lrj8Jvi96oBbF9Bn/6wGVDDeOuq6cjslFWhyLIE3WeDilIkl0rOJB63BHgVpBPbmdaO8HgdJoz3owwuUryxjcgBEl+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q3Z7g/Zr; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: oliver.upton@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719079881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+fa/31WHXvK8y3wUSKWM7ddloPmwAShICM7ksLk7Ds=;
	b=q3Z7g/ZrawMO1Jj+2+8U/brpIx+aWSOofnGEA/zCtL73IAGZZKbmyaqJWEenWF2osTP97E
	TKwzUBL8Ykv3rysSrwqkzObpnlj6QqQcO4rZ7iQ+7iwcJNyffLXB3gcDBII8NdKDG9scFH
	6q5VBZwMOic7uwTjCnTcX9y7s27aHaA=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvm@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
Date: Sat, 22 Jun 2024 18:11:09 +0000
Message-ID: <171907984340.2922035.2124351086655706702.b4-ty@linux.dev>
In-Reply-To: <20240621224044.2465901-1-oliver.upton@linux.dev>
References: <20240621224044.2465901-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 21 Jun 2024 22:40:44 +0000, Oliver Upton wrote:
> Marc reports that L1 VMs aren't booting with the NV series applied to
> today's kvmarm/next. After bisecting the issue, it appears that
> 44241f34fac9 ("KVM: arm64: nv: Use accessors for modifying ID
> registers") is to blame.
> 
> Poking around at the issue a bit further, it'd appear that the value for
> ID_AA64PFR0_EL1 is complete garbage, as 'val' still contains the value
> we set ID_AA64ISAR1_EL1 to.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
      https://git.kernel.org/kvmarm/kvmarm/c/33d85a93c6c3

--
Best,
Oliver

