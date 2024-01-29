Return-Path: <kvm+bounces-7338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4792840857
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 15:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D6DC1C21902
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 14:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BED413E22B;
	Mon, 29 Jan 2024 14:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EXF/t4Ls"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391D412F58B;
	Mon, 29 Jan 2024 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538630; cv=none; b=jQrnZyrlxqHzaQxydgfnEk3CejmUHwz5A70SsfsdmIH967V7XaPGrDWYR+BLm7+ob+YWVmafdhh/Og6kUaFnmP/XYxKdKIFCPNcJXpxywHHh4lyMZPsboQyO58GWNiPo9f4oVnDYsPKmeN1fV6StZAj7DWEjTNUH+NSKZhrm29Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538630; c=relaxed/simple;
	bh=ayzDPWWSUzfAB5KHVQGtFP4MQXzJbDYr8DV6p9odp5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N1NIWVK06H/eb1VPZT3E146yj43nBVkjKnk9z6zovy5/Ue8mwzAWBAmN78nCsaqXToG/96NUELb2oRNNfJK0NeTY6sn6no/F8xO3pe/pBfkz/NN+bgQJ1rfewaQyMrWUrEpJrwXX73HjMeWFAKO3HggtcZNx55KcgB/Oz4PU3t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=EXF/t4Ls; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D582D40E0177;
	Mon, 29 Jan 2024 14:30:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FUPz_7lY-mHO; Mon, 29 Jan 2024 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706538620; bh=v/O0496sOj7E1BARErP/HiyS4WURPDfte46HYKMJ6P4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EXF/t4Lsre5LWHpg3suGTHt3uoe6qWn8BUr86sTS2Gc6R2Xs5NwBmITbk/8FoyjUN
	 Ey9o45iD9r94OG5RO2A4jONYert5Z5i0txtLKsaFPexOyVPm/I04zPL3yth7wDKsWV
	 plJYH+ODDcLgOl6qGGk/qtuO/55VVrSN9pntqb5PpGaof+HIOaA+TK7XfnYPclelBL
	 5CJUuOg09x6MdBIMAeUDkSja7oJFNAKH93g7xKq9S7BBzAdajaIZco3qRl5gaN6Feb
	 tEKtApW/w/WznqteTuX2SM4KB9kY24IRQ16NRlxrOjLtfxxk2ySB/kjU+YABK1hrQS
	 glqxWD+qciDMmlEFHRoXbKijLSGPzWktgBlgEGTaMIoP2s1TFtf2wkM08IkGx936Ac
	 HPjwxrmcS28yDBWWpF7xpu+DIM/KwZEDbn5fccpk1T1CpdCxSk1iVwgzZ14vZcGn2E
	 /nV/ozXRkFdREB08sa7/8X+wV2f+qHXUIZh3H74YDq4yWYX+2j+55pljfu1PuHauQ4
	 lLGIqWRSvj0mM8JLHApHV2s1bOU0CMq2C1XOgJgLjqGR3Y5Ixp8QebJBYUYOKuo89q
	 SvFDW6w2HEFXtHMQ/uoXpIDw1Npgc7fYp8n5oBbNd+mXkuLiTUabQWq25OLvvsv1S2
	 xIiLpOGbHDTn0ICST7wICnHE=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0337A40E00C5;
	Mon, 29 Jan 2024 14:29:43 +0000 (UTC)
Date: Mon, 29 Jan 2024 15:29:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com
Subject: Re: [PATCH v2 15/25] x86/sev: Introduce snp leaked pages list
Message-ID: <20240129142939.GCZbe2U3lb2RPV7VOg@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-16-michael.roth@amd.com>
 <1cc76023-ef3e-4639-9a02-644c5abe918d@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1cc76023-ef3e-4639-9a02-644c5abe918d@suse.cz>

On Mon, Jan 29, 2024 at 03:26:29PM +0100, Vlastimil Babka wrote:
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Some minor nitpicks:

Thanks, here's what I have applied:

commit c3875aff4e0739a6af385795470da70d675a7635
Author: Ashish Kalra <ashish.kalra@amd.com>
Date:   Thu Jan 25 22:11:15 2024 -0600

    x86/sev: Introduce an SNP leaked pages list
    
    Pages are unsafe to be released back to the page-allocator if they
    have been transitioned to firmware/guest state and can't be reclaimed
    or transitioned back to hypervisor/shared state. In this case, add them
    to an internal leaked pages list to ensure that they are not freed or
    touched/accessed to cause fatal page faults.
    
      [ mdr: Relocate to arch/x86/virt/svm/sev.c ]
    
    Suggested-by: Vlastimil Babka <vbabka@suse.cz>
    Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
    Signed-off-by: Michael Roth <michael.roth@amd.com>
    Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
    Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
    Link: https://lore.kernel.org/r/20240126041126.1927228-16-michael.roth@amd.com

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index d3ccb7a0c7e9..435ba9bc4510 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -264,6 +264,7 @@ void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
+void snp_leak_pages(u64 pfn, unsigned int npages);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -275,6 +276,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index f1be56555ee6..901863a842d7 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -65,6 +65,11 @@ static u64 probed_rmp_base, probed_rmp_size;
 static struct rmpentry *rmptable __ro_after_init;
 static u64 rmptable_max_pfn __ro_after_init;
 
+static LIST_HEAD(snp_leaked_pages_list);
+static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
+
+static unsigned long snp_nr_leaked_pages;
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -515,3 +520,35 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 	return rmpupdate(pfn, &state);
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
+
+void snp_leak_pages(u64 pfn, unsigned int npages)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	pr_warn("Leaking PFN range 0x%llx-0x%llx\n", pfn, pfn + npages);
+
+	spin_lock(&snp_leaked_pages_list_lock);
+	while (npages--) {
+
+		/*
+		 * Reuse the page's buddy list for chaining into the leaked
+		 * pages list. This page should not be on a free list currently
+		 * and is also unsafe to be added to a free list.
+		 */
+		if (likely(!PageCompound(page)) ||
+
+			/*
+			 * Skip inserting tail pages of compound page as
+			 * page->buddy_list of tail pages is not usable.
+			 */
+		    (PageHead(page) && compound_nr(page) <= npages))
+			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
+
+		dump_rmpentry(pfn);
+		snp_nr_leaked_pages++;
+		pfn++;
+		page++;
+	}
+	spin_unlock(&snp_leaked_pages_list_lock);
+}
+EXPORT_SYMBOL_GPL(snp_leak_pages);


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

