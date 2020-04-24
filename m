Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333641B72B3
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgDXLJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXLJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:09:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282F8C09B045;
        Fri, 24 Apr 2020 04:09:04 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ms17so3787433pjb.0;
        Fri, 24 Apr 2020 04:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gyT3JhnhdKIwjs4eYU6gfUngC8pztPgbzgNj2PrTZlY=;
        b=gbRPbpyWcGRMGbEW5IvrC///VfT+5VhK27AJbGUipLLpX3UbpObJ4/k2zEhVawIISt
         T/NrBcMGlo3QJEDdCBc6rZSmltIztkddXRBuKacQfo3Tl2MoKGXy33gdE7auzILX+Oh+
         et9NcvxBEUux8Au+TtprnOBC5PEiauuTl+/b89y3PpIi3N0Vdj3V7Zk8NyAeZLkIra/a
         xNUV4MubIkx5a+YDvPdeJy8OuaWLPU+BNtYi0AY9qCxt+VGYNtZDXmpCQt3jhZ6apD2n
         VUz9gYmIfsExupUmlOb+aXSb2t1aK1Z8liTOfHGGPdRhI+2mud1+eMWXDdyTDb7BW2dv
         fxkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=gyT3JhnhdKIwjs4eYU6gfUngC8pztPgbzgNj2PrTZlY=;
        b=EA8MrfMhXh4yYMPjvskR767PN5puGFXgW0j1qJoKqFxWfGfwq+ndQqKv8xd57BUBfm
         0+zY2Wg0KIMyBIWjhoSAIR4ph3fPKdIc7qYBLoFa4RpTX8AMuryjbmrsTLzR5e2Wd066
         R/iCBvPO4GT3JOXvVJuK20sYqkWjVLs+YveVsc302nlZ9Dj1yIlqdUWGKaxMzymSsDep
         P1lb41ueX1nfqgg1qXkNSZuUV4hcy8YkoRllfHo22CFvCNjVouCvfSGoNhWNFTvdnHWQ
         VpqCdrMIW4ePgW9cFac6IY+reLH71IZ2XJuzwgOb9HDs8CWnJ1TY1y209fX1+MezRCFa
         k4nw==
X-Gm-Message-State: AGi0PubSnfD6McHvJ/iL5x/rFcSJFW2m5QUuPmz77F/SMWeuOWHIaU3l
        I73Wp2CaatsTG+07RCol238=
X-Google-Smtp-Source: APiQypKz0+9hgM63/qdcZE+0yaQAgKpvvvkbgU9rG3UgpN4ypzyT0dHo/8hUUP4kjqazBgP1GUEZQw==
X-Received: by 2002:a17:902:4c:: with SMTP id 70mr8430865pla.336.1587726543695;
        Fri, 24 Apr 2020 04:09:03 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.09.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:09:03 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 05/14] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Fri, 24 Apr 2020 19:15:24 +0800
Message-Id: <1587726933-31757-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
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

