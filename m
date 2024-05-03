Return-Path: <kvm+bounces-16511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A448BADC9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E4211C21CB3
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B767153BD1;
	Fri,  3 May 2024 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oz2OKeXG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C20B15358C;
	Fri,  3 May 2024 13:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714743330; cv=none; b=tzo0aq9cW4TM2OzFQk1fqzQ9Z6vBjuMVy3uS0tKjXgAZdGdlgMxr7zuP4Ma2a8hJ7sp6nAnyhhAOC30ltPE2j3weBpEcMO2vkVD2pw3PHwJpC60MxXrwbmX826yaLHG+4GmVw4xl3y4lqBV/CtbeCUz26wP6Ilh9hoIIG+WyE80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714743330; c=relaxed/simple;
	bh=1Gj0ji1WJGaVGrQBE5Z164B4WogRDBy3MPOTTBDGUFs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W23kJ3Prt/kxa+GQtFHsYCUJusck7bXrL8YgzaSUUHCAQF0RSQEz3aeN/r5hXP9os/xHGnzu3RG5Q8hUF8agSnuMzexpRyftaNH3RDWxgBesZ048EI1oTaQF1qLvHkzn+6812mzs0sKUCd8iG9ofGlyR5JTi0KIGrf9x+TGLiQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oz2OKeXG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11034C116B1;
	Fri,  3 May 2024 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714743330;
	bh=1Gj0ji1WJGaVGrQBE5Z164B4WogRDBy3MPOTTBDGUFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oz2OKeXGbtiOl3WZP8XjJ4oQIV7xNjYFaJCqmHpE3h11eCzqFI6WwvSGt/q3eO9XL
	 Yy6kFOkZf1ebmXr+3TV+ooP8EDdOi9tLX/Y0h9NUvaortLTNlfMvxRYaJ5qaKlaqDR
	 ULM8XdDJ6dYrbkAqGG8JODJ5zOO20eDk0WF+Tf1o2kD5Ekg1ZUmMX65SI3DcqNyaTy
	 N/LdulSJC0SQB//09pf9wTV4yYJUy9lJHqQs+fPyV77JD0CpQSgE2MtTqI9MMwgWE/
	 pHb+Li5jVvLQGn4kUbSWgX3E6E/M1yRt8zuREGJoyeJA/JD1SUfOzC9utcWDCBl/id
	 WLBFLCd0eWfrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2t4R-00AKZC-RB;
	Fri, 03 May 2024 14:35:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Convert kvm_mpidr_index() to bitmap_gather()
Date: Fri,  3 May 2024 14:35:15 +0100
Message-Id: <171474325427.3225213.7275231723236470580.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240502154247.3012042-1-maz@kernel.org>
References: <20240502154247.3012042-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 02 May 2024 16:42:47 +0100, Marc Zyngier wrote:
> Linux 6.9 has introduced new bitmap manipulation helpers, with
> bitmap_gather() being of special interest, as it does exactly
> what kvm_mpidr_index() is already doing.
> 
> Make the latter a wrapper around the former.
> 
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Convert kvm_mpidr_index() to bitmap_gather()
      commit: 838d992b84486311e6039170d28b79a7a0633f06

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



