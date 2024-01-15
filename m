Return-Path: <kvm+bounces-6281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26ADE82E103
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 20:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DBA41C2213A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 19:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4835518EB2;
	Mon, 15 Jan 2024 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YBn4l2yZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706601946B;
	Mon, 15 Jan 2024 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 56E6340E00C5;
	Mon, 15 Jan 2024 19:54:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lrd4RczTfciN; Mon, 15 Jan 2024 19:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705348470; bh=I4BKZtuvMD15eVn77Cz+lQijb+Y1S7XFupTLxcf4oE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YBn4l2yZDBQIdtVHUG8a/mOmP6/3Gsh4aeEBRtuGaPtmexmHp9kFY1/oxtGOL4UYa
	 byrLcZvvavZIyKQXHlRtjcatJJJr29tl0I+HSVSOF91YUAIdFzSMAks3ALhb/PETHD
	 H9uYUaveM/qbFTCzNqzcFTy/1/KR0wThYlzGFZBfJiKh8G3B44+eMQU0jAUkQsXwms
	 qS77R7rzVDiTXfPSUwPf5YUCIGq4M64Md7a5So9m6Fr/PdJrBkgXCNjZt87URhdQI9
	 M9pcMqxja2+9qVAxfGVlpWOhCjJ3kRR65KwNUr03se5p7bKnEJXofDla+jH7XZq6nS
	 yJiQURs13J92fCnMQWuSv+rdJrAF5x6iljCW6KoJEnTBn/ewoimrWG2pwBe1k5YECH
	 AjGDCzLWCMgLH4KpDxHieorQmia3aXKaP79KMaeOYcQw9fTRDDC4ZcHF/aPSGhb0DX
	 IS3ma6xVNYVSSbVPXjCKH1jOTXKUWjOZR7un2qb4kwf68oKEHLirOqbZl2Bu2I85Lg
	 C2BWKxYh21FEPaiI8g49UfEtWR64ZOenqxUUPDDitJY3hvPwqG4LzrwHwB/4yv/QmP
	 VX8c+VRNBbgKnLBFjxesXBr0SLgN5UDSA6TJ/NxCX9+OJZRmK9C8pKIdnNL3F4fhyQ
	 JqZY8OigMA3mcN8cIvohNEEA=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AF81F40E01A9;
	Mon, 15 Jan 2024 19:53:52 +0000 (UTC)
Date: Mon, 15 Jan 2024 20:53:46 +0100
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
Message-ID: <20240115195334.GHZaWNPiqbTg82QS_A@fat_crate.local>
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
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Before SNP VMs can be launched, the platform must be appropriately
> configured and initialized. Platform initialization is accomplished via
> the SNP_INIT command. Make sure to do a WBINVD and issue DF_FLUSH
> command to prepare for the first SNP guest launch after INIT.
							  ^^^^^^
Which "INIT"?

Sounds like after hipervisor's init...

> During the execution of SNP_INIT command, the firmware configures
> and enables SNP security policy enforcement in many system components.
> Some system components write to regions of memory reserved by early
> x86 firmware (e.g. UEFI). Other system components write to regions
> provided by the operation system, hypervisor, or x86 firmware.
> Such system components can only write to HV-fixed pages or Default
> pages. They will error when attempting to write to other page states

"... to pages in other page states... "

> after SNP_INIT enables their SNP enforcement.

And yes, this version looks much better. Some text cleanups ontop:

---
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 85634d4f8cfe..7942ec730525 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -549,24 +549,22 @@ static int __sev_snp_init_locked(int *error)
 		return 0;
 	}
 
-	/*
-	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
-	 * across all cores.
-	 */
+	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(snp_set_hsave_pa, NULL, 1);
 
 	/*
-	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
-	 * system physical address ranges to convert into the HV-fixed page states
-	 * during the RMP initialization.  For instance, the memory that UEFI
-	 * reserves should be included in the range list. This allows system
+	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
+	 * of system physical address ranges to convert into HV-fixed page
+	 * states during the RMP initialization.  For instance, the memory that
+	 * UEFI reserves should be included in the that list. This allows system
 	 * components that occasionally write to memory (e.g. logging to UEFI
-	 * reserved regions) to not fail due to RMP initialization and SNP enablement.
+	 * reserved regions) to not fail due to RMP initialization and SNP
+	 * enablement.
 	 */
 	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
 		/*
 		 * Firmware checks that the pages containing the ranges enumerated
-		 * in the RANGES structure are either in the Default page state or in the
+		 * in the RANGES structure are either in the default page state or in the
 		 * firmware page state.
 		 */
 		snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -577,7 +575,7 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		/*
-		 * Retrieve all reserved memory regions setup by UEFI from the e820 memory map
+		 * Retrieve all reserved memory regions from the e820 memory map
 		 * to be setup as HV-fixed pages.
 		 */
 		rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
@@ -599,14 +597,13 @@ static int __sev_snp_init_locked(int *error)
 	}
 
 	/*
-	 * The following sequence must be issued before launching the
-	 * first SNP guest to ensure all dirty cache lines are flushed,
-	 * including from updates to the RMP table itself via RMPUPDATE
-	 * instructions:
+	 * The following sequence must be issued before launching the first SNP
+	 * guest to ensure all dirty cache lines are flushed, including from
+	 * updates to the RMP table itself via the RMPUPDATE instruction:
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

