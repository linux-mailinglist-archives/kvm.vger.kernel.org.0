Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC72B6E848D
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjDSWSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjDSWSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:17 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF3E212F
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-52079a12451so209046a12.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942672; x=1684534672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOzd/WhvlpjJ956p72hZNImrff40bav5pGpgVf1jDCE=;
        b=nK5/1WGSlykOrMrz6zLE7ByOwHsNX7ku+LU2VBvTADuPSy3LTEvEYN/5idyeMAH9v6
         lDrCh9vx2uQPGrR2xDDmRNujTPNDyyzCxzk4mY1KxzUuZQGhhSyvWuaw1bMwsQMloPyl
         7AP1+xv6gUZEztUQTM1GZJONZkurrJQmSw8oo0Vlacs0NCnY8W0HIEeaXUNTT9FXPkDs
         BnQUvSJIxGIi32I9gl3+IkxfURT26aMcR2YDE4SZvKgasSWBzWeQlJS8HIQa8AHGBoBy
         oAuh9qhu2Ya7h80HYOyhHTVyAo19NM+J4mD7HNvy+vl3b7n5pBV/07agfGWnPCRxQI9a
         znow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942672; x=1684534672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOzd/WhvlpjJ956p72hZNImrff40bav5pGpgVf1jDCE=;
        b=aEAAIkJKK7xEw0Pd8cFCE1Hr1QlR0GAj5WwkkOvc5Lga47lNMpRL1770PQl/CyU2DG
         wxiquksiX+wjKW6Ysmdoiy5DvJtK0imNkMPaSE9xys0JuXe0TByR3TfS6jwBEwn71BqB
         cv22ZrlTqBL6/0Ja6K9U8DFlOD38xZZ1kyKZ1IY/TbVvNJ1qJS68p0ubvlTPaP4z6pqt
         saCSrjkeFQ9L9QbOVIstT3bQTCSfXPsOxF95bAQEdVf97Vgicu90Mnkbz6iCrEgTILSV
         q2mktZBGHNudWv7ur3auXXUfHNE0Cpr+O2dXSun2BZNljF56RXz6BD9yg7Lgfc9ywJqL
         10qQ==
X-Gm-Message-State: AAQBX9dG9OWHxlBs4zUF63eDRGvqFCaBhEHFa9BwyVIEiBQXrX0sVxXM
        XO4FMrB8LeWEe6OR8viNkuyNGw==
X-Google-Smtp-Source: AKy350YH91pAUPM41j7LqluKiXzQ7Ynx9OMjbtDndSOQdeDLatwEyjhoPFWqpUQdaJ4OsOf4sEQSuA==
X-Received: by 2002:a17:902:9004:b0:1a5:2621:34cd with SMTP id a4-20020a170902900400b001a5262134cdmr5755075plp.39.1681942671881;
        Wed, 19 Apr 2023 15:17:51 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:51 -0700 (PDT)
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
Subject: [RFC 10/48] RISC-V: KVM: Implement static memory region measurement
Date:   Wed, 19 Apr 2023 15:16:38 -0700
Message-Id: <20230419221716.3603068-11-atishp@rivosinc.com>
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

To support attestation of any images loaded by the VMM, the COVH allows
measuring these memory regions. Currently, it will be used for the
kernel image, device tree and initrd images.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_cove.h |   6 ++
 arch/riscv/kvm/cove.c             | 110 ++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_cove.h b/arch/riscv/include/asm/kvm_cove.h
index 3bf1bcd..4ea1df1 100644
--- a/arch/riscv/include/asm/kvm_cove.h
+++ b/arch/riscv/include/asm/kvm_cove.h
@@ -127,6 +127,7 @@ void kvm_riscv_cove_vcpu_load(struct kvm_vcpu *vcpu);
 void kvm_riscv_cove_vcpu_put(struct kvm_vcpu *vcpu);
 void kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *trap);
 
+int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm, struct kvm_riscv_cove_measure_region *mr);
 int kvm_riscv_cove_vm_add_memreg(struct kvm *kvm, unsigned long gpa, unsigned long size);
 int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva);
 #else
@@ -147,6 +148,11 @@ static inline void kvm_riscv_cove_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline void kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *trap) {}
 static inline int kvm_riscv_cove_vm_add_memreg(struct kvm *kvm, unsigned long gpa,
 					       unsigned long size) {return -1; }
+static inline int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm,
+						  struct kvm_riscv_cove_measure_region *mr)
+{
+	return -1;
+}
 static inline int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu,
 					    gpa_t gpa, unsigned long hva) {return -1; }
 #endif /* CONFIG_RISCV_COVE_HOST */
