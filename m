Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CD89C94E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbfHZGWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:22:01 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46394 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfHZGWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:22:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id q139so11086063pfc.13;
        Sun, 25 Aug 2019 23:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bTiLuj54xhwSp4kInqg003EfCIIghmCYrpGuqvUR+LI=;
        b=HjwPczo+xeGiGKfTWcz1tqZKwjXzLKLgNxq3WTfSCeRE7+QaKRL2AFWFFVzDksL2LK
         mny8zcPbE6rk7sqYCydewbGf1seXecm4vdltgHcRFyOdRZBNqcQ0VQ44upSYy2yrzamn
         iJVjP80riZCeZVMkXmKSDbQLBIf4wPnF99CgO6D5qpx4AKRSRbsugq9dtujqxt59VD6a
         4vu+GwmIuJ/1+lf4n45qAY7DB8nVVXme9Iz8GEmMDXrYoCDcUBnSlzQ4q7kuQBLN45zn
         jC8wEM6goR/J4OL5kGKq5iRvEr+3WVYCKaw6GEwSdxP2w/nZP8YdKncfVXouNlg8OV68
         pHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bTiLuj54xhwSp4kInqg003EfCIIghmCYrpGuqvUR+LI=;
        b=jr4vxYWrYZ4lzPM2Vym8+8sQLlpR4yNSxdcbO37YmNlMF/y/ZAnZNhrPqDc51jhdIB
         080MuwV5MgCLJWqTPlsGKyjQnMSIIkWfWXWPPUboLqmLKe7rQTvoYXUGSR4sOeJ//pVw
         VZc2TiF0AZNUt0Le4KlZkvezLBXdeetoajCqJrS/lxoBzGQQlIZTs1H0sfvT3cr9MXwp
         R3w5btqDi0+uoB1vQgVIPVZ3kljUQCCzKFgALabnn72naxdgrraz/Zu6KxTWl9C/dUkP
         P2mc/neJsqIvUv8K2Mg5R7i+IwMJCrllgZOx6yQq2TDf4P/p3F9D0jlJXW5evBQLvlUF
         EVpQ==
X-Gm-Message-State: APjAAAWKyaGUMaBNb/xCd9NMGnwMD9fgRiZUAxsLkIqkOIJ38U05vYBg
        8/flUzLULq4GdTViMaQJp1yb6QkDP9U=
X-Google-Smtp-Source: APXvYqxAPuKpLnVlDHq9cimzhP/gMssP/BAxq3B2HBnWJNn7iRv88B/Qn6UkvErFuo/5TX0xPwdKjw==
X-Received: by 2002:a17:90a:e38e:: with SMTP id b14mr5410849pjz.125.1566800519632;
        Sun, 25 Aug 2019 23:21:59 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:59 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 18/23] KVM: PPC: Book3S HV: Separate out hashing from kvmppc_hv_find_lock_hpte()
Date:   Mon, 26 Aug 2019 16:21:04 +1000
Message-Id: <20190826062109.7573-19-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate out the hashing function from kvmppc_hv_find_lock_hpte() as
kvmppc_hv_get_hash_value() to allow this function to be reused and
prevent code duplication.

No functional change.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c | 60 ++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index a939782d8a5e..c8a379a6f533 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -1162,6 +1162,40 @@ static struct mmio_hpte_cache_entry *
 	return &vcpu->arch.mmio_cache.entry[index];
 }
 
+/*
+ * Given an effective address and a slb entry, work out the hash and the
+ * virtual page number
+ */
+unsigned long kvmppc_hv_get_hash_value(struct kvm_hpt_info *hpt, gva_t eaddr,
+				       unsigned long slb_v, unsigned long *avpn,
+				       unsigned int *pshift_p)
+{
+	unsigned long hash, somask, vsid;
+	unsigned int pshift = 12;
+
+	if (slb_v & SLB_VSID_L)
+		pshift = slb_base_page_shift[(slb_v & SLB_VSID_LP) >> 4];
+	if (slb_v & SLB_VSID_B_1T) {
+		somask = (1UL << 40) - 1;
+		vsid = (slb_v & ~SLB_VSID_B) >> SLB_VSID_SHIFT_1T;
+		vsid ^= vsid << 25;
+	} else {
+		somask = (1UL << 28) - 1;
+		vsid = (slb_v & ~SLB_VSID_B) >> SLB_VSID_SHIFT;
+	}
+	hash = (vsid ^ ((eaddr & somask) >> pshift)) & kvmppc_hpt_mask(hpt);
+	*avpn = slb_v & ~(somask >> 16);	/* also includes B */
+	*avpn |= (eaddr & somask) >> 16;
+
+	if (pshift >= 24)
+		*avpn &= ~((1UL << (pshift - 16)) - 1);
+	else
+		*avpn &= ~0x7fUL;
+	*pshift_p = pshift;
+
+	return hash;
+}
+
 /* When called from virtmode, this func should be protected by
  * preempt_disable(), otherwise, the holding of HPTE_V_HVLOCK
  * can trigger deadlock issue.
@@ -1171,39 +1205,17 @@ long kvmppc_hv_find_lock_hpte(struct kvm_hpt_info *hpt, gva_t eaddr,
 {
 	unsigned int i;
 	unsigned int pshift;
-	unsigned long somask;
-	unsigned long vsid, hash;
-	unsigned long avpn;
 	__be64 *hpte;
-	unsigned long mask, val;
+	unsigned long hash, mask, val;
 	unsigned long v, r, orig_v;
 
 	/* Get page shift, work out hash and AVPN etc. */
 	mask = SLB_VSID_B | HPTE_V_AVPN | HPTE_V_SECONDARY;
-	val = 0;
-	pshift = 12;
+	hash = kvmppc_hv_get_hash_value(hpt, eaddr, slb_v, &val, &pshift);
 	if (slb_v & SLB_VSID_L) {
 		mask |= HPTE_V_LARGE;
 		val |= HPTE_V_LARGE;
-		pshift = slb_base_page_shift[(slb_v & SLB_VSID_LP) >> 4];
-	}
-	if (slb_v & SLB_VSID_B_1T) {
-		somask = (1UL << 40) - 1;
-		vsid = (slb_v & ~SLB_VSID_B) >> SLB_VSID_SHIFT_1T;
-		vsid ^= vsid << 25;
-	} else {
-		somask = (1UL << 28) - 1;
-		vsid = (slb_v & ~SLB_VSID_B) >> SLB_VSID_SHIFT;
 	}
-	hash = (vsid ^ ((eaddr & somask) >> pshift)) & kvmppc_hpt_mask(hpt);
-	avpn = slb_v & ~(somask >> 16);	/* also includes B */
-	avpn |= (eaddr & somask) >> 16;
-
-	if (pshift >= 24)
-		avpn &= ~((1UL << (pshift - 16)) - 1);
-	else
-		avpn &= ~0x7fUL;
-	val |= avpn;
 
 	for (;;) {
 		hpte = (__be64 *)(hpt->virt + (hash << 7));
-- 
2.13.6

