Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9544676243
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 01:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjAUAT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 19:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjAUATy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 19:19:54 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5567314C
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:19:22 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y66-20020a253245000000b007cb4f1e3e57so7418505yby.8
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CoXS9NR8J0lCDisdrTAQ77xqlurQK2TuY0Fdg8pUOxU=;
        b=E5VrJv2Hh0RmxBs1CPSwmu8xgt4qiqRciYcrXNA3andiehTlbQBzyXo+3IpgYQcFos
         uV4sCqmIxagqP/MnjPBDi0bAGuK0MDw0xKibN0uIeISt3SPn19Y3cYm9HWjtaq9KSG+6
         Os2YgJr/XOBiIvcyGQ5QQ00hTP3uTT3ZZpoxL/UMb1wrjKZ9NrenmHZ+OXWIH9G8GEgq
         bLxNJVQgtdLYNyR7MrtyYZHSTpt4Is23wEhQbbtNNhI3suLr17GaEy3TFlHDk9jwtSi+
         hDwvwsuG+iSlsogJYU+6ILeI+CiHuZQzrMVPV9gNi7X0emnR2Hy6GdmvLbpmMFUJz/k8
         BTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CoXS9NR8J0lCDisdrTAQ77xqlurQK2TuY0Fdg8pUOxU=;
        b=hiAbaSS5+dKufjaDAOkSL6beXNxm3hBz2lnRZvgInjtfwNRpSkr7nMQK9eHaTOtofX
         J96ir2e5L1p4o5XlX84CTGUA7pLyeqmI8vGcApDVjRZ7RiK8NpMNpiTSff+dh+efCSf9
         C8tC+YntmI0z1sNzMXD0xDK0MYxtMEEFfy5R7Z2AM3w4u63oEJFcFnrYYmwvtEYOsOFl
         8wxTMeoS1E5dTDRdwbNOJIfuB8oWjG4dY3/t2c62R7MnAbEP5O5ytMv1S73tQTVtX8Yh
         mVRh3bE/hwbSOHagKH2YwMDeTDOgF+kWW+F8vK5YqA66NNwF19otZjBxmJHmncx4Mecx
         hOrQ==
X-Gm-Message-State: AFqh2krv2wVJHh5D1RLtswD1dgRwWXf0AbMxfFpVjBro1zVlTJaHkwih
        R+YFgN20IW46RzRSpFeerUTczj6Pem7uR7GEzw==
X-Google-Smtp-Source: AMrXdXurazezYjrKpa5c/030vxFCh3UjbXOe7Br4b1qlVLdlxJrd3xlTjXikwWEVFysI/oB8UEaKP5KBcn41GK/9+Q==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a81:8943:0:b0:46f:daaf:f81f with SMTP
 id z64-20020a818943000000b0046fdaaff81fmr2058115ywf.161.1674260285954; Fri,
 20 Jan 2023 16:18:05 -0800 (PST)
Date:   Sat, 21 Jan 2023 00:15:37 +0000
In-Reply-To: <20230121001542.2472357-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20230121001542.2472357-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230121001542.2472357-27-ackerleytng@google.com>
Subject: [RFC PATCH v3 26/31] KVM: selftests: TDX: Update load_td_memory_region
 for VM memory backed by restricted memfd
From:   Ackerley Tng <ackerleytng@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, marcorr@google.com,
        eesposit@redhat.com, borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest memory is backed by restricted memfd

+ UPM is being used, hence encrypted memory region has to be
  registered
+ Can avoid making a copy of guest memory before getting TDX to
  initialize the memory region

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/lib/x86_64/tdx/tdx_util.c   | 43 +++++++++++++++----
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
index 4d6615b97770a..77803b7a1d739 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
@@ -207,6 +207,23 @@ static void tdx_td_finalizemr(struct kvm_vm *vm)
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
+	struct kvm_enc_region range = {
+		.addr = region->region.guest_phys_addr,
+		.size = region->region.memory_size,
+	};
+	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+}
+
 /*
  * TD creation/setup/finalization
  */
@@ -393,30 +410,38 @@ static void load_td_memory_region(struct kvm_vm *vm,
 	if (!sparsebit_any_set(pages))
 		return;
 
+
+	if (region->region_ext.restricted_fd != -1)
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
+		if (region->region_ext.restricted_fd == -1) {
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
+		if (region->region_ext.restricted_fd == -1)
+			munmap(source_addr, size_to_load);
 	}
 }
 
-- 
2.39.0.246.g2a6d74b583-goog

