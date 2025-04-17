Return-Path: <kvm+bounces-43587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBAFA9230D
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 18:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2A0E464DC1
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 16:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0805254B0B;
	Thu, 17 Apr 2025 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="he/f7u9K";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mPAtkEcJ"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC0117A30E;
	Thu, 17 Apr 2025 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744908782; cv=none; b=SepJoUoluWMCllAuzc68ohYIvUyJR1dY7M9/VVK4+7cRqG7YLPLwloa4ZBTLUfUCmj43ENGryxGLLlaagx3bX6pQWfKgsofSQ2ix4xHcE9Nk5ixcrT/SZzIfmnZk6sewK0VVzQ8kwu4YelfLng+v2YBtDogugOUdJ9DsE7V8xZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744908782; c=relaxed/simple;
	bh=GQjlB9ZQQVx3fg+6D6Zmajd5XJFoVNuSEJm6qm93bkU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sDgi2xvJuuE12RZfCI1e1clc9wvGf+hT2/pf2iZJw8KQavqeV9pBcTlrhF/kPdLXZ8q9vHo4HS5uPg1GUHJziCzGa7xUteaQN5J2I4iknYriRdAKgEgOzPGA3bs1NrB5ZAb55Mvtzk/bqNccSb2+YU9oDoekMfFTWuB87BNXNVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=he/f7u9K; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mPAtkEcJ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1744908779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ilrSYlzAx9iYFVL6md0qcJaDQ6BCvMQ44d5U56I1qoc=;
	b=he/f7u9K5qRzxO1u0lg191NtilNjwQbO4LCYa/OMIgAyczFQurpFr4ksvZSy4fpfQ0fRwm
	063rHKrU3jseAgzCkrg/ghApOnJGmDkI+NX41YQg/JKX5s43dKdFX8hB/z2t6EJzWEyaMv
	0KNI2v11d+cV791Zxw9iO8UwdYbOcI9gi2Em3QAOOmLkXJUY+AU5A7eRLPLIMbgGiQ77W7
	F7gFI4cs5I0KynPr45rjqry0HaEumGispMv+FIDWIfYBQ55u4jpePYQv3lcbJIilTi947X
	CeL7aSdRWqqNXiUA4R8JEn0wgc28Zi2V5JHnCpyDUgshKaFVm5sLH/6GPjkExw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1744908779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ilrSYlzAx9iYFVL6md0qcJaDQ6BCvMQ44d5U56I1qoc=;
	b=mPAtkEcJrNQQicuNCJuc2v1lPrHodX+1R3nx+8J0eGa1Q6jJ2IAK1kwl4BztyPv15fY4Aw
	WFlAP7PHh62GKABQ==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v4 06/18] x86/apic: Add update_vector callback for
 Secure AVIC
In-Reply-To: <f93d3f20-6070-4ffd-bfbb-cd813bb03479@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
 <20250417091708.215826-7-Neeraj.Upadhyay@amd.com> <877c3jrrfc.ffs@tglx>
 <f93d3f20-6070-4ffd-bfbb-cd813bb03479@amd.com>
Date: Thu, 17 Apr 2025 18:52:58 +0200
Message-ID: <87y0vyraqd.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Apr 17 2025 at 17:42, Neeraj Upadhyay wrote:
> On 4/17/2025 4:22 PM, Thomas Gleixner wrote:
>>> +static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
>>> +{
>>> +	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
>> 
>> This indirection is required because otherwise the code is too simple to
>> follow?
>> 
> update_vector() is used by send_ipi_dest() in Patch 7. From your comment
> on v3 https://lore.kernel.org/lkml/87y0whv57k.ffs@tglx/ , what I understood
> was that you wanted update_vector() to be defined in the patch where that code
> is added (i.e. this patch) and not at a later patch. Is that not correct
> understanding?

Fair enough. I missed the later usage sites. Again, a short note in the
change log which explains the rationale would avoid this.

Thanks,

        tglx

