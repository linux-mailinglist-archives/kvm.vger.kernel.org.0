Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856FB4FC656
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350025AbiDKVM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350014AbiDKVMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:12:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B6E18B0D
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:38 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z3-20020a170903018300b001585ef89813so1475573plg.21
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kJgMoCAjhZF08CgV3+jJ2ov9zdWBjUSyLPZfA15qjOk=;
        b=B1yK7n6ZfFUfK1bizsnRSAreeQmV+uitxPCS7NJyd6tleGrqGPsczFz4fmJWbnJT8i
         c9J395P0abuq+kKprK3PO0O6A7vhMQsPNcD9akSwJaJUMktxk/LN44khMc1bwMeJ4ZZI
         j6waqiifNBYXRR5UpjRk/nff2Az0lr4T/eqOoidoYzmnbpswmssa8p4FIWLmOo0LeUfi
         RwTMlnheEI30n2vRphdKBlzjdoK47/lwN1D5JLPCfXbw57klYnTkZ9EA7bKvNTo5a61u
         JaUSJEW9zldw4y+QNyCpt9cqiL0r97EmYULHjPeNkAWpVMlrwLkV9EVwDHRQuFvaBPMv
         jDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kJgMoCAjhZF08CgV3+jJ2ov9zdWBjUSyLPZfA15qjOk=;
        b=MZcvqtRIUTOIL/dhXT513r0+v27JqGe9PFePDA93aD98OJl2/+8xOh68guVRN8k0fe
         pf+mk05VkkcenkgQGXgPaN263S2Euy3vDJg2BJctBDaQkBFZv10mcr7uNQb4AfeBdACs
         biz9LM3QQZgLdE+2kokp20/8KMJ2BhxuKEykrGro08HxKpDsX8A/5YwpOZiUywC353AP
         f1OhCsxyuXectgyQPQqO3hntxeLwswF1BhGuIZchVBXbawuPQFaxmMYroWeSjAZI61Ex
         YvFB2sYyFCcQguqJeBUwj9U2tNGrmGt5cntSVpMN1je0cdKL/hXnywynlXRg3WWb+AX5
         JvxA==
X-Gm-Message-State: AOAM530EbhapYio6qK2hxbIl/44M4ucjKJxWDKofiL/x+c9uIz35JjnW
        tUOno2u49+bYW7POpapYVdr/QmXQnHve
X-Google-Smtp-Source: ABdhPJxRz84knoKx1GpcAy3ttUlScLwKOziY1SrT418kLk5rHFDxHG/9t9dbma3H8fJL3QXGxEkPuoDVYIsO
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a2d0:faec:7d8b:2e0b])
 (user=bgardon job=sendgmr) by 2002:a17:903:1251:b0:156:9d8e:1077 with SMTP id
 u17-20020a170903125100b001569d8e1077mr33659510plh.116.1649711438004; Mon, 11
 Apr 2022 14:10:38 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:10:06 -0700
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
Message-Id: <20220411211015.3091615-2-bgardon@google.com>
Mime-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 01/10] KVM: selftests: Remove dynamic memory allocation for
 stats header
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no need to allocate dynamic memory for the stats header since
its size is known at compile time.

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
2.35.1.1178.g4f1659d476-goog

