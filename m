Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6464A4E34F7
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 00:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiCUXun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCUXuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:50:40 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC1F195323
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:48:58 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 77-20020a621450000000b004fa8868a49eso3937551pfu.3
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=D0DwgEYL9FDtap/ma2duhrafHKDI2k2H7Kdd1DgpGcA=;
        b=lj0TKTl03MICUUzJ93f3Ojew9olRP8p1BnY2sOeXVZvCD3HdKCY2N2c/GtmUUS4x6Y
         tKRfNV/MyL9hhjjAX36tJK/CBufA5OeqOWcw2LL3BaO1XCj7ugzVz1rgpNOxZmBKowQT
         OYeDbEcb2Soy4afqkwYFKJRAlATr3us1x7c+FO7L1JAZRsB/KfFdD2syHI8ks9u16wW7
         0noRD+Rezs5xWBJkbs+rDmmP3104i3w+/cnf9n9CREvHlelrYrx9ufjyTyjbFf7o8gSB
         b4gVNme3LazD8qNoLaR714YqALarCheIKm/7DilxLtR+wHUq8hXhjLCaq2JC0nYBLxvx
         qWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D0DwgEYL9FDtap/ma2duhrafHKDI2k2H7Kdd1DgpGcA=;
        b=Ffm32aexVO0btU5JaVyiFh6GDionGZwbdnSEwyPo8DajBr9Kd0qMiz8NJRLBkIaBk4
         FjjCeq9eVFHscyJ/TYGwP61q55WHL6ogkOKdQSRV2LOeCIV+nxUYYAFHWltemWKzMKoB
         T9JzhkbPFgyadjh5DxGO7Du3Q3AoQEgGBClg3qvvsvQxkjvEyJlZBRab7bAH+5AqS9S0
         fnif9mQARMsUHyNp/PQRMkWls9aIVSNdf2siHyGph0sOwAJKZQYsk0ZsURE8/4Ov2Zyn
         U9C1p7Q+MveOP2xqqSW96riArL2PZyWnTds0eb0I/25OkMUjF6QuMwdupl57JNGLa33M
         Nd/w==
X-Gm-Message-State: AOAM532gXVqMGIr0Heq34ARq3pcTIdnmGCm+il7pZHIQbG7wktZWeLQf
        hDEahgliOHsSRZeiyHCR55gdTOq4WSXL
X-Google-Smtp-Source: ABdhPJxOe3b7ZZZO66aRyp7/6tF1PvbhvsmjAkilL5QfShvGV05olSOCMbfdC19YAO8HiqtMrSj5Ncy3i1Dh
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a62:1ad3:0:b0:4fa:686f:9938 with SMTP id
 a202-20020a621ad3000000b004fa686f9938mr21701293pfa.6.1647906536223; Mon, 21
 Mar 2022 16:48:56 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:35 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 02/11] KVM: selftests: Dump VM stats in binary stats test
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

Add kvm_util library functions to read KVM stats through the binary
stats interface and then dump them to stdout when running the binary
stats test. Subsequent commits will extend the kvm_util code and use it
to make assertions in a test for NX hugepages.

CC: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 .../selftests/kvm/kvm_binary_stats_test.c     |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 143 ++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 976aaaba8769..4783fd1cd4cf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,6 +401,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
+void dump_vm_stats(struct kvm_vm *vm);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 17f65d514915..afc4701ce8dd 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -174,6 +174,9 @@ static void vm_stats_test(struct kvm_vm *vm)
 	stats_test(stats_fd);
 	close(stats_fd);
 	TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
+
+	/* Dump VM stats */
+	dump_vm_stats(vm);
 }
 
 static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 11a692cf4570..f87df68b150d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2562,3 +2562,146 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
 	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
 }
