Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8487CE7A5
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjJRTXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjJRTXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:23:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DB611D
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:23:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7d261a84bso111877337b3.3
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697657010; x=1698261810; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nodpH4C4bQ/gNaICo1hh4M7XTXxxvuUKNCjUFbiep9I=;
        b=p8oqL8104jOuVWELkmr4wobfylJAOtjigEl/yNhBatjRBxW2x+UxdzB4p1PjD2dSba
         ow8UjseMnh9Ba4IaOJY5Gs0pblrrDhGXFxDi41+RU4fZKH8J+CSCoelJOkOxwbNanXro
         XWvyOAaS1JZklMBtUzzw/Z7FwSvcJZG3Q2CL7FMUclLzQzH59JQyKsm/ScVOePVz6q0R
         GjlsKPIVLGzEKjMlnq3mKL5r8sxFtMv0kna8cEbVu8qntXKl9Qa4wUxttqHnp8Y5pieU
         m06iXzXmX9hL6DYoG7EzuLWsD+cTnj5823jD+11pUEvyaTyulHEJCAWd2+HyQaUve9oP
         qYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697657010; x=1698261810;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nodpH4C4bQ/gNaICo1hh4M7XTXxxvuUKNCjUFbiep9I=;
        b=D1FRD0D/gXPRVhoa4wec8GMs6g73QGfRWhdFB7AQv49nJFusBOiWMp/KP2mHQ9Ff+r
         R/Pd0MUHNP5b5nCc8rx7rLLUvUQmVdHD6HEoP2tIY3pgtPRE+0DfWYBKkOOzILNpAuIe
         0Gn5EhN8CwRQ6XaqH3mVK6Q7xPMvLXbfylS6uuM8jntdz2M8bzSfXZcmVSb2UJUzhQyI
         Fs4nbZeK8klDznCVkX/hR7g6QnMUkfjBAaemaw1fFjB5dspt5v1LhFtM745pd7gFnHIx
         ii31e9AoiYW54Vis2hyc4Y/JF1JnVg52jBsIRhADgaXszKgKfaJ2V/l+e3E/fHaTxghN
         3h8Q==
X-Gm-Message-State: AOJu0YxT4WaVfBy8gRiWWQ9WGg0u2yGin410zsKk+xAQ5isuFLdU7GNH
        VRZucGIwVB86xwFg+T+oXG0tXDx4SI0=
X-Google-Smtp-Source: AGHT+IFmGxaXOt4/cBpfYV39xsYcl21XLtTTYlfhhkHY00t9wInu5pOx40L8w/7hPanWGs0YbTQEg8QQDMI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6c4f:0:b0:592:8069:540a with SMTP id
 h76-20020a816c4f000000b005928069540amr4397ywc.8.1697657010698; Wed, 18 Oct
 2023 12:23:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 12:23:25 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018192325.1893896-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks iff HYPERV!=n
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Declare the kvm_x86_ops hooks used to wire up paravirt TLB flushes when
running under Hyper-V if and only if CONFIG_HYPERV!=n.  Wrapping yet more
code with IS_ENABLED(CONFIG_HYPERV) eliminates a handful of conditional
branches, and makes it super obvious why the hooks *might* be valid.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    | 12 ++++++++++++
 arch/x86/kvm/mmu/mmu.c             | 12 ++++--------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 26b628d84594..f482216bbdb8 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -55,8 +55,10 @@ KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
+#if IS_ENABLED(CONFIG_HYPERV)
 KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
 KVM_X86_OP_OPTIONAL(flush_remote_tlbs_range)
+#endif
 KVM_X86_OP(flush_tlb_gva)
 KVM_X86_OP(flush_tlb_guest)
 KVM_X86_OP(vcpu_pre_run)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7c228ae05df0..f0d1ac871465 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1614,9 +1614,11 @@ struct kvm_x86_ops {
 
 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
+#if IS_ENABLED(CONFIG_HYPERV)
 	int  (*flush_remote_tlbs)(struct kvm *kvm);
 	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
 					gfn_t nr_pages);
+#endif
 
 	/*
 	 * Flush any TLB entries associated with the given GVA.
@@ -1825,6 +1827,7 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
 
+#if IS_ENABLED(CONFIG_HYPERV)
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
@@ -1836,6 +1839,15 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 }
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
+						   u64 nr_pages)
+{
+	if (!kvm_x86_ops.flush_remote_tlbs_range)
+		return -EOPNOTSUPP;
+
+	return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
+}
+#endif /* CONFIG_HYPERV */
 
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5d3dc7119e57..0702f5234d69 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -271,15 +271,11 @@ static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
 
 static inline bool kvm_available_flush_remote_tlbs_range(void)
 {
+#if IS_ENABLED(CONFIG_HYPERV)
 	return kvm_x86_ops.flush_remote_tlbs_range;
-}
-
-int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
-{
-	if (!kvm_x86_ops.flush_remote_tlbs_range)
-		return -EOPNOTSUPP;
-
-	return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
+#else
+	return false;
+#endif
 }
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);

base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

