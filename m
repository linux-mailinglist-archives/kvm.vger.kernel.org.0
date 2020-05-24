Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680DB1DFE87
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgEXLRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgEXLRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:17:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38734C061A0E;
        Sun, 24 May 2020 04:17:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so7244320pjh.2;
        Sun, 24 May 2020 04:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=W7INcs0KcAQZHE+wwc5xysMpyUn85qDRhCtLViYS2ftxfDI3JHve40aZgmK2JiNUKB
         OXtVs9AziqTY2m1atiMZCvYeUEBIzs0/NnsfBMq6i//ovuDyimhnfabmdeyKmbpvY6UK
         Jqx4ODpsHJhEgW7FwoWKZp3kApVNhBAMoSfkzxqIAWEkkP5anSGWEMl7pWERAlA62i1V
         +C0N4WLSQAMx/VQiePtTsCp95DSFjUKQFmt1JS+HxMGfeVyEDXmFxQWV8s9c7OXRzVYA
         3/eQbRUnwpyGIagwq4HXfM+htuApoWKCjALwlMjgKdc1dHN3YDOPsEtRYbI2Lbu2lkps
         MjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=G0AgtVhRiXtYv7GiuMfsQdi40RXSl8uWCB+fvVpYccA=;
        b=gLEH3lfG2T7yUVu+8oAmcU/zq+XJUk07WlIlvT/YxFcT5EZZnDC47CDebCFIe1yduf
         qsTCgZCI/AEoC+aMz+PCEXyyQHbms78noHByEjwI2UqqTcsob4/Vi+CXtpBnv82qAldw
         FQHBaVOp4WCDrDIzUequQAwCeoVT2sWJoOrcyhGeebn+lwAVEcUPv/K6PyXG+GfXAVCC
         QoPpT9k8PjjnNE2AsDdmoxV2/NHZJsQFDLL4Oz8TuJ0bkWEb80cWconSETo1GnxJ4DAj
         nEbBSAt4jik0b/OBD2G3Hv7pFgumq4Buc3hLMfGf97Ci9h+6m1J8swXUfvgr894x1Vsh
         +ycQ==
X-Gm-Message-State: AOAM533T0dbUbWYMdEeLWNnLu9TM06ncuqOmNyepRhUiRnKdFdXcVl7l
        XEfxmK2rcAKBYjCkcBntx+o=
X-Google-Smtp-Source: ABdhPJz32GKwBzHfy0YsNmwKB4BCRg6q6t/+WkD5C6Fxfk7hu5/OMNQr2BpsV+PrRCwraCFhHNUq8Q==
X-Received: by 2002:a17:90b:1046:: with SMTP id gq6mr14198519pjb.203.1590319049820;
        Sun, 24 May 2020 04:17:29 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.17.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:17:29 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 05/15] KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
Date:   Sun, 24 May 2020 19:13:29 +0800
Message-Id: <1590318819-24520-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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

