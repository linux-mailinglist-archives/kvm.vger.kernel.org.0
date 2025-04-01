Return-Path: <kvm+bounces-42397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06983A78259
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFD933B1563
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A4C214A94;
	Tue,  1 Apr 2025 18:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="h9fDWAkB";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fDLxMtRS"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B6C153598;
	Tue,  1 Apr 2025 18:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743532274; cv=none; b=lBHf667Tr068zRy7jBhF2Ht1cLKLnB8kFVN8Mw+lhdCl5CI1inzs4ioyvbrhoMIPLU+z9rNVIA7DRlBKSc/+Rr0OTC/kSNvXavmSEcYfAwcmXiADahboJFW0cGOqh5MoSZtTVTalZ8cZSPxti6C7rkT6AWaFuuk1dJCVnWaWR1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743532274; c=relaxed/simple;
	bh=Zw1izjCfOwlh66OfK+lnyQFpEdYj+S4kEB+O4qIrc7g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=czsa9SENllxB/EJSaBmrPY+VIWoNVGZDGd6QvD3HMPQ0ItWRYDqcTsld6MMtvQtHPCd1Owd1T2baUJ5S2N4lCKMUGunUf6jzhs6CZspLlyemcEQYVtbiBArbI/pP5DZ89H5T5LBDkpPRH5aiOH35ZSfHOHu6HLWC6adbqx0XaPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=h9fDWAkB; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fDLxMtRS; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743532270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NbtSL3VPOBfsPXeB8rckbl3H8XFA+UIU2LG0RUBSkTs=;
	b=h9fDWAkBMF+VjsgUpYcW6QCjoC9IHmVaUioy5bZeSUYh8E5d5J30IN7wGIUTuW3rcQFXCH
	uVY8n4WJcVLWFiFwkRFdtFFGbwLusy80yey7H/JrnlmOO7zcsZUtJSeOSwXYi2QnxlnqNB
	hd+/IcI/2ezsPFZU2UawzxUxiENMn4GaU5JkYWz9vUbR+YB6FQN0167rcs1Gq+eTJEJBzQ
	DenyO6HkYybFNfeSFbTXR/v/K6eeTnoyZbxc2uWVTj2/P1Hpl1oAmmXwAI+HaEl8gtrA5n
	PTyvvSnOEm+hEfwaZf9nVPuGuoDjvyKVatUH2BpMOLyo/6eVDmAECgKQVMkeCw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743532270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NbtSL3VPOBfsPXeB8rckbl3H8XFA+UIU2LG0RUBSkTs=;
	b=fDLxMtRSyPrzzJCaEGiR9nmIH2SAL2xzae2ITY3u0fjfDzFnUKRet/47AZ1eHYPUJL/fzz
	OoVwKdIuVEOHfBDQ==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 14/17] x86/apic: Add kexec support for Secure AVIC
In-Reply-To: <be2c8047-fd68-4858-bb92-bf301d7967b4@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-15-Neeraj.Upadhyay@amd.com> <87a59e2xms.ffs@tglx>
 <be2c8047-fd68-4858-bb92-bf301d7967b4@amd.com>
Date: Tue, 01 Apr 2025 20:31:09 +0200
Message-ID: <87frirwx76.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 01 2025 at 16:05, Neeraj Upadhyay wrote:

> On 3/21/2025 9:18 PM, Thomas Gleixner wrote:
>> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>>>  
>>> +/*
>>> + * Unregister GPA of the Secure AVIC backing page.
>>> + *
>>> + * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU
>> 
>> Yes, -1ULL is really a sensible value - NOT. Ever thought about
>> signed/unsigned?
> 
>
> In table "Table 7: List of Supported Non-Automatic Events" of GHCB spec [1],
> 0xffff_ffff_ffff_ffff is used for Secure AVIC GHCB event
>
> "RAX will have the APIC ID of the target vCPU or 0xffff_ffff_ffff_ffff
>  for the vCPU doing the call"
>
> I am using -1ULL for that here.

Which is a horrible construct, while  ~0ULL is not.

