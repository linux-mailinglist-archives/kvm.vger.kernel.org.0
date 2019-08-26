Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6845B9C959
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfHZGWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:22:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43825 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfHZGWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:22:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so9488935pld.10;
        Sun, 25 Aug 2019 23:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+bdtiq80ga87UK+6pRvebGrF37eiQJ3HgpQtHx+Y+Y0=;
        b=AoU+grwxrIfD5izn/ei0YquTLgk1px0bzay4IORJLw0HJJrSsH6Oh7fGPCxng1Aii3
         KhJnu6yKJIpxlW2QaIxAz8rhKN3aYPyRbDyIKZegJ2fDvL0LXqhZ10IzcDjv2FoEz9jA
         f5nqH5FZ022oXZ4GSCL4w0eGLTRRnD48caiSTOtF+Bhup/8jymevx4rg0297QR2wbFKO
         Dm0aJvMtOmjD15PnUvOTnWd0CV7a4WjK8UVGMNAtri9jK7CEDxEs3+hwtkNc1/55YIKH
         sWyECWh2deodtHTaZTIPH2ahziUMeEyWcUZp5Xg2CpeR6F2TplNu0ak83ZvTCC5lCXZP
         e/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+bdtiq80ga87UK+6pRvebGrF37eiQJ3HgpQtHx+Y+Y0=;
        b=nthwdhigAYdQpup2gd3ZsnwK7fEBCF76Cw8v3gjgj5QB4vVWOLGQYEXmiv/qfCbVQp
         N2C2J1gbC6f+c/qdm82Q9HDB37VOU0YmWKa9ouWGEssMy5jI5RTTNaZjon9QLslP13RL
         q1lm2nkCq7FHLDozXOYS+cGYPeLxeHulbrvjTdapLlmCdA8BeNlf5jDGqUtP5PLJFCKM
         nU1/uTzNSmyuwLvZIMzepOCL1ZwuPl/zKJq5fPTghO3HDoxzm3yhgtgjOjoxCgVcyDoG
         uLe15RFdJAyzJVV1GA0LQnxrhGVLEO3alXdKV8xSm465z2PAwvzG1d64t121VTM4yNnu
         EsRg==
X-Gm-Message-State: APjAAAX5yGnHMZjrIkFBk+O4nHEELOf2kH7ywBulpFAUpfRW+idq0GI/
        EyLhY52fJ+ru6+5pbDeY8JpFJDRq0EU=
X-Google-Smtp-Source: APXvYqyOMs9z5MTZ57/Im4yqEUYAWhP5jpgs8UUSGX2DN8/OqlaSsQVdfaeh94Lw2SAK6BLhBSISvQ==
X-Received: by 2002:a17:902:223:: with SMTP id 32mr17698186plc.220.1566800531466;
        Sun, 25 Aug 2019 23:22:11 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.22.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:22:11 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 23/23] KVM: PPC: Book3S HV: Add nested hpt pte information to debugfs
Date:   Mon, 26 Aug 2019 16:21:09 +1000
Message-Id: <20190826062109.7573-24-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The radix entry in the vm debugfs folder is used to export debug
information about the ptes contained in the page table of a radix guest.
There is a corrsponding htab entry which provides the same pte
information for a hpt (hash page table) guest.

When a radix guest is running a nested guest this entry also provides
information about the shadow ptes in the shadow page table.

Add the same information for a nested hpt guest running under a radix
guest to this entry. The format followed is the same as that for the
htab entry for a hpt guest.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 157 +++++++++++++++++++++------------
 1 file changed, 101 insertions(+), 56 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 48b844d33dc9..8ab9d487c9e8 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1188,6 +1188,8 @@ static int debugfs_radix_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+#define HPTE_SIZE      (2 * sizeof(unsigned long))
