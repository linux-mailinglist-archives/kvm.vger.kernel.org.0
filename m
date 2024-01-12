Return-Path: <kvm+bounces-6142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAD482C221
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 15:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F8FF1F258D1
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 14:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DCC6E2C3;
	Fri, 12 Jan 2024 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Uq/rcauV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C926DD16;
	Fri, 12 Jan 2024 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2195A40E01BB;
	Fri, 12 Jan 2024 14:50:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id j0ZiORjLOv0g; Fri, 12 Jan 2024 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705071016; bh=nqVhozkdasMvoNMNWSSH6FJXsbVj0/v6l5vQpljdmiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uq/rcauVAF/rPaiz6zG4iwcyP/DJrKvon5cm7DsCpvv4EfqvJbpDlNpRuNhfhu72L
	 n8IrDjE75/gjytSFQmBDYV+RfXzJ5yPbmWYErAT4jGQHPgp9fTYohyoE/hw6Ic509I
	 EoKI50jTnVkmhyJb73dkILrUIECLcmIj8qFIsZS0LSzioXwtpKYMdTyVeCzOp+jTAu
	 eswxAZ6hDFO/fdZBLGyMWGSbn+hdpFC72aRyo2dLJaHPSGHiWrawt6r1nl/QpSOZEq
	 po0eksPZQ3C5njl94LFXpntvJxTOSx/1TpV4ZHecnzsEvRgDodYPzfu7vznZi1knt5
	 e11dAhUw4NtAGRdUsBK5wIs9HFPwAc/bayH04wPymSCxGKgNBMX68hI2nTmcfQxdZR
	 jDqwIBJKuiBIEEETVzTvKfLT0bN3FMAiRnQzvHxvGalGKUbxX7bh+8lg5Whx5MSOC1
	 W+/5lMfe87IhbXpJFI+X4WIUjnVT2dUA4imi3IR/AKWcErPvsHeAgxmv5vgUdlf9bm
	 FZyjY+aOH8hxRoWUWFCEsBQ2BGhEHTxa4HjzR8ymv8uO60uwA/S85/BgcTGfBenv1Y
	 48POGnd7/NvuF/kg3fM8WUIzdT/x9J+Hj9IhZc2TjQezZuldVKsalPi3428QxA45E0
	 sVyGs7NksRVilK6HjRwuPKo4=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 441A340E016C;
	Fri, 12 Jan 2024 14:49:38 +0000 (UTC)
Date: Fri, 12 Jan 2024 15:49:31 +0100
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
Subject: Re: [PATCH v1 10/26] x86/sev: Add helper functions for RMPUPDATE and
 PSMASH instruction
Message-ID: <20240112144931.GCZaFRewg1ft-oS_rY@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-11-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-11-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:38AM -0600, Michael Roth wrote:
> +static int rmpupdate(u64 pfn, struct rmp_state *state)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENODEV;
> +

Let's document this deal here and leave the door open for potential
future improvements:

---

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index c9156ce47c77..1fbf9843c163 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -374,6 +374,21 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENODEV;
 
+	/*
+	 * It is expected that those operations are seldom enough so
+	 * that no mutual exclusion of updaters is needed and thus the
+	 * overlap error condition below should happen very seldomly and
+	 * would get resolved relatively quickly by the firmware.
+	 *
+	 * If not, one could consider introducing a mutex or so here to
+	 * sync concurrent RMP updates and thus diminish the amount of
+	 * cases where firmware needs to lock 2M ranges to protect
+	 * against concurrent updates.
+	 *
+	 * The optimal solution would be range locking to avoid locking
+	 * disjoint regions unnecessarily but there's no support for
+	 * that yet.
+	 */
 	do {
 		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"

> +	do {
> +		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> +		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> +			     : "=a" (ret)
> +			     : "a" (paddr), "c" ((unsigned long)state)
> +			     : "memory", "cc");
> +	} while (ret == RMPUPDATE_FAIL_OVERLAP);
> +
> +	if (ret) {
> +		pr_err("RMPUPDATE failed for PFN %llx, ret: %d\n", pfn, ret);
> +		dump_rmpentry(pfn);
> +		dump_stack();
> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

