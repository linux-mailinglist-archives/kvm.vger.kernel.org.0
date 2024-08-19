Return-Path: <kvm+bounces-24546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69288957239
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 19:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15609B22041
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B380184535;
	Mon, 19 Aug 2024 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U9sem894"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8774618E0E
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724088480; cv=none; b=jsNVlJhUCJwgpwjNyqn9Y2mLkvYtHeiduAitNp31XjHjO6Z9swhAQI+KTlf/3uaiiCosycfrkqgwm81FltZaMnbIIH9LPibULBi1kWgN7MuzfjIrozJUAuLnW/9zEd4aHOGJmMEZd51rZPsZVCE8yYCwxKKMXuOS+edgsxYAjo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724088480; c=relaxed/simple;
	bh=7M0OZHShhDAC+gzzpjewgdBrRAPvIOZhXlQ0c5RHqvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9p7jm7yHBZX8dEW7RPUwCnGVofxVakehvEWAZPApT7QLz94AEHxoysTT6Ftc7gDCxr9b+hjM+RhEEKmgDbjdnMOuJqd/kdTUgtVB0yI1rEdhS9ZQVACqjj173ghl4aTkBHk0PyyyMhvOCNLd0towxSRQ0Peitr+0O55X330zA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U9sem894; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724088476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PqS49g30NErX314MhXi3K/PTA6QBsp5a3jiODOwBZa0=;
	b=U9sem894frqgnlVFBLhfZgS55Pyk3teGaKz1drhTFCvQq93SIQFVk6Xb5iPyN5H+ZjTiVM
	+75LrAXCCBtFS52PLN0voCqgt6B7drdgujEAz+o7C4jMJPMg5TGkwGvKUfCUglAJM6Iz1X
	CFIboyJOlRYchQjibRk8gZ+g74yWDk4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Don't hold config_lock while unregistering redistributors
Date: Mon, 19 Aug 2024 17:26:05 +0000
Message-ID: <172408829924.848017.13221469817768550925.b4-ty@linux.dev>
In-Reply-To: <20240819125045.3474845-1-maz@kernel.org>
References: <20240819125045.3474845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 19 Aug 2024 13:50:45 +0100, Marc Zyngier wrote:
> We recently moved the teardown of the vgic part of a vcpu inside
> a critical section guarded by the config_lock. This teardown phase
> involves calling into kvm_io_bus_unregister_dev(), which takes the
> kvm->srcu lock.
> 
> However, this violates the established order where kvm->srcu is
> taken on a memory fault (such as an MMIO access), possibly
> followed by taking the config_lock if the GIC emulation requires
> mutual exclusion from the other vcpus.
> 
> [...]

Tested this w/ kvm-unit-tests, selftests, and a few VMs on a lockdep kernel.

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: vgic: Don't hold config_lock while unregistering redistributors
      https://git.kernel.org/kvmarm/kvmarm/c/f616506754d3

--
Best,
Oliver

