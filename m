Return-Path: <kvm+bounces-42570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 316EBA7A20D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 545071898CFB
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA6824C074;
	Thu,  3 Apr 2025 11:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mop43Q05";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="8wZzKKqq"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6830A241681;
	Thu,  3 Apr 2025 11:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743680281; cv=none; b=RxCyjx32u/ck2j5ZdqYh8ni6ZKs1c5Zu2g4eW/Ka2DM5zy1FHXWL3SP98ZB3NbXq7jnpSj/Dy1+jhZfQyGtmgQFBNgzt4fNTa0kQgtGPItfkble44NEXg3yjwSNnpYZjJVBqLgt8DkqeiqWtTVseDWVYjSa34sBTqW3wmPrnEyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743680281; c=relaxed/simple;
	bh=vJTitEfFPruvOkucxdKAvJOR2FzVAK9kzLlbmUhAEHw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=o2LqRjjlKp1iqCpq2LJSxkY6VNGCDDkGNMnDFlG+9wYXRoJb1+5+SUKx/TaSOg2PaD4bW0eMunqikaCBR6gwo6eT7SlVM9eCspByFEoE3DL0ZS9R4JYElfq8VhdLTKib3gF/QGuJ8vKM6HNdgvrQnwxnVWS8wiXBoVlV76UX2JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mop43Q05; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=8wZzKKqq; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743680278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xXAznvYJBZBGuUGpG9SWrVxF07/vrwO/MB0YHsSJUcs=;
	b=mop43Q05xFxhP50XdE6hqLiAphmDCN49rkzIXNXhxsMaexvhRaiZcM5Wiui9HqaKMemRCP
	2M4K2NyYh+Jv35gPYocvFx84aL4X3O3pB7EXXQr88Soa2ttyUtzFfBDTd7mduXe7jgbQMt
	lKKx4XsCNwvJi6Jiqcaqd4cfGlVr1mqK+mO7muSnI7kBteG9Ga5MfJA4FIjQIQ7stYrVRd
	ZMrKSQowL5U6lONiSKfwWawaA7rt508h/JQuyQIIRzoQ1P/Jm+TYl+nSfPb1+9CRsFI1XW
	d4Mf6nD+A7mPq2+Riy9CRdajh+dashHEXv/PN1Jc4hPzivIjUvA7rAMnHl3Z3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743680278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xXAznvYJBZBGuUGpG9SWrVxF07/vrwO/MB0YHsSJUcs=;
	b=8wZzKKqqMHNDm/1iCEB0DpcpIib3xC5M/EIGlHshGhH7cbw+Z7TQVrBxAe3MQ9xXGZl+wK
	PKeA+FU8XXhY6GAw==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v3 02/17] x86/apic: Initialize Secure AVIC APIC backing
 page
In-Reply-To: <20250401113616.204203-3-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-3-Neeraj.Upadhyay@amd.com>
Date: Thu, 03 Apr 2025 13:37:58 +0200
Message-ID: <871pu9wk4p.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
> +enum es_result savic_register_gpa(u64 gpa)
> +{
> +	struct ghcb_state state;
> +	struct es_em_ctxt ctxt;
> +	unsigned long flags;
> +	enum es_result res;
> +	struct ghcb *ghcb;
> +
> +	local_irq_save(flags);

        guard(irqsave)();

> +	ghcb = __sev_get_ghcb(&state);
> +
> +	vc_ghcb_invalidate(ghcb);
> +
> +	/* Register GPA for the local CPU */
> +	ghcb_set_rax(ghcb, -1ULL);
> +	ghcb_set_rbx(ghcb, gpa);
> +	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SECURE_AVIC,
> +			SVM_VMGEXIT_SECURE_AVIC_REGISTER_GPA, 0);

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#line-breaks


