Return-Path: <kvm+bounces-42110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F350AA72E2D
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 11:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 174CB3BC01D
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 10:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BECE20F081;
	Thu, 27 Mar 2025 10:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fUFbo3Aa";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1oG29ihQ"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121FE20E310;
	Thu, 27 Mar 2025 10:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743072527; cv=none; b=tdSFDyHrc+nfZ5PMdv5BnShbhEF1/G9Ohg4m9ePRc2oWEr41WnXKg9C2I1VNtdZo7LQXAlNuoxrPiCIwUAmw+hmjI+P/PBBjYNTNRtDPjxz3v+HWijFnCI7zxz0cbtUV6Z/Wjp9bvGkjpSe4NBFqWHy8g04SZNLkvTM8rGjBVzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743072527; c=relaxed/simple;
	bh=rqiLxa3LoJityHTuB4MjjQsNYv2rE6IlF2K5fEOK4UM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XGG2P0R6KuZaYeuo00+xQ0r5fpAUci7s7xQ/ADponLP/hfZ+j6M4r50d0u7X+zqhvKzBBuZBGyUQAxw/2KKgErv/ELaOJtJvUhrMvycrLgzOJVpvTJYaX5o98OGj8BcdRZxrqqxOmCs1s9xKWWn85tQHW2GCzDxJhTePl4lubRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fUFbo3Aa; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1oG29ihQ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743072524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LAeMRv1C0Anp07/ivFTaDKaXblAFGG1c20rodL/9wK0=;
	b=fUFbo3AauL8FJJoNRFAWfroTkAx2uqqHm5QWCOzzVlGq5TlJiu2In3zWIOa2NGXrSZbwO2
	HQtapq8XnQ0CM4sEXcB/YsOsPX2ALH5M/Q28GUmYdo355VX3PFi4fyWsdipk+2rTe4JWgN
	BvOeNllyodMlo3Ls0eupbSUBc9ZV+wCFz+k7YeHxGqe2460kOuLJPNgYRP2GRXwgGpE3LS
	ismiYaA/Dh1sm/srICBjlzYXRZ9vw8oD8CKdyraQaaQdbslK+R/oqPjZDZpVGPdGnPAjN0
	kBhyWCpsmgpqtw65KLx4ii3eIKsb42pwsqICIoZtaF8QUP0WN3moIQrSmCI1bA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743072524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LAeMRv1C0Anp07/ivFTaDKaXblAFGG1c20rodL/9wK0=;
	b=1oG29ihQMjn1bVUJNrwK3isHy/Dn9egfQtT/YhP1g18lWkeG8uUJCnNSP1+M8wFgQXpDuf
	wtY7/lWNRddEpIBQ==
To: Sean Christopherson <seanjc@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com
Subject: Re: [RFC v2 13/17] x86/apic: Handle EOI writes for SAVIC guests
In-Reply-To: <Z92dqEhfj1GG6Fxb@google.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-14-Neeraj.Upadhyay@amd.com> <87cyea2xxi.ffs@tglx>
 <Z92dqEhfj1GG6Fxb@google.com>
Date: Thu, 27 Mar 2025 11:48:43 +0100
Message-ID: <87y0wqycj8.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Mar 21 2025 at 10:11, Sean Christopherson wrote:
> On Fri, Mar 21, 2025, Thomas Gleixner wrote:
>> 
>> Congrats. You managed to re-implement find_last_bit() in the most
>> incomprehesible way.
>
> Heh, having burned myself quite badly by trying to use find_last_bit() to get
> pending/in-service IRQs in KVM code...
>
> Using find_last_bit() doesn't work because the ISR chunks aren't contiguous,
> they're 4-byte registers at 16-byte strides.

Which is obvious to solve with trivial integer math:

      bit = vector + 32 * (vector / 32);

ergo

     vector = bit - 16 * (bit / 32);

No?

> That said, copy+pasting the aforementioned KVM code is absurd.  Please extract
> KVM's find_highest_vector() to common code.

No. Reimplement this with find_last_bit() and the trivial adjustment
above and remove find_highest_vector() as there is no point to
proliferate a bad reimplementation of find_last_bit().

Thanks,

        tglx



