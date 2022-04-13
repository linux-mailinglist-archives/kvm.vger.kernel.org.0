Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FF54FFD4F
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbiDMSCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiDMSCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479A13EB96
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p187-20020a6229c4000000b004fb57adf76fso1742615pfp.2
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qmx8EsRrZbSQNFkjDz/mX7u6vKF72QcXgkibsLvEgdA=;
        b=nmgQIt8HDpFZHnZ2oPMbra7J/K4/W71WPYEYyeS9mh5TjtHyShK2YeCBkC6W1Otzxr
         Ctw+/9VvksAVw8ge5jYnkdStPnpK0MrCb1XqqPJO8Ytv23VUAclvZVCW0bYNgsaVZgMA
         JGyLExmZ+P40TRdtd3HNQNGM/ZeKFjwHbgZBTYItKOJlE7vdLmknJKf+x/sIjpFKxpil
         mjkcwycQj5zTRjLi0oCWpwvunMjgjzxPh3xPu1Wraby0ZiS5Oh5KWZlIzcgBXUqHft3x
         pyYSyvO9HVwOG1zOIMWkBLG5wz2vmavUaxp7FYbtSThCvtuMviX32nXluiS24yDwu4ss
         adug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qmx8EsRrZbSQNFkjDz/mX7u6vKF72QcXgkibsLvEgdA=;
        b=UmVYuo4r4ID5AumYHHD7L73g5fAXxAoev1L1mYZMRHl+7oZIzxaqn5MkE8Pb90TSNK
         SOnld+53LPM3IR6O5P/3aMTwwgk79iXGP6X1BN/HI6xf9fFrCVkKtIP0kT7ii5ESlRwV
         288Z9hDkCsnMjLfjLKrxcuojSSYmRgqWUsqf/Cg0pEswFsYsfqxkMP+jLcO312Sgq5+B
         o3PTE6az7Ps7pywvS/4i5BpKRZ026hQvZU4HLfgJIEcE0VZo88+wxV7I3X2mniG+5A74
         Qn/CIKot5DW0zPA4HYj/D2xjiA/Xszs9+kNdvAYhAgPg9uPppX3IeLkCB5ZesxVWM1ES
         1aiA==
X-Gm-Message-State: AOAM532zZV7aR+1QD+n669PsFm2vn2l/Kd0SPaTPvmICxYXIys5PtacX
        whPSnNRgIZOrSgYxcREuod9fN3sKK9SG
X-Google-Smtp-Source: ABdhPJxW4HDO9a7kQpk2ZBV4ljZgFCpWEuHwGotU1wRE4n+U4XpQJIlPZgmdYCir/GPQLu47qXd2QJLyb087
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1a06:b0:4fc:d6c5:f3d7 with SMTP
 id g6-20020a056a001a0600b004fcd6c5f3d7mr44462916pfv.53.1649872790687; Wed, 13
 Apr 2022 10:59:50 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:36 -0700
In-Reply-To: <20220413175944.71705-1-bgardon@google.com>
Message-Id: <20220413175944.71705-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220413175944.71705-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 02/10] KVM: selftests: Read binary stats header in lib
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
2.35.1.1178.g4f1659d476-goog

