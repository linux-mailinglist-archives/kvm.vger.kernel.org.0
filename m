Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79C76BA50D
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCOCSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCOCSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAAFE1B7
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:04 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-538116920c3so184361677b3.15
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bq+O9a1u8eXgxSzc7ecXz3Zf8cdQRV4ap6Xut1hzXhk=;
        b=U9+eY6410Erwi3Nr2kPWBuFJFUVXvrUqmUnx9+Q6T8QuHHFPL1HRx44Z38/eKvPTug
         yjuBTrwjJaJnOjFseVzyoWayTIW3uwUg5W42AelrjE/YO4QOWysu/HZZ15lhW3v987Li
         G8pc+LqVrlQJq+tvXHt/JbUCJLMi4Ig0G5HzwhhUB6zwGaDBsHT2gMaLEJQsfpv60q1C
         xnodbWBEueE6LFuxUAzSzj303iIvS8yPAMuDoZKIwVYVVBIh2q1bklguacbGENKaYFNo
         KKWanb4oYN0szxUUH0a6p8EuXGisuGyJrNPZhOT/nGfDqSoJh9zAElciS3Y8GqwizU1v
         6i2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bq+O9a1u8eXgxSzc7ecXz3Zf8cdQRV4ap6Xut1hzXhk=;
        b=UCtiomHaKAu9twHEPNtmi9/Xmhkf9JOsrCtLeQJnXgQ9jIH2Gdk0Js4R5e/mTR3asn
         oA47uOeZfHu6BgyH//jly5qcgvYz9woLl6TgkLKr16L4S408vWMVfYAU39qcntZL44Je
         kDfFGy9vmHM1Z687d+Wg0QNF0joJwY3Kn5X4ZN1U1nFDWDW1pb6Btqyehnp7pIYsXtJ8
         qN0vG1V/ITQx6HIZWvN9vZAfkwQywOPIUnJbp6E0Z2Hao1U0w3AYGWoElAGU+zPaZrpb
         l7QUv1fJnVXe2c8Fw9mKCiQCw0/ISLxee4xngh/45XHih1Zs6voFLUp0Hz4pEnTWfmJV
         lyhg==
X-Gm-Message-State: AO0yUKXq61tpDudR4cdJLuGO2kOXmuceBhcgSLekoDkVyHAkOup7uXI2
        SXBPs82PeRGZb2es7mIE3c4fcm2YwyiIKg==
X-Google-Smtp-Source: AK7set+IYIxxhg12Snl0iXDFeh1Y7UbmxuAQGbZWEkenjtcCdlqzvQsREZYkPhj+2e/Tx5RxaozB2lwCG3E5zw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:af1f:0:b0:536:4ad1:f71 with SMTP id
 n31-20020a81af1f000000b005364ad10f71mr25820691ywh.9.1678846683690; Tue, 14
 Mar 2023 19:18:03 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:27 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-4-amoorthy@google.com>
Subject: [WIP Patch v2 03/14] KVM: Allow hva_pfn_fast to resolve read-only faults.
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
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

hva_to_pfn_fast currently just fails for read-only faults, which is
unnecessary. Instead, try pinning the page without passing FOLL_WRITE.
This allows read-only faults to (potentially) be resolved without
falling back to slow GUP.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331e..e38ddda05b261 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2479,7 +2479,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2487,16 +2487,14 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 			    bool *writable, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
-
 	/*
 	 * Fast pin a writable pfn only if it is a write fault request
 	 * or the caller allows to map a writable pfn for a read fault
 	 * request.
 	 */
-	if (!(write_fault || writable))
-		return false;
+	unsigned int gup_flags = (write_fault || writable) ? FOLL_WRITE : 0;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (get_user_page_fast_only(addr, gup_flags, page)) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
-- 
2.40.0.rc1.284.g88254d51c5-goog

