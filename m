Return-Path: <kvm+bounces-73290-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oFHtKmu/rmlEIgIAu9opvQ
	(envelope-from <kvm+bounces-73290-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:39:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 27981238F98
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 929C4302864E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 12:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B09197A7D;
	Mon,  9 Mar 2026 12:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGccOhex"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5233ACF1E
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 12:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773059936; cv=none; b=mCJhQ/F0O1kJwXo/ITx6bIqKGrtuGAGFMB2Ah7KkpXMRkRvbzk0NiHyLuCOo1NbEMqn6s4a9Vtv+kZyRlCdQvTuvkO9uzei34OsmGIes3fAzJwXy3/yZP2GuvyJT3gV6wgtEIpTTZRjaNK6ak0FVUG4hHe4xTfP2hxhyO9ynLUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773059936; c=relaxed/simple;
	bh=6aXf669wEjEvyXVk8mslrwHWEJgV5QiDnJQRFyCNLx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rxIuAiX8l1S8ozMsIyqeTVLh63kZUlO1HBRl2OmOjlXRkyTCB9lcLNWgiIrwbC9n6HuLm4C0tNA4tx78RJqDcCqGommFmqmUr/0cQx5+JhnRQDuy+Xixqc0aXXGmjYfzpknJCOK6KTdLo+xlw6/CAKBtUZZPlGaGMLXC/PAbNpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGccOhex; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae46fc8ec1so56305805ad.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 05:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773059935; x=1773664735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nisfAIds2waJYT0R56BEFoM3l3b5O3t1RahsBzDsKqc=;
        b=lGccOhexOgKPH9IZVcMChx21nR0No6d5K2baE5oM5IUfKiSiKkosLqoeMBbsHS61XN
         CLtF64AqnXHimRb2aUxb/4mf55aOnh9GNyjLFP6WlCSOGUAtqXYtzi8sBXaq0NH5Qp21
         v2LGFW/sm339M2HvyLl4vMXMsAoa55U/CMOV5hLMzp8olc+X+5+akbqtkMXf4eVrAMif
         2dz1WHSD2CoAS4QcsWgbvNmvt83sfVduuxGfBnuM8RGCmgOuGhK/i/Tz3uISbj1Kppvm
         6UAc2GGJ38rPJh6gNKrkEt1rbZ8PBXy+LjI/P7VmSWhMjIMrRWxqExIhpdGsrvEBpbQT
         zKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773059935; x=1773664735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nisfAIds2waJYT0R56BEFoM3l3b5O3t1RahsBzDsKqc=;
        b=OamkqEeifWGyLIsA13MaclLiEa3YtDOhdURK0Y0n5XzXN6UU75UK39YkRlfhEGMvJC
         AOEv9jzi6rpwJWLIwJblxEaB5boi1goAiYYsgL3XNrYvp2B2A0ATrI0mGvspIBgAPnZ0
         xDcbQkOadXtYKUZwjeNc+BiJawKwaodIyGGK/EPMKNoc9mXoe213mKG8RL8o/tYYoBYf
         kjZEzzkCBGMfUDQWmbi+Co+r5oGTRc76QmeKGW0zvBqg1wHSy7WLhDChTB7HZKYTfZLV
         Rm5LSU4RzEfTPlXO/swAdOTMrW4/ZvgcgcS6jw9sRG7j7+28YcEn+14wnTP99zRM96Jq
         2Lgw==
X-Forwarded-Encrypted: i=1; AJvYcCVyHSTnkpVCQiqiOLmQgZ4YGV85Mxoy/o+mSZlgDwUvws95/VCvWAmHVGc97dq3R6fPgAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCADM4C7h7PHjAYuebRkKK+TQME+lyInHSlUO4pkAMahiHeO4C
	YA2htnwvq1yzFD9c8vXnGWqINt9NeZqZ6iPwgWR6K9/C4r9c7bqpcAlyCagBZZ5S
X-Gm-Gg: ATEYQzzEqs/XLhohAE4eRNULP4vVOWDhEBR2nUCv90tg3iXhfl+smeCWZcuyXxmpu+L
	QPClXsVSOcNrDiXoZqhE2VU0r3wLPVbAsg4PVZLiqKg9Vd0iQeSKE6Lec0Pw1LAkJyoqlhxq/lV
	6Zp0nOKgbIwNFHCkJzODsKlZutiS4mVWg+RrJWJZZz/aGDLKAVE/wHHUd3DFymtyqYD1KUwkbZP
	Be+GBK6HSDg6WfX7/GK0ewOroGBxHZPpuzdZhN95mlWWNfCgERVVKzIXA/qakSgQaHTnlJbNELB
	x7QFuAz4EWDvEIVz8CjSMJknmCQ8jDVvCV1kceBCW1EYVY5AvyZ0s9mDPqJDoOM1EAndp2An4H1
	XBl/Lm1k752IQUqMw3FlGGAgBSswoUR7GVR9fVwnQsanjeWMwdpgzwJs7gObL4PNcG7XaJco2Ww
	knJ16Z/yV/aKdF1CbXVwnW/nXYwtqv
X-Received: by 2002:a17:903:390f:b0:2ae:48a0:33e3 with SMTP id d9443c01a7336-2ae82480337mr132396235ad.45.1773059935096;
        Mon, 09 Mar 2026 05:38:55 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83eafc64sm154867375ad.40.2026.03.09.05.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 05:38:54 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2 2/2] powerpc/64s: Add support for huge pfnmaps
Date: Mon,  9 Mar 2026 18:08:38 +0530
Message-Id: <6fca726574236f556dd4e1e259692e82a4c29e85.1773058761.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27981238F98
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-73290-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux.ibm.com,kernel.org,kvack.org,vger.kernel.org,shazbot.org,redhat.com,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[kvm];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
This also adds support for {pte,pmd,pud}_pgprot helpers needed for
follow_pfnmap APIs.

This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
VFIO PCI core driver already supports fault handling at PMD / PUD level
for more efficient BAR mappings.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
v1 -> v2:
1. Added CONFIG_PPC64 #ifdef blocks around p{u|m}d_pgprot()
2. Retained the RB from Christophe.

 arch/powerpc/Kconfig                         |  1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h | 23 ++++++++++++++++++++
 arch/powerpc/include/asm/pgtable.h           | 14 ++++++++++++
 3 files changed, 38 insertions(+)

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
index dcd3a88caaf6..97ccfa6e3dde 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -63,6 +63,20 @@ static inline pgprot_t pte_pgprot(pte_t pte)
 	return __pgprot(pte_flags);
 }

+#ifdef CONFIG_PPC64
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
+#endif /* CONFIG_PPC64 */
+
 static inline pgprot_t pgprot_nx(pgprot_t prot)
 {
 	return pte_pgprot(pte_exprotect(__pte(pgprot_val(prot))));
--
2.39.5


