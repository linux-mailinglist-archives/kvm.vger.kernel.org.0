Return-Path: <kvm+bounces-43586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6174A92307
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 18:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A7F93AD0B5
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 16:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19962254AF6;
	Thu, 17 Apr 2025 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="oXLodcQ1";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bRfd1ZBV"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBFB2248AE;
	Thu, 17 Apr 2025 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744908722; cv=none; b=En9DZzXlEOfbclYvPLaKrPyPQzBLBBw99UTeaamZjeHYn+S1EcUUnb0dgzRn+nA0fIqh1yV81WhZ2UzWByc9bvzK7sTETpFeqdoUtDqFImc95h4CGzNfphHhUllgWJVq3+EULmFAaFzqmog6O/CRvnS5x2qMK1Tr1PctcLkaV6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744908722; c=relaxed/simple;
	bh=bFizTWUd6DP+23hJ/Fy8oI9/olpqY8UkA3bPWOlKBU0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p6u/2tVjpk/+TGzeZMApiKnpY1z9PTyUENcjosHAY4Oau4PI6FbOZuRn/B3giPrJjeS6VDEq+haAjZBe9YImGwSjmwYdTeNtQiIobMFNJ64XtYhYpiYNpZo/BWcMEe2MhMXYnnvGAfQ4eoz8VoBIEIgt782X/dYVhvDCCXHK1/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=oXLodcQ1; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bRfd1ZBV; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1744908718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pR2gVrjV1ITyM5ld6XjbQulfk8RlheA5YgiTJtBzmoA=;
	b=oXLodcQ1SJGQWvq5tuEKnMKFfevf7WPibT7GGA86dKTJseoZjh1oDqPum6Erq1dZUrONuS
	FVYDNL70hsISKFrsCZ7hRBtmpcld6rGzh8R8/QU4b5D1sXWQjGeyCkJzDgEpfcA+xQwnQo
	3dw4m/PRYT/yangxV/3kqBkxohtDiC5KYWxAC4V7EnLQcrjO/MiOUQPJ2eGixq4dfhXPPF
	3JQB2QWVvSwW6uVKMqj/GwMceDvAvy7rSV6EIv5VtFIBdcdGqIgjFoPwfzl5kgWUQhNFRe
	GIpPMG3/IGwXo9wEuRDFDiuJ6XGIqzsHm2dWNz6lhTVCOBYyygSsR93V+/01NA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1744908718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pR2gVrjV1ITyM5ld6XjbQulfk8RlheA5YgiTJtBzmoA=;
	b=bRfd1ZBVxlUBhWQRklZ3kf/Ixo+nAr8dEt2cl0wQfhAjLiqg8iLnko31h8QsEE19y3TdlC
	12VMhSSa3euba1Dw==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v4 06/18] x86/apic: Add update_vector callback for
 Secure AVIC
In-Reply-To: <be31db14-9545-4d11-9392-458782e10b48@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
 <20250417091708.215826-7-Neeraj.Upadhyay@amd.com> <87a58frrj7.ffs@tglx>
 <be31db14-9545-4d11-9392-458782e10b48@amd.com>
Date: Thu, 17 Apr 2025 18:51:57 +0200
Message-ID: <871ptqspci.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Apr 17 2025 at 17:30, Neeraj Upadhyay wrote:
> On 4/17/2025 4:20 PM, Thomas Gleixner wrote:
>>> +static __always_inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
>>> +{
>>> +	if (apic->update_vector)
>>> +		apic->update_vector(cpu, vector, set);
>>> +}
>> 
>> This is in the public header because it can?
>>
>
> apic_update_vector() is needed for some system vectors which are emulated/injected
> by Hypervisor. Patch 8 calls it for lapic timer. HYPERVISOR_CALLBACK_VECTOR would need
> it for hyperv. This patch series does not call apic_update_vector() for
> HYPERVISOR_CALLBACK_VECTOR though.

Then explain so in the change log instead of letting reviewers
wonder. I'm patently bad at reading your thoughts.

>> Now if you look deeper, then you notice that all places which invoke
>> apic_update_vector() invoke apic_update_irq_cfg(), which is also called
>> at this other place, no?
>> 
>
> Yes, makes sense. apic_update_irq_cfg() is called for MANAGED_IRQ_SHUTDOWN_VECTOR
> also. I am not aware of the use case of that vector. Whethere it is an interrupt
> which is injected by Hypervisor.

It can. The managed shutdown vector is used when a queue of a managed
multiqueue device is shut down. The device MSI-X entry is redirected to
this special vector in case that the device/hardware raises an
unexpected spurious interrupt post shut down.

Thanks,

        tglx

