Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75435587218
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 22:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiHAUMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 16:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbiHAUL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 16:11:26 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49493D58C
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 13:11:22 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id b4-20020a4a3404000000b00435e23d0402so5744027ooa.11
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 13:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nouhbkEBQaXXZRevsdiBE4K2DIHug6QazBMSfiyVtkA=;
        b=QpU+S4SyeeceQeGnoPfDWTgOMWQlkO+pE9fwKczKrSecXMTRkELwDQq9KskJe3g9cC
         chLUygz63+HHZZCWzmLQr3RrdHmwtJGWj+fEiEj8JBw31Dc8DAZ/nRnqToQx8+j/Xu1m
         4BdEa7iIPPQY5S0NQ59goxvJ9L1CyvEHnwACclIVZh+4LXLtHqo4jvBd1GH35LZqEkKH
         ApinryPLJF8P+/x75olOpYJQXBFniwDIwuAPyFqPdfBqYuQOX5za4rPhCbevt/OhETxy
         PjOuGB0E+bPeEx9kqPhXGm2SOzeKJ+IJUBrKxYGj2N72HzWeD7K+sY6pH7Vrdi2S9Wyr
         6upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nouhbkEBQaXXZRevsdiBE4K2DIHug6QazBMSfiyVtkA=;
        b=MUR1pElSuwgKEYgRH2adr8Ueuyq81SQIYlIEWOYqVhVmuXjrXZKHfQHv4lHmdqF7mV
         65JPLa5/Erqi8cDtEr+Z27FscMlDrLCV1WF5CIyXNanCTyzgkP4vim1QaQYUSpAAaBcm
         JQD8E/QoeXCIz1/NRAQl7kApBoX6F8tww3cMwaA/MGa/nF0uUrABC6pOgGwtm/O1rSVD
         vD9RYYmxBe6d4BrsH9pRvsShhZbeKsTk6mGH+POmhSLi6pmTas8pWuIRhuOfQZTtDZre
         dBjMY58m/3BcYrMCn7QitdU+vTOwnVVi/ZML7A/dJ0qRv4XmCookobLDYc0eid/TWHx6
         J8dw==
X-Gm-Message-State: AJIora/dlKf0AZH91Qf1u49wVxMUNXaPvKcG4m08Jw+Z1Ic9gG5hEdkP
        ghZh28lg49isU4hOfTc9e/JX9arOi4ZLd0MDTWJcg0u76LkZVKa/bPtoLsxHkEVGAfPggsrrXAN
        Y/+fDB7rzn8NB2MGtU2wlPtQP7D5TAYwYYzSy8yDUtBvSd9U+YmXQf8QjnA==
X-Google-Smtp-Source: AGRyM1t0mhJ5n97CC0mgfG86Lrv8IBimidKgHVeKvd1e+/vRW2j7YDmakiFshi3Q29qMWm7HQ3kwk5nqRq0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:6be2:f99c:e23c:fa12])
 (user=pgonda job=sendgmr) by 2002:a05:6870:15c9:b0:101:cdac:3887 with SMTP id
 k9-20020a05687015c900b00101cdac3887mr7699457oad.35.1659384681539; Mon, 01 Aug
 2022 13:11:21 -0700 (PDT)
Date:   Mon,  1 Aug 2022 13:11:03 -0700
In-Reply-To: <20220801201109.825284-1-pgonda@google.com>
Message-Id: <20220801201109.825284-6-pgonda@google.com>
Mime-Version: 1.0
References: <20220801201109.825284-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [V2 05/11] KVM: selftests: add support for encrypted vm_vaddr_* allocations
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
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

From: Michael Roth <michael.roth@amd.com>

The default policy for whether to handle allocations as encrypted or
shared pages is currently determined by vm_phy_pages_alloc(), which in
turn uses the policy defined by vm->memcrypt.enc_by_default.

Test programs may wish to allocate shared vaddrs for things like
sharing memory with the guest. Since enc_by_default will be true in the
case of SEV guests (since it's required in order to have the initial
ELF binary and page table become part of the initial guest payload), an
interface is needed to explicitly request shared pages.

Implement this by splitting the common code out from vm_vaddr_alloc()
and introducing a new vm_vaddr_alloc_shared().

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index de769b3de274..8ce9e5be70a3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -390,6 +390,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 87772e23d1b5..4e4b28e4e890 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1262,12 +1262,13 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 }
 
 /*
- * VM Virtual Address Allocate
+ * VM Virtual Address Allocate Shared/Encrypted
  *
  * Input Args:
  *   vm - Virtual Machine
  *   sz - Size in bytes
  *   vaddr_min - Minimum starting virtual address
+ *   encrypt - Whether the region should be handled as encrypted
  *
  * Output Args: None
  *
@@ -1280,13 +1281,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+static vm_vaddr_t
+_vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min, bool encrypt)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
+	vm_paddr_t paddr = _vm_phy_pages_alloc(vm, pages,
+					       KVM_UTIL_MIN_PFN * vm->page_size,
+					       0, encrypt);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1307,6 +1310,16 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 	return vaddr_start;
 }
 
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return _vm_vaddr_alloc(vm, sz, vaddr_min, vm->memcrypt.enc_by_default);
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return _vm_vaddr_alloc(vm, sz, vaddr_min, false);
+}
+
 /*
  * VM Virtual Address Allocate Pages
  *
-- 
2.37.1.455.g008518b4e5-goog

