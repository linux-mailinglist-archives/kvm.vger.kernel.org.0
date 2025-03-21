Return-Path: <kvm+bounces-41673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60294A6BE6E
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 375F51893652
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5671E8350;
	Fri, 21 Mar 2025 15:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="o/Fh6siw";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BDQ9UQEx"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577761D7E26;
	Fri, 21 Mar 2025 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571709; cv=none; b=jCTNoYaWX1SQu1T+BOec0OJiEeGB/hBkvTlGIy0WCsPLSm/zSUKYDXBDrBvtbAsmLhxFhrT6AJrSjBtR33nuCuxpWLpoI8aG2JZtwuX8YJFPG2XzDqmdyzG0E4F048mPEKhiJTSEuWSRzKTLDCv8UF99I0xi9u7dCMbZrv3gJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571709; c=relaxed/simple;
	bh=lepf8SgHrTfe1+ix7JUQSfrVfe1KdewT9tHWFaAEFrI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lBXqG4PluhSresKf79tyshMWtSf8ZlZoC68zmd0ta/HiV/H/6pq3lpAqPGbi6tQDsZOTlX6gdUew1vy9ODj6E+UrerVZnC56lz2USNW+rwJqYEE1KWATuCLv2/QO+ZpcLISCRbl9cQUz7uK2HcEVkUjM+QD7b0R67bl+UphFRJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=o/Fh6siw; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BDQ9UQEx; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742571706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p5wFTHKX5r7DdezRce+0vHw6f59KXToZqztHosyD/2w=;
	b=o/Fh6siwUff3Zd1JnZ3RobS3awjHunPWYS5qr9Y2MGJ4xwXsEhxC2rhEi9ZhValtyRCVMk
	7M+GLPNSx8rjuZWIsuWzDOsG+Ro6lzUiM32ZoXWK02PPrRLzBy/XhSik9FU3zHR/mrCOdO
	AfaeyRWMx5q10VSvaAN52yLYXTaL/LpYaRammhQRQQK0JSN/vuhZ5mkDuVN5x2WOU1ghQ3
	bxpxOsVEACgc4zjn1elwZxbkJoVoYxi2wtMzaZSvYcb6Pf8PXH3H+URCYKfj6WRrzK/OjJ
	MgEo5DCLEJV/KkgokTXRIHT68UVIkN5d+n0E/G3OUvunn0x0JuY5/reOD2oJvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742571706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p5wFTHKX5r7DdezRce+0vHw6f59KXToZqztHosyD/2w=;
	b=BDQ9UQEx/p4hDR/LyDlKu0j4l9/phyRn6u0UPr/etNRI9gKUblx7YDFQnc3Uaop1Ti8eTe
	pSpZMoIn/lhhXNAA==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 13/17] x86/apic: Handle EOI writes for SAVIC guests
In-Reply-To: <20250226090525.231882-14-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-14-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 16:41:45 +0100
Message-ID: <87cyea2xxi.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
> +static int find_highest_isr(void *backing_page)
> +{
> +	int vec_per_reg = 32;
> +	int max_vec = 256;
> +	u32 reg;
> +	int vec;
> +
> +	for (vec = max_vec - 32; vec >= 0; vec -= vec_per_reg) {
> +		reg = get_reg(backing_page, APIC_ISR + REG_POS(vec));
> +		if (reg)
> +			return __fls(reg) + vec;
> +	}
> +
> +	return -1;

Congrats. You managed to re-implement find_last_bit() in the most
incomprehesible way.

Thanks,

        tglx

