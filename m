Return-Path: <kvm+bounces-7332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E468840484
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 13:00:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA1662819F2
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66535FEE5;
	Mon, 29 Jan 2024 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IBierxaI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D205FEFE;
	Mon, 29 Jan 2024 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529619; cv=none; b=lCm9GzXIxJ1K8T8sVMs9oF2hpf1m5qM3YFRxkfwJqIK7m8QsK5RODhjp/H2Fs/ekTddDhxv7tIX2vPFeDR7SNwfnjnyWBoRbsbibVAB54xsIxj8KED0y0YF4sGw8/KmiAx7zTxODlQehT/KqL7brQ2GNowcfDuZTuslQFD9draA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529619; c=relaxed/simple;
	bh=mhGFf7MGTE5UAJykdouzYWhk4A4r1a2TZMx7bqBDAL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HyB9MY4A/d0a8Cl2u0PL0f7tMkOwEm1i8+YhU5co8RjYv5maScoR9AqSDpWIRvOVlPy8hYSA1rG0S07DGmfYiOMiSkun0xHp+b5U63Ficd8ZaJZbX3oYoAXR5U+bmEWP7MSSsHg6yQpE6d+iJaV0pGUqM2Kc5yQxNZSEce8fmOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IBierxaI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A8E7B40E0196;
	Mon, 29 Jan 2024 12:00:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id O1PSSIUvSr7N; Mon, 29 Jan 2024 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706529610; bh=/7xdwftFvU+K+fkB5/ftiK4NLEcLXN8V2ZAOrBtCZIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IBierxaIyAM4wVGGVRMEVa0DhSTk88Xh5/OsGgzc4yP+6lvF1kUD9VZKGAew+NHBk
	 Q7kGzqLvTMr/cz9aNoicn2tPBb271lGceu6yMC3cXAwExtfCV7kF8VqTitg6j/sG6v
	 oLJcAizi3PnbrH56dycJABb3hEU14dL5U02Li4+7Nc7eclV5FfDPpbMRXOokEF4WMh
	 aA8YVFXNFx2WroM0cNQGlOH+9xU6gPwFBySl7FoIsVYslCfQg51BMFrYVyYuwrunM9
	 +ftHYOc1z+qpU3qAsIUI5scOBlpibpkNiiuOIL6kF7C0BAFkXmuKf5sNowzEfPP7A7
	 V/frA2kDd09a9fkvf18ND5bZ0UT0bvklhvTo6r0kID8oikyiKGNFFgW9v8lQeor+AC
	 0N89Ed4xoAnVVZKSfKOZTMFcGRAV2+YeStzr2kEdj4BprulWSHFugZ2dUQNv8ALRRP
	 0h7Cy0WCjKz3yqdnObG/x8fN6OVW5EPRjtH/oyymOa2RKAL8I6DksXWuR5Mc4igIAG
	 OV8POWpWzWX1g04MaabkYiJfBVCA8egDSArYfvEXl2bIjTNdiKpu59WvZA7MFZ4qyH
	 yHIbgrkCVe7vMaOO4/FnbijEXMg6/T+tQMWhqY0DwOGiMrVLaZqjh16+IrNNXnDYjk
	 kStk+XZ13tqUQvqFgyhus5/0=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AB5CF40E01B3;
	Mon, 29 Jan 2024 11:59:33 +0000 (UTC)
Date: Mon, 29 Jan 2024 12:59:28 +0100
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
Subject: Re: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant
 RMP faults
Message-ID: <20240129115928.GBZbeTIJUYivEMSonh@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
 <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
 <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
 <20240126235420.mu644waj2eyoxqx6@amd.com>
 <20240127114207.GBZbTsDyC3hFq8pQ3D@fat_crate.local>
 <20240127154506.v3wdio25zs6i2lc3@amd.com>
 <20240127160249.GDZbUpKW_cqRzdYn7Z@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240127160249.GDZbUpKW_cqRzdYn7Z@fat_crate.local>

On Sat, Jan 27, 2024 at 05:02:49PM +0100, Borislav Petkov wrote:
> This function takes any PFN it gets passed in as it is. I don't care
> who its users are now or in the future and whether they pay attention
> what they pass into - it needs to be properly defined.

Ok, we solved it offlist, here's the final version I have. It has
a comment explaining what I was asking.

---
From: Michael Roth <michael.roth@amd.com>
Date: Thu, 25 Jan 2024 22:11:11 -0600
Subject: [PATCH] x86/sev: Adjust the directmap to avoid inadvertent RMP faults

If the kernel uses a 2MB or larger directmap mapping to write to an
address, and that mapping contains any 4KB pages that are set to private
in the RMP table, an RMP #PF will trigger and cause a host crash.

SNP-aware code that owns the private PFNs will never attempt such
a write, but other kernel tasks writing to other PFNs in the range may
trigger these checks inadvertently due to writing to those other PFNs
via a large directmap mapping that happens to also map a private PFN.

Prevent this by splitting any 2MB+ mappings that might end up containing
a mix of private/shared PFNs as a result of a subsequent RMPUPDATE for
the PFN/rmp_level passed in.

