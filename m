Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791284FFD55
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbiDMSCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbiDMSCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109AD3EF31
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i184-20020a62c1c1000000b0050603f28eadso1711457pfg.19
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jzWTSrObuuzchukDU3ZKJCOBHTggGHOLs/QEIhTLeaQ=;
        b=T7ff8Gw7EbvMO/RhGeZnSOV5XVRiNFOL3VC6qOIFpQq4ZrTBsrg5GpBZuyOEGQ1RIy
         Uf4/3LXk/fi/yAaRAsABMNt0a+oizpcd31KwOjIZgXlX1Lsu8/tY15pVm9A3N27cftnM
         jMWtJDOw8BlP4/xrMRmWpzd9rF+C3Ll3SFgjNOUPSYLr4jT9dcwhvf6oXLcrsSas2kHl
         cnp17MBxNHyYYjVh3lzPPPvsZGbKtqqxT1kG7AIsEfTXxyJcPRCCbrHlFn/SvuXGzT8U
         iNPaf8Mzqei2a63o4/Gw7/RrSCGv1sBd0VbpvFvwodDJdCxgdG5mfJAdILRPmRGdFPY2
         4CGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jzWTSrObuuzchukDU3ZKJCOBHTggGHOLs/QEIhTLeaQ=;
        b=CJcs/Q6MorkeOToDeD3+wOZh2ZsckfrqjK4ga6HL9EsImyiOieQy/rmPxZPibL8B+E
         5jAj6rcxU7QiE70Uohgy3yof4V+1otxK2hREQwqyxsmWhC7w/CLay1slrTnNZtIlTYSa
         0ywAfvyj6dFAzbYX/tIHeggQfwk5dmWuaHmPCDc2AV0Fo6+tTlJw7jbUAsnl1SS+s3un
         QTr/M5zzr7MVrKJMs70WCzfF32trxLuX9twN0wUKe9jG4PVSKw2lOeKEzEHkdifgGKhZ
         rH4+GpTGfiTQm/LFv5b3VYew9+xI2brUdN5F8B2DpgLdKMJ6HVcQ61HQeQUr2tTqrL1S
         wMtw==
X-Gm-Message-State: AOAM533cQ7BwL7knslmsXAeBQO09Do9Ho+t6eAkTkyGU5IWKfRWO8b66
        G/2FlpswRwTnZ2+FiBOil0bVFnLbbqSG
X-Google-Smtp-Source: ABdhPJw+1qz0wZbwekQ/1LYTZd61Pfe06F/KlYdFMslqEcJtAZD5QtALlGE+CSoEfB149VvN++QbigBl0GD2
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:3309:b0:505:ffd5:f146 with SMTP
 id cq9-20020a056a00330900b00505ffd5f146mr11833pfb.60.1649872792570; Wed, 13
 Apr 2022 10:59:52 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:37 -0700
In-Reply-To: <20220413175944.71705-1-bgardon@google.com>
Message-Id: <20220413175944.71705-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220413175944.71705-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 03/10] KVM: selftests: Read binary stats desc in lib
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
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

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +
 .../selftests/kvm/kvm_binary_stats_test.c     |  8 +---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 38 +++++++++++++++++++
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 749cded9b157..fabe46ddc1b2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,6 +401,8 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void read_stats_header(int stats_fd, struct kvm_stats_header *header);
+struct kvm_stats_desc *read_stats_desc(int stats_fd,
+				       struct kvm_stats_header *header);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index fb511b42a03e..b49fae45db1e 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -62,14 +62,8 @@ static void stats_test(int stats_fd)
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
+	stats_desc = read_stats_desc(stats_fd, &header);
 
 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1d75d41f92dc..12fa8cc88043 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2577,3 +2577,41 @@ void read_stats_header(int stats_fd, struct kvm_stats_header *header)
 	ret = read(stats_fd, header, sizeof(*header));
 	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
 }
+
+static ssize_t stats_descs_size(struct kvm_stats_header *header)
+{
+	return header->num_desc *
+	       (sizeof(struct kvm_stats_desc) + header->name_size);
+}
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
+struct kvm_stats_desc *read_stats_desc(int stats_fd,
+				       struct kvm_stats_header *header)
+{
+	struct kvm_stats_desc *stats_desc;
+	ssize_t ret;
+
+	stats_desc = malloc(stats_descs_size(header));
+	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
+
+	ret = pread(stats_fd, stats_desc, stats_descs_size(header),
+		    header->desc_offset);
+	TEST_ASSERT(ret == stats_descs_size(header),
+		    "Read KVM stats descriptors");
+
+	return stats_desc;
+}
-- 
2.35.1.1178.g4f1659d476-goog

