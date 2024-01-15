Return-Path: <kvm+bounces-6219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C776082D843
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 12:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65E4B1F2233C
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 11:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFB52C696;
	Mon, 15 Jan 2024 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="c9ibmYOW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB8D2208A;
	Mon, 15 Jan 2024 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C7BEE40E016C;
	Mon, 15 Jan 2024 11:20:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1FAqnwMpb_Zd; Mon, 15 Jan 2024 11:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705317621; bh=nCwtoIhn1fv1DIHX6b7LJt+v8CCENhFJbxBqG4Uf3iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c9ibmYOWC60KK4KJuKNxRjp9cTDl/t4NGMCh/hIKwI8C8n85ZPub0L2koL6V6bEcL
	 DnLO99QtKwXchL36UkyaqZXBS5DH7fP3jHL9Q/Ctm4+fh8YQ/Zi44hPI/hQd/pdAI4
	 hF/dZoekSuQo4hLubKrITPpOBld2No3hKm8/53/0LY+40mMrigZM8I3pfNjZm2DoIk
	 UROnl9HdofZnPLJ6LMgGqBqaDafsnEMfGqPyc1AfVYJRxj4jSf2YNhaeWiCk9E/3A2
	 a3kH6iByD969PW9vbwfK+YiMd0D9SY1TtpWky0g3RTJAF0hq+BELR+pCArKET/9zsi
	 qWGNTjOJNmElWJ+LYDgjQXdiTHPiLtkxN0MZLSX8sXLtARN3Gs1imoyDUCgjd7VCZC
	 J9vT3kwHNvW4Kf8TVcvfdGoJS6jNtP7zMsdEveUfXAGsMoXMdd0HGdiWKiEuoKaYNA
	 EPtLG2zJlKmm50rZEOmCQzZpToDW7Nw49E+B7wCUUoN+R/Zp/A/UYJ71G3L+X51uGD
	 46T9n5gOcZdmqK0u48Y8hXTy3YOBjU897Pw0gioBU1PMLttNUhCbrT7GUSTA/Bnr02
	 Mj7zI4H0tzj0gA4NTS5FNbwPFc3ylTElAZVRO6fzZXitlK8u8u1qXnQK/5HSONYAJJ
	 l7i/ggtKLhd5cb4XvcaoXjgQ=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1B87140E00C5;
	Mon, 15 Jan 2024 11:19:44 +0000 (UTC)
Date: Mon, 15 Jan 2024 12:19:37 +0100
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
	pankaj.gupta@amd.com,
	"liam.merwick@oracle.com Brijesh Singh" <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v1 13/26] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <20240115111930.GGZaUUwpmmZqxVcBEu@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-14-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-14-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:41AM -0600, Michael Roth wrote:
> +	/*
> +	 * The following sequence must be issued before launching the
> +	 * first SNP guest to ensure all dirty cache lines are flushed,
> +	 * including from updates to the RMP table itself via RMPUPDATE
> +	 * instructions:
> +	 *
> +	 * - WBINDV on all running CPUs
> +	 * - SEV_CMD_SNP_INIT[_EX] firmware command
> +	 * - WBINDV on all running CPUs
> +	 * - SEV_CMD_SNP_DF_FLUSH firmware command
> +	 */

Typos:

---
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 85634d4f8cfe..ce0c56006900 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -604,9 +604,9 @@ static int __sev_snp_init_locked(int *error)
 	 * including from updates to the RMP table itself via RMPUPDATE
 	 * instructions:
 	 *
-	 * - WBINDV on all running CPUs
+	 * - WBINVD on all running CPUs
 	 * - SEV_CMD_SNP_INIT[_EX] firmware command
-	 * - WBINDV on all running CPUs
+	 * - WBINVD on all running CPUs
 	 * - SEV_CMD_SNP_DF_FLUSH firmware command
 	 */
 	wbinvd_on_all_cpus();

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

