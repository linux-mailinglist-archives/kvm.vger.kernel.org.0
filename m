Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBD799239
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbjIHWaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343824AbjIHWaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:30:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A1D1FCA
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7ba519f46bso2513378276.3
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212196; x=1694816996; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XIpmIJLaTkwi74h1riRreKSmTmxguF7fM+nkkiCilQs=;
        b=3G1irqN6yy8+yYpakOYkwabbZHIhUg6H59SaA3MLZVB614Agf7F5HICjkeQo8QU1Ha
         2lNq/5+XFPrD9jKTppLs3wQ78Nn/PYgC8U2poVAtv7f6U+epTMDGmQ4NfqBP34VEwg5w
         Fw74YK1FeC09SZL8Vsl0PYayqaYjbp/NCL/SmIa93lWKy0PJ8eCw55EkqdvjcfPemSXT
         BLdDvQh99uAQfKLhFdSXSkHIYdfPZBgrzUTPDC000ZomM1J9KBlvctyjjg3zAoFIfuPe
         y9XxZOK4YQ/e7Q7P85vBRSrBTQWP7CZsiZ/zd5m54/0gXwtnBbx2+/ULpUHEjFjkWmEN
         xrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212196; x=1694816996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIpmIJLaTkwi74h1riRreKSmTmxguF7fM+nkkiCilQs=;
        b=gR5MH+9eR1WsRHpgbCocPtdkVeY85/Mfr0q3VuKFpRN1S7rFqS4Y0gWUofHATG+lme
         A9XYDdI0UZisUqn9y07hfS3nvPn4CInvQRrRZIlDjomo+G7az4Kh7I56z3jHl3eaPkDt
         wuUIC9fFKSAMo7LnhaDaC/DxFvhxgdguXpLMx+9PyK5abl+hGiYCYoSSLji6R8344RBP
         VgUHEUzrzo5fQYEcEKL/koU9CS2DcQ2OlgZKMWjh2rHZrN93ASnG843oU/HPY2PwtAka
         3gBxlc4eq27kP3e1LElZLL/nzIUvUVg+1z134zOT2bwa7VIed7nUJXxCh1XrWGeq26Ej
         Owhw==
X-Gm-Message-State: AOJu0YyDVhh6sYZ3192/irLwbX5eWq7hnBX7NN4HRFqVZDlrc7NyASLL
        TbK6HbcXQhat+RhQg5pFM6n/ttx0L5qDgg==
X-Google-Smtp-Source: AGHT+IEe7UramIvSlKRs0rA75cYHBcDpS4lm5Q6muAmcukOws4HAJpGyE1NyjeXOcZg1PL2GEmXXUQtyP3Ilwg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:a2c8:0:b0:d77:984e:c770 with SMTP id
 c8-20020a25a2c8000000b00d77984ec770mr85787ybn.5.1694212196358; Fri, 08 Sep
 2023 15:29:56 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:55 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-9-amoorthy@google.com>
Subject: [PATCH v5 08/17] KVM: Allow hva_pfn_fast() to resolve read faults
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hva_to_pfn_fast() currently just fails for faults where establishing
writable mappings is forbidden, which is unnecessary. Instead, try
getting the page without passing FOLL_WRITE. This allows the
aforementioned faults to (potentially) be resolved without falling back
to slow GUP.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13aa2ed11d0d..a7e6320dd7f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2508,7 +2508,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2522,10 +2522,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
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
2.42.0.283.g2d96d420d3-goog

