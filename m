Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC12698266
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjBORlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBORlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:41:05 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980023A87D
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:41:02 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-52eb75aeecdso219994857b3.13
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F7pmS0etoscsJWB31SNQ0h7rXLmwCbZI5n0ahNK1Zxc=;
        b=BkglgUo7hgFH0voA/pzzH9dAyhjXKOyLokdbDXnZmmat37ke58uDWgCy8VW/Wy/cqy
         t5SY2VP4f5nQPltPGAlXM4o+C9zUoX1UhOZgOqaERs/Q0guYOZXHIoeTF8XGmYXj5KBh
         U6HPOEubmicYwXVNYIznD+IE7BBCfQA0Nl7IERklHdSwdTdOWs1B/TkQZbt6RYCy3IuT
         nO/SQvThH02fcyD16UxXoMDjq6Y22JXC3ju9/MXG6+9jKwplhwaOYpTWOB4E5AZv1Ru9
         fFF7uKdlPzEdvaXp67uB3P1YvgacBYjJUK2aTjAgO8NOzQLvoGnDtc4I6eaQ7yf7FDqG
         qnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F7pmS0etoscsJWB31SNQ0h7rXLmwCbZI5n0ahNK1Zxc=;
        b=0w9jFfbFA5oAI3gVQvV1qowGPvZFf4817nO+Pjr/NRPk9uO7MCYxNyydOnmuzUqI06
         0SPagZA90Bm9a4qXFb9ztO2CvpMBg42wDJ8sQPwu5CMl9/7UzwLccYLc8S/cOS2SGqtv
         apba8OLjcpy5dDVbSxTj3PYWYKBLGv8T0LsdPp1Wmg7bGAPYC4kZOWV9kdWsnuHqG04X
         OaUZrVETThzqf4vY4pp/NX/XXIVkfyYc6NM5XhgUdGPVTa8MuRoXjStBSL1XgGFvyKVp
         a54ZjPfCgMQrzOVJRaTjPewVQkLMwpHYSqqeC5USzKK1oYcgHx2/SLHrJaOR/Xoy1MZ0
         hqdg==
X-Gm-Message-State: AO0yUKUPkVjrSR5BrhIQP/cjwGFmRjJ4MoVENpmOZdCnZlzQJecuZL5r
        esY/a0SrHZC/V7lwFqP4IEKE+5jh16ZonA==
X-Google-Smtp-Source: AK7set+Jy7z2qk9y2xPyd0hgX9cF2Rs6bN8+J369ziuNiWMAFJ8XPlPOKXYBYze5fVC1+rVVIeLv/76M+F4NKg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:7903:0:b0:855:d2c4:2119 with SMTP id
 u3-20020a257903000000b00855d2c42119mr366476ybc.107.1676482861684; Wed, 15 Feb
 2023 09:41:01 -0800 (PST)
Date:   Wed, 15 Feb 2023 17:40:41 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-8-ricarkol@google.com>
Subject: [PATCH v3 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
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

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..8c5530e03a78 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -991,6 +991,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..3940d2467e1b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4604,7 +4604,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
-- 
2.39.1.637.g21b0678d19-goog

