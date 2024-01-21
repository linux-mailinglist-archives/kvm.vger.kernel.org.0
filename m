Return-Path: <kvm+bounces-6491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C738355BB
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 13:42:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0BA61F21FCA
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E52F374CF;
	Sun, 21 Jan 2024 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RZTMuyMX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A4E37152;
	Sun, 21 Jan 2024 12:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705840909; cv=none; b=LIdXv5f2qb3iHPMaBWQeCWRwCtpla0ddfD64HI/djzILhLk+5OpYrlK0bwDO7jNxwq8ZwtUcw9tA/Fp9ZC/LNqP0Ptc/kaaytWU5DArhlQLy4TwaqGPrSL7tcyjGAH1IXpiQFKQ8jtTjDsJ5zqWl14TD4nNLPllqozHrWOeFCgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705840909; c=relaxed/simple;
	bh=b8kssEXUcXyp+9yNySq1ZhZ7sO+9Z0J8oTphLVHUrSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwkeuV/KyvymrBKUTf28Yu06BHC+jmED+oVuwx/OZPLPjWfpN7b4fxx9d44h4DP8ZJ36x0toh+5+71+j+u+9qv1A4Q0jFV1l4UJW5kNeZbuex6xosNaFMCHs1dxy6rGeBkhIgxcuGyJtZsspXkQeMIaFIU1BQpJGSse6oScfN9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RZTMuyMX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3174D40E0177;
	Sun, 21 Jan 2024 12:41:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id n2xllazxIvv4; Sun, 21 Jan 2024 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705840903; bh=DdanBUUkzmEiL4WSI9ML5YIGh668EwCLp/CMKO1Dfnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZTMuyMX3VgHk63OanWHbKzjFKwZiqdXLYCiVXJhzB9i3WpVpKJ+3d6zftj9gSVIu
	 77xLCZ1tjQvsjiwNzqySdXhaV3DVPeAkW7s2edCI3z2wUsyhmbWQwv1qUyLv/3eZu6
	 K20T0sIVPQp9u2CcqztXJnr+dDoELbMEVVCpUvp9pTO1erBkf/id+HlwoiDMl68k6F
	 LHrQLs5kOa/9KSQF946VvtBl6Lo8Jr7Q9eeLd/MPMLaZZn7koA4cQJkBQkXpaElTSz
	 pnl7ekltsypo7YyGIefJlpkGg8cGkK78qVbdj03pRewqW9RFwHk4iBph9+nKBJpWE8
	 wB5MdGS/taoN5YeyhbdJGTQBNoSqkmcYbWdRB4dQi0PQQI1SteJOAcDTb4fTzu99dc
	 z18R/pNaxbGy4q7gV2dWtMN7Q+6lYimR58vxr3O5ZgPQMsfkTNNbzI+E8y1fI5bKDE
	 W1wasiStWVkB+t3kGq6tmnX6TcFmaFZ8sQbvGS6w6fr5k0anDm+Ddvhl9Z1B4dbrA6
	 G9lkDN+ZCwy+lEoJxh8xDRQDTwPqENL0bomUjFV975KK2npNCLfKK6U8JUZKTmwPq5
	 uUmzyeDDN/p0tR1uyS3ajxEg/gVjrbvq4hiUKq8D8b2m8guGhuodYpWBp0qnba2W5M
	 LwAkg6N092PjLvUSz+CFsiho=
Received: from zn.tnic (pd953099d.dip0.t-ipconnect.de [217.83.9.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9771940E016C;
	Sun, 21 Jan 2024 12:41:03 +0000 (UTC)
Date: Sun, 21 Jan 2024 13:41:02 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Dionna Glaze <dionnaglaze@google.com>
Subject: Re: [PATCH v1 26/26] crypto: ccp: Add the SNP_SET_CONFIG command
Message-ID: <20240121124102.GPZa0Q3oBHLG0fH_yn@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-27-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-27-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:54AM -0600, Michael Roth wrote:
> +The SNP_SET_CONFIG is used to set the system-wide configuration such as
> +reported TCB version in the attestation report. The command is similar to
> +SNP_CONFIG command defined in the SEV-SNP spec. The current values of the
> +firmware parameters affected by this command can be queried via
> +SNP_PLATFORM_STATUS.

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 4f696aacc866..14c9de997b7d 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -169,10 +169,10 @@ that of the currently installed firmware.
 :Parameters (in): struct sev_user_data_snp_config
 :Returns (out): 0 on success, -negative on error
 
-The SNP_SET_CONFIG is used to set the system-wide configuration such as
-reported TCB version in the attestation report. The command is similar to
-SNP_CONFIG command defined in the SEV-SNP spec. The current values of the
-firmware parameters affected by this command can be queried via
+SNP_SET_CONFIG is used to set the system-wide configuration such as
+reported TCB version in the attestation report. The command is similar
+to SNP_CONFIG command defined in the SEV-SNP spec. The current values of
+the firmware parameters affected by this command can be queried via
 SNP_PLATFORM_STATUS.
 
 3. SEV-SNP CPUID Enforcement

---

Ok, you're all reviewed. Please send a new revision with *all* feedback
addressed so that I can queue it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

