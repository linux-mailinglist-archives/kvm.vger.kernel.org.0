Return-Path: <kvm+bounces-57718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D21E5B5963D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 14:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E99AD2A277D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C3D306B21;
	Tue, 16 Sep 2025 12:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0d/Dj5o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070991EDA2C;
	Tue, 16 Sep 2025 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758025902; cv=none; b=rcK6rUutC1Jnkmg9LTFzJ2y1XQwuqiMrFBF0NtKLBghZ4hWfbAl1bRXiSwC/7HkvVBtKIp0w2ZAdWJ27W7eGNGpfL4o+o+PHYYeuxlJ19t6omptcuKRgYLLmT7MOZerj4dI3nozVo2rJBpv/a4XeLlwZBqvvBQGEDoVGKgkihKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758025902; c=relaxed/simple;
	bh=AvnnFeLhqa+1N7BjqrcIXNBRXqWXQHi29E1hGGjkXRE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EQhf6u24y4wbm+b5X39cr2OgyXgMFP1r5Od1q4AUEPu4pg1p1LvBsp/nEKxmGX06suCLiVKzs+IwcO9qqECe39ozvDRKgQFH9ytgrww710AyV6yrhNsSjxUdsoHkF/+mRoZ2mUS5CoTAvct5bTmozIM2j5nzdMcND/BVHQRvvOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0d/Dj5o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F9FC4CEEB;
	Tue, 16 Sep 2025 12:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758025901;
	bh=AvnnFeLhqa+1N7BjqrcIXNBRXqWXQHi29E1hGGjkXRE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=P0d/Dj5oRlUj845mYfjKZ7ng1gm7rIXqPdU+u9b31iZhME+rs9C71GZZpLgHYxn6y
	 9puhWpjl36fzXN654GNREQI6cxnY28F49FElwXS3Z5/QgVQEbnuEg0KhcpOZPPcugQ
	 Hr8MPAE2+SqMpSLBtf4o5E9LKaX1PRIsbCldX2zc+bBTnzdXHHnCUq92b7IaDplx/e
	 8uzxxsAdcdKpEcnFr4g8E3y9d9bFcWKR2I/ABFomxlDgZ/vLtuI6L9hQccv/92sN7x
	 DkA27NRhwK50x6mDctSm6HKXaVPRXFGj8oJw//6Aro6Skcy8jK5U03rNa90Ml/IQOR
	 gswxS2axnp1qw==
From: Lee Jones <lee@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, Lee Jones <lee@kernel.org>, 
 "Kirill A. Shutemov" <kas@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Dzmitry Sankouski <dsankouski@gmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
 kvm@vger.kernel.org
In-Reply-To: <20250909-max77705-fix_interrupt_handling-v3-1-233c5a1a20b5@gmail.com>
References: <20250909-max77705-fix_interrupt_handling-v3-1-233c5a1a20b5@gmail.com>
Subject: Re: (subset) [PATCH v3] mfd: max77705: rework interrupts
Message-Id: <175802589907.3682989.11860525884258012047.b4-ty@kernel.org>
Date: Tue, 16 Sep 2025 13:31:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-c81fc

On Tue, 09 Sep 2025 21:23:07 +0300, Dzmitry Sankouski wrote:
> Current implementation describes only MFD's own topsys interrupts.
> However, max77705 has a register which indicates interrupt source, i.e.
> it acts as an interrupt controller. There's 4 interrupt sources in
> max77705: topsys, charger, fuelgauge, usb type-c manager.
> 
> Setup max77705 MFD parent as an interrupt controller. Delete topsys
> interrupts because currently unused.
> 
> [...]

Applied, thanks!

[1/1] mfd: max77705: rework interrupts
      commit: e3f56377ff69b0944da8780f2c5a14f10de71c13

--
Lee Jones [李琼斯]