Another way to handle this would be to limit the directmap to 4K
mappings in the case of hosts that support SNP, but there is potential
risk for performance regressions of certain host workloads.

Handling it as-needed results in the directmap being slowly split over
time, which lessens the risk of a performance regression since the more
the directmap gets split as a result of running SNP guests, the more
likely the host is being used primarily to run SNP guests, where
a mostly-split directmap is actually beneficial since there is less
chance of TLB flushing and cpa_lock contention being needed to perform
these splits.

Cases where a host knows in advance it wants to primarily run SNP guests
and wishes to pre-split the directmap can be handled by adding
a tuneable in the future, but preliminary testing has shown this to not
provide a signficant benefit in the common case of guests that are
backed primarily by 2MB THPs, so it does not seem to be warranted
currently and can be added later if a need arises in the future.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240126041126.1927228-12-michael.roth@amd.com
---
 arch/x86/virt/svm/sev.c | 86 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index c0b4c2306e8d..8da9c5330ff0 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -368,6 +368,82 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+/*
+ * If the kernel uses a 2MB or larger directmap mapping to write to an address,
+ * and that mapping contains any 4KB pages that are set to private in the RMP
+ * table, an RMP #PF will trigger and cause a host crash. Hypervisor code that
+ * owns the PFNs being transitioned will never attempt such a write, but other
+ * kernel tasks writing to other PFNs in the range may trigger these checks
+ * inadvertently due a large directmap mapping that happens to overlap such a
+ * PFN.
+ *
+ * Prevent this by splitting any 2MB+ mappings that might end up containing a
+ * mix of private/shared PFNs as a result of a subsequent RMPUPDATE for the
+ * PFN/rmp_level passed in.
+ *
+ * Note that there is no attempt here to scan all the RMP entries for the 2MB
+ * physical range, since it would only be worthwhile in determining if a
+ * subsequent RMPUPDATE for a 4KB PFN would result in all the entries being of
+ * the same shared/private state, thus avoiding the need to split the mapping.
+ * But that would mean the entries are currently in a mixed state, and so the
+ * mapping would have already been split as a result of prior transitions.
+ * And since the 4K split is only done if the mapping is 2MB+, and there isn't
+ * currently a mechanism in place to restore 2MB+ mappings, such a check would
+ * not provide any usable benefit.
+ *
+ * More specifics on how these checks are carried out can be found in APM
+ * Volume 2, "RMP and VMPL Access Checks".
+ */
+static int adjust_direct_map(u64 pfn, int rmp_level)
+{
+	unsigned long vaddr;
+	unsigned int level;
+	int npages, ret;
+	pte_t *pte;
+
+	/*
+	 * pfn_to_kaddr() will return a vaddr only within the direct
+	 * map range.
+	 */
+	vaddr = (unsigned long)pfn_to_kaddr(pfn);
+
+	/* Only 4KB/2MB RMP entries are supported by current hardware. */
+	if (WARN_ON_ONCE(rmp_level > PG_LEVEL_2M))
+		return -EINVAL;
+
+       if (!pfn_valid(pfn))
+               return -EINVAL;
+
+       if (rmp_level == PG_LEVEL_2M &&
+           (!IS_ALIGNED(pfn, PTRS_PER_PMD) ||
+            !pfn_valid(pfn + PTRS_PER_PMD - 1)))
+		return -EINVAL;
+
+	/*
+	 * If an entire 2MB physical range is being transitioned, then there is
+	 * no risk of RMP #PFs due to write accesses from overlapping mappings,
+	 * since even accesses from 1GB mappings will be treated as 2MB accesses
+	 * as far as RMP table checks are concerned.
+	 */
+	if (rmp_level == PG_LEVEL_2M)
+		return 0;
+
+	pte = lookup_address(vaddr, &level);
+	if (!pte || pte_none(*pte))
+		return 0;
+
+	if (level == PG_LEVEL_4K)
+		return 0;
+
+	npages = page_level_size(rmp_level) / PAGE_SIZE;
+	ret = set_memory_4k(vaddr, npages);
+	if (ret)
+		pr_warn("Failed to split direct map for PFN 0x%llx, ret: %d\n",
+			pfn, ret);
+
+	return ret;
+}
+
 /*
  * It is expected that those operations are seldom enough so that no mutual
  * exclusion of updaters is needed and thus the overlap error condition below
@@ -384,11 +460,16 @@ EXPORT_SYMBOL_GPL(psmash);
 static int rmpupdate(u64 pfn, struct rmp_state *state)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
-	int ret;
+	int ret, level;
 
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENODEV;
 
+	level = RMP_TO_PG_LEVEL(state->pagesize);
+
+	if (adjust_direct_map(pfn, level))
+		return -EFAULT;
+
 	do {
 		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
@@ -398,7 +479,8 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 	} while (ret == RMPUPDATE_FAIL_OVERLAP);
 
 	if (ret) {
-		pr_err("RMPUPDATE failed for PFN %llx, ret: %d\n", pfn, ret);
+		pr_err("RMPUPDATE failed for PFN %llx, pg_level: %d, ret: %d\n",
+		       pfn, level, ret);
 		dump_rmpentry(pfn);
 		dump_stack();
 		return -EFAULT;
-- 
2.43.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

