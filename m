Return-Path: <kvm+bounces-27776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E7398BFE2
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 16:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E018281ED0
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 14:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3EC1C6F7A;
	Tue,  1 Oct 2024 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kABweNjh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB5219D06E;
	Tue,  1 Oct 2024 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727792938; cv=none; b=CRMd+yJ6a5/Hqtt2bzb4dM3/4kbXsMFlv+X0iVzAuE+m1ghS2/vuSrHkKz9sDYzzlqOZ2JtG5WECdrcmIWiZeHdcQo0TTHCcH+pIdnjUGbkONTO9zErHkFXOrBvaCaS0dLonzMUbzItsA6wp4Fq/tMBMXaRY92mUht+yyne/hQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727792938; c=relaxed/simple;
	bh=iaVKSziNPXvrRl9FZ9+SzKyf8EeIpcYYBf0Surobxdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qu7UV6PLSGKdlB4B+1FEpztnLOW6K24DZywtu2mcG19HwCFWVBJE6U7ND7ijKeDuAcgaQJ/Tx7OsRkGP1Jo2vqb6D+xwPMenmcj7iTx8ofck7YyX+Y66nW2ZCWl7Y1GauQ5SWz0ZRv7E0vnrsBFM0/hZwUYLFCUx2fRqdKsSOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kABweNjh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A79C4CEC6;
	Tue,  1 Oct 2024 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727792938;
	bh=iaVKSziNPXvrRl9FZ9+SzKyf8EeIpcYYBf0Surobxdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kABweNjhIhZyNjyAKBaD18AL2xFS4admXZ7+stRkKq9n4j4gQxZHYqsTfegWsKyz1
	 SyZcG9z9TtdwJYbmMyDTuBoAxqxOp7Cu22IWToAk2T3Vo+oNBhn+1P5ecadxVZZiVj
	 uiDhyv8yRuP5TAULZlR5CmgBJvYMXskIfZv5L6E0lgttwhniKBoDfSLGxNCC0ySI6h
	 oclZjhxihd3QTtn7/1pVyhyO0zcLHZ7Bm+i+AmQpTOC+2+vQDVh/p9QP1moaUNWAAy
	 oNOhOX1c57HXqWpljptMfJ4eHlLsrZwOt8r6rSRH3jcflkunGQZUunR69FEiMY3rAr
	 EOrbBsePZ4Zvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1svdrz-00GmHW-WD;
	Tue, 01 Oct 2024 15:28:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Another reviewer reshuffle
Date: Tue,  1 Oct 2024 15:28:51 +0100
Message-Id: <172779288244.1647258.5766550239209776023.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240927104956.1223658-1-maz@kernel.org>
References: <20240927104956.1223658-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 27 Sep 2024 11:49:56 +0100, Marc Zyngier wrote:
> It has been a while since James had any significant bandwidth to
> review KVM/arm64 patches. But in the meantime, Joey has stepped up
> and did a really good job reviewing some terrifying patch series.
> 
> Having talked with the interested parties, it appears that James
> is unlikely to have time for KVM in the near future, and that Joey
> is willing to take more responsibilities.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Another reviewer reshuffle
      commit: 64a1d716615ee234a743b2528e95d8c3a9bef95f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



