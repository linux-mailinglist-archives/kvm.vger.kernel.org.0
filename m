Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2B254A15E
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiFMVaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353156AbiFMV3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C557B399
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a68-20020a25ca47000000b006605f788ff1so5946829ybg.16
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZzUThN+xouEXvquQYC3DjLFRmnBgRRe1A4CrkgI7ln4=;
        b=sHRyLYL421Xs0PblSrY0pePkWWuCbev2uWNsbFVqXMw40pLxEjaugtFZH9hHbSx7HR
         1NRAaX3xND50k/oiJGPt2gfpQw5CCLDxrwJ1UddD3gWct9pbidECcF7B0SiF2sZj1Fi7
         jhMPI8hV3cd37iDSymmTrD8JUZL8E4M1t/6n0Uy16fIpFJRGWTDuy0ToyJQaujRUPAwi
         /jSl4bUG8WzViV5GMDtPalVnzRSw81d+nyCjDLsK7uaQFuNNemWBTka3EPFqYXyLoCq1
         oqjRs/x595w3x3i7jjjg9Q/p31wQHgWAVTtF/0CNX7Xl6kkXITVorHa5fHfB9KAaBP0K
         XAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZzUThN+xouEXvquQYC3DjLFRmnBgRRe1A4CrkgI7ln4=;
        b=jDf8GaQPXkh1DgOF7PpGggBfiEgSGPK9IFnJfJPgfvrMgycrTLEEjGoZuHV2An4k8K
         EsEiY6uavSil8LJoh338IVVmHmMNRYNdPvEYdCqBcAnh45bePlhag8zo4EijM+lpV9tX
         OyaLFrXdC/o4yrflu6R9m6KFyuWUL3fcDEria8QXIfFim1PmM+JlUky0D/rqnM6b1Wv0
         jng7TUU964zjWjMaGijLRYlMl0GUKdL+9BnmazZA+pTPptbdYviQg0z1KnHLLvn/4J0Y
         k8+2+e1P2hPePpceSJIQnJfHt9086Nii4Of14ibT7NTO0N8L+hojyNXL9MlFeaz/bM/n
         oqaA==
X-Gm-Message-State: AJIora9QazAM6aqeHpqxa0sHC9s7y5XP5QLvavDl4MmL9hJyxRPWh90u
        jKTjOdy+DaIFTOLlZrSgmVv7vr5abcmDrl84pVb4N20shE8IJw0G6kYtNBM+BlxLc5LRkLlY58B
        rLr+zhsJE//kJo5/Ghc5ck/pdRIyH15qu6P4s3VQl4L/DJKaRGPupPfVbCVeu
X-Google-Smtp-Source: AGRyM1sXk21WOlgWX4dQMcaAZ1rEcbnnYGTFH9DeiQwG9O2E9jG7cqqfX4nk+5lfn4xuFhinU/bIu6fC/ZmM
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a81:a95:0:b0:30c:7063:ff2e with SMTP id
 143-20020a810a95000000b0030c7063ff2emr1915851ywk.65.1655155534947; Mon, 13
 Jun 2022 14:25:34 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:18 +0000
In-Reply-To: <20220613212523.3436117-1-bgardon@google.com>
Message-Id: <20220613212523.3436117-6-bgardon@google.com>
Mime-Version: 1.0
References: <20220613212523.3436117-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 05/10] KVM: selftests: Read binary stat data in lib
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

Move the code to read the binary stats data to the KVM selftests
library. It will be re-used by other tests to check KVM behavior.

Also opportunistically remove an unnecessary calculation with
"size_data" in stats_test.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 +++
 .../selftests/kvm/kvm_binary_stats_test.c     |  9 ++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++++++++++
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6c66c6ef485b..aa7f8b681944 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -336,6 +336,10 @@ static inline struct kvm_stats_desc *get_stats_descriptor(struct kvm_stats_desc
 	return (void *)stats + index * get_stats_descriptor_size(header);
 }
 
+void read_stat_data(int stats_fd, struct kvm_stats_header *header,
+		    struct kvm_stats_desc *desc, uint64_t *data,
+		    size_t max_elements);
+
 void vm_create_irqchip(struct kvm_vm *vm);
 
 void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 3002fab2bbf1..98b882ec8f98 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -147,15 +147,10 @@ static void stats_test(int stats_fd)
 	ret = pread(stats_fd, stats_data, size_data, header.data_offset);
 	TEST_ASSERT(ret == size_data, "Read KVM stats data");
 	/* Read kvm stats data one by one */
-	size_data = 0;
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = get_stats_descriptor(stats_desc, i, &header);
-		ret = pread(stats_fd, stats_data,
-				pdesc->size * sizeof(*stats_data),
-				header.data_offset + size_data);
-		TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
-				"Read data of KVM stats: %s", pdesc->name);
-		size_data += pdesc->size * sizeof(*stats_data);
+		read_stat_data(stats_fd, &header, pdesc, stats_data,
+			       pdesc->size);
 	}
 
 	free(stats_data);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fc957a385a0a..5b8249a0e1de 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1890,3 +1890,38 @@ struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
 
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
+ * Read the data values of a specified stat from the binary stats interface.
+ */
+void read_stat_data(int stats_fd, struct kvm_stats_header *header,
+		    struct kvm_stats_desc *desc, uint64_t *data,
+		    size_t max_elements)
+{
+	size_t nr_elements = min_t(ssize_t, desc->size, max_elements);
+	size_t size = nr_elements * sizeof(*data);
+	ssize_t ret;
+
+	TEST_ASSERT(desc->size, "No elements in stat '%s'", desc->name);
+	TEST_ASSERT(max_elements, "Zero elements requested for stat '%s'", desc->name);
+
+	ret = pread(stats_fd, data, size,
+		    header->data_offset + desc->offset);
+
+	TEST_ASSERT(ret >= 0, "pread() failed on stat '%s', errno: %i (%s)",
+		    desc->name, errno, strerror(errno));
+	TEST_ASSERT(ret == size,
+		    "pread() on stat '%s' read %ld bytes, wanted %lu bytes",
+		    desc->name, size, ret);
+}
-- 
2.36.1.476.g0c4daa206d-goog

