Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3270353C1BE
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbiFCAqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240142AbiFCAoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0EE3465B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f4dfd09d7fso56496097b3.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=T3DLT5cYIGbppXKfmAUbAPCbbCg7OYuJUt00ahVxBVg=;
        b=BpsFlQd35xCU9fw8o7q3BAHgRloE+fywZA5txvGNVyl8seNxDNpCEmsHd86pY6gzpu
         9oyQhqdpQ6XAFvpdJ4sDmm6qPTQA+UhbqcpX7gLMVlwbysRQWH7IBpiacVsDkh4yu9DK
         oQMLdSHuEQEqq84Ak1n1AQPZhovQX/+S87T26oDLwVTV3e88HzlGcV+Lp1lYPj5NY4ii
         JInvcs+qCi8TYIdYJUoSH27bhMjfq/cuc35Ro/qQAMueE2OzS2z5UMzcknIwZxtr8H4X
         Rhu2sW7UAYVSvzWcwsRAU8V2Zgy6ab49LmUp/M9Wme4avbZ86Kx2dw1kEYTVDKk2bvIw
         e+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=T3DLT5cYIGbppXKfmAUbAPCbbCg7OYuJUt00ahVxBVg=;
        b=S8OmJqhJBhF4W6kfROT8hWZUZcAg7qZqoKDDfWwD+YOMrKIdBROyHIyLmxVKuuTtqe
         2z4hx+Qvi7LgOr0gnZDvlJklBEar9A2zGF+03Te/hPoMScH/j1IdpmpHngS8GuhuZQF6
         RyRIN+FfTy+MnlI5CgendwAnCmTcQMN4i5fFInwwQ1PAo+aV8E1vJEFCBYjQHAV0JT3t
         IZdN46NwgdTKGqvYF6kFxuhCiN/oGscX7yREt9jDOZOjjXy/YVeF9o0o/2dRUzYG27JE
         loBISls0IMdAsbxglIwcUS+ArxG5zdqwvHMPm8vNf0/AfQC8eOKylR3kRewIBIw3Cux5
         yoHw==
X-Gm-Message-State: AOAM533zW87naN9P4Mpi7nxLDk8RJpL2oCnwfcsgZVXZjoxs7FJgPU9T
        glM1Z3FJ5jlLUKQiB9V/VpejUHPZvr8=
X-Google-Smtp-Source: ABdhPJxelU0V8oCsTrZdIIV5G022Xk83e4prdbZk9iJd/1yX2mUnHIkS2GUbDIqk9xQmtENYwZetI7TiE1w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:8045:0:b0:65d:1743:f045 with SMTP id
 a5-20020a258045000000b0065d1743f045mr8471589ybn.412.1654217083954; Thu, 02
 Jun 2022 17:44:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:44 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-38-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 037/144] KVM: selftests: Add vm_create_*() variants to
 expose/return 'struct vcpu'
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

Add VM creation helpers to expose/return 'struct vcpu' so that tests
don't have to hardcode a VCPU_ID or make assumptions about what vCPU ID
is used by the framework just to retrieve a vCPU the test created.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h      | 16 ++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 18 ++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index edbbbbe4cd5d..c46c03750043 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -628,6 +628,22 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 /* Create a default VM without any vcpus. */
 struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
 
+/*
+ * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
+ * additional pages of guest memory.  Returns the VM and vCPU (via out param).
+ */
+struct kvm_vm *__vm_create_with_one_vcpu(struct vcpu **vcpu,
+					 uint64_t extra_mem_pages,
+					 void *guest_code);
+
+static inline struct kvm_vm *vm_create_with_one_vcpu(struct vcpu **vcpu,
+						     void *guest_code)
+{
+	return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
+}
+
+struct vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
+
 /*
  * Adds a vCPU with reasonable defaults (e.g. a stack)
  *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8f670cef6faa..1c5caf2ddca4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -369,6 +369,16 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 					    (uint32_t []){ vcpuid });
 }
 
+struct kvm_vm *__vm_create_with_one_vcpu(struct vcpu **vcpu,
+					 uint64_t extra_mem_pages,
+					 void *guest_code)
+{
+	struct kvm_vm *vm = vm_create_default(0, extra_mem_pages, guest_code);
+
+	*vcpu = vcpu_get(vm, 0);
+	return vm;
+}
+
 /*
  * VM Restart
  *
@@ -403,6 +413,14 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 	}
 }
 
+struct vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
+{
+	kvm_vm_restart(vm);
+
+	vm_vcpu_add(vm, 0);
+	return vcpu_get(vm, 0);
+}
+
 /*
  * Userspace Memory Region Find
  *
-- 
2.36.1.255.ge46751e96f-goog

