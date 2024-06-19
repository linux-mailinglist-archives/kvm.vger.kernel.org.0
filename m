Return-Path: <kvm+bounces-19947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6679A90E62F
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74B2E1C21932
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1C87E761;
	Wed, 19 Jun 2024 08:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jg2kJ3wA"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35867E576
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 08:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718786521; cv=none; b=ukMoPS+qHwgbNu2s03yfg3BodkM1lYxdihak5xAgSkxX+lJ1d6Bd0Uq9EnVz5hCm5HaC8F7RjFoN4oboCgTCTl+Ci8nlcaVCzIVk7VF/lDMoLixtoWGTZoYtuZgJmdqtyw+4G1fmRuhgUrZ+Z2XoAcSQuNfY1iRlSCR0pTTOE9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718786521; c=relaxed/simple;
	bh=HtjdXg9ZU+akgiCSMtHxSFxQ2HPFeYkojWZkkjhztbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Km0VWt5MAH51F5qAsXrcKdVEQE+4cdJ9GOY6w+kv56V6llHpCNc7fGRhQbrL4YwKpgxoV2SqwiTVZBRnLhextsoFi1rItPgsm1Dm1gd38rl/mkCFksyYvIhpHBM3MmEnD7XyLKllBhlzoEOR3pW+UYC3oN1NZtQCA8B7KV2zQp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jg2kJ3wA; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvm@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718786517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJVO7AfMHkPi8E140K5GfFbeAJzLQ61z8H0562UabYQ=;
	b=jg2kJ3wAtcctxn4PlxIB06Lslr6GcwVnYSxnBhmqqxLBdeDXpgnFWZvw7uWV+JyXQtDWwi
	bTUGfgYN7c5njFzuk/m3BYeldosXoxgYc67eFQ9K4+sT9ULLapmjL+sUUmSVKaa7T+F02j
	ohsfD9v7+ZUmQ49jeStqP4b9EBMnGJ0=
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: christoffer.dall@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: gankulkarni@os.amperecomputing.com
X-Envelope-To: yuzenghui@huawei.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 00/16] KVM: arm64: nv: Shadow stage-2 page table handling
Date: Wed, 19 Jun 2024 08:41:44 +0000
Message-ID: <171878647493.242213.9111337124987897859.b4-ty@linux.dev>
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 14 Jun 2024 15:45:36 +0100, Marc Zyngier wrote:
> Here's the thurd version of the shadow stage-2 handling for NV
> support on arm64.
> 
> * From v2 [2]
> 
>   - Simplified the S2 walker by dropping a bunch of redundant
>     fields from the walker info structure
> 
> [...]

Applied to kvmarm/next, thanks!

[01/16] KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
        https://git.kernel.org/kvmarm/kvmarm/c/4f128f8e1aaa
[02/16] KVM: arm64: nv: Implement nested Stage-2 page table walk logic
        https://git.kernel.org/kvmarm/kvmarm/c/61e30b9eef7f
[03/16] KVM: arm64: nv: Handle shadow stage 2 page faults
        https://git.kernel.org/kvmarm/kvmarm/c/fd276e71d1e7
[04/16] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
        https://git.kernel.org/kvmarm/kvmarm/c/ec14c272408a
[05/16] KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
        https://git.kernel.org/kvmarm/kvmarm/c/82e86326ec58
[06/16] KVM: arm64: nv: Handle EL2 Stage-1 TLB invalidation
        https://git.kernel.org/kvmarm/kvmarm/c/67fda56e76da
[07/16] KVM: arm64: nv: Handle TLB invalidation targeting L2 stage-1
        https://git.kernel.org/kvmarm/kvmarm/c/8e236efa4cd2
[08/16] KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
        https://git.kernel.org/kvmarm/kvmarm/c/e6c9a3015ff2
[09/16] KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
        https://git.kernel.org/kvmarm/kvmarm/c/5cfb6cec62f2
[10/16] KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations
        https://git.kernel.org/kvmarm/kvmarm/c/70109bcd701e
[11/16] KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations
        https://git.kernel.org/kvmarm/kvmarm/c/d1de1576dc21
[12/16] KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
        https://git.kernel.org/kvmarm/kvmarm/c/b1a3a94812b9
[13/16] KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
        https://git.kernel.org/kvmarm/kvmarm/c/809b2e6013a5
[14/16] KVM: arm64: nv: Add handling of outer-shareable TLBI operations
        https://git.kernel.org/kvmarm/kvmarm/c/0cb8aae22676
[15/16] KVM: arm64: nv: Add handling of range-based TLBI operations
        https://git.kernel.org/kvmarm/kvmarm/c/5d476ca57d7d
[16/16] KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations
        https://git.kernel.org/kvmarm/kvmarm/c/0feec7769a63

--
Best,
Oliver

