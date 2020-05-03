Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9771C2B2B
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgECKLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727976AbgECKLD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:11:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C36C061A0C;
        Sun,  3 May 2020 03:11:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u22so5587334plq.12;
        Sun, 03 May 2020 03:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gyT3JhnhdKIwjs4eYU6gfUngC8pztPgbzgNj2PrTZlY=;
        b=jZIYgEC7kr/51giyb8xCI/mSLGApQvDdOqMOGD5gsnjT+mENC7dMJId9flHPxE4s4o
         kJRhXXOipkoeQj0VWhTV81qN5bFvRucnlwMUbXwb6wwQ+tPrajZraP6fXIxcAuswNpxb
         ZATykodV49+rovoEuYWYL7VobgARIeckZizZ8BbyDhc3ci92WBDf8BuyzqHkBDHMwRFF
         VMP8QwRjkePHI1KdWJiPtCEZquGNstADNd6SmE61Z+1uRzoVxwJd/0tD6VeJ2DBFEj5M
         3emKiNU6qnT41JHNVTV3SxEUw7TP61WqHIQS63oDUzM8gz1LI7eWd/hF+DF8KbCmIlIA
         8r2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=gyT3JhnhdKIwjs4eYU6gfUngC8pztPgbzgNj2PrTZlY=;
        b=dyEizl8ue2VQNg+LK/qy39rX9he5aNoHZU58EqDMJHvrlRPx+lIEX05UVqPRXgNjTR
         meVz6KQo4moZY4RsPmtFzMz7fdcJ3JQ0BqW0kVPFa7ejnJ40gfIDyjPKorlb7FNtBKO9
         IFEvoQT5nosvUMh5+VwUB9Jb3PF+RMoqQpfeHX7d6ELEJ4a9pU7KBE+aXP2WtJWomyGv
         u0leZXB3WOB7bAFhnSVUvYOrz7Ikj/8h0ksflh7lVlGTJ+Wwo58Hxf3TycWuDw6co+WS
         +uMHbnJgZ3Byl4rOjPpjGY7dCojow8oxYMJXiY0N8g/EytZ2vTVBmrfLC9Ex5vs5ygES
         duaw==
X-Gm-Message-State: AGi0PualswG23UTY2frl3zLNj9UZHOPY4f6p+vipJk4LSI/LnD/OJKuR
        9wqcFJjn/Lxodpe1I8huuAQ=
X-Google-Smtp-Source: APiQypKxPXXZvoHV52Oia9QLEogfOAw/k6eKuH+DgiGfNz1tSiPiyunzoqLR9ttUryaTqlw2R6EcHw==
X-Received: by 2002:a17:90a:a893:: with SMTP id h19mr10517185pjq.138.1588500660783;
        Sun, 03 May 2020 03:11:00 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.10.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:11:00 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 05/14] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Sun,  3 May 2020 18:05:58 +0800
Message-Id: <1588500367-1056-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
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

