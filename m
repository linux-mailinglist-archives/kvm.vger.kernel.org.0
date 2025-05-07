Return-Path: <kvm+bounces-45698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50611AAD95E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 10:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5EC13A6898
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C6F22173E;
	Wed,  7 May 2025 07:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="azLg/sI8"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EAC1C6FF3
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 07:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604632; cv=none; b=ruBYTTPoDui5X052YGjZgJZblA1gA+vXtYgAibYNZGqZOt4/ukzGFyuM9s7rRmis1t1GL+mV7dh8KQi5GH71m5OGKFB/L8QwnYzCspJRsvtPfC5xVgRnxfVLuel1QvgA7m+IhySMJXOnZ76xAv9HCGL28v8ArnDesX1vwZQeRDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604632; c=relaxed/simple;
	bh=A4KqFUfiMWSBY37pZWbrLNHyowfIzlyC7+VB02RvYZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IOl7a+PUWacOIdZlqciRMUjN/83r4nd1vd+2G2aFp/4JjSdo91duNl+HEHv9KurjAfo/+4brYA7KLfujAvwjcjUycCK3i7B6UN0Nv1ENqoKxJ++zpqJ99PQNx9qat7qNWNpDZBwgipatzwhr+/dLDK4kMOPuzwEEjEEbs52smtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=azLg/sI8; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746604628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x/jWrb5ObufWdp/TqLTqFq4iyOq4wwysHakUs6xba8E=;
	b=azLg/sI8sSK0Zi6OEV5H7j14UusXX4bvQhsXMag0nu0Hvv+9jCRS1yP9o2QRAxkPvc0fyX
	hChtum8TT4F7JzgcLJGFAyGeYiGvkWQtVM1QZNiAh/nUo5yKRThfJvX0UlpV8y+oGbIzV7
	/8a3yOvmr2ixCv/CLkcPNlNCCpYPqHE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: Re: [PATCH v2] KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
Date: Wed,  7 May 2025 00:56:50 -0700
Message-Id: <174660459087.2542293.11599535036974656323.b4-ty@linux.dev>
In-Reply-To: <20250429114326.3618875-1-maz@kernel.org>
References: <20250429114326.3618875-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 29 Apr 2025 12:43:26 +0100, Marc Zyngier wrote:
> We keep setting and clearing these bits depending on the role of
> the host kernel, mimicking what we do for nVHE. But that's actually
> pretty pointless, as we always want physical interrupts to make it
> to the host, at EL2.
> 
> This has also two problems:
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
      https://git.kernel.org/kvmarm/kvmarm/c/859c60276e12

--
Best,
Oliver

