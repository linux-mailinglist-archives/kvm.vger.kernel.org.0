Return-Path: <kvm+bounces-6473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0217D832E60
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 18:49:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADCB328999A
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 17:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A85C56450;
	Fri, 19 Jan 2024 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Lv/MxRHu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8435856443;
	Fri, 19 Jan 2024 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705686555; cv=none; b=uHOyllL1paH5ItnbU0yG7KosJz92wdajxhBZklV3z42BKJ18DO+vZIUUMnMEtyCa9uz9Xdk/spRmcsDyQ6dVQl2wjoxUrPjnpippStCE8raDLTjcknGRb2XC5rRpkwLJYJwhHkz1rjKYkjeDwhIBYYvO8IaeXO9k3I7cSoRVcEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705686555; c=relaxed/simple;
	bh=AhM06dWCoS9Yqe/bb9J4wni8RWPqY5xZW8ChtKJK2uQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmRukwY6nQdPOsAnquxhXj6pMMcxHTanC/ygqsavCS+gZ7JYu5kjjCfI+RX4096TCUNw72AF2joYrEFbGc5S/pO6sC4ehDaLIBd7F3n8McP1Oe0IKVbcWMQNYCLorDuL//llh8pxPLT4NZsKJrDyWRpNzM3ePbvFqgUk+GxBC2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Lv/MxRHu; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6BF1940E01B2;
	Fri, 19 Jan 2024 17:49:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HTqOCos1itEC; Fri, 19 Jan 2024 17:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705686548; bh=N5P0OP32u4vYYJkcq5dn4rKE4JvHTAglrfVwbhPG/40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lv/MxRHuM+pgkTF76WNf6wAea7SiPxjGNWgw1Nq3sSFEEZ8LcLa46XqpYcjzNVefP
	 W9IaeVK4fmGl5MD6SuR5Tk/HPtnNdx58IqpmYbQE9xrBrZR2i1Dtrv8v9tmIfs+nGf
	 wioqmCGxileSNFUb7EeP6sfZtg2z7oP12PJ7odFCG0+oPpCsn9bSM3LjOX20+U5LXm
	 zlIxeaWfXn6vdZdWaO1sigObmx6erxqACnQyeQ0/vs3TReFNN0Zj3ZOepDmP/JIJgl
	 9ivSuwG0HA3QfDXI+hi0Cd9WdP0qxNC07hgjf/iMWHqcLSe/wtmD3ALRLb+rI6Ef2/
	 odB1fOjl8dVl7C89bBrLoeQkdfeTyxi4IH6mcO7uXeuAJMxKBvN8Ue+av+vd7ThsGZ
	 ZxMmeUGyzcZDgTT5sv2DfM/Bbzi0dzASOJsBzdtz0ID2gRDBsQgTEoXVt2jXG0kgFx
	 Z0k4POTM2hje1aJMgArrmB48zGrSXoslJ4RXAva10jaqXdZgSRt1f6j51eNm0+Hcwy
	 PLsslv7VxhOyoXvaGyMPI8sa8+dRSXCcK9hOdb3rAtKm4fhBgZieh0IRosICOgIafa
	 GoVX8FCOfcom8e5wkECW/r3UCPpIcR8mzBpPVQR6kosBqL9H9j8kpv8/tNSl1uTFkk
	 MLifxaMoPKPq4u/YBhDhRKys=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9691B40E01BB;
	Fri, 19 Jan 2024 17:48:31 +0000 (UTC)
Date: Fri, 19 Jan 2024 18:48:25 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Subject: Re: [PATCH v1 18/26] crypto: ccp: Handle legacy SEV commands when
 SNP is enabled
Message-ID: <20240119174825.GAZaq16f0dlfle65To@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-19-michael.roth@amd.com>
 <20240119171816.GKZaqu2M_1Pu7Q4mBn@fat_crate.local>
 <6d8260e3-f22b-68c9-03c7-5e0fa351fe05@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6d8260e3-f22b-68c9-03c7-5e0fa351fe05@amd.com>

On Fri, Jan 19, 2024 at 11:36:44AM -0600, Tom Lendacky wrote:
> Using %#x will produce the 0x in the output (except if the value is zero for
> some reason).

printf-compatibility:

       #      The value should be converted to an "alternate form".  For o conversions,
              the first character of the output string is made zero (by prefixing  a  0
              if  it  was not zero already).  For x and X conversions, a nonzero result
              has the string "0x" (or "0X" for X conversions) prepended to it.

> So I would say make that 0x%x.

Yap, better, unambiguous.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

