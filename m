Return-Path: <kvm+bounces-30803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB4B9BD605
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 148AD282447
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384E7212628;
	Tue,  5 Nov 2024 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="gur4LC2E"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4011CCB35;
	Tue,  5 Nov 2024 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835708; cv=none; b=ALxic1yYmvF4MOVM4U/vjENvG5O+z7szwDxXAmPfmXZgsMoU0V5PlRNs1WFEpITqG3+XYJr4EYC3o1TnXYdGc2/DN49XsObXBpn71VnEfCJO64W90Qg5FTn5p9XbwHgGIleLHVLsT8Q/w3F9HiK8frJn1YhQVQni/NfET+e4TL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835708; c=relaxed/simple;
	bh=SHlKYmWrJexsI52/Kyz9hNTkPpxRQSSlSxiJa48ASWg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qtEUXyITZEcSRuhbjmy93ff/MBhfcl5+lkNH53zSWx7BSyWZU/R+2xRNNqVX9FgysBCuSSHvEIkof49sfPOirfQhKhYZ/C0CSS5aDYujCqDmoqMJ0KiJV1BaceJJx+aARBUljzVGFZdvChXUPr1Cc9kscTdjoOn98PuWgVy7Xwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=gur4LC2E; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1730835385;
	bh=SHlKYmWrJexsI52/Kyz9hNTkPpxRQSSlSxiJa48ASWg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=gur4LC2ENdoTLE5NBd9oeUipAzLvjujzbc1S4BDW5aVfMtIYlqZPGj/kxOVfmkdoH
	 Mdqu3peD0iAWAw8ACHJujfjLDLwO8nbRoX00ZBbcdIjYrRlW6TzoabCcl+85JIy6Sc
	 IEkq8PzsnqHjkzf63DkFeNDo4Npki//p9t1ZAKgk=
Received: by gentwo.org (Postfix, from userid 1003)
	id 299BA4027E; Tue,  5 Nov 2024 11:36:25 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 276364026F;
	Tue,  5 Nov 2024 11:36:25 -0800 (PST)
Date: Tue, 5 Nov 2024 11:36:25 -0800 (PST)
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
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
In-Reply-To: <20241105183041.1531976-2-harisokn@amazon.com>
Message-ID: <f46a71b5-8e0f-c2a9-b3f8-d499c10f227a@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20241105183041.1531976-1-harisokn@amazon.com> <20241105183041.1531976-2-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 5 Nov 2024, Haris Okanovic wrote:

> +/**
> + * smp_vcond_load_relaxed() - (Spin) wait until an expected value at address
> + * with no ordering guarantees. Spins until `(*addr & mask) == val` or
> + * `nsecs` elapse, and returns the last observed `*addr` value.
> + *
> + * @nsecs: timeout in nanoseconds

Please use an absolute time in nsecs instead of a timeout. You do not know
what will happen to your execution thread until the local_clock_noinstr()
is run.



