Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6EA6E00FC
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDLVfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDLVfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:25 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92E37EC2
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f87e44598so46584897b3.5
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335321; x=1683927321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FCUsl1ZTxToHK35g7kMPjWEsQGVLI4o3jf0Ta0rdcNU=;
        b=GqYSDW8zsU2k4X6g1gBul0HwBunj4Kc5oYYOBMCg2HxZHahOe7VzzKcmgXGNk6Y76U
         ES2/HgE87JrE3Kj+DU1U7U7ZPB3OeWv2fQqzkndHu4nkh9tNJXo+8XA6i+dP16vd5jH6
         yhhp5Xlpg/1WXEt2TCimkolDf+lDpG00WZd+4Rf7ToYnySMIrDySxVaaJY8qsIpPh+Xc
         F6NoX4FGulsoWmc57IaSRd8SkJ6BOC/oz9X5iq9fyC4RhUl/E/ELD4HBRCVFBKSZpISJ
         5uLvNeMIJ+NcqD5ZUkiMlnPJ9ZP/M8N/9PrABFSOd2H7umgblTHbxO2YbtmUCYZAHR+e
         8T1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335321; x=1683927321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCUsl1ZTxToHK35g7kMPjWEsQGVLI4o3jf0Ta0rdcNU=;
        b=doHqMVYqHbCSo2xb7nDBvAIT+KOFdHNhhtKoqM6OAxnMlUoJjOASHyrXmtvEWisA6F
         E2FavM7xhbZxs2JP3PNjXsfCkaIgrfniOZmY/ePU1YbmmptJddarj/ihQD0E7P4tl/p+
         F1usu3qeL8W7n16tY86JppbDUMffTeLaRy7t8ZNHYt1N/o9Ft4l1jqoTobRkbTuSxxw+
         W9jwCDKHO8VL0qDITzxFaRKXMFeT4rraVEt2uVhbNkq+ICFoMQt6eexO2Ai6BGUFdk5R
         KF+OSZs2vQe0UiQtvXuVTplgXWP42feghA0IoPI3olC1kT8rRZR9g4GLSkRfXuxcwAIf
         xLpg==
X-Gm-Message-State: AAQBX9d5Yn72cLWbSj94Rl7lr+leVwnWgHt+tiLSNATXHRsF5BXQTxCi
        JaHX555MRzRTUFnznnjqUSymhFvU4B+yxg==
X-Google-Smtp-Source: AKy350YICLmkH8ieQ0EkmaBManzdBLGb7Tvuk3VBxUWumq1jgSxExJBdj4wohiY0LLASz9PuLStOSQz2vaCbWA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:d0f:b0:545:f3ed:d251 with SMTP
 id cn15-20020a05690c0d0f00b00545f3edd251mr3435849ywb.1.1681335321139; Wed, 12
 Apr 2023 14:35:21 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:34:55 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-8-amoorthy@google.com>
Subject: [PATCH v3 07/22] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
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

Implement KVM_CAP_MEMORY_FAULT_INFO for efaults from
kvm_vcpu_write_guest_page()

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 63b4285d858d1..b29a38af543f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3119,8 +3119,11 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	int ret = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 
-	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
+	if (ret == -EFAULT)
+		kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset, len);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
-- 
2.40.0.577.gac1e443424-goog

