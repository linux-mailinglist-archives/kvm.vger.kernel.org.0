Return-Path: <kvm+bounces-63624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C1EC6C079
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1A2A9355CE5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A131331AF18;
	Tue, 18 Nov 2025 23:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIxZtq+m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC36731327A;
	Tue, 18 Nov 2025 23:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508881; cv=none; b=srvxsQWpjkG4QbjaRJYCJ8w9y/ClkGJe1BN/lWzuY9z51fS9tDdRJzQKSxTXunvA4M9BOXow4F4eM9r4LvNFUvAqLcTxHCJgAIJ7MFBe2t33hUyvuHTZaa0C720gGdx4vGWWOdrZCKhv4iL76XGPQL1TjoWtH2dV3nst/A4gjm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508881; c=relaxed/simple;
	bh=gXBV/4xTwn0jzieLHx+pUWj0FhQ7YIU3nhIOpIaPsBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVEAya7ylEddrtGbtjrp8lY0FXomPs6tDVng+hpSZEBnIHeem5FhpwgmZsGXDlSRPKuJyl4MOXv2XsQe/mb7zxn5wZxOwVgff3wJmQS7Rt69TlM+uaDOHu393bX+CtEpFqOmFrwAqUPbldQS0lP1/ttf2wzyfsFX1IidRbv1RUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIxZtq+m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23F6C19421;
	Tue, 18 Nov 2025 23:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763508880;
	bh=gXBV/4xTwn0jzieLHx+pUWj0FhQ7YIU3nhIOpIaPsBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIxZtq+mMWHY55GePuSG4b4vyL94wGWhdj9ZRIR8GwGyc9v55CabqX/nHSRlZnt5x
	 VGeXefjeekQkBYOPVTKVcABuhIhXlF5Du1VXCuYVJgSICv2FkJ8OiBPhBSLyjgJPlM
	 N1lM6VS4jr7Pcd3jyT0CG04+MKRnzkQbBwkJ9cxTGYeXSy7bwp+dFupEbUpO43h5MX
	 kNrjBX14UFoq+BtcWrh32VxhZlafy6c32dckLgutkt5m2mQPA+l09nAJqOvQyWDY7K
	 VpidE3/1gW1q9z/4A+6UCY2+xcXzRt4y3qakBiPLVVOo5tfl3rLnRwgh6m/7SlHHOU
	 JMseaSoL5s4rw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the dregs, the bad and the ugly)
Date: Tue, 18 Nov 2025 15:34:30 -0800
Message-ID: <176350881099.2483203.14164245618391807826.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117091527.1119213-1-maz@kernel.org>
References: <20251117091527.1119213-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 17 Nov 2025 09:15:22 +0000, Marc Zyngier wrote:
> This is a follow-up to the original series [1] (and fixes [2][3])
> with a bunch of bug-fixes and improvements. At least one patch has
> already been posted, but I thought I might repost it as part of a
> series, since I accumulated more stuff:
> 
> - The first patch addresses Mark's observation that the no-vgic-v3
>   test has been broken once more. At some point, we'll have to retire
>   that functionality, because even if we keep fixing the SR handling,
>   nobody tests the actual interrupt state exposure to userspace, which
>   I'm pretty sure has badly been broken for at least 5 years.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: GICv3: Don't advertise ICH_HCR_EL2.En==1 when no vgic is configured
      https://git.kernel.org/kvmarm/kvmarm/c/3c14fb1b1c88
[2/5] KVM: arm64: GICv3: Completely disable trapping on vcpu exit
      https://git.kernel.org/kvmarm/kvmarm/c/8be00d1ba3a1
[3/5] KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI emulation
      https://git.kernel.org/kvmarm/kvmarm/c/34586ff89152
[4/5] KVM: arm64: GICv3: Remove vgic_hcr workaround handling leftovers
      https://git.kernel.org/kvmarm/kvmarm/c/22c299785240
[5/5] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
      https://git.kernel.org/kvmarm/kvmarm/c/54cf1341324a

--
Best,
Oliver

