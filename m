Return-Path: <kvm+bounces-29625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0009AE42C
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1419D1C22C27
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E855D1D0DD5;
	Thu, 24 Oct 2024 11:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Qx5ZVtgo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719C3170853;
	Thu, 24 Oct 2024 11:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729770591; cv=none; b=oksSJvAxW+nzOKuuVjMX5W0+L/XRWOKJn2EJpGh0U1522S+feymSi1TFMCDGuZ0y5togefpDgXtz1Efv6YHbbLJNIDqeQ1aTd2Gnb59TJ6uGrU7atVXtDsU05nVhCm6GI4DgtgQmTnzwhpJekdOy39FOev7LkIXDK6hCKbKvfik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729770591; c=relaxed/simple;
	bh=VbZ78Ol9IT+t2IlEXHuCD+qVCzE5Fs3KW5BPehToQj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S12lvaxhd5Ww0iydWiPae/NB6h3dnvRzVoi+IPUjNi9x4EgEJhD4HaTpXmVgAA2JHCqthIu2N7XO2bWJjwgdfkfG+8teon+t541xVXkWFFf+19WTMMHTKN+OFlKAENJTegDKMfYBj8YSQFRZMNKVeZ8gJxlxHEOuxXPRZ6vS3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Qx5ZVtgo; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9F99140E0198;
	Thu, 24 Oct 2024 11:49:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1_QoP_aj4980; Thu, 24 Oct 2024 11:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1729770576; bh=wEQtHOaZ7+6zm6ZVhufBrrygdh+rqbRyaAN0gvYGngs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qx5ZVtgo+Q10F8lUuT3gI86+AMnuOvyOV2RcSiG4ucdNCD7vdrq7f/C/k+EO2+Fif
	 WYEwTRsZgRWDr7nrvlxl8Fagl/4BqnRX1ZEYbimKS8ZJfefqwwiRzdGQsomZIfJyJI
	 lvNYauMRQn4gZnGLcK7iub7rFGqoRdbz9gPHnHCceFXJEdUfl2WF9rsuyAFnhxPrBa
	 61ye/gOqYPIDvB4B50/J/mYl/8NNrncsODqEoo5GY1LY2SbFQu10Gd/+E2XA1jsKPK
	 rf9lRsmOcSpTU/On1gzcdDwWtmQoVzwQnRVxrt2DAZh2jNaaJEQGly6lOyRq+x/Exi
	 +9vkuV+Ktvu0r479C8+dUqVLXzSsNa6B0awmEQtp+7JUcxgdvZF+iUgELhlqRmlZIg
	 lEgRGqYMzoDvxO4fji77yi3s0/KehjDHmTqH6SAEaj4xPQtAP8zvaU4VbjeL1Obu9t
	 M9TfdO84Lh8j6h/r34/oShhAljwYGorVwglnlACWWo/EqoXj4e95P3PQ2WlRZoUs+O
	 mSdsvueRkhHN7s0NQrNBXk4lbytXaNhNM4MQ9Q9rGQ4g/JbHB0/mD2m5Bx2Xp6LC34
	 LItT4zzkmrsaWevqoaEcoShGsXSQZJY2mj93BM57NgpqJT5LK09QWNW9Wl329Fl8lT
	 I+1hkjmzz/6mEQoE28tEMU3I=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 00EA940E0191;
	Thu, 24 Oct 2024 11:49:17 +0000 (UTC)
Date: Thu, 24 Oct 2024 13:49:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
Message-ID: <20241024114912.GCZxo0ODKlXYGMnrdk@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
 <4298b9e1-b60f-4b1c-876d-7ac71ca14f70@amd.com>
 <2436d521-aa4c-45ac-9ccc-be9a4b5cb391@intel.com>
 <e4568d3d-f115-4931-bbc6-9a32eb04ee1c@amd.com>
 <20241023163029.GEZxkkpdfkxdHWTHAW@fat_crate.local>
 <12f51956-7c53-444d-a39b-8dc4aa40aa92@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12f51956-7c53-444d-a39b-8dc4aa40aa92@amd.com>

On Thu, Oct 24, 2024 at 09:31:01AM +0530, Neeraj Upadhyay wrote:
> Please let me know if I didn't understand your questions correctly. The performance
> concerns here are w.r.t. these backing page allocations being part of a single
> hugepage.
> 
> Grouping of allocation together allows these pages to be part of the same 2M NPT
> and RMP table entry, which can provide better performance compared to having
> separate 4K entries for each backing page. For example, to send IPI to target CPUs,
> ->send_IPI callback (executing on source CPU) in Secure AVIC driver writes to the
> backing page of target CPU. Having these backing pages as part of the single
> 2M entry could provide better caching of the translation and require single entry
> in TLB at the source CPU.

Lemme see if I understand you correctly: you want a single 2M page to contain
*all* backing pages so that when the HV wants to send IPIs etc, the first vCPU
will load the page translation into the TLB and the following ones will have
it already?

Versus having separate 4K pages which would mean that everytime a vCPU's backing
page is needed, every vCPU would have to do a TLB walk and pull it in so that
the mapping's there?

Am I close?

If so, what's the problem with loading that backing page each time you VMRUN
the vCPU?

IOW, how noticeable would that be?

And what guarantees that the 2M page containing the backing pages would always
remain in the TLB?

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

