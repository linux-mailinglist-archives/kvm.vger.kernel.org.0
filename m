Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0551656A642
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiGGOyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236154AbiGGOyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:54:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC28015A2C
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 07:53:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g126so5456825pfb.3
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 07:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fCJ8QaefSod2FLdMLTYJXcVAzkRtmLMvuXzW7AhKtNg=;
        b=ohr/MWgS1UQ+/RqKaVwpKraOsQZDAN9is50wEwY0SGO1YKNeTXChx9AZGHKtXsBBmy
         Mbp1n9fspU0TeIVN1VIrNZ7vPZzdDx1q/Eo3o+Na38S4wjuQ9jCi/QPL3PhU9kb/Nz/N
         sL7Rz0wsEVRNOzl7JGtvop7SVc9OQepRnfWrIGfdYy3U3WujeOLTny3Fd6p4OIHTVuHw
         4ONX7nnB1kHQspD5L7+rNnmUdBwLlETywejxdMnqyA0LRUWtz6nWWNUkg71C2DAp9YiA
         Lh8Sf6yiCI4CbfCT+V+YntxYuQbEXcjqhGU/Hp7/b8bbJY6ZjnWH/G9c31yRwu+6L7qe
         nZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fCJ8QaefSod2FLdMLTYJXcVAzkRtmLMvuXzW7AhKtNg=;
        b=FXdnelPuRBQs9iEe810M0UrBWEB+nosU+w9q+J0VXOzR/pIvt5LpICR/Bwvtkgz2HW
         Bht8gkjALSfOUNRjAQ3GQsEvjDv/1tCar31WC6DEKyAVKNqoY1aVLZI/qnfXMwRpndFd
         s7kt4hDhtd3CaAup4Y2ByF87H/aqjwyJG9B9HIiPd8NKgLeJLsMqrN5gwriZZIRn9EiY
         Mf0zA23vnRKff8/fUaI88VMeKi+qTpY7UrUk17uLf5X0P0QGm3I83SS+UYpCgn6ixWwN
         JEUCecMqYavV8yrj6eLcgHZFbYdY0SehlYvD0JAo3N7d8C+EbQOfp/5T+0pMJElimf/3
         Q9ng==
X-Gm-Message-State: AJIora/IbqdF3ZocWxO1gDfg/E27zBwRyZbLfP1Dn6bGF+IRmasOWV30
        7qGSRZ2z5FMkEVUqfXRvjx/5Xg==
X-Google-Smtp-Source: AGRyM1snRoAR3IesxARH9go1XUXWfZLlCv+MUuUz10z6M/0+3rvZbNtTwjV0qKUuBZJUWXwPPcq4Ag==
X-Received: by 2002:a17:903:124c:b0:16b:a568:996d with SMTP id u12-20020a170903124c00b0016ba568996dmr45373917plh.169.1657205610537;
        Thu, 07 Jul 2022 07:53:30 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([223.226.40.162])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7951a000000b0052535e7c489sm27144231pfp.114.2022.07.07.07.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:53:29 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 3/5] RISC-V: KVM: Add G-stage ioremap() and iounmap() functions
Date:   Thu,  7 Jul 2022 20:22:46 +0530
Message-Id: <20220707145248.458771-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707145248.458771-1-apatel@ventanamicro.com>
References: <20220707145248.458771-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The in-kernel AIA IMSIC support requires on-demand mapping / unmapping
of Guest IMSIC address to Host IMSIC guest files. To help achieve this,
we add kvm_riscv_stage2_ioremap() and kvm_riscv_stage2_iounmap()
functions. These new functions for updating G-stage page table mappings
will be called in atomic context so we have special "in_atomic" parameter
for this purpose.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  5 +++++
 arch/riscv/kvm/mmu.c              | 18 ++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 59a0cf2ca7b9..60c517e4d576 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -284,6 +284,11 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
 void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
 			       unsigned long hbase, unsigned long hmask);
 
+int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
+			     phys_addr_t hpa, unsigned long size,
+			     bool writable, bool in_atomic);
+void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
+			      unsigned long size);
 int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index b75d4e200064..f7862ca4c4c6 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -343,8 +343,9 @@ static void gstage_wp_memory_region(struct kvm *kvm, int slot)
 	kvm_flush_remote_tlbs(kvm);
 }
 
-static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
-			  unsigned long size, bool writable)
+int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
+			     phys_addr_t hpa, unsigned long size,
+			     bool writable, bool in_atomic)
 {
 	pte_t pte;
 	int ret = 0;
@@ -353,6 +354,7 @@ static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 	struct kvm_mmu_memory_cache pcache;
 
 	memset(&pcache, 0, sizeof(pcache));
+	pcache.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
 	pcache.gfp_zero = __GFP_ZERO;
 
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
@@ -382,6 +384,13 @@ static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 	return ret;
 }
 
+void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
+{
+	spin_lock(&kvm->mmu_lock);
+	gstage_unmap_range(kvm, gpa, size, false);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					     struct kvm_memory_slot *slot,
 					     gfn_t gfn_offset,
@@ -517,8 +526,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				goto out;
 			}
 
-			ret = gstage_ioremap(kvm, gpa, pa,
-					     vm_end - vm_start, writable);
+			ret = kvm_riscv_gstage_ioremap(kvm, gpa, pa,
+						       vm_end - vm_start,
+						       writable, false);
 			if (ret)
 				break;
 		}
-- 
2.34.1

