Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3184E1E75
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 01:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343897AbiCUA2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 20:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343893AbiCUA2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 20:28:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CCADE910
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:26:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bj8-20020a056a02018800b0035ec8c16f0bso6625988pgb.11
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZnD2DMccysTRV29OOaip4kblVakt/ZXloOGMe9n4Sq8=;
        b=KDMyBdZmkNm9VQre/sHHd+UF3yLIF3XPElWKa82CiPy1b7hEVh9nyWahmPuLote377
         KSDkZZqhX/BR9824SpZY9nY/1qeWg5iLaIw79JX0wKagPNLtWpFCr9Xyk3iGC4svbs4H
         UMHBiMVexnJw3LuAwJeYPqtRSf7zqf3/bp32cAM0ZwjYjaqcZlFXOetCtOMQ9Z155UO4
         nSaquyHHmSm+3HvKXJaY3xsm5XvZrXrene3Lp2Cto/v5sdLMOYM3DChdG5UoUllKEM8y
         MjjUnMWOvBoAOzLet0kHzmhoBrr7ttSa26hRSaztdAmnHtnAYPTNFoOCHh3thtt3uRpu
         /3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZnD2DMccysTRV29OOaip4kblVakt/ZXloOGMe9n4Sq8=;
        b=CMInBkNdCIOW6/ECVIvwaIyNLx1J5RldZzjDGdCSAG029amQn91x2qKWs1HAZEe4er
         EDI579GK+211YwxXOq9Jp4fWCya8/5j6vyfkN9+DQQ0mrHzNNxaJFIIYW83J4ai6wyXC
         zx6WN5Rf0za0BeuLe+db4vicosYBaG0YU7dKXdy8PDfq4IUxWcZHIcxPSMYMRMnlQ5AL
         /0W6qYAgFVQArkrJB/ECf1fsiDmh0wRKUEU8eYVh26f5JFAu+DgN3shH5MCX6hI7qw+l
         6NESvn+ffWIIPtTD5KP2LExgknqgQBxoz03TM4Vnub8kLx2I6qkLq9AtN0DQtUxW3Vpx
         34SA==
X-Gm-Message-State: AOAM532zhP9z1QyUaZjub6wT3Kigi0n+pAe8XlykeIO+uoBfudUGuouL
        cKPPFS2rTgkBl5tGkQhLhOpafuGDrkb+
X-Google-Smtp-Source: ABdhPJxBa/87UWDZmU7EDsZl+WZSJ+96ppP55fnQay9zpPrkfeF9vKo9OqM19uQ4CNgZgV0Unu/Rdf89sZaW
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:1992:b0:4fa:7438:870a with SMTP
 id d18-20020a056a00199200b004fa7438870amr13100130pfl.48.1647822402113; Sun,
 20 Mar 2022 17:26:42 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 21 Mar 2022 00:26:35 +0000
In-Reply-To: <20220321002638.379672-1-mizhang@google.com>
Message-Id: <20220321002638.379672-2-mizhang@google.com>
Mime-Version: 1.0
References: <20220321002638.379672-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 1/4] selftests: KVM: Dump VM stats in binary stats test
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
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

From: Ben Gardon <bgardon@google.com>

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
index 4ed6aa049a91..160b9ad8474a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -392,6 +392,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
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
index d8cf851ab119..d9c660913403 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2517,3 +2517,146 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
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

