Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E07B4FC659
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350040AbiDKVNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350014AbiDKVM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:12:59 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636B228989
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:44 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i184-20020a62c1c1000000b0050569a135c1so7683056pfg.3
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PnhCdKeHHZWArDQ1iucb3AijNBhmwdSe4l8urUqIw/o=;
        b=kWej4LqMy2wG9GiOMR4EBwr5fY8uQGDDjlYT4c+BSMgcMMr/n4pfu/ZkxaknhQX9mQ
         HQ9PnUGA/rLimezn+RYxZT1qDXT+Xk8Kp8Oed0uBrJ93Mw0D49MzRmUmWdyqxZU6XKLn
         dsZWAj2kVr3HmVKSyzSfOFO/1XJ/lZmKhZc1UCo2xD/lLxE+LLVuJR/o/OTQ9fyEHbQ+
         fEs4g83jZGh0KXTL0ATE7EgDsqvpqNsUfUGLDi6kAOHDk7wmlsX/pAHOqXIRzF07Oj35
         UYhH09I8HwmBQMF1oJ2P5fGGSC5bASUCobdXbkesfpbyqcQXm80AYPTEKydotOIppkiJ
         T2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PnhCdKeHHZWArDQ1iucb3AijNBhmwdSe4l8urUqIw/o=;
        b=fIHtefPpTaeLo/4MOAk9U7HN7J3XRJFZEGq82zLYn1l3mmfN8q/fZQmb2mgP2JjLlL
         6YKAURFyaPvws+NJ0d/fwbUmEeD25ZYkAPQYO6cCMgWjxcApOS6sAkbkhFcR9MNl/vig
         7IpKqeu+4KpVtOfTxWZWyDPcyBp7sYHbDvMZRzd5bIRE/add4C5roWnJcHP36RYwnRgQ
         NqYRheGqQ6bSk9QwVTQLDhd37Yu7Jrpwgo+2G5ZhZM9fDUKtEinkz0vF72bnAwHo+N/W
         O3cqxDnNoUJT8pX9PSRFVXANttJtJXPDjAjgHpXuItH7CBPM4NNjA79ZV+MIx2L3b/CS
         Hbsw==
X-Gm-Message-State: AOAM5327SW2x/LwB1HPVBIZ/e2ZnnfLOxfg2RwiT6Cjxc8oKqn7UX/lo
        IANcQ/WgSUT3XGVrZTJLyH+QGjTXOMrx
X-Google-Smtp-Source: ABdhPJzyY925u/CK4XLi0NlB4Y6g2g9YO6PFKhDKu7ugWNkxp0SyHsGt8vwqyRqoSKM8xEXH8oneEN7MaUsE
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a2d0:faec:7d8b:2e0b])
 (user=bgardon job=sendgmr) by 2002:a17:902:70c8:b0:156:509b:68e3 with SMTP id
 l8-20020a17090270c800b00156509b68e3mr34743852plt.113.1649711443803; Mon, 11
 Apr 2022 14:10:43 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:10:09 -0700
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
Message-Id: <20220411211015.3091615-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 04/10] KVM: selftests: Read binary stat data in lib
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>,
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
 .../selftests/kvm/include/kvm_util_base.h     |  3 +++
 .../selftests/kvm/kvm_binary_stats_test.c     | 20 +++++-------------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c5f34551ff76..b2684cfc2cb1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -405,6 +405,9 @@ struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
 					  struct kvm_stats_header *header);
 void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
 			struct kvm_stats_desc *stats_desc);
+int read_stat_data(int stats_fd, struct kvm_stats_header *header,
+		   struct kvm_stats_desc *desc, uint64_t *data,
+		   ssize_t max_elements);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index e4795bad7db6..97b180249ba0 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -20,6 +20,8 @@
 #include "asm/kvm.h"
 #include "linux/kvm.h"
 
+#define STAT_MAX_ELEMENTS 1000
+
 static void stats_test(int stats_fd)
 {
 	ssize_t ret;
@@ -29,7 +31,7 @@ static void stats_test(int stats_fd)
 	struct kvm_stats_header header;
 	char *id;
 	struct kvm_stats_desc *stats_desc;
-	u64 *stats_data;
+	u64 stats_data[STAT_MAX_ELEMENTS];
 	struct kvm_stats_desc *pdesc;
 
 	/* Read kvm stats header */
@@ -130,25 +132,13 @@ static void stats_test(int stats_fd)
 			pdesc->offset, pdesc->name);
 	}
 
-	/* Allocate memory for stats data */
-	stats_data = malloc(size_data);
-	TEST_ASSERT(stats_data, "Allocate memory for stats data");
-	/* Read kvm stats data as a bulk */
-	ret = pread(stats_fd, stats_data, size_data, header.data_offset);
-	TEST_ASSERT(ret == size_data, "Read KVM stats data");
 	/* Read kvm stats data one by one */
-	size_data = 0;
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = (void *)stats_desc + i * size_desc;
-		ret = pread(stats_fd, stats_data,
-				pdesc->size * sizeof(*stats_data),
-				header.data_offset + size_data);
-		TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
-				"Read data of KVM stats: %s", pdesc->name);
-		size_data += pdesc->size * sizeof(*stats_data);
+		read_stat_data(stats_fd, &header, pdesc, stats_data,
+			       ARRAY_SIZE(stats_data));
 	}
 
-	free(stats_data);
 	free(stats_desc);
 	free(id);
 }
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e3ae26fbef03..64e2085f1129 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2593,3 +2593,24 @@ void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
 	TEST_ASSERT(ret == stats_descs_size(header),
 		    "Read KVM stats descriptors");
 }
+
+int read_stat_data(int stats_fd, struct kvm_stats_header *header,
+		   struct kvm_stats_desc *desc, uint64_t *data,
+		   ssize_t max_elements)
+{
+	ssize_t ret;
+
+	TEST_ASSERT(desc->size <= max_elements,
+		    "Max data elements should be at least as large as stat data");
+
+	ret = pread(stats_fd, data, desc->size * sizeof(*data),
+		    header->data_offset + desc->offset);
+
+	/* ret from pread is in bytes. */
+	ret = ret / sizeof(*data);
+
+	TEST_ASSERT(ret == desc->size,
+		    "Read data of KVM stats: %s", desc->name);
+
+	return ret;
+}
-- 
2.35.1.1178.g4f1659d476-goog

