Return-Path: <kvm+bounces-6008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55091829E0D
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9FE11F27A64
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 15:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9394CB40;
	Wed, 10 Jan 2024 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DvO7RhNe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36924CB20;
	Wed, 10 Jan 2024 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0290C40E016C;
	Wed, 10 Jan 2024 15:56:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jhy-WvyI-ZKl; Wed, 10 Jan 2024 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704902168; bh=9AXlWCYHyGlZWoMBjnEdXnJNXAAZdOZ1mMO8CIYljuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DvO7RhNeuoKySKUfs6PH0zwrctKvn30zN4ZJDSb4SJEyCcf/+ZUAT51AnHdipMAh7
	 rm0RrWrys+aUa/IzTcaKG3XQZypPVKlUvek2MEpQmkr+NuF5q9tRLpICGdc0/QWziU
	 MwU/PkCLVGULD/bD5kg83YuJkvlWJO6QsaEenRoEObBox8gQVQvOU+FYNLztanY1Yq
	 Rg6EiSfJWGaWHw6zbN51AyuRDr+Gta1viaxdbG/MHFJN8DQlIaS0GDhyhpuBGYXiZd
	 QXHYO3b1r66t6qXOhXGV1ZPN+Ftm4y7/vGYv1NcEhVaqZtGue97HlNS0yT53vMp/+/
	 o7gi4l2nlH6zVoGaNly8UNIs8TfMAcJxu/jPx6VwPlFgpkLdPWqcg2r1CCH+l9I1vn
	 IUn3st1d8C838EjqjP+1VkwM0KrZDrQw2voJaJIKrvOM15E1+WhXiIbZBgaHOPcc90
	 FXp61xtJLgEtlnKTodZAGCn+aXb9dm7jz+fiSKkzJlKzi7V+fiUMnpIsARIk/0FffF
	 xdLIK8mYSVKwdgB00rWb/VTCt9noXUDjeGEYMbMPWGTF19zJxZNDhLwTBK8Px0bF8u
	 CXpBdrtdMuIoGpqfvJx9e+EmE4Yrut8ZwqkQGOad2y15r9Q0D4m1gM7uN3plRwBes3
	 XjO8/dwgOZn6I30W6HVlZEXA=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 73DF440E01A9;
	Wed, 10 Jan 2024 15:55:30 +0000 (UTC)
Date: Wed, 10 Jan 2024 16:55:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
	pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
Message-ID: <20240110155523.GEZZ696yxCY-oOvygR@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
 <20240110111344.GBZZ576DpwHHs997Zl@fat_crate.local>
 <625926f9-6c45-4242-ac62-8f36abfcb099@amd.com>
 <20240110152745.GDZZ63cekYEDqdajjO@fat_crate.local>
 <9e3a6d33-cc04-46cb-b97d-e903a263800f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e3a6d33-cc04-46cb-b97d-e903a263800f@amd.com>

On Wed, Jan 10, 2024 at 09:51:04AM -0600, Tom Lendacky wrote:
> I'm only suggesting getting rid of the else that prints "..." when the entry
> is all zeroes. Printing the non-zero entries would still occur.

Sure, one should be able to to infer that the missing entries are null.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

