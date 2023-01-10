Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885A06647B3
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbjAJRvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbjAJRvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:51:12 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A0950062
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id d8-20020a17090a7bc800b00226eb4523ceso4487657pjl.7
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/ZFh9sq8eKLeQlZMFZXYESJzlw0D4epBxstQ4Hl+0w=;
        b=rR5TD1mjo0BugUgy9sqDZFyRVIVwGuEeGnYm7xKUqLuXUVc8TQafnyYPuAXzjLTAMh
         Ug8YUjTavJkAx0fQ6WIOH85q9DqOrZo1okXl8+wkYcMNEvOOuefh4tWqZleatHTmgp9Y
         EKU9FpZSaxwalOJeNYpb6+r431FMJg9Z2kSP4qmAkupspAKncb6fAOAB7GRS6gXKXmZ9
         2KB83pbiJvBsAupmZDJPE+6HqDXC+q6tHrkOU00Ormku9OEAy3XWBPdWPG3kQN5cMsLg
         EAKYAvtAavH24d1GhAXT6E33D9sPiZ1oxeIaqv7/qwKfn7uUTUcAYxA7q8IME79XdL4P
         eKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/ZFh9sq8eKLeQlZMFZXYESJzlw0D4epBxstQ4Hl+0w=;
        b=DxfZL6NmZun4020cdNKkyIsmJuYwZSM9sICHv5AcDiyOCoZDs3+5tAlE+bkteKcHYv
         510zY1EJE4GiE/FEfT6Lwo1wBL38b/HQKgs6jenz+DrevA8Lo9hVO+dxHya1snuoYGip
         aUH5TcHl5ig24LFjfjIJiCr8IqRf3raA+wyTA7sUIby0aR4Rt1PtZx7kquxLM5KSWp4g
         bM+Pw3eJcmFikSVdX4cqfg/9CFSdnTGeFbm/90KK7ZglyMK0Uu/j1A1Y8zN2nepWzULU
         ckg+cVtYpmahstHo8kFhz67AHLegvzR+GPZ5Rmxo+P+GW1BW1LDvAuK5CyElOyWD/FrN
         FOuQ==
X-Gm-Message-State: AFqh2kpgXyGGJxDWhfSgESrcSmGZjisJ12XxbYu2mmgjDd69SauIfvGY
        gbwFtzhltF+UnM+e5Z3Y2HLR1YuRClYGlyp339jJl+6Ld3Vxb33H/cq9SGB0lKA1m/s1cMFqqj7
        xGQLGPJ4eQkCR35j0UJ+mPf3XWR3DhM5eALzDJ2mC6ChG8+2u9M06yFjj+w==
X-Google-Smtp-Source: AMrXdXsyttMZPx8tqmF+Qd7moE5dn1J+z7gT+0EhV/1swASMncnWRAXFxQugWRw51uT6uWTXMRq0N/Uu/qA=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a17:90b:2751:b0:219:baef:3c7 with SMTP id
 qi17-20020a17090b275100b00219baef03c7mr4090148pjb.57.1673373071520; Tue, 10
 Jan 2023 09:51:11 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:50:54 -0800
In-Reply-To: <20230110175057.715453-1-pgonda@google.com>
Message-Id: <20230110175057.715453-5-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 4/7] KVM: selftests: add support for protected vm_vaddr_* allocations
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

Test programs may wish to allocate shared vaddrs for things like
sharing memory with the guest. Since protected vms will have their
memory encrypted by default an interface is needed to explicitly
request shared pages.

Implement this by splitting the common code out from vm_vaddr_alloc()
and introducing a new vm_vaddr_alloc_shared().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f84d7777d5ca..5f3150ecfbbf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -435,6 +435,7 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_mi
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			    enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
 				 enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ba771c2d949d..0d0a7ad7632d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1305,15 +1305,17 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type)
+static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
+				     vm_vaddr_t vaddr_min,
+				     enum kvm_mem_region_type type,
+				     bool encrypt)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
+	vm_paddr_t paddr = _vm_phy_pages_alloc(vm, pages,
 					      KVM_UTIL_MIN_PFN * vm->page_size,
-					      vm->memslots[type]);
+					      vm->memslots[type], encrypt);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1333,6 +1335,17 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 	return vaddr_start;
 }
 
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, vm->protected);
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA, false);
+}
+
 /*
  * VM Virtual Address Allocate
  *
-- 
2.39.0.314.g84b9a713c41-goog

