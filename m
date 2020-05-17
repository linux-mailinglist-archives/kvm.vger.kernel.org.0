Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD51D658C
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgEQEIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgEQEIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:08:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D3DC061A0C;
        Sat, 16 May 2020 21:08:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so3039671pgn.5;
        Sat, 16 May 2020 21:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=aAIfZrcwAq/18CcUYGCaozun75Y6jk3SaEpYRXYv0rHzr/BwEQZOXBKPKHnm/OGGOT
         WRvg3pJWWq84MojM1xzyJUsABq/7UFwJjKLoqPfbSClxQqDHGhjHLTkKgBUpfmbBB1jq
         SBr5EQQI5OM3F2c9VBVWlrMWfZj+wtrh4Uy/YGWMI2ITpjawufOjRIKR4BKC1+Hphk1U
         +sLc2AHGSG0FfqsLNe3l19pbK6vLsmv9NUTu6UJ7n+i7p+byFImxu5YRq5+xHX5M772l
         pXSMY420bpD+TtekDjza4V5CKaj/vaFasQl9Y2+KXwl0KHtUZUanS333f8iCoGL4sCOB
         BhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=jvAd5S6I7NLyIR+hiN5iXwowfaLZAyduKN06oWFPDlwSrczk9q8totUevUGim9v92c
         xh1WCfWLDWlcrHWvoHBxRdVSix25BN/x64ZecEj9wcV85ks+Bby3RRVyDBhcmUx/EsDF
         KGnFZgsEjqeISOnRP2jjHmNaWp3+WTC1mWdVNmqTo+kZXq3Y5JQ5j9L9HvYlmf660PvL
         jmTp88uvvt3bOBxwclFu3Me16GW2Rd8F5sOsoeqk9ccovM1wG0uGkStW509xjJlMSiVK
         axj6uPouhmoQ/Za4smhzWbYoCzFgZNT6/fY9M8OTkTJV05C5hoqAmvY6WhiWI/42UZq7
         QYlg==
X-Gm-Message-State: AOAM531WCrOh7VCOXBRNGBAWGWdloXvS2iTszzc4ID69nZoy+AFl71Pp
        s4+P09N0/YPkww1EiD2qIRM=
X-Google-Smtp-Source: ABdhPJwacPjsy10gpl2YbHZkYjyjJrBghbjWtbpI/ofTCl2DKWEaFEZ1f0BaYOl/t8rlIQ+Qa/NerA==
X-Received: by 2002:a63:145f:: with SMTP id 31mr1469721pgu.383.1589688504512;
        Sat, 16 May 2020 21:08:24 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.08.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:08:23 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 05/15] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Sun, 17 May 2020 12:06:02 +0800
Message-Id: <1589688372-3098-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
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

