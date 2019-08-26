Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AE89C93D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbfHZGVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:41 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33920 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZGVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:41 -0400
Received: by mail-pl1-f196.google.com with SMTP id d3so9513430plr.1;
        Sun, 25 Aug 2019 23:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/ms0nuXfsg9cGjBThAlzsKCHSca13kSNyW1vlFYE1M0=;
        b=tGZJpMlXDrMkX9MEpKz2MUGQyK7WcvZM7vDGUEtSmITD6bWxdHg61WNv/eGYMMJwYH
         1C0k3PMfm+r0Gwmc4PgQQc9aBV2H7XlZOlEj5Rt8WYr0BinzQrbkHsFGAZ3iXMvdwKCf
         VbLPOhUcf6wcLJMAc5xs7Y3P+qoOF6g+Igr+KffFbdtKeUDGqVD/JI2aRizUBYdJIg1G
         jaOVivRts+4SHZOqKbvVEw9/+kVgmz0HkIk3Uj7u2+h2xGgUFXKPSE6nASzZisj9/ABm
         qTrXo319UayWU1bk3UyyK4ctW9fcSpc9ibuE+itcoyEPYgUd/Kdh5d3A0+AqtXlinR6y
         urjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/ms0nuXfsg9cGjBThAlzsKCHSca13kSNyW1vlFYE1M0=;
        b=TXey/d1hi1ieM+TwHnoKwdBe4702pbK20jhNQJnaXXhaRYQKFsZ7FXcAct2y2l+C6v
         8T+mde7SAqSALh90nXCpJh289qtAX+d+Dg/O8RR/rff8i7bD6Qmty1ENde2Jj9d0E/mE
         uX0CDcNq9YI1PaH+jzNXr8zMrQysuNtPAXTbuP1yct7iPQyN2/jXuwnZCrCdBjls9FDY
         N5XPmwut73qmnyhZA3vx4ZTZTbbA3wtQQxMkxkAElAzSR+JY9cj31NhXTBxMDhtVJhRo
         eZhqqHBZTyI3b3PzH88/qqWQBne5tQsQBnNqwgbROg1CZuAg7Q4OGE6lOsqm+mGYdg6p
         cpDw==
X-Gm-Message-State: APjAAAX0kgGl8xzbAhiL3YJMrx6qLwepdjNL8/KyyUf8cEzVaTNCxhfJ
        oa1/O4RD1zaQDs11NIGh67XlG3N0Sdc=
X-Google-Smtp-Source: APXvYqyWb8Q/ywYikOmACHWqt3iXBd3UqXnbbLFpi0PoWiO0Aol4+dliR19YJjG9o/JmmQvkdfx4Xw==
X-Received: by 2002:a17:902:ea:: with SMTP id a97mr17288931pla.182.1566800500214;
        Sun, 25 Aug 2019 23:21:40 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:39 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 10/23] KVM: PPC: Book3S HV: Nested: Increase gpa field in nest rmap to 46 bits
Date:   Mon, 26 Aug 2019 16:20:56 +1000
Message-Id: <20190826062109.7573-11-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nested rmap entries are used to track nested pages which map a given
guest page such that that information can be retrieved from the guest
memslot.

Increase the size of the gpa (guest physical address) field in the
nested rmap entry to 46 bits such that it can be reused to store a
nested hpt (hash page table) guest entry where this field will hold the
hpt index (which can be up to 46 bits).

Additionally introduce helper functions to access these bit fields for
simplicity.

No functional change.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |  5 ++--
 arch/powerpc/kvm/book3s_hv_nested.c      | 41 ++++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index bec78f15e2f5..ef6af64a4451 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -50,12 +50,13 @@ struct kvm_nested_guest {
 /*
  * We define a nested rmap entry as a single 64-bit quantity
  * 0xFFF0000000000000	12-bit lpid field
- * 0x000FFFFFFFFFF000	40-bit guest 4k page frame number
+ * 0x000FFFFFFFFFFFC0	46-bit guest page frame number (radix) or hpt index
  * 0x0000000000000001	1-bit  single entry flag
  */
 #define RMAP_NESTED_LPID_MASK		0xFFF0000000000000UL
 #define RMAP_NESTED_LPID_SHIFT		(52)
-#define RMAP_NESTED_GPA_MASK		0x000FFFFFFFFFF000UL
+#define RMAP_NESTED_GPA_MASK		0x000FFFFFFFFFFFC0UL
+#define RMAP_NESTED_GPA_SHIFT		(6)
 #define RMAP_NESTED_IS_SINGLE_ENTRY	0x0000000000000001UL
 
 /* Structure for a nested guest rmap entry */
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 555b45a35fec..c6304aa949c1 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -770,10 +770,31 @@ static struct kvm_nested_guest *kvmhv_find_nested(struct kvm *kvm, int lpid)
 	return kvm->arch.nested_guests[lpid];
 }
 
