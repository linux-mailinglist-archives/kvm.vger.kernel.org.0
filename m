Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD1375A4A
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhEFSny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236401AbhEFSny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:43:54 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12025C061763
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:42:56 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id s123-20020a3777810000b02902e9adec2313so4144169qkc.4
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IvlR4TwLPb1VTfZLUATWctM7vw/E1uak9fxPDAc2C68=;
        b=qLvTttI//vGOQKjhAI709uVWmJJX9PjDcNvEdKpoTe1nwekLzot7XmeC569I41AUbO
         Rf7RVyEVc2dcPUMvuXuiBsC+D2P+DhFJI2AzyTz/OKH9yoGN+B1eqk4dHpdFZrnGV4kw
         5tGCsJbkXii/72IzIqNDFbSx9KuoVQ1ZoNE2z7KFv4eMYWdExYdSmzbVjpYO3rCTgyAC
         4UiBN158gd9GrhhJCP6cS0ivDnOYzpGBev2fcUW1vLaiUXZyQmVWDpzvbToiQiK1hAx6
         ToNtI7GQQ6juvF4oCH2A2/0En03LAz3qY2lQ/EqhDSmHYi9JCVYTk78hxjqwzsMK2hYe
         IDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IvlR4TwLPb1VTfZLUATWctM7vw/E1uak9fxPDAc2C68=;
        b=rwHZZQVcEKJfefcpVYo4rbu0QO8IyCgMLEsw1Qgp+jy/s3iaPu4oMe+lkb162t5zPs
         65CwvTGm4LCA6/nu38OJZgpAAHXSMrTHnw/QrseQDd62OVljEeblta42bVEubJtPzK0T
         qP2rn4bzfxf3owSsiFm0vMYss68/8eWGOezthRsh/7uvUa6s03BDkDf5p/b1ucxL7K44
         SuRbPoxcMTp0YjSrr5b7n5vmdQhH34FM7ej2O0Ly740mK8BpvgchbSPRaQYU4v4DqIXi
         aPuxBe3oK0/hnIOFJzxdnFtfP6z7nx6VGi+c8XR0DK+EE1XZS1/VN7/txOasOpHRM42a
         Eb8Q==
X-Gm-Message-State: AOAM533PpPeGMq0OFXUowT52IZVWiezMwYMLMQGdv4HgZa2hY+Y/V12B
        gj8GiJJzntV6hE/Oeeb1JPBBB0HjzO/U
X-Google-Smtp-Source: ABdhPJwjCHgBiZQPveyAT8FAROrbGPGcTpihTMmkgQ8Bsq5jAd317Ayic93qyH9jaYwSjUS/wPnxAXGAp/M3
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9258:9474:54ca:4500])
 (user=bgardon job=sendgmr) by 2002:ad4:4d94:: with SMTP id
 cv20mr5913495qvb.26.1620326575260; Thu, 06 May 2021 11:42:55 -0700 (PDT)
Date:   Thu,  6 May 2021 11:42:35 -0700
In-Reply-To: <20210506184241.618958-1-bgardon@google.com>
Message-Id: <20210506184241.618958-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 2/8] KVM: x86/mmu: Factor out allocating memslot rmap
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

Small refactor to facilitate allocating rmaps for all memslots at once.

No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bcf07465c47..fc32a7dbe4c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10842,10 +10842,37 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
+static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
+			      unsigned long npages)
+{
+	int i;
+
+	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+		int lpages;
+		int level = i + 1;
+
+		lpages = gfn_to_index(slot->base_gfn + npages - 1,
+				      slot->base_gfn, level) + 1;
+
+		slot->arch.rmap[i] =
+			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
+				 GFP_KERNEL_ACCOUNT);
+		if (!slot->arch.rmap[i])
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	free_memslot_rmap(slot);
+	return -ENOMEM;
+}
+
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
+	int r;
 
 	/*
 	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
@@ -10854,7 +10881,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+	r = alloc_memslot_rmap(slot, npages);
+	if (r)
+		return r;
+
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		struct kvm_lpage_info *linfo;
 		unsigned long ugfn;
 		int lpages;
@@ -10863,14 +10894,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		lpages = gfn_to_index(slot->base_gfn + npages - 1,
 				      slot->base_gfn, level) + 1;
 
-		slot->arch.rmap[i] =
-			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
-				 GFP_KERNEL_ACCOUNT);
-		if (!slot->arch.rmap[i])
-			goto out_free;
-		if (i == 0)
-			continue;
-
 		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
-- 
2.31.1.607.g51e8a6a459-goog

