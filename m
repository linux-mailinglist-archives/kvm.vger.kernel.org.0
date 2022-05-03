Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01006518C5F
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 20:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241426AbiECSer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 14:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241456AbiECSea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 14:34:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADD63F315
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 11:30:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s18-20020a17090aa11200b001d92f7609e8so7634910pjp.3
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 11:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F1YFA94P1++LikfS1g8U/kKLAsz7yw4a/MvxHPVvBOI=;
        b=LRHBMVUxHaAXjbu6bocKLBht9ff7SwaBfohWLxDr8xiB3shAvodzjiD31TjLPVffiT
         PfRUafOYAZNXw9UD6jS7CznHlLRSFfDnwPjhjF9cCwoLCV8TWiV7gBvYxAfP30z9egyy
         IC0uChw5HdzSJs/VUBoG/fyESxizHbHkSCfCJLZWVti1HDYzQD1oDE6rjlB9pfou1cys
         uykjtPh0b6vMwgepGrQhJUQT9K9XmeBRKkUXBy3UqXM7lj0OfSKErqoRy7WvwjAoNmPn
         YXczqIg2rIVt493Y5FYxC71tN2kjXk+Y2IbZKhjpLMwjp7mzN4Z/K3ARhC1vvqmAHXoU
         epMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F1YFA94P1++LikfS1g8U/kKLAsz7yw4a/MvxHPVvBOI=;
        b=XGAD30Tptvv0P+Ocn1px48QAajEAbO2VzYVwL9sdA0TpHEaoaezF5aqctcpAPSx4Od
         Uu3FdkQAH3F8lIE3bVBQpPi9MN9TRULx36o5DJSaJw8Pv1pnPpf1STbtlc4g3LNFZYMB
         lK2ZeR911NecX+04tiho4oU/kJWlkVS0cx1aXfqjeaph8mTHcF+MHmUclxya+nn3wn1t
         /Xgg4wGpKgbtjAyeWvnvs2pRdzg+aqz42RN+IPPPipa2EPzNluKyQXmu7QHNuvZT5cQY
         FNj+KAkRh8CmLzvVm8DmmAUAozeGbjFbvv+UW/RmMuDYPrIikQNU9saxJ0fCR6/G7QY3
         aTpA==
X-Gm-Message-State: AOAM533ZjnzmVoDVusnyBlXrQIizpbGRkcTAOf7k/vC3FXXzutwSFvYF
        JUSzConDcUGJrPXSTCWknOTrNEDhQoCe
X-Google-Smtp-Source: ABdhPJxb5sHYMrvzaFL/U4Z43+cSJQgwNTQaJ89YOGdvUtVxphK9ndXvdKQurfkNV32hZuqagK95Y6FoPWi1
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90b:245:b0:1dc:1597:20e with SMTP id
 fz5-20020a17090b024500b001dc1597020emr6089939pjb.151.1651602656813; Tue, 03
 May 2022 11:30:56 -0700 (PDT)
Date:   Tue,  3 May 2022 18:30:39 +0000
In-Reply-To: <20220503183045.978509-1-bgardon@google.com>
Message-Id: <20220503183045.978509-6-bgardon@google.com>
Mime-Version: 1.0
References: <20220503183045.978509-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 05/11] KVM: selftests: Read binary stat data in lib
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

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
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
index 12fa8cc88043..ea4ab64e5997 100644
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
+	ssize_t size = min_t(ssize_t, desc->size, max_elements);
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
2.36.0.464.gb9c8b46e94-goog

