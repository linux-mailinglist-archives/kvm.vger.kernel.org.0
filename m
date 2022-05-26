Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049C25352E6
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348348AbiEZRyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiEZRyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:15 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E43A0D25
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:14 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i9-20020a632209000000b003facc62e253so1132774pgi.11
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9wfIV9ktdtuy1sicWR+vMg0zPdgp8Sw4DeDOVy/L0Xg=;
        b=Cg2crwEdced9xr0sM9fAF9uCE6L9kxXQ1mBZfPsygwupWi1/Ykuua/+KmvwcAQ9FKt
         3reJkQvmwAkXBdoojDTnY4U2cAydb30wE7MvWOXOLDzf7LjbgNrNTTPfM7kFSYd+S9mo
         4VgABdhyN41ymfgFbFDD0q3AI3N5Jl123r0zdwUhWv4n47NR8aKznVO6OzJ0JF1stTCe
         9knB2NYxrz0EmWtnm9R/ch1eWybZGgIQz5dY7h0lPRgGQ/nxOS2vO+yQb/SjcZvGR714
         8MsG9s2M/n3hFPHLKju0epIGcu4FCNE3/zRMQ+ecNqEqnHAxeomcXZBlAxzvwsy3KQAi
         4H5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9wfIV9ktdtuy1sicWR+vMg0zPdgp8Sw4DeDOVy/L0Xg=;
        b=4f4GfNTKVFFI/tWo/GOgAb5/lavaT1qlI9C0aB75kXT+OqHnRwvdv1baVf4ZXCMmuA
         5HcMv0NEdIUO/eBMxkC24Ct3d2BQiKPNlCGZcpB6nVtnRTXH53IUWNjpJB3Ewq52hMIs
         kbwjhDCf7TVYW/sOM3iSZrz1+SEHan2lHJ5M6FlC1K5kOgk3aPvTDrkkVNyI6d2j98Sj
         BIvrv9yaxqYgNoHT0z9kJKwiTpqGSQSxvS7uEiG3k7+IyTzqmo0ntE0fzmb1kXVIn2z1
         9N8F+4qcLwMmVmQZFPlvPpgCOrVcPCm8o62xEsbIpBz3nP9+mRL3p4zec4N2m8+u/2Ts
         Y7Zw==
X-Gm-Message-State: AOAM532heNsnf4cwRCtAVsi2PF7xnuymhftniyPTxn5ZfqVgDh/SIeC0
        TM8NhN2k9WJ+2BBLeqlFoOv8NrrzQ60UB2t/mz0GBmDmrJpn7IJRtFzvYqRVQP+14uwJOSpDePo
        KSHipjvAKWtWXs6bXEg64WxrmyV3TBn4P+k6vIkeMXZxxo2/HVa1HflWbd9zd
X-Google-Smtp-Source: ABdhPJwPEUSDh9zmbiYVgnxInr7tNS6kaDSzP6NbCxilAhFD4Oe5zcxZDSHVsw2MoKvzG4i4StEp2OJ3c/uZ
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90b:4a51:b0:1df:7617:bcfb with SMTP id
 lb17-20020a17090b4a5100b001df7617bcfbmr3806835pjb.207.1653587653576; Thu, 26
 May 2022 10:54:13 -0700 (PDT)
Date:   Thu, 26 May 2022 17:53:58 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-2-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 01/11] KVM: selftests: Remove dynamic memory allocation for
 stats header
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

There's no need to allocate dynamic memory for the stats header since
its size is known at compile time.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
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
2.36.1.124.g0e6072fb45-goog

