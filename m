Return-Path: <kvm+bounces-72128-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DC6MlA4oWkbrQQAu9opvQ
	(envelope-from <kvm+bounces-72128-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:23:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD541B3344
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:23:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B86F531AD805
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 06:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28623E8C73;
	Fri, 27 Feb 2026 06:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CJt1DsxK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A1336ECD
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 06:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772173021; cv=none; b=aeVyZ/18Chk3dsHATD8LnTvYNnzqwl4Pgugpt7U8ZXRyQowTj5GvYEZCDpEsjFXtOj3zpgbRcwC8k3ScmhE4FMFSY++LsFJZXjOQaJ/z3Me+t+iKCsgfxCxXt7nu14575Gn2HxlA2NUQXU0iZSMLIZOgLsW6qhbR25UmxQaFr8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772173021; c=relaxed/simple;
	bh=5gQ+UMdviYKja/6hkHFz/Hq5rbWJtsehg2cYJ+vuFLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0r8g1FW+JDdvupb/bz70FuLF9elBADAHXGv8075z6bHd4gDr3hNP40MOG4hd8ohUuptaUs006tWELPzgO4WOe9bImksjwSdnE2vmp2prOjodGFqpRFSppMjusb351st9lt7Goew19f3xNXnROm41Egdixp93LzbgYq2lsVxkd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CJt1DsxK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2adae92249eso18703635ad.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 22:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772173020; x=1772777820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scUOVzAnRBW38ibEW6xQpgzOJyOZg1ewr63AX7NvRVM=;
        b=CJt1DsxKKstXXEQBgSKJ7MXpHpH3RRemS3caXMdszDNa+xGzBhGLF8R9k83UEUdoq7
         JWdLrKYMiROXOLADdr9CiIliRWkRRgNv/klsXtVeuvnj3/Ciwif3C4GMwao2Och2lezz
         +90muMOiQOYZSyx7//eTxcsUFDNjyj/As4RPzNNnh6Y+E4bPEYyPIlM9Dy2u0f3bZs73
         UzvIbb0ph0haMyTCnLO1+KYaRTAqB/hkkxBDqI9Yvdo86oLyZPfmAhIEHeq2/AB1eF5b
         wN6b39z1dfHq8r4Hwb/Zsnng3+FqU5QR5yvEGqDc0LLwxQphwk362v4kq5t+EYnI0kDJ
         2qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772173020; x=1772777820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=scUOVzAnRBW38ibEW6xQpgzOJyOZg1ewr63AX7NvRVM=;
        b=P8G4vBTZ3UIfYjlOcbjB7ZHPbnLwWYqAodRZYGRBc/fyl8bv1zAsC1MleU5keDj+fr
         maqGuVcoKtikQ2vDKBbGs2+on6O6+THrQzcNowUoPbEDPg15VgaR5ceIgRtmpCa1fF22
         Vzg+R2OGrscROLsmlB8cW/m8p4eH/7yW2jW3QpcMSDRcypYYuFYesamGudxdgT2Uzp9b
         Nxn9oaOFH5C386rFX/FPOu08hiyU0BquC536OewUqgyrGYPhGhHC4EDwKhvJgX9Ik79f
         diSNK+CU7Lh4U79nxbVaPzdPPNeX3vQlSp6TzTT/p7pnrxUD0NjVl04tAkAndLv/cD9L
         o+Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWAy1R651NWLEq0GjGvnee///q94bqZRrjua6DOil9hE98Gj/gM5kYJkyIrOzQBVdnvXU0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsZBnXROv96nmwTX6TjaVdF4olz2NyM5HUCzJ/aQC5+uFHB+tu
	nhSpP8k2ghQ489KnyJ+W9QASTEucwsLGCQKFtkQ/21oLO1cU2JyYWarX
X-Gm-Gg: ATEYQzwZ5I8e5hOJFc7MNCfA9O9D1qRJ9PP4jo09viWg+4uwTj1IhA8YqMH3Kj3WJGK
	eBOgdo2K1v1FxmpwJlRt+dgahrDkZYc/8/I7SPy5bXFniDXvdQEhZKdZGc693DV1P1RHoEpEAV9
	VLd8sCCN8HLXQY65xdiohcwzkf8cLnBnvtncKHa+HfLHm95WkVmIlnMbH9VQJ6uABZxDF2R3zI7
	UOoJm7Ah4tdvEl9PgswA73BBduEgkyxgf+Dnedlep0yPChZaMGg8V7W+bwQr+x+l5R9eqvJgF7I
	t6dj1Qqk+azEsQt7m9JydDAgonS+hUZTu15mG8iB0CPtoUpyevDh+c0loKOxnO4tTQ6HytsZJLe
	Zf+u236smiKqhnVimyZyafjF7+kygWhKHl77J7lirYRHlgXBTK3PXtbN26ijQ0yOCuicmx4mCLx
	gB/0fpAeuFYTWUlhJ+FvX8L0RDSKfi
X-Received: by 2002:a17:903:1a06:b0:2aa:f0ec:3701 with SMTP id d9443c01a7336-2ae2e3e9a31mr15207155ad.2.1772173019761;
        Thu, 26 Feb 2026 22:16:59 -0800 (PST)
Received: from dw-tp ([203.81.243.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6d1913sm57837485ad.77.2026.02.26.22.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 22:16:58 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
Date: Fri, 27 Feb 2026 11:46:37 +0530
Message-ID: <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,shazbot.org,redhat.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72128-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2FD541B3344
X-Rspamd-Action: no action

This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
This also adds support for {pte,pmd,pud}_pgprot helpers needed for
follow_pfnmap APIs.

This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
VFIO PCI core driver already supports fault handling at PMD / PUD level
for more efficient BAR mappings.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---

@linux-mm:
Is there any official test which I could use to verify this functionality.

For now I used basic ivshmem setup + vfio using Qemu and validated using some
basic test to see that we are seeing these prints.

[ 4351.435050] vfio_pci_mmap_huge_fault: 3 callbacks suppressed
[ 4351.435234] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x0: 0x100
[ 4351.457005] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x40: 0x100
[ 4351.463684] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x20: 0x100

 arch/powerpc/Kconfig                         |  1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h | 23 ++++++++++++++++++++
 arch/powerpc/include/asm/pgtable.h           | 12 ++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ad7a2fe63a2a..cf9283757e5d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -172,6 +172,7 @@ config PPC
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
+	select ARCH_SUPPORTS_HUGE_PFNMAP	if PPC_BOOK3S_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if !HUGETLB_PAGE
 	select ARCH_SUPPORTS_SCHED_MC		if SMP
 	select ARCH_SUPPORTS_SCHED_SMT		if PPC64 && SMP
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..639cbf34f752 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1289,6 +1289,29 @@ static inline pud_t pud_mkhuge(pud_t pud)
 	return pud;
 }

+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static inline bool pmd_special(pmd_t pmd)
+{
+	return pte_special(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pte_pmd(pte_mkspecial(pmd_pte(pmd)));
+}
+#endif
+
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pud_special(pud_t pud)
+{
+	return pte_special(pud_pte(pud));
+}
+
+static inline pud_t pud_mkspecial(pud_t pud)
+{
+	return pte_pud(pte_mkspecial(pud_pte(pud)));
+}
+#endif

 #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index dcd3a88caaf6..2d27cb1c2334 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
 	return __pgprot(pte_flags);
 }

+#define pmd_pgprot pmd_pgprot
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	return pte_pgprot(pmd_pte(pmd));
+}
+
+#define pud_pgprot pud_pgprot
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+	return pte_pgprot(pud_pte(pud));
+}
+
 static inline pgprot_t pgprot_nx(pgprot_t prot)
 {
 	return pte_pgprot(pte_exprotect(__pte(pgprot_val(prot))));
--
2.53.0


