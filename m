Return-Path: <kvm+bounces-20297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B30912BE9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 18:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C146F1F22446
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7707B16A93D;
	Fri, 21 Jun 2024 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BISOTScV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B56515AACD;
	Fri, 21 Jun 2024 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718988879; cv=none; b=dUkZEtOIjb1p95OYhCffcZrFRZZuGapwltNRW6m6RUn2bQ5DF0FOUb+lPeasmr51jrZZzomkigIhy7/JFP3ZP7umRcZAHQAglFbFM2imwjuQTdT91ED+VWQSYJCwpbhkldveRlVVYoDAv52nqfdsZSCMbMtQBIHt3IhhM8h5I+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718988879; c=relaxed/simple;
	bh=p9rgC8AhEGnxn7glekQ57NbVbRgVqVE9M3IVR52QWCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DhcClmtY5pl+tKOO917AwTrnRf8wsNb9qp8O50SJUxs1xx2De6v8p4jitO1LIS2gAr9tSwXPdB7eu1znmh0ZuwMOvVoRnr0je69CvZmC0KVnqRJ62WH5dTzlxv40UXhoHEx/f6lwUvmAYkncV1B5fbic4YEbmJSzAe22DScATKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BISOTScV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 077ED40E01F9;
	Fri, 21 Jun 2024 16:54:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fk6kBdSQxNjV; Fri, 21 Jun 2024 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1718988868; bh=ZxRYh4NdlH+RU/ASZJKjkd8D8lAlZCa4l3GUh195iIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BISOTScVi+Zf7bXTrwyspo/9rkZhXd/dnuajqD5GRTgC0FFP6wUf0kIm65fun6oas
	 v8yyW9jWhhP29sS/gwP/hr1UhcNSj7kmTLPW4Yo7pK00kbKAwcrk4AH1pb0VVpVU9d
	 +RczkHu2laUFi//ihaNdIwcNfkV0xNQO7Aga7Eo2nOMpACtePCkOcvHkIuDPFyezBV
	 fg7AdnXLQYo1EKfiSNGQIxzgSTxH6TerFCAKaLnZKKbBO8KCxnY6IOpONSPpA572L6
	 JeBcBTqPOHKvxRB9WlHZ8shggBc1n8Cl4IFWXKBpbJVds02cpI0bMTBqv6xL9a0zaS
	 sxLTZR37L6MGlY0266+nGIvIxMoOjxZZPGQKzsfXEplqxEqfu1MX8Xc3Us+Ur8TeSp
	 R/D67bWFm8Cx5dR/BOb5CWvm96ufKoXxSBqu7hp4kj01R5QQDdqGalP4+7g/CRV3i4
	 Q1+1uYNTs+ZRfY0d+2WVnPMbjhloQi+5csTRWYwy3Y0gnm4aEWKfBNiVLB9FAfmVa7
	 eYRjdlkefAZE10eUcFnh4buHNWunB6lm6Dhlc3HjSQXLCPHb2U+w3OQ4R/qp7sS08b
	 89SyiL3L0ju8AwDz6gET7XyNIdiXTPPKFS8IYK0z0pKx7K77S4kPIwgukJlma7Vzaj
	 2YS4NihruCz1bc+gLDdcWOKY=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EFB5540E01D6;
	Fri, 21 Jun 2024 16:54:16 +0000 (UTC)
Date: Fri, 21 Jun 2024 18:54:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
Message-ID: <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240531043038.3370793-4-nikunj@amd.com>

On Fri, May 31, 2024 at 10:00:17AM +0530, Nikunj A Dadhania wrote:
> Currently, guest message is PAGE_SIZE bytes and payload is hard-coded to
> 4000 bytes, assuming snp_guest_msg_hdr structure as 96 bytes.
> 
> Remove the structure size assumption and hard-coding of payload size and
> instead use variable length array.

I don't understand here what hard-coding is being removed?

It is simply done differently:

from

> -     snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));

to

> +     snp_dev->request = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);

Maybe I'm missing the point here but do you mean by removing the hard-coding
this:

+#define SNP_GUEST_MSG_SIZE 4096
+#define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))

where the msg payload size will get computed at build time and you won't have
to do that 4000 in the struct definition:

	u8 payload[4000];

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

