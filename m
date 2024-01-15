Return-Path: <kvm+bounces-6212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D16C282D5C3
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84E021F217A4
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C42D308;
	Mon, 15 Jan 2024 09:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hfFfwFBK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBE6C2D9;
	Mon, 15 Jan 2024 09:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 35EA540E01B2;
	Mon, 15 Jan 2024 09:21:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rb5tBLNoEbwP; Mon, 15 Jan 2024 09:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705310478; bh=Os+C4jxJM6cuCv/+nZczKN8icXMlG5fnzbqLqBJ4eRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hfFfwFBKPHLW/QtzuKXG58rcKCxxRwLLVsK2LLhqMujRled61nis0h5hnJABNNzod
	 mPk4rXIq4Z6SoQaKwGeGmpZq2CKpkfChXIi/CsU+qaBYQsFoAlgJLOA5egTdj0YWZb
	 x2aC3CvpyoE/UAcsB29fTmmFB2NuVQnIfrWD3m0qXpoahND8Q0G9b8CdamQro4+INj
	 q6yaLUuxDT8OMkhHVP0O1/7JYLzENiCQDrUA1MQocBMuLM0jA184M39QU7LMBqe0cR
	 o8Hd4S+VCp5IFz3cR88WNmzjsJ66ATUasBnBgpFCpdzpB0WjO+kuUQAMplY87zuSo7
	 XiZvI6CRwcIVhjVx9ZRNRky5nfTffBEx+20YzfQffUCjUZF06q8zbGwvahDGq/URCp
	 lOJXRP2hf5DdmIVJAiao+Af8wYDCkhtbhY5EwY0+Nvq1XubdRaqnAtn2nXs9NLUzXv
	 QdKySb6ec9fXztpYlf/oYPirrxpIl3CqdsJ4G4CyNOZqMoCIImCvCiXTbgo3EDAUr5
	 XB78FjnBvIH69wfc66i1ZkocCiSP9qaO3tMsEagoXXZZMuv/boz5MySco+TmIJJ4AB
	 Nfl5JmIIVTFlTOIjVoGi/3b64zr6921t4DpHoASDgzErqPPh2eutHWZJ5/Nsv+w6ec
	 MS4jYGfJGVYB0JwCVW0m1ntE=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B048140E00C5;
	Mon, 15 Jan 2024 09:20:39 +0000 (UTC)
Date: Mon, 15 Jan 2024 10:20:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Dave Hansen <dave.hansen@intel.com>,
	Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	"liam.merwick@oracle.com Brijesh Singh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240115092032.GCZaT44DIho_qvikDP@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <f0f44280-799a-4bf8-bf88-d423a2bd41ec@suse.cz>
 <20240115090639.GAZaT1nx4C4xJuF8IA@fat_crate.local>
 <ZaT3424NIr-BrMr_@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZaT3424NIr-BrMr_@kernel.org>

On Mon, Jan 15, 2024 at 11:16:19AM +0200, Mike Rapoport wrote:
> I ran several tests from mmtests suite.
> 
> The tests results are here:
> https://rppt.io/gfp-unmapped-bench/

Cool, thanks Mike!

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

