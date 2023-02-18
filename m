Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B6669B7EB
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 04:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBRDXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 22:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBRDX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 22:23:29 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13082C66D
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:28 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x25-20020aa793b9000000b005a8ad1228d4so1355815pff.10
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676690608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V+h39w+M5y7yM65vTe8AIma457bKn0boXmudJkmUO64=;
        b=OOGQDAozfJPxU4cPh+eNsnFORVxhBseQ4po+PMVYCaaHrMa27a9eZwz2HjcuIdNgVh
         slYOm4TsOONQCaqTOCU64Vyqjc6wA23716ZiGacc/GuZx9D+Ze+sZX3iXZOiGOJPfzWw
         DEoYq/LLYfSROStk+2ZwCOK08p6EUsCQQomIY0RjEmXUx1ogiu0aDnkPstrbqkFIAsIO
         MmTUzMho1a89tjVA6XSHJPzknQsAy9d3/oybmTkcrgybl1jryNlrmOncv1u6qAqxxR1C
         WAcxMZX5PvwwVrEDyVwVNABO4a3hoCllU8GjbsW9Wy5fF9tXx1SQaV4ccNARUsNP0pKc
         brWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676690608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V+h39w+M5y7yM65vTe8AIma457bKn0boXmudJkmUO64=;
        b=nAQj68cc5bv9oVjg21Q9nCCLp4Bkv4J2NCIguVSalMWB/oSSqyV8xduYaRysrgikP7
         Y+tAFg51vVIDd5xX/JKoumSh08TzD5loOnuHULdzi6maBooM0SkPx3lV7BXo01MvGKcA
         pRNdbadBrmYp9liXdxmwlINvRQIdQ6o9Bkl38GhNZBYk6ivFUyOio64QN2M8yqIU3cSa
         VCmHzVQqOJ5S8Wc7KJUkPcnGvzeTSLuI2cXKe5cyH52FxbM+o0AAU4SLxb2ZiGUprU04
         u3KmP/OjCJxTvliH5fatDDXZB6ewagWY19rIbSTH/M7u8Zfpfp+/RXpGdZV6jUOcZo3s
         I0zA==
X-Gm-Message-State: AO0yUKUIfH9Wd2y/AZmNoqtQHRxZIr6yC9Jm9hayhVJW7MfZEVZqv42v
        20rX2IrOMMb844jCB+dwiagki/RkPQC2vg==
X-Google-Smtp-Source: AK7set+NggMflM6BNmRBHhGqrUcGVQByOp77BaqX2/+UoO+KkK/O0C3um/TDX+sbYIPuNVsMZ/613iCYuJMYfA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7207:b0:19c:2b30:f22e with SMTP
 id ba7-20020a170902720700b0019c2b30f22emr354082plb.11.1676690608082; Fri, 17
 Feb 2023 19:23:28 -0800 (PST)
Date:   Sat, 18 Feb 2023 03:23:09 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-8-ricarkol@google.com>
Subject: [PATCH v4 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
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
2.39.2.637.g21b0678d19-goog

