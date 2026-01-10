Return-Path: <kvm+bounces-67654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B1AD0D4C0
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 11:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0CCD53035317
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 10:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3818630DEB6;
	Sat, 10 Jan 2026 10:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNk1s514"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5830C371;
	Sat, 10 Jan 2026 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040591; cv=none; b=lpwiJVKNVeWkXVJ0tNxkXHfS9XGWnPfP8YyaKTF7c8jpqBcQeYiAuqJcjO4DjttL7Ej6/+zk8zab05o39C9mVz0iO2nh3TjZNuj39OmqI7njvXwYuK146we2Xwgif44/YfjWNekdxqzjY3i5YX4PJKv07nilF5mjbIJyIyPuTyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040591; c=relaxed/simple;
	bh=85X+Dw7tcU6Dy3t2huC1qsEwwh+z3sypfGDQLubbMDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIaR9GrHHt7wuZpw3vNutWUXTo3wg+cOOMoqsCDX8YyK4xrDkn1ury2pMsLvKB9oDbhA00RgbQ8epj1lgQjwi5LozUUjOiWWeaYBUnI0V8TjEMPCW3zDEJLaKmel6kTb48FdSNTEAaafai1/aL2HtV7BmB5bqr8iIotyTuGfiRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNk1s514; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A64C19424;
	Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768040591;
	bh=85X+Dw7tcU6Dy3t2huC1qsEwwh+z3sypfGDQLubbMDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNk1s514y5QfuogV0MJ3zbFUlBmUOp01YXIdpt49P6i+okIJG5kervEmcMjjJSMXL
	 v58bLydG302mcuV3dzBJIXE2g4lkiWqUMpQesloyHDN2EF1r/tJBpQ548MRK4xN9/s
	 qmctipnW1cSdC0fYRybBlz+7RfmPgDAyaOOsiXvxEAbA8af2HWtTgiuQ6B50W3BNGo
	 BjaPS7UAbu7+37tOIkgC14sYPbNSIXx/jVlmuIKP+ooTCrjKrpPpWKPW8DQDIsJNjp
	 oWm/5egZ/nv6h4zexDDa2dGE6jNRudSBZgVzhrBUZv14j3Z3b3JekDTMFAZ7p/S+VD
	 PsKTyFUyGtIjg==
From: Oliver Upton <oupton@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: Oliver Upton <oupton@kernel.org>,
	nd <nd@arm.com>,
	maz@kernel.org,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: gic: Check for vGICv3 when clearing TWI
Date: Sat, 10 Jan 2026 02:22:46 -0800
Message-ID: <176804045751.916140.10019376959151552249.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106165154.3321753-1-sascha.bischoff@arm.com>
References: <20260106165154.3321753-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 06 Jan 2026 16:52:10 +0000, Sascha Bischoff wrote:
> Explicitly check for the vgic being v3 when disabling TWI. Failure to
> check this can result in using the wrong view of the vgic CPU IF union
> causing undesirable/unexpected behaviour.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: gic: Check for vGICv3 when clearing TWI
      https://git.kernel.org/kvmarm/kvmarm/c/5e8b511c39f3

--
Best,
Oliver

