Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B424EB706
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241170AbiC2Xwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbiC2Xwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:52:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054E1204AB3
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p13-20020a170902a40d00b00155e8c68777so3710096plq.19
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xn6dD0NDRkWndk+qkMADvSMilfrLo/OBZLvoP8lMgT4=;
        b=Zv6ZvG4i+G6qdX4EyMXuTo4rE1/1buf4+IA8KvqZucAn6jB+7rx1ho6dvdO/bZWd+y
         9kEN1uShJTlpKhNHX4Zu/v910yYCZS8JI86sfUKOfiJU7KgBiEca7WkJ3MXzUeq1qZly
         klS4V9lj/zuBmWxAgjvvRzDTGmxq4A0y9KlO2P/QG6fxNlIkXXaXboA/fi7lUSQiRoFd
         +Bmsf/UjchaUHOoi/YxbWJqOhu0IBRf8YSgVfqc6T5usvIUdbWPdSYh08Qt7KYwu8UGB
         kxu1zlaWPYgVNdZY6VYFMUR6N1oJJNnQitrdP4c4xmZC4dseEBrcDtGV5+Q3APUio0vV
         1AyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xn6dD0NDRkWndk+qkMADvSMilfrLo/OBZLvoP8lMgT4=;
        b=wcb4sm0CTyXLHqR496l8uS7ioaApmN5m8vbKLEc0Ro2h2zSs6/PbfAsL/tJrkYdPrI
         +ER2GThP/mpKjfcBTJ2jq8dv5ghhCkD8udOHitFiZgHwjDcYz7k7L3brrwBFuzYmlPmG
         Qu6oCOwF8+r3aQR4r8OEx7rLi/WmrGuiiD+PivZ0Lkzf0shJCJMJsPHzVxstP1Fx0Rhb
         Z/dxr5XXhdS6w8ipON+jdYPgmOlayMl1EIaJS9NIrdE8iOJIecdygFTtTDlL8oc+l2BZ
         Me/4Ip2kx2RwQBw+nICM5yoOs/f2lkm5B1T/iCO+VGBOxLQATGzdAFI9MfHXzyE+MWR3
         8GZQ==
X-Gm-Message-State: AOAM530BMlvDgpadZVmR9RfOP4xdEhillojGAi7rMpKBfACfmskI/zxb
        bbuaDRbPMjheRqsplgS9HiK3g3bTQoc=
X-Google-Smtp-Source: ABdhPJz8DKtXUDzVuwe4lXRByg3SXE/K90HbdG1Lp6s5S6ujIgdHPcCZ3v2xBfAmrxf+cEch6FwfDIdQ4o8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3a81:b0:1c6:834e:cd61 with SMTP id
 om1-20020a17090b3a8100b001c6834ecd61mr1699386pjb.149.1648597865466; Tue, 29
 Mar 2022 16:51:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Mar 2022 23:50:51 +0000
In-Reply-To: <20220329235054.3534728-1-seanjc@google.com>
Message-Id: <20220329235054.3534728-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220329235054.3534728-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3.1 1/4] KVM: x86: Move kvm_ops_static_call_update() to x86.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

The kvm_ops_static_call_update() is defined in kvm_host.h. That's
completely unnecessary, it should have exactly one caller,
kvm_arch_hardware_setup().  Move the helper to x86.c and have it do the
actual memcpy() of the ops in addition to the static call updates.  This
will also allow for cleanly giving kvm_pmu_ops static_call treatment.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: Move memcpy() into the helper and rename accordingly]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 14 --------------
 arch/x86/kvm/x86.c              | 19 +++++++++++++++++--
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9694dd5e6ccc..df4e057b0417 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1557,20 +1557,6 @@ extern struct kvm_x86_ops kvm_x86_ops;
 #define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
-static inline void kvm_ops_static_call_update(void)
-{
-#define __KVM_X86_OP(func) \
-	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
-#define KVM_X86_OP(func) \
-	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
-#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
-#define KVM_X86_OP_OPTIONAL_RET0(func) \
-	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
-					   (void *)__static_call_return0);
-#include <asm/kvm-x86-ops.h>
-#undef __KVM_X86_OP
-}
-
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3a9ce07a565..99aa2d16845a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11595,6 +11595,22 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
+static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
+{
+	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
+
+#define __KVM_X86_OP(func) \
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
+#define KVM_X86_OP(func) \
+	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
+#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0(func) \
+	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
+					   (void *)__static_call_return0);
+#include <asm/kvm-x86-ops.h>
+#undef __KVM_X86_OP
+}
+
 int kvm_arch_hardware_setup(void *opaque)
 {
 	struct kvm_x86_init_ops *ops = opaque;
@@ -11609,8 +11625,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (r != 0)
 		return r;
 
-	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
-	kvm_ops_static_call_update();
+	kvm_ops_update(ops);
 
 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
 
-- 
2.35.1.1021.g381101b075-goog

