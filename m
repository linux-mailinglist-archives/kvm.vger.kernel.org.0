Return-Path: <kvm+bounces-56684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88916B41E76
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 14:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D075B1786FB
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 12:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BDA2E62C3;
	Wed,  3 Sep 2025 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xw/Zxpln";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jPYvEOdC"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A3E286428;
	Wed,  3 Sep 2025 12:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756901277; cv=none; b=SISwV4tDD6y482C6+gWp7usnl40MtZMgain3JiHCL8h6dDyxf/yhg6AlB4kKQPEROpIX17VrhMfeEQIxCsQ2qR6hcKtyzckkvIGRezO1zFxaZVozjraSFSJsM3IuexXkn0qydZNoEbmypeWvWDjv6Zf5f6VmMn5ecGBJiSM3LUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756901277; c=relaxed/simple;
	bh=IedR9gLTqIst+0+I6/rCBWY1cT0eeORo9UueU/viVUs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nz1SS4VWWjYsl+JHs65s7Cpv2frTgbqmpDY40uWzApbOOm8VUhMje6n5ZCORKgLMzpETNHMolgeLiE23In4zrIm0kYgYYhNgGUgy0TPEloZVrMyolikxJCiKNj0PBPTRz0bBZPnSNgwd6mVo/UTt2HG3VMMyU05o2QFxMRba6Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xw/Zxpln; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jPYvEOdC; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756901272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IedR9gLTqIst+0+I6/rCBWY1cT0eeORo9UueU/viVUs=;
	b=xw/ZxplnLljYchtWLlcn8/J04+jjSWmOTBlUk/gySEikZE1mr57Wbp1d7/9uobUQVXr1Re
	PC9yMoasYgYWcYxeqatqpDgKLJmb40+9epAxAishKhajLizLCIN9729JQvO7m/3rmiu/NV
	c1bV6U/02I5tY7qN/w7XgBt89Kxh8LGPRpfwRKpL97zHuWBXP37P1ZxEGB0m1Mk3lizpPw
	ElIIjQbOpvCqDh65s6WA1OPxwtBnkcofkLE4U9Ke3iJyyxI25x0bc/0CMoV/l8QFoo7phX
	SKcImogCcFIxEKkB14R83VYNQa+wb47PrXeePbZm74VoH2n9SMxVYLYSwg4NKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756901272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IedR9gLTqIst+0+I6/rCBWY1cT0eeORo9UueU/viVUs=;
	b=jPYvEOdCiB5SxSTGT9FwgczyLLPEoJxm5A6QgwYbgaVy+O/K2p/7OfoPcRKZ0HSfnwhFHD
	iXWyk916Zaz6ZXCA==
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Cc: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
 <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
 <will@kernel.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 5/5] irqchip/gic-v5: Drop has_gcie_v3_compat from
 gic_kvm_info
In-Reply-To: <20250828105925.3865158-6-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
 <20250828105925.3865158-6-sascha.bischoff@arm.com>
Date: Wed, 03 Sep 2025 14:07:51 +0200
Message-ID: <874itjzqlk.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Aug 28 2025 at 10:59, Sascha Bischoff wrote:
> The presence of FEAT_GCIE_LEGACY is now handled as a CPU
> feature. Therefore, drop the check and flag from the GIC driver and
> gic_kvm_info as it is no longer required or used by KVM.
>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Assuming this goes through the arm/kvm tree:

Acked-by: Thomas Gleixner <tglx@linutronix.de>


