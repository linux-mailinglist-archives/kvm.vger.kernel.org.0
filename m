Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A425D1A6399
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgDMHYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDMHYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:24:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB86C008651;
        Mon, 13 Apr 2020 00:24:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu11so3485628pjb.1;
        Mon, 13 Apr 2020 00:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gyT3JhnhdKIwjs4eYU6gfUngC8pztPgbzgNj2PrTZlY=;
        b=V3VOhY8VmnM/w5l1OtQnzCohgK6qWeXErUDr+UvCipYHvEkRmokVvM10dZWR5KudUA
         t7hm4n8HWaEb9e56F/JzCCgWdbYle0oQ8IYSHQOZeJobyEApTKdfVEN5TsViNVJteqcY
         i43cfHzl1z2opTpedqDpfEsltwbZtAIJFLdHdJ8aGzxn2b6WQ//bF0O1VAGm+bfTxTFm
         xquPJslUM8gGEWXG6ZsEUobUQCoLOK/0W7ZTBz+3io2R376T0pcICYGsrXhhDyHkhk9p
         VuNnOA1aG7VUaS4jkcoPKcwvnbmQkh6uR6Kolc//ca9/Ij5bVESC3yNOSb1f7QNO1VJc
         6R8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=gyT3JhnhdKIwjs4eYU6gfUngC8pztPgbzgNj2PrTZlY=;
        b=qMufPlCZCFcQzjBWeERQ7hbG+YkJL8En59T4ey/sJJkUJiNflw9p1rECblL4N74F+S
         he8oPpRO+U0wUxWaenDf5aOyL+2Gn+owBM2EKBnpwetHPJwsUHQGjewCF3V3GTFUA2j/
         sWFMB+9hAv8FlkUSK/scX2uLzPQgSkALEjhePkz+RNetp8W+/7JHhwdyAA+AirkmaAH0
         geE+SLV3/ul+optevQpKAgdmo6zlbOg5bfSUW7OtGJMkY/XWvhas+oVULDjr9zQS5REt
         P70p38xpnlJ2RWMrWM5FQCJieU429uM1HziynCvd/ICgm/DHwxoYFm2RaU5ykuelB7is
         JUjw==
X-Gm-Message-State: AGi0PuY7/2+bJZn6MV9T0/1UbR1aZGyVPnMLmbGahdMuCByfnS7Aw4kM
        uHIC6C2SlzgC+RiGfzBJ4qI=
X-Google-Smtp-Source: APiQypJBIU25Kv+njqNZQJhQyJZZDlzXd0hmwzx5Ke62j9e0iXHDH4NqDBE9tce8eCwOOpjKc3b96A==
X-Received: by 2002:a17:902:322:: with SMTP id 31mr16406962pld.103.1586762643670;
        Mon, 13 Apr 2020 00:24:03 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.24.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:24:03 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 06/15] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Mon, 13 Apr 2020 15:30:15 +0800
Message-Id: <1586763024-12197-7-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 can use lddir/ldpte instuctions to accelerate page table
walking, so use them to lookup gpa_mm.pgd.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/entry.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/entry.c b/arch/mips/kvm/entry.c
index 16e1c93..fd71694 100644
--- a/arch/mips/kvm/entry.c
+++ b/arch/mips/kvm/entry.c
@@ -56,6 +56,7 @@
 #define C0_BADVADDR	8, 0
 #define C0_BADINSTR	8, 1
 #define C0_BADINSTRP	8, 2
+#define C0_PGD		9, 7
 #define C0_ENTRYHI	10, 0
 #define C0_GUESTCTL1	10, 4
 #define C0_STATUS	12, 0
@@ -307,7 +308,10 @@ static void *kvm_mips_build_enter_guest(void *addr)
 
 #ifdef CONFIG_KVM_MIPS_VZ
 	/* Save normal linux process pgd (VZ guarantees pgd_reg is set) */
-	UASM_i_MFC0(&p, K0, c0_kscratch(), pgd_reg);
+	if (cpu_has_ldpte)
+		UASM_i_MFC0(&p, K0, C0_PWBASE);
+	else
+		UASM_i_MFC0(&p, K0, c0_kscratch(), pgd_reg);
 	UASM_i_SW(&p, K0, offsetof(struct kvm_vcpu_arch, host_pgd), K1);
 
 	/*
@@ -469,8 +473,10 @@ void *kvm_mips_build_tlb_refill_exception(void *addr, void *handler)
 	u32 *p = addr;
 	struct uasm_label labels[2];
 	struct uasm_reloc relocs[2];
+#ifndef CONFIG_CPU_LOONGSON64
 	struct uasm_label *l = labels;
 	struct uasm_reloc *r = relocs;
+#endif
 
 	memset(labels, 0, sizeof(labels));
 	memset(relocs, 0, sizeof(relocs));
@@ -490,6 +496,16 @@ void *kvm_mips_build_tlb_refill_exception(void *addr, void *handler)
 	 */
 	preempt_disable();
 
+#ifdef CONFIG_CPU_LOONGSON64
+	UASM_i_MFC0(&p, K1, C0_PGD);
+	uasm_i_lddir(&p, K0, K1, 3);  /* global page dir */
+#ifndef __PAGETABLE_PMD_FOLDED
+	uasm_i_lddir(&p, K1, K0, 1);  /* middle page dir */
+#endif
+	uasm_i_ldpte(&p, K1, 0);      /* even */
+	uasm_i_ldpte(&p, K1, 1);      /* odd */
+	uasm_i_tlbwr(&p);
+#else
 	/*
 	 * Now for the actual refill bit. A lot of this can be common with the
 	 * Linux TLB refill handler, however we don't need to handle so many
@@ -512,6 +528,7 @@ void *kvm_mips_build_tlb_refill_exception(void *addr, void *handler)
 	build_get_ptep(&p, K0, K1);
 	build_update_entries(&p, K0, K1);
 	build_tlb_write_entry(&p, &l, &r, tlb_random);
+#endif
 
 	preempt_enable();
 
-- 
2.7.0

