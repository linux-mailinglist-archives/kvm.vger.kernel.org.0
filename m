Return-Path: <kvm+bounces-51187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3EC2AEF800
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A39F6166B18
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DFD273818;
	Tue,  1 Jul 2025 12:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="P+tiwVbj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED58272E7E;
	Tue,  1 Jul 2025 12:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751371975; cv=none; b=Yz3p44LARh0HsxsJG+vgsV9mWfhla6GsKq0Nk34pX6zDNEII4p/ChI7Dp9vbk81TkpJo+BRIvArGmPBdXZiEzvoWVRneugisUMES8+ZehkdbVxATfr8kcP+aH9DQY/gDfTJRIFtRsES8umejPJXSn8V80b2SexPJo+9p6e0C8SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751371975; c=relaxed/simple;
	bh=3wnoHoKhyAyG96eGcEYegIFhqP678K43NhXgCAcN7m8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ls1LBecAyEMkhnQm9TEyCzKMsUKhRBawpRj6TdnQpj2TMGKsi/Y1FTxLNvWPChnIvlyZar7pehGwW2MHSI+0GsB71DXc15hPVSiQVcgKb608urmHsJcURKj1EqwMZrjyfZA01YlLA1h04DEJ5LM/KY/YJ30DQ5QCC6FTUu1h+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=P+tiwVbj reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 560E640E0213;
	Tue,  1 Jul 2025 12:12:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SVdnG-6_SDU9; Tue,  1 Jul 2025 12:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1751371964; bh=3jvGCEtZYunx69KW5dVUx7Rc541oTHidTbbd0WAhMQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+tiwVbjhDOXk/b+xVCCbcXS8uvF7/6zEEXC5h6VEtMkZfBYVoaS7uydtOYQSvagy
	 ccbigF0AW9DTEYlNww0+3VRX++bfFbv6yCK8j2mPisuzWGQgnUaT0LfdFKs4SLkISe
	 7yQHWuC1tIyG0W9EytouWOHU4ed2RQeb0d/f5nhCRoh86ZJYoIpDdCop5i2lYYU6ow
	 9xLXd5tVH1pPyFWj+Zxg9shiidOCgtFL1IpCFpBmN5Ws3dHEp53fRhYkCjZi4MsTpu
	 WzBD++Ii9vUWoG+MNPkXdZlNhhltfjFZ76lDpbVacKHUp+mZd3z+k9o6gt+R60ue6F
	 O/TL/0O3PX1RvWJaoVw23Q0eCzstCuUE2t2Zf0n8iczuUmrgyXapaNp0+TPPRQga3Z
	 +n+v8slwpr9I+sxT+1ZcA0e3QD2it++gpiTjiuDDjqPDW+tsmEc+2SGo3iMa3aUOlu
	 latvAcGMSS9Z3SthI9jth4ldaO+iSeUKng0DaG1GsoKtdzJ+oZYEGkYQbZaFkUfoE4
	 ijwA+T0CjWbdvZoVsVHKPfk4/6k95mjLlSI1fj6fbKvzO4aWSPxQwuFudd0rJFAtFg
	 6OhnJe787YH0ta78SAhITF4ph6nrccMXThmYjZCZ2/k1HCfg4MCykt3HU5chPDXGGO
	 V1KTJDKuMo5uoEPR4hduzcfs=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 776F640E0200;
	Tue,  1 Jul 2025 12:12:24 +0000 (UTC)
Date: Tue, 1 Jul 2025 14:12:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Message-ID: <20250701121218.GBaGPQold6Kw2M-nuc@fat_crate.local>
References: <cover.1750934177.git.kai.huang@intel.com>
 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
 <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
 <e7d539757247e603e0e5511d1e26bfcd58d308d1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e7d539757247e603e0e5511d1e26bfcd58d308d1.camel@intel.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 11:34:34AM +0000, Huang, Kai wrote:
> Yeah I agree the text can be improved.  I tried to run AI to simplify b=
ut so
> far I am not quite happy about the result yet.  I'll try more.

Ask it to simplify it. I get it that you want to be exhaustive in your co=
mmit
message but there really is such thing as too much text.

Think of it this way: is the text I'm writing optimal when anyone needs t=
o
read it in the future to know why a change has been done. If not, try to =
make
it so.

> Yeah I agree a single u32 + flags is better.  However this is the probl=
em in
> the existing code (this patch only does renaming).
>=20
> I think I can come up with a patch to clean this up and put it as the f=
irst
> patch of this series, or I can do a patch to clean this up after this s=
eries
> (either together with this series, or separately at a later time).  Whi=
ch
> way do you prefer?

Clean ups go first, so yeah, please do a cleanup pre-patch.

>   /*
>    * The cache may be in an incoherent state (e.g., due to memory=C2=A0
>    * encryption) and needs flushing during kexec.
>    */

Better than nothing. I'd try to explain with 1-2 sentences what can happe=
n due
to memory encryption and why cache invalidation is required. So that the
comment is standalone and is not sending you on a wild goose chasing ride=
.

> IIUC the X86_FEATURE_SME could be cleared via 'clearcpuid' kernel cmdli=
ne.
>=20
> Please also see my reply to Tom.

I know but we have never said that clearcpuid=3D should be used in produc=
tion.
If you break the kernel using it, you get to keep the pieces. clearcpuid=3D
taints the kernel and screams bloody murder. So I'm not too worried about
that.

What is more relevant is this:

"I did verify that booting with mem_encrypt=3Doff will start with
X86_FEATURE_SME set, the BSP will clear it and then all APs will not see
it set after that."

which should be put there in the comment.

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

