Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4497B5EFCBF
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 20:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiI2SMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 14:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiI2SMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 14:12:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0981F44E9
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y65-20020a25c844000000b006bb773548d5so1785537ybf.5
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=3AvudpWWP8E1u5vk+zIaGFx/CkuEhsPoMtC12WcbCT0=;
        b=FX1cs1fXaycaF5z7bF+lr3EEyHSBZWeuZalxdHQLqSGwx/aJjl917ug6ZGsiXxt0cR
         LGIIFThkbWQnp/G9v7XX9TLF/Pq72sMrFOpArsR7xLBmpK5PVkOW+JriGQ+SDh8dK7cH
         o5wY2GH4z9uWxS25OF8cxMuJ3t+NF9LVj2n2zC1OUmK1sXNUIe5laocGzS/kMWdTe/9f
         LdMCOWvI7gaTaJ+1zYLJN0Wv3kjH2j5L6yBxZL6l/51LAN4yFfyYfoClB7bysHdka/zY
         xanItoeT11sKFEEf8NA5Ys0zh7JD92dIEICixiK+zjS2hiOhU+vNAdgW9ePHcONOK31V
         vG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=3AvudpWWP8E1u5vk+zIaGFx/CkuEhsPoMtC12WcbCT0=;
        b=Thh9d1HoBZbBMvfzbUR5YcuWFczbdfMmcRy6ciFeNhhqqrhMSNoCMjow2J78o8GfY2
         0utZYJFsQyAkvdXpkpMfRo++WR38pOEw8u7SgAVLB6FaHBG6Kfh1E/xn13g/lEvmgAme
         NlIFYxyqlctPHvTPOa58QGT8dVymrq0ImfxxDPJJoVGKXJDDLyQ5EaVJp8keIb0sT2OX
         yZ1ZIYmA8yj3VTIEXXgHRZEt+ekC4Za5AyHyaH/rorb+lK8Hh4raxDnC8yMeLMagi3fR
         jlSorJK3D2bvQQiJu8eYHchrcFpGRejCxkVGHZqxsC2Kzdx1TtyIMV0xRN0D7EY0mjFL
         eZnw==
X-Gm-Message-State: ACrzQf0NthNAmBQCq+X6wx/ZKcp8B3yQsde/5CExtFL8RBmlcb7b7QYO
        T10kyrIfMGmQjgVAMJ5uLl6014sSA0HvsQ==
X-Google-Smtp-Source: AMsMyM6X7UeBhfKYz8pt95A0pTIjBOD/cB6xgYfIhxhJpevbccaMwVa6Swu3y/vaHpbZQSs7+7RszMTbQkXbQg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:150d:b0:6bc:6e50:d0d8 with SMTP
 id q13-20020a056902150d00b006bc6e50d0d8mr4613626ybu.416.1664475134658; Thu,
 29 Sep 2022 11:12:14 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:12:05 -0700
In-Reply-To: <20220929181207.2281449-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220929181207.2281449-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929181207.2281449-2-dmatlack@google.com>
Subject: [PATCH v3 1/3] KVM: selftests: Tell the compiler that code after
 TEST_FAIL() is unreachable
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add __builtin_unreachable() to TEST_FAIL() so that the compiler knows
that any code after a TEST_FAIL() is unreachable.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 5c5a88180b6c..befc754ce9b3 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -63,8 +63,10 @@ void test_assert(bool exp, const char *exp_str,
 		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
 } while (0)
 
-#define TEST_FAIL(fmt, ...) \
-	TEST_ASSERT(false, fmt, ##__VA_ARGS__)
+#define TEST_FAIL(fmt, ...) do { \
+	TEST_ASSERT(false, fmt, ##__VA_ARGS__); \
+	__builtin_unreachable(); \
+} while (0)
 
 size_t parse_size(const char *size);
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

