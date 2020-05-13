Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417841D0B18
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732379AbgEMIpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732279AbgEMIpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:45:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76152C061A0C;
        Wed, 13 May 2020 01:45:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t9so10824805pjw.0;
        Wed, 13 May 2020 01:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=kf2iMY5L93sEo/Ug6YcUz5qSM3wX5PMqKTw3nxPzWoFWpDvwokpY7lOaOwn7Ipv8PQ
         G1qytgcHKNqN5trVuoaD5yHoY+mKjAlIdzljfORqH3uGZCjf/tcOK8iypPe3zjzgZ2i3
         08zc9DUXO2cf3DvRG3zz/6+FmlOJ57Uli2tLl5sglUrRr04kLbVn52mNbPHDmydyVIHq
         xuMVQnAQ9UipGEKY91gk6vOR0u0Jct0XNaL7I7DyBlNaORgSKXDf0r0nLFVnuk41Zqql
         2bcEr1NK0YVdLL69V81RRqfgJBvNBC9EmJAkCaZhqwc5Ky5nmKiJAjvY7z2ZGVVUH87F
         36bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=owoy/5xdGBjyTx8dqWndGoXtt6jItIikz0G/4oyRbHm3Yg15XkmeiQ+9GJOlCX6uGL
         dkA+Z+pax22i/JDUeTpGDBZCF7gYQD+1/wYvgZPNiRgVXY/XnsxhVDH0cjMdYV1td64t
         3TW0SLJMJ4/TM7WCu5Gyk7kNG1Dp6iTmPDQHxIh5AwdnU5VzTvE5vN4yyvMgGcWdz0Mz
         CM+jiJb6ibCmjJ4kAFz0+a991E/pH7ImdqcYK/0qYW3ZdvF0ubDhI2hodO7LpU8zvZGr
         VYHsgtE8Ua9xF47w7X0N/wIiKdPO8W+qoO7ZzOUU3EPxeyIY1cElNwylZy+wn99CwzSn
         R+BA==
X-Gm-Message-State: AOAM533EXtyRTGwCc/CQcLVHGflRE6huWR/+KXI7+eCzG+1KZD2ydfzE
        sNxeXUbVM1DvzHvnNid+kaUzzml+Kr4vbw==
X-Google-Smtp-Source: ABdhPJy2ZlNe0QXyg8lusmiLqXJv9/sCP0ZfJQi5MZebu8tCM9hI92/rUhzo9Wes5Th3MyxVcEuV+w==
X-Received: by 2002:a17:90b:1191:: with SMTP id gk17mr6567205pjb.225.1589359501095;
        Wed, 13 May 2020 01:45:01 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:45:00 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 05/15] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Wed, 13 May 2020 16:42:36 +0800
Message-Id: <1589359366-1669-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
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

