Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6127B68C407
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjBFQ7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjBFQ7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:59:07 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB55D29E33
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:59:06 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id j18-20020a170903029200b00198aa765a9dso6645478plr.6
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOpp/S8Rtelv3h2rWZJqIJdgZzud+NaCm9qMEIp1MnI=;
        b=sKfiuMTpfyXaq12seZrzSDjLQ086gfmqtdv4cF7ki165PqRcS4JuSmFzlwgwD8G5xk
         UmH8vLp6oybFNKOXyHV8rZBBZuWWr/XEbTmtMZk4fa4it2miA63L77htcx57jNOkjjjC
         fjVc3EiLaA6BzAWlOd5aGzYvA87cTEexWkjcATvLpehYjZ/4ng5onMRqBqjTPXRibHU8
         5d1hueXAYquDsbUKDj303ZwOwYZqTCZu5l/TS0/CdHSfNHiszcROETa7jQ3MTibzwOHM
         A9dz4+r0LX57xxL5TDp/i1AN5WGxB4UDieKQBexLxjfqzoEzPu6Hrg6Hd3iktEMwx/uT
         lBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iOpp/S8Rtelv3h2rWZJqIJdgZzud+NaCm9qMEIp1MnI=;
        b=5O2BfTz5SkeCuZn6uc9E4wWcJxWNpOjf6fq70/rrV2fFJBKBej3vCFjR+V83AiqvKM
         QeGQPQiC43mghoq6nGjLYpFh2j0JvYW0rC/L3aT/1s+aYJwXCAV+Ae1qNJQo8HxvhCGk
         6O1BG1tmSg/Gl2USZFvkaZoLFglwAQsuQRyQu5MUiamPbOuMASNxFWyJQ8GBz+rpB8dy
         xCxhzUddtICZ73Y3uVbQty4g5fJz4E12ijD51Rf3344dUgQlUjaVzFOtC5P6N7Z/NbeH
         dq6HNWrYMEoUIS1bVZHEAosGgRbVzF2wlQy96BAtZhZxehthplP2GnJdlV2LRnQXIo9h
         RbtQ==
X-Gm-Message-State: AO0yUKVyi+Fz30E23e9GkspJcUYviu6uCcmLQfzutUUAskHook+jjz+J
        BsJk6Yqq0Yzd6ptGQo1NSOC5fBoDDRUu2g==
X-Google-Smtp-Source: AK7set+9BMru5C7ajdZ/QFnYvf0vq6OsZXfNWB4URhHpoB1VV9dRbuBfGMCP/U4V0dUdFkxQcatVyOKOpOVTJQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a65:45c9:0:b0:477:31bc:348f with SMTP id
 m9-20020a6545c9000000b0047731bc348fmr3202793pgr.72.1675702746208; Mon, 06 Feb
 2023 08:59:06 -0800 (PST)
Date:   Mon,  6 Feb 2023 16:58:46 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-8-ricarkol@google.com>
Subject: [PATCH v2 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
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
2.39.1.519.gcb327c4b5f-goog

