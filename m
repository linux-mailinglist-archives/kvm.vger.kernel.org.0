Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AEA54A172
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350901AbiFMVbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353139AbiFMV3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:19 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B9733F
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p2-20020a170902e74200b00164081f682cso3635236plf.16
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NphrsrvGM2ysfafA1BnbkDe+v8oridLj8hF4hpwL2dk=;
        b=UaWigyO27u2sBfxzJ5wByM0XODuTu6u5V7qsHyfP/HPKyAOcmdvCHk1hwQvAgh4ruy
         Qd/rkJnn9bdgQRvedE1ZXlUV6Aa/Ke9FSLA+s0trhhwy8iJNrIfSJAjxcfn5ZziS9LYY
         suku1u+ummjIygddnqgUKWI4xap5mZhk0oCYNVVMSjhKoRMVNap2wtYmj+ceoDRwE3YP
         ZByl5fn4fjZkLqqT7+yhm7ZiztK45KGa3jnECz8cVDFzZXUQGjwQ50Tdpm6EPex/cqH2
         uwTPUFFpH3Wr5Xn5vVJgN7Pvt13j/LOfdQ0HKE0APVdEbXU7jX7ZiWxqwzlGq5vriCYX
         wO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NphrsrvGM2ysfafA1BnbkDe+v8oridLj8hF4hpwL2dk=;
        b=69ZbSrTlEuYlqk17SuVHZxYA/K+K8SSmGIe1dKip98+dS1QibGGf10n6cPv9q3P87V
         Hv3SmsUSGcB7skz5L/jh6YjxrhOKcwAmqSKYNAqXrVkmywGjPympQaf0Tn8F2ULF1E00
         N9KpYDtmhMADOR7SrDJKgOEBdzlJFKUDSYe0Sgj8W5u4xLq5ZNMlio+LaaV/ne5fx7RS
         seP5hXpTNZFcJ5sUCEUHHZy7fJyMZFHU4Ju35haZFCRYEZvNFUcd0Rr2BN6ZU0rNFQCf
         qpUTN17c5L73iYLkdmKn2wALHwJFXfDjEPiWLFmwoxRmxV6VZ+PPcwc8qGZodzTApM9a
         X1Iw==
X-Gm-Message-State: AJIora94v9HIzg6DUcFXq49ICdGri34hMxfTMgaebxWjpY+/l0qKgotk
        hSlD5jM4wrs22wsjSNpqkcSwkL1FlzY8C7jF3Q90whY+DLDHJjxYNnJw3v7ZzXJoVRXJnA0+HRV
        K6D3z0xaixgJ5NLG3v7i/nNDOvaZkl8DxSnSBg09JiU7w78LgxS+RqaUuBLqE
X-Google-Smtp-Source: AGRyM1uIxj1wGiaZ4qlThdtRyOdAttssYwQlrUBe6mjmg1rt0zRK6XHQtdF7fki40BpGMsRRihfZ2oz0TLCt
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:f688:b0:163:ee37:91c5 with SMTP id
 l8-20020a170902f68800b00163ee3791c5mr959491plg.86.1655155531550; Mon, 13 Jun
 2022 14:25:31 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:16 +0000
In-Reply-To: <20220613212523.3436117-1-bgardon@google.com>
Message-Id: <20220613212523.3436117-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220613212523.3436117-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 03/10] KVM: selftests: Read binary stats desc in lib
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the code to read the binary stats descriptors to the KVM selftests
library. It will be re-used by other tests to check KVM behavior.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 25 ++++++++++++++
 .../selftests/kvm/kvm_binary_stats_test.c     | 16 +++------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 33 +++++++++++++++++++
 3 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 3d3dd144f427..6c66c6ef485b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -311,6 +311,31 @@ static inline void read_stats_header(int stats_fd, struct kvm_stats_header *head
 	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
 }
 
+struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
+					      struct kvm_stats_header *header);
+
+static inline ssize_t get_stats_descriptor_size(struct kvm_stats_header *header)
+{
+	 /*
+	  * The base size of the descriptor is defined by KVM's ABI, but the
+	  * size of the name field is variable, as far as KVM's ABI is
+	  * concerned. For a given instance of KVM, the name field is the same
+	  * size for all stats and is provided in the overall stats header.
+	  */
+	return sizeof(struct kvm_stats_desc) + header->name_size;
+}
+
+static inline struct kvm_stats_desc *get_stats_descriptor(struct kvm_stats_desc *stats,
+							  int index,
+							  struct kvm_stats_header *header)
+{
+	/*
+	 * Note, size_desc includes the size of the name field, which is
+	 * variable. i.e. this is NOT equivalent to &stats_desc[i].
+	 */
+	return (void *)stats + index * get_stats_descriptor_size(header);
+}
+
 void vm_create_irqchip(struct kvm_vm *vm);
 
 void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 64db17faacd2..9d3b9a0ce2ef 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -35,7 +35,7 @@ static void stats_test(int stats_fd)
 	/* Read kvm stats header */
 	read_stats_header(stats_fd, &header);
 
-	size_desc = sizeof(*stats_desc) + header.name_size;
+	size_desc = get_stats_descriptor_size(&header);
 
 	/* Read kvm stats id string */
 	id = malloc(header.name_size);
@@ -62,18 +62,12 @@ static void stats_test(int stats_fd)
 							header.data_offset),
 			"Descriptor block is overlapped with data block");
 
-	/* Allocate memory for stats descriptors */
-	stats_desc = calloc(header.num_desc, size_desc);
-	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
 	/* Read kvm stats descriptors */
-	ret = pread(stats_fd, stats_desc,
-			size_desc * header.num_desc, header.desc_offset);
-	TEST_ASSERT(ret == size_desc * header.num_desc,
-			"Read KVM stats descriptors");
+	stats_desc = read_stats_descriptors(stats_fd, &header);
 
 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
-		pdesc = (void *)stats_desc + i * size_desc;
+		pdesc = get_stats_descriptor(stats_desc, i, &header);
 		/* Check type,unit,base boundaries */
 		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
 				<= KVM_STATS_TYPE_MAX, "Unknown KVM stats type");
@@ -129,7 +123,7 @@ static void stats_test(int stats_fd)
 			"Data size is not correct");
 	/* Check stats offset */
 	for (i = 0; i < header.num_desc; ++i) {
-		pdesc = (void *)stats_desc + i * size_desc;
+		pdesc = get_stats_descriptor(stats_desc, i, &header);
 		TEST_ASSERT(pdesc->offset < size_data,
 			"Invalid offset (%u) for stats: %s",
 			pdesc->offset, pdesc->name);
@@ -144,7 +138,7 @@ static void stats_test(int stats_fd)
 	/* Read kvm stats data one by one */
 	size_data = 0;
 	for (i = 0; i < header.num_desc; ++i) {
-		pdesc = (void *)stats_desc + i * size_desc;
+		pdesc = get_stats_descriptor(stats_desc, i, &header);
 		ret = pread(stats_fd, stats_data,
 				pdesc->size * sizeof(*stats_data),
 				header.data_offset + size_data);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 39f2f5f1338f..fc957a385a0a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1857,3 +1857,36 @@ unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
 	n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
 	return vm_adjust_num_guest_pages(mode, n);
 }
+
+/*
+ * Read binary stats descriptors
+ *
+ * Input Args:
+ *   stats_fd - the file descriptor for the binary stats file from which to read
+ *   header - the binary stats metadata header corresponding to the given FD
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   A pointer to a newly allocated series of stat descriptors.
+ *   Caller is responsible for freeing the returned kvm_stats_desc.
+ *
+ * Read the stats descriptors from the binary stats interface.
+ */
+struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
+					      struct kvm_stats_header *header)
+{
+	struct kvm_stats_desc *stats_desc;
+	ssize_t desc_size, total_size, ret;
+
+	desc_size = get_stats_descriptor_size(header);
+	total_size = header->num_desc * desc_size;
+
+	stats_desc = calloc(header->num_desc, desc_size);
+	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
+
+	ret = pread(stats_fd, stats_desc, total_size, header->desc_offset);
+	TEST_ASSERT(ret == total_size, "Read KVM stats descriptors");
+
+	return stats_desc;
+}
-- 
2.36.1.476.g0c4daa206d-goog

