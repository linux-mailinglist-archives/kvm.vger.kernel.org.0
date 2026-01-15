Return-Path: <kvm+bounces-68184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B50ABD24CB0
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 14:47:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B731308603B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 13:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915AE3A0B16;
	Thu, 15 Jan 2026 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4Zm+eDV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C177D334C14;
	Thu, 15 Jan 2026 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768484698; cv=none; b=ixgtDdZwp1Eg7XsgSrkk0iddGFWyywcWp6zm0ewqcy5F1Y7uwVjZYlXGmBJ0vIKLR0JcIe7qItYUNibLllanr4JjqI/a4mJiZJha+FGucIRAbOqQxdZ/CX1VohTA22DS0a4tVA2cBWYZ6J//WZ0BAzcC1I2maABJ9V03buGRm2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768484698; c=relaxed/simple;
	bh=DXUK5OShB9en+nMT8mpBNu33HgXEnxxQ/vgq26T3Tx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0iWYi1bsPPnrq+M5H91I6rMsW+S1kWoIl9ipjDxfAuTb7OXAsFdhBGAjx/9nqWA4IOwe2hZMphz6w0YDe4ixls3Pq+SzQ7UEyn8tu2W+oq77vFJhrAX7WNpJ9W93kG4fbEknSgDROJGvVY7VIHlrLLQy8zQWTwVUtScZ1WVMK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4Zm+eDV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64264C116D0;
	Thu, 15 Jan 2026 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768484698;
	bh=DXUK5OShB9en+nMT8mpBNu33HgXEnxxQ/vgq26T3Tx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4Zm+eDVr715b7zc+K4GFEoGu+xrAqhbtPjXRmDZCdel8oIJS9zC8QvzWQF+iHMvf
	 KVXvx6k8weAuWqytg1z5NLAJid/dAKHu0Vc8W8Ju0c3XTnSyb+2F0CljO+pImAtqKm
	 zonnD7ot93W/64d/jJXyMwzLNvJFlJmj0evnsBCUZ7cx6aXWzkWUIhQq4yr3GNlqlH
	 oCz689y9fkywS0JPdT9VBcd5XzwWdXQlYmB5rnQIhwsj5BVbtJa2TsdIZE1smxQKwC
	 PPw9xJtf6Jtn30++Ritbe4HTLF+3pXU30mDiz35oHfGQKov898uJa4MvKrZG2HVeVK
	 SA3WkhfXXyUqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vgNeh-00000002XXF-3FHQ;
	Thu, 15 Jan 2026 13:44:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	anup@brainfault.org,
	atish.patra@linux.dev,
	itaru.kitayama@fujitsu.com,
	andrew.jones@linux.dev,
	seanjc@google.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v4 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
Date: Thu, 15 Jan 2026 13:44:53 +0000
Message-ID: <176848468177.3734174.14845458952708831898.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
References: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, seanjc@google.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 09 Jan 2026 08:22:13 +0000, Fuad Tabba wrote:
> Changes from v3 [1]:
> - Renamed page_align() to vm_page_align() (Sean)
> 
> This series tidies up a few things in the KVM selftests. It addresses an
> error in memory alignment, hardens the arm64 MMU configuration for
> selftests, and fixes minor documentation issues.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
      commit: 7e03d07d03a486c66d5c084c7185b1bef29049e9
[2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
      commit: dd0c5d04d13cae8ff2694ef83d1ae5804d6d9798
[3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
      commit: 582b39463f1c0774e0b3cb5be2118e8564b7941e
[4/5] KVM: selftests: Move page_align() to shared header
      commit: de00d07321cf3f182762de2308c08062d5b824c0
[5/5] KVM: selftests: Fix typos and stale comments in kvm_util
      commit: e0a99a2b72f3c6365d9f4d6943ed45f7fc286b70

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



