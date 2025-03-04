Return-Path: <kvm+bounces-40062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB534A4E8CE
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:30:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08F117A8AE5
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 17:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBA329345E;
	Tue,  4 Mar 2025 17:02:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D17293450
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741107740; cv=none; b=g/TLhettifoTl8pni6FImBSrYjnH4LPtSQtbqB+zpSs+NifrqJp6zaF+3QbaHxbfPqeGVxAVSkLzW1yRRM6534dxMRKnevYSgvpWSUYZ8m8z38aWqXxhhzNV4/UHGDFRDMig1Fc2p7jiQdmdF6kBIS6qKA39UuHi5xaKdEkgMyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741107740; c=relaxed/simple;
	bh=EFjtBnt19Ojd3dLx40oDXftpn2X9SiAs1wVQcHBfI6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLKQvp/5JEmCFHeB9JRF71leCg90RyshLgaTz/zaFVz57o/VlgFl0czny7s4QfTR+lD4mU/lCgApuxr57Zvd0qaNsFvmPB9dZjwAFvKzLrTfHtqWZaOJ9o9524XQaRUpErL3ZSmtAkijVJYCoJ4lLX4qEJBlG3VLnmM9ZkLlnG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D6252F;
	Tue,  4 Mar 2025 09:02:31 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F54A3F5A1;
	Tue,  4 Mar 2025 09:02:16 -0800 (PST)
Date: Tue, 4 Mar 2025 17:02:13 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, drjones@redhat.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/7] arm64: drop to EL1 if booted at EL2
Message-ID: <20250304170213.GB1553498@e124191.cambridge.arm.com>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
 <20250220141354.2565567-2-joey.gouly@arm.com>
 <Z8CYeyKrFoglWWSp@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8CYeyKrFoglWWSp@raptor>

Hi,

On Thu, Feb 27, 2025 at 04:53:15PM +0000, Alexandru Elisei wrote:
> Hi Joey,
> 
> On Thu, Feb 20, 2025 at 02:13:48PM +0000, Joey Gouly wrote:
> > EL2 is not currently supported, drop to EL1 to conitnue booting.
> > 
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > ---
> >  arm/cstart64.S | 27 +++++++++++++++++++++++++--
> >  1 file changed, 25 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index b480a552..3a305ad0 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -57,14 +57,25 @@ start:
> >  	add     x6, x6, :lo12:reloc_end
> >  1:
> >  	cmp	x5, x6
> > -	b.hs	1f
> > +	b.hs	reloc_done
> >  	ldr	x7, [x5]			// r_offset
> >  	ldr	x8, [x5, #16]			// r_addend
> >  	add	x8, x8, x4			// val = base + r_addend
> >  	str	x8, [x4, x7]			// base[r_offset] = val
> >  	add	x5, x5, #24
> >  	b	1b
> > -
> > +reloc_done:
> > +	mrs	x4, CurrentEL
> > +	cmp	x4, CurrentEL_EL2
> > +	b.ne	1f
> > +drop_to_el1:
> > +	mov	x4, 4
> > +	msr	spsr_el2, x4
> > +	adrp	x4, 1f
> > +	add	x4, x4, :lo12:1f
> > +	msr	elr_el2, x4
> 
> I'm going to assume this works because KVM is nice enough to initialise the
> EL2 registers that affect execution at EL1 to some sane defaults. Is that
> something that can be relied on going forward?

I was just trying to keep the changes minimal.

> 
> What about UEFI?

Haven't tested it yet.

> 
> I was expecting some kind of initialization of the registers that affect
> EL1.

I'll look into it.

Thanks,
Joey

> 
> Thanks,
> Alex
> 
> > +	isb
> > +	eret
> >  1:
> >  	/* zero BSS */
> >  	adrp	x4, bss
> > @@ -186,6 +197,18 @@ get_mmu_off:
> >  
> >  .globl secondary_entry
> >  secondary_entry:
> > +	mrs	x0, CurrentEL
> > +	cmp	x0, CurrentEL_EL2
> > +	b.ne	1f
> > +drop_to_el1_secondary:
> > +	mov	x0, 4
> > +	msr	spsr_el2, x0
> > +	adrp	x0, 1f
> > +	add	x0, x0, :lo12:1f
> > +	msr	elr_el2, x0
> > +	isb
> > +	eret
> > +1:
> >  	/* enable FP/ASIMD and SVE */
> >  	mov	x0, #(3 << 20)
> >  	orr	x0, x0, #(3 << 16)
> > -- 
> > 2.25.1
> > 

