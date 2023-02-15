Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321C0697353
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjBOBRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjBOBRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:17:05 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0928232E47
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:40 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id o24-20020a05620a22d800b007389d2f57f3so10671208qki.21
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPrYycs38Jm3Sq3undZq9ttXoskj6Xab1yQZ0uAvcW8=;
        b=nT5UvRV+bdXTY47eDM312ZUnHfNlWrwBJx6pdwuGEIubphNFZSWnMXxcpXFhQpNXYh
         F8TnEG1zuWzDqzduwqwOrXyGlqCFCkM98iRpeBU1tcpHvFAk4+JIxRxdH+TKZmx8h/lO
         Bqm9+nSVsOmUHwl0qdzxKY2MrmCICC2ZmEOhcHWcESFpdcAQrCCKl3VAR52ACOxfx1Cl
         4HRdc0oHWA+SMUEa7WpQaDAh7TbB/N+cvqRF5mGV8aRafe2Xo6dzwFGqvQm1cPXymb1X
         hq3qSrSQJEV5pufNUG/jT2SMrTDNz0J9Fi6QrMD2x1izAiSkB53PtmoiGLWVTEPCWm/j
         mg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPrYycs38Jm3Sq3undZq9ttXoskj6Xab1yQZ0uAvcW8=;
        b=Ox6bSM/jb5yRyvdnrbYl1Rvl+1vDhyNP9pEcvmX1QNR01T+Dk00Zz+8gKWOO6WDVPW
         JoDDvjfUJifqfNm+nm9wa+mt2xUI1OouItnsOnyET19QhEHo3CiPJqLDTcIff0E0lGgH
         xXLF/FAHAn+h9aaxwWj+xcviruPD5P4PqgnvCDV5rCvp1+eQHFpeKd6+VJFsiCALiXVj
         s1hQIVHzCJbBPDQ1GTy2tOjKvjHzExryuMNsCWF5qcG1PNf5MTkduuQO+gbf6Bsqp9Lq
         LmQSIVD1jQ/69Wwh9cdi3AXF2PFPWuVlTDOIPSXAvqbO7rDwcN1MDsnudylprpvZEm6c
         4JWg==
X-Gm-Message-State: AO0yUKUi9VemD4yLaQ3IGHt9JR7tkHaSztmsX78eRD4TmWqqTd84zhrL
        0BA/kH/szFPimqQ/gPh/DEJYMqBI59RCCg==
X-Google-Smtp-Source: AK7set8OIyhmpWoTab6NgRcquwz3ebP9gVLRLX3gqnZH2lhB8uDvbbDq1XcJNQVsOeixNwKTxn++WoFJjfzvCQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:ac8:498d:0:b0:3b7:fda5:14ba with SMTP id
 f13-20020ac8498d000000b003b7fda514bamr9963qtq.12.1676423794603; Tue, 14 Feb
 2023 17:16:34 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:16:10 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-5-amoorthy@google.com>
Subject: [PATCH 4/8] kvm: Allow hva_pfn_fast to resolve read-only faults.
From:   Anish Moorthy <amoorthy@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
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

The upcoming mem_fault_nowait commits will make it so that, when the
relevant cap is enabled, hva_to_pfn will return after calling
hva_to_pfn_fast without ever attempting to pin memory via
hva_to_pfn_slow.

hva_to_pfn_fast currently just fails for read-only faults. However,
there doesn't seem to be a reason that we can't just try pinning the
page without FOLL_WRITE instead of immediately falling back to slow-GUP.
This commit implements that behavior.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331e..dae5f48151032 100644
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
@@ -2487,16 +2487,18 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 			    bool *writable, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
+	bool found_by_fast_gup =
+		get_user_page_fast_only(
+			addr,
+			/*
+			 * Fast pin a writable pfn only if it is a write fault request
+			 * or the caller allows to map a writable pfn for a read fault
+			 * request.
+			 */
+			(write_fault || writable) ? FOLL_WRITE : 0,
+			page);
 
-	/*
-	 * Fast pin a writable pfn only if it is a write fault request
-	 * or the caller allows to map a writable pfn for a read fault
-	 * request.
-	 */
-	if (!(write_fault || writable))
-		return false;
-
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (found_by_fast_gup) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
-- 
2.39.1.581.gbfd45094c4-goog

