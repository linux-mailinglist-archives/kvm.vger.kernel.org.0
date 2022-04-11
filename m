Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BB34FC663
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350038AbiDKVM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350014AbiDKVM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:12:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838D315822
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 78-20020a630551000000b0039958c05e70so9454362pgf.8
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jowVcPeazSi67SHgtKHyWBS9ErkTHd94DAj2Ts0QL0M=;
        b=Fkyh/qBc5dAbHEPYor9iqLZ2edWjPV7qo03ufqQAJHs5D95oaD8g1hbsktBpWjPvd8
         Tj9GgivDJotqnPauWNFysO5DvaLksOyFYeq0WEOq9k+BXexF9ZK5YA7j27I9YinVQRuq
         YYo8VRSpCeYCmwERrYYwq1qXnVf7h47eFGcKneLkLYymrLIVwooPor/E3ApLLjyp0+VC
         ASaaFV8CVJClt7aQtjPiw7HsMJERACVWfm/BoluRf+O1D0t2GM+vb/IZEgO+SO0K+IgB
         mFIPumy9JwhOMQtO3nHrUZLgCcirwK7VfF4EWnCjEf6WGiPnNXtTf0jtX1s8uhh3oIL8
         X7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jowVcPeazSi67SHgtKHyWBS9ErkTHd94DAj2Ts0QL0M=;
        b=U/KaxIfsZKJgQebAsp0lUsQojflrLQk/cWZLNNjR0oKNauZb9pP81Dz/vLUTryqxLo
         dQFNIxao00m5NEW2dWRfuVVTWPqiuQqA4xbyn4DycrWv/4p17DQE50w3LKzzV/N2bztR
         3AcoGrLl7fdpgNeuGG9GsiIj4meIHWaD3hH/2+zqJQPJ6hCPs8YwtKeRm7vvd8rMDcZa
         WsX4jZq5l65rpGWb8K6rk5jf9Pvqmgc+bSkd6R5Vn1cffsQXBD8WPT9a1nF+6kJE02TL
         0SP9QGCZUfY/496yjQvPz1nXnfp/3KWJJsTtGniXvF/CXweTMG3BU78jZKV1PsYo1SWH
         YTjQ==
X-Gm-Message-State: AOAM530/t3rq4qKL4yb4Lk9zQjvOXa/TjWuctWErBsldFrbT1zx15jew
        6DGw1iuD1lFOKZhFOew+CbVi7HiNyCkV
X-Google-Smtp-Source: ABdhPJw5goVNxXsGn1XxWfE1rh4zn1jaQ5MJFUoJlaymhAL+7IoXVGg0+wZdui9Zaj+6jHwCcufa++gDmrrn
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a2d0:faec:7d8b:2e0b])
 (user=bgardon job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr116087pjb.1.1649711441713; Mon, 11 Apr
 2022 14:10:41 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:10:08 -0700
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
Message-Id: <20220411211015.3091615-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 03/10] KVM: selftests: Read binary stats desc in lib
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

Move the code to read the binary stats descriptors to the KVM selftests
library. It will be re-used by other tests to check KVM behavior.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 +++
 .../selftests/kvm/kvm_binary_stats_test.c     |  9 ++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++++++++
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 5ba3132f3110..c5f34551ff76 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,6 +401,10 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header);
+struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
+					  struct kvm_stats_header *header);
+void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
+			struct kvm_stats_desc *stats_desc);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 22c22a90f15a..e4795bad7db6 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -62,14 +62,9 @@ static void stats_test(int stats_fd)
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
+	stats_desc = alloc_vm_stats_desc(stats_fd, &header);
+	read_vm_stats_desc(stats_fd, &header, stats_desc);
 
 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0caf28e324ed..e3ae26fbef03 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2564,3 +2564,32 @@ void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header)
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
+/* Caller is responsible for freeing the returned kvm_stats_desc. */
+struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
+					  struct kvm_stats_header *header)
+{
+	struct kvm_stats_desc *stats_desc;
+
+	stats_desc = malloc(stats_descs_size(header));
+	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
+
+	return stats_desc;
+}
+
+void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
+			struct kvm_stats_desc *stats_desc)
+{
+	ssize_t ret;
+
+	ret = pread(stats_fd, stats_desc, stats_descs_size(header),
+		    header->desc_offset);
+	TEST_ASSERT(ret == stats_descs_size(header),
+		    "Read KVM stats descriptors");
+}
-- 
2.35.1.1178.g4f1659d476-goog

