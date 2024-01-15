Return-Path: <kvm+bounces-6215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EFC82D63A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:42:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 751BE1C214D5
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBE5101DB;
	Mon, 15 Jan 2024 09:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kZq7oIgp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EF9F9D3;
	Mon, 15 Jan 2024 09:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 367D240E016C;
	Mon, 15 Jan 2024 09:41:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gbcYK8KndIZR; Mon, 15 Jan 2024 09:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705311716; bh=XBIKxlNsZUJPRPkrxlOi1GzgwTad37xoV2mYozz4U4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kZq7oIgpoPYNJEFRmQ9JE48d2cPjKOwShniYdb8svdbjNuXaCXgkI4vm7t9jN3tk3
	 0SyquZx6f4o+581UG8SQEF/a5JXBrhlewfKVgs0DWSPD7Xhu3x7KPorhxYHOrW/ZkW
	 /WkS4JM23S0qQa6J6k/PMJ9/UFQC3c3EAtxAAudXnxy2OfmMr6GryU5ieNcRB0VUqF
	 Kk56gR6BWxDGFlGlKPXEkv3AS1x2RjKgRjF4rN71FCEKHAR7JQV8a9ePmr0epXg4nr
	 +K8OUef+fdVPdl9dDUwxnKAIEtAaEqwy5hTxtLcpu+fZI3TyrfY91wAV77MqGaQJX+
	 I9TV8Vr7MDR6A+XR2gzKocxtwZwUaUPYPtI71n52jydUwNRUFbuLfcJmGPHLs6vmCc
	 GT15I5hrWJ5oS44BqXuvuQz7Gn+RxvthADl5Xqp7KraalD4OGnhM3sIkHtrlPoA+SP
	 ElIlzTj3x2wO4UdsT9YEgQcRKXep+r2BCZohCYiRrppaZJ8uagtla5VglupvrYmOSB
	 Uz8ExwhjAP5m15h1O0Q7sQH1RYxDEBqFCXtAiJLE2g5DCXhPEhpyNgmdJIGvMFTeRG
	 6p+xjuV3jBjkoXBYS7fHf89rG4lL2UmaOvBIU5i6yOHaa7F3eHhKV/VzYkAGlTfiYe
	 I7Bqk/56DF97nG5LMUix8SaU=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AC6A940E01A9;
	Mon, 15 Jan 2024 09:41:19 +0000 (UTC)
Date: Mon, 15 Jan 2024 10:41:12 +0100
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
	"liam.merwick@oracle.com Brijesh Singh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 12/26] crypto: ccp: Define the SEV-SNP commands
Message-ID: <20240115094103.GFZaT9r4zX8V_ax8lv@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-13-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-13-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:40AM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> AMD introduced the next generation of SEV called SEV-SNP (Secure Nested
> Paging). SEV-SNP builds upon existing SEV and SEV-ES functionality
> while adding new hardware security protection.
> 
> Define the commands and structures used to communicate with the AMD-SP
> when creating and managing the SEV-SNP guests. The SEV-SNP firmware spec
> is available at developer.amd.com/sev.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: update SNP command list and SNP status struct based on current
>       spec, use C99 flexible arrays, fix kernel-doc issues]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c |  16 +++
>  include/linux/psp-sev.h      | 264 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/psp-sev.h |  56 ++++++++
>  3 files changed, 336 insertions(+)

More ignored feedback:

https://lore.kernel.org/r/20231124143630.GKZWC07hjqxkf60ni4@fat_crate.local

Lemme send it to you as a diff then - it'll work then perhaps.

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 983d314b5ff5..1a76b5297f03 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -104,7 +104,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_PAGE_RECLAIM	= 0x0C7,
 	SEV_CMD_SNP_PAGE_UNSMASH	= 0x0C8,
 	SEV_CMD_SNP_CONFIG		= 0x0C9,
-	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX	= 0x0CA,
+	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
 	SEV_CMD_SNP_COMMIT		= 0x0CB,
 	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
 
@@ -624,7 +624,8 @@ enum {
  * @gctx_paddr: system physical address of guest context page
  * @page_size: page size 0 indicates 4K and 1 indicates 2MB page
  * @page_type: encoded page type
- * @imi_page: indicates that this page is part of the IMI of the guest
+ * @imi_page: indicates that this page is part of the IMI (Incoming
+ * Migration Image) of the guest
  * @rsvd: reserved
  * @rsvd2: reserved
  * @address: system physical address of destination page to encrypt

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

