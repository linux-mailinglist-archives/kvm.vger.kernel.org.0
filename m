Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4551518C5A
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 20:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241467AbiECSed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 14:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241411AbiECSe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 14:34:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882A91D0C6
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 11:30:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d188-20020a25cdc5000000b00648429e5ab9so16294799ybf.13
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 11:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3/QOXmo+jSd7MUY1n1sbQqzuMbb/wqCHqK/oyoJG464=;
        b=XzuEAgapJuZ4gslUfI9xP5hZtQX0BO5IYLc1XWxKwO4vFs3yQJf1/JEgC4P2C6ayu5
         c8zFJkqvyVOTDBI39Gge7pWgFPx6xwujBMf1VH/O27lsSOvvWwrrm2/99tn/wfV+5uAI
         i+RWF5TtAeOzVZrEeaG7/k1bJHWAqkTBoA0m2ha6ACTyCVWJdT/39IJh2yK47nHVKmAp
         JCJuyKLpZDyZu4I/tWolCNP2unndLsRUSPeY0FPde4d2d+y2QgdfczGOFMi19UJ/SUVN
         NxCMnl+oVGFEcuswZHxQaGQ8lN1T2qlyKnhzjKXMZbX9mi7zIdFB0tZF6GnZ7lBPCsSS
         goRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3/QOXmo+jSd7MUY1n1sbQqzuMbb/wqCHqK/oyoJG464=;
        b=dfPLKZ15qEjevs7NyFtZSGifPZ9NwDYbKnYtnlSHKxnOwcRZMPGKbcruR+9MyZwW2u
         q8MkTdrbja2sawg9njqaFYh4rtZffwLj++5pyVAezZLozR1rjCkoMz5bDl3wDbL/gvNs
         e5bWoiHGm/tzRIB2CgWV/2r9V+MTLgr00F/K8F9IHg5rveuyUd3qzCpNw6rHi/elCRBG
         1/tsEuxFJbROHDy3yv2yOF2lsnHiQRaQ8T1RXo5qtsJR6+mq1OFlwAiX00/B+Gjc+OBe
         uSDG8FDYY9e2T75yucloUcjK4tDtcYZ3iArVHduGVuBzOyLTa72ChljZYAL+1iFfmJu+
         QZ3w==
X-Gm-Message-State: AOAM532k/T+8t9UpKsk9jGlTGNYHvp/qbnTrjfASRTV/WpAL75vTKCC0
        joqO2IRURz9c9axpf+4VYUALP9AubcJM
X-Google-Smtp-Source: ABdhPJzOdIxW1iRe2vRKUNc/Nj7MyA6lA4aRxsBwZOdbYZZvrJz2siQXwDQza6mdWwtDSaTyeF/70nWoEP+4
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6902:703:b0:649:3ed0:a132 with SMTP id
 k3-20020a056902070300b006493ed0a132mr16872059ybt.185.1651602653774; Tue, 03
 May 2022 11:30:53 -0700 (PDT)
Date:   Tue,  3 May 2022 18:30:37 +0000
In-Reply-To: <20220503183045.978509-1-bgardon@google.com>
Message-Id: <20220503183045.978509-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220503183045.978509-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 03/11] KVM: selftests: Read binary stats desc in lib
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

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
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
2.36.0.464.gb9c8b46e94-goog

