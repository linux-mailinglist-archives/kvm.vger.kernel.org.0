Return-Path: <kvm+bounces-52307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE62AB03CB3
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB18A18907E2
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 10:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43AD248895;
	Mon, 14 Jul 2025 10:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LGJuBfVJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889AC24887E;
	Mon, 14 Jul 2025 10:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752490398; cv=none; b=U3ra9Va5GuECsRYZzu/iX/uWYcQnAicl6gMhu6u/v6Jjdl2hl6taK9GfUoZWAvRBWpMygdcb6tXGZcijY7boH4J/m8Flj9JafAzmyv1gAP357EM5S9mw5fPXRyjlGaqf9a1d5FjhZ8j6WYdJI74n/ekgFHQld4C95eFI7RnQjeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752490398; c=relaxed/simple;
	bh=faQh3yDJ3cmAtPWHJAAYh+8EJbkuKGS8rv10u+6kVdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiAwpH6c+ARGTcsguiT0/E9yRxSPml67jSup8FbXwG38lwQ/kxNz43KeX5aFo1Q7Z4aYQxSB2u62wm+j5lp8Yz5pQoKZ7elGbRMItwRDj5t2rDFzXpOE0nCYkECyKAA1bs+OUn2Yfg2g5FpbFI07t+tobASpsdo9TARgHni73OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LGJuBfVJ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 176A840E0163;
	Mon, 14 Jul 2025 10:53:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4Z3gr6BUp_8I; Mon, 14 Jul 2025 10:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1752490390; bh=6rOjcKLLPgtL8H8EwqYk8h4UdVGv4zjdYvcfXegnVJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LGJuBfVJv5V78O/C0L4MoZYTuwjK5J+gcPXX2cgukGxgzvxEgt37jJUN/SCv6kZaz
	 xX7j+jLBpSu9dx7xf6CkThp8UtgEj85Cc7q6sf3aIR3z9DYiyhEIxqopRQHXHqYiom
	 qYf/1nboKxOOMz648e1eYL2JfYLseRkEwJpjZ6SnCH2/JzA/JpwNDULq0dTOWYiqiY
	 5PJR2Wxk8Cdk/LgTKC3FOz/BuvZK4dC/kA00Tq5xgqqgyjWrbn+KJp4pwPtvulZH89
	 CopPPaFErRwNusjZy0lTNFrMjE7qeMAYl8zWhXdZQRa92bNYdB2qFAtjbdSBJJWcAG
	 qNWjgMZd4LMrRvXuLX+RbB8r6GMGt2dXB3/jx0GTuuj2x8EmbSJojcJFcidV9qMnKc
	 2kYdFUFbHNXshbXj5OwmihP1d4w1EbyJ3Y2oWPSIcK9K0AtCTS9a0gyVH56fNlidjv
	 COyC6Puwys9eb0KxnpDRA/UPEj8bWd7cJCUtWpac1On40A1a9tyYPIMoTONsFOv/bk
	 NieBSEVb2oq6om8TZoIXMos79NNuEQkWNHyjmhSJ2boV4nKvPt+nPSlcejkdIAZWXP
	 Ij2ODJWDH4UIMJzrHSo+AVJNwrDhNfUxaYvCiaJCVT0YkY3GUab5GI4WJsTOl5Nv4y
	 bLEvZGjCi+Wv4DvRwJ1G14fg=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3934140E01FD;
	Mon, 14 Jul 2025 10:52:49 +0000 (UTC)
Date: Mon, 14 Jul 2025 12:52:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v8 16/35] x86/apic: Simplify bitwise operations on
 APIC bitmap
Message-ID: <20250714105248.GFaHThgLB9QnrW2xLW@fat_crate.local>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-17-Neeraj.Upadhyay@amd.com>
 <aG5-PV7U2KaZDNGX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aG5-PV7U2KaZDNGX@google.com>

On Wed, Jul 09, 2025 at 07:35:41AM -0700, Sean Christopherson wrote:
> On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> > Use 'regs' as a contiguous linear bitmap for bitwise operations in
> > apic_{set|clear|test}_vector(). This makes the code simpler by eliminating
> 
> That's very debatable.  I don't find this code to be any simpler.  Quite the
> opposite; it adds yet another open coded math exercise, which is so "simple"
> that it warrants its own comment to explain what it's doing.
> 
> I'm not dead set against this, but I'd strongly prefer to drop this patch.

> > +static inline unsigned int get_vec_bit(unsigned int vec)
> > +{
> > +	/*
> > +	 * The registers are 32-bit wide and 16-byte aligned.
> > +	 * Compensate for the resulting bit number spacing.
> > +	 */
> > +	return vec + 96 * (vec / 32);

I kinda agree. The naked 96 doesn't tell me anything. If we do this, the
explaination of what this thing does should be crystal clear, perhaps even
with an example. And the naked numbers need to be defines with proper names.

Also:

>     This change results in slight increase in generated code size for
>     gcc-14.2.
>     
>     - Without change

What is the asm supposed to tell me?

The new change gets a LEA which is noticeable or so?

The generated code size increase is, what, a couple of bytes? Who cares?

We add asm to commit messages when it is really important. Doesn't seem so to
me here but maybe I'm missing an angle...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

