Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30273EBCDA
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhHMTzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 15:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbhHMTzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 15:55:05 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1608C0617AD
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 12:54:38 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o13-20020a17090a9f8db0290176ab79fd33so11426247pjp.5
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 12:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jGdqH7teKJ4mZM017dJsQ8DXbufWMqis8KtdPBn4mCA=;
        b=F9p4yWSJkf87aCLhH+oo7krZZ+f38oss3VXzkoX+SACRVCO1FWa/Gs1kNYK8Ywhdiu
         3B3NG/ghOERM8pN4rEPVbGPZj3WKiMnftYn25EbcVEFy4JJZdbRpkPfjjdB3ElQ7v0P+
         t603+l6oliTEcb8+ydFYju8uopcSmFW996I7sODVj3V99+Sm+tyaugyCjaIyivGty0G+
         GIkvU84w6mAHvAEt0RlhetLIQrvDQDsC38pYL95uV/9Swu2/5/fCAyCwj6r7EhuGtnuF
         eFkJS+b6C3wOdTaST0KoNiiUjz9W8Sc327CTpMEsxtMOkDJUXoMcX1vIamLV8dqiJpQ1
         UAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jGdqH7teKJ4mZM017dJsQ8DXbufWMqis8KtdPBn4mCA=;
        b=AoBn/NOCXwTQ7pmwflABIIze77zhgQ43ZM1beZKGOPJPvPHw3rPTQIARWCKQ75ddEJ
         WuaWZZmbk3kRCzxEp3iOE1NkTHKlWOWXabSGHDnfd4pzOYgS0onYH67HctleyDiZGl4m
         FS2Bd3y64IRCHh8luO7Q4oDGpYM4H1xPRzAs6CVyYDTPFOqlEnjgRS/GfvMhdjwiDjnM
         sM+JHHPQsYzIK5WycAtJJ9t0C7mgPg6Nlt4Awtkvh9toxNrBjDyWfiintcDPLOezMpWV
         NjEXN82BMNPNDf6VB4e9dwa81HMARtWG5nlAenFnrZq0a+ZJ2C1sYotcLWGOQ+0fkbWH
         NWPw==
X-Gm-Message-State: AOAM531HeoU/XZIQQ/wOS4OF2VH9/bFBkqPcgDAxq3ea2APqLAy42rWu
        rTI5swmMmGf01ER1r3u6cnEnAGefkP710T5P9eYpKjsO3zrBhscP1bpFtivsDhXifhyPnCM3lbU
        D31UtpVT0a4kuAP7sUYIg5ZcgmGnik3bvR+pn8mPbgC91vB8z8Ftsz/QBEya6VRM6ukFKFug=
X-Google-Smtp-Source: ABdhPJw6fOPR+CX9bCm0Ns9AALocYSNGiDKEtptkFfcuABrYWtIofRT/VtqdeNILbBkjcOAmzSWllFtTQqkwkIFaEQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:ecca:b029:12d:1a3b:571f with
 SMTP id a10-20020a170902eccab029012d1a3b571fmr3265550plh.37.1628884478139;
 Fri, 13 Aug 2021 12:54:38 -0700 (PDT)
Date:   Fri, 13 Aug 2021 19:54:33 +0000
Message-Id: <20210813195433.2555924-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v3] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A per VCPU stat dirtied_pages is added to record the number of dirtied
pages in the life cycle of a VM.
The growth rate of this stat is a good indicator during the process of
live migrations. The exact number of dirty pages at the moment doesn't
matter. That's why we define dirtied_pages as a cumulative counter instead
of an instantaneous one.

Original-by: Peter Feiner <pfeiner@google.com>
Suggested-by: Oliver Upton <oupton@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 12 ++++++++++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  3 +++
 include/linux/kvm_host.h               |  3 ++-
 include/linux/kvm_types.h              |  1 +
 virt/kvm/kvm_main.c                    |  5 +++++
 5 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index c63e263312a4..e06cd9c9a278 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -1112,6 +1112,7 @@ long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
 {
 	unsigned long i;
 	unsigned long *rmapp;
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	preempt_disable();
 	rmapp = memslot->arch.rmap;
@@ -1122,8 +1123,11 @@ long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
 		 * since we always put huge-page HPTEs in the rmap chain
 		 * corresponding to their page base address.
 		 */
-		if (npages)
+		if (npages) {
 			set_dirty_bits(map, i, npages);
+			if (vcpu)
+				vcpu->stat.generic.dirtied_pages += npages;
+		}
 		++rmapp;
 	}
 	preempt_enable();
