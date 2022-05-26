Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A65F5352F0
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348375AbiEZRyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242732AbiEZRyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2846BA503A
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f8398e99dcso19031377b3.9
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xlflu8xJTWgeN8YYc673kTXZztT28OEQGqYXKcMTcZc=;
        b=UKc8S/QfO2KDNs4t5BrShZINGyYVzp7r9KvjjtdzWWAdC8pfJTlwPuw6Bpqnm8998m
         tsahLj+YqaCb461oohfhNAXEHu3k9HQo1iVNV0ghFHY5DaY0cH1FyFBvtANXc54G0j4O
         fG1a1WtOcaBYDWPW0kRpUMyny91kP8jGDoFYVIiFStx8qthi83IWngLLojYh1a+VPbhq
         qJM93XFxr6VNs6qyF7HHFtdz5LKVXwd4OmcXE8bDJn80t7xVyqe9/y9uH0uaklqag9Zv
         pb/KMxY19NLDBzhEkNAyKOoDS1B04+CQ0FTjVg5AWUHqq64QDcJMxNygoJTcmR2uvtvP
         9xVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xlflu8xJTWgeN8YYc673kTXZztT28OEQGqYXKcMTcZc=;
        b=klwR/iZicQ314ChYDV0UnbdBEZstAvMU97SDaFYntn4NxfBC+K8RWjteftD5DtA/sw
         W3H/Jm/2HZaCZQ4POjPQpLhFtkWdV+C3CdX1grsG8Ghuss8RxpARPXz/q+64ZQoqdotB
         JK3fJI3M4+vibP04JQeCoQBJFZ6OgxgFGsO/x5k24F1mKwN/gutawPqZQ6/nvAVBGrZX
         OFtvLNSkxWle4II181OEjUAQlxlSi2hMEakTrEjyIwGlblF4udvRtRparNFoZgWogTdy
         C3MI/pr/TEtm3cq07svTN1adL3HK01Hvr9koTJussv8xV/kChkoI4jS1yY/wX4DHPD0c
         83yQ==
X-Gm-Message-State: AOAM530I68BIziUVCq9CNlBAn+bfUvPyuKmHweC6dJ9pKm6/+N9vQzYF
        ix4JWYJTEfhylPZwyyGM2r761iB43jzxeS3qkvSFyZsbq4Xb5n+P3Nu2Sr9rfhZH26rzu1B9D4J
        04dxqgj8OF5QdKRn7m0AxzYp0DkGGped4p3cJKoViJAuljLncVoekMq60zObX
X-Google-Smtp-Source: ABdhPJytBXiMeMyCo4WITinfBE+6stYgPM7eUOkHFwe5wzCn73c979Va1eZ3fDUY8ZULh3f5jFEQNZAntyzj
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a25:f45:0:b0:64f:8489:910f with SMTP id
 66-20020a250f45000000b0064f8489910fmr26370755ybp.602.1653587655158; Thu, 26
 May 2022 10:54:15 -0700 (PDT)
Date:   Thu, 26 May 2022 17:53:59 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 02/11] KVM: selftests: Read binary stats header in lib
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

Move the code to read the binary stats header to the KVM selftests
library. It will be re-used by other tests to check KVM behavior.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/kvm_binary_stats_test.c     |  4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 92cef0ffb19e..749cded9b157 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -400,6 +400,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
+void read_stats_header(int stats_fd, struct kvm_stats_header *header);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index dad34d8a41fe..fb511b42a03e 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -33,8 +33,8 @@ static void stats_test(int stats_fd)
 	struct kvm_stats_desc *pdesc;
 
 	/* Read kvm stats header */
-	ret = read(stats_fd, &header, sizeof(header));
-	TEST_ASSERT(ret == sizeof(header), "Read stats header");
+	read_stats_header(stats_fd, &header);
+
 	size_desc = sizeof(*stats_desc) + header.name_size;
 
 	/* Read kvm stats id string */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..1d75d41f92dc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2556,3 +2556,24 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
 	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
 }
+
+/*
+ * Read binary stats header
+ *
+ * Input Args:
+ *   stats_fd - the file descriptor for the binary stats file from which to read
+ *
+ * Output Args:
+ *   header - a binary stats metadata header to be filled with data
+ *
+ * Return: void
+ *
+ * Read a header for the binary stats interface.
+ */
+void read_stats_header(int stats_fd, struct kvm_stats_header *header)
+{
+	ssize_t ret;
+
+	ret = read(stats_fd, header, sizeof(*header));
+	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
+}
-- 
2.36.1.124.g0e6072fb45-goog

