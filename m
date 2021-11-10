Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DBC44CCC1
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhKJWdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbhKJWdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:22 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F47C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:34 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id h35-20020a63f923000000b002d5262fdfc4so2238819pgi.2
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yCz7cyLf3zj3rbp6D5rVcRB8/oAS85nKHiPmUvql15M=;
        b=puwXdgsXTast2KMlehXXil09T6tXG+5+d6LEEM/ydxzkNwv1r7hW2iYVdYZ6szgVjq
         yPbJmvrEH12zVvIWThdbLT9grVe1r9BFT+gL0xWprjJiHVuqRyrNozWyfPBjifT/qXCf
         tRHBX+U0uQGPybDAqM01+aVKn1MDnv1HRc5y0KR9XPWCNqmQZg/hpJTwu8A0LfU+xs0k
         /LjK+2zXB97JjmCHERHbMDSVSHQpMtaEc7NWp7B538R2v7AFOoNbTfJNH16lhaNdIf4l
         pvuaKbzwAfjD3/CuHkJys/P3YrixNkaZwduTHuKEwJbmEXngoAd73rSlXcXiGbk3IKU+
         Qncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yCz7cyLf3zj3rbp6D5rVcRB8/oAS85nKHiPmUvql15M=;
        b=DxH9tl12cz+yHPfR3xZlFekRLhpfOBt0IcFacUcXcnbYSyWRa7hF9lVpT0OPjKkYZc
         f9QQXdA/vVkDvp4gkfI99btmXs6NnzDCHfBCaAd1Oa7nLB4xg+avYNEhopayT2arIAn2
         mIwxZgg+BwpipKQP7vwYH/QRZLOwyDU4P5NFQs1L5lMLatc+AJNfLzklrTeNXl3HsCfq
         yPXb7M2eIMtoXZBlnFEieTM94a/7r0b/px7JR83E1UI0O3PUKUMF2wRF7st+WNmOOEp3
         b/FQYAdeKCXUSs28PXF9wXN6JgBk3RAKX4pWAKysc3nCdPFF3/RR2U/kBGjYyg1D4tWi
         QGaw==
X-Gm-Message-State: AOAM531n+vTd5dHHpRNkjY+DjAyYIom+hSnS3HGJ+o4G3Dmor5ElLnJo
        Z3gE8PZJY8hWMsxd+V+QxqD/y6i8i0Xs
X-Google-Smtp-Source: ABdhPJxpMsqYTyzUV1XtB8oPH6XSH/mhtghcJCEb8GMNVlWHOgVZ5EhWP4YdliIdeqQu7u5r2KSoqvuL4HAE
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:2349:b0:49f:db1d:c378 with SMTP
 id j9-20020a056a00234900b0049fdb1dc378mr2436949pfj.53.1636583433793; Wed, 10
 Nov 2021 14:30:33 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:55 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-5-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 04/19] KVM: x86/mmu: Yield while processing disconnected_sps
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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

When preparing to free disconnected SPs, the list can accumulate many
entries; enough that it is likely necessary to yeild while queuing RCU
callbacks to free the SPs.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a448f0f2d993..c2a9f7acf8ef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -513,7 +513,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * being removed from the paging structure and this function being called.
  */
 static void handle_disconnected_sps(struct kvm *kvm,
-				    struct list_head *disconnected_sps)
+				    struct list_head *disconnected_sps,
+				    bool can_yield, bool shared)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_mmu_page *next;
@@ -521,6 +522,16 @@ static void handle_disconnected_sps(struct kvm *kvm,
 	list_for_each_entry_safe(sp, next, disconnected_sps, link) {
 		list_del(&sp->link);
 		call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
+
+		if (can_yield &&
+		    (need_resched() || rwlock_needbreak(&kvm->mmu_lock))) {
+			rcu_read_unlock();
+			if (shared)
+				cond_resched_rwlock_read(&kvm->mmu_lock);
+			else
+				cond_resched_rwlock_write(&kvm->mmu_lock);
+			rcu_read_lock();
+		}
 	}
 }
 
@@ -599,7 +610,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 */
 	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
 
-	handle_disconnected_sps(kvm, &disconnected_sps);
+	handle_disconnected_sps(kvm, &disconnected_sps, false, true);
 
 	return true;
 }
@@ -817,7 +828,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	if (!list_empty(&disconnected_sps)) {
 		kvm_flush_remote_tlbs(kvm);
-		handle_disconnected_sps(kvm, &disconnected_sps);
+		handle_disconnected_sps(kvm, &disconnected_sps,
+					can_yield, shared);
 		flush = false;
 	}
 
-- 
2.34.0.rc0.344.g81b53c2807-goog

