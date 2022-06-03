Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C650A53C231
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbiFCAqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240215AbiFCApI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C1A2251B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a65624d000000b003fa74c57243so3040978pgv.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=i7TyyG/pheXHSCAMN2TUl4WUF9LIX1YQpLdcH3B6/rg=;
        b=eJHqEVN5MVelv00NchUI0BZIRKsIQEv+Gq5cslmQpY1sO4avZyHI3M7BGccJ4bc2v1
         uF2dHcPQ5MyodQd9CXrbG5uM3Ox4lGFumLtbQvHC6RwQGOY1NBa12/UAnm8piJVm7KaY
         UXPMv5N1VuxcsE0aMrjRjlhYsuFuTdzcc1GfWt2QNUZ3FauIW5IhIgBSMAFShkYrlXS+
         qoF+E6r+YqUpk+FhMgXmV5bOoIbO7579xy9C86hUmv05OZuf4O6SNbWv2g8jN82dnsQf
         khWPyTKs6wLo1jMEAmr2eCUu44cQXo6FHEYWFJ3ZUB/735moyDSrttQWG92u4iEZEjoX
         ON+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=i7TyyG/pheXHSCAMN2TUl4WUF9LIX1YQpLdcH3B6/rg=;
        b=qK9+wybBUqoBDInabnqD2+hQoZy6Y8JOp3b49pmmVT2JvhJ7MJ32rdKPpZa3VBbPJ9
         Q40OUPGl2DxNtu3wazN5cxiLPwgQjuCSPN/hJAXUv7BeiTkSDMo7sgGD4gYrvFHi7u+7
         EJZ8uXRZICBd9Y2dXBK8WbZHMrcQqWHrtHvikcCAbB0xn9dU8sHk1IaLN2jxWbKcPSPW
         N4CUuxszKLBF1+CAu4Xorayt9QQuS4yzACQ2DgDukyUAcgQuaEmfjMS95vDlGphyzm2G
         Eqitf+JHCNvg4hXu1jAkGpHlnARkucNRmFWVd+LwHCOe6FX9nHDp2UpXSAi7BUUDHvgI
         LTHA==
X-Gm-Message-State: AOAM5311n8JrrZeeCcijz5BHW/vVnheAKwfCESpFNinhWd3Qv1JMQq/A
        Rpu0yTPYE+6g3BAF4jxshElBJKcdezg=
X-Google-Smtp-Source: ABdhPJzgBie8tvjnKymUCzbRf0t4xAGfUMFR246RyJ+7kX0YkbRNxZRAdC7zg2eT+LI69mCB8QeX0/AJNcI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9891:b0:166:496a:b44d with SMTP id
 s17-20020a170902989100b00166496ab44dmr3892350plp.13.1654217106370; Thu, 02
 Jun 2022 17:45:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:56 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-50-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 049/144] KVM: selftests: Return the created vCPU from vm_vcpu_add()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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
index d2c7fb391fc7..fbc54e920383 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -324,7 +324,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
+struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 99d6c5a8659e..8348fa19690a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -397,8 +397,7 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 {
 	kvm_vm_restart(vm);
 
-	vm_vcpu_add(vm, 0);
-	return vcpu_get(vm, 0);
+	return vm_vcpu_add(vm, 0);
 }
 
 /*
@@ -1063,33 +1062,23 @@ static int vcpu_mmap_sz(void)
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
@@ -1102,6 +1091,8 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 
 	/* Add to linked-list of VCPUs. */
 	list_add(&vcpu->list, &vm->vcpus);
+
+	return vcpu;
 }
 
 /*
-- 
2.36.1.255.ge46751e96f-goog

