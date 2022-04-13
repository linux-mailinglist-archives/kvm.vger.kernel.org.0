Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AEB4FFD59
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiDMSCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbiDMSCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:20 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2893FD9F
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:57 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id y12-20020a4a86cc000000b00324cb8287a4so1388340ooh.19
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nE0p9VkAEZPrbUZLBLHj/EA6GeKDyutWcWOyx+QH1CQ=;
        b=CGNbDpPje6DWNjSf8HxzYlFoeW1No4i38r6wXXxwwBripH9w+hcowUZjbCXeEk7ebm
         JxfkF/a2MAsta6GRKlumZE6cFaOm/Yli8aCQmtf0wxrUnAcQlyyzk/cU8XGWus381SF/
         JJMqKOUXYgEuvwwpU3m8+ZCRalGNv0LEk6CSfdh9BSWnas3iuooeZM7XMsT8H5BrlMnh
         RGhfZnBAP6eymm5zbSoH03p791b2+LMIiH3gDKpQfotTNSudybPXIx3ElmeOLTSdcP6Z
         a2wkvjqmqlx90KsFRn1CWqeB5Gjecuhtn5LxmvywsA0apGF8kDHFZe/PSmzbdFhrC2DV
         /7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nE0p9VkAEZPrbUZLBLHj/EA6GeKDyutWcWOyx+QH1CQ=;
        b=PNXOVornHi4dhjfdcGm6CZ4QjmDsmqGMvgrpM4E5kihddZm+KqX7pf9yyeWXMgdwp2
         XEXnwawRoyZjoyOpPH2XGJWX2r4P8mBACm78WdQTbGcHDZmLF4u+otT5OxLj6JdaeYn4
         ZQi3fW3ALoO+iqElpbdnC1t2EQCwQ9u2V3J+THVI15LplErBR+y/9V9iJ5dJL9nCy7IL
         TRhckwpD5TtNfK0WMHfS2jpdLZABKa5/DucBxC0a/SERHjptas6P5nAA6+zWi/ISHrRG
         0pp0Xd1ygDWFpv6Y4/FFhZBWVDb8c+clGr1HPzx9lr5Z2rojJ8kGmFUc6UUIGYbyPTlZ
         x/Sw==
X-Gm-Message-State: AOAM531DYrUUMmBM3vzEEhi0ijBswnUrnVWi83Ao5FdGpz4nvWa8M4Rz
        nWkkN9ZDYhmd8P8/nMNxr18AdN9ivKO4
X-Google-Smtp-Source: ABdhPJxIEOLgikotz+8frIC7nYGrz+JkYc/+D4E6cRrh+T9b8zgx11iYyDt9qlI4bTND46iVkwTs5LlwOE4V
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a05:6870:a789:b0:de:a48c:c953 with SMTP id
 x9-20020a056870a78900b000dea48cc953mr9066oao.298.1649872796515; Wed, 13 Apr
 2022 10:59:56 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:39 -0700
In-Reply-To: <20220413175944.71705-1-bgardon@google.com>
Message-Id: <20220413175944.71705-6-bgardon@google.com>
Mime-Version: 1.0
References: <20220413175944.71705-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 05/10] KVM: selftests: Read binary stat data in lib
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

Move the code to read the binary stats data to the KVM selftests
library. It will be re-used by other tests to check KVM behavior.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 .../selftests/kvm/kvm_binary_stats_test.c     |  7 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fabe46ddc1b2..2a3a4d9ed8e3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -403,6 +403,9 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void read_stats_header(int stats_fd, struct kvm_stats_header *header);
 struct kvm_stats_desc *read_stats_desc(int stats_fd,
 				       struct kvm_stats_header *header);
+int read_stat_data(int stats_fd, struct kvm_stats_header *header,
+		   struct kvm_stats_desc *desc, uint64_t *data,
+		   ssize_t max_elements);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 8b31f8fc7e08..59677fae26e5 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -160,11 +160,8 @@ static void stats_test(int stats_fd)
 	size_data = 0;
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = (void *)stats_desc + i * size_desc;
-		ret = pread(stats_fd, stats_data,
-				pdesc->size * sizeof(*stats_data),
-				header.data_offset + size_data);
-		TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
-				"Read data of KVM stats: %s", pdesc->name);
+		read_stat_data(stats_fd, &header, pdesc, stats_data,
+			       pdesc->size);
 		size_data += pdesc->size * sizeof(*stats_data);
 	}
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 12fa8cc88043..fc2321055a69 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2615,3 +2615,39 @@ struct kvm_stats_desc *read_stats_desc(int stats_fd,
 
 	return stats_desc;
 }
+
+/*
+ * Read stat data for a particular stat
+ *
+ * Input Args:
+ *   stats_fd - the file descriptor for the binary stats file from which to read
+ *   header - the binary stats metadata header corresponding to the given FD
+ *   desc - the binary stat metadata for the particular stat to be read
+ *   max_elements - the maximum number of 8-byte values to read into data
+ *
+ * Output Args:
+ *   data - the buffer into which stat data should be read
+ *
+ * Return:
+ *   The number of data elements read into data or -ERRNO on error.
+ *
+ * Read the data values of a specified stat from the binary stats interface.
+ */
+int read_stat_data(int stats_fd, struct kvm_stats_header *header,
+		   struct kvm_stats_desc *desc, uint64_t *data,
+		   ssize_t max_elements)
+{
+	ssize_t size = min((ssize_t)desc->size, max_elements);
+	ssize_t ret;
+
+	ret = pread(stats_fd, data, size * sizeof(*data),
+		    header->data_offset + desc->offset);
+
+	/* ret from pread is in bytes. */
+	ret = ret / sizeof(*data);
+
+	TEST_ASSERT(ret == size,
+		    "Read data of KVM stats: %s", desc->name);
+
+	return ret;
+}
-- 
2.35.1.1178.g4f1659d476-goog

