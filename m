Return-Path: <kvm+bounces-5990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F63829882
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 12:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1556B22A9F
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 11:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6533047796;
	Wed, 10 Jan 2024 11:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DRISGyRR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138B346BB1;
	Wed, 10 Jan 2024 11:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2B03040E01A9;
	Wed, 10 Jan 2024 11:14:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rk1GXipRnNvY; Wed, 10 Jan 2024 11:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704885267; bh=fwWP59DQZ/MSSlZK6nSA8WJmcHMonAP5bkUAu0nzMfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DRISGyRRH2Yb8ljr7qzKxmjDv5PDR//i1JNCPji2bZmoSqvXC2CEFgz/un4zlwdOd
	 1gE3QpuxPCOS/AO49UojJngUhe+gslvuDort5mT6YKdB6PxdpW6SSQ6zI36SoQuZR2
	 j+RNLNTXzjvJQgrviDjXNmGcHbG5Mhmfs3WnhbYXRMEeLIMF9EE/Sfiam/v3lfpkqD
	 jmyhL1yhBFmtW21wCivpy1KA++k78OC13Jex3T8KKx2xdYeruw7kBahsHOSGi83Nc6
	 zsmsThRTTmzDRmCRXhyv4Wh7snbFm9Jn0fzha+wd4J2CxbS65LeqhPk/ZyYjL29/bo
	 uzu+pKOPJQzyhB3gyH2U0vw/1s2cnfvdj8f4glLTntMjkAbIhBlBYRxUu+5LM16j5D
	 U55MFzVMl22H06LDmtwxnqgrBxOzam7Rf4F2Fu/NM/qSWgrU3fe+/dUsfjXHbxCZ5G
	 e7qT409qJNtDLgXCJ76zb6Vl1icGQQwZPxoS/Wdei8VQcHsSvz5xp6cU2JEctfs62k
	 7S7u9Tu+1rKxVl8sIi+n7DFgdXO+dkjJJ2aOKwBMXd4jKb0z/ex7gzelEMo/Qew5t7
	 pM9QC4FIj9hngIZR138Qa4DFSWnFwdYzXo60YT4dvPw5Je2/cOL9wzPkTcg6JofhE0
	 8CJKjCNIb4GEyJfUyPXLgMxs=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 67EAF40E01F9;
	Wed, 10 Jan 2024 11:13:49 +0000 (UTC)
Date: Wed, 10 Jan 2024 12:13:44 +0100
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
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
Message-ID: <20240110111344.GBZZ576DpwHHs997Zl@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-8-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:35AM -0600, Michael Roth wrote:
> +	while (pfn_current < pfn_end) {
> +		e = __snp_lookup_rmpentry(pfn_current, &level);
> +		if (IS_ERR(e)) {
> +			pfn_current++;
> +			continue;
> +		}
> +
> +		e_data = (u64 *)e;
> +		if (e_data[0] || e_data[1]) {
> +			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +				pfn, pfn_current, e_data[1], e_data[0]);
> +			return;
> +		}
> +		pfn_current++;
> +	}
> +
> +	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
> +		pfn);
> +}

Ok, I went and reworked this, see below.

Yes, I think it is important - at least in the beginning - to dump the
whole 2M PFN region for debugging purposes. If that output starts
becoming too unwieldy and overflowing terminals or log files, we'd
shorten it or put it behind a debug option or so.

Thx.

---
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index a8cf33b7da71..259a1dd655a7 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -35,16 +35,21 @@
  * Family 19h Model 01h, Rev B1 processor.
  */
 struct rmpentry {
-	u64	assigned	: 1,
-		pagesize	: 1,
-		immutable	: 1,
-		rsvd1		: 9,
-		gpa		: 39,
-		asid		: 10,
-		vmsa		: 1,
-		validated	: 1,
-		rsvd2		: 1;
-	u64 rsvd3;
+	union {
+		struct {
+			u64	assigned	: 1,
+				pagesize	: 1,
+				immutable	: 1,
+				rsvd1		: 9,
+				gpa		: 39,
+				asid		: 10,
+				vmsa		: 1,
+				validated	: 1,
+				rsvd2		: 1;
+		};
+		u64 lo;
+	};
+	u64 hi;
 } __packed;
 
 /*
@@ -272,22 +277,20 @@ EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
  */
 static void dump_rmpentry(u64 pfn)
 {
-	u64 pfn_current, pfn_end;
+	u64 pfn_i, pfn_end;
 	struct rmpentry *e;
-	u64 *e_data;
 	int level;
 
 	e = __snp_lookup_rmpentry(pfn, &level);
 	if (IS_ERR(e)) {
-		pr_info("Failed to read RMP entry for PFN 0x%llx, error %ld\n",
-			pfn, PTR_ERR(e));
+		pr_err("Error %ld reading RMP entry for PFN 0x%llx\n",
+			PTR_ERR(e), pfn);
 		return;
 	}
 
-	e_data = (u64 *)e;
 	if (e->assigned) {
-		pr_info("RMP entry for PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
-			pfn, e_data[1], e_data[0]);
+		pr_info("PFN 0x%llx, RMP entry: [0x%016llx - 0x%016llx]\n",
+			pfn, e->lo, e->hi);
 		return;
 	}
 
@@ -299,27 +302,28 @@ static void dump_rmpentry(u64 pfn)
 	 * certain situations, such as when the PFN is being accessed via a 2MB
 	 * mapping in the host page table.
 	 */
-	pfn_current = ALIGN(pfn, PTRS_PER_PMD);
-	pfn_end = pfn_current + PTRS_PER_PMD;
+	pfn_i = ALIGN(pfn, PTRS_PER_PMD);
+	pfn_end = pfn_i + PTRS_PER_PMD;
 
-	while (pfn_current < pfn_end) {
-		e = __snp_lookup_rmpentry(pfn_current, &level);
+	pr_info("PFN 0x%llx unassigned, dumping the whole 2M PFN region: [0x%llx - 0x%llx]\n",
+		pfn, pfn_i, pfn_end);
+
+	while (pfn_i < pfn_end) {
+		e = __snp_lookup_rmpentry(pfn_i, &level);
 		if (IS_ERR(e)) {
-			pfn_current++;
+			pr_err("Error %ld reading RMP entry for PFN 0x%llx\n",
+				PTR_ERR(e), pfn_i);
+			pfn_i++;
 			continue;
 		}
 
-		e_data = (u64 *)e;
-		if (e_data[0] || e_data[1]) {
-			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
-				pfn, pfn_current, e_data[1], e_data[0]);
-			return;
-		}
-		pfn_current++;
-	}
+		if (e->lo || e->hi)
+			pr_info("PFN: 0x%llx, [0x%016llx - 0x%016llx]\n", pfn_i, e->lo, e->hi);
+		else
+			pr_info("PFN: 0x%llx ...\n", pfn_i);
 
-	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
-		pfn);
+		pfn_i++;
+	}
 }
 
 void snp_dump_hva_rmpentry(unsigned long hva)
@@ -339,4 +343,3 @@ void snp_dump_hva_rmpentry(unsigned long hva)
 
 	dump_rmpentry(pte_pfn(*pte));
 }
-EXPORT_SYMBOL_GPL(snp_dump_hva_rmpentry);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

