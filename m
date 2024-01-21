Return-Path: <kvm+bounces-6490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8908355B6
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 13:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 703301C20F7C
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DF8374C4;
	Sun, 21 Jan 2024 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="d331IEhU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F6D36121;
	Sun, 21 Jan 2024 12:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705840564; cv=none; b=tOUnhgJgnvwdU4WVrYXTDnZnEQENFQGLuTFGzgYDL0P98TGeBnuDITAg9A3qmJY8kGX5H3MEo34hKvKoNqgsrSN2G4YWIIX1XYEFklVpoTYW5J/3Zr1xmVUqec60AVR9IxEphXe/s4NpqTp7eh/xBmcantWwLJ2v1B3ZAbWzVkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705840564; c=relaxed/simple;
	bh=9UC/Z53u3PsWp6d/JmTBZ5MCf2IfR5euiOyakilNmII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sT+WldFFmw8uqGJ/qimaMVLD33HP19fdFz9bjfd2GcmReRPSvaGonWa0VQngk+zRRmeQp+Ob9kNIz1I/STZmRU/IYUuzqxdjiz24yaR1Ersk1T77i6hoae6zQjxFp+aFUolSbcPb6z0MWXztnxTKy6MYb9Z8TFKHidBjhmqS82Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=d331IEhU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 01F4640E01B2;
	Sun, 21 Jan 2024 12:35:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5VXvWGOEi1Tv; Sun, 21 Jan 2024 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705840556; bh=PByWkdngqQVsVKrcULrL2WzGVw8XOq+8thFbN8v7KPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d331IEhU9THYOmhCfeAzn+Gpz0zfijnvxvwy5UTtdLRXw0oq+UysSe1bEP26235e4
	 t3jL1kKriJjTtRlKZuBgeVVNHdLS3tO0YVMbn4Ux/n992sk+wLNb+AE0Rt1PDhHTPK
	 2DeRDVArIuxLY9YR26qVJUcEXhE3yE4jeBtJ0paK9k/LrBomEOKpOGJQXAKGiXhV2B
	 0XP7lkUHibWrvRPErZn6/LHE/ii4zBdnWVpyYeZodQ7Ulq6qYSrjD1Ij50UwasZ78f
	 ZPw0iUI5SldXBprCZGiL06Z6AEnV61APh/kbharRy+KILEQ3WHcy3Amu0ukvZXXAZ3
	 dYGzQrt5rDOshpRpOmVSwAA2mgkXzY7lxRJ9y7XDrv58Mgz3NTtYUTRVrVvQJ2vxv4
	 GfqvCi8py8uAO9pBc1UX/+0FJZGheeEBcORyRAGzdDB2y+w2X/dvSOKBSWDkJUUDsv
	 HRdpg/Vy+AMO7vjlcOuQeYtv/P3fq4+e5tLwxJAv8y82wRGynfNU8kJTE0oUIUGalX
	 SHJRgW2ZmYeBde2+cJ6MOcxdQsN6j0OKi9fJzTSoHy2LMPag0LCKmNj3h6Uc6dhQO3
	 x6eMzJzBthk7sPIrn4nCYkAsg+toch3o7rkiFa7wYwjZaVGAZJI34ddTq5oukHM7N/
	 s4R+kLEoOibIsogmvGSq7Wyk=
Received: from zn.tnic (pd953099d.dip0.t-ipconnect.de [217.83.9.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5DB5340E0177;
	Sun, 21 Jan 2024 12:35:19 +0000 (UTC)
Date: Sun, 21 Jan 2024 13:35:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
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
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Subject: Re: [PATCH v1 25/26] crypto: ccp: Add the SNP_COMMIT command
Message-ID: <20240121123518.GOZa0PhqZVsvIVx3Jc@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-26-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-26-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:53AM -0600, Michael Roth wrote:
> +/**
> + * struct sev_data_snp_commit - SNP_COMMIT structure
> + *
> + * @length: len of the command buffer read by the PSP
> + */
> +struct sev_data_snp_commit {
> +	u32 length;
> +} __packed;
> +

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 11af3dd9126d..31b9266b26ce 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -790,7 +790,7 @@ struct sev_data_snp_shutdown_ex {
 /**
  * struct sev_data_snp_commit - SNP_COMMIT structure
  *
- * @length: len of the command buffer read by the PSP
+ * @length: length of the command buffer read by the PSP
  */
 struct sev_data_snp_commit {
 	u32 length;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

