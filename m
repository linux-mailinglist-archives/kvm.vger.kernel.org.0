Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A44E6E84A2
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjDSWTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjDSWSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:50 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F82E93CD
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a67bcde3a7so5057005ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942693; x=1684534693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyIj0UBv9pS76jm0gxcpwmAmAKqEq2wUQqZgUQ6cXgk=;
        b=JUqXodm7yTv0ln6sHn0eyCWrKgQ2lIYWLmeyEDRipWR1vGY9jvhA0yFwbIBRMjhRbb
         5feEP/EeoRDxGxyKun0x5G2O5oEBJdDAFRS/RHZ4Ci8b/iv26PTeN1VUZ+s3pIrJBSTf
         rZjckAXPtWtvH1Kvmtp4JHL0K8GHX72uGWQN4DiIyrkkdwTzznpc2XULSlQqV9+qqsp4
         UJ+vBagyFy5rq5HF8Oa6OHLTBhdbA55/ZL15Y605z4/ZrHmgIiKmwYrEl9ntaC9BfLrM
         ClfqHB6I3YRHPV8jZmE8uYnBE2UGqLOLZNM172UxVHBchm+jEWBkzY2ZxZ7p2UfryNvP
         OpFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942693; x=1684534693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyIj0UBv9pS76jm0gxcpwmAmAKqEq2wUQqZgUQ6cXgk=;
        b=PEO2dpyjd9eC6uNVQqOGPx/ZedyzUYXlwb2e/N77vCcBH6++/ON339jFH/7qJTY9QZ
         2A2zvWEkShiBRleK0XLtQVjeSpx2xRJbZlcFSUEyFDI+2Lpn00a+ZDfb92d3Jcdig7Rb
         jfpb6g0iiWk0CISRtbHsY/f5LOOf2dsBC1KnETNTgALstDtZWyLstqPxh8wSnsLDhBcH
         OKA1uHM6ScHzMavpGc3LQc7Hd5IBwIoXhWjMrD8xyklP0/isl+fqMs6rGrDz9FKjn7Z6
         gZlJMOw+3OdCPh7I0rV4VIahIrJZknaNbfMbcVivNfZC4rbkgdZs/xKUzOgs2LCiXEkP
         Ld5A==
X-Gm-Message-State: AAQBX9ciXd1e8b7j1P8zlw+Ge+DmsFrbJROzWDJ1YzGx25SaStU3SpB4
        d6cY/9NXnfbn5qY9obd5fXOPYg==
X-Google-Smtp-Source: AKy350Y8OMGVUtVmKbRjYFU/NfkRlor4BXVO9AnvAi3r9stoJW7W2hRl3eELkUdIf0o2cuCG7q0qBA==
X-Received: by 2002:a17:903:2291:b0:19c:dbce:dce8 with SMTP id b17-20020a170903229100b0019cdbcedce8mr8768332plh.15.1681942693408;
        Wed, 19 Apr 2023 15:18:13 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:13 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 20/48] RISC-V: KVM: Add gstage mapping for TVMs
Date:   Wed, 19 Apr 2023 15:16:48 -0700
Message-Id: <20230419221716.3603068-21-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For TVM, the gstage mapping is managed by the TSM via COVH SBI
calls. The host is responsible for allocating page that must be pinned
to avoid swapping. The page is converted it to confidential before
handing over to the TSM for gstage mapping.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/cove.c      | 63 +++++++++++++++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu_exit.c |  9 ++++--
 2 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/cove.c b/arch/riscv/kvm/cove.c
index 4efcae3..44095f6 100644
--- a/arch/riscv/kvm/cove.c
+++ b/arch/riscv/kvm/cove.c
@@ -149,8 +149,68 @@ void kvm_riscv_cove_vcpu_put(struct kvm_vcpu *vcpu)
 
 int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva)
 {
-	/* TODO */
+	struct kvm_riscv_cove_page *tpage;
+	struct mm_struct *mm = current->mm;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned int flags = FOLL_LONGTERM | FOLL_WRITE | FOLL_HWPOISON;
+	struct page *page;
+	int rc;
+	struct kvm_cove_tvm_context *tvmc = kvm->arch.tvmc;
+
+	tpage = kmalloc(sizeof(*tpage), GFP_KERNEL_ACCOUNT);
+	if (!tpage)
+		return -ENOMEM;
+
+	mmap_read_lock(mm);
+	rc = pin_user_pages(hva, 1, flags, &page, NULL);
+	mmap_read_unlock(mm);
+
+	if (rc == -EHWPOISON) {
+		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
+				PAGE_SHIFT, current);
+		rc = 0;
+		goto free_tpage;
+	} else if (rc != 1) {
+		rc = -EFAULT;
+		goto free_tpage;
+	} else if (!PageSwapBacked(page)) {
+		rc = -EIO;
+		goto free_tpage;
+	}
+
+	rc = cove_convert_pages(page_to_phys(page), 1, true);
+	if (rc)
+		goto unpin_page;
+
+	rc = sbi_covh_add_zero_pages(tvmc->tvm_guest_id, page_to_phys(page),
+				     SBI_COVE_PAGE_4K, 1, gpa);
+	if (rc) {
+		pr_err("%s: Adding zero pages failed %d\n", __func__, rc);
+		goto zero_page_failed;
+	}
+	tpage->page = page;
+	tpage->npages = 1;
+	tpage->is_mapped = true;
+	tpage->gpa = gpa;
+	tpage->hva = hva;
+	INIT_LIST_HEAD(&tpage->link);
+
+	spin_lock(&kvm->mmu_lock);
+	list_add(&tpage->link, &kvm->arch.tvmc->zero_pages);
+	spin_unlock(&kvm->mmu_lock);
+
 	return 0;
+
+zero_page_failed:
+	//TODO: Do we need to reclaim the page now or VM gets destroyed ?
+
+unpin_page:
+	unpin_user_pages(&page, 1);
+
+free_tpage:
+	kfree(tpage);
+
+	return rc;
 }
 
 void kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *trap)
@@ -390,6 +450,7 @@ void kvm_riscv_cove_vm_destroy(struct kvm *kvm)
 
 	cove_delete_page_list(kvm, &tvmc->reclaim_pending_pages, false);
 	cove_delete_page_list(kvm, &tvmc->measured_pages, false);
+	cove_delete_page_list(kvm, &tvmc->zero_pages, true);
 
 	/* Reclaim and Free the pages for tvm state management */
 	rc = sbi_covh_tsm_reclaim_pages(page_to_phys(tvmc->tvm_state.page), tvmc->tvm_state.npages);
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 0d0c895..d00b9ee5 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -41,8 +41,13 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		};
 	}
 
-	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
-		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
+	if (is_cove_vcpu(vcpu)) {
+		/* CoVE doesn't care about PTE prots now. No need to compute the prots */
+		ret = kvm_riscv_cove_gstage_map(vcpu, fault_addr, hva);
+	} else {
+		ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
+			(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
+	}
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1

