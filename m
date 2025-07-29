Return-Path: <kvm+bounces-53674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C545B1549E
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 087B04E128A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 21:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F15427A93D;
	Tue, 29 Jul 2025 21:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R9NTTjX+"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E6D17A30F
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 21:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753824221; cv=none; b=R8rIIEiDDWRtqd8dKcVKwSdsF1eflsfKu1dR/ohnoZGTktnsh7BaXsoqAs0RnTgh59dxaEYM9+rVr3ll+QXwQneCT9iGQMV1CkdJXzs+KE+5yXUCwguBKBLhuWCWtTKhdGbkr5U/7JKg5uQ/vWEUWwzllDsUb8lJvvIUTXLl3c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753824221; c=relaxed/simple;
	bh=YPw39hM0XPwwHdZLB+B/18nFgGiAdWO+RbYDk3eDt1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mtvbj1AaNQd4AsnqXvrGdjTkpoA754I0cQvt/qrvYpXHTdGYDY1e97OYJ8mPA5nI8zjQhWjtJ9MdHJ/ut2/P9avowAvbAcvPxn/KR0okJMj37jTBJ6OrU621BzCK3KI6b46ZG+atAs9ixHqiI/VzJXfF+P/nlHrDvoeEjuzT3hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R9NTTjX+; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753824207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbTYZV5A/izXGKdYsYyam9domfvB6oEjtk6O72eaKBs=;
	b=R9NTTjX+rORwT+a6JEIYVzSVkSK/RdLskz6BUNFX0dC5BsyCafVhv2uhz1byrhsymuxQGR
	YPqf6IDP1I3oHmOLby3G/aQ8iLzsfJuE5kx9SeVn3eZ4BTbAQA1QMAQnuJhSDlAVA0pX51
	rCK0mNvbXaGok210uECSnNBoj2j9l0s=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Move bundling vLPI and vSGI to vgic_supports_direct_msis()
Date: Tue, 29 Jul 2025 14:23:16 -0700
Message-Id: <175382415249.3325682.6984441451099105450.b4-ty@linux.dev>
In-Reply-To: <20250729210644.830364-1-rananta@google.com>
References: <20250729210644.830364-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 29 Jul 2025 21:06:44 +0000, Raghavendra Rao Ananta wrote:
> Commit <c652887a9288> ("KVM: arm64: vgic-v3: Allow userspace to write
> GICD_TYPER2.nASSGIcap") bundles the vLPIs and vSGIs behind the
> GICD_TYPER2.nASSGIcap field. While the vGIC v4 initialization and
> teardown is handled correctly, it erroneously left out the cases when
> KVM sets/unset vGIC v4 forwarding, which leads to a kernel panic of the
> following nature:
> 
> [...]

Massaged the changelog a bit. Applied to fixes, thanks!

[1/1] KVM: arm64: Move bundling vLPI and vSGI to vgic_supports_direct_msis()
      https://git.kernel.org/kvmarm/kvmarm/c/7b8346bd9fce

--
Best,
Oliver