-static inline bool kvmhv_n_rmap_is_equal(u64 rmap_1, u64 rmap_2)
+static inline u64 n_rmap_to_gpa(u64 rmap)
 {
-	return !((rmap_1 ^ rmap_2) & (RMAP_NESTED_LPID_MASK |
-				       RMAP_NESTED_GPA_MASK));
+	return ((rmap & RMAP_NESTED_GPA_MASK) >> RMAP_NESTED_GPA_SHIFT)
+		<< PAGE_SHIFT;
+}
+
+static inline u64 gpa_to_n_rmap(u64 gpa)
+{
+	return ((gpa >> PAGE_SHIFT) << RMAP_NESTED_GPA_SHIFT) &
+		RMAP_NESTED_GPA_MASK;
+}
+
+static inline int n_rmap_to_lpid(u64 rmap)
+{
+	return (int) ((rmap & RMAP_NESTED_LPID_MASK) >> RMAP_NESTED_LPID_SHIFT);
+}
+
+static inline u64 lpid_to_n_rmap(int lpid)
+{
+	return (((u64) lpid) << RMAP_NESTED_LPID_SHIFT) & RMAP_NESTED_LPID_MASK;
+}
+
+static inline bool kvmhv_n_rmap_is_equal(u64 rmap_1, u64 rmap_2, u64 mask)
+{
+	return !((rmap_1 ^ rmap_2) & mask);
 }
 
 /* called with kvm->mmu_lock held */
@@ -792,7 +813,8 @@ void kvmhv_insert_nest_rmap(unsigned long *rmapp, struct rmap_nested **n_rmap)
 
 	/* Do any entries match what we're trying to insert? */
 	for_each_nest_rmap_safe(cursor, entry, &rmap) {
-		if (kvmhv_n_rmap_is_equal(rmap, new_rmap))
+		if (kvmhv_n_rmap_is_equal(rmap, new_rmap, RMAP_NESTED_LPID_MASK
+							| RMAP_NESTED_GPA_MASK))
 			return;
 	}
 
@@ -822,8 +844,8 @@ static void kvmhv_update_nest_rmap_rc(struct kvm *kvm, u64 n_rmap,
 	unsigned int shift, lpid;
 	pte_t *ptep;
 
-	gpa = n_rmap & RMAP_NESTED_GPA_MASK;
-	lpid = (n_rmap & RMAP_NESTED_LPID_MASK) >> RMAP_NESTED_LPID_SHIFT;
+	gpa = n_rmap_to_gpa(n_rmap);
+	lpid = n_rmap_to_lpid(n_rmap);;
 	gp = kvmhv_find_nested(kvm, lpid);
 	if (!gp)
 		return;
@@ -878,8 +900,8 @@ static void kvmhv_invalidate_nest_rmap(struct kvm *kvm, u64 n_rmap,
 	unsigned int shift, lpid;
 	pte_t *ptep;
 
-	gpa = n_rmap & RMAP_NESTED_GPA_MASK;
-	lpid = (n_rmap & RMAP_NESTED_LPID_MASK) >> RMAP_NESTED_LPID_SHIFT;
+	gpa = n_rmap_to_gpa(n_rmap);
+	lpid = n_rmap_to_lpid(n_rmap);;
 	gp = kvmhv_find_nested(kvm, lpid);
 	if (!gp)
 		return;
@@ -1454,8 +1476,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_run *run,
 	n_rmap = kzalloc(sizeof(*n_rmap), GFP_KERNEL);
 	if (!n_rmap)
 		return RESUME_GUEST; /* Let the guest try again */
-	n_rmap->rmap = (n_gpa & RMAP_NESTED_GPA_MASK) |
-		(((unsigned long) gp->l1_lpid) << RMAP_NESTED_LPID_SHIFT);
+	n_rmap->rmap = gpa_to_n_rmap(n_gpa) | lpid_to_n_rmap(gp->l1_lpid);
 	rmapp = &memslot->arch.rmap[gfn - memslot->base_gfn];
 	ret = kvmppc_create_pte(kvm, gp->shadow_pgtable, pte, n_gpa, level,
 				mmu_seq, gp->shadow_lpid, rmapp, &n_rmap);
-- 
2.13.6

