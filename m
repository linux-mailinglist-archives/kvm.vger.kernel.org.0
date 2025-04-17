Return-Path: <kvm+bounces-43559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8BD1A919CE
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B3153AC529
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 10:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18B5622F175;
	Thu, 17 Apr 2025 10:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="j5Pf16Y9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PfgyBIPv"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA22B20C497;
	Thu, 17 Apr 2025 10:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744887147; cv=none; b=UGiZ/1T4WwH8K575ImRd3PsrQDnSZKy1RhNYdWR7YY1RbYBKHUEDD90UJRVFdsr0H5qM0jE4H8sfiev899/l0DxOkvN3h6j6uWZ22vExPJhu+pHfpUqKV5zSVuLUgWfMwFWgIUVMyup5xh4CVbZ4Qa0IKODlMp/SyJEfVPGPAVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744887147; c=relaxed/simple;
	bh=BEtzs8okJ/e2kflQcdV7NHBTe1Gk2en6RLBq4iCBdfY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BIZcD9y6AeFYuSiPbuBS2KRIKgO5f1l/ibbNMnZFz+F2h2HWYQKJ2i4VIcJHmVL3onhQlgSKZudoqEwXFn5Ix1a9BWzvQVpQinDq6Kw5mNwcJ0kdhaS+wESLrFom3tJmTxLnFsPhIZxpIaPulDjZrj6QgnNNSCcpREBiLVWi968=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=j5Pf16Y9; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PfgyBIPv; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1744887144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y55y+LaOlehRwtIz7RGQb2e6+VrpkCQrhq4YYhq8Oj0=;
	b=j5Pf16Y9JiImhmzN+h81RqQ1ALhYmzGJ0+qrxEAZulTkVLA7lDdTPm5GZ/C0ZLQXnrCRQD
	pVNz4lyOcM7y3P6ZIjMEbJ3t0KVwo0SFC1CzQPxO6qpETq1t+XECGSdaqddhiE3bD/37DH
	mIh4c4xmqq20gNH1Oa7zT9FdisQxpDoerZFAGWfkuO/eZKN2R1xhA6mWdBAjzWRLFi2nbN
	wuUEMJsZ+S0KbXuhSlF5VhNGKXGCnQlKUPRckmMar5g0dLZ5uTxqnmuEilu7lkPupT1lD6
	T9reBCGgM30deXy5hAxHlYQXtpW/vL7lgZP+hcvN/z3FPBHMB6ITylJS0Vr9kA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1744887144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y55y+LaOlehRwtIz7RGQb2e6+VrpkCQrhq4YYhq8Oj0=;
	b=PfgyBIPv7vXFXqVDiFDn/QJx5cGNrcDpbK44YXDZw6EdU3klmmzqU/duICGAO+thvgbnL7
	3sgkVI7AuoZG9rDQ==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v4 06/18] x86/apic: Add update_vector callback for
 Secure AVIC
In-Reply-To: <20250417091708.215826-7-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
 <20250417091708.215826-7-Neeraj.Upadhyay@amd.com>
Date: Thu, 17 Apr 2025 12:52:23 +0200
Message-ID: <877c3jrrfc.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Apr 17 2025 at 14:46, Neeraj Upadhyay wrote:
> +
> +static inline void update_vector(unsigned int cpu, unsigned int offset,
> +				 unsigned int vector, bool set)
> +{
> +	unsigned long *reg = get_reg_bitmap(cpu, offset);
> +	unsigned int bit = get_vec_bit(vector);
> +
> +	if (set)
> +		set_bit(bit, reg);
> +	else
> +		clear_bit(bit, reg);
> +}
  
> +static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
> +{
> +	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);

This indirection is required because otherwise the code is too simple to
follow?


