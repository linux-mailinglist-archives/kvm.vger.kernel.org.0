Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA17375A4F
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbhEFSoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbhEFSn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:43:59 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39239C061761
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:43:00 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l5-20020a0ce0850000b02901c37c281207so4843824qvk.11
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O0n4OZEsHYcsD2VSr2bO/0IhfkveI/qdk1WzUKQRQFQ=;
        b=vFvBjOncg7aGdK7ZU3LRmt/7t3P8qKHD9RrHXpR7ksCarWtGJ5CoVNsZ3frJsz8zcE
         d+kD9605lOQD5m3JuliJXQ+DS6c8bTD4yRrrc+qvzedtPSYxHMgukU1t2NYZeLegfbDG
         u6gd6rV6z49+HuFFlf5U0l3sfgeEANJngIim1etpwROcdpRmka65K/Y0IDCQ2ePDryGU
         bTGnbnOWRyhozHOUegzpbf3bj+fDFDbTZyBcZBUgNLOcr5j4/OjiQwnlPsqfyHPQ6B8b
         waFkFvheUZ/oQebkPGpa3lux0lYv/ZOFxI7UgGzxrBa9dLdxuMP/1G9g0TBuw0UwuNy0
         3ofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O0n4OZEsHYcsD2VSr2bO/0IhfkveI/qdk1WzUKQRQFQ=;
        b=X7dq//5LdDzeScoFvzhrAcdJULEh76cfNJrEmks0niAYKNnFiKMY1vU2/TKd+ycAbw
         MGXDW75h+1t9QJePVFEfoYn8sCiqGimPsDC4gQzNXCb0C08lt+I89J/2o4Od7aax2ydK
         frhhvujHXFgimg1Gf5ILf70O6goJAq31RbcVWVqQC9f9eHzGymk5EterCHBaRjYKmjD/
         Cv7E4beb11ZR4txRB8qp5mk539Icl89yC5MIlc+3SvSGeG8uw9wTPZn9Sg1gEyAkV9/j
         F1Mf2IWdv6oaN4smaqmCZAjlpmeDpxRZ9DsP8MgugtvcHxRsFxOasCFcjZwXxBm6jh6w
         uMkw==
X-Gm-Message-State: AOAM530D7Ejk3OcUM9qLZBAMuhPlqIpVq7GtT757kU56LY0NptbDd7+w
        O/mHuz/+GSmissQA5pXhWMp8oXf4fwO2
X-Google-Smtp-Source: ABdhPJzbdZ5eidTYLUpqAxffM6plVUL8/poFE64k5MuNYLOFnQEKczGzc8DsayccIR3TMxHrquLZoy2dqOfk
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9258:9474:54ca:4500])
 (user=bgardon job=sendgmr) by 2002:ad4:4634:: with SMTP id
 x20mr6228412qvv.49.1620326579461; Thu, 06 May 2021 11:42:59 -0700 (PDT)
Date:   Thu,  6 May 2021 11:42:36 -0700
In-Reply-To: <20210506184241.618958-1-bgardon@google.com>
Message-Id: <20210506184241.618958-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 3/8] KVM: mmu: Refactor memslot copy
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out copying kvm_memslots from allocating the memory for new ones
in preparation for adding a new lock to protect the arch-specific fields
of the memslots.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 virt/kvm/kvm_main.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2799c6660cce..c8010f55e368 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1306,6 +1306,18 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	return old_memslots;
 }
 
+static size_t kvm_memslots_size(int slots)
+{
+	return sizeof(struct kvm_memslots) +
+	       (sizeof(struct kvm_memory_slot) * slots);
+}
+
+static void kvm_copy_memslots(struct kvm_memslots *from,
+			      struct kvm_memslots *to)
+{
+	memcpy(to, from, kvm_memslots_size(from->used_slots));
+}
+
 /*
  * Note, at a minimum, the current number of used slots must be allocated, even
  * when deleting a memslot, as we need a complete duplicate of the memslots for
@@ -1315,19 +1327,16 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 					     enum kvm_mr_change change)
 {
 	struct kvm_memslots *slots;
-	size_t old_size, new_size;
-
-	old_size = sizeof(struct kvm_memslots) +
-		   (sizeof(struct kvm_memory_slot) * old->used_slots);
+	size_t new_size;
 
 	if (change == KVM_MR_CREATE)
-		new_size = old_size + sizeof(struct kvm_memory_slot);
+		new_size = kvm_memslots_size(old->used_slots + 1);
 	else
-		new_size = old_size;
+		new_size = kvm_memslots_size(old->used_slots);
 
 	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
 	if (likely(slots))
-		memcpy(slots, old, old_size);
+		kvm_copy_memslots(old, slots);
 
 	return slots;
 }
-- 
2.31.1.607.g51e8a6a459-goog

