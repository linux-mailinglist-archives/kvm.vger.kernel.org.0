Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D47720754
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbjFBQUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbjFBQT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A35D3
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565d6824f2dso31904887b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722796; x=1688314796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BbIws3TVOQ+ga2kyHnOYUuU4ZoW+MEWkftwOYAYwIko=;
        b=LlVUGKyVTKSnyZBMTtGtTVFNYmhWxoozKLYiiqpPhrsXi6R1dgUdwUHOW51uXiGxxq
         IPPODOiBarv7foL2YIn1iTk9NOhUa/Vmksxw2KwTyXhffKGPpqbupXrzJlwn4GjFO5+5
         zKlpSEyY16Xg7ZBK7tFUvqSBrc71g6jFEqUf4x9XcPUGoh699nQiZLDPeAup6qIqL2Xk
         Pj6A/PIBXtrU15rmncPbIFqAzVGWXGvAwqtXQO/4F03a7fB4bHzrLQuEMfcVNcNVy/G7
         sF2VSxniYN7UnvLWnoKZMAsXhwXfnmkTCSym3IDXGLYw/qrcgx88OHqM2MffWgNqB5Wr
         esDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722796; x=1688314796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BbIws3TVOQ+ga2kyHnOYUuU4ZoW+MEWkftwOYAYwIko=;
        b=LRVbuEJnOGc9iE19uvexguJToNfeu2CZ94Onyl4DlqTAxmD+wp+wmdJVpi13UNBI/R
         33EXOCSUCRyVJKlRqkBs/iiMo4JbIBAapmVfuMJPkmGMKCTgnEJHy9W1QK9g1+yLuMeM
         /9KanaXfbrhI+f3xyE4LM27fkmSfy0xdHkcc/iwhnTydhhRXcOeYkeyjJXl+tZ4XNoAO
         /Bu4KSQxjMF3phsYVbJSyiIjIF0VPPedjrNhdpJixi0ywlwvdPDXBqEdbwx/of9JpGE2
         2YKq1LaODNN+v+1VuD4rhoMiQWMLFuTYIX32tbTw9LmYb43ul7s7FSc2b73WC/WbkDS8
         vJZw==
X-Gm-Message-State: AC+VfDycE52DzagC92KzLJoavr6MDIlpm9/mWgT7lEMoEDQjPGgRxLnV
        qLG8sFTXZo2l/gfz4/FnVFUGM1aEMQ37FA==
X-Google-Smtp-Source: ACHHUZ7YQ7d8v8jTjhqkGsOOSbttWu/vTfPGkpdYjmI5de7T/VwKGMoMRbh3XrT/5dCI1cf4Fr89Z6/LlBLL0w==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:af4c:0:b0:564:c5fd:6d98 with SMTP id
 x12-20020a81af4c000000b00564c5fd6d98mr174023ywj.10.1685722795889; Fri, 02 Jun
 2023 09:19:55 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:11 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-7-amoorthy@google.com>
Subject: [PATCH v4 06/16] KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
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

Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures within
kvm_vcpu_read_guest_page().

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ea27a8178f1a..b9d2606f9251 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2986,9 +2986,12 @@ static int next_segment(unsigned long len, int offset)
 
 /*
  * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ * If 'vcpu' is non-null, then may fill its run struct for a
+ * KVM_EXIT_MEMORY_FAULT on uaccess failure.
  */
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+static int __kvm_read_guest_page(struct kvm_memory_slot *slot,
+				 struct kvm_vcpu *vcpu,
+				 gfn_t gfn, void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -2997,8 +3000,12 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_from_user(data, (void __user *)addr + offset, len);
-	if (r)
+	if (r) {
+		if (vcpu)
+			kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset,
+						 len, 0);
 		return -EFAULT;
+	}
 	return 0;
 }
 
@@ -3007,7 +3014,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(slot, NULL, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3016,7 +3023,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(slot, vcpu, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

