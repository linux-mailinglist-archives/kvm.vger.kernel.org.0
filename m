Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6272753C279
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbiFCApX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240016AbiFCAoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:08 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2B4344D8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:07 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z16-20020a17090a015000b001dbc8da29a1so3397036pje.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Oi80sezCk7gxJZoW0ux8DSw87sfFjgySpbytwAP1Yiw=;
        b=Jgs/uoLQLZPA+XzAKH/oLm1DACsirv130BnIyfuPtZBTM4MZrMZFbwPa7qP3UZufY3
         qRaywPZky147jh1jsU/dT706qaPC8Ctmn1gz8rfWIGWAJXCB2sAWQdXliCdtkFSmLjFH
         h5Msbe/lJ12ia0Ol8rPQgDcPtMsotWD81gT02C+Kv5Yw6wIMu67RAH9thizCZxF75L8D
         2s7ewy4sXa2+wyfYXJDJrSjr+9sojn6sw7E8cQp3cPOz2aUB8ALIjiva3JgM7WXEpsKf
         aJ3AW9uF1sG2piXfvLnGE05OqiL4sAVZzKy5V/2LPJI8DTwXO57Ws8HB21ZreCEt25aY
         +tnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Oi80sezCk7gxJZoW0ux8DSw87sfFjgySpbytwAP1Yiw=;
        b=zrce3VXKu+aMAzNPFf31yBLBU++/5Wv3Yqy3yloq+xZA4C5oKfFPUzI4D/H0OSDzZc
         4t+oyi8xXo0BkbeOwDvjKex+xkE1lGz6QozcgCE/q3czklhyGFNLMtwhgOD0Ahp5TUYN
         w4nqMi6/5el0HO8jwTfrYxGTt2ZGmxkV56ep0ppYaa6B905p3WzS/1BeceUuF9UrTqTI
         bUiKAqckYi8xpzX9CT1aRfgl2zS8OoX6FMTUa2MxaPkClw4mdSgaNvFkjSL0CRaCNjgl
         Ws1TTdi7Cc6VDNyDiHhqSMG95b5GHHTnbrrHUtYn+/piwVQsEFY6A20eWHaKoJ+w1SOa
         JOEw==
X-Gm-Message-State: AOAM532TM4Gbfd5CLrJJVni0wXdVZeoxfjHauuuM0jyL1ikf6lSFFTP2
        ahbrWDgGmbBE3nLITZ9xEf4FyO8ndEc=
X-Google-Smtp-Source: ABdhPJxOwQyOENK2eLXEWE7gAKLoVv0yFZUF+Yp1uVnmfLyhreaRluoSd7OPMOjugXIGGV2dszUanAfZVDw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:778e:b0:162:2cf7:28be with SMTP id
 o14-20020a170902778e00b001622cf728bemr7550680pll.0.1654217046554; Thu, 02 Jun
 2022 17:44:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:24 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 017/144] KVM: selftests: Make kvm_ioctl() a wrapper to
 pretty print ioctl name
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
2.36.1.255.ge46751e96f-goog

