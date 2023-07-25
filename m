Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35F0762568
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjGYWCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjGYWCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:02:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BAD213E
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c79a5564cso2573888a12.3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690322512; x=1690927312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2LFI4LFbO9Za9GYdKLk7QvU7CpMUS45By27lNDC3GjA=;
        b=uciYcUscCG6H+67Jcmkbc5V2n9+VZ93bLtIW814gvYmube9sijgHq2d2+fhAFg6N1t
         Dw4e/msB58FhRlaEDW6If1180OsASchae1hL8RG8Jlem0+vo7hC/bEDYlzLHbT5J7xru
         CI3Y9RFVPoG/mQEzEtMXSmWvBfZBr9P5M/FCdiUrv9f7yKBdMi1yE2lbKEebb/8QZrY3
         Sd/n6X4t+tTakMnoxsxynC3E0aJNnw2nV7YVVD5gYjxSjF/Cxreuub5mjDYW8pyYp/4t
         lw849iyeLf7Y7QA9iS63UcnFz3R7IDBAOt0z3hD2XdzVMNzbYny5txH8dWGWJQ7IIJKN
         rWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690322512; x=1690927312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LFI4LFbO9Za9GYdKLk7QvU7CpMUS45By27lNDC3GjA=;
        b=NS7FDvBWdWMZ2X9flzNpJGJm5iy17OuCQHxZkniPZKCDZjbjADIBC1WYqiIicP4HH4
         vvrVqc3NNbKtlHL8vEPqb37K0hx9GZewG2Kw1x7UCOtABdoJCqr72U0LdUNq+xWjUgju
         sqKjrV54jBfFIoOiCUAGUpGXREnUe3ajOMufqG/bOpkLsNnha3+8dq0h+bVIonaQV6m8
         tFknSaul3hTw3TwrRDXmPT/ibzul4n5kWHz+FwYc8u+epva8Zz1ftBNIGKIwzolJYLio
         4NvDiJaa6WhO8W3nb9W5t9DNQjqt6DndSOxo1KnqpyRb0D3J34b+JUZH/1nsYlvID9Am
         wiqg==
X-Gm-Message-State: ABy/qLYxa1+k9oWypUiuXbz7hbKwnHU97Cqrc3Uc4G/odw6DRrHesSqo
        3J7T7SyHNTBAe+DSvsyZbghVoZqcCsWv
X-Google-Smtp-Source: APBJJlEPI23MF32jHIZQ2ZRj8w4W6GxwOZ6bYhBqAkYrdYYyI9q1X89KcpwA0MZlRaLNL9IvTnS+4zGIWWHr
X-Received: from afranji.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:47f1])
 (user=afranji job=sendgmr) by 2002:a63:3e82:0:b0:563:9e04:52b with SMTP id
 l124-20020a633e82000000b005639e04052bmr2658pga.6.1690322512106; Tue, 25 Jul
 2023 15:01:52 -0700 (PDT)
Date:   Tue, 25 Jul 2023 22:00:56 +0000
In-Reply-To: <20230725220132.2310657-1-afranji@google.com>
Mime-Version: 1.0
References: <20230725220132.2310657-1-afranji@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230725220132.2310657-4-afranji@google.com>
Subject: [PATCH v4 03/28] KVM: selftests: Store initial stack address in
 struct kvm_vcpu
From:   Ryan Afranji <afranji@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, eesposit@redhat.com,
        borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ackerleytng@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ackerley Tng <ackerleytng@google.com>

TDX guests' registers cannot be initialized directly using
vcpu_regs_set(), hence the stack pointer needs to be initialized by
the guest itself, running boot code beginning at the reset vector.

We store the stack address as part of struct kvm_vcpu so that it can
be accessible later to be passed to the boot code for rsp
initialization.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I54e7bde72c5c21e7d8944415ac5818d9443e2b70
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c  | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a07ce5f5244a..12524d94a4eb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -67,6 +67,7 @@ struct kvm_vcpu {
 	int fd;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
+	vm_vaddr_t initial_stack_addr;
 #ifdef __x86_64__
 	struct kvm_cpuid2 *cpuid;
 #endif
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index e3a9366d4f80..78dd918b9a92 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -607,10 +607,12 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_setup(vm, vcpu);
 
+	vcpu->initial_stack_addr = stack_vaddr;
+
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
-	regs.rsp = stack_vaddr;
+	regs.rsp = vcpu->initial_stack_addr;
 	regs.rip = (unsigned long) guest_code;
 	vcpu_regs_set(vcpu, &regs);
 
-- 
2.41.0.487.g6d72f3e995-goog

