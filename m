Return-Path: <kvm+bounces-64570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4BBC87396
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 22:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C42583509B9
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A062FBE03;
	Tue, 25 Nov 2025 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScWFMkJ1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB0C2264A9;
	Tue, 25 Nov 2025 21:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764106000; cv=none; b=R8UdXW3Sl0+PJFP5jQXBEmD4x7FpDS8r4TVWloQzMmzea0Ltcgx7iyzcNejhHnkrNdGByP4zLXFJHOtbRsij/SL4qbQ8cV7AvEdTDREEHKxyV/+mEnR1HjNJwIN7wtFPtZGUVG2eYJxMcdRykceSNf7v0rSy1nGMWHOKUPei4H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764106000; c=relaxed/simple;
	bh=j3PFuvojslHLNYmdmCoF9SEmIH4R95D0u/HjVyTT8uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8LSI/4jA1G1SrHRRvHToCHKZcLJbgp9NmJ9J8MaryvQzns4skuVPydd3ojuVa6pj1qlLJXeTpWQTZwBvhnuD3H31eVEROmLvW5UGU0C0N2iDb6MuaiBNEwbE/6oqVi9OHvPyU6uO7z+dcUboYVXBvN6YuDYyK6wWsx8N4h6u9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScWFMkJ1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AD0C4CEF1;
	Tue, 25 Nov 2025 21:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764106000;
	bh=j3PFuvojslHLNYmdmCoF9SEmIH4R95D0u/HjVyTT8uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScWFMkJ1QIkfkGpwHoZvxJn8uc6QJ2SBxnfKVzjoHJzbaAoMYPFDWH6e5hre/DrVs
	 kT0yl90HJc90N+9huQqq9fb/dK5KXOTehydvzJ+fS/lMsytXH8pphr4KpxIsw6ukUf
	 70yYrpktNvn8Z1QuVtrdFTP4jRihoqC1HfsgkZzeOoxHV5XlQ4E2gUmC7KwSOF1Eq5
	 Mt8jg6J6NSD48NhaCXWLRRIgUBQNCT6UnAvRKqnLGeUWmpGZpuSLclz1rGad0Jz2tr
	 H3ujKq2PDX2yTyCKFPM+NmsNpqulbkQRSTmPoktP95+SrSUyrts0kvV28bYxMnoORw
	 VbUDZaZj3gfEA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] KVM: arm64: Add endian casting to kvm_swap_s[12]_desc()
Date: Tue, 25 Nov 2025 13:26:37 -0800
Message-ID: <176410599244.1757287.4209231567146876775.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125204848.1136383-1-maz@kernel.org>
References: <20251125204848.1136383-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Nov 2025 20:48:48 +0000, Marc Zyngier wrote:
> Keep sparse quiet by explicitly casting endianness conversion
> when swapping S1 and S2 descriptors.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Add endian casting to kvm_swap_s[12]_desc()
      https://git.kernel.org/kvmarm/kvmarm/c/1625e20fc198

--
Best,
Oliver