+
+/* Caller is responsible for freeing the returned kvm_stats_header. */
+static struct kvm_stats_header *read_vm_stats_header(int stats_fd)
+{
+	struct kvm_stats_header *header;
+	ssize_t ret;
+
+	/* Read kvm stats header */
+	header = malloc(sizeof(*header));
+	TEST_ASSERT(header, "Allocate memory for stats header");
+
+	ret = read(stats_fd, header, sizeof(*header));
+	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
+
+	return header;
+}
+
+static void dump_header(int stats_fd, struct kvm_stats_header *header)
+{
+	ssize_t ret;
+	char *id;
+
+	printf("flags: %u\n", header->flags);
+	printf("name size: %u\n", header->name_size);
+	printf("num_desc: %u\n", header->num_desc);
+	printf("id_offset: %u\n", header->id_offset);
+	printf("desc_offset: %u\n", header->desc_offset);
+	printf("data_offset: %u\n", header->data_offset);
+
+	/* Read kvm stats id string */
+	id = malloc(header->name_size);
+	TEST_ASSERT(id, "Allocate memory for id string");
+	ret = pread(stats_fd, id, header->name_size, header->id_offset);
+	TEST_ASSERT(ret == header->name_size, "Read id string");
+
+	printf("id: %s\n", id);
+
+	free(id);
+}
+
+static ssize_t stats_desc_size(struct kvm_stats_header *header)
+{
+	return sizeof(struct kvm_stats_desc) + header->name_size;
+}
+
+/* Caller is responsible for freeing the returned kvm_stats_desc. */
+static struct kvm_stats_desc *read_vm_stats_desc(int stats_fd,
+						 struct kvm_stats_header *header)
+{
+	struct kvm_stats_desc *stats_desc;
+	size_t size_desc;
+	ssize_t ret;
+
+	size_desc = header->num_desc * stats_desc_size(header);
+
+	/* Allocate memory for stats descriptors */
+	stats_desc = malloc(size_desc);
+	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
+
+	/* Read kvm stats descriptors */
+	ret = pread(stats_fd, stats_desc, size_desc, header->desc_offset);
+	TEST_ASSERT(ret == size_desc, "Read KVM stats descriptors");
+
+	return stats_desc;
+}
+
+/* Caller is responsible for freeing the memory *data. */
+static int read_stat_data(int stats_fd, struct kvm_stats_header *header,
+			  struct kvm_stats_desc *desc, uint64_t **data)
+{
+	u64 *stats_data;
+	ssize_t ret;
+
+	stats_data = malloc(desc->size * sizeof(*stats_data));
+
+	ret = pread(stats_fd, stats_data, desc->size * sizeof(*stats_data),
+		    header->data_offset + desc->offset);
+
+	/* ret is in bytes. */
+	ret = ret / sizeof(*stats_data);
+
+	TEST_ASSERT(ret == desc->size,
+		    "Read data of KVM stats: %s", desc->name);
+
+	*data = stats_data;
+
+	return ret;
+}
+
+static void dump_stat(int stats_fd, struct kvm_stats_header *header,
+		      struct kvm_stats_desc *desc)
+{
+	u64 *stats_data;
+	ssize_t ret;
+	int i;
+
+	printf("\tflags: %u\n", desc->flags);
+	printf("\texponent: %u\n", desc->exponent);
+	printf("\tsize: %u\n", desc->size);
+	printf("\toffset: %u\n", desc->offset);
+	printf("\tbucket_size: %u\n", desc->bucket_size);
+	printf("\tname: %s\n", (char *)&desc->name);
+
+	ret = read_stat_data(stats_fd, header, desc, &stats_data);
+
+	printf("\tdata: %lu", *stats_data);
+	for (i = 1; i < ret; i++)
+		printf(", %lu", *(stats_data + i));
+	printf("\n\n");
+
+	free(stats_data);
+}
+
+void dump_vm_stats(struct kvm_vm *vm)
+{
+	struct kvm_stats_desc *stats_desc;
+	struct kvm_stats_header *header;
+	struct kvm_stats_desc *desc;
+	size_t size_desc;
+	int stats_fd;
+	int i;
+
+	stats_fd = vm_get_stats_fd(vm);
+
+	header = read_vm_stats_header(stats_fd);
+	dump_header(stats_fd, header);
+
+	stats_desc = read_vm_stats_desc(stats_fd, header);
+
+	size_desc = stats_desc_size(header);
+
+	/* Read kvm stats data one by one */
+	for (i = 0; i < header->num_desc; ++i) {
+		desc = (void *)stats_desc + (i * size_desc);
+		dump_stat(stats_fd, header, desc);
+	}
+
+	free(stats_desc);
+	free(header);
+
+	close(stats_fd);
+}
+
-- 
2.35.1.894.gb6a874cedc-goog

