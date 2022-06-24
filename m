Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95DB55A4CA
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 01:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiFXX1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 19:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiFXX1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 19:27:41 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E24387D6E
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:41 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id o22-20020a637316000000b0040d238478aeso1670433pgc.2
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hyZEmhqPYeJ4Ol3ikZnvOQkrNHTZADYaJQ9/4xLEzS0=;
        b=RQeyNxucOwEmOmlBweIrqsG0ZUxZEW0ceF4YdFG5/ou6I3MEp9laYGwA6FxeNk4q7e
         AtEvYgQyivljH1GzxvlOm0CjjB6VUH6R/vQ4Mm2tAaFyKH/CjdysAsNDyie/e25xo9k3
         yaulyDLYn9XfGvho17sszGygVcra/lYFlv5c7DTjLH+moXzJVK43qHneVeVOd0rwKj5h
         9R+BwM1OUtwTwPkZw9CS69F/TF4O4V/RLlTUebv9CajTXoE4qP35J9YJI75p68XLeKpG
         WNJPA27AFlVFPSIOKc74czrMMpqf3QM0rSMQk5D3f+nSO/2/VZ6+ebP/55vyae2v+dfE
         yc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hyZEmhqPYeJ4Ol3ikZnvOQkrNHTZADYaJQ9/4xLEzS0=;
        b=XoINWc1LOrCBqgLE7ysxYkmqAomOwkk5+jMWTochMfUwWcDetgWl0MaXcootthtOz6
         t1xoUlfENqDjBzPZ7s+YhFqQnIXwoI0SOYlEBoHzJZCTUfFCOZE1pJl3sPpcbw/Qjk6B
         k/ENf5TUMVIUSEj7B9yUre8PGArh7zCm+Gu5xCTu6s9UbLQR+0pdJ36Syu1loJ7DsBxZ
         IRPk0sfyg/phYU+v0fmKM4PqpdO2SJeHF/N3KYjEAJogC1TxKELE2/Stc46hqa/oxwze
         eDdvNBSoYV+XMUdOct3AFnYIcRbB3qEuGLsAEUf3RP4g9FzSLjB8/5rttv8g2VJ3k7wz
         oUvg==
X-Gm-Message-State: AJIora+lytSmqUXOGHYL5RADCWIIx7S49J2haLdI6qAugMVESPtnG0cn
        fkoYfggoYiwLDuauxeQ9MW468aqgV1U=
X-Google-Smtp-Source: AGRyM1uShxIahYbE//SRYq4lXZNODGcS3W3YeRuQtoxiJi3Py4SMnXXX/hN0fbJujEQrqzFbbot4+GGCnGA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cecf:b0:16a:416c:3d19 with SMTP id
 d15-20020a170902cecf00b0016a416c3d19mr1412420plg.137.1656113260851; Fri, 24
 Jun 2022 16:27:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 23:27:33 +0000
In-Reply-To: <20220624232735.3090056-1-seanjc@google.com>
Message-Id: <20220624232735.3090056-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220624232735.3090056-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 2/4] KVM: x86/mmu: Defer "full" MMU setup until after vendor hardware_setup()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
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

Defer MMU setup, and in particular allocation of pte_list_desc_cache,
until after the vendor's hardware_setup() has run, i.e. until after the
MMU has been configured by vendor code.  This will allow a future commit
to dynamically size pte_list_desc's array of sptes based on whether or
not KVM is using TDP.

Alternatively, the setup could be done in kvm_configure_mmu(), but that
would require vendor code to call e.g. kvm_unconfigure_mmu() in teardown
and error paths, i.e. doesn't actually save code and is arguably uglier.

Note, keep the reset of PTE masks where it is to ensure that the masks
are reset before the vendor's hardware_setup() runs, i.e. before the
vendor code has a chance to manipulate the masks, e.g. VMX modifies masks
even before calling kvm_configure_mmu().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++++----
 arch/x86/kvm/x86.c              | 17 +++++++++++------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88a3026ee163..c670a9656257 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1711,8 +1711,9 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
 void kvm_mmu_x86_module_init(void);
-int kvm_mmu_vendor_module_init(void);
-void kvm_mmu_vendor_module_exit(void);
+void kvm_mmu_vendor_module_init(void);
+int kvm_mmu_hardware_setup(void);
+void kvm_mmu_hardware_unsetup(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 17ac30b9e22c..ceb81e04aea3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6673,10 +6673,8 @@ void kvm_mmu_x86_module_init(void)
  * loaded as many of the masks/values may be modified by VMX or SVM, i.e. need
  * to be reset when a potentially different vendor module is loaded.
  */
-int kvm_mmu_vendor_module_init(void)
+void kvm_mmu_vendor_module_init(void)
 {
-	int ret = -ENOMEM;
-
 	/*
 	 * MMU roles use union aliasing which is, generally speaking, an
 	 * undefined behavior. However, we supposedly know how compilers behave
@@ -6687,7 +6685,13 @@ int kvm_mmu_vendor_module_init(void)
 	BUILD_BUG_ON(sizeof(union kvm_mmu_extended_role) != sizeof(u32));
 	BUILD_BUG_ON(sizeof(union kvm_cpu_role) != sizeof(u64));
 
+	/* Reset the PTE masks before the vendor module's hardware setup. */
 	kvm_mmu_reset_all_pte_masks();
+}
+
+int kvm_mmu_hardware_setup(void)
+{
+	int ret = -ENOMEM;
 
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
@@ -6723,7 +6727,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }
 
-void kvm_mmu_vendor_module_exit(void)
+void kvm_mmu_hardware_unsetup(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 031678eff28e..735543df829a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9204,9 +9204,7 @@ int kvm_arch_init(void *opaque)
 	}
 	kvm_nr_uret_msrs = 0;
 
-	r = kvm_mmu_vendor_module_init();
-	if (r)
-		goto out_free_percpu;
+	kvm_mmu_vendor_module_init();
 
 	kvm_timer_init();
 
@@ -9226,8 +9224,6 @@ int kvm_arch_init(void *opaque)
 
 	return 0;
 
-out_free_percpu:
-	free_percpu(user_return_msrs);
 out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
 out:
@@ -9252,7 +9248,6 @@ void kvm_arch_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
-	kvm_mmu_vendor_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
@@ -11937,6 +11932,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	kvm_ops_update(ops);
 
+	r = kvm_mmu_hardware_setup();
+	if (r)
+		goto out_unsetup;
+
 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
@@ -11960,12 +11959,18 @@ int kvm_arch_hardware_setup(void *opaque)
 	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
 	kvm_init_msr_list();
 	return 0;
+
+out_unsetup:
+	static_call(kvm_x86_hardware_unsetup)();
+	return r;
 }
 
 void kvm_arch_hardware_unsetup(void)
 {
 	kvm_unregister_perf_callbacks();
 
+	kvm_mmu_hardware_unsetup();
+
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

