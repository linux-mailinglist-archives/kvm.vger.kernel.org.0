Return-Path: <kvm+bounces-42502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 204B2A79519
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9BC116F5DA
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3167A1D7E4C;
	Wed,  2 Apr 2025 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SZdI0vBf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314CA19E99A;
	Wed,  2 Apr 2025 18:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743618610; cv=none; b=b0Bbfpv2l6FxqZfgJNH4uXBSdPDxGiS0ys3pdH+NyqPceCrlYxVDNGk+3RohSnz8mWN4WhQhthffLQ6rp0OgtzTvLx6B2OC1w3hQ1uutWJIjQyGqL+Y4/8n9Qvq9FSbPVa1X0Yiyp4PoKz4FiPWVmfuMrH0ozdPFSXb6Sf+UAh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743618610; c=relaxed/simple;
	bh=MIYZp0RpSxC/dK550QikaiN/zkIiyI2QWdLzOBOBqpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9ycq9qveOL/s3+rmS10f1hBnB++5RUhLdbXnelYG/UpkBOHhgloEz+ULK17UGb3sh6teZu7umsh/B3+FjkicatdEkmI7HKqw2KCONjGfOeNUbLFRPSziAILhu4iTROCzlRpwg/cJvM8YXxnNGjXFKucX4zTt4OmmVAmdBhmJZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SZdI0vBf; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9E6E340E0196;
	Wed,  2 Apr 2025 18:30:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id XOtpVDaZ6P3S; Wed,  2 Apr 2025 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1743618598; bh=jhDUDmM64c22Ocj1QmmY4kruyZeU8W2YObwLlnin59E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SZdI0vBfe5b5fSq+dU/Nkw8aec5CNiB1tK1BWVP/nZwIo+0CNnmN1T4mpcXp+hWzZ
	 x3Wd9O0AM9YfFpbWB7DnnSJ5jO8/VFknTEzLiM2cB1CQXnoPG43EQ+Kd/TQLKVpY+R
	 sipVJ+sau6oZyU1j+O4uk6tcdRUHNjRKZPgx9POf/pRW1IUw0tcMHLqSzIOUwRcAtO
	 /ReoHNqNoBiJB3Byf0MxbjttxqYafKUGjGsDm2SeVeShPrF/+L6N1sDwraS4A43dSW
	 GiMJRG95JKjT+LcqJfFV6zO/VzwgGXs+Qb0r2E+T//Euzo2cHFSj8TBrEgcTRRw8Nw
	 9RKoKuy4XN7nrud2B+gRcJgCcc4wuwFM68Ei25xt4ydmxjHgfq8xPI8o7dS6PvIa5+
	 pfCkkF0GQ9hR1AblLIhJneWwhRRUG2zgshpdShnPknpmKLpWedTmFVUBAQhQCM1hSs
	 nkNAp47iyqviNGOj/DAJsbmrnpVtOAXr8Ctjd6iKL3i69baIDFJkWWJbIbhYlNf6zT
	 +GP0qSk+LTw+uuhN0mIbbL/qESbcS59b8gdtT4n3iWcuKoId2JPGgsNbg2cSnAY6t6
	 ebOT+gjFhWGNWz+69GXtg5ZI6VbFIdqtzCpkqtvv3K8S6q5s3i0PT8vAvGr0sB+MyW
	 C5zplnk0AC9EIUcIx3H39dmw=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1E09140E022E;
	Wed,  2 Apr 2025 18:29:34 +0000 (UTC)
Date: Wed, 2 Apr 2025 20:29:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
	tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 1/6] x86/bugs: Rename entry_ibpb()
Message-ID: <20250402182928.GAZ-2CCBR2BAgpwVLf@fat_crate.local>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>

On Wed, Apr 02, 2025 at 11:19:18AM -0700, Josh Poimboeuf wrote:
> There's nothing entry-specific about entry_ibpb().  In preparation for

Not anymore - it was done on entry back then AFAIR.

> calling it from elsewhere, rename it to __write_ibpb().
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/entry/entry.S               | 7 ++++---
>  arch/x86/include/asm/nospec-branch.h | 6 +++---
>  arch/x86/kernel/cpu/bugs.c           | 6 +++---
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
> index d3caa31240ed..3a53319988b9 100644
> --- a/arch/x86/entry/entry.S
> +++ b/arch/x86/entry/entry.S
> @@ -17,7 +17,8 @@
>  
>  .pushsection .noinstr.text, "ax"
>  
> -SYM_FUNC_START(entry_ibpb)
> +// Clobbers AX, CX, DX

Why the ugly comment style if the rest of the file is already using the
multiline one...

> +SYM_FUNC_START(__write_ibpb)

... and why the __ ?

>  	ANNOTATE_NOENDBR
>  	movl	$MSR_IA32_PRED_CMD, %ecx
>  	movl	$PRED_CMD_IBPB, %eax

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

