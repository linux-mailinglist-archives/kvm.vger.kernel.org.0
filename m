Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D12720751
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbjFBQUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbjFBQTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0E01B9
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb2202e0108so1028161276.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722790; x=1688314790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3S/+6B4sIASEmcbAiWUGrwdrzyn3Ij/qOhyq0MCeDZU=;
        b=3KnMQGCxKmRUQNx9/GCrwoNNuCixk06ds3u4KEOi/wBb8zEVX3zs6I0WB6qefr8Uf5
         keKzQ3SMN7tF8SdmDp8m00jbXVEefJ3rH5J+M4XOhW0yOoV7HQc/h92GGhi429v90ErS
         mt/+ADOIuj/xd+F6GJBmFzwVDCJkIE629FPeaWgIE89Kua6KyLMNJaTLzoqo5hTPnZrj
         VFEW2lzLBYg8ECwvbQdeD16HEpbsKBAjS8AJeP1FrB75mTCkg5OHvWo9ALaPvZ3337fw
         70XglXByk8/ZytgCMJCKNNWPjViqg+pQgBKViEpsXkrw2MroTlNnh2nCzS+nlH0BmF7C
         HMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722790; x=1688314790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3S/+6B4sIASEmcbAiWUGrwdrzyn3Ij/qOhyq0MCeDZU=;
        b=iw+2C2SWhOhmDPT6xwbVaVmjuvmbvsENY3PSw1oNZHjCA2idVZe2vUHsCCcWlxHB4M
         hRgmW+VG04fEvEfMWNYdB1afKM9CiF9j6al2BWTSe5KFAcYdTAgp7CgG2r+6BKbdLB9v
         lATGh1PYCUPn1i/e8L41FqUA3ipCcYbcc/laxBYH0KcU+TE861QtFX3WBSofp4rDHA01
         hH210cnYns2q+vpTVM0m9wnPJZC1wHrcIGfzXwqp+0wndW82tPhI8tJDjeNdRcbm0d3P
         Ng85ctT9WwGkrVVM3TiuAQl835IGmAIbdj+I7H7tm9GQaQBN3fhKi/DmALoTCjtDUYWW
         GJxQ==
X-Gm-Message-State: AC+VfDyR+FsikCAOJkW8Ef5niLSp0MvXluzpqaB9OH13JDDK2BjcQI56
        DZq/vkuBx0H/7/sC7yeaLOkLvONuOqrzNQ==
X-Google-Smtp-Source: ACHHUZ7LmOAw8I6mCP70UYYxUu8dl4OdoZ+FYLa9vbMmwQKQEEjk5cDjm8BJnNrFHtRHYk8QXcsObPSpVZMJEw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:adc6:0:b0:b8f:6b84:33cb with SMTP id
 d6-20020a25adc6000000b00b8f6b8433cbmr1333210ybe.11.1685722789992; Fri, 02 Jun
 2023 09:19:49 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:06 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-2-amoorthy@google.com>
Subject: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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
index cb5c13eee193..fd80a560378c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2482,7 +2482,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2496,10 +2496,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
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
2.41.0.rc0.172.g3f132b7071-goog

