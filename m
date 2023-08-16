Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15877EAD1
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 22:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346174AbjHPUhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 16:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346187AbjHPUhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 16:37:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F3E2701;
        Wed, 16 Aug 2023 13:37:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68859ba3a93so1525843b3a.1;
        Wed, 16 Aug 2023 13:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692218231; x=1692823031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jGuo32BcwZ4xrip9OSKVN8CRZpvzjsNQ0WOCuGvqoo=;
        b=IwRFjsy3rmvP07bgFhAzql9KyPj/+y7HhbnNxUmt5S21f2nbnXpvDbV+ASL6sPvjp4
         V1TGGNXnTRmkD5Il95nbhJQx6Mo5XHTbp/R1+Z2XkwMPAwvizKEiMH8o/vq03J1ExQgx
         6wOwul6ue6R/VU091fCQb+RPUEAlCqyMoWwJMfbIWA+PvUznpqCJPJPco8TZ/aYxikik
         mNg//VmsW2YpfEGJ5swqjMxwlouqmUv7KfL9by0U0DfnGS8IoO1vqub7EXex2cftSLEH
         zEsYxLmszuTF1TKUgPUGacgc7HNQqayEKvPSNZ10Xq2BPcX0gIUJii/aMKx/TONc4lMB
         BaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692218231; x=1692823031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jGuo32BcwZ4xrip9OSKVN8CRZpvzjsNQ0WOCuGvqoo=;
        b=bUe8k5LynsrRL9I+7WsdsnkpPuisPvu6ttu4Cfrd/A/X4Ul1Vomd0JJSmtnDFvoUra
         PxHWcTiWGmllaoN0tWIqWJR/ZwabQgAber57mdLWzUIRU9zFCNOUg59iRpGT6p+fEzlR
         BgfA6ey9GXdFfixqkOnMB/k4KGxFZqkwCFLbHbFjGb5lyKM3v/h8wl5obYK7T32QyXvi
         v+VzjalwJUBuHAydHwdnKU+iyZvmBIFAKcby/1GWn3SCN69FTfPoT8OhaxeLWIQXBirs
         wbYMfeOD6qVSgyD3PM4Yj0O5XRZS9CV+IeB8oMCdVSvIywYU//JrVsdyUpfD7A6CsUR3
         /W/w==
X-Gm-Message-State: AOJu0YztDkDAVXvACDdV5vl8+YcpY5/PcRxtIow6KkzQrMibRBMRULoX
        +QFRhaaT6dSicUyOqtNnZ6A=
X-Google-Smtp-Source: AGHT+IFueect6CxNlrZ/Gbgac9xxnV2DHvFL3lOI6qtByKzkkLJhbDn1orqcbqpgFUNsfejd88MaiA==
X-Received: by 2002:a05:6a00:418f:b0:668:8596:752f with SMTP id ca15-20020a056a00418f00b006688596752fmr2890359pfb.4.1692218231115;
        Wed, 16 Aug 2023 13:37:11 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id u9-20020a62ed09000000b00686ed095681sm11421006pfh.191.2023.08.16.13.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 13:37:10 -0700 (PDT)
Date:   Wed, 16 Aug 2023 13:37:09 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6/8] KVM: gmem, x86: Add gmem hook for invalidating
 private memory
Message-ID: <20230816203709.GA3561043@ls.amr.corp.intel.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 10:18:53AM -0700,
isaku.yamahata@intel.com wrote:

> From: Michael Roth <michael.roth@amd.com>
> 
> TODO: add a CONFIG option that can be to completely skip arch
> invalidation loop and avoid __weak references for arch/platforms that
> don't need an additional invalidation hook.
> 
> In some cases, like with SEV-SNP, guest memory needs to be updated in a
> platform-specific manner before it can be safely freed back to the host.
> Add hooks to wire up handling of this sort when freeing memory in
> response to FALLOC_FL_PUNCH_HOLE operations.
> 
> Also issue invalidations of all allocated pages when releasing the gmem
> file so that the pages are not left in an unusable state when they get
> freed back to the host.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Link: https://lore.kernel.org/r/20230612042559.375660-3-michael.roth@amd.com

