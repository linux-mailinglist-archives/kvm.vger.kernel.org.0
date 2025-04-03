Return-Path: <kvm+bounces-42575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 708AAA7A297
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA8683B7239
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 12:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED5B24C69D;
	Thu,  3 Apr 2025 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QhQbQ8Sz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ckbuOpw6"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DA018DB10;
	Thu,  3 Apr 2025 12:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743682426; cv=none; b=eDsJyumtqz7Sh92OG8kJKJTQyf05jdCbHshUZWUITpC31cg8a75g9GTXjHZGLhjEJ8o1GUhFiQgNMGGK33dpu1wtTNrn+vvt0dKY5hh49bU/uLjI+QvDLuqEbWaOcIPXGcWmQUxw9zt5U/b2f5X3FF6ylv7gR8mRJwavpBckBZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743682426; c=relaxed/simple;
	bh=o4xmQBoPc/Qm9H6E04XOQkETeUrxmKyoCzqkS2ZF+wc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ElkyUhTVA1eddPLMqQUie0BG/WO5lok48vK1ByEnLoZZRn0Fibs1T+gkYvI53W90pnlHXz9Auei6Z4ncoz2nraYsy+NPND/yzMxjL7R80lNwcR9m9z45hHzDFyG3SBwu2Sxwyk1yVYd++UwQWKtS1iBkxOQjrs3z7ci+TmfrgOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QhQbQ8Sz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ckbuOpw6; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743682423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7kH0y+/9EMf2LKj/mPOb7ZFXaD9jNKwUGUkxA4+Z3tI=;
	b=QhQbQ8SzGQxJMNouitc7SDGiqHSKSUnpfywcG83NKuK+vUZEwlel31PermPI/zb9eiTyxN
	O6F24n8UNX9Si0BZ2RXFdwCi/H+9nFFeGOdZpkL7a35PF2zIBQK1cC6OFR3ocRwORwE93d
	pz6NHejmJMuek5fhT3e1pWdFixu3FU7LX1LmX1yCoLx4jbHfBitM4QXr766VOPkBt5iRLf
	uZLuU9DbQ/tIlmjLUwiPwqg5qgqEm3ZM66oIe6QQj4crPj7emhvCMaBuA7k8O4WaNKTj2t
	G/HVtQR/+gl2rCL491wX6kw619Y/kVAbsiGbxly9itawe/40eIgsh6MDOg32mA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743682423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7kH0y+/9EMf2LKj/mPOb7ZFXaD9jNKwUGUkxA4+Z3tI=;
	b=ckbuOpw6qeWfRfDi7g+8W4OBdDDz/hFMpMBVIIzSlFYg1YsUgr4k18cxK22/jJMDnGWN3M
	445VXLk100Umx/BQ==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v3 07/17] x86/apic: Support LAPIC timer for Secure AVIC
In-Reply-To: <20250401113616.204203-8-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-8-Neeraj.Upadhyay@amd.com>
Date: Thu, 03 Apr 2025 14:13:43 +0200
Message-ID: <87v7rlv3wo.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
> In addition, add a static call for apic's update_vector() callback,
> to configure ALLOWED_IRR for the hypervisor to inject timer interrupt
> using LOCAL_TIMER_VECTOR.

How is this static call related to the timer vector? It just works with
the conditional callback. apic_update_vector() is not used in a
hotpath.

Even if there is a valid reason for the static call, why is this not
part of the patch, which adds the update_vector() callback?

It's well documented that you should not do random unrelated things in
patches.

You really try hard to make review a pain.

Thanks,

        tglx



