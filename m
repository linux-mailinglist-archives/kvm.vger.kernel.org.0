Return-Path: <kvm+bounces-6016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA6F82A3CC
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5E501C252C2
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 22:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A8284F8A0;
	Wed, 10 Jan 2024 22:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="T7tPVLGj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BF84F21D;
	Wed, 10 Jan 2024 22:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E2EB740E01F9;
	Wed, 10 Jan 2024 22:15:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nyXwZKqd1a34; Wed, 10 Jan 2024 22:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704924900; bh=qzYKfx3de59+vgu9hb7XP534ekilIGghNG65JX231Xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T7tPVLGjEkG/q/m/oH7mkFdDSm4g2QnCZlUFWhO4EGnjXvMod93Xmw38Bn6Qb02r8
	 nVFfOtjpQQjaePLyFHocD24AWkK+eKheKufHm6jIuZsdberpp7cjLKTTTL4Sjip/lF
	 Sxjy//bcTKZlT06vTRplCHHl8DqCr+tPTSlSQC0WQqDmdH0Hge0WZKgYQj2tMBe/Rx
	 Xr91oVHJxIbJ0ZwzFk4MlIv7acdNiks925JUCne17jxQPHPY4amCgxM59vOSaZgezg
	 YVUqIxNGgpKG0Fsr+hv2s33cd3ENnb7hSAX0Qvx065ZjUprPxuH7YkWvagW5+DR5Ot
	 Kemo2oqFTqg6S4xoCIC3E3WweV6jc1c4lXvDZq2yciB5bqbXCghRbMmNeFPYcVgbar
	 vnkdWwdyOwC4GbhSLTHRzi0hOajTdSUSGK/B5RLAW8Zt5ACALLmT4+pEaqb406hbZs
	 iOl9T/u3ucRUZKWJJAc6B9oVbP29ud3il+OUf2RAvWYjNOHSppvfdr8eQ1XADoPpoi
	 yD8LSFO8WizFfqBxIv4qNn47XIKqyWwIcQRafgo7sjlVZhQrKeWYPMrmMReiNz5g/6
	 pnB79G3kp/jjse4W92qGlxhmpVRliPceQSyedFqsoc4HfF/fnlUSNqjajDUxgDdX+8
	 y3b1JVQnou1C5kImEixUgwGk=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 72F3A40E0196;
	Wed, 10 Jan 2024 22:14:22 +0000 (UTC)
Date: Wed, 10 Jan 2024 23:14:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Michael Roth <michael.roth@amd.com>
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
	ashish.kalra@amd.com, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
Message-ID: <20240110221421.GGZZ8WvTGdNrWkUkfv@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
 <20240110095912.GAZZ5qcFXYgvPrCdRI@fat_crate.local>
 <CYBAYMHESW3Z.1EVW4Q0W0FHEC@suppilovahvero>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CYBAYMHESW3Z.1EVW4Q0W0FHEC@suppilovahvero>

On Wed, Jan 10, 2024 at 10:18:37PM +0200, Jarkko Sakkinen wrote:
> > > +	if (!pte) {
> > > +		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
>                 ~~~~~~~
> 		is this correct log level?

No, and I caught a couple of those already but missed this one, thanks.

Mike, please make sure all your error prints are pr_err.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

