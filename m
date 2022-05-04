Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365DA51B2AD
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379585AbiEDW4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379273AbiEDWxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E916B53A4C
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x4-20020a1709028ec400b0015e84d42eaaso1375824plo.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hILKMTXhI7mRm2ADq6Bo0astJ7uCLjembG67g1jJ450=;
        b=Ncaaljy9+Lfur2pGzGKsKPkhJPX9MLSHtkXBPpvCBySaAZuIyZMPBdgkM0GL9GYDUd
         S2IcMlJGcGRZk6VsLkbBVZQk82rsgf7W1uIaxmjBzBnP26oTl0k4FxX/21kPmK9lgVJD
         +fforQSppisWLgOClyk9KaHMPZpiqZxYCVGrveqhBjBmap8A+9rmeM0MOekTcjFKJKRt
         CnEHQsGYBtT4ALon9OCAsUkBOS33SIZMYJByYZTvw5t4a1iKG2L4aGD8CsSpzTSVHhPf
         Eqf2ZEETFgcH28UiN6u/xmSMJ1CKKD26I77ACFhP+CU9gCCaDpVHNFRfW87mCPhRqD2Y
         SwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hILKMTXhI7mRm2ADq6Bo0astJ7uCLjembG67g1jJ450=;
        b=l7eoW7Cr4SzDZ0D2lvwAC1mvxrfjwvktPEAZfWIVMtguQq9DDHIn0s4Gp17tC+wupy
         MP+KxpS7qMnFf0in0rrEp90nDHU+FJjQ0NYs8NFWDEMBw7NfZBtlB/oY6YzPwURX3O/S
         kep3WvEzlhqEzBvVPmu2jzK3Uis/r6mevue+N2KCyHAr15We20IuXSZFd4507dVR+Ne1
         4QGBWEK2fz2vJ5XKcu4sza36LZ+J6SGywkb5H4b2Xw4nv9V4xagrhNVBWlo9DoRPOiCv
         C7iOu4IOXfP7exmiz7oZ0NPY5cRrl7oGVgPUADOv/ghZ9HX/e90mr+rjmYA+mIuhAj6V
         bEOQ==
X-Gm-Message-State: AOAM5323Wp60t9YgJnykkOVOQjVb4du53E6QuRf9PZdRMzdV3Y5FLzXj
        uat/dojMoGV2GboZrkY9axCQ1tRXGHg=
X-Google-Smtp-Source: ABdhPJz+TJFzV0X1qy9CMo/Jq3gGk8wZv/bs/1O8q3seQKUZU2YCyLYVIK/dQ4G95jYZo36n+bVfPfDZNeY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b52:b0:1dc:b438:68b7 with SMTP id
 ot18-20020a17090b3b5200b001dcb43868b7mr1827113pjb.166.1651704599471; Wed, 04
 May 2022 15:49:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:22 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 016/128] KVM: selftests: Make kvm_ioctl() a wrapper to pretty
 print ioctl name
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

Make kvm_ioctl() a macro wrapper and print the _name_ of the ioctl on
failure instead of the number.

Deliberately do not use __stringify(), as that will expand the ioctl all
the way down to its numerical sequence, again the intent is to print the
name of the macro.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 16 ++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 31 +++----------------
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |  2 +-
 3 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 1ccb91103e74..f5bfdf0b4548 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -110,8 +110,19 @@ int kvm_check_cap(long cap);
 #define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
 #define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
 
-int __kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
-void kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
+#define __kvm_ioctl(kvm_fd, cmd, arg) \
+	ioctl(kvm_fd, cmd, arg)
+
+static inline void _kvm_ioctl(int kvm_fd, unsigned long cmd, const char *name,
+			      void *arg)
+{
+	int ret = __kvm_ioctl(kvm_fd, cmd, arg);
+
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
+}
+
+#define kvm_ioctl(kvm_fd, cmd, arg) \
+	_kvm_ioctl(kvm_fd, cmd, #cmd, arg)
 
 int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
 void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg);
@@ -492,6 +503,7 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 uint64_t vm_get_max_gfn(struct kvm_vm *vm);
+int vm_get_kvm_fd(struct kvm_vm *vm);
 int vm_get_fd(struct kvm_vm *vm);
 
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 339d524a0399..ac8faf072288 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1616,32 +1616,6 @@ void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg
 	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
 }
 
-/*
- * KVM system ioctl
- *
- * Input Args:
- *   vm - Virtual Machine
- *   cmd - Ioctl number
- *   arg - Argument to pass to the ioctl
- *
- * Return: None
- *
- * Issues an arbitrary ioctl on a KVM fd.
- */
-void kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
-{
-	int ret;
-
-	ret = ioctl(vm->kvm_fd, cmd, arg);
-	TEST_ASSERT(ret == 0, "KVM ioctl %lu failed, rc: %i errno: %i (%s)",
-		cmd, ret, errno, strerror(errno));
-}
-
-int __kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
-{
-	return ioctl(vm->kvm_fd, cmd, arg);
-}
-
 /*
  * Device Ioctl
  */
@@ -2074,6 +2048,11 @@ uint64_t vm_get_max_gfn(struct kvm_vm *vm)
 	return vm->max_gfn;
 }
 
+int vm_get_kvm_fd(struct kvm_vm *vm)
+{
+	return vm->kvm_fd;
+}
+
 int vm_get_fd(struct kvm_vm *vm)
 {
 	return vm->fd;
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 7e45a3df8f98..896e1e7c1df7 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -123,7 +123,7 @@ void test_hv_cpuid_e2big(struct kvm_vm *vm, bool system)
 	if (!system)
 		ret = __vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 	else
-		ret = __kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+		ret = __kvm_ioctl(vm_get_kvm_fd(vm), KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 
 	TEST_ASSERT(ret == -1 && errno == E2BIG,
 		    "%s KVM_GET_SUPPORTED_HV_CPUID didn't fail with -E2BIG when"
-- 
2.36.0.464.gb9c8b46e94-goog

