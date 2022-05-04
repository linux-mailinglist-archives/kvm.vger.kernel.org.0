Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B37451B279
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355319AbiEDWz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379515AbiEDWyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:20 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C5D2C0
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:43 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id a23-20020a17090a6d9700b001d60327d73aso3556955pjk.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=G4ZX0Log93RwEpV4IdM/MtOoP7++p5/8Pg5nP4hU55M=;
        b=QPpmCUBQcK6yP8h9FvLVtqJgJb/X0s2qo2L0Kh45Ih4It/Skr0BY2GhjBAW75O8NZN
         XX3dfWEW2tq/ZrHL3uF/FXmc8R5DKKiVudOSKXSIgS8dEwWowUl8bnMBFrkVRAiX9gvH
         vaJRFFc0KUFCKeWahpDRxhrMRurgsmLFQJPTTjv/JqX5ON/agdL8tKjT5yumvjGcUOAN
         Jap13hAyqEYIustppUdlOXzU8+/4K8vLgVbsN6U8rbaUo+TAYVZ5An8DiyVqaWWHnVe2
         Tc0oI7jNMSZhOofDCxxQM1es6it50122dRfEJKE1ff6Ng6PdwqDUkCrZXVrvFhjnwTlC
         jEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=G4ZX0Log93RwEpV4IdM/MtOoP7++p5/8Pg5nP4hU55M=;
        b=w3vS6I/lCxG8SYRhD9kmjZXV9Rv0RXeMZix+5Fr79D1ZC7H+nbDzs5Gy+ymVNtDhKZ
         ljSW2KOwbMM5LiD3lkyuScXK9ue1pENmrB3832ywHhrrf5234b/o5FCuKNTccOnkiueX
         Z89WJExvCVhomjQVHDUGp9M13IhFAywbDs7dJk0YOwmXtn/g50cDg8RUlD4Ja1u+fTFk
         p2NLiLnx85DKmhPYWtC4NQzXLV/I6faxNWGx3jo1Egj/Xh3KJZVbkykC4l/THTWehhq8
         3V5S4uN9ed2zrJODrRFt16YgJBjGCNHdih6YgR37k1yDaZNyOynictxD9CjmU/PwrfYG
         qXnQ==
X-Gm-Message-State: AOAM5318G6NY42g4BtaTE/PV/j5flDHvF54+fwtoMrk0R7eFqMLkFgoS
        n8JsXHSckUvwl7l+Y7eLL26nCCxvyWQ=
X-Google-Smtp-Source: ABdhPJzV/Sr5AKvdGnNLQnGkCIr2E+ofxQsaTO4t0RpI4gxFAYCWl97qDea0QZIIog8rPl2KxQTvCRwS2PA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr139700pjt.1.1651704642439; Wed, 04 May
 2022 15:50:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:47 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-42-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 041/128] KVM: selftests: Return the created vCPU from vm_vcpu_add()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Return the created vCPU from vm_vcpu_add() so that callers don't need to
manually retrieve the vCPU that was just added.  Opportunistically drop
the "heavy" function comment, it adds a lot of lines of "code" but not
much value, e.g. it's pretty obvious that @vm is a virtual machine...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 27 +++++++------------
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index ca65771388e7..4487d5bce9b4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -316,7 +316,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
+struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 911869b350ea..bcdc47289df3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -401,8 +401,7 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 {
 	kvm_vm_restart(vm);
 
-	vm_vcpu_add(vm, 0);
-	return vcpu_get(vm, 0);
+	return vm_vcpu_add(vm, 0);
 }
 
 /*
@@ -1067,33 +1066,23 @@ static int vcpu_mmap_sz(void)
 }
 
 /*
- * VM VCPU Add
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *
- * Output Args: None
- *
- * Return: None
- *
- * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid.
- * No additional VCPU setup is done.
+ * Adds a virtual CPU to the VM specified by vm with the ID given by vcpu_id.
+ * No additional vCPU setup is done.  Returns the vCPU.
  */
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
+struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	struct kvm_vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
-	TEST_ASSERT(!vcpu_find(vm, vcpuid), "vCPU%d already exists\n", vcpuid);
+	TEST_ASSERT(!vcpu_find(vm, vcpu_id), "vCPU%d already exists\n", vcpu_id);
 
 	/* Allocate and initialize new vcpu structure. */
 	vcpu = calloc(1, sizeof(*vcpu));
 	TEST_ASSERT(vcpu != NULL, "Insufficient Memory");
 
 	vcpu->vm = vm;
-	vcpu->id = vcpuid;
-	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpuid);
+	vcpu->id = vcpu_id;
+	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpu_id);
 	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
 
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
@@ -1106,6 +1095,8 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 
 	/* Add to linked-list of VCPUs. */
 	list_add(&vcpu->list, &vm->vcpus);
+
+	return vcpu;
 }
 
 /*
-- 
2.36.0.464.gb9c8b46e94-goog

