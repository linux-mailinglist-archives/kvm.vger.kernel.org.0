Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B0F5352FA
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348432AbiEZRyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348369AbiEZRyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789EBA76EC
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:17 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o8-20020a17090a9f8800b001dc9f554c7fso1427065pjp.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0FS/khluyzXyi0v7JMPmPvXNbS+JklV5tSdCLtxEUUk=;
        b=HrkQFgdujrqFd3BRxxt7bRuGXEf8RWb66hZtsqdudc94AMeXuZwfxe5oSwRdX+eRrR
         IYhW2jztILRKX2tbD1FD5BeoyJShY4usFO+IwyRiO69sgqyELWq00S6yUzjJe212LTno
         lZvROlt5uqQJdKmKI2UyjeFKzNvLkICfQtm17xgybvEFMeBeobAtbYtJHyEIwALgZ/tn
         u9wzo7lLnURyr0C2S1YpFxjtDfJ582dTQzUyXElddc4+9jX/levpaMUXZibHirpPurBB
         D9tW7T8+M7d0B3uM4L/KoxIMnwiyF0QtrkDNa6X8+4ImdN9vFEQd7MfcR4rgYGNe0g+9
         D+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0FS/khluyzXyi0v7JMPmPvXNbS+JklV5tSdCLtxEUUk=;
        b=dknG7ENrgghE+Xh6dr7ZnS48Q5tF4svd6x/yGj8b4ZBgI3hBzgf1MUbohFQI9//Fda
         zfxTSSfjEfB8WwfPmAB8zsJOgqODcighplXgE/HBcZljnbEjkB+gsL95iJjDcKNKYzTQ
         24ouDclLLVZ0ZCQtuSsZ8WWCOoKuDevFa7zSXv/Q0MO59HD3K5o1eeAFchzewAEhCC41
         q4l8UH7qZQE0j5Qha3v4MOsLwkDrJw7oRG18oi/I4rgIuU83nAWhepzFOzryDORc/5JT
         bo10JydzBaDNTf46rKu7HsQ/aRVCTXTASX2rlh79NS0g9V8IJDgr4sFIdPFcyBeW3zP2
         gPOw==
X-Gm-Message-State: AOAM532wMTel6bgCxfJ92xx8HbTJb09cNod0OSpLMuN/BTYgmOshtDPV
        TQQcp383Pub5XY6poYRsQ877sALVMuj9Ccilkv2XBBlScdyDph0Ou/zu6d+ZQuQ7RZ7tWW283r+
        dIMJ43Gg7ROwXDbFqndNJNQp5fPkZt/9Hy/baRTduDkeR/xn+Eq/2ZY0XF/Tu
X-Google-Smtp-Source: ABdhPJwEI6jPYmsPvZnvvRFp8VGXZTwyDOgPjMc7nn/ZmtEPM4e59mSKFUnPTnOJKJaq7mcxqB6EbYWXFEF5
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:8203:b0:15f:4423:6e9c with SMTP id
 x3-20020a170902820300b0015f44236e9cmr39395839pln.25.1653587656833; Thu, 26
 May 2022 10:54:16 -0700 (PDT)
Date:   Thu, 26 May 2022 17:54:00 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 03/11] KVM: selftests: Read binary stats desc in lib
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 .../selftests/kvm/include/kvm_util_base.h     | 24 ++++++++++++++
 .../selftests/kvm/kvm_binary_stats_test.c     | 16 +++------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 33 +++++++++++++++++++
 3 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 749cded9b157..da7bf881f94f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,6 +401,30 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void read_stats_header(int stats_fd, struct kvm_stats_header *header);
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
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index fb511b42a03e..a5198b9a19c1 100644
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
index 1d75d41f92dc..e5abcb189f1d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2577,3 +2577,36 @@ void read_stats_header(int stats_fd, struct kvm_stats_header *header)
 	ret = read(stats_fd, header, sizeof(*header));
 	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
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
2.36.1.124.g0e6072fb45-goog

