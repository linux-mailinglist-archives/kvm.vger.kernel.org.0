Return-Path: <kvm+bounces-6004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 175B8829D8F
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:28:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A398228A46A
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 15:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B794C3C4;
	Wed, 10 Jan 2024 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eTsD0Roa"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D054C3AE;
	Wed, 10 Jan 2024 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6730140E01F9;
	Wed, 10 Jan 2024 15:28:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FUCzeqJ5KG5u; Wed, 10 Jan 2024 15:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704900510; bh=sqSLDTLrGLChVeqpstqSHsw48slxVSeLIba4GiMdj+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eTsD0Roazi0FSMEkRZ0QUIyEP6/uCZycEzj3PQiprx0zxrnvqzflIIYpU9VyH6pki
	 btIME/rVbw4hFK6t+sjj4qF+VOxK65ERGXHe9ff8t4zGl7QJeoDrMlxjbK44YMOCGY
	 5BCr1KDOzOv8aatCOJlyqddC77qPO25s10bdCVpcav31CisL9MVPPWwYF84aJXb4eI
	 XLkYCGfndhnA/ivM9bnU5DSF8TT1wDy2bPTXzB21e92ou9m7wcB5N5DwXovdmsxh88
	 5P6nYK/8e+WdOcpx+/JXbJMsuDljVClQxmUwHJaKs/FaLjmfKao+rQvc6lg6W4yB/y
	 Akr1w0si9UAhJNlu+wzCyJRXGCNmtVfoSj41pb3nru3E4c+VFzV7IQpC5B++YqdcX4
	 j023bLX4BesExDYRmsW3EwN7ERwUwU2UVrWqDF5TCpKEM+49IMuOlWH5JvWQ7PThMf
	 NfzvUper7MM+s+2Adj58h7zfvpxOU6B9qTEml+3QogXWeEZIU+kTR1Uqoyyexc3C9a
	 Au0rWtbvu7aJfhDkSAmgM6LnsNPKSnYVnrsFeKCqVU0XajsiCH1Ubuodw0Fv/cW5fl
	 3GlTqyo1d3TuL5C1x8F+Eb+4V/7+ejJXr9GHp2Youcny+jGKH/cD9xAMSqoaXtcsRk
	 RQ4ZKhwEbFV4zvAMlWbg5uH4=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 74E5A40E016C;
	Wed, 10 Jan 2024 15:27:51 +0000 (UTC)
Date: Wed, 10 Jan 2024 16:27:45 +0100
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
Message-ID: <20240110152745.GDZZ63cekYEDqdajjO@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
 <20240110111344.GBZZ576DpwHHs997Zl@fat_crate.local>
 <625926f9-6c45-4242-ac62-8f36abfcb099@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <625926f9-6c45-4242-ac62-8f36abfcb099@amd.com>

On Wed, Jan 10, 2024 at 09:20:44AM -0600, Tom Lendacky wrote:
> How about saying "... dumping all non-zero entries in the whole ..."

I'm trying not to have long stories in printk statements :)

> and then removing the print below that prints the PFN and "..."

Why remove the print? You want to print every non-null RMP entry in the
2M range, no?

And the "..." says that it is a null entry.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

