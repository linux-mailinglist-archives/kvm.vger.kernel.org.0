Return-Path: <kvm+bounces-56872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEAA3B45392
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 11:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80791A414CF
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433FA27AC2F;
	Fri,  5 Sep 2025 09:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wpMNqaR8"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820772571CD
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757065292; cv=none; b=C0gBq7j/3Vq1wp7+G9w7TvP9wVCrCoxKDIofPfLQ7e6hrLUaMLPWWBGjxMrFsnRNzIJuogXeDw8guLVs3H9N+YEQfFnMPdqTbJldk1mRqnoNxDkuipjTAF1F3kraRpjz57p32zqKB0z7NDTImgFpQlxLWqeGxE68c4dYz3kpT3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757065292; c=relaxed/simple;
	bh=fUa5NaK+E4wiGm/bgRkC9fh6/Pm+sXfruU2We5KdNCg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qa270o33Hozb9dc/ssbnuZBTuhZgeNlacdNjF9ESWaaWD19BRAA32bN62aC1dKrUB0/dq6i/nVv7DVMj9GG5RLMl9MaiGNHDsoezNF7dGhG/d56bP7iCYHzDjIBQHugckT3O2GxKJTO7CJaHctMknAZCqZoqtY8+mAPBrDkn7Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wpMNqaR8; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757065287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e3f89ee38JzlP4+WgyrG1VSv+60qHAOmRS35v0Ui0Uw=;
	b=wpMNqaR88xSefy6Ul0H0g6t9aY5WxK1iW7rRhQRQnK5gjU++CLwnujruhbgPH4QwmWvnyj
	ZGfTlu/z0rp+4sSm1aemt139jjbh/O3vXo67Bf5oNgjcJg06oRSLxiT/3o3w20WM2dxP74
	uxvIzZPiF9lQDeV4yyP834GcRlgfZCw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Mark freed S2 MMUs as invalid
Date: Fri,  5 Sep 2025 02:41:08 -0700
Message-Id: <175706523465.1669883.14530688411686369270.b4-ty@linux.dev>
In-Reply-To: <20250905072859.211369-1-maz@kernel.org>
References: <20250905072859.211369-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 05 Sep 2025 08:28:59 +0100, Marc Zyngier wrote:
> When freeing an S2 MMU, we free the associated pgd, but omit to
> mark the structure as invalid. Subsequently, a call to
> kvm_nested_s2_unmap() would pick these invalid S2 MMUs and
> pass them down the teardown path.
> 
> This ends up with a nasty warning as we try to unmap an unallocated
> set of page tables.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Mark freed S2 MMUs as invalid
      https://git.kernel.org/kvmarm/kvmarm/c/34b8f4adedd5

--
Best,
Oliver