+
 static ssize_t debugfs_radix_read(struct file *file, char __user *buf,
 				 size_t len, loff_t *ppos)
 {
@@ -1197,6 +1199,7 @@ static ssize_t debugfs_radix_read(struct file *file, char __user *buf,
 	struct kvm *kvm;
 	unsigned long gpa;
 	pgd_t *pgt;
+	struct kvm_hpt_info *hpt;
 	struct kvm_nested_guest *nested;
 	pgd_t pgd, *pgdp;
 	pud_t pud, *pudp;
@@ -1234,84 +1237,126 @@ static ssize_t debugfs_radix_read(struct file *file, char __user *buf,
 	gpa = p->gpa;
 	nested = NULL;
 	pgt = NULL;
+	hpt = NULL;
 	while (len != 0 && p->lpid >= 0) {
-		if (gpa >= RADIX_PGTABLE_RANGE) {
-			gpa = 0;
-			pgt = NULL;
-			if (nested) {
-				kvmhv_put_nested(nested);
-				nested = NULL;
-			}
-			p->lpid = kvmhv_nested_next_lpid(kvm, p->lpid);
-			p->hdr = 0;
-			if (p->lpid < 0)
-				break;
-		}
-		if (!pgt) {
+		if (!pgt && !hpt) {
 			if (p->lpid == 0) {
 				pgt = kvm->arch.pgtable;
 			} else {
 				nested = kvmhv_get_nested(kvm, p->lpid, false);
 				if (!nested) {
-					gpa = RADIX_PGTABLE_RANGE;
+					p->lpid = kvmhv_nested_next_lpid(kvm,
+							p->lpid);
 					continue;
 				}
-				pgt = nested->shadow_pgtable;
+				if (nested->radix)
+					pgt = nested->shadow_pgtable;
+				else
+					hpt = &nested->shadow_hpt;
 			}
 		}
+		if ((pgt && (gpa >= RADIX_PGTABLE_RANGE)) || (hpt &&
+					(gpa >= kvmppc_hpt_npte(hpt)))) {
+			gpa = 0;
+			pgt = NULL;
+			hpt = NULL;
+			if (nested) {
+				kvmhv_put_nested(nested);
+				nested = NULL;
+			}
+			p->lpid = kvmhv_nested_next_lpid(kvm, p->lpid);
+			p->hdr = 0;
+			continue;
+		}
 		n = 0;
 		if (!p->hdr) {
 			if (p->lpid > 0)
 				n = scnprintf(p->buf, sizeof(p->buf),
-					      "\nNested LPID %d: ", p->lpid);
-			n += scnprintf(p->buf + n, sizeof(p->buf) - n,
-				      "pgdir: %lx\n", (unsigned long)pgt);
+					      "\nNested LPID %d: \n", p->lpid);
+			if (pgt)
+				n += scnprintf(p->buf + n, sizeof(p->buf) - n,
+					      "RADIX:\npgdir: %lx\n",
+					      (unsigned long)pgt);
+			else
+				n += scnprintf(p->buf + n, sizeof(p->buf) - n,
+					       "HASH:\nnpte: %lx\n",
+					       kvmppc_hpt_npte(hpt));
 			p->hdr = 1;
 			goto copy;
 		}
 
-		pgdp = pgt + pgd_index(gpa);
-		pgd = READ_ONCE(*pgdp);
-		if (!(pgd_val(pgd) & _PAGE_PRESENT)) {
-			gpa = (gpa & PGDIR_MASK) + PGDIR_SIZE;
-			continue;
-		}
+		if (pgt) {
+			pgdp = pgt + pgd_index(gpa);
+			pgd = READ_ONCE(*pgdp);
+			if (!(pgd_val(pgd) & _PAGE_PRESENT)) {
+				gpa = (gpa & PGDIR_MASK) + PGDIR_SIZE;
+				continue;
+			}
 
-		pudp = pud_offset(&pgd, gpa);
-		pud = READ_ONCE(*pudp);
-		if (!(pud_val(pud) & _PAGE_PRESENT)) {
-			gpa = (gpa & PUD_MASK) + PUD_SIZE;
-			continue;
-		}
-		if (pud_val(pud) & _PAGE_PTE) {
-			pte = pud_val(pud);
-			shift = PUD_SHIFT;
-			goto leaf;
-		}
+			pudp = pud_offset(&pgd, gpa);
+			pud = READ_ONCE(*pudp);
+			if (!(pud_val(pud) & _PAGE_PRESENT)) {
+				gpa = (gpa & PUD_MASK) + PUD_SIZE;
+				continue;
+			}
+			if (pud_val(pud) & _PAGE_PTE) {
+				pte = pud_val(pud);
+				shift = PUD_SHIFT;
+				goto leaf;
+			}
 
-		pmdp = pmd_offset(&pud, gpa);
-		pmd = READ_ONCE(*pmdp);
-		if (!(pmd_val(pmd) & _PAGE_PRESENT)) {
-			gpa = (gpa & PMD_MASK) + PMD_SIZE;
-			continue;
-		}
-		if (pmd_val(pmd) & _PAGE_PTE) {
-			pte = pmd_val(pmd);
-			shift = PMD_SHIFT;
-			goto leaf;
-		}
+			pmdp = pmd_offset(&pud, gpa);
+			pmd = READ_ONCE(*pmdp);
+			if (!(pmd_val(pmd) & _PAGE_PRESENT)) {
+				gpa = (gpa & PMD_MASK) + PMD_SIZE;
+				continue;
+			}
+			if (pmd_val(pmd) & _PAGE_PTE) {
+				pte = pmd_val(pmd);
+				shift = PMD_SHIFT;
+				goto leaf;
+			}
 
-		ptep = pte_offset_kernel(&pmd, gpa);
-		pte = pte_val(READ_ONCE(*ptep));
-		if (!(pte & _PAGE_PRESENT)) {
-			gpa += PAGE_SIZE;
-			continue;
-		}
-		shift = PAGE_SHIFT;
-	leaf:
-		n = scnprintf(p->buf, sizeof(p->buf),
+			ptep = pte_offset_kernel(&pmd, gpa);
+			pte = pte_val(READ_ONCE(*ptep));
+			if (!(pte & _PAGE_PRESENT)) {
+				gpa += PAGE_SIZE;
+				continue;
+			}
+			shift = PAGE_SHIFT;
+		leaf:
+			n = scnprintf(p->buf, sizeof(p->buf),
 			      " %lx: %lx %d\n", gpa, pte, shift);
-		gpa += 1ul << shift;
+			gpa += 1ul << shift;
+		} else { /* hpt */
+			__be64 *hptp = (__be64 *)(hpt->virt + (gpa * HPTE_SIZE));
+			unsigned long v, hr, gr;
+
+			if (!(be64_to_cpu(hptp[0]) & (HPTE_V_VALID |
+							HPTE_V_ABSENT))) {
+				gpa++;
+				continue;
+			}
+			/* lock the HPTE so it's stable and read it */
+			preempt_disable();
+			while (!try_lock_hpte(hptp, HPTE_V_HVLOCK))
+				cpu_relax();
+			v = be64_to_cpu(hptp[0]) & ~HPTE_V_HVLOCK;
+			hr = be64_to_cpu(hptp[1]);
+			gr = hpt->rev[gpa].guest_rpte;
+			unlock_hpte(hptp, v);
+			preempt_enable();
+
+			if (!(v & (HPTE_V_VALID | HPTE_V_ABSENT))) {
+				gpa++;
+				continue;
+			}
+
+			n = scnprintf(p->buf, sizeof(p->buf),
+				      "%6lx %.16lx %.16lx %.16lx\n",
+				      gpa, v, hr, gr);
+			gpa++;
+		}
 	copy:
 		p->chars_left = n;
 		if (n > len)
-- 
2.13.6

