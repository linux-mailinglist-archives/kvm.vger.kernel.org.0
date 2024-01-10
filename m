Return-Path: <kvm+bounces-6013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E33482A216
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 21:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84F281C22BFB
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 20:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68AD4F602;
	Wed, 10 Jan 2024 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvkunF8I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D909D4F5EF;
	Wed, 10 Jan 2024 20:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01087C433F1;
	Wed, 10 Jan 2024 20:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704917926;
	bh=fgRgZuoAXQ+AEZV1jM9xn99Om5QJ8jDoPAfUebkzG1k=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=ZvkunF8I+PbytQ3aauQZUhtA04lAEOU1IIG/RzeLPK401UDcocZUiX7tCvNZkhUk4
	 J8a7G8Iysz62mTv6dS7JxkxqOpnkVy0/tWgEyKHX0ldkP1s5h1dIXmuIQPkQhKovTm
	 Cub4+DO8mPJAz+POJlzwqzGt+XtknBta4GkxUMyo0//jfrITtgslfxtCKBzyk9B0qx
	 raZ45Hlaa0llbA+sg7uaPslIrVCLG2bYGGGl4PlWYiRlAyGoNI0zCZ+6ZGhY9M/AMT
	 /ni0sJFRI03TITR1JWZJnCtipD43lilhybATuWTUCrc8Q7YIMfY2l/lWVu4GyNF9xT
	 JNdHq6vFCh6cg==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Jan 2024 22:18:37 +0200
Message-Id: <CYBAYMHESW3Z.1EVW4Q0W0FHEC@suppilovahvero>
Cc: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
 <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
 <jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
 <ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
 <vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
 <dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
 <peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
 <rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
 <kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
 <sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
 <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
 <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>, "Brijesh Singh"
 <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Borislav Petkov" <bp@alien8.de>, "Michael Roth" <michael.roth@amd.com>
X-Mailer: aerc 0.15.2
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
 <20240110095912.GAZZ5qcFXYgvPrCdRI@fat_crate.local>
In-Reply-To: <20240110095912.GAZZ5qcFXYgvPrCdRI@fat_crate.local>

On Wed Jan 10, 2024 at 11:59 AM EET, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:35AM -0600, Michael Roth wrote:
> > +void snp_dump_hva_rmpentry(unsigned long hva)
> > +{
> > +	unsigned int level;
> > +	pgd_t *pgd;
> > +	pte_t *pte;
> > +
> > +	pgd =3D __va(read_cr3_pa());
> > +	pgd +=3D pgd_index(hva);
> > +	pte =3D lookup_address_in_pgd(pgd, hva, &level);
> > +
> > +	if (!pte) {
> > +		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva)=
;
                ~~~~~~~
		is this correct log level?

BR, Jarkko

