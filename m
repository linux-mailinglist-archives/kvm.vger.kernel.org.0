Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC57E603473
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 22:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiJRU7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 16:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiJRU7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 16:59:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC180F6B
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:58:58 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x16-20020a63b210000000b0045f5c1e18d0so8599114pge.0
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dm0BAJRXbXrs7kBcZp+dxeyPGUHjPB12rWArnLP7msg=;
        b=YF5VeFDyNQJ2ym8Y57EPDOEDneGD4XW9dGLt9NeoeMOFKRBStFaGBkpzLuIXnhrTct
         bFMMNIywz3eMLsi027WLwkml7N8AyUIDWSsdQ71xnTB3lclRIIJTZElOQJ3u5+uci4wM
         HffV50ggDKpdmFDKqClp0HneDe6g2Yq13ulSWP3AI6XpAHnjWln5bE0NWeGYDiHEnONB
         tUGhWPphmBjlL6y/JjPRQKod8MY4Le7inveQ2BSMPyrMLe9A3wIzJ5RifwreZJSiIYWI
         EsN41+348W/E7vAZ+gJ6SzsGkCRP4NtAzBVCrDNazMXZzRhmVNMaH60LlZHWLMaBcAEE
         oADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dm0BAJRXbXrs7kBcZp+dxeyPGUHjPB12rWArnLP7msg=;
        b=Es4wCyauelo2UpwscSg6DV6BxXlhHG6Q1/EW6Pd3KLQ1axT+zpqLfiWBHzz4OGYVL1
         7vS/IPi+clBriK2nNSfydpyi9Hpp30CKp44ubWAE4Qtn8ZgzKp0qGYXCTZ8tUxFffygi
         SmYuQMW2T+xrDM+FR3ikyVqzW8f2jxBwGbCl/Ae704UhhWtTVpWHDGjEdyQx1m0nxv0P
         4srDW6afEg7fqh9EIN6pheah/hQvbZThPl3F2jNdsaXoTmRP1vTVMXJWXb1EFwWtNwfX
         sNJ0/Y5ylqFmw1jmG03S1+UJjkAbIGEgqvOSfYSdlixcQSO2C8VHBfkGCuAjxRJSqnAe
         xTvw==
X-Gm-Message-State: ACrzQf2UtSjNwKnC/3BYjOy5AmDk43xXOrhYLqIl3cMNffXsFBvxPQuD
        Iu5KI8o4w/Cn73BB69ErmmgNgJKa2LtNdpVuglAsz6u7FyBFCjTg55Ca4c9b5p74p23tp6AOSC7
        /ArKzstCONIMwDwWySZmn3JIc/oehtB5Gqq3FFsdlPOlBYB5f9XXI1Yr17w==
X-Google-Smtp-Source: AMsMyM4bN8Kqx2uShoejSxlwnoxLYOC7KdUTaiMpnxodnGGwlEJcjoeZysq9k/1jYqwTese+ALAv6ZlPXLk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:c89b:7f49:3437:9db8])
 (user=pgonda job=sendgmr) by 2002:aa7:8e8c:0:b0:562:a549:efc5 with SMTP id
 a12-20020aa78e8c000000b00562a549efc5mr5126346pfr.20.1666126738024; Tue, 18
 Oct 2022 13:58:58 -0700 (PDT)
Date:   Tue, 18 Oct 2022 13:58:40 -0700
In-Reply-To: <20221018205845.770121-1-pgonda@google.com>
Message-Id: <20221018205845.770121-3-pgonda@google.com>
Mime-Version: 1.0
References: <20221018205845.770121-1-pgonda@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Subject: [PATCH V5 2/7] KVM: selftests: add hooks for managing protected guest memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, pgonda@google.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm_vm.protected metadata. Protected VMs memory, potentially
register and other state may not be accessible to KVM. This combined
with a new protected_phy_pages bitmap will allow the selftests to check
if a given pages is accessible.

Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h        | 14 ++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c       | 16 +++++++++++++---
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c14d531a942a..625f13cf3b58 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -33,6 +33,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
+	struct sparsebit *protected_phy_pages;
 	int fd;
 	off_t offset;
 	void *host_mem;
@@ -90,6 +91,9 @@ struct kvm_vm {
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
 
+	/* VM protection enabled: SEV, etc*/
+	bool protected;
+
 	/* Cache of information for binary stats interface */
 	int stats_fd;
 	struct kvm_stats_header stats_header;
@@ -638,10 +642,16 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot);
+vm_paddr_t _vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot, bool protected);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+					    vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot, vm->protected);
+}
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f12ebd27f6e5..0ce5cdb52f0c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -595,6 +595,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->protected_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 
@@ -935,6 +936,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
+	region->protected_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1711,6 +1713,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			region->host_mem);
 		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
 		sparsebit_dump(stream, region->unused_phy_pages, 0);
+		if (vm->protected) {
+			fprintf(stream, "%*sprotected_phy_pages: ", indent + 2, "");
+			sparsebit_dump(stream, region->protected_phy_pages, 0);
+		}
 	}
 	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
 	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
@@ -1807,8 +1813,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+vm_paddr_t _vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			       vm_paddr_t paddr_min, uint32_t memslot,
+			       bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -1841,8 +1848,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		abort();
 	}
 
-	for (pg = base; pg < base + num; ++pg)
+	for (pg = base; pg < base + num; ++pg) {
 		sparsebit_clear(region->unused_phy_pages, pg);
+		if (protected)
+			sparsebit_set(region->protected_phy_pages, pg);
+	}
 
 	return base * vm->page_size;
 }
-- 
2.38.0.413.g74048e4d9e-goog

