Return-Path: <kvm+bounces-55620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 422C2B34484
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CD79188BDF6
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 14:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CCBB2FB610;
	Mon, 25 Aug 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VkFcRY7l"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F243147;
	Mon, 25 Aug 2025 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756133402; cv=none; b=SHwC7ceIQIseIvH/QaGO1gM6iYK9T0BfHeJJ/SzPiRdENG5cyU1qC8CsOytOr535hvQzZ7nWd7SddXkXmkeObZqpckfn8hM2JDBL1A8aT6DcFAomm1R9MvmPQq5GU2B2iDOlq/c9BYvKmV8Z5o8n+ka71oHeRxVtm1k+E7CCV5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756133402; c=relaxed/simple;
	bh=hCnP05TiQs00BGY+oG0ba4z63lxDCdqa3mCAPO/U3ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCMZlymhauzWmuKnlpub00jrXi3A4PVw/9zHwp81KAPasxflgXKu3xwc0WbR09wE4jSGf+tIqm6/q/kZsfe0HBj491HpJZnAqRFQ0I9DsmupirXl4ktKadqcxmC2oD3HQrRj6dB+XS2LneG33Wr7a+bw70EIPS8HphcuDQ44Hpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VkFcRY7l; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8978040E01A1;
	Mon, 25 Aug 2025 14:49:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mQBz3sQRIXXn; Mon, 25 Aug 2025 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756133394; bh=9u9e2oYR+J3vZ4QtNSraXiEs+objJRX/aDWchk+pmRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VkFcRY7lPRFl/1P9LJnnmj3rgRwJrWxAkvJsbWHfI+udX0ufea4Vp2GpGWiGkiP68
	 SXBxT20mnHHPE1d5DiKLQQmqkoWKENbaCWpyizBYLc1uVeI56bhAifjHdB5CJogscT
	 9wu6M/Bc6tXTuEFvwnTAGPLTjz0DR7lGlpLD1LUs+L5x+0P7nbtrtokofF+sjLTrmu
	 PVyMhMDhDrO1VJSqJ5DVNRc+qD4LJ41zZR0JnqngR5HHVyWtqiPsoKV7LZiAKAU4Cg
	 7TiTEjP6ttbyBesZcBkKlSH6s/DUPjPsu7wnkj89h0gxxJ4yC2Zh5ObdgOPo5p4dCh
	 J78QIH4E3OySYkC7vBiu2+CXYlc8Dcpx9f2xECboadesrKWZorSUkrZ3+qIrYCJlze
	 hr/9cZzFZxYYPuME19E1kRse1aHxvx2QW64mEXqfLhRC9kgvvhyoo4jKOkDUi97V6H
	 lJ3gZWwSbCBcas1FmO1SKBK1bbGqN1Y/b4wfZd+QlKQFs65Y2c/pihSjV7w+ZaIowt
	 GR5x1EawWitcfNce5C+UKg3ZUX1gMVGsv558XXgdKwn1uZ3v8yrgT/6X2z34DBPh2v
	 5kVR5ZYvV+FQ5L76HnY0bLfxDqmXFujZasz3eFsXRccz4jPgl6vZhoEm9ktGkfaRzq
	 HF4Uj2MpjpYvWxb7jzpba8tA=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0D47340E0202;
	Mon, 25 Aug 2025 14:49:31 +0000 (UTC)
Date: Mon, 25 Aug 2025 16:49:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
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
Message-ID: <20250825144926.GVaKx39npwZZ18htgX@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-6-Neeraj.Upadhyay@amd.com>
 <20250819215906.GNaKTzqvk5u0x7O3jw@fat_crate.local>
 <c079f927-483c-46c4-a98e-6ad393cb23ef@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c079f927-483c-46c4-a98e-6ad393cb23ef@amd.com>

On Wed, Aug 20, 2025 at 09:06:52AM +0530, Upadhyay, Neeraj wrote:
> > > +static void apic_chipd_update_vector(struct irq_data *irqd, unsigned int newvec,
> > 
> > What is "chipd" supposed to denote?
> 
> chip data (struct apic_chip_data)

So this function should be called chip_data_update() or so?

It is static so it doesn't need the "apic_" prefix and "chipd" doesn't make
a whole lotta of sense so let's call it as what it does.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

