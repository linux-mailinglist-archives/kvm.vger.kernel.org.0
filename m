Return-Path: <kvm+bounces-6385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B098302C2
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 10:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE296286FFD
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 09:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF59B14A8D;
	Wed, 17 Jan 2024 09:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AUPVTfrH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B1C1429A;
	Wed, 17 Jan 2024 09:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705484970; cv=none; b=JfonRDNpQM+vPDXLpjp1FE+VYn3BoI1EAH74VnOUNOBosLYHnNG4Fj793k5CTX1xD+ingI6EOImzJXZJfc+ZKhOGHLT4dxb5+RViF0IrQWYagweJf6KzT6HGB80ZUw6IDQ6jGakubGWqmlSCITsTeIvFWZheTOc7C5itW4xbYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705484970; c=relaxed/simple;
	bh=NeXbzY9+OZVSrlATeMXiaBJzHoo1NhZn/JV7MllYRi0=;
	h=Received:X-Virus-Scanned:Received:DKIM-Signature:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=cFJfRmgDWlRHNWoG7VsDScRnYrE4kirxXFhq55QepTOcHCi6LN1k74KAIhVDzwoK9jCdSeGzyik0XI2+wNtV4Nw1nFB74n6xOADLTZRoNl2YW1jkWD8BNy5iyCS7bybQPkBLUi6mNZBP3JpZ/myeJozV1dG7HtlRCHqoZHhOQys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AUPVTfrH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8DE3840E0177;
	Wed, 17 Jan 2024 09:49:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 73h8eGAiSvco; Wed, 17 Jan 2024 09:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705484962; bh=CjSLyfAbv41XmX0Cv5sZW7YHSOKxGuGf033WvhzwPIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AUPVTfrHiTingPKZFsEqLYK+TO00Iy3wbEj0fI4XxjUUpFdFJlDE/XHGxTyF8nNo4
	 VVarO1oPMsXUftLhWvSIRZLQ47Bo2voFTP1gEo4+hhuX7kAFqnYkYo7+NqfLY/uV7x
	 w3KOTxa1iOIkskfSCrMQde/2pRbzPQuY69h+gNahEfptdViN4dIKJ1W6FCleIgSWEe
	 CUkAZBF1by7UteEN7U2wuUWNo/W22/k1TU4LbMVGxvVzMHFBJjvdcbChVzoBZhNb36
	 oTgykRuhLSJ9UI7ECrukEUA0afo/IfqgN3GdaptmgQgdedHpMQto+oM4zz67TmD10h
	 PYsXe+s1aGs1umDN8NlMjTYJBJQZXugAMHwhoeRPfhEUaYo+eYxIkcZDyJyOHmOPGo
	 WTNGuznm7QQ+70yycVYpQhWrGOVDGcBljzDDbQVoc7cDjD0KV0tKRVohIfoR++sWx/
	 Ff/nNR578eIa8XaX2HnSPfonK33YzATVzjQbPgsbzjOUYtXpMPu0yp98yegOQonIcC
	 rKkr85aYezQJWaYLAV7mG2gdRRW2FPECtlw+FMAoDg/o9K/FCOLPr65iTRc8vorClb
	 8HZJsWJHOZ2wNwTGoo59jdcsMfyhyvXm6PSAW7yKHhBfnOlPLypb2vQ7Vi4wlTzBY+
	 ITa9H0uT9nSwrrTWtNdFtXec=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BA00240E01B2;
	Wed, 17 Jan 2024 09:48:43 +0000 (UTC)
Date: Wed, 17 Jan 2024 10:48:37 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 14/26] crypto: ccp: Provide API to issue SEV and SNP
 commands
Message-ID: <20240117094837.GIZaeidSVUPFF7792g@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-15-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-15-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:42AM -0600, Michael Roth wrote:
> +/**
> + * sev_do_cmd - issue an SEV or an SEV-SNP command
> + *
> + * @cmd: SEV or SEV-SNP firmware command to issue
> + * @data: arguments for firmware command
> + * @psp_ret: SEV command return code
> + *
> + * Returns:
> + * 0 if the SEV successfully processed the command

More forgotten feedback:

---
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 0581f194cdd0..a356a7b7408e 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -922,7 +922,7 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
  * @psp_ret: SEV command return code
  *
  * Returns:
- * 0 if the SEV successfully processed the command
+ * 0 if the SEV device successfully processed the command
  * -%ENODEV    if the PSP device is not available
  * -%ENOTSUPP  if PSP device does not support SEV
  * -%ETIMEDOUT if the SEV command timed out

---

Also, pls add it to your TODO list as a very low prio item to fixup all
this complains about:

./scripts/kernel-doc -none include/linux/psp-sev.h

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

