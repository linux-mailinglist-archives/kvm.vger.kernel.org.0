Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25BE508E7F
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381140AbiDTRiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381127AbiDTRiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0925412AD3
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t3-20020a656083000000b0039cf337edd6so1361948pgu.18
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/lytJlVZ1asZQvqccJjy8nnnVMvt29QnZJwrlfaEIOo=;
        b=sEbAflrSLpDDn4tKeGnsCqqsull8tQvNHOdl/uizSD4lm6uwOJbZWDggSCIucVnffx
         7dHs2gsgDIIPIoXXrcKEZuly6+3NJpHYh+invAOzr+A2Ac1T/zsbRI7GOiq8rwoPgpMh
         8PU1GVTBmneZ70dAqO8M2k/qdOvZpRA1dD6MuECsXgABTwDLPjnGwNWmxB8NfARJT/2s
         3tC9QbMg6o/4vUF6upko50KlqML1M1ujKfwCHKnGCdBjtFRijaI2AiaW8uRaHhEBKvJ0
         a2SX9jeTZPdQKDaai8HtVCVlysI7givX29OhNyvL4oOK/39GLaf4OpW3evcNJkLDUvyv
         Dilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/lytJlVZ1asZQvqccJjy8nnnVMvt29QnZJwrlfaEIOo=;
        b=XoiaAfV/s4RX/rX0oD42deHQ3eody4dBRorr+oJc1EKZYp3BDwaRYdcBtLdoiLSr9m
         wqDmgmcL41AmW0fltWNAKf3y5Dl0r+pZyfxmV2YRPgfO2G7wqu91TLzqopEcHYTd5/0T
         AQjigpCu2qqzP7LPfJa0w18mXtGDyYQ5oB/s6qaOVMGtlHrIddkAYsL7W1Du3zHCvLfn
         AGgWgUdlOE8IisDOSwOoXrBBZgbdqhgKaJnV4CYogEGkgxLlxSHaOAvkxrXiTGTgUpmT
         47yWEfowhg/SjDBZa8RVeU7rEVR50JZW4Ubb4C3sWK8t2sbTel4IYnvvnwx09qPSB/xu
         zO5w==
X-Gm-Message-State: AOAM530aMdqWHzIEB4rh18cRqEh6YtDABslKQ+c1wqV2DhxydFDFUPoT
        Uk1xmr357lRRCtdxe9/qck3rIbDr3HxK
X-Google-Smtp-Source: ABdhPJwgyW+5qidvzRQitkcVQZlSueRHFJvOqKMxORsvHXFeVoDvfkO+zQTaOHosoaW2iz0YNtokqHhN6r9z
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a65:6b8e:0:b0:39d:6761:300f with SMTP id
 d14-20020a656b8e000000b0039d6761300fmr20839090pgw.42.1650476118477; Wed, 20
 Apr 2022 10:35:18 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:04 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-2-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 01/10] KVM: selftests: Remove dynamic memory allocation for
 stats header
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

There's no need to allocate dynamic memory for the stats header since
its size is known at compile time.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/kvm_binary_stats_test.c     | 58 +++++++++----------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 17f65d514915..dad34d8a41fe 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -26,56 +26,53 @@ static void stats_test(int stats_fd)
 	int i;
 	size_t size_desc;
 	size_t size_data = 0;
-	struct kvm_stats_header *header;
+	struct kvm_stats_header header;
 	char *id;
 	struct kvm_stats_desc *stats_desc;
 	u64 *stats_data;
 	struct kvm_stats_desc *pdesc;
 
 	/* Read kvm stats header */
-	header = malloc(sizeof(*header));
-	TEST_ASSERT(header, "Allocate memory for stats header");
-
-	ret = read(stats_fd, header, sizeof(*header));
-	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
-	size_desc = sizeof(*stats_desc) + header->name_size;
+	ret = read(stats_fd, &header, sizeof(header));
+	TEST_ASSERT(ret == sizeof(header), "Read stats header");
+	size_desc = sizeof(*stats_desc) + header.name_size;
 
 	/* Read kvm stats id string */
-	id = malloc(header->name_size);
+	id = malloc(header.name_size);
 	TEST_ASSERT(id, "Allocate memory for id string");
-	ret = read(stats_fd, id, header->name_size);
-	TEST_ASSERT(ret == header->name_size, "Read id string");
+	ret = read(stats_fd, id, header.name_size);
+	TEST_ASSERT(ret == header.name_size, "Read id string");
 
 	/* Check id string, that should start with "kvm" */
