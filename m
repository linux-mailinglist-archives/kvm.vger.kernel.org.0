Return-Path: <kvm+bounces-6425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B83831B13
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 15:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5BE9B26F8C
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 14:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAA628DBF;
	Thu, 18 Jan 2024 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Kt3H5wHF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B5125579;
	Thu, 18 Jan 2024 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705586678; cv=none; b=pIuxoYazXE8YUx0RYt2AsFGy0GShV7cBOtLlSZMP1044uM3hgZqAplvsP00yVA5tPVCN+4KALUW1aUR3an5nkc4twkv3qzpQqWsEXalsenhqFUMbBgeHUpYSi54g2jjaZVLWRLTsi8cwdgXI8sAZsEcYb3kRxwOciCaATxB00ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705586678; c=relaxed/simple;
	bh=maSG38FRSlRqfJJYy0Qy2S5rKAfADRtfQn+zD30T+/0=;
	h=Received:X-Virus-Scanned:Received:DKIM-Signature:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=NWSxiwLBCyIVg6MwNUZIuUVFMrUpo6bDSpFyH3xGPP0ctiavYq9d+0aXF8OhsHe01JnVy9nAiTM+iqsEahG76zXbAr+E3bIuTU84F9aFv2U61b/6PTR1ODU0Z3zMv9Wp6bmkw/mmU1cz0UzygB5F3tYowERIq+jrgRLlQUyYY3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Kt3H5wHF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 30A1640E0196;
	Thu, 18 Jan 2024 14:04:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gLCyDuDGzu6c; Thu, 18 Jan 2024 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705586665; bh=VoFIqBDZC2Z/liH3WDJQdK5q0qjW6OBA8h6YdVHmZ98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kt3H5wHF/tNwLtW0f/4BhPNVZfeZzR6mmo1JsyrecxQ+2GjqAAk0RKd5bm9OTceZV
	 ZI4o3+1pW10/YCYAjSmp9UY18092RN0MwaIH0wIuYAegxBGvqSXma0EgQR8Sy6RcKl
	 rBG4WgZ6pAD8UZbYEpW93HQM4eZuX5CQ9Y7UhuLrOK69EjAXTq3EMkECWHa2PTW4ue
	 XW/SlAblPN+o9dG+CC22p6CNi8IB4fovTsV9CK4CWTp7hzv9f0Xrddo0UgWOYUWQju
	 EZejyWpOy/70tZ4einnZMW+vh+90oPY6IDrBkcUGk6fK0dzQmz9rQ55dywi7JS1HWo
	 FOR1rqhVcTEd6o1S0VvY6doKJMxIfFx8acDkSQ6SFhEkrYk1q/747p6PHa/ObA5Qa5
	 X18JH1GeIgQPZV0u5ZAeQON0wKpolt4u0Mm9y/60ACtbuU+nC0U9I4xjB6aiy0rySY
	 glGjVUm1L+SycV0gvjuaZM0iEeuD4cUHW+PlExWusVm0PlQeuKS4WOoQ1pkk8YAbwo
	 LPmS6KEkc7fAdpOUZb1UQnIPXB0ihX5/+qbd320usnEtD+9ts8haiaDrIj1TwhwGEn
	 tqsZVPxmjb6GleGKcm3rQNfHV7dFtnCUQ8PyZnS9byl/kg/IKbV6mcGIRo0nUmvQ+P
	 H1RPqdZLPDbBogXGZW/d2hqs=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 443BF40E0177;
	Thu, 18 Jan 2024 14:03:49 +0000 (UTC)
Date: Thu, 18 Jan 2024 15:03:43 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Subject: Re: [PATCH v1 17/26] crypto: ccp: Handle non-volatile INIT_EX data
 when SNP is enabled
Message-ID: <20240118140333.GJZakvtcJO1QYh8C8-@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-18-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-18-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:45AM -0600, Michael Roth wrote:
>  drivers/crypto/ccp/sev-dev.c | 104 ++++++++++++++++++++++++++---------
>  1 file changed, 79 insertions(+), 25 deletions(-)

Some minor cleanups ontop:

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index dfe7f7afc411..a72ed4466d7b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -266,16 +266,15 @@ static int sev_read_init_ex_file(void)
 }
 
 /*
- * When SNP is enabled, the pages comprising the buffer used to populate
- * the file specified by the init_ex_path module parameter needs to be set
- * to firmware-owned, which removes the mapping from the kernel direct
- * mapping since generally the hypervisor does not access firmware-owned
- * pages. However, in this case the hypervisor does need to read the
- * buffer to transfer the contents to the file at init_ex_path, so this
- * function is used to create a temporary virtual mapping to be used for
- * this purpose.
+ * When SNP is enabled, the pages comprising the buffer used to populate the
+ * file specified by the init_ex_path module parameter needs to be set to
+ * firmware-owned. This removes the mapping from the kernel direct mapping since
+ * generally the hypervisor does not access firmware-owned pages. However, in
+ * this case the hypervisor does need to read the buffer to transfer the
+ * contents to the file at init_ex_path, so create a temporary virtual mapping
+ * to be used for this purpose.
  */
-static void *vmap_sev_init_ex_buffer(void)
+static void *vmap_init_ex_buf(void)
 {
 	struct page *pages[NV_PAGES];
 	unsigned long base_pfn;
@@ -292,6 +291,11 @@ static void *vmap_sev_init_ex_buffer(void)
 	return vmap(pages, NV_PAGES, VM_MAP, PAGE_KERNEL_RO);
 }
 
+static void destroy_init_ex_buf(void *buf)
+{
+	vunmap(buf);
+}
+
 static int sev_write_init_ex_file(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -315,7 +319,7 @@ static int sev_write_init_ex_file(void)
 		return ret;
 	}
 
-	sev_init_ex_buffer = vmap_sev_init_ex_buffer();
+	sev_init_ex_buffer = vmap_init_ex_buf();
 	if (!sev_init_ex_buffer) {
 		dev_err(sev->dev, "SEV: failed to map non-volative memory area\n");
 		return -EIO;
@@ -329,12 +333,12 @@ static int sev_write_init_ex_file(void)
 		dev_err(sev->dev,
 			"SEV: failed to write %u bytes to non volatile memory area, ret %ld\n",
 			NV_LENGTH, nwrite);
-		vunmap(sev_init_ex_buffer);
+		destroy_init_ex_buf(sev_init_ex_buffer);
 		return -EIO;
 	}
 
 	dev_dbg(sev->dev, "SEV: write successful to NV file\n");
-	vunmap(sev_init_ex_buffer);
+	destroy_init_ex_buf(sev_init_ex_buffer);
 
 	return 0;
 }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

