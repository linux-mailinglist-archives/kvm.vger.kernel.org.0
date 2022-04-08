Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3314F8BAE
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiDHAnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiDHAng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:36 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA55C17869F
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d11-20020a17090a628b00b001ca8fc92b9eso3785737pjj.9
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ma205ge9BDOVMj7gZDxqTm6bY+KHnPOCZruDDJTsiDQ=;
        b=XdNNOy+Xf42B56zBTOagqhnkIL2gXF35sWD5D7P7s7jff+QGphla7l3EukkPSCLOin
         y57ixsuzrAl5CZiH4/eM6+jb6VFmpuz7ijMdbG82+JFA98iXGDE+0nabN/AdBig7OyzM
         FwttxRmdVs+dk2sBGidoWMyRKJX/6B+84LQpzH1Sdj0KDpzB2IdXX1LWXnnHlCc2rp5Q
         qTN1IWY7L3kXbPiMNb4wYaaUR3tXU7OWTrVtGTumt60ZVQcqcaQobGp+hYjPriXhciZ6
         HIkKnfTwtETqk1UYPo0Zk82c+mLcr6IMof2gV+2x/9G+1Yt/20zk2YI6LsEeKO+7+YjZ
         V5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ma205ge9BDOVMj7gZDxqTm6bY+KHnPOCZruDDJTsiDQ=;
        b=aNZwOh3CYhufw2vNsIRu7sRJcFTkw14ZHUBrk/EP+dKUIBshV35dFn5RaFY3w7M36w
         VvHc7493LO1h0OedjMO7zm/jbVDE+jnlQU77G3IjSOM35Bybv4YeUh3Hj4wZlVUjV5Sf
         pE+VcIwSdO8asLMBDPM//Om7KohlPw+VempM2Bz5RGAnGh8atAFWjJM+Iac7xxNN0Mjt
         Pm2XI8u8QOlkSqEIe0RkwZBZeN5WUKIoIZkVrtsWadDcgJOFvYeHOo8Aj+MzNyUg0GhU
         mfzycMXcyo/skC5oxqDLAlV0kyajER6EKRBbVJ/kkhBhxPqr+zQ4VlouttPlIjgZcHNq
         ta5g==
X-Gm-Message-State: AOAM533L94Gl1TJloc6+DEFAcu78mQK++1fgKHTyclamLvuiGJmMUYEe
        fQpHy9X/OAZXhpvowFtfP5AU5RKJVrXWvXCsLeaZpuS+dftwojwxszZyytWq1/avJVnK+/nSzco
        7IPsagJBAeG4TlVCfAEDhMBjhEnSasva+NFxBPRG6Xwtmu+sSsbEdTC3I2KI8Oa8=
X-Google-Smtp-Source: ABdhPJx/x/5ymStBVtSGKj7Xfm/crzv8lUGNkVJDDDCjk2nW2zm+u3BK3CB1mCfuw7JBEbiV1LYqYuZQsLSIEw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:20c:b0:154:b58:d424 with SMTP id
 r12-20020a170903020c00b001540b58d424mr16087633plh.45.1649378492864; Thu, 07
 Apr 2022 17:41:32 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:13 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 06/13] KVM: selftests: Add vm_mem_region_get_src_fd library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Add a library function to get the backing source FD of a memslot.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 3a69b35e37cc..c8dce12a9a52 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 268ad3d75fe2..a0a9cd575fac 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
+/*
+ * KVM Userspace Memory Get Backing Source FD
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   memslot - KVM memory slot ID
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Backing source file descriptor, -1 if the memslot is an anonymous region.
+ *
+ * Returns the backing source fd of a memslot, so tests can use it to punch
+ * holes, or to setup permissions.
+ */
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
+{
+	struct userspace_mem_region *region;
+
+	region = memslot2region(vm, memslot);
+	return region->fd;
+}
+
 /*
  * VCPU Find
  *
-- 
2.35.1.1178.g4f1659d476-goog

