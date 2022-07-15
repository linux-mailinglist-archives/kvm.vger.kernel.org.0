Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C5257677B
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiGOTa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiGOTaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:30:20 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4B95B04A
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i17-20020a170902c95100b0016c449584a9so2473536pla.1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gs77UXlDczSHQF1pVGrbWwFBLbmSJeDP2KCTQVzhQ4w=;
        b=Yho4pa020PJOurbSFO1drfQJF8CGNLTiZXlRmYL31dZYBSt+tcx8ZXb+XDmvhx+yuk
         xUrMgnZvQ1eoy71kjdUfS7R9okqDtcQG1tDz/8NT+o/Pf7PRvwwnc58MstW9HBu5oFMR
         GO+Ee4Jklm816guSzjcyAJPAhWGAlppS2F4kCrrJPdmmGnqi2cjtbI3RSZy1ysTPXyWa
         FPrmrnLYXzMnv8hTN4ylaHNP4o5oOuyeOFrgSdbTWWkbsiWbvPHnQmjh1jGpF67Pitdb
         TQGz9J0SXIHYAGX+RNnZ+vX+cGAG2zO80d4uH+bftxTHinhgpC3v0ufO/BhIOC9gjWyh
         ZyHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gs77UXlDczSHQF1pVGrbWwFBLbmSJeDP2KCTQVzhQ4w=;
        b=f+liBFPdltI+OVlboc14R08GCmlbub2cqa6hWwjUJGZkK7EGqcxYAVjfupXk0jMu+c
         Alk2pIw78qaRQU8fsCmmaPg20xFfNjN5EoHgShtit6NtOX6t3QCKm5WB/Aqac5apUP7n
         7/u4mTEpFtUCgItxoJNNRL6bDzUfXoh8Vb1T4B3GyybgmVDMwJAdyrPBAzacd4dCRAp+
         dl7zx6Mvlte9lWLg7TmgrAF98e4Hp3S9eb+0drGTOnrG1px2KikpOHx29aXDHOz1VR4e
         MNBIjEGOxnrPSEikpfEE9puy3xMZreTV+gRnILBkAIGxgMgGk0XuQAcJ1/92uZxZgrZU
         0p9w==
X-Gm-Message-State: AJIora9btVyZ2XndTZ67Vzy878j1Rewenh6ivXcAnLbAzrfCfR45zyOh
        pgCIGoHEG2ZtvcS2uF5VFgaUFSVohdo5l4l7TbxGX+MllKu+liuWKO9mJErRgsRAmW6GHT/zH8D
        XDmetoUbO9YmbONDdHOrABS0cIJ4z829UgD5feG+gRP0Rv5qAIx2M0Mc2zg==
X-Google-Smtp-Source: AGRyM1vwMHvTQkuA7wCpNxdf75a2AjYo/3WibRk6QtD/vo0CRxXVclkLhhGPrsj0ARzMPa5/MUI93HQ7DjQ=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a17:902:e5cf:b0:16c:413c:fbfa with SMTP id
 u15-20020a170902e5cf00b0016c413cfbfamr15226411plf.80.1657913416653; Fri, 15
 Jul 2022 12:30:16 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:51 -0700
In-Reply-To: <20220715192956.1873315-1-pgonda@google.com>
Message-Id: <20220715192956.1873315-7-pgonda@google.com>
Mime-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 05/10] KVM: selftests: add support for encrypted vm_vaddr_* allocations
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
index 17eb5fb70867..60b604ac9fa9 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -387,6 +387,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5b473a8c90ae..17d9a2606cc8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1250,12 +1250,13 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
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
@@ -1268,13 +1269,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
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
@@ -1295,6 +1298,16 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
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
2.37.0.170.g444d1eabd0-goog

