Return-Path: <kvm+bounces-64569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BA8CAC87387
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 22:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 34F4E34E35D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8532FB0BC;
	Tue, 25 Nov 2025 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiYzwwbW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC0A2264A9;
	Tue, 25 Nov 2025 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764105959; cv=none; b=DiLcef9Bw09EHH7zrVI8qGVwv+u56egpPhBjHzGdfG1CaJBunLHaQQl2qxSfkKiGGgXBhNZHM7sItIJbU7loq1IBu5n2vw36X3/6V2TJUaxJ81AExeSS29ZaUElg/GksKfK115Yuq8TR+P/KkNJ9ARrE/PI7VMt0DWfCJRx25Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764105959; c=relaxed/simple;
	bh=n5CbeK8jDmfr7XozFAqeBAw9k9v7rJ8GAcFjignIIHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vcqy9P406mqQjALnp+fnU/GMDHs/4GvJcq0m0OlEkLcTKW+MGiarCt8ATYkIlB0aFP5AdaXdAqTWG56HdpaGQJk0IbUZ9gPzqTLeKIwKLlXy7v3oT/0pVZN73O69S5VTeYQh6rriCcDasvFRoCRdWE7GKNbpXpLyZAsWOm9JPuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiYzwwbW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750B4C4CEF1;
	Tue, 25 Nov 2025 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764105959;
	bh=n5CbeK8jDmfr7XozFAqeBAw9k9v7rJ8GAcFjignIIHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiYzwwbWs6GsJDcQLfpHkUixgu90gQAntbPAxoHz5R+QD8CRJqTFAbv3zGTEh+SkI
	 xYyYACNja+jj4qWS08YDpbDHVGabTtd4wjwBCdANYSqMm3ziTIwmSQR0R/AS2AqCRJ
	 r3yE6Jd+kTygj9Xp5I5l2kvNsMG7ol573cjWnaRksbNAsf2rTKZLlXDghRs3jN+ZOD
	 35umsDShvWtxHLc1Avpz9/i1nX8gy6FQew7Os888cLjyjC6xFpMeQHMT1EpJSxa9Qx
	 l+OZA+CdDgEbgj3czy8YU3LuDzE+8Yoh+92UPFnNLZx9w7J/umCup9RrToXzAkWbBa
	 3cNlZCpPSopEA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Don't use FIELD_PREP() in initialisers
Date: Tue, 25 Nov 2025 13:25:55 -0800
Message-ID: <176410594555.1756747.17127905148287939848.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125201715.1133405-1-maz@kernel.org>
References: <20251125201715.1133405-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Nov 2025 20:17:15 +0000, Marc Zyngier wrote:
> Nathan reports that compiling with CONFIG_PTDUMP_STAGE2_DEBUGFS
> results in a compilation failure, with the compiler moaning about
> "braced-group within expression allowed only inside a function"...
> 
> Replace FIELD_PREP() with its shifting primitive, which does the
> trick here.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Don't use FIELD_PREP() in initialisers
      https://git.kernel.org/kvmarm/kvmarm/c/5742f3650013

--
Best,
Oliver

