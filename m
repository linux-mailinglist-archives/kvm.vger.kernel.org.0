Return-Path: <kvm+bounces-6488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF49835595
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C4801C20FCB
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 11:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6814636B0F;
	Sun, 21 Jan 2024 11:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PWRIpLMh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1B5364DB;
	Sun, 21 Jan 2024 11:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705837928; cv=none; b=Nu0DSVMjjmgiSz1HyiaB3OjWcm7CPFwC4AFMxmG18rlFEdwMB+H2Jof7j7pwkdttwLUhG/N0UNnCrrClPtPCMhcEvgc7frplgHxWtrbJ5ozE1XO6WpM5OW7cZoQjA0crdyFtqf31H8a7xAj8PfTyE4N3EYYr/zgngA+rRhmaeTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705837928; c=relaxed/simple;
	bh=kUJ/wPcANnaorPy+42IvxaFh1BIIEqhsRbE3avdcw34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bc6yIZrTYvPgmzZDpTzRbJCzFgOCBaaqbNaAvccOB2I2F+AVe/QocZQ8QI8kO50fBoxxHp7AIYX3VoVt9Ip8lLDClFmiq+2kI5vKBjmHqqiFJdIkq4Je6v9wgJYKEVSwfT/m/Cb1GqDzPC8O1/ysnA8l2A5An7p7yKI//hSgJ5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PWRIpLMh; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 39E0140E01A9;
	Sun, 21 Jan 2024 11:52:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Qry1piIfM2_s; Sun, 21 Jan 2024 11:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705837922; bh=W26mJiWl0XX44Dk5YTanf0FWQj3ee3/S5XIYVQ5nwj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PWRIpLMhVmfkfx26lX4R4uXpRfe0W2rJNAnRNlu+16ESj0qW6C97t5JItDpm6Ahly
	 cjhd9p+VBY2fI3ur12OdD/9eQV0iOsVhVdwaseIOv3XBNqhURzaGKMjrFcrCv/Bd+N
	 QelXvcz0omYcpd6ZZ10Y4KxlRiMIKPB+PYn2Ua4VZLOctb3gqjOyRbghMnrqbA9EHn
	 scSUymmETpHppBjXs1518pQ3bbom5Ci8isAFQS2Lh9NBC3yA7PGrHbQ9aFnyMVxJlm
	 PEYSBE2mvthH8VgZ+SOsjJeFugXKYBSuoFyuHHaGaQGeGCgsLQiFMFhReJ0IppKegB
	 i8QZI3Ms8hXqlg04qPjFk7crQq+oFg1RVF88VmWt01f/T2uY6F3iL4lbEJJWjJ7p3+
	 530H3wx7vx4p7A1Xb2hlp/Mhg25nq+NhWL7XD1ZNwzIVWEYrodPZ/qG9wdU1Ujzv/r
	 tYfg2UEL8rgpTZbpfpS8/J0ory/8AnpEBWaqENis1q65LqHI4HjsEDg8Y6sT+X5I2D
	 BMdnPMg1i2NwzIwb4Fpft3EP18pP9lUssffwBHP+dgwX/3FfhQcp/yo2VMZPTZtQDV
	 dM/N0XCHtVyMujjFY022LKrgT9XtIg7AjzvKNx3MOZLwDyiyBG+DjTX0ndOWuYV26Q
	 BiWfBYCxgChhdii4Vj7ORkbQ=
Received: from zn.tnic (pd953099d.dip0.t-ipconnect.de [217.83.9.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E04CC40E016C;
	Sun, 21 Jan 2024 11:51:22 +0000 (UTC)
Date: Sun, 21 Jan 2024 12:51:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Marc Orr <marcorr@google.com>
Subject: Re: [PATCH v1 22/26] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Message-ID: <20240121115121.GMZa0FOViBESjYbBz7@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-23-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-23-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:50AM -0600, Michael Roth wrote:
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/lapic.c               |  5 ++++-
>  arch/x86/kvm/svm/nested.c          |  2 +-
>  arch/x86/kvm/svm/sev.c             | 32 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c             | 17 +++++++++++++---
>  arch/x86/kvm/svm/svm.h             |  1 +
>  7 files changed, 54 insertions(+), 5 deletions(-)

This one belongs in the second part, the KVM set.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

