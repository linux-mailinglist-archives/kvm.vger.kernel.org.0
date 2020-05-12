Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57FF1CF288
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgELKdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729375AbgELKdc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:33:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B7AC061A0C;
        Tue, 12 May 2020 03:33:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f6so5962576pgm.1;
        Tue, 12 May 2020 03:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=m5661PQCMWssxNXXluEOtrM5YIERTeySP0srSwULbR/53cHc1GzkKj5EhO+YIHt/13
         KOL/iR71smvHMxWe+d5DMOV0yg/uK1QYPYMVKoqZn5SzGgioTJXxXXVvtdNMMcw/yfJA
         kMefre5/uCvvz+CK0ln0uwpSztwE5QiREoByoz7xWFXBPO3OitOJvmUe3yo2sHXxdjRT
         QL2sMemyKWwUQj5zpt8O04rMJF3rQaZSjHZLPf9/GCM8YJ+PX0PDnLd60jQpUR+DUOUs
         jEZykwA4eL6oe+8nLO31Jyjum5I9YWCwI7IegJB65xFXQQLZDVs0018igrDU9fud/a8a
         F/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=j07T9LWXpj5iKcYqOvbbbysW4Wc8hbdenM3Jr6TC5brbVCWu0mjwJ0f8XOWN4LykW3
         ghpM1hy9lIIy1q7ddWgGaxiJce+Kw/cI9jQNI53hx/SxrwBOqt4WwgktLfwacZqa2bZ4
         hqMY3lMci36PlJOPxHQfhWlJ/EIvIEbB33akJDnvDcbcRCtoDjkdiAEdwUQLbLXJ74uF
         o9jqXlnHblh2+v5zLqdyI/n+cfiQBApUCe/8ZW+05lrKTCswDvMBMgzoOGy4guA3aIdN
         xz/GMLyiMj6yFfWuQMIiNzajOgYd1cNUm/PtiG8AZDCAuuXo9rsTSllaOF34IiNNdrDx
         ULrQ==
X-Gm-Message-State: AGi0PualSAvJMSMpmPnQIpcxiOlpVsiht6Q1GNqZfaIbZ6gPSAiJI9wQ
        r2bkmsk2impioBjyPbYB/hs=
X-Google-Smtp-Source: APiQypItRCtm/7wVQwSz4bxaklISK40K28wi9wtcHOCXzrswEhJQNUABd+95eyu6ZwSSgdxaw8aEsQ==
X-Received: by 2002:a63:de49:: with SMTP id y9mr18630573pgi.435.1589279612291;
        Tue, 12 May 2020 03:33:32 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.33.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:33:31 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 05/14] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Tue, 12 May 2020 18:31:11 +0800
Message-Id: <1589279480-27722-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 can use lddir/ldpte instuctions to accelerate page table
walking, so use them to lookup gpa_mm.pgd.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
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

