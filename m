Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7405B762583
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjGYWDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjGYWCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:02:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B66F2D48
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:22 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56942667393so78019267b3.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690322520; x=1690927320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g4KcxLrzQkXOChykEZFXIv5nUY2y8T7+ZlIOw1AWFkc=;
        b=fkrYsLWyogUVFgS4vePJWwymNPenlzaFl9gf8Jak3i3FMyFQEfdiYt85RuLv7nnYWq
         4RNZ8BVD4lIIBvw8v1OiGn8I6qHrsP4bghvqX0r8CTRYxPxc57oeDSeDrRFtZWqZVT7U
         fLgnE+HTKSsYGyOUcElr+LrKwCgPCE0YspD22KaNwn3TmWJRa2JF4dhyXdFIAgFH5JxV
         U7be3pIOdvuFA/eWH7c1uy+2IARQb2dU+Sbhj37Fn487aAWBoPCsmWsrbsHUMk+dt8Yw
         ziELdfhK5qQrLT47kvGQjjWnRq9MRHlHOfE5sS5dRSgGXYiuYpDZ31KyBQIvRdKLkKvu
         4g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690322520; x=1690927320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4KcxLrzQkXOChykEZFXIv5nUY2y8T7+ZlIOw1AWFkc=;
        b=l6Pls1aiKgEJY2NIw1uQA41aqLN7cI187lNHCQrYzZjC48koSvWcN/Guw+XlwBF0Bh
         OCu6ytK12S2IihQsBZBaCk4bFyQq1dShcZlf+IH88YYjCAA16LDHdZ0x2G8Lwh7x2qYH
         TxYJeKFgDPGOMjNzEjQsnSeq1H/bw5qgBwVgh+3Y71Ma/HgfO9ksEaPPdRrino7BQR2t
         tYxhWFVaU7WwM8KWN+cu3GAS6MP+xjBDFiqIRpWg9OfgnfrB4Svs4u8lAbJld0k1jq0J
         Bpz2UJBelHcRtGTISoTI0ifvhuv/GQQiXvqq0j3q3ZYioOA/Y4CYFhkwX0HjAE0gz4G3
         zk7A==
X-Gm-Message-State: ABy/qLZHFnOCNCvrENJH4fLOWGtKW+B1dDGSC22bCw5hgi1EP1QnUMBU
        UdWEhXCZLszWTgxNNWKArwXMJWOjNQRP
X-Google-Smtp-Source: APBJJlGk02QkSJLPp43LDnyvS2p1LTv46fGTg4fQgNMMmRcnaVvnBglLkNtr8PLqRyPqh66JIr5RCPySeD1A
X-Received: from afranji.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:47f1])
 (user=afranji job=sendgmr) by 2002:a81:b614:0:b0:579:fc33:b3a2 with SMTP id
 u20-20020a81b614000000b00579fc33b3a2mr4504ywh.10.1690322519981; Tue, 25 Jul
 2023 15:01:59 -0700 (PDT)
Date:   Tue, 25 Jul 2023 22:01:00 +0000
In-Reply-To: <20230725220132.2310657-1-afranji@google.com>
Mime-Version: 1.0
References: <20230725220132.2310657-1-afranji@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230725220132.2310657-8-afranji@google.com>
Subject: [PATCH v4 07/28] KVM: selftests: TDX: Update load_td_memory_region
 for VM memory backed by guest memfd
From:   Ryan Afranji <afranji@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, eesposit@redhat.com,
        borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ackerleytng@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ackerley Tng <ackerleytng@google.com>

If guest memory is backed by restricted memfd

+ UPM is being used, hence encrypted memory region has to be
  registered
+ Can avoid making a copy of guest memory before getting TDX to
  initialize the memory region

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I43a5a444d5d2b5bf0d6750f6ef82c16e3d7d755e
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 .../selftests/kvm/lib/x86_64/tdx/tdx_util.c   | 41 +++++++++++++++----
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
index 95c6fb263583..c30801f4f759 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
@@ -199,6 +199,21 @@ static void tdx_td_finalizemr(struct kvm_vm *vm)
 	tdx_ioctl(vm->fd, KVM_TDX_FINALIZE_VM, 0, NULL);
 }
 
+/*
+ * Other ioctls
+ */
+
+/**
+ * Register a memory region that may contain encrypted data in KVM.
+ */
+static void register_encrypted_memory_region(
+	struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	vm_set_memory_attributes(vm, region->region.guest_phys_addr,
+				 region->region.memory_size,
+				 KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
 /*
  * TD creation/setup/finalization
  */
@@ -383,30 +398,38 @@ static void load_td_memory_region(struct kvm_vm *vm,
 	if (!sparsebit_any_set(pages))
 		return;
 
+
+	if (region->region.gmem_fd != -1)
+		register_encrypted_memory_region(vm, region);
+
 	sparsebit_for_each_set_range(pages, i, j) {
 		const uint64_t size_to_load = (j - i + 1) * vm->page_size;
 		const uint64_t offset =
 			(i - lowest_page_in_region) * vm->page_size;
 		const uint64_t hva = hva_base + offset;
 		const uint64_t gpa = gpa_base + offset;
-		void *source_addr;
+		void *source_addr = (void *)hva;
 
 		/*
 		 * KVM_TDX_INIT_MEM_REGION ioctl cannot encrypt memory in place,
 		 * hence we have to make a copy if there's only one backing
 		 * memory source
 		 */
-		source_addr = mmap(NULL, size_to_load, PROT_READ | PROT_WRITE,
-				   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-		TEST_ASSERT(
-			source_addr,
-			"Could not allocate memory for loading memory region");
-
-		memcpy(source_addr, (void *)hva, size_to_load);
+		if (region->region.gmem_fd == -1) {
+			source_addr = mmap(NULL, size_to_load, PROT_READ | PROT_WRITE,
+					MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+			TEST_ASSERT(
+				source_addr,
+				"Could not allocate memory for loading memory region");
+
+			memcpy(source_addr, (void *)hva, size_to_load);
+			memset((void *)hva, 0, size_to_load);
+		}
 
 		tdx_init_mem_region(vm, source_addr, gpa, size_to_load);
 
-		munmap(source_addr, size_to_load);
+		if (region->region.gmem_fd == -1)
+			munmap(source_addr, size_to_load);
 	}
 }
 
-- 
2.41.0.487.g6d72f3e995-goog

