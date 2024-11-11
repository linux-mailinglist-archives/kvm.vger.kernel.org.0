Return-Path: <kvm+bounces-31450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2299C3C6F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0F64282085
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CBE175D34;
	Mon, 11 Nov 2024 10:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BhwQvEZj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5741474B9;
	Mon, 11 Nov 2024 10:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731322339; cv=none; b=cE1zp9VcwJUeHl152+ifrUEs3Ztmv9KlEpL3juzD047UWH32zqR/IKeXjbQJGXr0vOb/OhnJobNRSo6oVUJR/ch5luz5SMqlAtT7Hj1Ta/tRGcwnSd5vcqLWZdK9auKdQQ5+E6hDb7sGBh4LPOwFKn6ox6cu97XOuBOcgoUflvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731322339; c=relaxed/simple;
	bh=+OE7WuuVlD51jNyVk5FSaLOcHh1ptk5gSQB2t8VF1qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COdHTSq/TVLcLocyqVX8Wp2qte6BwH6u85NT9GtM5qTB9pqbS8dDHAb52Y+7UclsDWZKoJAFgJM7QCk0wx7bVTdbkM093ZDQg2oQ/ay65jknn+nj8fdRDlDUMMJcFC4deQuFutRFrilnXVnS7N4e7vEbs2JGtXVfsv2z79cil+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BhwQvEZj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4A35A40E0169;
	Mon, 11 Nov 2024 10:52:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ru_z-eOfPiSA; Mon, 11 Nov 2024 10:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731322329; bh=qMd8DDSKjRjWBUjILwppfrvCZfCueYmajCWJiijRdsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BhwQvEZjZjfQPFxGS6b8ZQCeWikSo4FH7K064fo8grvqWDR3k/+X3JWlAfiuzt5pQ
	 z0Qe+gjbU38/tjFBTEWEflE3OhWSLGOqAIom6jT3kryKV10op5zt0OMIkhoq7FDdGb
	 qLnXScFFTAyCN04jw7Q65AnujaTGu77T5sQ6aHAa+pKBROiO5CNaC1bquMqjvhBk2J
	 kPrZ2quVViQqdBXfYtH2sUPI52gcGXlxP2N2+7bn+dylf4sh8zKTAq2wrWqw23byRE
	 ZJNZkr3UwktOCkM9bKMFWdOcU82izkx2GEAw/FopEXy7g+7Q6kvne5MLi091SFYAmM
	 YCRFywhz6exsnxl5fVsRBASn0z7Ob1oZgBSVrt/7Zo0M5VrwjgjPkCLtrbVW4f4j4R
	 HGNKPv1qWxf8+CzvZukDnS9SU7PV3VcpZQNgqFJIuPA3KMxG/xy0EraMO3YV1DdQFQ
	 oXnUJ3Mg3of80XdO4pIe7ftduwNAaqFuwvSNnB+n5I7SB/c9TpHw3w4x3GHDz64klA
	 376KFbbjA8sjtV6v8FEwgqKu0V/fPw+FSPC+IkrH45ipU1S29SgiFMKB3chw/qzUMk
	 IRjI052IPHV2WNg5hGzDfVNeX5EYnYNNUfWlHaXjjEgcfitvS0M0iFMHpqK+rYcfs9
	 RW0wBBZOHKHwaiD7dSKNx5xY=
Received: from zn.tnic (p200300ea973a31c3329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31c3:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9511640E015F;
	Mon, 11 Nov 2024 10:51:58 +0000 (UTC)
Date: Mon, 11 Nov 2024 11:51:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241111105152.GBZzHhyL4EkqJ5z84X@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
 <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>

On Mon, Nov 11, 2024 at 02:16:00PM +0530, Nikunj A. Dadhania wrote:
> That was the reason I had not implemented "free" counterpart.

Then let's simplify this too because it is kinda silly right now:

---
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index a72400704421..efddccf4b2c6 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -96,7 +96,7 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
-static struct snp_msg_desc *snp_mdesc;
+static struct snp_msg_desc snp_mdesc;
 
 /* Secure TSC values read using TSC_INFO SNP Guest request */
 static u64 snp_tsc_scale __ro_after_init;
@@ -2749,19 +2749,13 @@ EXPORT_SYMBOL_GPL(snp_msg_init);
 
 struct snp_msg_desc *snp_msg_alloc(void)
 {
-	struct snp_msg_desc *mdesc;
+	struct snp_msg_desc *mdesc = &snp_mdesc;
 
 	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
 
-	if (snp_mdesc)
-		return snp_mdesc;
-
-	mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);
-	if (!mdesc)
-		return ERR_PTR(-ENOMEM);
+	memset(mdesc, 0, sizeof(struct snp_msg_desc));
 
-	mdesc->secrets = (__force struct snp_secrets_page *)ioremap_encrypted(secrets_pa,
-									      PAGE_SIZE);
+	mdesc->secrets = (__force struct snp_secrets_page *)ioremap_encrypted(secrets_pa, PAGE_SIZE);
 	if (!mdesc->secrets)
 		return ERR_PTR(-ENODEV);
 
@@ -2783,8 +2777,6 @@ struct snp_msg_desc *snp_msg_alloc(void)
 	mdesc->input.resp_gpa = __pa(mdesc->response);
 	mdesc->input.data_gpa = __pa(mdesc->certs_data);
 
-	snp_mdesc = mdesc;
-
 	return mdesc;
 
 e_free_response:

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

