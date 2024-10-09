Return-Path: <kvm+bounces-28229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 627339967EE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D223A289D22
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC43519049A;
	Wed,  9 Oct 2024 11:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hUzJWDjy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746121C68F;
	Wed,  9 Oct 2024 11:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471774; cv=none; b=YLV1Et6SqU5RG4mmzJmbFGDXbGjYIT2uw+gwcDhRKgQ7/5fogs0VLL6bqgmyjhsvNQIOiQ/WrEnz58bYGE/jsQ2BVu8dxcYrTg/oOuUvB3tLh9SCR+A258LHb8aw47nDGH13/NSaDKQ8uCGIXBE1wynsZM1eg/1szoDkfejaTpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471774; c=relaxed/simple;
	bh=N466VGqjWSptj2aGUN5oUgG+gVzgGM2Uheovz59VrY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hv66T4zu7Kc33QdqQdybdaDr6D3p/2QiM2j2cCZE5/B79vm7/sKZOg9y0stT56jeFxXKW/cj+Souc1TwD66tEnquM52Oinbo4sUM5HdmvnhwtE+tFR95MWL21JXNuKdWioRaSGkKoEqUhSerfBGeMCt+EZv12vEl432rcj4mrpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hUzJWDjy; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 55D5C40E0194;
	Wed,  9 Oct 2024 11:02:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gATxLXAG03qR; Wed,  9 Oct 2024 11:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728471767; bh=+NW9SDD6w078wzTpaFP19oWUpfh1g3cnOLjfE+kDkuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hUzJWDjyuCb39YbB29tOv2T3nqISUOSWFPDYSPavy9MWFMAum0oudUng5StxYy15H
	 qcucjEZR2FfRoD5VOABv4htvCxhodg8Vvorp2jCJQzvNchiKVkQMHbm7f3+MSgoIz5
	 k959Mg1tw4BusU8GrUCMpufm8fleFdPJP5u03SWONDhf3EtuVJm/depGmZvzhm8Hok
	 ChMglUpHuPUBzK+QzJeHDkrrYdFyLMU77/R2xqsaAuY0qIRvQLUQvZrRfFm+QzWCVm
	 Z17i9p6aM8rErTTi1m4qvQwYZ/Z43DFo/QUqR8V7mJtXXxG/qmb2MFmc+5A3hWcwiS
	 0B3QPdzgcG9h10VObg/nqG5UDEnp73A0HyiLbT9wsq9r5hIPVzO9AFQ5+cThCzxRbn
	 f6HVs1KZ57wGQ7eoRIQVpn2Ab92cf0XeUhD3F6Mxnd9m4HhR5y7HvFIrCU3CE429ry
	 8k/XM1ZleyeiAQOJ07qRgSsK/T2jHlk6Zk3pYGk+tv7r5HYGVwM0EA3NDVky/NFp31
	 5o5VF8nKyJBrdoTZurTc+LBy2NEsjva9I61yVihWmhu2gSQCG5Lp10GWZ/v/V492+2
	 fE72CupX6DV/LcK27UjJGZpsPGNNttkv1ko3GVBvwJI06v3iw7b+KvNZQD+XEOv3tF
	 MIjJRfuiXDXnPqzVFx/Wn0gk=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2D50640E0191;
	Wed,  9 Oct 2024 11:02:30 +0000 (UTC)
Date: Wed, 9 Oct 2024 13:02:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241009110224.GGZwZiwD27ZvME841d@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
 <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
 <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
 <20241009103821.GEZwZdHeZlUjBjKQZ5@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241009103821.GEZwZdHeZlUjBjKQZ5@fat_crate.local>

On Wed, Oct 09, 2024 at 12:38:21PM +0200, Borislav Petkov wrote:
> On Wed, Oct 09, 2024 at 11:31:07AM +0530, Neeraj Upadhyay wrote:
> > Before this patch, if hypervisor enables Secure AVIC  (reported in sev_status), guest would
> > terminate in snp_check_features().
> 
> We want the guest to terminate at this patch too.
> 
> The only case where the guest should not terminate is when the *full* sAVIC
> support is in. I.e., at patch 14.

I went and did a small C program doing all that - I see what you mean now
- you want to *enforce* the guest termination when SAVIC bit is not in
  SNP_FEATURES_PRESENT.

Basically what I want you do to.

Please call that out in the commit message as it is important.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

