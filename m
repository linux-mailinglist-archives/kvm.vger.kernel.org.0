Return-Path: <kvm+bounces-33532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7745C9EDC2E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 00:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC2B5282785
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399361F4E2D;
	Wed, 11 Dec 2024 23:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjjbPw1X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A41F3D43
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 23:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733960663; cv=none; b=c6EeCccMahQnBJw3xJzgPqntIPtJMvTY28yswJC2JABnxhv2kUE2DNtt0OEgJuJd/pOf3AQJJqPuOT3QC9qalD3qBqo//EqhwNsDU9PQB+N3V0FSB6jDOhGzHeeZKSCSzRoOAHLs/lcPstp7+pJziZVe6k6i7XhtmKZUqtAdCUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733960663; c=relaxed/simple;
	bh=jeH4GZgYMjzsC79p4/GYsmGWcUTkTTIXW26ndg85N0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFDEWvQFXJUP87Kia+gce/l2/k+q5VskdgXfxO6MC/3PSYRtjEKxOsHUcFspYkYbomO+WH+Cvn1Ud1XqW59AUpbZRS70opSxkR2tO4hQiXLYZ0nLU3yKmRcsjhIxkpfVpZWQ1tBtAcAbF2a1HYrLCFN8livC9DuQNHj1N8KyASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjjbPw1X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AEDC4CED7;
	Wed, 11 Dec 2024 23:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733960662;
	bh=jeH4GZgYMjzsC79p4/GYsmGWcUTkTTIXW26ndg85N0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjjbPw1X5lNveMFMXp6R8u+3/Bhr1L9sWoXHTjczmfEbvKTXb/FR/fsSfIiGrX1ZV
	 Nb2vXNtzbNO/NMartFAhpE2gbzDsuB9LYbSm6J5r++1WgundcqC6sFYVX6ybl029wT
	 EzBlCbrwDNUqeBAAV9o5hRUaNs4OasAIwZZuF6OffjAKmAI12TLIVNPbelbHMgYgzd
	 LG2gsHPAB3FmOm9Us2XY9PP9BdOQ3+BTE7BdrwQn4psOkXDhoGMHQ5aSQW6i4zXxH/
	 p5dZ7nn6qF1V9E4cYHYW1+zBqk8h7M2LKVTVfT52ODGxCjVKa0db9qImHK8atSa0HX
	 K9LKS38dJN0dw==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	maz@kernel.org,
	oliver.upton@linux.dev,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	apatel@ventanamicro.com
Subject: Re: [PATCH kvmtool] builtin-run: Allow octal and hex numbers for -m/--mem
Date: Wed, 11 Dec 2024 23:44:13 +0000
Message-Id: <173395688697.2731841.12222331741553553547.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241128135041.8737-1-alexandru.elisei@arm.com>
References: <20241128135041.8737-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 28 Nov 2024 13:50:41 +0000, Alexandru Elisei wrote:
> There is no reason why -m/--mem should not allow the user to express the
> desired memory size in octal or hexadecimal, especially when it's as easy
> as changing the strtoull() 'base' parameter to 0, as per man 3 strtoull.
> 
> Before:
> 
>   $ ./lkvm run -m 0x200 -k Image
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] builtin-run: Allow octal and hex numbers for -m/--mem
      https://git.kernel.org/will/kvmtool/c/2be69d9d4ae3

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

