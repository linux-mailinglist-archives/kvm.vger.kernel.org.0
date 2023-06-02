Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DE9720758
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbjFBQUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbjFBQUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:20:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3C6B4
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:20:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb0cb2e67c5so2992408276.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722799; x=1688314799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4E8+zNfn1rJk8U6PDocth2WfbfjiLTYwf3mfdWaR2yU=;
        b=gWDsLQXMBko5cslhOYtYqHCyQkoSrIwxBgZlMhgc7PNFm+zEUTxO94Bb/6m4V/EXdI
         ttDq2ZVJ3U/LswNpYO7WaOvKJQ1mU2ohVzru4+1yqUgYvW05Z+rRWP5SJEurktQZ25op
         YB/K+hiuDlX+gtpUN/hQOEkjouBS4zjKnwcJCF/H7COoAVWeG5994D9XMONrga8GdVyH
         rJOrqLcrmwMzoWNdKHNiNP3fLnxHVzb0XhtEFp7916G+C9v60v5qYJjg15saFy1OKfe5
         fRnGlvd0yd/9HdwMa9oN9ANxKkQfA2K6mQOuAQ3dG+X4EysL8mmVa1H9MXxwN5Gef3Br
         rN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722799; x=1688314799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4E8+zNfn1rJk8U6PDocth2WfbfjiLTYwf3mfdWaR2yU=;
        b=iFmg2JHhGWCiFAvzF+W13jGmbkUO+e5D8X3nZymgDvBXdKIf6G493jITKPfElOa9o4
         t24h59VX0bkKa8ZqiW8doGfntk1UpnsYBDeB7Ckxk1eOdFTJxdGBI8ZAIZ/DQ8bxpt22
         a1iYLuShlb6KMmCZSvoT0WRQiOvf03hVGAfC9uFRCica43TUZ7/kX2DeUuffcdEvIKrL
         6dFHx0aP6c0lYftpC+a6nvUr0mdkkmahhzQJsy570VFx5zI7v4fNB7sg3PkZSGZBWXwx
         DAgQOV80NKuyqzIQbF8jIUaKYqGxFMEcB8VIlXMJ/1cglFsFJm0yNdarysZ7ODqnRzQ/
         M7zg==
X-Gm-Message-State: AC+VfDxjhVgGeUWdt3we+MPLtg2Em4v/YT1BCaFo4MZUwlIShWniNg3G
        Gco1dyj2OOEqnwTNv4Rn/ijgVOSvVoG27Q==
X-Google-Smtp-Source: ACHHUZ7IOKhrQkM5+thZOkEyj7PyCIBHPmI5OcHGabjfs9Y8mO4Rss5CHJYmBbwWqftwew9oXtBqqj0YAR1ilA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:e7c6:0:b0:ba8:8fad:c19d with SMTP id
 e189-20020a25e7c6000000b00ba88fadc19dmr1257767ybh.8.1685722799503; Fri, 02
 Jun 2023 09:19:59 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:14 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-10-amoorthy@google.com>
Subject: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation, memslot flags, useful helper functions, and the
actual new capability itself.

Memory fault exits on absent mappings are particularly useful for
userfaultfd-based postcopy live migration. When many vCPUs fault on a
single userfaultfd the faults can take a while to surface to userspace
due to having to contend for uffd wait queue locks. Bypassing the uffd
entirely by returning information directly to the vCPU exit avoids this
contention and improves the fault rate.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 32 +++++++++++++++++++++++++++++---
 include/linux/kvm_host.h       |  6 ++++++
 include/uapi/linux/kvm.h       |  2 ++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/kvm_main.c            |  3 +++
 5 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5b24059143b3..9daadbe2c7ed 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
   /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_NOWAIT_ON_FAULT (1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1342,12 +1343,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
+The flags field supports three flags
+
+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
+use it.
+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
+3.  KVM_MEM_NOWAIT_ON_FAULT: see KVM_CAP_NOWAIT_ON_FAULT for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -7776,6 +7780,28 @@ userspace may receive "bare" EFAULTs (i.e. exit reason != KVM_EXIT_MEMORY_FAULT)
 from KVM_RUN for failures which may be resolvable. These should be considered
 bugs and reported to the maintainers so that annotations can be added.
 
+7.35 KVM_CAP_NOWAIT_ON_FAULT
+----------------------------
+
+:Architectures: None
+:Returns: -EINVAL.
+
+The presence of this capability indicates that userspace may pass the
+KVM_MEM_NOWAIT_ON_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
+to fail (-EFAULT) in response to page faults for which resolution would require
+the faulting thread to sleep.
+
+The range of guest physical memory causing the fault is advertised to userspace
+through KVM_CAP_MEMORY_FAULT_INFO.
+
+Userspace should determine how best to make the mapping present, then take
+appropriate action. For instance establishing the mapping could involve a
+MADV_POPULATE_READ|WRITE, in the context of userfaultfd a UFFDIO_COPY|CONTINUE
+could be appropriate, etc. After establishing the mapping, userspace can return
+to KVM to retry the memory access.
+
+Attempts to enable this capability directly will fail.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 69a221f71914..abbc5dd72292 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2297,4 +2297,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
  */
 inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
 				     uint64_t gpa, uint64_t len, uint64_t flags);
+
+static inline bool kvm_slot_nowait_on_fault(
+	const struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
+}
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 143abb334f56..595c3d7d36aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_NOWAIT_ON_FAULT	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1198,6 +1199,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_MEMORY_FAULT_INFO 228
+#define KVM_CAP_NOWAIT_ON_FAULT 229
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 5476fe169921..f64845cd599f 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_NOWAIT_ON_FAULT (1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05d6e7e3994d..2c276d4d0821 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1527,6 +1527,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (kvm_vm_ioctl_check_extension(NULL, KVM_CAP_NOWAIT_ON_FAULT))
+		valid_flags |= KVM_MEM_NOWAIT_ON_FAULT;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

