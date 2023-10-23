Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2D7D4003
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjJWTPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 15:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjJWTPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 15:15:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02123A1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:39 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a824ef7a83so49388607b3.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698088539; x=1698693339; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Fgbudwquptx3kxGF2Rx/jDbv8sQ1FkhX6MwfxQpq3LQ=;
        b=Jyt0/uLO9cpaOM5TuA8al91OF2xAYoGUDUZDSSBAyxeu7pjDhEfZnxhMpOE9L6GRHH
         CT0V4Ikd/IkpVXszW5k0EzyNFWcerRFEoYsPISXXs3YqSExFIpI7P9PvEZSl8tPc9DS6
         hafeTTJncrdo8HYY3zmxQh4FRJnmEmD4GPgb40Yaib4dTp92X3T8swvhQt3HAUCP+X+J
         iqM0zRn+oTmkG/U1yYtpGL/TJ9aLZGKlPFjRw+fPBU6JzImK/F3UpfBws7UAAuqzBSwq
         5I4rb5UGOGIuUiATt8fkyZNtQsi223GV9uXhZiV28dlMEY2P3oHklcRoyrDGWbec3rw0
         WfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698088539; x=1698693339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fgbudwquptx3kxGF2Rx/jDbv8sQ1FkhX6MwfxQpq3LQ=;
        b=BE/joxIxf2dHVPBENOudHpzL7CalU2hmdOytEMBdrVeXT81EKVUp/K4ZQK0KmyTnbn
         IV+RI0RG/bHmayKpO56M0JN3f9FTh+ADHcdczExtr4cfd3k2aO7CB2aoLpNQybP/aFwV
         kJu0rBpIatl58a7GBpffw3UD1YspJtW9V244DNBrCPZICzu901bY5RC+P9u8oC1OEly3
         DKv/eNsHPGCw6dsknAS6EbH0DuZGFb2c7N0k0w9nFtXzf+cPpkv8m/MtX2ShttTxNLmW
         xPGQvp+5Tih1p0QBiz8nX2JXyyXtjBSXfs/j1+D86kxOa/e8g+I28bNnPIy5b0YGsQho
         bTew==
X-Gm-Message-State: AOJu0Ywql+zbQvsbenKEu11e3/bQf4stiMx0FhLgbL+lL/xw3jZZbVeL
        aqvdilZL/VgqKxuKN5K9EURetMmnPDs=
X-Google-Smtp-Source: AGHT+IEudh7lv+vB3jmTBdAfnrXmjFNTxJ/CNAhB5midYZMIoFDKf8WDrbcSjw2PyODeBffCvgZo3fQJbXA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:db43:0:b0:5a7:ccf3:3f28 with SMTP id
 d64-20020a0ddb43000000b005a7ccf33f28mr200781ywe.0.1698088539262; Mon, 23 Oct
 2023 12:15:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 12:15:29 -0700
In-Reply-To: <20231023191532.2405326-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023191532.2405326-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023191532.2405326-3-seanjc@google.com>
Subject: [PATCH gmem 2/5] KVM: selftests: Handle memslot splits in private mem
 conversions test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the SYNC_{SHARED,PRIVATE} handling in the private memory conversion
test to play nice with ranges that are covered by multiple memslots.  This
will allow letting the user specify the number of memslots, and more
importantly allow testing KVM_SET_MEMORY_ATTRIBUTES calls that also split
across memslots.

Opportunistically update the error messages to clarify whether the assert
fired in the guest vs. host.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/private_mem_conversions_test.c | 44 +++++++++++--------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index c04e7d61a585..c3992a295b5a 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -28,25 +28,25 @@
 #define PER_CPU_DATA_SIZE	((uint64_t)(SZ_2M + PAGE_SIZE))
 
 /* Horrific macro so that the line info is captured accurately :-( */
-#define memcmp_g(gpa, pattern,  size)							\
-do {											\
-	uint8_t *mem = (uint8_t *)gpa;							\
-	size_t i;									\
-											\
-	for (i = 0; i < size; i++)							\
-		__GUEST_ASSERT(mem[i] == pattern,					\
-			       "Expected 0x%x at offset %lu (gpa 0x%llx), got 0x%x",	\
-			       pattern, i, gpa + i, mem[i]);				\
+#define memcmp_g(gpa, pattern,  size)								\
+do {												\
+	uint8_t *mem = (uint8_t *)gpa;								\
+	size_t i;										\
+												\
+	for (i = 0; i < size; i++)								\
+		__GUEST_ASSERT(mem[i] == pattern,						\
+			       "Guest expected 0x%x at offset %lu (gpa 0x%llx), got 0x%x",	\
+			       pattern, i, gpa + i, mem[i]);					\
 } while (0)
 
-static void memcmp_h(uint8_t *mem, uint8_t pattern, size_t size)
+static void memcmp_h(uint8_t *mem, uint64_t gpa, uint8_t pattern, size_t size)
 {
 	size_t i;
 
 	for (i = 0; i < size; i++)
 		TEST_ASSERT(mem[i] == pattern,
-			    "Expected 0x%x at offset %lu, got 0x%x",
-			    pattern, i, mem[i]);
+			    "Host expected 0x%x at gpa 0x%lx, got 0x%x",
+			    pattern, gpa + i, mem[i]);
 }
 
 /*
@@ -335,19 +335,25 @@ static void *__test_mem_conversions(void *__vcpu)
 		case UCALL_ABORT:
 			REPORT_GUEST_ASSERT(uc);
 		case UCALL_SYNC: {
-			uint8_t *hva = addr_gpa2hva(vm, uc.args[1]);
-			uint64_t size = uc.args[2];
+			uint64_t gpa  = uc.args[1];
+			size_t size = uc.args[2];
+			size_t i;
 
 			TEST_ASSERT(uc.args[0] == SYNC_SHARED ||
 				    uc.args[0] == SYNC_PRIVATE,
 				    "Unknown sync command '%ld'", uc.args[0]);
 
-			/* In all cases, the host should observe the shared data. */
-			memcmp_h(hva, uc.args[3], size);
+			for (i = 0; i < size; i += vm->page_size) {
+				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
+				uint8_t *hva = addr_gpa2hva(vm, gpa + i);
 
-			/* For shared, write the new pattern to guest memory. */
-			if (uc.args[0] == SYNC_SHARED)
-				memset(hva, uc.args[4], size);
+				/* In all cases, the host should observe the shared data. */
+				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+
+				/* For shared, write the new pattern to guest memory. */
+				if (uc.args[0] == SYNC_SHARED)
+					memset(hva, uc.args[4], nr_bytes);
+			}
 			break;
 		}
 		case UCALL_DONE:
-- 
2.42.0.758.gaed0368e0e-goog

