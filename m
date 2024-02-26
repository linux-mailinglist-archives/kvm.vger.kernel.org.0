Return-Path: <kvm+bounces-9939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 192DE8679DA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A00B0294B81
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F6E12C53E;
	Mon, 26 Feb 2024 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Uq5KAJLc";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="gTs37Py3"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B5A1E525;
	Mon, 26 Feb 2024 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708960208; cv=none; b=IeVr1rv7Eb9xCG8fYqQk76HIBuuLrOHi8AZEFJ/dkh31VWG4/hWFKQiA4v1V8ZA2kcnAVKOGekWQUUcTn86eq/IAK0NN1SFT//kfmBckKqC5J8TxopwkKlwwYkFaCYeOVPVvNGbVCg7AKHcVp1OfR3A3vtR77nUYuPgahGd5V1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708960208; c=relaxed/simple;
	bh=C0ZwnQmP/kh2aUrDS6fDXoRaWozBz0fD5wPpQnqCPKI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nt+mIxgzKkfdU93HWkHY50AIZUTzlVs2TVjuuTnBP/OktnfSJ62NjYFEFEiNfHCAVvgsFW9+g/eMtuO+2GTrH/V6ItGhL6DNd18qh8CGAs5R6OipE7V8mUmDBGut0yOL0w8pRNSKTa04ceBWnJB1op2fyomS/LbfR97osl9r6n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Uq5KAJLc; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=gTs37Py3; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1708960205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Np64UFrlcA1zUiScJ++rAWu+Ye7rIko/mCcLVb2aFho=;
	b=Uq5KAJLckHXqr97Gny1FQ4D/YJkTN1iuUfrLuGuAaoF7pw2hpW+cwp9xfz3srpl79PoTKq
	UkXU3luWYY+jHOlizNbF8zohLwD6WBXjkVZ3l8Bc4uqa0Zj9ygQPxCCANvGFvP4+526nMX
	X4/hsvvTFU8V78XgCBeoLQ1XN56BrESxLYyRMxJH0aN0VVfePsZfOlEy8CvAxb8byRtXQ/
	vIIwFxM8/GoLG+3xx5sHKNdtOp6Lqtrxg2alvTEIQo6P3FeEGyIwFGvOxOqwwp0mER01br
	kqtDd7x90rlR8a9h6AIbaC4zPfPNm76KtGyUTP9N7o3AvL1n/AsSfiOx/X8OgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1708960205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Np64UFrlcA1zUiScJ++rAWu+Ye7rIko/mCcLVb2aFho=;
	b=gTs37Py37j7g18u29ubSzzjjG8e+Ddfm6z8kHtO8x4tD+MUcC2HMtlcgHzmWfe6s+ci0CD
	hf+bQyc+7HwBpFBQ==
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: x86@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, Xin Li
 <xin@zytor.com>
Subject: Re: [PATCH] x86: irq: unconditionally define KVM interrupt vectors
In-Reply-To: <20240223102229.627664-1-pbonzini@redhat.com>
References: <20240223102229.627664-1-pbonzini@redhat.com>
Date: Mon, 26 Feb 2024 16:10:05 +0100
Message-ID: <87zfvn9s8i.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Feb 23 2024 at 05:22, Paolo Bonzini wrote:
> Unlike arch/x86/kernel/idt.c, FRED support chose to remove the #ifdefs
> from the .c files and concentrate them in the headers, where unused
> handlers are #define'd to NULL.
>
> However, the constants for KVM's 3 posted interrupt vectors are still
> defined conditionally in irq_vectors.h.  In the tree that FRED support was
> developed on, this is innocuous because CONFIG_HAVE_KVM was effectively
> always set.  With the cleanups that recently went into the KVM tree to
> remove CONFIG_HAVE_KVM, the conditional became IS_ENABLED(CONFIG_KVM).
> This causes a linux-next compilation failure in FRED code, when
> CONFIG_KVM=n.
>
> In preparation for the merging of FRED in Linux 6.9, define the interrupt
> vector numbers unconditionally.
>
> Cc: x86@kernel.org
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Suggested-by: Xin Li (Intel) <xin@zytor.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

