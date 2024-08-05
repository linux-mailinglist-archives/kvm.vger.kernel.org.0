Return-Path: <kvm+bounces-23292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E26F5948686
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 02:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19A341C21750
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAD9A47;
	Tue,  6 Aug 2024 00:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="XFWsAmJf"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D080625
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 00:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722902917; cv=none; b=PvfT4CFxl/BRvfv3AwTZhEbcczQzll2VfdpW6xF6WyduPtSaCTVLRxDvamnjvis99Dsdk/e0YdLKLK1TbPNvxk9aVdz3t0CZF93D4ZZGMtv3uUb4v4wfeauJ/6bl1tj/Zqr0cFI3PnzX3bQCrTSR4gX9BwZe4FPp73LS3/WUfYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722902917; c=relaxed/simple;
	bh=CRfVICL5JRjRRAVIb3Z0/r0y0frJpIGoEA8vpvNR9hU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=e0zTb7TSjasMtvP692tQ87JRGafmEZjZihzKPJMQpP9GtPWl7/RaRG+hQhaUqabU1vzNVsFTaYWlbuv7tpfU9u4aYy7pky+QN0hq8cbORilVLDh4/738kMcA5Yq7lqrPQ8f3cqfgE2PAe9Z8xMtPiCTdNQWySCcjDU8dH11Xv4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=XFWsAmJf; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1722899623;
	bh=CRfVICL5JRjRRAVIb3Z0/r0y0frJpIGoEA8vpvNR9hU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=XFWsAmJf3N/CEbEk1h0lu+oViCnvi3U5tOwacWQ/pPMfTzidqOuIcvyQXurbksxNL
	 7+64VlC20WnKuIhcK9KKz4xKz+Su6o2xh9NtEL8+G3HIDaugsRdc5oc+ppr1n4FYnQ
	 MNCskYkIIa6t00/aU03X40MizMLKv2Kk6jjK+bT4=
Received: by gentwo.org (Postfix, from userid 1003)
	id BC80740404; Mon,  5 Aug 2024 16:13:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id B889D401CA;
	Mon,  5 Aug 2024 16:13:43 -0700 (PDT)
Date: Mon, 5 Aug 2024 16:13:43 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org, 
    arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com, 
    mtosatti@redhat.com, sudeep.holla@arm.com, misono.tomohiro@fujitsu.com, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v6 07/10] arm64: define TIF_POLLING_NRFLAG
In-Reply-To: <20240726202134.627514-5-ankur.a.arora@oracle.com>
Message-ID: <5bbbba0e-b4c0-eb8b-a7f1-8483847e0397@gentwo.org>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com> <20240726202134.627514-1-ankur.a.arora@oracle.com> <20240726202134.627514-5-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed


Reviewed-by: Christoph Lameter <cl@linux.com>


