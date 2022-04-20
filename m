Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96804508E8D
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381155AbiDTRiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381141AbiDTRiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:09 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A98414095
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso1252508pjt.0
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IFGVGXrPp0JKSYr31Wh7oCBYK9LScbz2jTaBX8GqLkA=;
        b=EunJ/c1twOmedQgxPOPLKjh6UDM8DxR2YwbC3zz4KwPz+61o3j6KS571FUEAiB1rfX
         UD2QoAfDkgPDX1AgRQy2cY/C7lZobRi5aidT06jQ6TagwA+XiW9FLo4nkfmiLfDmnkhN
         HAbaGLk5r4NeCKuOCepjg+VMqJHuWRhTvr15QtgND8aBslOtyQ7RH4B/TaEbhtehIUiI
         tIQH5Lt3r6WYO78h0DB5DZvRdtaNAcdhyYm1rGcH52k+6JwcwZQfONN8XFEkN2qqyDQP
         uy83RGoWnoD2gRWCMV3XsQ5w7jc6a6FwwT476Zd7TDOxhl+03+bhbAKP2P8cQcq/wSfH
         W5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IFGVGXrPp0JKSYr31Wh7oCBYK9LScbz2jTaBX8GqLkA=;
        b=CDC0YrG4dpHga8tmj60ohL1nHQrpEUHgFpviH4JXwc+aPAjibvrRlwwjMvI2nP5Zqm
         TT+ocGptv9RlujEJl3/0VVBcDYTL1ElqMFTgDxDwAkvZM+qCpDx0rwOMaT16gTWuuDuG
         HBUoblJUK+2xuWdGRArRDdphhgEDWHKP64TdC02vy8KP3233TFqjQuywBLTE5jH6/h/p
         /NUVFtuUDz01RNm6aNIb8vSDE2+kEGjq36vm+Q+QedeSYXQmDeH0efbcnFpu+dL9TpVN
         N2hXZgQqv5s9wsk5/9NNxTf51f3lEDIeySXwojjkTc/ZgJYgzA/tvk+NZdtSpAlGPBf/
         cd7w==
X-Gm-Message-State: AOAM533fHwI5BEGrbNlReACn66yUsYHbIZwajVxW9ctFs0mSYIArLUvt
        ciEuFzXZOJXIe9GlhBAPRa6DDwesfaTf
X-Google-Smtp-Source: ABdhPJw3BsCmwNNPj2DBXjtCbOyEoA2UFwm1nio4l/na63GTm4jZti88uWVQS74x8QcsTwokWYc99hM64MvX
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a17:90a:2e0d:b0:1c9:b839:af02 with SMTP id
 q13-20020a17090a2e0d00b001c9b839af02mr5620989pjd.122.1650476122112; Wed, 20
 Apr 2022 10:35:22 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:06 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 03/10] KVM: selftests: Read binary stats desc in lib
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the code to read the binary stats descriptors to the KVM selftests
library. It will be re-used by other tests to check KVM behavior.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
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
2.36.0.rc0.470.gd361397f0d-goog

