Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36DC4D4F96
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbiCJQqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241095AbiCJQqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:46:49 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D57F15F099
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:48 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id o133-20020a25738b000000b0062872621d0eso4897409ybc.2
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3kP5r5OVryNKXjUYWSAGxldjSwy2u45gORSbNRbqjK4=;
        b=N7mCXve5ChV6kK9nsxwOshVGth/7qmbMf51kU6YkpgF8R6ESL8tJepyaXcmo6v9Kuk
         xAO0vPhVtigqvjdK4U6NnOi0n/wTieAJu1R5iAjI/zpHkK9IM52wZ6PniIepdhd0y4uK
         SXELfzw82lHJe9m9lgBdEL3wrl8pl5nw59x1Pp+loeSS4xtuBCj+BHZoy7BNEYCPdmq3
         Oz36xccn/KhThAZBe3+sPV435UdfCcRlXl5NckwOdDv2Oex/19bV2jcFe8UDWnwhVKLJ
         625IN7/2hdifRgVYO3JYn9tfHaG7Z9gn/S+TvgcAr4Hys/mb7oOZ8109dSk4J/qH8ZNN
         pXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3kP5r5OVryNKXjUYWSAGxldjSwy2u45gORSbNRbqjK4=;
        b=rQQInlvQs0VF36iV4TMJAo5ftTm/7RHHE5PU43hNNKzUToPx14+ZeG0mKmpUeAy1gQ
         kDF4qjK+Njzoq2CNZaO8m9cM1VieWSiSK93de2l3E7u7Ci1G+q5WgwIKfVn/IE85E4Tf
         AcnsSYcrthHqwR0qvTCgjVFUOzDs7+jk/wtkCD/8+sqFNzC9AQvF9MpvCjv219d7/R4u
         36yPS53KZVlAZoYk5U1fOzY/ywb/w+MO851SBaHBjoTjNEpyCqkHX4s5kdK9tMZqDu5K
         GVexP0k5uk8wKeMg6RsnQ1pH9OCBLmZhvwkWq9+iock+npShwGciIgYf3awlkLUmD1xH
         +Q1Q==
X-Gm-Message-State: AOAM531jeHOgRYP62YBs3n0GcYfydYnv8peY+AsS6ffypZ4gC8nubekU
        CrdsZUowdh1KABXdYJoQE7bpoFdsaUjN
X-Google-Smtp-Source: ABdhPJwSnKuuWl+kD5Vu+YPIM9Bgb0tOm35IFF8rcpCfnffcjOmy2dl1mrauLWzhsbaj88i3a4mOQ4rXncik
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a05:6902:533:b0:629:52d7:e4ae with SMTP id
 y19-20020a056902053300b0062952d7e4aemr4515236ybs.601.1646930747605; Thu, 10
 Mar 2022 08:45:47 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:20 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-2-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 01/13] selftests: KVM: Dump VM stats in binary stats test
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
index 92cef0ffb19e..c5f4a67772cb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -400,6 +400,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
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
index 1665a220abcb..4d21c3b46780 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2556,3 +2556,146 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
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
2.35.1.616.g0bdcbb4464-goog

