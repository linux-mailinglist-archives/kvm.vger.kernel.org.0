Return-Path: <kvm+bounces-5850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4BEB8275FF
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 18:05:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAAAA1C21116
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9133B5466A;
	Mon,  8 Jan 2024 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="U/ewXcsS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37295465C;
	Mon,  8 Jan 2024 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8DA1C40E016C;
	Mon,  8 Jan 2024 17:05:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CuKpKJOv0sMx; Mon,  8 Jan 2024 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704733504; bh=w1U9JuwWvaJMBjH60Qfm085eTdHCG+21c5u4mrqzaCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U/ewXcsSUdD+9SivtyMgsN1CLap1vAi6dgi/nHSjCXg0jJhmbsOPxEmWonINyytCW
	 yHusPDNEelLb2hSX/YpL86mKhzh6613QmFUDCKyPEVWa+yTwr3xKKYmHYETfOFioHM
	 UG7wND5TN6SCBiUotmh/m0XPbPDaukfUGTkMy8jnkxzO4SwdfBDEUEnmkTpsGLZIOE
	 sect88K4iyvL5/WYaCvR73nckuSijcOIQo4dmwfrAlizNGjOyn854a/fvz8K//UgzF
	 WHkRisFKQ8H6k4WW77iRE/076LW8ZTb2CZJ5Tw71s6Ct6Jj8qJbypu83wz+y5t6xtn
	 iyzJ67+JsiDecDvJpKCAYW9vOrCoSsUAmnPZCMwZX4Kz7rzgKj5fdwvD6fNyPGt4M0
	 Wqatg1aOn4oh4LYWIf771GzU8hK1uihaj2XDIN6oLIWQ0iVNt5H/oTMPAW2d50+Jcb
	 Gp2WStL5TwCP2vpCpWCHmCVAXXECM1pdxg5YQR7YlHrwAzoXgGYnr3TKUZKIclkwWQ
	 /SVh/PhLwC3rsUUnMSUm+aBtUwi3A7GTVVTadwBTH/Qe3NuvHc677pP2x2yTeqLHPg
	 pbBP0l6Y/iLEfyEE0WoSxhReJIxxwMk0lxvbvVJDa22IFMtfW8R1HhMLioru2Lyj6A
	 Mxev4/iCkvm2ibZWTuP9drhI=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DC56840E01B0;
	Mon,  8 Jan 2024 17:04:24 +0000 (UTC)
Date: Mon, 8 Jan 2024 18:04:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240108170418.GDZZwrEiIaGuMpV0B0@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
 <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
 <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>
 <20240105162142.GEZZgslgQCQYI7twat@fat_crate.local>
 <0c4aac73-10d8-4e47-b6a8-f0c180ba1900@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0c4aac73-10d8-4e47-b6a8-f0c180ba1900@linux.microsoft.com>

On Mon, Jan 08, 2024 at 05:49:01PM +0100, Jeremi Piotrowski wrote:
> What I wrote: "allow for the kernel to allocate the rmptable".

What?!

"15.36.5 Hypervisor RMP Management

...

Because the RMP is initialized by the AMD-SP to prevent direct access to
the RMP, the hypervisor must use the RMPUPDATE instruction to alter the
entries of the RMP. RMPUPDATE allows the hypervisor to alter the
Guest_Physical_Address, Assigned, Page_Size, Immutable, and ASID fields
of an RMP entry."

What you want is something that you should keep far and away from the
upstream kernel.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

