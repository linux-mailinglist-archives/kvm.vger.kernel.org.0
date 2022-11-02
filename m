Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C2D617253
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiKBXYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiKBXX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:23:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697BFBC27
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:17 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id f19-20020a63f113000000b0046fde69a09dso91673pgi.10
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8Uwp9RFmCfERzBLmSD7eu3R9205OYPiiKzVrBdwzi3Q=;
        b=claCS3NwR+0MhaVoOkYFaVJrGvE24DgWhuNNCXqXu/cNJfkkndHulcRSJgg3bl5nWu
         ezVBksYs16BVUSTgISauIccvN25YpCmvIh4mNK/TCF369Fz0WIi83T4N5gGR00HTOqlx
         K4C+hDeDasVPWWZ4+BaBihKLBuiEHpr1atX0l4mNFYO6SnajcydRGegOOlYJnt7A9EyL
         WVgPBRXZNK+X1jmKSPJP+zS+z/RzaqKh78J6C240UaCJXUpsZczjlAYOamojaVu730U3
         lpa507MtfiYoTLuSMZbMYA0BMaBQ45neHFSt224FOIaW6TS0lAzeoj2uBvYGp04j4B2C
         qnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Uwp9RFmCfERzBLmSD7eu3R9205OYPiiKzVrBdwzi3Q=;
        b=Zf2po1H1f5eAF4u7a8Vk8Anhv2NcUTVr9sp/HfvVIUbbjYSEgehHPLS+5kuKLkcY6B
         8HaTBSoDiVKKf4/G2As6U1c+a6dyrSIMXlhiF97YT4t4IMVSe68yF51VP0W0CYgtqhGS
         8ssAsUSzqFz5KEi6v87rS/c1i/CFPklanYI84BARFs7P2cliv8Zh0GQiaJLMFCn4fEie
         vPboKi9fFiUUcuIxmlEujnSOoipU0UVRIPTb8WZj43E4Ngx47NZrs5jrPH0pdCJY/4Nb
         q0vJtPCwf4E/Pr+S9b3/VoBozp5wrQ9AM3Fqr700KcQy5/bup+YO2WG4r4H/0lGvFSvB
         RhSg==
X-Gm-Message-State: ACrzQf3NfidqLTivJYqNkXjx1AUUjbj+FJj7HFaR0vIGcoHRclpOqUkv
        Z1PDEKpg0SaejNtY8Ql3+97EGfl+22c=
X-Google-Smtp-Source: AMsMyM4zzGxwdwr8knwrNkc9Tyv3aipP6cXa6lLRwTf0OJezhzGXSJ4RMlmbp1AMJSMoes4N/0MT7VKx15M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d0d:b0:20d:6fc0:51 with SMTP id
 mw13-20020a17090b4d0d00b0020d6fc00051mr44233781pjb.10.1667431203634; Wed, 02
 Nov 2022 16:20:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:56 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-30-seanjc@google.com>
Subject: [PATCH 29/44] KVM: x86: Do CPU compatibility checks in x86 code
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
        Vitaly Kuznetsov <vkuznets@redhat.com>
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
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the CPU compatibility checks to pure x86 code, i.e. drop x86's use
of the common kvm_x86_check_cpu_compat() arch hook.  x86 is the only
architecture that "needs" to do per-CPU compatibility checks, moving
the logic to x86 will allow dropping the common code, and will also
give x86 more control over when/how the compatibility checks are
performed, e.g. TDX will need to enable hardware (do VMXON) in order to
perform compatibility checks.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 49 ++++++++++++++++++++++++++++++++----------
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f48d07bfc3d7..368b4db4b240 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5144,7 +5144,7 @@ static int __init svm_init(void)
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
 	 */
-	r = kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
+	r = kvm_init(NULL, sizeof(struct vcpu_svm),
 		     __alignof__(struct vcpu_svm), THIS_MODULE);
 	if (r)
 		goto err_kvm_init;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 81690fce0eb1..26baaccb659a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8562,7 +8562,7 @@ static int __init vmx_init(void)
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
 	 */
-	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
+	r = kvm_init(NULL, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		goto err_kvm_init;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b4530a33298..94831f1a1d04 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9271,10 +9271,36 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 	kvm_pmu_ops_update(ops->pmu_ops);
 }
 
+struct kvm_cpu_compat_check {
+	struct kvm_x86_init_ops *ops;
+	int *ret;
+};
+
+static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
+{
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+
+	WARN_ON(!irqs_disabled());
+
+	if (__cr4_reserved_bits(cpu_has, c) !=
+	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
+		return -EIO;
+
+	return ops->check_processor_compatibility();
+}
+
+static void kvm_x86_check_cpu_compat(void *data)
+{
+	struct kvm_cpu_compat_check *c = data;
+
+	*c->ret = kvm_x86_check_processor_compatibility(c->ops);
+}
+
 static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 {
+	struct kvm_cpu_compat_check c;
 	u64 host_pat;
-	int r;
+	int r, cpu;
 
 	if (kvm_x86_ops.hardware_enable) {
 		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
@@ -9354,6 +9380,14 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r != 0)
 		goto out_mmu_exit;
 
+	c.ret = &r;
+	c.ops = ops;
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &c, 1);
+		if (r < 0)
+			goto out_hardware_unsetup;
+	}
+
 	/*
 	 * Point of no return!  DO NOT add error paths below this point unless
 	 * absolutely necessary, as most operations from this point forward
@@ -9396,6 +9430,8 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	kvm_init_msr_list();
 	return 0;
 
+out_hardware_unsetup:
+	ops->runtime_ops->hardware_unsetup();
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
 out_free_percpu:
@@ -12002,16 +12038,7 @@ void kvm_arch_hardware_disable(void)
 
 int kvm_arch_check_processor_compat(void *opaque)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-	struct kvm_x86_init_ops *ops = opaque;
-
-	WARN_ON(!irqs_disabled());
-
-	if (__cr4_reserved_bits(cpu_has, c) !=
-	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
-		return -EIO;
-
-	return ops->check_processor_compatibility();
+	return 0;
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.38.1.431.g37b22c650d-goog

