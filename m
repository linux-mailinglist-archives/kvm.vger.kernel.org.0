Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423891DF5D8
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 09:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387761AbgEWH7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 03:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387757AbgEWH7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 03:59:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2701DC061A0E;
        Sat, 23 May 2020 00:59:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so6073746pgv.8;
        Sat, 23 May 2020 00:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=p/3vzLeD1Eq6+PCWIoaBLN9WHs//yRmi84gC7OqorDbVlURYuprWvgEVs4B1jeQ+i1
         pnfJa9S1UqrOM/XZVeEU/yloRbyfRpGlZTaUhDst7IcxRl5VxpJWuPGt/R9lgsytJ4Ao
         Ic5n0EKUBRR1LQSb42qMHPZ6IouwN1QGM2j1MjfUQ39oVFt+Hahc9V9hF45FnYHOLE1r
         UtwibU8qgVQ2/JaZq+hd+N0F9DO9g/tksF5hQzEUD4mT0hoVAQ4mGEfj6GfCU9kaMMBA
         OOpLdbTocuvp4eAATjMaB4uXsaVmLWCSqkqjSpfKNEcN7swBykt0VWJHBzlqHtRyzlSg
         8Bug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=aLYvMo2dw8KrCzilEhEE3UkCFKnUZ2HE3ps9bOeScZ1IH4u7sJ2VwGagcMe+zyv3ud
         5c7yCfVlJDpdjgFblBqhAC8hoimqv3g139WSVrdGBr/b47DVBE9oVRCWNd+btO4ZtGhy
         DIQRNx8AUovrxftySe+MBB9PrPJlJbVBZRBmLPycJblL7DSsNaK6BcqKBsWSeiWDvjsp
         mXCCbsnwvxic/U1K1A7OnmYUvjWlTTMngH+MT/VVsu4PCCXqQKnm3WCqKXtCCUjdeADF
         5C3060G9cEknpHBMXgV6MQoeOYM8m2UoWJmzs5sxAwwLkGO+vhGtdHj+VNjhSWf7BUk8
         DP5Q==
X-Gm-Message-State: AOAM531AwiXpuXwFNoG4B5WLmPiMG7m8NcLUgQlTHecBX7NbR1CWpAeJ
        H6sUrCjwCsO65DLkmhXa+hw=
X-Google-Smtp-Source: ABdhPJxxrgkHUeTcV7mcDYrRSwHeV9p5YanRsNfT41AqEAxpZ9S5pc0uYxtf71V0SNxUMb4Z1WkZ7w==
X-Received: by 2002:a63:5fc8:: with SMTP id t191mr17162323pgb.185.1590220774766;
        Sat, 23 May 2020 00:59:34 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.00.59.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 00:59:34 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 05/15] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Sat, 23 May 2020 15:56:32 +0800
Message-Id: <1590220602-3547-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
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

