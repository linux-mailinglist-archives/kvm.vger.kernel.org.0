Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FCB4FC658
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350030AbiDKVM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350015AbiDKVMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:12:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C37715822
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l3-20020a170903244300b001570540beb6so5012260pls.16
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6WTud4t2/o0hsvjWQOQfdmuf5Jf6mvrUa1JIGUzDHLI=;
        b=VHuO5hifqls6sBiOFF5trRISTudPJeSwLA69oUCU92UK7hmXgQ3INRQpOKeXurszhH
         EDVKKYo5KOuKzaHnVJfH22q6tXxy+3wf3b+YDD40dAt1q2vuG18/51poqqXCto931V/n
         gP7pZY6UPTcqwOeqUPzi+IQAZne0jzBjhUbZE+qNGzBkT/TuS7m1NMlSZ/ruGj/aWvXQ
         Fly45ZuxfYEGtm15GgL0luQMUfYss1s3Bao9xsB5D/Wkb9pgR4C++cy6sRx6dlbfZFij
         AuOL6YT/sCdXkE9G/r3cSEpeSB3fJ3ayZ5QUgjExwRLjnlYd+SlX/ddQ6sktXzv8zTtg
         EPPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6WTud4t2/o0hsvjWQOQfdmuf5Jf6mvrUa1JIGUzDHLI=;
        b=rFGOPH+RetQ2M+MwvWjzjw5RBaLR1saKbXLiOLsH5YjyroM6iIjXAq8P2wqeXUZtrg
         Xud+kyl1PEfKz9wzWz7TQC/ZcKoo5Q8vufyTq9NrG4BxeehUsYMNEza6sZz8PB6t6NHP
         +xR6sJGFNLKzAP5W31B4OkMYYxHXzdh+rW0AJ2y2IJHTZtEkhxK+A0ULWcQBggKzcHLM
         wYPGPQWrSH2vmQFeoD9hvxHLoMNQzvADuc8lMCzj1Z2OdI7+FdZyuZ9lJXJ8h5pzSLU7
         IvpdYbXLDnmrGIcTNsBQPuO7fb87Yuw1rqfZCOG0T+V+4P+DglLQE2Nm3iWvidOZVB5h
         1qlg==
X-Gm-Message-State: AOAM530IBduvg5PPVeLI/tPmJj7Rf4PwSBbT5P0JpLR6e7phGhxtBMLW
        V1smtZaKbws8ZP58cXRjn6ELPkgDoskE
X-Google-Smtp-Source: ABdhPJzijb1tEhtGCiz626QqQz2oBsdS4t++17JOsaPUm80osckqSdyQGNl8CQiPE3Gl+j2KfvnOxc2Gz00D
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a2d0:faec:7d8b:2e0b])
 (user=bgardon job=sendgmr) by 2002:a17:903:2488:b0:156:1e8d:a82 with SMTP id
 p8-20020a170903248800b001561e8d0a82mr34228889plw.51.1649711439874; Mon, 11
 Apr 2022 14:10:39 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:10:07 -0700
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
Message-Id: <20220411211015.3091615-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 02/10] KVM: selftests: Read binary stats header in lib
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
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 ++++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 92cef0ffb19e..5ba3132f3110 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -400,6 +400,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
+void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index dad34d8a41fe..22c22a90f15a 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -33,8 +33,8 @@ static void stats_test(int stats_fd)
 	struct kvm_stats_desc *pdesc;
 
 	/* Read kvm stats header */
-	ret = read(stats_fd, &header, sizeof(header));
-	TEST_ASSERT(ret == sizeof(header), "Read stats header");
+	read_vm_stats_header(stats_fd, &header);
+
 	size_desc = sizeof(*stats_desc) + header.name_size;
 
 	/* Read kvm stats id string */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..0caf28e324ed 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2556,3 +2556,11 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
 	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
 }
+
+void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header)
+{
+	ssize_t ret;
+
+	ret = read(stats_fd, header, sizeof(*header));
+	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
+}
-- 
2.35.1.1178.g4f1659d476-goog

