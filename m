Return-Path: <kvm+bounces-30804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8064B9BD609
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:43:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ACA01F2365E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4808212630;
	Tue,  5 Nov 2024 19:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="GHRsJVAR"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAEB1CCB35;
	Tue,  5 Nov 2024 19:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835781; cv=none; b=iQcoCpXcHu/5ppFhNyGG7jV99ySZd4xTHC1tXn2ncrmic/fFayih9Rz2O+u+Ugm9kMQKC7+OZT7N4pQwp+gh0dphUgG/ZGEZjpyhvHArYZ8ECIQ2rLCvcI7SomiJYPvJNHDunToEUCoysgzTCppnIShx50RumRDlyuhLp0eshqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835781; c=relaxed/simple;
	bh=GiOBrRt8u3pbme+9crDvgrAOmXf8UgUMxXKx4GcDPvs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZoHSYBPwdNIZiwrh5DrMxpTot11UnlR8B/za4Ooz1FQ5HhiD3gA3X5We3jB02udfTJ2S9g/UaEOK3YyFo/1xHau4fKtXJZ2OcO7z6OKt8lttd16jZU7xccm4sLB9vKzSNmYMWxTALjEnGPcXTFWd2H/U96sTbuOfGHVUbEN/5R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=GHRsJVAR; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1730835778;
	bh=GiOBrRt8u3pbme+9crDvgrAOmXf8UgUMxXKx4GcDPvs=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=GHRsJVARCyKaKjxinMOObYFMZjO81KYlxs89D/N6BdPi3basQCsKMRDj2mc+jpOl8
	 fHm9PAKJDm6cjsBwQ8+NERTkezcJsfkp0PIsOOc0k/4emMC3zBWfhG3a6DwU5LsYcl
	 KMpD3PlvL+RDM17VJR+3Q1x4CVKdVo59/pElhBAY=
Received: by gentwo.org (Postfix, from userid 1003)
	id D7D964027E; Tue,  5 Nov 2024 11:42:58 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id D59424026F;
	Tue,  5 Nov 2024 11:42:58 -0800 (PST)
Date: Tue, 5 Nov 2024 11:42:58 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Haris Okanovic <harisokn@amazon.com>
cc: ankur.a.arora@oracle.com, catalin.marinas@arm.com, 
    linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org, 
    arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, mtosatti@redhat.com, 
    sudeep.holla@arm.com, misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH 3/5] arm64: refactor delay() to enable polling for
 value
In-Reply-To: <20241105183041.1531976-4-harisokn@amazon.com>
Message-ID: <efd92a03-f5a9-ba9b-338f-b9a5ad93174f@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20241105183041.1531976-1-harisokn@amazon.com> <20241105183041.1531976-4-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 5 Nov 2024, Haris Okanovic wrote:

> -#define USECS_TO_CYCLES(time_usecs)			\
> -	xloops_to_cycles((time_usecs) * 0x10C7UL)
> -
> -static inline unsigned long xloops_to_cycles(unsigned long xloops)
> +static inline u64 xloops_to_cycles(u64 xloops)
>  {
>  	return (xloops * loops_per_jiffy * HZ) >> 32;
>  }
>
> -void __delay(unsigned long cycles)
> +#define USECS_TO_XLOOPS(time_usecs) \
> +	((time_usecs) * 0x10C7UL)
> +
> +#define USECS_TO_CYCLES(time_usecs) \
> +	xloops_to_cycles(USECS_TO_XLOOPS(time_usecs))
> +


> +#define NSECS_TO_XLOOPS(time_nsecs) \
> +	((time_nsecs) * 0x10C7UL)

The constant here is the same value as for microseconds. If I remember
correctly its 5UL for nanoseconds.


