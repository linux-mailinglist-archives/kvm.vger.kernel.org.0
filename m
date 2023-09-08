Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33469799232
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343716AbjIHW34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbjIHW3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:29:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19582B4
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7e7e70fa52so2520797276.0
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212190; x=1694816990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0BHnhPQjohMasi1FkwP4rKpLhtBzedfsHeNgZmOOQA=;
        b=7SoUNBBdrKisDRsgsN/pg9o1OKNOM54odJ0TLHSllEsXjHJQ1uNcRMXdG/0o+p3SJD
         aS4MlKjyk7+T09lcpbkwVxcGGltJkIOpG1LllpXC0/j5+GYk24NCf6eYB2TcpDRYaur1
         MXtmXKB8IpvOiTdehQguzxYdcoJjy3vit96FPc6ZZ/bS6fOBuwzwtabx3PSP6KBNhmot
         ACDQjdD9JrHajmeRgR75BYXB98Wfk9fMx4nz0sbV1SKr880IYWDF/T2L0gVvjAjrwhe0
         LKjseP4ny1lcdNdKvzNdJKXEIYAnnM4Du8Spo8cbAQuqq/4ixT2BVAjQb1vm4oQBze1o
         kpUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212190; x=1694816990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0BHnhPQjohMasi1FkwP4rKpLhtBzedfsHeNgZmOOQA=;
        b=Nk0/vbi6jUaJGmNR/CG5kLT7h+lYBnw8Zh79rO0f7buH23iQgvnaFTN90RwQ8jOBZ5
         ZHNkXiWQiT432+/Ddv+u478jjSPfUPnDH0rY0oMk6CHd2zaXUFrb25zdFs57fY0FrKAx
         HEIXiEmjCi4b7Z8V5ogKCb1cBjAgQ9LAh/F/qxQ+sMk1UAaoeT33D1MQhLYSfoNcYuRm
         Zkoyim01soGDjUtL3SY5mkDUo34PS/Rm3XAmg6EiGEzGZhN1bQNxUGA4/DSoreqdmr5x
         FyeCuXVqsJV/gmrjLAXu95Bb9goaxUFsA6ErKTs2//rtZZ9iCv9VuLKdvxMwiMW2EigM
         lQQA==
X-Gm-Message-State: AOJu0YxjhgQrx5sOjFu4eyoEiq1QL5+Ziu3vz4PgC0Zobrz97xpAF6+T
        Bhc+f6WzpEZnasJi9Qz+g2LyhthXeyqaQg==
X-Google-Smtp-Source: AGHT+IGp3U+3huHXNrxPmxtY8xOiIHumjFDWxT6bJyVrVGJlTBuqH0tDk2yalvdlbk+Mgf/zY5+CmxE2i9YNdA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:a8b:b0:d12:d6e4:a08f with SMTP
 id cd11-20020a0569020a8b00b00d12d6e4a08fmr72162ybb.6.1694212190325; Fri, 08
 Sep 2023 15:29:50 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:49 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-3-amoorthy@google.com>
Subject: [PATCH v5 02/17] KVM: Add docstrings to __kvm_read/write_guest_page()
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

The (gfn, data, offset, len) order of parameters is a little strange,
since "offset" actually applies to "gfn" rather than to "data". Add
docstrings to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84e90ed3a134..12837416ce8a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3014,6 +3014,9 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/*
+ * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3115,6 +3118,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/*
+ * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.42.0.283.g2d96d420d3-goog

