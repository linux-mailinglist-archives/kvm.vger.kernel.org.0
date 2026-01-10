Return-Path: <kvm+bounces-67653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FFF9D0D4B7
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 11:23:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FFB03028584
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 10:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1ED30C61B;
	Sat, 10 Jan 2026 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMeE8jOD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A4029B8C7;
	Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040590; cv=none; b=boxP+KXkNq02W9MQkmNYng4m3a07L3BFjM2i2fnZc/5HdWi8VUacfcnK7U6xgZ0ZHoy2fPBBGG6BCsafOn082ybOC9eKQ/NLQgjWT4xpJWZLRZdcpzee3soOK/QI3pyulTPY85r5uKqmcyXEhaoEmZZ/vdytHat8C0djd3FIhAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040590; c=relaxed/simple;
	bh=7YgEmuODkBdJ5vTtg9+ZT6aVkPL7hovfppJ5JjIij54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0RwKxzWMGGIstt3JJY6e4xf2Sf2zRpSg9wAuFN4eG44NESK1OQhxH4KamwHNy89nbFaWYyQB6VPgLowZ5FkqSejtsXXXXL2IeToyuS/PCzVIdzOxB2P/3SjoctnNzAX0YghrGkhjQjNiUgBBNZnyofROaAtQOUGEOn1yZFWj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMeE8jOD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F02C4CEF7;
	Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768040590;
	bh=7YgEmuODkBdJ5vTtg9+ZT6aVkPL7hovfppJ5JjIij54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMeE8jODVxkRq88ihk5l60Yxi/YV8/uPou3Ui00izndWUUTeVIaIPgTGLL/jjex0w
	 CttTfPII0sA8LQwPvBr08zU/+zJM5Eq1qw7Z7mluBsLQfcBwDZysOG8BB3D+5juqmq
	 /ny9ZWkE2tjwBMu3w8+3MoD1KTLSU6UkJp7JXi7VYKZam2QtZrx8PRiasrp81ObYRl
	 EuFVRqFpcOlZPjtuE3UtHg0ARk0gVFvusmUI1/QLlh+xPfP2jk16woUgr/PttbNBT0
	 H+gheW86Nq4gKxSILqaz+cOn0iBvJZywcQ5ytAq/JMePnWDa5QIgPh5eH24ZZRYB+R
	 TFoxdMYR3Bz6w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: (subset) [PATCH v2 1/6] KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
Date: Sat, 10 Jan 2026 02:22:44 -0800
Message-ID: <176804045754.916140.2575057766830377707.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210173024.561160-2-maz@kernel.org>
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 10 Dec 2025 17:30:19 +0000, Marc Zyngier wrote:
> The current XN implementation is tied to the EL2 translation regime,
> and fall flat on its face with the EL2&0 one that is used for hVHE,
> as the permission bit for privileged execution is a different one.
> 
> 

Applied to fixes, thanks!

[1/6] KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
      https://git.kernel.org/kvmarm/kvmarm/c/8d8e882c2b4b

--
Best,
Oliver