-	TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header->name_size,
+	TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header.name_size,
 				"Invalid KVM stats type, id: %s", id);
 
 	/* Sanity check for other fields in header */
-	if (header->num_desc == 0) {
+	if (header.num_desc == 0) {
 		printf("No KVM stats defined!");
 		return;
 	}
 	/* Check overlap */
-	TEST_ASSERT(header->desc_offset > 0 && header->data_offset > 0
-			&& header->desc_offset >= sizeof(*header)
-			&& header->data_offset >= sizeof(*header),
+	TEST_ASSERT(header.desc_offset > 0 && header.data_offset > 0
+			&& header.desc_offset >= sizeof(header)
+			&& header.data_offset >= sizeof(header),
 			"Invalid offset fields in header");
-	TEST_ASSERT(header->desc_offset > header->data_offset ||
-			(header->desc_offset + size_desc * header->num_desc <=
-							header->data_offset),
+	TEST_ASSERT(header.desc_offset > header.data_offset ||
+			(header.desc_offset + size_desc * header.num_desc <=
+							header.data_offset),
 			"Descriptor block is overlapped with data block");
 
 	/* Allocate memory for stats descriptors */
-	stats_desc = calloc(header->num_desc, size_desc);
+	stats_desc = calloc(header.num_desc, size_desc);
 	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
 	/* Read kvm stats descriptors */
 	ret = pread(stats_fd, stats_desc,
-			size_desc * header->num_desc, header->desc_offset);
-	TEST_ASSERT(ret == size_desc * header->num_desc,
+			size_desc * header.num_desc, header.desc_offset);
+	TEST_ASSERT(ret == size_desc * header.num_desc,
 			"Read KVM stats descriptors");
 
 	/* Sanity check for fields in descriptors */
-	for (i = 0; i < header->num_desc; ++i) {
+	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = (void *)stats_desc + i * size_desc;
 		/* Check type,unit,base boundaries */
 		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
@@ -104,7 +101,7 @@ static void stats_test(int stats_fd)
 			break;
 		}
 		/* Check name string */
-		TEST_ASSERT(strlen(pdesc->name) < header->name_size,
+		TEST_ASSERT(strlen(pdesc->name) < header.name_size,
 				"KVM stats name(%s) too long", pdesc->name);
 		/* Check size field, which should not be zero */
 		TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
@@ -124,14 +121,14 @@ static void stats_test(int stats_fd)
 		size_data += pdesc->size * sizeof(*stats_data);
 	}
 	/* Check overlap */
-	TEST_ASSERT(header->data_offset >= header->desc_offset
-		|| header->data_offset + size_data <= header->desc_offset,
+	TEST_ASSERT(header.data_offset >= header.desc_offset
+		|| header.data_offset + size_data <= header.desc_offset,
 		"Data block is overlapped with Descriptor block");
 	/* Check validity of all stats data size */
-	TEST_ASSERT(size_data >= header->num_desc * sizeof(*stats_data),
+	TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
 			"Data size is not correct");
 	/* Check stats offset */
-	for (i = 0; i < header->num_desc; ++i) {
+	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = (void *)stats_desc + i * size_desc;
 		TEST_ASSERT(pdesc->offset < size_data,
 			"Invalid offset (%u) for stats: %s",
@@ -142,15 +139,15 @@ static void stats_test(int stats_fd)
 	stats_data = malloc(size_data);
 	TEST_ASSERT(stats_data, "Allocate memory for stats data");
 	/* Read kvm stats data as a bulk */
-	ret = pread(stats_fd, stats_data, size_data, header->data_offset);
+	ret = pread(stats_fd, stats_data, size_data, header.data_offset);
 	TEST_ASSERT(ret == size_data, "Read KVM stats data");
 	/* Read kvm stats data one by one */
 	size_data = 0;
-	for (i = 0; i < header->num_desc; ++i) {
+	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = (void *)stats_desc + i * size_desc;
 		ret = pread(stats_fd, stats_data,
 				pdesc->size * sizeof(*stats_data),
-				header->data_offset + size_data);
+				header.data_offset + size_data);
 		TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
 				"Read data of KVM stats: %s", pdesc->name);
 		size_data += pdesc->size * sizeof(*stats_data);
@@ -159,7 +156,6 @@ static void stats_test(int stats_fd)
 	free(stats_data);
 	free(stats_desc);
 	free(id);
-	free(header);
 }
 
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

