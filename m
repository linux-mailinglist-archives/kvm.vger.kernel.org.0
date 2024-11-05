Return-Path: <kvm+bounces-30805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3EB9BD617
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:46:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44D62283B21
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636CF21503D;
	Tue,  5 Nov 2024 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="QExaPV0B"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CD6215C45;
	Tue,  5 Nov 2024 19:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835948; cv=none; b=PBTF2MBvxp+v5jGomQO6ppXatnDVyziCDFe+lztKvL2h+NBw/OZqTAQXEAgAgW+rC6QmBymnqVP+Bik/Gpg25edL+UKxdDiH8NsPxV0WaZJ/edTMrPypixp8SFLFyfiq/YbPEDaCe4amWT1dwk8cEQQ+zwCkwQYe5sXx0f6/Dsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835948; c=relaxed/simple;
	bh=1U3UU0vNK2UHqlFnB6QG7+izsLRF9HGSgXpwKtSG3OA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mB2N5YZzWCp4kq1FczQGb43EEig5yByPbUcqBVsYi7QtnZMj0JBJWltDDLgrWRIEQ0ruCp/7VNHnpJdo1Nbsl5MOma1F2x2zJoWqc9pVXnnoPJ2wL3EgP/zCbDOmOjM5qyypSxm6iKfurwyUQeS5aGKl60QoH2r2onEmBYai354=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=QExaPV0B; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1730835946;
	bh=1U3UU0vNK2UHqlFnB6QG7+izsLRF9HGSgXpwKtSG3OA=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=QExaPV0B5/PcD8M4wyyQL8ZSAkH2WoSHEwCG2/0klxJX0iv+ArrkvEkLOPp396e/D
	 m+gORqTG38L7ug2odYbT12ywp5Bz8o6bUuXdhAV/j1t2PNijJsfQnzDYDzWpbTdZ4F
	 4VogdWAIEQvMGxg8QW/d2ljyUEjWDBYg1KS7t/00=
Received: by gentwo.org (Postfix, from userid 1003)
	id 7C1A34027E; Tue,  5 Nov 2024 11:45:46 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 7A4F24026F;
	Tue,  5 Nov 2024 11:45:46 -0800 (PST)
Date: Tue, 5 Nov 2024 11:45:46 -0800 (PST)
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
Subject: Re: [PATCH 5/5] cpuidle: implement poll_idle() using
 smp_vcond_load_relaxed()
In-Reply-To: <20241105183041.1531976-6-harisokn@amazon.com>
Message-ID: <aeac3141-c480-52f9-610e-d9d222f3ecad@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20241105183041.1531976-1-harisokn@amazon.com> <20241105183041.1531976-6-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 5 Nov 2024, Haris Okanovic wrote:

>  {
> -	u64 time_start;
> -
> -	time_start = local_clock_noinstr();
> +	unsigned long flags;

Lets keep recording that start value here. Otherwise the timeout could me
later than expected.

