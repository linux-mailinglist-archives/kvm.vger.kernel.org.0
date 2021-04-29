Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8036F1DE
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 23:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhD2VTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 17:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237449AbhD2VTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 17:19:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91CEC06138E
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:18:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x186-20020a25e0c30000b02904f0d007a955so5970096ybg.12
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QRzqEuizFaFkQxevKt3y5xfCD5/WcG3SO3mTco4rXd8=;
        b=a7o4NbCb/FLCP3YNj/MExk/0rq0NY4gLbkLB3ZIyFzZxQrbQ3t+vk5+Pp0MCoG9rqt
         MEI8VOXWgTEf4BcNg441Pro8kHFr71sXKs7G4yS8BDDuGdu41FadlSKvrmif4doRTLUk
         ReXW9ShVSjefMMtgPQC9dDaPI32aM5gYpm2y80hvuT8JOrBXVOHSj8l+1s0EhPqn6vm6
         2GGjtxYyUlTWL9Wz7hEDD7XUZRXSmU4t0n0xLmqQzSjQrDQwMppuhnBk3syz9JsYUWYN
         5ZZ+gr1eT27GQBrEJt6jRtjQsTRqXb9OIJkr2jeYxl8+0J1iOJUAoeDUSZ4hmuyZhLR3
         IBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QRzqEuizFaFkQxevKt3y5xfCD5/WcG3SO3mTco4rXd8=;
        b=BDvjtzAZyA3Xt+g64LcdXE4kqJLcd/mZb3xtevkEzd4ppj73V1J5tVrpQQzasSoyEE
         jsTgRi2E2Gb9MX6LpwwyRiUb2tkSD6QUCOwXZp94t45OyKJPV1L72R9j0bALATfw+mC6
         LFvvVmzF32cMPwBPNviXbj1IyfGJbBK/PxFTqnJkqHM3chxgwv4xEQ2tYGgAbCwJMW7k
         J8CLl4Pjxe/d0HWlUZBozyFlxXZn2dmE7SEN1x1lfaG9Y3iOAb4erL6bJ7Tym27pAdN2
         K7uvfVIfDw/GZEK0o1ZwM6IZ16ClNBeNYOVFKEH3gUl8n9aZeUHFz0UI/nA4rA54DkxO
         qnVQ==
X-Gm-Message-State: AOAM530xSnO2yKXzCJWZ+hSQZboc8+M/5N7UQAilZUlL41zmNo5l6HU4
        yErVAgia2zZnaUV5mIutkeh43HLFAv4K
X-Google-Smtp-Source: ABdhPJzW+3BDMQbSuehL66s7eyvJCJrWAWWw4G9WeRa7yQ1zEs9j14VEAtPYhCvIytk/eK/E2AOfbyTPnh1P
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:1a18:9719:a02:56fb])
 (user=bgardon job=sendgmr) by 2002:a25:b9c3:: with SMTP id
 y3mr2081339ybj.480.1619731135170; Thu, 29 Apr 2021 14:18:55 -0700 (PDT)
Date:   Thu, 29 Apr 2021 14:18:29 -0700
In-Reply-To: <20210429211833.3361994-1-bgardon@google.com>
Message-Id: <20210429211833.3361994-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210429211833.3361994-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 3/7] KVM: x86/mmu: Deduplicate rmap freeing
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small code deduplication. No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf3b67679cf0..5bcf07465c47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10818,17 +10818,23 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_hv_destroy_vm(kvm);
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+static void free_memslot_rmap(struct kvm_memory_slot *slot)
 {
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.rmap[i]);
 		slot->arch.rmap[i] = NULL;
+	}
+}
 
-		if (i == 0)
-			continue;
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	int i;
+
+	free_memslot_rmap(slot);
 
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
@@ -10894,12 +10900,9 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	return 0;
 
 out_free:
-	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		kvfree(slot->arch.rmap[i]);
-		slot->arch.rmap[i] = NULL;
-		if (i == 0)
-			continue;
+	free_memslot_rmap(slot);
 
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
-- 
2.31.1.527.g47e6f16901-goog

