Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6067676200
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 01:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjAUAQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 19:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAUAQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 19:16:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B27DBF5C4
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:16:29 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h136-20020a25d08e000000b007e1b1a30d5dso7411076ybg.15
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/APv3/dZy7Uqys8Jgj7g1WItGoK9cC/vyW/fiLSrtbM=;
        b=ZFdMejAyz/1eZEWr6CE1KV/fJwKp4C6f4WL5WtXgG88Np70btURm7pCninpSBJojSB
         KK4E1iX1M3bD1CrMEe4+TSvBz0j4p7sloEuWZiK9VTejKWAIi7iFN2TD2wx9bXQUiHIb
         +N9i7a3cCH8iuJMbmDKcH1m+HVakzAaXEoTeuCn1D4sqK0IYS60MuIdP8R8qi/dtoP6G
         shrtjQKccnaUQ32fGfOFnCMAJInqvLEq80PrMtih/PuI5gl5APa3sS9i9AwrKjFF9haB
         0dezXLc/gkEEnKcCbbPzFws3RnU+sOo817JJSWaDmG2u6vrvIAwWsroUE7nZMwqMaw4b
         tXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/APv3/dZy7Uqys8Jgj7g1WItGoK9cC/vyW/fiLSrtbM=;
        b=qnUqY8I1N6M6P7RLvFQdrYIjGsrCfliTIRPZN9jCM7TukRmctlWNYkqhrh1AhkfbdU
         BGiOzCQvZKC1XslJl6CekErngZzLD6TCV5W4TySRv5G+oKJtucD733Hcdwaoyivzds9Y
         9hJEuxe5+avxtpz4BkiSLrA9CfXyjioxlVPUuKjYac9i2rpKDIpa1+JLgpyI4G/K2Lrn
         6+qnq8xo3IcHU1rAcKtmt/dQ1GexPV5mleo3oiiSSEJrLGQuQqzvm3ti+Cht8ttS0OYW
         0pbNcs8EqcRWot9MyRYHX7AILqmAbXo6hYnjCUFHM8tcwEl5bKV/aXunOjw+yTv6jr4P
         Ut0g==
X-Gm-Message-State: AFqh2kriFKA99GJ/kIDqXC/GBPh00VhtTZyR/+cJNVJhBtI52N6ybmiq
        Bg0HWySaFk1dobX1yDujG72dNPtYMDJ9UPOyDQ==
X-Google-Smtp-Source: AMrXdXumVBpMD1wS8t96TrOMSwGj8T1nGqZGed5JUaR2MYkla7J53/4pjMUrQ09V611Z1bZNhJPET1aOdRMlceefig==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a25:2bc1:0:b0:7fe:35ff:fddb with SMTP
 id r184-20020a252bc1000000b007fe35fffddbmr791742ybr.466.1674260188336; Fri,
 20 Jan 2023 16:16:28 -0800 (PST)
Date:   Sat, 21 Jan 2023 00:15:15 +0000
In-Reply-To: <20230121001542.2472357-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20230121001542.2472357-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230121001542.2472357-5-ackerleytng@google.com>
Subject: [RFC PATCH v3 04/31] KVM: selftests: Store initial stack address in
 struct kvm_vcpu
From:   Ackerley Tng <ackerleytng@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, marcorr@google.com,
        eesposit@redhat.com, borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX guests' registers cannot be initialized directly using
vcpu_regs_set(), hence the stack pointer needs to be initialized by
the guest itself, running boot code beginning at the reset vector.

We store the stack address as part of struct kvm_vcpu so that it can
be accessible later to be passed to the boot code for rsp
initialization.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c  | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 0fa4dab3d8e52..cdc204cfeb4c2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -54,6 +54,7 @@ struct kvm_vcpu {
 	int fd;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
+	vm_vaddr_t initial_stack_addr;
 #ifdef __x86_64__
 	struct kvm_cpuid2 *cpuid;
 #endif
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 1bb07d3c025b0..3046b555fee49 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -673,10 +673,12 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_setup(vm, vcpu);
 
+	vcpu->initial_stack_addr = stack_vaddr + (DEFAULT_STACK_PGS * getpagesize());
+
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
-	regs.rsp = stack_vaddr + (DEFAULT_STACK_PGS * getpagesize());
+	regs.rsp = vcpu->initial_stack_addr;
 	regs.rip = (unsigned long) guest_code;
 	vcpu_regs_set(vcpu, &regs);
 
-- 
2.39.0.246.g2a6d74b583-goog