@@ -1164,6 +1168,7 @@ void *kvmppc_pin_guest_page(struct kvm *kvm, unsigned long gpa,
 void kvmppc_unpin_guest_page(struct kvm *kvm, void *va, unsigned long gpa,
 			     bool dirty)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct page *page = virt_to_page(va);
 	struct kvm_memory_slot *memslot;
 	unsigned long gfn;
@@ -1178,8 +1183,11 @@ void kvmppc_unpin_guest_page(struct kvm *kvm, void *va, unsigned long gpa,
 	gfn = gpa >> PAGE_SHIFT;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	memslot = gfn_to_memslot(kvm, gfn);
-	if (memslot && memslot->dirty_bitmap)
+	if (memslot && memslot->dirty_bitmap) {
 		set_bit_le(gfn - memslot->base_gfn, memslot->dirty_bitmap);
+		if (vcpu)
+			++vcpu->stat.generic.dirtied_pages;
+	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index b5905ae4377c..a07f143ff5ee 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1134,6 +1134,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 			struct kvm_memory_slot *memslot, unsigned long *map)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	unsigned long i, j;
 	int npages;
 
@@ -1150,6 +1151,8 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 		j = i + 1;
 		if (npages) {
 			set_dirty_bits(map, i, npages);
+			if (vcpu)
+				vcpu->stat.generic.dirtied_pages += npages;
 			j = i + npages;
 		}
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d447b21cdd73..c73d8bf74f9f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1459,7 +1459,8 @@ struct _kvm_stats_desc {
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
-			HALT_POLL_HIST_COUNT)
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_COUNTER(VCPU_GENERIC, dirtied_pages)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index de7fb5f364d8..949549f55187 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -93,6 +93,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
+	u64 dirtied_pages;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..8c673198cc83 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3075,6 +3075,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 			     struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
@@ -3084,6 +3086,9 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 					    slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+
+		if (vcpu)
+			++vcpu->stat.generic.dirtied_pages;
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);

base-commit: 32bdc01988413031c6e743714c2b40bdd773e5db
prerequisite-patch-id: 7f9928f8f0eefbaa3a583f2938fe702bf082832d
prerequisite-patch-id: c02ba4a19976d9404f0b74e9a004b94c32250e23
prerequisite-patch-id: 628acee8421e7a79a8c88457a3c7cfc62eb60df6
prerequisite-patch-id: 38a6ba1e5f31ec6527aa9834be8c24bdcc10daf8
prerequisite-patch-id: 1dad2c942cdaf9085f3ca0d7e075bf412f063690
prerequisite-patch-id: 733eec6f0411d168d8be7e84123c2701d650c9b1
prerequisite-patch-id: e01d06225202e7e71948649e6f17d131c514eed0
prerequisite-patch-id: cc1b3818a85e8d9caea4804f89adeb58771bbf1e
prerequisite-patch-id: 81ef42f04afa63ac0b3016c27835e3b5968d202a
prerequisite-patch-id: 7f279f4a51f46f2108e4854fb9558df4c6a94f29
prerequisite-patch-id: f2defc4b5b2be4a8533bc404018c2dff84804e1c
prerequisite-patch-id: 71a90f368e66bdefff7c9e61aeadf3b8d0ddde82
prerequisite-patch-id: 8f2100ccb62bee15548d7cb95290aaeb0f8e2b5c
prerequisite-patch-id: dc293f3133694e90a2ebf0ae144f43fffb906f85
prerequisite-patch-id: 5d69ad7077a762025172f5fd2574d08fea7dc268
prerequisite-patch-id: 48505db61f795aa630346ecc7ac6356edcca06a3
prerequisite-patch-id: d3bf8234d2c9ad9232cb555c36dee748b0c80718
prerequisite-patch-id: 26c42b588f3b5e69221c3e306ec3e1b4790bee8c
prerequisite-patch-id: 602dc8d069bebe908605c8a215dc43a884735ead
prerequisite-patch-id: e280224c3d0a3b4f4655b8ff72bd94b35b1f43e7
prerequisite-patch-id: d1b1fef9e46f933a7966f696bb524701173e5204
prerequisite-patch-id: 291fdde808d05f601930d010fdac5f8338189ff0
prerequisite-patch-id: b5fcfb1ce91b4a18f4e2b13b4768956c4b58f244
prerequisite-patch-id: 4374b5db583ecd2fc7b9dd09d5798e39dcfd8133
prerequisite-patch-id: c48a5c9e213598815d7d421ea37a7c1ffadd5c5f
prerequisite-patch-id: d2eb17f39a5c0b79f4572e61865bf0780a701150
prerequisite-patch-id: b307b25a22b7323d381172d0567e9d605a4a81d6
prerequisite-patch-id: e029e05c967a87ae93a825c554295278cc2992bc
prerequisite-patch-id: 82839126bac4f409eeba502c3b9c42cdb94d6755
prerequisite-patch-id: 74133700ce1b993ab21f856460fb376118afc03b
prerequisite-patch-id: d2103c1a2efd0c8827a2755a1900cd9882e24d69
prerequisite-patch-id: e23c3a8fef94984b2646749af6f5039951db0078
prerequisite-patch-id: 79d10df1e51206f1b5ab817cb0a4fe0e5deb3714
prerequisite-patch-id: 1e9b9d657710420f725a5ca7a907af4f1c490cf7
prerequisite-patch-id: a23e193be8d45015fc97b5c050b95c1d993c4071
prerequisite-patch-id: 635e397140a5ee693b57107349a0361a3bdfdaad
prerequisite-patch-id: ee2ba6ddbda9caeff25fe806fb7b90f6bc8d738f
prerequisite-patch-id: 170ca5c3ff1b233471a18cfd2c8a784da4ccd992
prerequisite-patch-id: a1097b6a0e20c4e90836c91c76706fffc729764b
prerequisite-patch-id: e8f1fb7ab8f65141e31779ee07727dff47ac0098
prerequisite-patch-id: b6312876622aca5d7c9e75f30dc3fd8a03ac26a0
prerequisite-patch-id: ca943c3b8b8b92890be1460b1ea35700f334660a
prerequisite-patch-id: e7f18191c3eab5e9d00835427b24e5c4cb71e816
prerequisite-patch-id: 35d6e3afb732b90645dbe616b09ac3804d0c382c
prerequisite-patch-id: 44e001ebb2ca30fc9961d05318b255b5cd613373
prerequisite-patch-id: 191134641b9ac4388a673cd1be8990c055e7a7e0
prerequisite-patch-id: 381ad781082b71336c68dc34b5f25d5b77ba414a
prerequisite-patch-id: adc5e83bd8bb078c8ea18e7967c50f1129bf6b32
prerequisite-patch-id: 08acb2d3d0570fa274f37f6962d77717ba1dc81e
prerequisite-patch-id: e208ed736197056053c4f31831f6d8778255142e
prerequisite-patch-id: 36c72d212fbe1dd0f90eb2767a9537931836dd1d
prerequisite-patch-id: d9267363edcdfe283817db7a8d4bccf3e51e497d
prerequisite-patch-id: 9cc7ff89a0b76cbad8e3ef90c7cb2677874e055a
prerequisite-patch-id: a86657c13e42746d2bc1dd9a97cd0c69873b405a
prerequisite-patch-id: 52bbc868d38a1e9747af2339769cc5fef37ee5e8
prerequisite-patch-id: af33089f214ac7a4018dfb5f1d2eaba8fe0da914
prerequisite-patch-id: 83783ad0d671bf57882cb508ce210aa997e40f55
prerequisite-patch-id: fbf0c1e61a19ca0c2ba30fc25e00aec74b77caeb
prerequisite-patch-id: 2475fd8e98d99b813fc1975bb74ec313944b91eb
prerequisite-patch-id: 30c2fe721d08d0355358f14065339164fd2fc05e
prerequisite-patch-id: 7aea11540a6b79b9490a71291ad8f55dac766333
prerequisite-patch-id: 2172f5ec654e6dbeb853234e49debf02002e0c1e
prerequisite-patch-id: b5615f710c650f11dc792b1ed41b1f6e0466b5b4
prerequisite-patch-id: e7081362d2b5f7f6c47004216a06491c88219438
prerequisite-patch-id: d5a02470af471474c86fe98e744d6765c7bb0568
prerequisite-patch-id: 875404b5ca431d51ed44ef1bac7314263378c21c
prerequisite-patch-id: bd76891bbc89690d44048c4bcdeceea803b8c329
-- 
2.33.0.rc1.237.g0d66db33f3-goog

