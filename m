Return-Path: <kvm+bounces-69534-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QH4tI509e2mNCgIAu9opvQ
	(envelope-from <kvm+bounces-69534-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:59:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E4838AF4A8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C242C30A47E3
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DD4381710;
	Thu, 29 Jan 2026 10:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="lAKP9eHl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C16E385502;
	Thu, 29 Jan 2026 10:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769683901; cv=none; b=go2Togp/yvge6mELmjWSdALeNoQ+eCsfXkgJUwnSOrEu8nOb65p8h0iylp7yQu2yMuH+duRlNCm50CdD8L8dy6g+LrICvox+eRVBwH6d4b+2PWTV+XTSx2aomc7p//rFNHSJTANIm1bg/4MKpR52HCr3HRfAMF3H9f1tJjB37pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769683901; c=relaxed/simple;
	bh=xbiQLS5Bu5k/D1HVH0xRQb8mY2QMcXN++Bqboyduo2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mk0zlPE7EOsAF/2Q+G3EuRVb461C7x9wHvhu7IS4G1fNR5VZXWyFI37lDUuXOqIJpS4RIbdpEQPJcWgtc1g2fHctDbSqkM4e4cnrIfq0fjYelaCbnjZyF4CpAwqvHQF3/I2LSvGjKrswQ20ggV7s9sC5QkxrMjfnSsZSw9GSTE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=lAKP9eHl; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E60C540E02E5;
	Thu, 29 Jan 2026 10:51:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8dkfuaiTZ6T4; Thu, 29 Jan 2026 10:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769683891; bh=waBCN0ZZew0V5noAoiVAk2IjN10s/+4yPnyCtkN5rzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lAKP9eHlwFfGYleYNJaNjQ8u9JDYoYpVwkgqo68Fpe1/DtocNDgZ3394rycBTVghq
	 g04ONhZVxRNlwfP4Z4lXULG2VYOGox8ywcPkODF2FF4bI36NaKITI1FCasbQO5ZGem
	 vHzTPlnVg33oCAQQEMzfqGbJmJyT8+HO3JuX9u/nFCPo7S6oxeAWlk3uk/6BaitgH9
	 G5k36r5OgOUfodq/H1P/0lQtDTJeaPAdABstpaW91SnG7i5b24mGdbaSOi8yqMDeZ9
	 vYO8Y7LRWx58GYd2+KTM4a8U0ynd/DKkLjKbC/JkBJzW5HAd5vAV5DouRVOLRLa/VR
	 3gxfdIXVxMvF33XvcYDBT3v85nOh4uMceA3eTUkE5tupzOsL6XoiwdB37oaON48TY/
	 v9XRPwuD3ercIU6jdX4CpiwtbhrtO8N40iFg34gZK4hmXY8WawUZhZCxQ7+gTSZN6/
	 WjVUkiv9ouD2muX346CRu9hj641dKk1zRgHdOAeq2eawKHk8Dy9LQ1DmNXg9sv+7Xm
	 +q3zq1+RBfh32oFAZNKpw/On3oC1yqV83lf2bwODm9rTn+2lr2udHY35sj18e2+9Ke
	 PrMWre0UZIFZEl75vmLoL+dc/1qh4VKlyo9duUCjslRLV3sOyEEMiYdTATJoLN/h/u
	 7k99EWfkWnwYjy94uvcMxuAo=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 83AE840E01A2;
	Thu, 29 Jan 2026 10:51:17 +0000 (UTC)
Date: Thu, 29 Jan 2026 11:51:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kim Phillips <kim.phillips@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Naveen Rao <naveen.rao@amd.com>,
	David Kaplan <david.kaplan@amd.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
Message-ID: <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69534-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alien8.de:dkim,fat_crate.local:mid]
X-Rspamd-Queue-Id: E4838AF4A8
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 06:38:29PM -0600, Kim Phillips wrote:
> For that last paragraph, how about:
> 
> "Allow guests to make use of IBPB-on-Entry when supported by the
> hypervisor, as the bit is now architecturally defined and safe to
> expose."

Better.

> SNP_FEATURES_PRESENT is for the non-trivial variety: Its bits get set as
> part of the patchseries that add the explicit guest support *code*.

Yes, and I'm asking why can't SNP_FEATURES_PRESENT contain *all* SNP features?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

