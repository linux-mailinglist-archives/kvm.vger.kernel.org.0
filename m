Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3388E51B26A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379172AbiEDWxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379148AbiEDWxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:20 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3E853A40
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i188-20020a636dc5000000b003c143f97bc2so1341260pgc.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4pIauhSlde4XCXit2IlbWFMSroGJDw7QeFGFxnStppM=;
        b=a9+WhsNyIFthX2/9HChLG4NOifYBsqe11L7lWxR3ClM+nDKb459zt9goW8dgYEV3h9
         RdKNolxw5aTFBVqUUGpe24s4SxsjUYG+Q1rN47d0ukeIDrM+XHt+E/TbxWhfZ45/IKmv
         qi2K6R6nH2Lnnq2XwTlHk4D5geT0qdM2ln/oozKJ66fHBGlqT1AfOhXASB68uK7s7BTg
         OC3d834iT8jJgb15w7TL9I9SWBhDFVCg/5uw6n+d96x2OCiYgLskiCgBHHuVN0o/2ia9
         T/7o7iVo7+OWl6j5fw7ONY4TjMmTG8bXZxofKvVkW5pMQDHO2cmqXBIgLe4H8tfmlw5A
         tQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4pIauhSlde4XCXit2IlbWFMSroGJDw7QeFGFxnStppM=;
        b=xC/iJN5DlnLLTnhamJ00zdLGb2XH+P/UdlaNiXjH8Z5WirQLkWSFcWnSangci+LIqP
         uDB1EERl/oGU47uGU1TGf85yXsXEkM33mHjTA7U3kbfSe4bEKNpiMKROviW/SlDMVJhs
         ynmXlPJvU29N4X+6u+wbYkq3UXQyHG60aEMFfWlCHlzho1daxgpE+XFh4tbJaZ+x9Ffu
         OPN6Y8oGWGGpKn1kqf/BQdTyhSkU8lOJW1zg4my5AY8fX1FuNrct8ephaIRtLoVkwd0J
         JQOytfK1zsL7NE92IPmDownpRP516I4T+wn8jIjGLV5Qf0shBf6yhG65SQplR+dXxawn
         XdMQ==
X-Gm-Message-State: AOAM531nEAEuuepbK2eqkSd3f24ZINKbGm2kdIanKVmjuFYN5FBVPDDJ
        Ya2g6Sw97tlB7tEK3ovZ9MSMUh+bhYc=
X-Google-Smtp-Source: ABdhPJwuL73IVTiU2k74hQ3qJRkNU0pw5Xj2dfjKuUwh4LQNFfuRqowdR8m/OVpUzvVO7wgRdemp+EZAtGE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8c:b0:15e:a371:ad89 with SMTP id
 x12-20020a170902ec8c00b0015ea371ad89mr17656273plg.157.1651704582214; Wed, 04
 May 2022 15:49:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:12 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 006/128] KVM: selftests: Make vcpu_ioctl() a wrapper to pretty
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make vcpu_ioctl() a macro wrapper and pretty the _name_ of the ioctl on
failure instead of the number.  Add inner macros to allow handling cases
where the name of the ioctl needs to be resolved higher up the stack, and
to allow using the formatting for non-ioctl syscalls without being
technically wrong.

Deliberately do not use __stringify(), as that will expand the ioctl all
the way down to its numerical sequence, again the intent is to print the
name of the macro.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 13 ++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 31 +++++--------------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 662579a6358b..00f3103dc85e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -157,10 +157,19 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 	uint32_t flags);
 
-void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
-		void *arg);
+#define __KVM_SYSCALL_ERROR(_name, _ret) \
+	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
+
+#define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
+#define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
+
+void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
+		 const char *name, void *arg);
 int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		 void *arg);
+#define vcpu_ioctl(vm, vcpuid, ioctl, arg) \
+	_vcpu_ioctl(vm, vcpuid, ioctl, #ioctl, arg)
+
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
 void kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 03c1f885a98b..fdcaf74b5959 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1937,29 +1937,6 @@ void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
 		    ret, errno, strerror(errno));
 }
 
-/*
- * VCPU Ioctl
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   cmd - Ioctl number
- *   arg - Argument to pass to the ioctl
- *
- * Return: None
- *
- * Issues an arbitrary ioctl on a VCPU fd.
- */
-void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
-		unsigned long cmd, void *arg)
-{
-	int ret;
-
-	ret = __vcpu_ioctl(vm, vcpuid, cmd, arg);
-	TEST_ASSERT(ret == 0, "vcpu ioctl %lu failed, rc: %i errno: %i (%s)",
-		cmd, ret, errno, strerror(errno));
-}
-
 int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 		 unsigned long cmd, void *arg)
 {
@@ -1973,6 +1950,14 @@ int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 	return ret;
 }
 
+void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
+		 const char *name, void *arg)
+{
+	int ret = __vcpu_ioctl(vm, vcpuid, cmd, arg);
+
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
+}
+
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu;
-- 
2.36.0.464.gb9c8b46e94-goog

