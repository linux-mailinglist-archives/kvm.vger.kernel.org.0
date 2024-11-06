Return-Path: <kvm+bounces-30883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E3279BE23B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 415191F23853
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D4B1D8DE1;
	Wed,  6 Nov 2024 09:18:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB671D95AA;
	Wed,  6 Nov 2024 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730884692; cv=none; b=c5/xm6T3jqQNV2/Mdp5StgzFQWkr654pXuQLnupHBkzKmZNOFC1n4zW0lIbmVWnZDAgezgiKQG7XQx2/5P6/KkLqGKqWT7L/kyAwxkSQucvdBk2Nd8Lj+zjREnsk1CPP1H2yEtdjJA2G5dWqDfu3YKLHlzPo0LmAN3MHr5Pjs8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730884692; c=relaxed/simple;
	bh=T3omAzSu6MK/PMDopCq5vxosWT3b4zAt0mht2R29VXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XtcPiAENVlpY+NlOReOtSD0ianKIR+Ybs9n35Iy2GsE7ug7NJGjmUpZ5/EifqO2QFInpyoidHtuPzE5OF1Q//gIGVs89jaswCf4cXySsWrCzQzSo7c8U0j5hdAK0fnISBYLno0pbMTRd0R0nkcyttIAUkjrXMfTYqT0mQDSKhQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BFFC4CED0;
	Wed,  6 Nov 2024 09:18:06 +0000 (UTC)
Date: Wed, 6 Nov 2024 09:18:04 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Haris Okanovic <harisokn@amazon.com>
Cc: ankur.a.arora@oracle.com, linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
	misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH 3/5] arm64: refactor delay() to enable polling for value
Message-ID: <Zys0TAHZzqbGst93@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
 <20241105183041.1531976-4-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105183041.1531976-4-harisokn@amazon.com>

On Tue, Nov 05, 2024 at 12:30:39PM -0600, Haris Okanovic wrote:
> +		do {
> +			cur = __READ_ONCE_EX(*addr);
> +			if ((cur & mask) == val) {
> +				break;
> +			}
>  			wfet(end);

Constructs like this need to be entirely in assembly. The compiler may
spill 'cur' onto the stack and the write could clear the exclusive
monitor which makes the wfet return immediately. That's highly CPU
implementation specific but it's the reason we have functions like
__cmpwait() in assembly (or whatever else deals with exclusives). IOW,
we can't have other memory accesses between the LDXR and whatever is
consuming the exclusive monitor armed state (typically STXR but WFE/WFET
can be another).

-- 
Catalin

