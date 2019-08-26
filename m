Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24889C933
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfHZGV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:29 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37461 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHZGV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:28 -0400
Received: by mail-pl1-f193.google.com with SMTP id bj8so9492676plb.4;
        Sun, 25 Aug 2019 23:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tsCdhGqjUY+eXv8R0/P4zJnXHp5W4wEHM1AAkePaAYY=;
        b=nmdGdiJLLe2ONZbhHdsNbVxRU6vq6oiXSee8sXTWmtixGiH+i89/5/z6wOSPlsU6A9
         IaRfJphITVZs/b3FngA5nMP1C91OuIFBJxF9dxDmWgcI1h5vMqI1MAtw2RD3Lo9SKxQy
         MAjJ+2qatD8rAPqIgcKxTW3XnOpsup1RKFDkm34QPeIaGPYUnWb4X97BPQa5QQQO4qW5
         MqNxxOGzVqz6XHWYXTep23Zhvvo6iChtRdFlorJA2mQm1Kpyr1Jq3DpHutN/VEB4+JXW
         85RWRV6/9mRv++RNlmQcx4s4iaMHxk1AjZcV1VAe8kkmLDVB2B1NApTla8dG+l5T3Hi3
         +x7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tsCdhGqjUY+eXv8R0/P4zJnXHp5W4wEHM1AAkePaAYY=;
        b=Ueu+HDf7omUKgSAlXstj48BN0/6jFy/5HRQ4cXuDRwXGbeJeRw9qmjsyCfOhq9J0yL
         JEYg03fMUhcCDUAbCJk9R++HLcENAg0lMbrnNW7BsmfXVKsa3wPpa2IMB7Q70rlPHjUM
         /fo7SwAHt7eWr0nojBH/dhV59sidFoDZCngvMYIsfxGBvCc9OsN0VV9RfsW7LjjXY3V9
         0BA1c79FBEy0NHgiPSnyuMMpls+5GufbGHGvgO56g+P4odj5J++0QRnIHBrcwMtQr/6I
         YDoOQ6BhWMZnv0aTMR7fizOJ/50lURN7ZhycjJTF5t8vdMaTlPrsr8bZ213wWKS7DqyO
         LOZA==
X-Gm-Message-State: APjAAAWinZ9+gXORF8GYQOfifTJVASRcFr9ZQW4IJ/se4bB+CfhyzNBM
        SnhbN4ZQgKhjWrgTR8kjXDKm/pYd2Yw=
X-Google-Smtp-Source: APXvYqwnIGdJZ3qFFFL+lAUhnryLUYP4cu27iJ6qKSM7PPaWO7a0vnCC7BGE3sq6A5CRZmpdTlM+vQ==
X-Received: by 2002:a17:902:6687:: with SMTP id e7mr5223706plk.211.1566800487678;
        Sun, 25 Aug 2019 23:21:27 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:27 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 05/23] KVM: PPC: Book3S HV: Enable calling kvmppc_hpte_hv_fault in virtual mode
Date:   Mon, 26 Aug 2019 16:20:51 +1000
Message-Id: <20190826062109.7573-6-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function kvmppc_hpte_hv_fault() is used to search a hpt (hash page
table) for an existing entry given a slb entry, a fault code and a fault
address.

Currently this function is only called in real mode. Modify this function
so that it can be called in virtual mode and add a function parameter used
to specify if the function is being called from real mode or not.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_ppc.h      | 3 ++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c     | 9 +++++++--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 2 ++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 2484e6a8f5ca..2c4d659cf8bb 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -688,7 +688,8 @@ long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 long kvmppc_rm_h_page_init(struct kvm_vcpu *vcpu, unsigned long flags,
 			   unsigned long dest, unsigned long src);
 long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
-                          unsigned long slb_v, unsigned int status, bool data);
+                          unsigned long slb_v, unsigned int status,
+			  bool data, bool is_realmode);
 unsigned long kvmppc_rm_h_xirr(struct kvm_vcpu *vcpu);
 unsigned long kvmppc_rm_h_xirr_x(struct kvm_vcpu *vcpu);
 unsigned long kvmppc_rm_h_ipoll(struct kvm_vcpu *vcpu, unsigned long server);
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 63e0ce91e29d..9f7ad4eaa528 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -1182,9 +1182,12 @@ EXPORT_SYMBOL(kvmppc_hv_find_lock_hpte);
  * -1 to pass the fault up to host kernel mode code, -2 to do that
  * and also load the instruction word (for MMIO emulation),
  * or 0 if we should make the guest retry the access.
+ * For a nested hypervisor, this will be called in virtual mode
+ * (is_realmode == false) and should be called with preemption disabled.
  */
 long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
-			  unsigned long slb_v, unsigned int status, bool data)
+			  unsigned long slb_v, unsigned int status,
+			  bool data, bool is_realmode)
 {
 	struct kvm *kvm = vcpu->kvm;
 	long int index;
@@ -1222,7 +1225,9 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 			v = hpte_new_to_old_v(v, r);
 			r = hpte_new_to_old_r(r);
 		}
-		rev = real_vmalloc_addr(&kvm->arch.hpt.rev[index]);
+		rev = &kvm->arch.hpt.rev[index];
+		if (is_realmode)
+			rev = real_vmalloc_addr(rev);
 		gr = rev->guest_rpte;
 
 		unlock_hpte(hpte, orig_v);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 337e64468d78..54e1864d4702 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2066,6 +2066,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	/* Search the hash table. */
 	mr	r3, r9			/* vcpu pointer */
 	li	r7, 1			/* data fault */
+	li	r8, 1			/* is real mode */
 	bl	kvmppc_hpte_hv_fault
 	ld	r9, HSTATE_KVM_VCPU(r13)
 	ld	r10, VCPU_PC(r9)
@@ -2158,6 +2159,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	mr	r4, r10
 	mr	r6, r11
 	li	r7, 0			/* instruction fault */
+	li	r8, 1			/* is real mode */
 	bl	kvmppc_hpte_hv_fault
 	ld	r9, HSTATE_KVM_VCPU(r13)
 	ld	r10, VCPU_PC(r9)
-- 
2.13.6

