Return-Path: <kvm+bounces-55047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A039B2CF0D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 00:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CA431C42BD9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 22:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EACD35337C;
	Tue, 19 Aug 2025 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BjbrlEAT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B99353376;
	Tue, 19 Aug 2025 21:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640777; cv=none; b=d8WxAZlEGvekLC1U3qtSzQeF0Bbmws/MehRLMvqYhWjYY3lHMte5WfAbomN6dCEPpcyowsLZton9m5gP/y2Q+Wgkri4yrMp9zNrjF+58LROfotBFSwUlB2v/+IL2X/IYxgf6Wnm/GeV8xLoVHqvSeDDaLO0I6dKDqFVVqHl0ll0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640777; c=relaxed/simple;
	bh=qWEusKPlhURpLJlcPDTFMVxbwMtLHKYR/6o1EkX3He4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFOn+NJ2bGDgmW7BVQm3Rx5sngQ8TIclJ2fArZgeeomXWzpCfXV8Tjmr45GFOGnNdaoXYlrRQvVRZ+BeteibDoNc90fH/ZRS8TyYQCBuzTbUHcGF4LAvNxcm3J+V1jDhGV5BpdXdAPRnfcnG7+musCdJVDzYWUOi4RmTMMkd+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BjbrlEAT; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1ED6F40E0286;
	Tue, 19 Aug 2025 21:59:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5RLjIa4A2rMa; Tue, 19 Aug 2025 21:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755640769; bh=lfxFdlVZ2oTJXHiaVZ26hnYSTaWkglVmw0qhMgLkBW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BjbrlEAT3rp9XrVk48VrpjKUMt3hXFDUB0v7Y8oBkd+mMai4XCPylMw0gKd1iW5qr
	 //Ncgi1FddbPqF6iZL5lwAInrMNt7OW+fDArj/U/1fqtriIa75wVU+oFIfLIDWfkg0
	 DtZKtQFjsmL1bIaJg9260gh+cDkjoJJpUclElv9UOEPQBwz3sEwD3qS/dfHywLu217
	 JNMFEeUzIMmJMQJK6fyadYteHmtSTcGvD8Pjq+AY91ajIxUgXQsxTicibhstrX6afq
	 G4W2Ps3dcFLdR0BaiQuZseNY9mLLKDXhQtsBxnaHNW1a6ZYSyEXpDD9O5rqi8jKbQM
	 zljdaYCoSzStB3Lc4xiaMxnKXdT1RVkao2cBma38CgARkS9pu/c4mcUdeYe9fJM8F2
	 9Y11G0CK0qEeJ0kHSZA3P6MO07GaoYFy77h0K1rvEXSyCinGfxOBgiSVoYCvKuASPU
	 4MW1T3t4MZC/+nDMCK11GtRLSSA97CkuBxKFwafXtINed0nrNMwCTT00hRRHnAotw3
	 c16mfl1BKk5CIfDIzmCpTAMrwkiWINGnIx1PLEGoqOcQt7J/NvzyjYdPPON5Qm/EIo
	 DKVH5j04a/k0/IIIpctptmb9AectsHulsGqoUWqskVW35io7a3VFHV8KvkBbintva9
	 Tpa8rfy4+WvbvrEppCPPd1h8=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8B88140E023B;
	Tue, 19 Aug 2025 21:59:07 +0000 (UTC)
Date: Tue, 19 Aug 2025 23:59:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 05/18] x86/apic: Add update_vector() callback for apic
 drivers
Message-ID: <20250819215906.GNaKTzqvk5u0x7O3jw@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-6-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-6-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:31PM +0530, Neeraj Upadhyay wrote:
> +static void apic_chipd_update_vector(struct irq_data *irqd, unsigned int newvec,

What is "chipd" supposed to denote?

> +				     unsigned int newcpu)
>  {
>  	struct apic_chip_data *apicd = apic_chip_data(irqd);
>  	struct irq_desc *desc = irq_data_to_desc(irqd);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

