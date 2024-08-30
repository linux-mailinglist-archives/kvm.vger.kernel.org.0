Return-Path: <kvm+bounces-25472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5272965980
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2290D1C21C6D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC5C16D4D0;
	Fri, 30 Aug 2024 08:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+lrXAL7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395DC380;
	Fri, 30 Aug 2024 08:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725005247; cv=none; b=JqemUIHVkd25Zyezi8nHgcY0t/ufqyqXejrekx2jdupD7oY8Gk3GfOuUPzL6v3cLPoZujhO+upa3sxJGjvouqMqG1JiK/SN5P2GJrTImZlJCrcZ6tOeCkDljluEOKkKRrXr3znFULE7RGHiFfYWUrlXSG9ZovL1lAkLVFywFOKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725005247; c=relaxed/simple;
	bh=l8roqf8kViPOvYRrIjEHUh2DQeMyArROfKcwR+D371o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1C89ZusMaO9PWxF8D7nldYoiLu3Yr9gqPf69nxtIHb7gsPNA+9DFmLzQoRuF2c1LG4Yfn95kHI0rTR9+cl1KhzLaLXQSwQQtmEN0h01Oyvq/UE2BLOljK8ldiqxBZzc8R4ktFh6q9S/LuPgXLsgyMHpeddQ2RyqSN/SrugnDwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+lrXAL7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB65EC4CEC8;
	Fri, 30 Aug 2024 08:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725005246;
	bh=l8roqf8kViPOvYRrIjEHUh2DQeMyArROfKcwR+D371o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+lrXAL77Dy6OZ784OTZCEFloe1ktIt+FzesYMm7fnUShwe0iC5yHiwE9B8OZzNK4
	 S/axU8AK9hSkZT8Ryl/kKvxyNP3PhC2gm/8XzA83L8HT1mGf/a2EQyB8D3uhFeQj5E
	 pQAf0Id9Dxf0zXpFVCR6lOiJhCdaNTEve4jQCTk3NYTUdMrRHdPhxf67wfJihFDs7M
	 EP24LdKM9tH2CXQxmft+cJUrbA4RSdDp2iku8YXhcWNqH67+d/TkesSY1ZhH55xbgk
	 1d4EGasPc/cpQf4M1sK0wXWJbuZ9fwiIDhc4oCW58K+x1SLsGk434YSWpzUoPpRGh9
	 JMeF5l3Vg9m0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sjwfE-0089Jh-KW;
	Fri, 30 Aug 2024 09:07:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v6 0/2] Add arch_timer_edge_cases selftest
Date: Fri, 30 Aug 2024 09:07:20 +0100
Message-Id: <172500523359.3939805.264149216310075712.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240823175836.2798235-1-coltonlewis@google.com>
References: <20240823175836.2798235-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, coltonlewis@google.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, rananta@google.com, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 23 Aug 2024 17:58:34 +0000, Colton Lewis wrote:
> Add arch_timer_edge_cases selftest to test various corner cases of the
> ARM timers such as:
> 
> * timers above the max TVAL value
> * timers in the past
> * moving counters ahead and behind pending timers
> * reprogramming timers
> * timers fired multiple times
> * masking/unmasking using the timer control mask
> 
> [...]

Applied to next, thanks!

[1/2] KVM: selftests: Ensure pending interrupts are handled in arch_timer test
      commit: ca1a18368d764f9b29ab0c79b3ddd712f5511855
[2/2] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
      commit: 54306f564441f6bc99514af45552236f28b1768d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



