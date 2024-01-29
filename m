Return-Path: <kvm+bounces-7343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A0784096C
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 992521C22A49
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 15:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9709D153BC4;
	Mon, 29 Jan 2024 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="S9hx1zdO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465441534F9;
	Mon, 29 Jan 2024 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706541172; cv=none; b=AvQ2fY07EMq3GJxyRkIP1yVqSaIkfWveZ6ndk1VJ4QCN61J4nMz5owqDO46v13d0LcQ1UE5iHGroE8G8zzSsx6h3JvXQDuONOTdUpLjZjEbwrESb5W9bYmzRUV7OzyA/sM4ohwEoDe83Tyu3cxtQdyV+N1hB3gaE1KsUBmh3EZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706541172; c=relaxed/simple;
	bh=Dqc03FH3/y+CCimsmNhdKUIaCQE9ISImD7T6rsc1jrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M12yS+pSPwf7ggGHWlzA631Pys/HfVH2YZd4+EH8zSnNMop4rOkN/jStFQVS0r/PbrXasPfLs5u2U94wWLQsojhDfdAFIYYS8zOyItT3TyT9LWH9FU01i/m+MQ2MKTOo96rEu7hpkhkuoR3yi2/IMpvPWIiEFE+EITzE6Nds1Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=S9hx1zdO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9222F40E01B3;
	Mon, 29 Jan 2024 15:12:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FcEV77rZWFUk; Mon, 29 Jan 2024 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706541165; bh=bL5xCSJwrqGSh7PjycTnta+ueE1OlQNJBlrjPUL4leY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S9hx1zdOcIxqJ+TSYCPolqP8WXkkgHNAdR4w0m9y4nAbW1lRpOXx4hUNO3a7niAO6
	 CRg850DdKMW6pf7QU6e0oSXk0jhVOesWSAeAbSNeVyAkagFEvFQAeJ98Pz+pDeRe/u
	 wuaAtnzxG3qySggxPGuQ2UdraBaVONAj1Tmvm0fQ12Pxfn/0O0AEgnAYQMdhrhSuW5
	 Bw9G7WVn6VDKUI5PPXjFn3OyYiP59k6ayqOcWt1hFAUlyoI8UtMhWBhSqxRLNWeTbk
	 5rx5a3VxahKYZMLxWt+Jzoxu5K+6RbE9z2BWogMivpGx0Zh7ChPJUQhQYuUy8AtKFV
	 IwGQTnbcTOtYnnM8NJt1TKDTIfHg+2D9vYYR0K7Mt3i900NO1ORPxTlDpKXM45Rt0H
	 /MpFEuo2+YQgm3TVWuRhBamrCH39Jui9iZmeAXVrxYqzFN3hJ4Rfi7Ys902xk8dIJe
	 pTyP42MUpUYsdqx8EBBoHmbQmI+/coZ4rWesDrvlx4dPKnOnX3EoA+DtlpuS5cG6ev
	 zG+tk90ogl6IluFDUSs8OlrX7W5bakTBEPWp3naC8HoK5+0sVuEs/5uvN3iAnDC342
	 egpIGexVZv7Q4/m/x3IZuj25PWvIdW586gJPFFGWwCfSjfXy5QGq+FPXLM8gShJyza
	 1XGRhnYD53wxcTWFeb+ul0qM=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD79D40E0177;
	Mon, 29 Jan 2024 15:12:08 +0000 (UTC)
Date: Mon, 29 Jan 2024 16:12:07 +0100
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
Subject: Re: [PATCH v2 17/25] crypto: ccp: Handle non-volatile INIT_EX data
 when SNP is enabled
Message-ID: <20240129151207.GAZbfAR1_nCqhblsAT@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-18-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240126041126.1927228-18-michael.roth@amd.com>

On Thu, Jan 25, 2024 at 10:11:17PM -0600, Michael Roth wrote:
> -	if (sev_init_ex_buffer) {
> +	/*
> +	 * If an init_ex_path is provided allocate a buffer for the file and
> +	 * read in the contents. Additionally, if SNP is initialized, convert
> +	 * the buffer pages to firmware pages.
> +	 */
> +	if (init_ex_path && !sev_init_ex_buffer) {
> +		struct page *page;
> +
> +		page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
> +		if (!page) {
> +			dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
> +			return -ENOMEM;
> +		}
> +
> +		sev_init_ex_buffer = page_address(page);
> +
>  		rc = sev_read_init_ex_file();
>  		if (rc)
>  			return rc;
> +
> +		/* If SEV-SNP is initialized, transition to firmware page. */
> +		if (sev->snp_initialized) {
> +			unsigned long npages;
> +
> +			npages = 1UL << get_order(NV_LENGTH);
> +			if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer),
> +						    npages, false)) {
> +				dev_err(sev->dev,
> +					"SEV: INIT_EX NV memory page state change failed.\n");
> +				return -ENOMEM;
> +			}
> +		}
>  	}

Ontop:

---
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c364ad33f376..5ec563611953 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -775,6 +775,48 @@ static void __sev_platform_init_handle_tmr(struct sev_device *sev)
 	}
 }
 
+/*
+ * If an init_ex_path is provided allocate a buffer for the file and
+ * read in the contents. Additionally, if SNP is initialized, convert
+ * the buffer pages to firmware pages.
+ */
+static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
+{
+	struct page *page;
+	int rc;
+
+	if (!init_ex_path)
+		return 0;
+
+	if (sev_init_ex_buffer)
+		return 0;
+
+	page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
+	if (!page) {
+		dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	sev_init_ex_buffer = page_address(page);
+
+	rc = sev_read_init_ex_file();
+	if (rc)
+		return rc;
+
+	/* If SEV-SNP is initialized, transition to firmware page. */
+	if (sev->snp_initialized) {
+		unsigned long npages;
+
+		npages = 1UL << get_order(NV_LENGTH);
+		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
+			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
 static int __sev_platform_init_locked(int *error)
 {
 	int rc, psp_ret = SEV_RET_NO_FW_CALL;
@@ -790,39 +832,9 @@ static int __sev_platform_init_locked(int *error)
 
 	__sev_platform_init_handle_tmr(sev);
 
-	/*
-	 * If an init_ex_path is provided allocate a buffer for the file and
-	 * read in the contents. Additionally, if SNP is initialized, convert
-	 * the buffer pages to firmware pages.
-	 */
-	if (init_ex_path && !sev_init_ex_buffer) {
-		struct page *page;
-
-		page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
-		if (!page) {
-			dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
-			return -ENOMEM;
-		}
-
-		sev_init_ex_buffer = page_address(page);
-
-		rc = sev_read_init_ex_file();
-		if (rc)
-			return rc;
-
-		/* If SEV-SNP is initialized, transition to firmware page. */
-		if (sev->snp_initialized) {
-			unsigned long npages;
-
-			npages = 1UL << get_order(NV_LENGTH);
-			if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer),
-						    npages, false)) {
-				dev_err(sev->dev,
-					"SEV: INIT_EX NV memory page state change failed.\n");
-				return -ENOMEM;
-			}
-		}
-	}
+	rc = __sev_platform_init_handle_init_ex_path(sev);
+	if (rc)
+		return rc;
 
 	rc = __sev_do_init_locked(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