diff --git a/arch/riscv/kvm/cove.c b/arch/riscv/kvm/cove.c
index d001e36..5b4d9ba 100644
--- a/arch/riscv/kvm/cove.c
+++ b/arch/riscv/kvm/cove.c
@@ -27,6 +27,12 @@ static DEFINE_SPINLOCK(cove_fence_lock);
 
 static bool riscv_cove_enabled;
 
+static inline bool cove_is_within_region(unsigned long addr1, unsigned long size1,
+				       unsigned long addr2, unsigned long size2)
+{
+	return ((addr1 <= addr2) && ((addr1 + size1) >= (addr2 + size2)));
+}
+
 static void kvm_cove_local_fence(void *info)
 {
 	int rc;
@@ -192,6 +198,109 @@ int kvm_riscv_cove_vcpu_init(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
+int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm, struct kvm_riscv_cove_measure_region *mr)
+{
+	struct kvm_cove_tvm_context *tvmc = kvm->arch.tvmc;
+	int rc = 0, idx, num_pages;
+	struct kvm_riscv_cove_mem_region *conf;
+	struct page *pinned_page, *conf_page;
+	struct kvm_riscv_cove_page *cpage;
+
+	if (!tvmc)
+		return -EFAULT;
+
+	if (tvmc->finalized_done) {
+		kvm_err("measured_mr pages can not be added after finalize\n");
+		return -EINVAL;
+	}
+
+	num_pages = bytes_to_pages(mr->size);
+	conf = &tvmc->confidential_region;
+
+	if (!IS_ALIGNED(mr->userspace_addr, PAGE_SIZE) ||
+	    !IS_ALIGNED(mr->gpa, PAGE_SIZE) || !mr->size ||
+	    !cove_is_within_region(conf->gpa, conf->npages << PAGE_SHIFT, mr->gpa, mr->size))
+		return -EINVAL;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	/*TODO: Iterate one page at a time as pinning multiple pages fail with unmapped panic
+	 * with a virtual address range belonging to vmalloc region for some reason.
+	 */
+	while (num_pages) {
+		if (signal_pending(current)) {
+			rc = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		rc = get_user_pages_fast(mr->userspace_addr, 1, 0, &pinned_page);
+		if (rc < 0) {
+			kvm_err("Pinning the userpsace addr %lx failed\n", mr->userspace_addr);
+			break;
+		}
+
+		/* Enough pages are not available to be pinned */
+		if (rc != 1) {
+			rc = -ENOMEM;
+			break;
+		}
+		conf_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!conf_page) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		rc = cove_convert_pages(page_to_phys(conf_page), 1, true);
+		if (rc)
+			break;
+
+		/*TODO: Support other pages sizes */
+		rc = sbi_covh_add_measured_pages(tvmc->tvm_guest_id, page_to_phys(pinned_page),
+						 page_to_phys(conf_page), SBI_COVE_PAGE_4K,
+						 1, mr->gpa);
+		if (rc)
+			break;
+
+		/* Unpin the page now */
+		put_page(pinned_page);
+
+		cpage = kmalloc(sizeof(*cpage), GFP_KERNEL_ACCOUNT);
+		if (!cpage) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		cpage->page = conf_page;
+		cpage->npages = 1;
+		cpage->gpa = mr->gpa;
+		cpage->hva = mr->userspace_addr;
+		cpage->is_mapped = true;
+		INIT_LIST_HEAD(&cpage->link);
+		list_add(&cpage->link, &tvmc->measured_pages);
+
+		mr->userspace_addr += PAGE_SIZE;
+		mr->gpa += PAGE_SIZE;
+		num_pages--;
+		conf_page = NULL;
+
+		continue;
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (rc < 0) {
+		/* We don't to need unpin pages as it is allocated by the hypervisor itself */
+		cove_delete_page_list(kvm, &tvmc->measured_pages, false);
+		/* Free the last allocated page for which conversion/measurement failed */
+		kfree(conf_page);
+		kvm_err("Adding/Converting measured pages failed %d\n", num_pages);
+	}
+
+	return rc;
+}
+
 int kvm_riscv_cove_vm_add_memreg(struct kvm *kvm, unsigned long gpa, unsigned long size)
 {
 	int rc;
@@ -244,6 +353,7 @@ void kvm_riscv_cove_vm_destroy(struct kvm *kvm)
 	}
 
 	cove_delete_page_list(kvm, &tvmc->reclaim_pending_pages, false);
+	cove_delete_page_list(kvm, &tvmc->measured_pages, false);
 
 	/* Reclaim and Free the pages for tvm state management */
 	rc = sbi_covh_tsm_reclaim_pages(page_to_phys(tvmc->tvm_state.page), tvmc->tvm_state.npages);
-- 
2.25.1

