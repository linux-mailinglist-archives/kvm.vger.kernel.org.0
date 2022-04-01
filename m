Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A174C4EE858
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbiDAGiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiDAGip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:38:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DF2190B49
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:51 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id bv2-20020a17090af18200b001c63c69a774so846380pjb.0
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4FXxXLJZLQEs++ONkysSkU83dsOxk/dTRI/0WYDJ8+o=;
        b=RA/ibjQbIQjR1lmfHqDORV7no8EtnU3osUeN4xQ1ZUnoqlRqOqgvjK5NGtrBnfvt1p
         a/eEFVUoOEVlBXA5InpwA1aNCl9qwhm8AIooMqcXR7iottezC6NwjTwpz/JNPwyBpjDz
         b6TT4zTOG31I9iPQqxfhPINrEk+7WLYwNeM0yYQ5b/1E6pWszelF4Aikq6UxBEWW0Uip
         F6eZdHAVN8AGyprizZD6uW38b8URzIJFsnW90Cruf7IiTC5lg9Osw3jpnlenLiShRORr
         dUH/4iKkCROza6IQpjZ+DE5OCFZ9RQ8lk9w6Q8I1mNC0a9W2VZMvasflYjNjpOpSEK8y
         oaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4FXxXLJZLQEs++ONkysSkU83dsOxk/dTRI/0WYDJ8+o=;
        b=CpfhBDyIHWS4u76tgbSHX9u7H+rSTT9BMTl5g5IOWBlOvmVVJLw1dL7lDd1YjFZpsM
         /hj1uZWK4QH4pU9Bve1AscZlpLa0W3U5whxlV1LvKLcymw0AEMszpeNl7dck/W5E1/kJ
         IYd6oMS9WoCn8CF7QZnee61hOJfs8/oMCPqRJKng1XP0Nccq3qEUNzN8Dw22H9dwYmSi
         WevRrA/4tfDfdcJrwK8cTpU3KNMZ0z87vLS1hI0ngOcf21kE7EsJAW6q2k9FYgsBd2DJ
         rz2ENBLPDWEt3D4YTdSPfNVnM28aHEddSbqEczEXrxsUBfQ6Ap79zNDx8CL3h5Kr1nYl
         x4dg==
X-Gm-Message-State: AOAM530ViqdaPyOAeHiGYt8yiu66HwqkgrduVj9r6kc3F6DdoP6Fp3JS
        qnwyJabj4GR2gOhrDRh+0Ot71x4OkZ2j
X-Google-Smtp-Source: ABdhPJxRZKW1kTO4N7PzjBjiTYtM5m2OPqUDst+Fqm/l7UQ+k1okKkthp4T79hWu30Kzi/4orYUFMKOyYFDl
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr332690pjn.0.1648795010348; Thu, 31 Mar
 2022 23:36:50 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  1 Apr 2022 06:36:35 +0000
In-Reply-To: <20220401063636.2414200-1-mizhang@google.com>
Message-Id: <20220401063636.2414200-6-mizhang@google.com>
Mime-Version: 1.0
References: <20220401063636.2414200-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 5/6] KVM: selftests: Test reading a single stat
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
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

From: Ben Gardon <bgardon@google.com>

Retrieve the value of a single stat by name in the binary stats test to
ensure the kvm_util library functions work.

CC: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/kvm_binary_stats_test.c     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c5f4a67772cb..09ee70c0df26 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,6 +401,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void dump_vm_stats(struct kvm_vm *vm);
+uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index afc4701ce8dd..97bde355f105 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -177,6 +177,9 @@ static void vm_stats_test(struct kvm_vm *vm)
 
 	/* Dump VM stats */
 	dump_vm_stats(vm);
+
+	/* Read a single stat. */
+	printf("remote_tlb_flush: %lu\n", vm_get_single_stat(vm, "remote_tlb_flush"));
 }
 
 static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4d21c3b46780..1d3493d7fd55 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2699,3 +2699,56 @@ void dump_vm_stats(struct kvm_vm *vm)
 	close(stats_fd);
 }
 
+static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
+			    uint64_t **data)
+{
+	struct kvm_stats_desc *stats_desc;
+	struct kvm_stats_header *header;
+	struct kvm_stats_desc *desc;
+	size_t size_desc;
+	int stats_fd;
+	int ret = -EINVAL;
+	int i;
+
+	*data = NULL;
+
+	stats_fd = vm_get_stats_fd(vm);
+
+	header = read_vm_stats_header(stats_fd);
+
+	stats_desc = read_vm_stats_desc(stats_fd, header);
+
+	size_desc = stats_desc_size(header);
+
+	/* Read kvm stats data one by one */
+	for (i = 0; i < header->num_desc; ++i) {
+		desc = (void *)stats_desc + (i * size_desc);
+
+		if (strcmp(desc->name, stat_name))
+			continue;
+
+		ret = read_stat_data(stats_fd, header, desc, data);
+	}
+
+	free(stats_desc);
+	free(header);
+
+	close(stats_fd);
+
+	return ret;
+}
+
+uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
+{
+	uint64_t *data;
+	uint64_t value;
+	int ret;
+
+	ret = vm_get_stat_data(vm, stat_name, &data);
+	TEST_ASSERT(ret == 1, "Stat %s expected to have 1 element, but has %d",
+		    stat_name, ret);
+	value = *data;
+	free(data);
+	return value;
+}
+
-- 
2.35.1.1094.g7c7d902a7c-goog

