Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F71518C5C
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 20:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbiECSe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 14:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbiECSe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 14:34:27 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809771EACB
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 11:30:52 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 15-20020aa7920f000000b0050cf449957fso9833408pfo.9
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 11:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZlzC2bfcuGT4kbRVJ38+TB0qj+KtuXSymHV+fLhrqvw=;
        b=UNVc0C+eq6p83NWSllrNv5vO03WvpL18Ik3qfB7ruLNFwQwMaEJ7qiP+UQSUliQEHD
         /PJbDZ2K7y0ewOQnSfElgAi1UW+ZUKv1uIGszPfnGnNGF88dKsO+x0GQiovhA2qNCxh/
         E59XRfRAAKtt6wXhFVgTFSDW8u7JBcT7w9Tycxlp73UKrVAIaNPVkH5Drz0bLR7QuAw+
         8585xvagTNnO58b4HSSyt7VaVRsftRAKSj0wOaarjX7xJxn3SPE0DHaD2FSbEMXxYWOd
         i+SIr1gkIH+fH4gIW4vscRog7xH7cvmiMqAw/5sA+OIIEdOkt2Jk7HOkVx8SSs+Yv0NW
         Jc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZlzC2bfcuGT4kbRVJ38+TB0qj+KtuXSymHV+fLhrqvw=;
        b=dAe/DDXklNbA3XGhj360Ch3qhASQqUvPAsK+deLe05X8yVPx46KzU92eY/HJCfyOn/
         eolV1Kn9Ltap3ruGTO+T7iQyBRTh7YHjI6IZWrF7dje0DYxxP8lNlqS6rh67RQGZXqdc
         TAO+d0xJa5m+BAPPaUY9sCAbjggCD0PO89FsKgdKIQ4LEeZJi2rZWi0l5VmRNdbAJhIG
         WtR/2/Tnu09ln4sHADtMboLzki4AtZ1c6TPUMHZPZSlcFWXMf1DK2rpH14K05xs00vqo
         MnY959lN7PB0jjiiq1e8GNu49UtjZgnubUMeX6MFdWxTD2G8Pl0d5XmLF9i4JUOjASt2
         D+DQ==
X-Gm-Message-State: AOAM5320QmlTPPp76J0HI9BtejbmuvdAYnk+/h9LdVuQASBj4xArzrmM
        KDEXs+Vf8Bn5gOe1x32AtMqxxx6b7OUr
X-Google-Smtp-Source: ABdhPJw65eq8HHy3awj9KFCl7Lo1isD3it+/ihQmFligXTbVgbokMql8ff24EbJ+Pn0P6xQorDV+TVbhf55l
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1991:b0:50e:697:53f9 with SMTP id
 d17-20020a056a00199100b0050e069753f9mr6097951pfl.22.1651602651975; Tue, 03
 May 2022 11:30:51 -0700 (PDT)
Date:   Tue,  3 May 2022 18:30:36 +0000
In-Reply-To: <20220503183045.978509-1-bgardon@google.com>
Message-Id: <20220503183045.978509-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220503183045.978509-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 02/11] KVM: selftests: Read binary stats header in lib
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
2.36.0.464.gb9c8b46e94-goog

