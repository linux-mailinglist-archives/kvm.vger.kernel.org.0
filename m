Return-Path: <kvm+bounces-64653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9316C89A01
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 12:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8FE23B6FDF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C5D325720;
	Wed, 26 Nov 2025 11:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nwxd9t5R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E876EED8;
	Wed, 26 Nov 2025 11:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764158298; cv=none; b=SuKVkd52ZNxIzA6HMkqmaP6CQwmhvYfL+GGtICqOwzfWBMXhFuTukATYnoPm00Lzpl4msi81Px2ZsCXU/vVBGc/XDCdMoKvcOSYW+H7j9AJAK/YGxEm9aYP/DVFXoYUHFFpCWeSoC4FiPsegKP4jExtlpkSWaiRO0adStfG36ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764158298; c=relaxed/simple;
	bh=rmV+i/bxGZPpVilUeplxqHoBEtEaVJTKCPj9TMnykC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pf3hQe/xVb3intlMzJ5p/LSENRQ6zfC4BXp45+GjenRc96wNKys5zL0+F3GaeiW4UpfiILlNVMobK2iLbQj8up7+MtsNeTORaoT6dVjEd0LqIHotlvAZ/Xl4eLDTzCQmqW9JtHEtMMyyryczkJpj0EEnFUmc4egEI5/eMktsRAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nwxd9t5R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73152C113D0;
	Wed, 26 Nov 2025 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764158296;
	bh=rmV+i/bxGZPpVilUeplxqHoBEtEaVJTKCPj9TMnykC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nwxd9t5R5bIys1gPue6FOsKItnzoP/0qgGNdZ2v4fRnl0sjw3K85BBLvodEkOGRnI
	 pl9YPwTDC4bvfsbQCvbfZlBbMHHAJ2gTMjNu0hs39OmQEQGLV1n8zui4lwspyleDug
	 DR/rxRIPwldmxw6LoADHlzwxTcK4oY/4uZ9693NEcWZk0fWVE/eHXUePmg29s8AU7y
	 VMJ2pCP6F8ROXzIOLwN7h5jEybsZw92p9WmaG1sESESLA8aVlrC85D/Ecn1y2TbtxF
	 0JRmE8AmpkgHWUz5nKJGzyZ8dRk3Tkuu9dfPWnYUcrqlTwoS9wwYnYnNfDBJ/To8wg
	 tPUJbLLYtjoTw==
From: Sasha Levin <sashal@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 6.12.y] KVM: arm64: Make all 32bit ID registers fully writable
Date: Wed, 26 Nov 2025 06:58:14 -0500
Message-ID: <20251126115814.1354988-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251123103909.3518993-1-maz@kernel.org>
References: <20251123103909.3518993-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch has been queued up for the 6.12 stable tree.

Subject: KVM: arm64: Make all 32bit ID registers fully writable
Queue: 6.12

Thanks for the backport!

