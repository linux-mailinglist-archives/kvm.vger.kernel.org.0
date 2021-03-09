Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02573331A7
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 23:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhCIWmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 17:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhCIWmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 17:42:21 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC04C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 14:42:21 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id h126so11301096qkd.4
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 14:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3FDwgTSdlybb0+QpsP8TGr882VxHot0P+ICZIwf0/7Y=;
        b=oW2lr/XjXHg3Nm0VgnuAiEKlaz9HAuC1KRfqgW2Mej9IR1fv7tZd29Q0rJNk8kbwyy
         SQDLQCLoY2lc72OxFhtWMYZoPJHKBy8vxit8uE1so0nAPVLgsuk3eZdprPjmvKUHOWm3
         2mEQViqJRN8DaZk1CqdIsy6b9aHers+u7wJkATiOQshwgQ1RBOnKH2sSWPk0SpXzuGjA
         YYnHrERktO5leQqBWNZg/BmvAaC5g+Nwa6zwwiuzA5i3Z5Wd2GXV7QvUzei/cdpLU7Qj
         h6GDPr7CqLoqv8pL/Fb698SVhxdivZgCisyogbkB9qTTS/uvjO2Uo1RsDZXj7RnkzVOy
         bAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3FDwgTSdlybb0+QpsP8TGr882VxHot0P+ICZIwf0/7Y=;
        b=f8lEFREniuiNzQJUpefmCdvXfdCF3H28RU2sWUCHAifWiEWbc8XdfuCgL0A6rhGyCT
         NkCknsoUUFFd7tcaufBn2X3OfrHeBBgz8PqJl/WEjgRW8Xp0ksFE5JNHe1o/cqrx/6gO
         KU9w4zZc/ttVz1eOt0rUsvwHjeSuRerI1FtAHr8HQKV8Szg+WAiM6JShHYLojMWhuASg
         0Eql7YRrAx2v41O3b0wdrK0Kl4omtYzEgOR4u95/4GkcjzZ/yXNGhAe87b7Va3nZ6six
         EYu8Hn8vhCNLiVDAmr8NZ+4j3AR9juY0rBiBlPusejkeflZn1wYb5PR8HuvYuoGR2DH9
         uqjA==
X-Gm-Message-State: AOAM533u9QOAogWd7AqVgYZFCtNrButpH/Wy4P9JERVMPrXA47sMIzf4
        n9AROoAZqNXM4H7jiKEPY3VPzgYrJc8=
X-Google-Smtp-Source: ABdhPJw5U0P6iQMF5biraJ2CMhXIV52ZCiW4aOwwilimTx8W3XMvVhsYpE+xa+8pbuPNKS0hkuqZ2hOdbxU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
 (user=seanjc job=sendgmr) by 2002:a0c:b9a5:: with SMTP id v37mr172321qvf.46.1615329740864;
 Tue, 09 Mar 2021 14:42:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Mar 2021 14:42:06 -0800
In-Reply-To: <20210309224207.1218275-1-seanjc@google.com>
Message-Id: <20210309224207.1218275-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210309224207.1218275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 3/4] KVM: x86/mmu: Use '0' as the one and only value for an
 invalid PAE root
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use '0' to denote an invalid pae_root instead of '0' or INVALID_PAGE.
Unlike root_hpa, the pae_roots hold permission bits and thus are
guaranteed to be non-zero.  Having to deal with both values leads to
bugs, e.g. failing to set back to INVALID_PAGE, warning on the wrong
value, etc...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++++-----------
 arch/x86/kvm/mmu/mmu_audit.c    |  2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++++++
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index febe71935bb5..6b0576ff2846 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3197,11 +3197,14 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
 		} else if (mmu->pae_root) {
-			for (i = 0; i < 4; ++i)
-				if (mmu->pae_root[i] != 0)
-					mmu_free_root_page(kvm,
-							   &mmu->pae_root[i],
-							   &invalid_list);
+			for (i = 0; i < 4; ++i) {
+				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
+					continue;
+
+				mmu_free_root_page(kvm, &mmu->pae_root[i],
+						   &invalid_list);
+				mmu->pae_root[i] = INVALID_PAE_ROOT;
+			}
 		}
 		mmu->root_hpa = INVALID_PAGE;
 		mmu->root_pgd = 0;
@@ -3253,8 +3256,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			return -EIO;
 
 		for (i = 0; i < 4; ++i) {
-			WARN_ON_ONCE(mmu->pae_root[i] &&
-				     VALID_PAGE(mmu->pae_root[i]));
+			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
@@ -3328,11 +3330,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < 4; ++i) {
-		WARN_ON_ONCE(mmu->pae_root[i] && VALID_PAGE(mmu->pae_root[i]));
+		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
 		if (mmu->root_level == PT32E_ROOT_LEVEL) {
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
-				mmu->pae_root[i] = 0;
+				mmu->pae_root[i] = INVALID_PAE_ROOT;
 				continue;
 			}
 			root_gfn = pdptrs[i] >> PAGE_SHIFT;
@@ -3450,7 +3452,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
-		if (root && VALID_PAGE(root)) {
+		if (IS_VALID_PAE_ROOT(root)) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
 			mmu_sync_children(vcpu, sp);
@@ -5307,7 +5309,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->pae_root = page_address(page);
 	for (i = 0; i < 4; ++i)
-		mmu->pae_root[i] = INVALID_PAGE;
+		mmu->pae_root[i] = INVALID_PAE_ROOT;
 
 	return 0;
 }
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index ced15fd58fde..cedc17b2f60e 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -70,7 +70,7 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
-		if (root && VALID_PAGE(root)) {
+		if (IS_VALID_PAE_ROOT(root)) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
 			__mmu_spte_walk(vcpu, sp, fn, 2);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ec4fc28b325a..5fe9123fc932 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -20,6 +20,16 @@ extern bool dbg;
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
+/*
+ * Unlike regular MMU roots, PAE "roots", a.k.a. PDPTEs/PDPTRs, have a PRESENT
+ * bit, and thus are guaranteed to be non-zero when valid.  And, when a guest
+ * PDPTR is !PRESENT, its corresponding PAE root cannot be set to INVALID_PAGE,
+ * as the CPU would treat that as PRESENT PDPTR with reserved bits set.  Use
+ * '0' instead of INVALID_PAGE to indicate an invalid PAE root.
+ */
+#define INVALID_PAE_ROOT	0
+#define IS_VALID_PAE_ROOT(x)	(!!(x))
+
 struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
-- 
2.30.1.766.gb4fecdf3b7-goog

