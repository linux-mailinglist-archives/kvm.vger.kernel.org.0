Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEAE4E58B3
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344112AbiCWSvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344051AbiCWSvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:51:00 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97C160A8D
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z9-20020a637e09000000b003836f42edfbso1087081pgc.22
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZvZ7NXHw7GzgGFsDiaZ7LRsy8v/D1TyF5VT8AtGFPGQ=;
        b=DePjTDEbt2mBZO6bE7QxHlJoCYjmip+Tcmpp5fXYjuKqOHHl8lmUfImaNga5rahcF5
         xuJirINC1eb3WRbNw3LHscTxBz9j6ruk47BtkQpLOZVRh7LGeyjES1/eMCKqhYX8tNl1
         QDUEbfO68/Ua3Ww1rGQw4wDKDUQFutiLqXYpO/CUG7dkHS0XhTWqChff5ETD37vFIFjB
         uf+0RYheQSH1lMCj4QIMhdu9+DIdzjdrEEHOGJh9K1KmEO5/1Tlq+xVRQ+HR0oOizO0v
         q2c6oAfx54KDKI3xbJRK6aqlllVbSejtYLtTEPaoTRyIHTCoGrJGDjtvQ/KejvdkmSee
         PiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZvZ7NXHw7GzgGFsDiaZ7LRsy8v/D1TyF5VT8AtGFPGQ=;
        b=qWB6Y+zfYSSHJZi2qHT7TJKNSnm1KDtn2nydESAo+W3Wlkm+WFfSHlshnkgbhOINhS
         gwiHvHuUCNd4Fnj62m5iny9pjSjPlJ6F07d38caL+zQQ2dwC7wLzkeCiau5e5ungjZ4q
         Sn0lvy6QzlOEg4ykv3Gg4jpNrU5nnHqjMqP0/oZspiNxvZ6zjHQoXrnPF9ULv2UV/FIX
         D6iuRUPYLC441gYIXfrJrYYzRR4rDw7eOmZOhYP1Ofl2ye+7spzYo5w40vUR04/1LTy8
         R58j+rzb0Uy5beYXF5XYAFjU7KNGNoawyj8NsIZOOdnlamMPXhiTSeili+hYHmKQXJtg
         UB1Q==
X-Gm-Message-State: AOAM5327dHEsA9nRl27eOduDhbvWNRBQAbCkiG63ZJpe1KJrenmD56Ql
        umVpRD8Zal0O8k33re+zJApGsRpq+jef
X-Google-Smtp-Source: ABdhPJyGv0uu1UznuwbbBIAbEyI3XHYc+M6XclgiUwlGGmq73ohYQxiTedK9gcBFElWoRgfQeW4Eb4SD5uFb
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:7f1c:0:b0:382:1fb5:58b8 with SMTP id
 a28-20020a637f1c000000b003821fb558b8mr947103pgd.507.1648061369343; Wed, 23
 Mar 2022 11:49:29 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 23 Mar 2022 18:49:13 +0000
In-Reply-To: <20220323184915.1335049-1-mizhang@google.com>
Message-Id: <20220323184915.1335049-4-mizhang@google.com>
Mime-Version: 1.0
References: <20220323184915.1335049-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2 2/4] selftests: KVM: Test reading a single stat
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
        Peter Xu <peterx@redhat.com>
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
index 160b9ad8474a..a07964c95941 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -393,6 +393,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
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
index d9c660913403..dad54f5d57e7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2660,3 +2660,56 @@ void dump_vm_stats(struct kvm_vm *vm)
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
2.35.1.1021.g381101b075-goog

