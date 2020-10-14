Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486A228E646
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgJNS11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388816AbgJNS10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:26 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA755C0613D6
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:15 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id w16so84280qvj.14
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=VK4nUWuE6Urr4OKvNaeKhHJ/uqy3tmhC2rICDI8pQEM=;
        b=OAJeWAMCiUkqNclZIZf9eCtx/a5JmLB6dQP0x/vHoRZN6eRjepQJ5IfxrSSSNjYTYA
         Jd09oJC3odnZ1Wh+n+RhpcXhBpCP4xxAUic4bJ1G+4tdDUhnuSeoZ8NyFzBuLqLQS/Ab
         cVy7VO5/g+ilZj/s3i6HHMo5C5oVQ/84hldrGUDWYSUAL5hXcY7OeV8EAx6gw2UWROTP
         B9xz91Sl+QVxN4LD+FNBkILXAqN//pmeoXnuAnDnTXpHttILErUf2QFND92a8N4EnMjS
         1crQLtNcD5SWGdSYYSe9sP7W0i7AY5DMRQbiln5R8bEa4B4UfXBXQl+xM2389bVsuAM+
         Gk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VK4nUWuE6Urr4OKvNaeKhHJ/uqy3tmhC2rICDI8pQEM=;
        b=GtBp0tLdDbofxbS983HIoVyFNACiON3W1El5puVZUkn1IucKsh8aZWxEo4uhtkDC+h
         gn9m1tCiEJT26qlsiLYKLknwFxSV3sEXAbhLAreUZSiEMMHqS0+7kbhPVVaDcowXoeK8
         Unq02ZNgYdVA3njB9VQ5mUkCVUDzkvn3O/38GCsvD8pVfJ/oOYNygb2dmTULzOLB6oLt
         yAmQi3pJpJ/GE3RgWjfddQ/d80r2eJyAez9LfLV5UiF1dwJDEogOJbv3XaE+wNyxAk16
         8H2woa93ECaOAb0BHDevsMiKB6mKByYm7Lt+WXZE/3Ss3bET966Ye+MWOY0wBkXF0nTC
         X5zA==
X-Gm-Message-State: AOAM533oxMoEdsCq1yPUfIj0bYo/1ctKq0FzKwzWcz2yOJK+X+b17nB+
        L74e4VBS6rtiqbwIuJ8SguXnkeNOK0rw
X-Google-Smtp-Source: ABdhPJyDBH3cxsFvKx/KaPbcmYDwJ74J5KkBtAYRqy4tXdQWuOmgGQKly65dlFs0LkNo/wLpP2LAlGH+A4SU
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:ad4:5192:: with SMTP id
 b18mr641006qvp.14.1602700034772; Wed, 14 Oct 2020 11:27:14 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:46 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-7-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 06/20] KVM: Cache as_id in kvm_memory_slot
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Cache the address space ID just like the slot ID.  It will be used in
order to fill in the dirty ring entries.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 05e3c2fb3ef78..c6f45687ba89c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -346,6 +346,7 @@ struct kvm_memory_slot {
 	unsigned long userspace_addr;
 	u32 flags;
 	short id;
+	u16 as_id;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 68edd25dcb11f..2e85392131252 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1247,6 +1247,11 @@ static int kvm_delete_memslot(struct kvm *kvm,
 
 	memset(&new, 0, sizeof(new));
 	new.id = old->id;
+	/*
+	 * This is only for debugging purpose; it should never be referenced
+	 * for a removed memslot.
+	 */
+	new.as_id = as_id;
 
 	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
 	if (r)
@@ -1313,6 +1318,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
 
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	new.npages = mem->memory_size >> PAGE_SHIFT;
-- 
2.28.0.1011.ga647a8990f-goog

