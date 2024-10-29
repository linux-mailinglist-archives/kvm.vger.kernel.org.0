Return-Path: <kvm+bounces-29947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 334F69B4C10
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:28:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE29228496F
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6672071EC;
	Tue, 29 Oct 2024 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AOPK1UCw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628C620696B;
	Tue, 29 Oct 2024 14:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730212103; cv=none; b=sPSSdpVzM1txkvvy7ertX/JY8aLSmHXTB8biB8DsF9tccNTZW4o+xPxGLkD0Do3DkXDuOqgKAotX4A95kt9oi/yr1Z/+pCIC7lLjCS6oh2MZWXuaXx9WAiQVvqCL0LuGKH6X78/gjdOr5mDvDiSkqkvx+m2/0bj8RYetDMtUcVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730212103; c=relaxed/simple;
	bh=zQSTQuHfIXDeySIqsjpMXxQJKi9tTYPZ4/OJS6CLMo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZHmJEenVZdUVnzyC0+X+/AA45X3Y0WTDSJLoyqbL+w2MEYPjGiwXxbykhTjQRn+z0XhRnPetloR/2pDn07ychaIw/BvavrsAyezWahTceELCrF+oMKCip7BB/RtMfz4ZjrIyeYx848ZONcr9Nm1xxmOZbrj9/+oEv1I3wdJ1Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AOPK1UCw; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2D86B40E0219;
	Tue, 29 Oct 2024 14:28:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LrVDKlyK2IwV; Tue, 29 Oct 2024 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730212095; bh=yizANEBOVFjBZEYttknFswJfr+e4kzXqziGfAwRn6SM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AOPK1UCwnkFenxQpt44QmxIH1vtwwF6zF8mdVeBFh4qtka21vsyKrM+lPq37mSgDX
	 3M92Lfp2I0a5/AYpKpu5KcysLz6U8E/Ir4Nn2Bpve6qAp2ezX0N5bHuDfWil0+03rt
	 fahYiNYLz3uyxR6/DqQ6DhFLdWv4/L/JQ4qWvuA0j8kBDIPYu1Ddll00vznfobucDB
	 YDAj4Jq1qzpT81QWcfdso285LvBYM6ntwGGjDjP0vTBvZhT2xNVCQ8qOSRSsnqVbMJ
	 YsPNF1dAaM3WmTR0v3G0YZhwUMLtGVzu47QaUXYjyW9oOd13vRriUR3aiCZgrcr2u4
	 numfSVDjonRPvQcl7fry+SFKwdfar4rwsTbZ4kEoTadMwfUwA1OAO5/R1AK/OXsysA
	 h/NMOCltcbBO9/lsq4gGxr3hlMdH+wAU3DqIUsYDICnhcDVA35yQCgrDY0Jtoxj73a
	 Pw2THF6DO84c/RRga1SCLcrbUerlmoHwCE6fVEq1paYJiiHM87EskF+9GDhlWSMK+J
	 aSLr++g29zRojnmAprJ51OWFr4ZRyOGqOXdG6g/n7EC580s0mGFxYVS+aKKNs+mgep
	 cxfhG2smpYdzYklTnabb8h1tBKWyPkFb37uB1tMe5WrEwMi4LXB6aTjQJGCO0EbGeE
	 IYZOg2+NJ37NiXYrnjOXlMjc=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EB72040E01A5;
	Tue, 29 Oct 2024 14:28:02 +0000 (UTC)
Date: Tue, 29 Oct 2024 15:27:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
 <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>

On Tue, Oct 29, 2024 at 05:19:29PM +0800, Xiaoyao Li wrote:
> IMHO, it's a bad starter.

What does a "bad starter" mean exactly?

> As more and more SNP features will be enabled in the future, a SNP init
> function like tdx_early_init() would be a good place for all SNP guest
> stuff.

There is already a call to sme_early_init() around that area. It could be
repurposed for SEV/SNP stuff too...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

