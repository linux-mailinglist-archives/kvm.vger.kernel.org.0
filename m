Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380FD53C29E
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbiFCAoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbiFCAoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1F8344D7
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:50 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a65624d000000b003fa74c57243so3039887pgv.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nL2B8kY14hSwejw9RxK3Pa8QE1mSuDfrelWBw2aEYGA=;
        b=D/m73JaC0OEO3d5k9DGtAXjLDms0wLG5WNUOiEPwskP6Uftzig68QJPQ081eeGCOKm
         vaBZy/CwY3qo9xXUdARuyb9F1wMRwic7D4OCFo1YKGELMyUauKC6KF730oEZlhf1ABaA
         qw8tgh/F9uIgV730jNtYnjl+SyhEApeGOh02u8E1sjBvp5abr39OUhuGNJqE9VhglML5
         HMevj0xIqTd9CUgWlK0LGF1lCMixoNG/YUNFUUVlURLrJrt6Xs6OiL7CDcwDfIVlg7U1
         ys1XRlXe0ExarhQ2lQP+/MjbJXeF56vMQY2Vy2TXvMwMKhFp4p8bQL+uF37DBelUy4ks
         MPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nL2B8kY14hSwejw9RxK3Pa8QE1mSuDfrelWBw2aEYGA=;
        b=eKZQ7Or3s30jtuwv48F1/eLg0R5AsYeGggZTLXon6knZwcCDLRUboHaIB6Ou4Q/rIM
         H+C0R9DRXh7jdDF9d9KBLmAmIp/Rnu5Hk1zS47sr3WLnApiCl4r178Wi52XFNCL4VsQR
         VMpUIUuCwrBPSw+Wq0vi3iaALlmJLV8mMrQorp9eD0zpiHOy7Byyt0JOzANG35swAKKO
         c2Wffy+RRIkYayKT7+EbluBGc88Shvy0rId/CMMLZwH4PRPCIWpgFmSYp7HozAXO85OV
         scQOEYVbj4FTeeue89YWDYjh6MDmpY/p5QFMUouodPPG7sQvgZEZ9mhhb9Yvur3Xz+wc
         epqg==
X-Gm-Message-State: AOAM533TO2ULaAk2ux8BRoQo8dXs1Ohnq84D+r/OmlweUYBohNhFMXyg
        7FRfK9kO2GwpN7XlfLIphEWkWajijOM=
X-Google-Smtp-Source: ABdhPJzZeEHnmZWp0xNEa8TRWZbJ84+KIiGHjcsHJYw+FsOMdpDJ2uIL3OaCSRhhD9EsujNUj49DsUP1rr0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b396:b0:1e4:d7de:ea3d with SMTP id
 e22-20020a17090ab39600b001e4d7deea3dmr8358835pjr.222.1654217029475; Thu, 02
 Jun 2022 17:43:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:14 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 007/144] KVM: selftests: Make vcpu_ioctl() a wrapper to
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
2.36.1.255.ge46751e96f-goog

