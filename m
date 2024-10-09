Return-Path: <kvm+bounces-28160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 032C1995EEE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 07:24:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2CEA1F25E5B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 05:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1953D15CD49;
	Wed,  9 Oct 2024 05:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OAfmZLhb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5D639AEB;
	Wed,  9 Oct 2024 05:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728451450; cv=none; b=H7r5hNzNy6QOgf9e5REksZvqM69wLBrzO4SphuME2rv6RXTHXB6r0UI/Ue7OXAor1U3LGoNkFCNr7tlq99bqJmaJjWgiA/EEqKUi2z5HfoS+gFNFjD7LyQDIGh2nSq6K4YVuA/FUZYtulvLDc6xO4Sb8zXRJug7Y9S0Ntd5S54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728451450; c=relaxed/simple;
	bh=PoSZ4w50I3l6g8tbsbVsp8+HhLHPpIhi8GGnIcTkIu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LG04t+e5GrdkKLPYHDBcjlY85OSyv66N4TB5y2e8oeKQ3w9tW6KN5/xzaXoUkUkKTdMND/EHbg/iSXNKYcQWHn+uvsKE1vtNjs52p00kF/XguQREaisdKdPVX72hhFcnsYY2SVUp+RRe7rNdcAVnhrJft4QFf1BWQ5qKVbweYHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OAfmZLhb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CD6BA40E0263;
	Wed,  9 Oct 2024 05:24:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BWLhazLo0C82; Wed,  9 Oct 2024 05:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728451439; bh=fa5EYiN5E+PNX8HO3SypS+kUz012vaZqA5LR5h5ExUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OAfmZLhbAJbHDoGnObGP1E7Rb2gEpyYS/ocOT3x0T0FjRicvRddCCfEo8lxX6Rzvs
	 l+zu4w6MUgWKMYZJ2ofwEvwEHOrE21XhuO6HPLTmgz5FPXE6T/G6tIo0PLWx2kZofM
	 SQ6N5fRcRgrHiK6s5+R70o7mY0UoUXZu2wVz1Ps5Ryax1f74w7v+FIRFBRq37E14bu
	 GDjU5R5h4pTUw53f4VHZeXFrzgVr/fMB5boGYnnYNvCr9XPhS0Fs32FjCxp6VkG8fg
	 NKyUuAXRnOOm2TaraWXzle1St1M8wEGudtSsFFgsHwL0YpkJkslr8owK/L2/1+t9y7
	 jRaqgEkqGYr64075diaPaII4BmhnaFeHXSgnApg2768LPWfJgV/DfCv7mrEZiuq+3e
	 p5jUddjwBSZx67lfzpAC66Oh7BYJlTXWuxlz+YVbyAmcGG5fkDr8Zk5LNizIBIKX8d
	 T8gpvFjHrygREs0QQ7UwiUXy4uYDmsTUyb8Nw2AXvmdbquXV/rZ4bPDVZs2ZalTUcD
	 xIDqYjhvnn9G+Nal/2tLNCoD82PxB412fhcFsi5n3ekitQ4hi4JEv3J8t6rpq2kpCi
	 Cs0wAaFoWMqBTx4xb3Yms/CsQuIafKMuursAmE4pU3DLr2TfVb8kZRJ9LahReGJcxT
	 cNU4eKFnC4RX4ZB5yTeXtQwo=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 67C1840E0163;
	Wed,  9 Oct 2024 05:23:42 +0000 (UTC)
Date: Wed, 9 Oct 2024 07:23:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>

On Wed, Oct 09, 2024 at 07:26:55AM +0530, Neeraj Upadhyay wrote:
> As SECURE_AVIC feature is not supported (as reported by snp_get_unsupported_features())
> by guest at this patch in the series, it is added to SNP_FEATURES_IMPL_REQ here. The bit
> value within SNP_FEATURES_IMPL_REQ hasn't changed with this change as the same bit pos
> was part of MSR_AMD64_SNP_RESERVED_MASK before this patch. In patch 14 SECURE_AVIC guest
> support is indicated by guest.

So what's the point of adding it to SNP_FEATURES_IMPL_REQ here? What does that
do at all in this patch alone? Why is this change needed in here?

IOW, why don't you do all the feature bit handling in the last patch, where it
all belongs logically?

In the last patch you can start *testing* for
MSR_AMD64_SNP_SECURE_AVIC_ENABLED *and* enforce it with SNP_FEATURES_PRESENT.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

