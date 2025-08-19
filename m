Return-Path: <kvm+bounces-54976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED27B2BFCA
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 13:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F5975E4AB8
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75B0322C70;
	Tue, 19 Aug 2025 11:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek8WAJEL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DAC322A06
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 11:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755601303; cv=none; b=BUDqbs5o43kmn//JQAcgc1XrZotFpMfWcFSoNmLONLN5Zh/Ekkx2dKKfZsDlJl6Jn1VEh0uO8/v4TumDQ2dxqNNji8Ugg0aakdrFD8qBr8Qf1N6NwNVonMnsdUMp/KwkqJB3zr0EfDowvwQGB7FiWdcce5hnLp/Ag1doSKPiq2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755601303; c=relaxed/simple;
	bh=NNJCi2SrzVPY1orE+oxzKIbLBlUfiasgbV7nipAAIOs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UsAnp5MTb5HXuiQ7hOlhg0EIdIGm+i/umhzPUXqBJ2SxbmIro4mGYvo5vLGCSbJMPMYJsnGg1MyaadlewspTza1D2njiAp2vFbryKhMGxk5ykPOynAGbhe0Y+iJ3NRIpca9W3AflAe9k4cUlHS5tcXFtdngKaTvmm76346yIU08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ek8WAJEL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272D5C4CEF1;
	Tue, 19 Aug 2025 11:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755601301;
	bh=NNJCi2SrzVPY1orE+oxzKIbLBlUfiasgbV7nipAAIOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek8WAJELyxJBl4u+DFOM3seut5zgC+vfV9bLE0kmivDoRlIuhKvtd3fOdimOhmhIc
	 1qOqEyxAJp5DraB4kDuONHv2AqLef1a1es7RBIiYTy7aKQ6UWV0qE6dmm821YNMcqd
	 /WcXImjrzKr1UDDERk7uy93dmHK7HwM3xCbJ2YQudmaV9E+PTWPhA1p1/yYLo7Irkd
	 y4QHMYJqeultfnnlEpg5rH84dZqmDTYATcVQL7Bx3bxxJx4/mlFKet2gr3wk+G1G2x
	 jsCzddU9rQCkD/nJpdyYJRhGFgrWvYx52UpZ5bRLj27mCIlwovU6V/HpS+wT3DEZ/a
	 RlOkPaCfjyK4Q==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Cristian Marussi <cristian.marussi@arm.com>
Subject: Re: [PATCH kvmtool] virtio/pci: explicit zero unknown devices features
Date: Tue, 19 Aug 2025 12:01:33 +0100
Message-Id: <175560107061.89119.13817614908098860585.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <ed62443b8fd3fef87bd313a54f821cf363f647a5.1755185758.git.pabeni@redhat.com>
References: <ed62443b8fd3fef87bd313a54f821cf363f647a5.1755185758.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 14 Aug 2025 17:37:02 +0200, Paolo Abeni wrote:
> The linux kernel implementation for the virtio_net driver recently
> gained support for virtio features above the 64th bit.
> 
> It relies on the hypervisor to clear the features data for unknown /
> unsupported features range.
> 
> The current pci-modern implementation, in such scenario, leaves the
> data memory untouched, which causes the guest kernel assuming "random"
> features are supported (and possibly leaks host memory contents).
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio/pci: explicit zero unknown devices features
      https://git.kernel.org/will/kvmtool/c/c4e9b3a8de7f

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

