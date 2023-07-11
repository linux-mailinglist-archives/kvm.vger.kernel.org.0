Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F12174FB9D
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 01:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjGKXBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 19:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjGKXBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 19:01:40 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C93F10D4
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:39 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8a7735231so64505745ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689116498; x=1691708498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UMgWqyV1osh/Eb0aP0u4bhUqRrnmL/HIe/0o+d3Tstg=;
        b=ZjSlV+P+WjR6ipP1RlWNPxFrwdcht0OxmLKa0QLn3xaLeCwtB9UDH/7OWOaXSa1z1+
         e2Xp3FRdI2MWx37ejpgHg8bgTtmoMYn4siDuMjw83SChlUw9YLK/9sO4njF70fv1cBBN
         0VDi+v5aqplRYzKmOv5koReQ1cr5yZJ/6qo31Jrb6tT3f3Q3npKiGZNGkE29jcxFW4iS
         Tv/jkowMfOnaNQdgZQCVAO6/XIDOIM/d2JLTw6PD01ywwtTBefmUWejntl+JNTuU0uXW
         19H67WBVIO5m3ryNK9unbbDJgSJcn40VHQ/GW1DoqjAjEfRv8j+KkQcj6nbnVMLcta6Y
         SgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689116498; x=1691708498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UMgWqyV1osh/Eb0aP0u4bhUqRrnmL/HIe/0o+d3Tstg=;
        b=GFTqRO5clfCjF1aX6LTOlU+jl33lmtNlheIyFA5wt+cnpwXL8fcpbqGXIUCV5CEJeb
         KpBLSlhP/2wFKknlNtt/pkXfpY5OSxh93AgxwemfGft9X5/xOKZ9uTzrc180yc/4bVLn
         tAfDyIm5bMCI/SMR5AQgF5VXq7Z5v2qUjiS7T5+xFFz4Jr6ByuT4cn82XfLJh94QS3m9
         wBUZ1TWcMFqVyG0cgvXxn2APJQljoARRV3XQVpeBZMEdz6AOg0TI3BsTw5256rGT8zCV
         g3L3/r++8gY0xKqJFYRjgHubxpr76vGuxpqNeHgq2fgBg1IasT0VuGWpgz7MIZaMkjYU
         zrKw==
X-Gm-Message-State: ABy/qLav9lJd31wjWUGVBzqU6KjtPmcBWtdeIr+4F/V8ciOZyECXJ+id
        LhgNM3A0OmX7j3JrDVoZZTkvztbveRw=
X-Google-Smtp-Source: APBJJlHIsJhSGesygyR2pvIXL2h+l2QVdYqlNq2kM9qsrLj2xYFk6PgbKKr53V9ZXQsNbOblHHioGHN/RSI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da92:b0:1b8:95a2:38ab with SMTP id
 j18-20020a170902da9200b001b895a238abmr13020184plx.8.1689116498492; Tue, 11
 Jul 2023 16:01:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 16:01:26 -0700
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230711230131.648752-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711230131.648752-3-seanjc@google.com>
Subject: [PATCH 2/7] KVM: selftests: Use pread() to read binary stats header
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use pread() with an explicit offset when reading the header and the header
name for a binary stats fd so that the common helper and the binary stats
test don't subtly rely on the file effectively being untouched, e.g. to
allow multiple reads of the header, name, etc.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 6 ++++--
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 07732a157ccd..eb1ff597bcca 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -362,8 +362,10 @@ static inline void read_stats_header(int stats_fd, struct kvm_stats_header *head
 {
 	ssize_t ret;
 
-	ret = read(stats_fd, header, sizeof(*header));
-	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
+	ret = pread(stats_fd, header, sizeof(*header), 0);
+	TEST_ASSERT(ret == sizeof(*header),
+		    "Failed to read '%lu' header bytes, ret = '%ld'",
+		    sizeof(*header), ret);
 }
 
 struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index a7001e29dc06..eae99d0e8377 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -43,8 +43,10 @@ static void stats_test(int stats_fd)
 	id = malloc(header.name_size);
 	TEST_ASSERT(id, "Allocate memory for id string");
 
-	ret = read(stats_fd, id, header.name_size);
-	TEST_ASSERT(ret == header.name_size, "Read id string");
+	ret = pread(stats_fd, id, header.name_size, sizeof(header));
+	TEST_ASSERT(ret == header.name_size,
+		    "Expected header size '%u', read '%lu' bytes",
+		    header.name_size, ret);
 
 	/* Check id string, that should start with "kvm" */
 	TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header.name_size,
-- 
2.41.0.255.g8b1d071c50-goog

