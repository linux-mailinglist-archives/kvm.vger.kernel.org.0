Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D863B0E25
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhFVUIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhFVUIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:06 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523F3C061760
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:49 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 100-20020aed206d0000b029024ea3acef5bso393203qta.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=h9C5XJrlV2du+jCCBdcRQqIsaVMGFR3Dp5ea/2spNSQ=;
        b=UjMTXaf8mt8UkwYjdrw+LgfbwFyyDmQCiDkXS53dXKlGLwZOe73fPx2LJMncbTXdUb
         PGK+ik25J0KwWlQ26yuleHd5XyElHG2pXtZYklS/gZxRS22JHWfZSsYxncotklmxHq4R
         LHTsZ00X64+EkUBE/Fdd8H09i5nbXWU3FMEyQEpmmynWZI8FfQJxWaw4NYS4Bje7hKOl
         i9RgQyNXw80fYXDMM+AU2UyyYMc/zwXnIGEpEAvevvDqlRlnYpcCgou1t5W61OfVI/II
         agVlxyR5aOK7P2RbLOcJRCzuPVqeZz0DCJV5oo0MDqlx/fhkUC51eoi7JXGU/TPPQBIc
         1h5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=h9C5XJrlV2du+jCCBdcRQqIsaVMGFR3Dp5ea/2spNSQ=;
        b=cubAbPcZrsVTqnD6JKTCo0PHV3ynLvpNQ71YMLrwJ1fEqijJDkyhrorbEUUt1gtaag
         +7Rcjmk7uF9Xn5hHIBEpB0v6PUu/PQTWcE/vAV1oX5Tqs23kNJaTpuEVbBj9VF2EH6iz
         JOVCuNJR2t0C3O/HBJiMmJv+m3fKDnt06gk92xINEvIR9S8Gs1bjqzCT2J9UkDPkE70a
         fd25C+dLeiycQo9aUJbZT7xP0WWDXQPV9BaUAB2X0o5DE+/yxP5W9p0MvbijGKPDNZr3
         J0z+qudgYfgXT9jJjdh8vqrdg9hYfYJ/Efe251UjX1lqLNx/rxJQJqhDyC9zoPl4v2WN
         dRlA==
X-Gm-Message-State: AOAM5319Nj7bAU8wGH7YKsuGfSYNmsAAtLfCBjHVw5GlwLEch9U+p9kQ
        tIxC0PFca0P/wh/PoTLqQnJTbr8/guQ=
X-Google-Smtp-Source: ABdhPJwUDsBtaM8vjykTWRheuY39bqVHMFfaVuO6KB6eCVIep8NFoj7AA0sWQH0h7uOQaCz0zMDfgH/jrqo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:6f55:: with SMTP id k82mr7349655ybc.490.1624392348443;
 Tue, 22 Jun 2021 13:05:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:14 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 04/19] KVM: selftests: Unconditionally use memslot 0 for x86's
 GDT/TSS setup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor x86's GDT/TSS allocations to for memslot '0' at its
vm_addr_alloc() call sites instead of passing in '0' from on high.  This
is a step toward using a common helper for allocating pages.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c       | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index efe235044421..b1fb4c60dd73 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -518,24 +518,22 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	exit(EXIT_FAILURE);
 }
 
-static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt, int gdt_memslot,
-			  int pgd_memslot)
+static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
 {
 	if (!vm->gdt)
 		vm->gdt = vm_vaddr_alloc(vm, getpagesize(),
-			KVM_UTIL_MIN_VADDR, gdt_memslot, pgd_memslot);
+			KVM_UTIL_MIN_VADDR, 0, 0);
 
 	dt->base = vm->gdt;
 	dt->limit = getpagesize();
 }
 
 static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
-				int selector, int gdt_memslot,
-				int pgd_memslot)
+				int selector)
 {
 	if (!vm->tss)
 		vm->tss = vm_vaddr_alloc(vm, getpagesize(),
-			KVM_UTIL_MIN_VADDR, gdt_memslot, pgd_memslot);
+			KVM_UTIL_MIN_VADDR, 0, 0);
 
 	memset(segp, 0, sizeof(*segp));
 	segp->base = vm->tss;
@@ -546,7 +544,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 	kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
-static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
+static void vcpu_setup(struct kvm_vm *vm, int vcpuid)
 {
 	struct kvm_sregs sregs;
 
@@ -555,7 +553,7 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_m
 
 	sregs.idt.limit = 0;
 
-	kvm_setup_gdt(vm, &sregs.gdt, gdt_memslot, pgd_memslot);
+	kvm_setup_gdt(vm, &sregs.gdt);
 
 	switch (vm->mode) {
 	case VM_MODE_PXXV48_4K:
@@ -567,7 +565,7 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_m
 		kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
 		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
 		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
-		kvm_setup_tss_64bit(vm, &sregs.tr, 0x18, gdt_memslot, pgd_memslot);
+		kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
 		break;
 
 	default:
@@ -588,7 +586,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 
 	/* Create VCPU */
 	vm_vcpu_add(vm, vcpuid);
-	vcpu_setup(vm, vcpuid, 0, 0);
+	vcpu_setup(vm, vcpuid);
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vm, vcpuid, &regs);
-- 
2.32.0.288.g62a8d224e6-goog

