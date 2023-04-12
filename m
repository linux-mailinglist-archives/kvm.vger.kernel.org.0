Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55A16E00F9
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDLVf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjDLVfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7A87A84
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v67-20020a254846000000b00b8189f73e94so36715058yba.12
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335317; x=1683927317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZP5BD9r0skQIBcVsEuwbsf0/jfPby4JFW+0o25mrlY=;
        b=DAuQvN09j6rlTcQ+SQvMQ+Srqk6zFEIzLM+R85LsZhahtQ9CqOj17Bl9EwDey3+OVk
         P61HT30gkple2nno/lQ6MMs2NiUU9yRsMw67CiJ06U4l7n5Y6XMTqmmU4enb4W3pHBmq
         nBmCLgs5DM0SwjG0Z4HWqplWgT+BrSEOhLpoMD5vE9qPZc9sZNjFbjyUlwuSOybbkUau
         /NL1HdHJ7Qj+Wnp9YdpsWuGUi7Qwd9lEr+7CEbZOMeleYsWX4yUNsC/N65vWzHpxrdJV
         Kg9I13GwIJsn6srNEau4xyl+XnBWmGtXj4V9QSu4M9kEdgzLrmgUSFyd/ElRA6N/5V6+
         oT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335317; x=1683927317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZP5BD9r0skQIBcVsEuwbsf0/jfPby4JFW+0o25mrlY=;
        b=TF1HaUv/pE3rAp+EyIgWIeR5X8OwDhYNVgIeqnRQ64bj5+riHR69uKv5BhipR0fgfu
         ZJDDO/Unrn/swjYfD+uEhOyYntyktvvfTtToqwTX+Q7zAE5aFMbfHOI0J/Uu9ZoVvD/b
         uxjz15ngcWnSCc+Ay0KdkJnB4IrIxoS72xWLVPtvSO+SC84wnJUWKvbrreZ7kV1MmzyH
         CuLT1qvVKaQGrQxrZxeo6880ihmN8bgkDMsmniPQaXhJA14VsmqhtIL9nr4QHJJG03Ux
         YmwOqIDgb0PPx+7ye8mOo2oQf8YC1ubjSwYfwaW6UdEUJDPg44wp33scw8qPO22hwtun
         7OqA==
X-Gm-Message-State: AAQBX9cmoqz0EX+CrZA3o18GP7+g1S4XNkb13YpqZprhlboxeOZKRlfh
        rHfosggU69MNaH1LugYoKTlAYak6fj53yA==
X-Google-Smtp-Source: AKy350ad5sOlGC49a3Zq+AqLstAbTPejBd4itxZk6c/jHU4q2Zhim4pjqaakFyBZUvWX5WivnmgBjuGC8os9Ig==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:d20c:0:b0:b6b:6a39:949c with SMTP id
 j12-20020a25d20c000000b00b6b6a39949cmr326ybg.6.1681335317547; Wed, 12 Apr
 2023 14:35:17 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:34:51 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-4-amoorthy@google.com>
Subject: [PATCH v3 03/22] KVM: Allow hva_pfn_fast() to resolve read-only faults.
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

hva_to_pfn_fast() currently just fails for read-only faults, which is
unnecessary. Instead, try pinning the page without passing FOLL_WRITE.
This allows read-only faults to (potentially) be resolved without
falling back to slow GUP.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f40b72eb0e7bf..cf7d3de6f3689 100644
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
@@ -2493,10 +2493,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
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
2.40.0.577.gac1e443424-goog

