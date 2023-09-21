Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C167AA37F
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjIUVvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbjIUVvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:51:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32ABC06BE
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:45 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c46ce0c39fso11210595ad.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328425; x=1695933225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TrGawBYlg9dO9+tpkWoFC/Bm9/vroFhKv3wNgQsPHaE=;
        b=rFUUewuO4GiLk6j9N+4yp4fVjBcvcNNt50CIzAVuZSejDlBuhrCOxxOZhc8+s1TLM8
         J7VZoW31U63mk8Sr2bA42PCP59D6/UbKYU68Gb988+21XZqO/uiTRQ++zSP9M7VuQdTY
         fWZHjOXbjbBzOIH5lb8Me7NfER71QI426xW2bVmo6OVkMZN1P3Kf/95+V7SaqbWIvUep
         S9L8rrrGHAloQASoSFIgpXDbWCOcL0YurN1tRF6PwSf3OY4QSn4i3SuxJKZNG5H0bxkw
         t/huqM7dO8MESLuMR8p9A9Vg/hr6nzktEEkW4cxkVgBpB7t0tc23FLgGxiLfq0imX7GG
         L96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328425; x=1695933225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TrGawBYlg9dO9+tpkWoFC/Bm9/vroFhKv3wNgQsPHaE=;
        b=M3ibDPqmlPiuPhhX3bMIJrvX3geJUyDOdtfEAYubnUJwPxhBp5CQHJ9NPFwveAw9Oy
         8MlsMPf4WG6Cm5zmQM/vrdXilaCsV/ClskFiSHPjFPUf1GGr429RgbPVjPOGguOUyJ9l
         aKEV23o/PnuF78WUigbGCAAjeJngCayienJgwZ8runKMO2bJA2Gl3OLGtyyj84bB5cpw
         eCYfXSJRSw8601tpWxuvJBq350ckvSEheMtTIX00iB6o2MMmbPwdQjeNV8eB5HnxmgJo
         /Q6QtC9aAg/oHDJK498rvq4CZK/Qewi5By8h5Axb8UyKJ1hPHXBNIKoplQZ8xsOvcZcN
         y7wQ==
X-Gm-Message-State: AOJu0Yx1dq9MXowxtivGcTpEILRDSLS5d6YI4JTUcSvbsWa/4+GfUvt8
        rz1CSWOIvK0ZsqAdniPf6OxtkC/HBAs=
X-Google-Smtp-Source: AGHT+IG+uc2R/SKzIbV4YSj6Mluwpdoxl1dWdFaELq1DVKwkomUBRUUtPG4pltoyI3X4CUGacjj01mPun/o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d490:b0:1bc:7c69:925c with SMTP id
 c16-20020a170902d49000b001bc7c69925cmr94805plg.10.1695328425216; Thu, 21 Sep
 2023 13:33:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:23 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-7-seanjc@google.com>
Subject: [PATCH 06/13] KVM: Disallow hugepages for incompatible gmem bindings,
 but let 'em succeed
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

Remove the restriction that a guest_memfd instance that supports hugepages
can *only* be bound by memslots that are 100% compatible with hugepage
mappings, and instead force KVM to use an order-0 mapping if the binding
isn't compatible with hugepages.

The intent of the draconian binding restriction was purely to simplify the
guest_memfd implementation, e.g. to avoid repeatining the existing logic in
KVM x86ial for precisely tracking which GFNs support hugepages.  But
checking that the binding's offset and size is compatible is just as easy
to do when KVM wants to create a mapping.

And on the other hand, completely rejecting bindings that are incompatible
with hugepages makes it practically impossible for userspace to use a
single guest_memfd instance for all guest memory, e.g. on x86 it would be
impossible to skip the legacy VGA hole while still allowing hugepage
mappings for the rest of guest memory.

Suggested-by: Michael Roth <michael.roth@amd.com>
Link: https://lore.kernel.org/all/20230918163647.m6bjgwusc7ww5tyu@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_mem.c | 54 ++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 68528e9cddd7..4f3a313f5532 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -434,20 +434,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
 	return err;
 }
 
-static bool kvm_gmem_is_valid_size(loff_t size, u64 flags)
-{
-	if (size < 0 || !PAGE_ALIGNED(size))
-		return false;
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if ((flags & KVM_GUEST_MEMFD_ALLOW_HUGEPAGE) &&
-	    !IS_ALIGNED(size, HPAGE_PMD_SIZE))
-		return false;
-#endif
-
-	return true;
-}
-
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
@@ -460,9 +446,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-	if (!kvm_gmem_is_valid_size(size, flags))
+	if (size < 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if ((flags & KVM_GUEST_MEMFD_ALLOW_HUGEPAGE) &&
+	    !IS_ALIGNED(size, HPAGE_PMD_SIZE))
+		return -EINVAL;
+#endif
+
 	return __kvm_gmem_create(kvm, size, flags, kvm_gmem_mnt);
 }
 
@@ -470,7 +462,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset)
 {
 	loff_t size = slot->npages << PAGE_SHIFT;
-	unsigned long start, end, flags;
+	unsigned long start, end;
 	struct kvm_gmem *gmem;
 	struct inode *inode;
 	struct file *file;
@@ -489,16 +481,9 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto err;
 
 	inode = file_inode(file);
-	flags = (unsigned long)inode->i_private;
 
-	/*
-	 * For simplicity, require the offset into the file and the size of the
-	 * memslot to be aligned to the largest possible page size used to back
-	 * the file (same as the size of the file itself).
-	 */
-	if (!kvm_gmem_is_valid_size(offset, flags) ||
-	    !kvm_gmem_is_valid_size(size, flags))
-		goto err;
+	if (offset < 0 || !PAGE_ALIGNED(offset))
+		return -EINVAL;
 
 	if (offset + size > i_size_read(inode))
 		goto err;
@@ -599,8 +584,23 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	page = folio_file_page(folio, index);
 
 	*pfn = page_to_pfn(page);
-	if (max_order)
-		*max_order = compound_order(compound_head(page));
+	if (!max_order)
+		goto success;
+
+	*max_order = compound_order(compound_head(page));
+	if (!*max_order)
+		goto success;
+
+	/*
+	 * For simplicity, allow mapping a hugepage if and only if the entire
+	 * binding is compatible, i.e. don't bother supporting mapping interior
+	 * sub-ranges with hugepages (unless userspace comes up with a *really*
+	 * strong use case for needing hugepages within unaligned bindings).
+	 */
+	if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
+	    !IS_ALIGNED(slot->npages, 1ull << *max_order))
+		*max_order = 0;
+success:
 	r = 0;
 
 out_unlock:
-- 
2.42.0.515.g380fc7ccd1-goog

