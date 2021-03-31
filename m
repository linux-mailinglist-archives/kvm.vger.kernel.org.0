Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94543508F4
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhCaVKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbhCaVJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121EFC061760
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f75so3600016yba.8
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eskadvO96k3pneANThCp7BKmWYHI2ZyppDiy24nRtnU=;
        b=ZNhWId0uRHEhcDaAEd0M+K8xEu8VkF9gCgl+jE8TAn0noCeIzMzHMNMryIZIYQLkSH
         4ZKR95723NNgMyMUMIFcWwEX4p0WBlE0hX5Cae9bzRjnMHRvQ4DMS5JMJhz7rAvUQnks
         BmQuV2ch1Yzm/Ouj4V7cHkZ6q0w9i4fwFRRSLSRl2S6Sr0lW6Aj/QQ8eJcOdRlQOwt8U
         kyBEIuggTOia8+5h3uBAMy+n9qtAqs2eIjIbkUCnYLm2UFErwm1so1B8Lz0ARw9ovDCs
         5hentAQ2bFLK/1pb1h6jkF8C8fJsiv+7LtlzbFy4uLwQxeTwbm+8U6Z+KWkInFAwlOF2
         LWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eskadvO96k3pneANThCp7BKmWYHI2ZyppDiy24nRtnU=;
        b=QxtaYNl7Zc6+JSp31j1WvESByF2JdrTtJFVbkhWD9Nn8hLvwm/ObVRRc/mhUFc96GI
         w1+kQzKa/1xd/woTbIkAJmq2fqF2V+d68P4IZskP/Sl6WVSo82YIX8frqmjzlyihAz40
         PRo0vmnKVrf6PPIcq4RLxHDcA0Y4TiEuvTa6ICKrR5Ir6VLlew0wIyjjz4fMRPBTLj83
         0EXzKuJ6e6eF8mE3diy21eCHs2qJkozFFSARksigebFjwWX7NN6D5INVBgD0OGK7Igfw
         mdHepvFIV5VoGSOxL6UOSrbxDJS6GCKCIJhJ8gk71EWnycbFFQfwDdl19xqNuMi2d8l3
         Pg1w==
X-Gm-Message-State: AOAM532Tsj6w6VaWFHPaO+UCdO+EqkPTIeB/BGOZf5zSrDpX+2zy+8jW
        Rr0NHJRaX8wyWVh1O6qHSW9bZ+jy1275
X-Google-Smtp-Source: ABdhPJyfQtYhFW2ppM84KeLTBpgHFcYS7dJjRLhpqN+OnPuOl2ss6HgsxRRuWZICOhJTiHuUMc86SR3/XdTq
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a25:d2d3:: with SMTP id
 j202mr7290798ybg.157.1617224975277; Wed, 31 Mar 2021 14:09:35 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:40 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-13-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 12/13] KVM: x86/mmu: Fast invalidation for TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
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

Provide a real mechanism for fast invalidation by marking roots as
invalid so that their reference count will quickly fall to zero
and they will be torn down.

One negative side affect of this approach is that a vCPU thread will
likely drop the last reference to a root and be saddled with the work of
tearing down an entire paging structure. This issue will be resolved in
a later commit.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.c | 14 ++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  5 +++++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bf535c9f7ff2..49b7097fb55b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5430,6 +5430,9 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	write_lock(&kvm->mmu_lock);
 	trace_kvm_mmu_zap_all_fast(kvm);
 
+	if (is_tdp_mmu_enabled(kvm))
+		kvm_tdp_mmu_invalidate_roots(kvm);
+
 	/*
 	 * Toggle mmu_valid_gen between '0' and '1'.  Because slots_lock is
 	 * held for the entire duration of zapping obsolete pages, it's
@@ -5451,9 +5454,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	kvm_zap_obsolete_pages(kvm);
 
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_all(kvm);
-
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0c90dc034819..428ff6778426 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -789,6 +789,20 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 		kvm_flush_remote_tlbs(kvm);
 }
 
+/*
+ * This function depends on running in the same MMU lock cirical section as
+ * kvm_reload_remote_mmus. Since this is in the same critical section, no new
+ * roots will be created between this function and the MMU reload signals
+ * being sent.
+ */
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm)
+{
+	struct kvm_mmu_page *root;
+
+	for_each_tdp_mmu_root(kvm, root)
+		root->role.invalid = true;
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 855e58856815..ff4978817fb8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,6 +10,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 						     struct kvm_mmu_page *root)
 {
+	if (root->role.invalid)
+		return false;
+
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
@@ -20,6 +23,8 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
 			       bool shared);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm);
+
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		    int map_writable, int max_level, kvm_pfn_t pfn,
 		    bool prefault);
-- 
2.31.0.291.g576ba9dcdaf-goog

