Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4260C4E5B82
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345338AbiCWWzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241390AbiCWWzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:55:50 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD208CDA5
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:19 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o15-20020a17090aac0f00b001c6595a43dbso1796516pjq.4
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vKLQzM6klqpkjmFS7GU8Jq/66Sy+Fcb5x77LNB4tmdY=;
        b=T2r1Caf2OJOtk5scJPySOp/9x5bj+Apl8WHaB3jSMoOIz1MKaQBurKnGDjtE5j7HIZ
         9OzExFu8pSpHjGFZCP3Cuj1ybKmX1oCev7O7tSC+rgrYeVIw8Tr3sNK35PzvXat/KSR9
         dolxuhItD4Ol+BlA6VIzVmvkJT0NxWvmxp88V7/W1lTGTKFLRyWtGRd2iEMSN5A9yy2H
         Seddhj/2HySTBw0pKeLTmrJNHMvXNP+/FAmkaEkHGZlS45r7/IWEwWw6nH+c7krdYanH
         JOCd4/NjP0nSTfd43jcxEdgU+kxdHjcnaruKZsOp4e5k8y/vNSOOSipI3Y41Bg2nBs6n
         bCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vKLQzM6klqpkjmFS7GU8Jq/66Sy+Fcb5x77LNB4tmdY=;
        b=0SGyQqWau2M0BuFyU09G5ltwDwTdQiIJJNN1XSNaue9EzFIj3fhN4keiblCTyl+JDn
         fLp605pfRcF2xu9LDtcQgonyjrlzUXRrbY2aFbfPUikUwPVKX/CWT9uMrylY/QIbgibC
         Ls9j4mKRqklxcmxmeUbe+szUi7x7y/LtXWdvYtCxgiTADymE94Ric6E3cYd2rLII5iZk
         vkPvt8eKy+Hd9+qIQLI7HSFUw2/pl8GP3U32OZwYv7GA29OTWZ/L/5dya5R6TjBYIeOO
         bKt4Z6s1rn4BZ/eYufJbs2zlQXS3dLIyeityqlYcCn4/egU1qhEqWjYF7tczgUPx12B6
         K0cg==
X-Gm-Message-State: AOAM531kkDIRk9XmnKCOr9rue0x+BqJ2NOIEnJE3YQhptfxKCRTxYw79
        yQiwfWDLcflauIqZuYBvagd6H0MxWNpUr/iQsnJ+HoqLf5/N732kGSyY2M9MMWx7UjAZNzvSCKr
        xct/QFhRYW21ZiP2muS/3HGxGT0vZkrTNHRghnHvr0XSVc41zMYtHrhEBYaWuy4U=
X-Google-Smtp-Source: ABdhPJyAZxVTIQwmd51afsdptnZnXVDyKJtPsBQk9LT1jHkerS5r8cmHIz4Q/xt8p3x6a0B6SZillADFV5BM/Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:8bcc:b0:14f:2294:232e with SMTP
 id r12-20020a1709028bcc00b0014f2294232emr2362408plo.105.1648076059147; Wed,
 23 Mar 2022 15:54:19 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:54:00 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 06/11] KVM: selftests: Add vm_mem_region_get_src_fd library function
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
2.35.1.894.gb6a874cedc-goog

