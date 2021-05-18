Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCEB387E72
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 19:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351172AbhERRfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 13:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346564AbhERRfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 13:35:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27118C061761
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d20-20020a25add40000b02904f8960b23e8so14526116ybe.6
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+sf6y3nv2ZCNMXtqDYEEUFgNmENQxF7tXN6LoZYjT6w=;
        b=PU5+p2NnY0u4ZuZWWlDMiOb5GYo4r0+qOUW247POD85mVHqQiV4MByP+516xA+ko2N
         /eF+jpmKfJWCWyS7Q4l2p6GRWAxftv+4SaTlD1Yugk4v+ULn+VBaqO2nq5bLS8hIEhT9
         Tg7RrVP/OYR+8R9yE1+KGIy29BlteCy4tRBeJnvgy6TE4Q2rQjs2q4Cobi4mJP+fHS4s
         ix7/OKNTcfbmyrksuvBL7t+oKlXF9zemZ8sK1SrqXMD+4rNEjHT3mHtzDvxLInriml6W
         YRRe6p+pwWm97JSG2jVcwOT0U0mlO/aX4HEHbPEJPxXpvig4tpNA//j6p5RqF4piBk76
         gfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+sf6y3nv2ZCNMXtqDYEEUFgNmENQxF7tXN6LoZYjT6w=;
        b=lR1MKMYVL7pRapy+LykatQw2vrsbUW42fyaty6veExZt1o4u1JFLXmI2DrmMPgGazH
         77FYowDN5P5BhMa8J7EdghfPOEEx3jGnflzTg2nQb4bFHkkO0/zZpqNM7MnxCwsSUe3P
         hZBUJue7HzCjIkczwFg4VAW01sYSbKv3Y8WjeaLpLTg0PMn/jFWn85qU0/bJqV5Hz4+c
         rhuhQAt+j5dHhcESkdT+QRNcYfQlbjq4JHiXpqiqjmJgXjFQYqbAaqe6Iqmp2QLWzQ1j
         hCb+5FNpOLAnCIliFW916Mcrtg7AwTSk8dhHQRVwdI3/Tr141y8Kn0ngYhQW2nhG78YZ
         yXbA==
X-Gm-Message-State: AOAM530s1IRzvNZKFNITVHvKBxECywoJSBAY1kUG8xDdT6cEV/liogRo
        pR6yV2fO8/OQRe3mTJQjZAp3h0iPSbD1
X-Google-Smtp-Source: ABdhPJyFg3C3gccSXGLVHaDl3yMQ2ccs5PyYFlbCOevTKAIcdWPUH93Yi7nwEn0Wy8SM+qElCtaO8jLNrmd1
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2715:2de:868e:9db7])
 (user=bgardon job=sendgmr) by 2002:a25:6c0a:: with SMTP id
 h10mr8538112ybc.167.1621359259737; Tue, 18 May 2021 10:34:19 -0700 (PDT)
Date:   Tue, 18 May 2021 10:34:08 -0700
In-Reply-To: <20210518173414.450044-1-bgardon@google.com>
Message-Id: <20210518173414.450044-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210518173414.450044-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v5 1/7] KVM: x86/mmu: Deduplicate rmap freeing
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
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small code deduplication. No functional change expected.

Reviewed-by: David Hildenbrand <david@redhat.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..11908beae58b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10896,17 +10896,23 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_hv_destroy_vm(kvm);
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+static void memslot_rmap_free(struct kvm_memory_slot *slot)
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
+	memslot_rmap_free(slot);
 
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
@@ -10972,12 +10978,9 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	return 0;
 
 out_free:
-	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		kvfree(slot->arch.rmap[i]);
-		slot->arch.rmap[i] = NULL;
-		if (i == 0)
-			continue;
+	memslot_rmap_free(slot);
 
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
-- 
2.31.1.751.gd2f1c929bd-goog

