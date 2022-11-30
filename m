Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AB363E4BA
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiK3XLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiK3XLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:11:01 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639CD99F5B
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:09 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x11-20020a056a000bcb00b0056c6ec11eefso169414pfu.14
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MJave+Z+CqVOQlKYNh+9u1XLbNgTtvhVtL4XdeBXq3U=;
        b=ZO3Ftedng5ZXtAj1HLjLejIkXeEuGF++TCmzhSGUO/jffRhjc4H+xBEcj7yIeqEdat
         0U3Y+Ads6LzFvxNp27Uo8B2HMacUCZIv0pSE92rlIHxzWTi7f9KsRULC+bwhGX87ZVPR
         vnMRqpKsuzzrvEbFNarvM7whj/3tQRNLMCHwuLgw98CUXaVYGXJOn+GNNpcbHsAkPmeN
         tXU852Btu7ns0KpVR55ygwmLkYJEnvUvyvy5iEVsL5b//kXV7FWMRdutGQwiv7w9+h2Y
         WeYcLiKtjVQOAjeb0ZzTx4wnLQ7dUbOEoRqTrEQ9fS/dnvpncahogy2siy31VVqOiND3
         XFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJave+Z+CqVOQlKYNh+9u1XLbNgTtvhVtL4XdeBXq3U=;
        b=fXM6D+699fBjfjicisYA3qam/XDdt77XYivn4Xl1gfjeuX0EiCsHTMwJg5LvHzsTrd
         Cnim0D9pNZa9dDAizYLZ+Z739P/j3O5QmWav4rFu1ZiLHuspnQhkIhJz7rr5UhQlSUgO
         8qivKUhxmy/Wg1bs89fbbUdzL6WOKo983DE5YiuP1YunNDSNXddXyUgVmdtIKs+4xD3d
         WgW+fHwhzHvLeUWqUa7GrOAiNTiUyWaXoc1FWmzFc0ROxd6TAGCFkgrNM8d6L8Syz77q
         2Az86cBINjC92ggnfqFszNwG7Bgftuh9fzuBFvqSblp9t17Z2OG16abW3B0WV3DbSmrl
         9xsQ==
X-Gm-Message-State: ANoB5pm4dYdmMfZuplf6Yl1Dz7XAKjcPnfGdbakHisLhYMUiQ5otp+XM
        +AzeVulIrju7gmxFS3ND4kybFpvt+Rs=
X-Google-Smtp-Source: AA0mqf5OF5+sS7pzLlgqnJtqaKfzLdsx3EOQi2ZpWetSPzJEZYu9zjdDHGwAbdG5EGES6Cvu/KbnbnXMVFE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8090:0:b0:575:4e92:189e with SMTP id
 v16-20020aa78090000000b005754e92189emr14689428pff.59.1669849799328; Wed, 30
 Nov 2022 15:09:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:08:57 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-14-seanjc@google.com>
Subject: [PATCH v2 13/50] KVM: x86: Move guts of kvm_arch_init() to standalone helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the guts of kvm_arch_init() to a new helper, kvm_x86_vendor_init(),
so that VMX can do _all_ arch and vendor initialization before calling
kvm_init().  Calling kvm_init() must be the _very_ last step during init,
as kvm_init() exposes /dev/kvm to userspace, i.e. allows creating VMs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/svm.c          | 23 +++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c          | 21 +++++++++++++++------
 arch/x86/kvm/x86.c              | 15 +++++++++++++--
 4 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70af7240a1d5..04a9ae66fb8d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1758,6 +1758,9 @@ extern struct kvm_x86_ops kvm_x86_ops;
 #define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
+int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops);
+void kvm_x86_vendor_exit(void);
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 91352d692845..19e81a99c58f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5091,15 +5091,34 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 
 static int __init svm_init(void)
 {
+	int r;
+
 	__unused_size_checks();
 
-	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
-			__alignof__(struct vcpu_svm), THIS_MODULE);
+	r = kvm_x86_vendor_init(&svm_init_ops);
+	if (r)
+		return r;
+
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
+		     __alignof__(struct vcpu_svm), THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
+	return 0;
+
+err_kvm_init:
+	kvm_x86_vendor_exit();
+	return r;
 }
 
 static void __exit svm_exit(void)
 {
 	kvm_exit();
+	kvm_x86_vendor_exit();
 }
 
 module_init(svm_init)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b8bf95b9710d..8e81cd94407d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8529,6 +8529,7 @@ static void vmx_exit(void)
 #endif
 
 	kvm_exit();
+	kvm_x86_vendor_exit();
 
 	vmx_cleanup_l1d_flush();
 
@@ -8546,23 +8547,25 @@ static int __init vmx_init(void)
 	 */
 	hv_init_evmcs();
 
+	r = kvm_x86_vendor_init(&vmx_init_ops);
+	if (r)
+		return r;
+
 	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
-		return r;
+		goto err_kvm_init;
 
 	/*
-	 * Must be called after kvm_init() so enable_ept is properly set
+	 * Must be called after common x86 init so enable_ept is properly set
 	 * up. Hand the parameter mitigation value in which was stored in
 	 * the pre module init parser. If no parameter was given, it will
 	 * contain 'auto' which will be turned into the default 'cond'
 	 * mitigation mode.
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-	if (r) {
-		vmx_exit();
-		return r;
-	}
+	if (r)
+		goto err_l1d_flush;
 
 	vmx_setup_fb_clear_ctrl();
 
@@ -8587,5 +8590,11 @@ static int __init vmx_init(void)
 		allow_smaller_maxphyaddr = true;
 
 	return 0;
+
+err_l1d_flush:
+	vmx_exit();
+err_kvm_init:
+	kvm_x86_vendor_exit();
+	return r;
 }
 module_init(vmx_init);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 915d57c3b41d..b33932fca36e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9278,7 +9278,16 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 
 int kvm_arch_init(void *opaque)
 {
-	struct kvm_x86_init_ops *ops = opaque;
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+
+}
+
+int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
+{
 	u64 host_pat;
 	int r;
 
@@ -9410,8 +9419,9 @@ int kvm_arch_init(void *opaque)
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_x86_vendor_init);
 
-void kvm_arch_exit(void)
+void kvm_x86_vendor_exit(void)
 {
 	kvm_unregister_perf_callbacks();
 
@@ -9440,6 +9450,7 @@ void kvm_arch_exit(void)
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 #endif
 }
+EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
 
 static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
-- 
2.38.1.584.g0f3c55d4c2-goog

