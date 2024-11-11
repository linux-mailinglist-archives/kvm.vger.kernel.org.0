Return-Path: <kvm+bounces-31438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5AF9C3C19
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D01491F226AC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D6F171E7C;
	Mon, 11 Nov 2024 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bjQ2Pxqk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524B14600D;
	Mon, 11 Nov 2024 10:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321307; cv=none; b=UlT7JQF9oMcyVCFh2yCdL/LGQJs5cUfTOCQXfEMVuOz6WKttSOEPiy1DrH9U74Tlghm+Xy67bLF8hMIH5WuUVkJjE1OnKvw3TapqUBfODqkAvlmszYlGhfvmbSug9t0QthUSpdx8mwZ9pN1cfBrYmUDBjOfveOfxD7wOCupzzj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321307; c=relaxed/simple;
	bh=2MtqUS3y97fOQ82JdgQiPRVDC5cdhFwgioSKW2Qzmhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElHyGwW22gBc7FhwGd9J2ZpVnT3GkCCKFynLTXsLa/WkCoV3wzarYjQRG7Qw2RG8r6d5rviHdaFCE/C7RuiV+dohFR2SDpbLPwKoXJ+YX00lsvtk+QsKF7/HjqKSta+hWIKzHQUUHxsLVNr88FG6i6TL4mDg4/ztWGKiqgtri8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bjQ2Pxqk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2A09940E01FE;
	Mon, 11 Nov 2024 10:35:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id R9QoRSL3AYlB; Mon, 11 Nov 2024 10:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731321295; bh=xbzaRnca6qVfPM0PskEZJkeARgpzM8iVthUCgkHuEpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bjQ2PxqkhJkmvtYAbieCpFds7qX5faeDe93Gxl7KORqqy4AqF5OejUIqB1kRS1PS5
	 lUxeaVaAMw9MCh9ZiYZRe/tuEcp0a+huN600nhj1xe7q/9h1/dX1pOroynlwGvinU5
	 LKMLCIjMr8ctNAZT9BQqS6H3Kxn2x9LNCsLaYbOnFuL2y3Ur8EetHocTA2OIpKwI9N
	 mvkUe0UMQyPqnHW7whWLqeuD7VQXQ27MQPS4fahX64dEmT1Nm3nVpYhmI0hJOqU4s1
	 gH84/TfD9fNYYRwwo0CsyrhQ5++fulm1Vf6Xt+8XghvF6RFRwWfMXVjMmU9wUj5FxT
	 gn8/CwPsnwDqPDPMavUaGwFR+a4vPsme+InThOQl1vDnHgFeWMlzVSKklw72He6z8K
	 VveJO33LvQTBHye3iUmcqfTzwZa2d6E3n9F3IgKFu03fuPS2Zj3HpDR9BThO7gOnWC
	 6EwkTdKsuE7vymZ6x8oYEUst0NSPAxRchkrNU6tNvb65OrMcmBnNvFBZPqhZ6YTsnL
	 HELjwx2T2yN5dOYQ3cqnasRrQHLWfK3ZgjQgwXRXSyxtAl1OzP0EssKNazRzU/KBCI
	 SW4vpj+ql92YprcJ/OSHIz97hYz9k0nBwKKg+gFcDMzrZk7H1VVztkPt/GmEfkZ4UG
	 q3+7ZjpvhIPtlxOJPa6VVli0=
Received: from zn.tnic (p200300ea973a31c3329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31c3:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 786AD40E019C;
	Mon, 11 Nov 2024 10:34:44 +0000 (UTC)
Date: Mon, 11 Nov 2024 11:34:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241111103434.GAZzHduouKi4LBwbg8@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>

On Mon, Nov 11, 2024 at 12:33:28PM +0530, Nikunj A. Dadhania wrote:
> kmalloc() does not work at this stage. Moreover, mem_encrypt_setup_arch()
> does not have CC_ATTR_GUEST_SEV_SNP check.

Bah, let's simplify it then:

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 996ca27f0b72..95bae74fdab2 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -94,9 +94,7 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
-	/* Initialize SNP Secure TSC */
-	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		snp_secure_tsc_prepare();
+	snp_secure_tsc_prepare();
 
 	print_mem_encrypt_feature_info();
 }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