Somehow I used the old one. Here is the updated one. The change is the argument
for kvm_gmem_issue_arch_invalidate() is struct inode instead of struct file.


From e14483943e2ab6d8a0e4d00ea903509595847aa9 Mon Sep 17 00:00:00 2001
Message-Id: <e14483943e2ab6d8a0e4d00ea903509595847aa9.1692218085.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1692218085.git.isaku.yamahata@intel.com>
References: <cover.1692218085.git.isaku.yamahata@intel.com>
From: Michael Roth <michael.roth@amd.com>
Date: Sun, 11 Jun 2023 23:25:10 -0500
Subject: [PATCH 6/8] KVM: gmem, x86: Add gmem hook for invalidating private
 memory

TODO: add a CONFIG option that can be to completely skip arch
invalidation loop and avoid __weak references for arch/platforms that
don't need an additional invalidation hook.

In some cases, like with SEV-SNP, guest memory needs to be updated in a
platform-specific manner before it can be safely freed back to the host.
Add hooks to wire up handling of this sort when freeing memory in
response to FALLOC_FL_PUNCH_HOLE operations.

Also issue invalidations of all allocated pages when releasing the gmem
file so that the pages are not left in an unusable state when they get
freed back to the host.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Link: https://lore.kernel.org/r/20230612042559.375660-3-michael.roth@amd.com

---
Changes:
- Use struct inode instead of struct file.

Changes v4 -> v5:
- Fix compile issue by adding static inline when gmem is disabled

Changes v2 -> v3:
- Newly added

KVM: guest_mem: fix kvm_gmem_issue_arch_invalidate()

Now kvm_gmem_issue_arch_invalidate() takes struct inode instead of
struct file.  Adjust argument.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  6 +++++
 include/linux/kvm_host.h           |  3 +++
 virt/kvm/guest_mem.c               | 42 ++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 439ba4beb5af..48f043de2ec0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -134,6 +134,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2bc42f2887fa..17e78f9f2d17 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1735,6 +1735,7 @@ struct kvm_x86_ops {
 
 	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	void (*gmem_invalidate)(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index de195ad83ec0..b54818d02cb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13274,6 +13274,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+	static_call_cond(kvm_x86_gmem_invalidate)(kvm, start, end);
+}
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 091bc89ae805..349b0bf81fa5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2358,6 +2358,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2366,6 +2367,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+static inline void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end) { }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index ed03f1d12172..13d6dab08f87 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -127,6 +127,46 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 	KVM_MMU_UNLOCK(kvm);
 }
 
+void __weak kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+}
+
+/* Handle arch-specific hooks needed before releasing guarded pages. */
+static void kvm_gmem_issue_arch_invalidate(struct kvm *kvm, struct inode *inode,
+					   pgoff_t start, pgoff_t end)
+{
+	pgoff_t file_end = i_size_read(inode) >> PAGE_SHIFT;
+	pgoff_t index = start;
+
+	end = min(end, file_end);
+
+	while (index < end) {
+		struct folio *folio;
+		unsigned int order;
+		struct page *page;
+		kvm_pfn_t pfn;
+
+		folio = __filemap_get_folio(inode->i_mapping, index,
+					    FGP_LOCK, 0);
+		if (!folio) {
+			index++;
+			continue;
+		}
+
+		page = folio_file_page(folio, index);
+		pfn = page_to_pfn(page);
+		order = folio_order(folio);
+
+		kvm_arch_gmem_invalidate(kvm, pfn, pfn + min((1ul << order), end - index));
+
+		index = folio_next_index(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+
+		cond_resched();
+	}
+}
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct list_head *gmem_list = &inode->i_mapping->private_list;
@@ -143,6 +183,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
 
+	kvm_gmem_issue_arch_invalidate(gmem->kvm, inode, start, end);
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
 	list_for_each_entry(gmem, gmem_list, entry)
@@ -253,6 +294,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+	kvm_gmem_issue_arch_invalidate(gmem->kvm, file_inode(file), 0, -1ul);
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	list_del(&gmem->entry);
-- 
2.25.1
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
