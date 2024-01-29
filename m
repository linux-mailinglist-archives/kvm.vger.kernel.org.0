Return-Path: <kvm+bounces-7389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E18841391
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E82B51C24710
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36260179AB;
	Mon, 29 Jan 2024 19:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bdsIxLwX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2655E2E834;
	Mon, 29 Jan 2024 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706556870; cv=none; b=ZRszzev+Be3/k3Rc4pUYFFVzhH0Q4A0SyHh3vBqbwsiISp0HKuFdjIjNV1Uc9ydMOlvNICr8LPmJoI62xJj8j1No8CS48fjJiog0C6DmaQTOeVv66L/G0EUsVxfAExPF6OKFoRlMJc8gJGzUzgn76JQbproRJ2CM603jeZ8RyEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706556870; c=relaxed/simple;
	bh=I7RxhbY/EibWYZIjX/KVd/UOGTnYnSVr17JA67fezys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfJfI9RYVOyfghxSzu6mE68E8A/2jRUaj6utGZt7UPh9xVZvxM91OxqSEKjn8GCyra4Ezyq7/AtsuDiy4A4XRSztobfi8qscOFwuJCh4wQdV5Jx+KPRItYiV2HQDyXhClvM+UuY4Bfr2W64JsEGAwBSDAKGJw9XqPEDGDEgDIo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bdsIxLwX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 45A6640E016C;
	Mon, 29 Jan 2024 19:34:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4_ICJQF_PwKX; Mon, 29 Jan 2024 19:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706556863; bh=Y20SlS97Pif+eZWcli8UoWz3jQtBHyVieM06xnSycFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bdsIxLwXTfiTiQNBBuB4jxzMjtcW9WLQgDndiKuh2Dgb1Fycm7YYU1xoqIfx8WkDk
	 ZWPNJ92VcRA1likU1aDH2DuQQ7wGisMuAlPOoUjuJESd23/x1dOTfWX9bt5UW1wmKO
	 rHqGvrOI2XHAzgnHlljaQXh3TONXOx51jFEdh8ehAc3IT296ZK3HC4+Pam2D4/uDPq
	 fMTRb2p0RgOZRUCeqxKFq0ATiK3GGxR9YoTj16jRNFwQN8Jfl0rhgBBWliLPOJByFm
	 0Td75HtzdqwyPNJj86PRwlop6u+oa52/lGQDVrYYDp2x7jNnJSVXCc176KK6TJWi15
	 PleiW0y++W5QfJAynv5b2KyzlzKuVHFgYHiE19YgVM7xqUnPJtXzHwg88/O5VVUGvf
	 Ih4s4Cp5x4PlvJouh/SQWBI/8w8nnVddxJmn4cov/xaqB0Ue9l9VfcJArJOV1O3BSG
	 pSMPG234d7SXmNE0YITi5zqaBZMRqGvjr7zYkGwoMtl6NnQ0o430Idm6aw4KArALM0
	 1F0CPmVk1pZzMIAcEnJDhltOfay5/dxNH6KDVIB/5hEzJoAAhGGWpa48ZrBKyJN0DB
	 0JacNamOknGrSMo/o4CSeVOcYWxIzE9hvOEGg4CDxDlyHSiQWj4J7LytH4Bvm1aMi7
	 Njo5QWcNHZ2lOUtJBw05ByGk=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 92C6C40E00C5;
	Mon, 29 Jan 2024 19:33:45 +0000 (UTC)
Date: Mon, 29 Jan 2024 20:33:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Liam Merwick <liam.merwick@oracle.com>
Cc: Michael Roth <michael.roth@amd.com>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"jroedel@suse.de" <jroedel@suse.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"jmattson@google.com" <jmattson@google.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"slp@redhat.com" <slp@redhat.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"tobin@ibm.com" <tobin@ibm.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"kirill@shutemov.name" <kirill@shutemov.name>,
	"ak@linux.intel.com" <ak@linux.intel.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"alpergun@google.com" <alpergun@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 10/25] x86/sev: Add helper functions for RMPUPDATE and
 PSMASH instruction
Message-ID: <20240129193344.GFZbf9mEIxZg7ZEb8f@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-11-michael.roth@amd.com>
 <23cb85b1-4072-45a4-b7dd-9afd6ad20126@oracle.com>
 <20240129192820.GEZbf8VBsDhI0Be8y0@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240129192820.GEZbf8VBsDhI0Be8y0@fat_crate.local>

On Mon, Jan 29, 2024 at 08:28:20PM +0100, Borislav Petkov wrote:
> On Mon, Jan 29, 2024 at 06:00:36PM +0000, Liam Merwick wrote:
> > asid is typically a u32 (or at least unsigned) - is it better to avoid 
> > potential conversion issues with an 'int'?
> 
> struct rmp_state.asid is already u32 but yeah, lemme fix that.

Btw,

static int sev_get_asid(struct kvm *kvm)
{
        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;

        return sev->asid;
}

whereas

struct kvm_sev_info {
	...
        unsigned int asid;      /* ASID used for this guest */

so that function needs fixing too.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

