Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3577AA1E8
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjIUVIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjIUVID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:08:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86726C06B4
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c41538c7eeso11043055ad.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328423; x=1695933223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ooFkuvOD+X01OBgJAJRWL8fBqVSu8Kag+d9BzvqrsOA=;
        b=xfuWEt8Xy/eLnkQ+WkpVXF77FY2mYKZh+pVi4BHapkczPN939dDp/4nGYBFzE6i91L
         dE6VUtYLN+gmelAtViKrulirUCx/d258IsmZ+60MuScpzpV3/jwA1F2tgr3VDi39qQPt
         ASSWsuUMBHCmc0y6haYEQqqPH6k1gt3sb7+6E/lFXpUnGSdpmyeIpyW5wz6krEG/GdaE
         lw31qnFx0PoBhiZ2iKwClwEFJddwOBujQlMtZdvzJ3VewGoIGQBKmJHBfEnk6sJFlErJ
         4g6x81YuZKCJQVkYAAzXb2KPj9GqNdtlZ/VUmu45nsdbVBE6g5RORCDXLMfTzEDE2Ro2
         9OYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328423; x=1695933223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ooFkuvOD+X01OBgJAJRWL8fBqVSu8Kag+d9BzvqrsOA=;
        b=reHoC4FBSpnbsM9tf01gx27C7WmtpUeGN/kb3ZGJACflMBMlTSvF1XioIyubqM3LSl
         SMurC+rQuxH9O4/p8zm0qjFFd3KObjzXYeVz4dncGPI9c874M/UO3ZMGXNQWQuH5QGSN
         HhrBhFx6cgjAiewXC+YcofFtKZTXPEj13hfxdNXoCdtW328Tj2z+sjWHbcc5vptPP/rk
         MuonKcBLjnPjqR2DTluT5wlHuKW5JQ84O9ZYDzHXCY68ydxl0Ft0deMhpS4IoB8c0erA
         vkpO7Nz0jZ9xTyH1NaZq/xmZ+kn8Hg6IA3QFOKPu7tX2gVdZxXfkxWxZ+eBLGue+7yCc
         b6tQ==
X-Gm-Message-State: AOJu0YyKL7pQwhfM5sdZmocehUFnRWSc6NezX+Z9n+djd9Rshsun6ArV
        oGxCiCqHzGdKhCaeGrbl8KRqF3N+yzA=
X-Google-Smtp-Source: AGHT+IEU5m4YoGaLYARxz6CkyfsMJNbrUD8SUx5Ubkh7a53+UYT0k7pUszgIuGSWr5rg40lyfuo4qcQeNaM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5d2:b0:1bf:cc5:7b53 with SMTP id
 u18-20020a170902e5d200b001bf0cc57b53mr91087plf.1.1695328423673; Thu, 21 Sep
 2023 13:33:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:22 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-6-seanjc@google.com>
Subject: [PATCH 05/13] KVM: Fix MMU invalidation bookkeeping in guest_memfd
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acquire mmu_lock and do invalidate_{begin,end}() if and only if there is
at least one memslot that overlaps the to-be-invalidated range.  This
fixes a bug where KVM would leave a danging in-progress invalidation as
the begin() call was unconditional, but the end() was not (only performed
if there was overlap).

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Fixes: 1d46f95498c5 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_mem.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 3c9e83a596fe..68528e9cddd7 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -88,14 +88,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 				      pgoff_t end)
 {
+	bool flush = false, found_memslot = false;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = gmem->kvm;
 	unsigned long index;
-	bool flush = false;
-
-	KVM_MMU_LOCK(kvm);
-
-	kvm_mmu_invalidate_begin(kvm);
 
 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
 		pgoff_t pgoff = slot->gmem.pgoff;
@@ -107,13 +103,21 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.may_block = true,
 		};
 
+		if (!found_memslot) {
+			found_memslot = true;
+
+			KVM_MMU_LOCK(kvm);
+			kvm_mmu_invalidate_begin(kvm);
+		}
+
 		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
 	}
 
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 
-	KVM_MMU_UNLOCK(kvm);
+	if (found_memslot)
+		KVM_MMU_UNLOCK(kvm);
 }
 
 static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
@@ -121,10 +125,11 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 {
 	struct kvm *kvm = gmem->kvm;
 
-	KVM_MMU_LOCK(kvm);
-	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT))
+	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
+		KVM_MMU_LOCK(kvm);
 		kvm_mmu_invalidate_end(kvm);
-	KVM_MMU_UNLOCK(kvm);
+		KVM_MMU_UNLOCK(kvm);
+	}
 }
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
-- 
2.42.0.515.g380fc7ccd1-goog

