Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3781C63E525
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiK3XQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiK3XPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:15:35 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB59A1A37
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:20 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u9-20020a170902e80900b0018939ccbeedso19239431plg.20
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f2C8vDRaA/O8SbCTM+wfwlQ+MVAOdj+YvpH8iocCum8=;
        b=E8ory0J1I2HGG0veF4yVwhyY9m0RRKrUrQNbtHkcBPn3mu4coPo+BcZ2CCSzBYmt1U
         gLqizNJDmxOs7ohAfQhuw1mtRxvIWCRJ1ZjGtcj9O77B+F2VF9B0cWhIdzQ02sw591vX
         fdSkALucc7nvyd/ucUkC9khImEPpK6ZxVf/6qAMCnOioiN6e65FTcxBoi9EhyhsHRvLB
         6DuDXJdb6qUgt4jDvBcmP8KYPUbvEzvzpi828Cuwms5+CFGS0VNQK/Ys8J/r7urUqDtN
         pCLG6YtdBn+DHe0STOYvxL6cUh5uQ8qX1SMqSbW+jxDAMmvD7Bx5d27IfSui/C5++PVG
         HYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f2C8vDRaA/O8SbCTM+wfwlQ+MVAOdj+YvpH8iocCum8=;
        b=l7ar3Mva+tdGlRVk3g9ve6wPtUOnzT0gVKiz3R1dytVMTYRZ5GXxsK6/Klse+juu2I
         9VVLLd8ZC3MXITVSWSx4WQzp2M1zMJt6pYSq+GvKvwHms3ixUaiof+8KedgadbpQ1y70
         fCNo4l+JDt1seyw/KX+MXW396L/bRoMFUymC2Lz7eey+jP8vMV6X8LcyTRctDzB0/UqZ
         NQLp4hH8yUo2fdvS+HoMROOMI0CRvzn/x8BRVaPb0HvwcXFfCuZmwQ5yDbkDR4u2aCJE
         b1vRFWh8FuDDAwytj4o5eW8leq3fnIhubZFtFQsSGcCEvAmfG385peKFDUZ/xaXDpsSJ
         cJlw==
X-Gm-Message-State: ANoB5pmiF22LEzAl34jQXfwUxMTqkDMc3UJ4Nh4h1UV3qqN0kfU7AUpM
        /UeuXPmQdTL4Jf+mAfIa27KROzPd3sc=
X-Google-Smtp-Source: AA0mqf7KhS1zzjBRRWmgNzYeinI7lFKtVig8aF30FAKfC8K3egPzRcjNw0j/jgHxn/ZrtapQhwi3bSxxU3g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1941:b0:572:6e9b:9fa2 with SMTP id
 s1-20020a056a00194100b005726e9b9fa2mr44563414pfk.8.1669849846939; Wed, 30 Nov
 2022 15:10:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:24 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-41-seanjc@google.com>
Subject: [PATCH v2 40/50] KVM: x86: Do compatibility checks when onlining CPU
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

From: Chao Gao <chao.gao@intel.com>

Do compatibility checks when enabling hardware to effectively add
compatibility checks when onlining a CPU.  Abort enabling, i.e. the
online process, if the (hotplugged) CPU is incompatible with the known
good setup.

At init time, KVM does compatibility checks to ensure that all online
CPUs support hardware virtualization and a common set of features. But
KVM uses hotplugged CPUs without such compatibility checks. On Intel
CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX, or
VM-Entry failure if the hotplugged CPU doesn't support all features
enabled by KVM.

Note, this is little more than a NOP on SVM, as SVM already checks for
full SVM support during hardware enabling.

Opportunistically add a pr_err() if setup_vmcs_config() fails, and
tweak all error messages to output which CPU failed.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  8 +++-----
 arch/x86/kvm/vmx/vmx.c | 15 ++++++++++-----
 arch/x86/kvm/x86.c     |  5 +++++
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c2e95c0d9fd8..46b658d0f46e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -521,11 +521,12 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 
 static bool kvm_is_svm_supported(void)
 {
+	int cpu = raw_smp_processor_id();
 	const char *msg;
 	u64 vm_cr;
 
 	if (!cpu_has_svm(&msg)) {
-		pr_err("SVM not supported, %s\n", msg);
+		pr_err("SVM not supported by CPU %d, %s\n", cpu, msg);
 		return false;
 	}
 
@@ -536,7 +537,7 @@ static bool kvm_is_svm_supported(void)
 
 	rdmsrl(MSR_VM_CR, vm_cr);
 	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE)) {
-		pr_err("SVM disabled (by BIOS) in MSR_VM_CR\n");
+		pr_err("SVM disabled (by BIOS) in MSR_VM_CR on CPU %d\n", cpu);
 		return false;
 	}
 
@@ -587,9 +588,6 @@ static int svm_hardware_enable(void)
 	if (efer & EFER_SVME)
 		return -EBUSY;
 
-	if (!kvm_is_svm_supported())
-		return -EINVAL;
-
 	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6416ed5b7f89..39dd3082fcd8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2711,14 +2711,16 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 static bool kvm_is_vmx_supported(void)
 {
+	int cpu = raw_smp_processor_id();
+
 	if (!cpu_has_vmx()) {
-		pr_err("CPU doesn't support VMX\n");
+		pr_err("VMX not supported by CPU %d\n", cpu);
 		return false;
 	}
 
 	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
 	    !this_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL\n");
+		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL on CPU %d\n", cpu);
 		return false;
 	}
 
@@ -2727,18 +2729,21 @@ static bool kvm_is_vmx_supported(void)
 
 static int vmx_check_processor_compat(void)
 {
+	int cpu = raw_smp_processor_id();
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
 
 	if (!kvm_is_vmx_supported())
 		return -EIO;
 
-	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
+	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
+		pr_err("Failed to setup VMCS config on CPU %d\n", cpu);
 		return -EIO;
+	}
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
-	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
-		pr_err("CPU %d feature inconsistency!\n", smp_processor_id());
+	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config))) {
+		pr_err("Inconsistent VMCS config on CPU %d\n", cpu);
 		return -EIO;
 	}
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee9af412ffd4..5a9e74cedbc6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11967,6 +11967,11 @@ int kvm_arch_hardware_enable(void)
 	bool stable, backwards_tsc = false;
 
 	kvm_user_return_msr_cpu_online();
+
+	ret = kvm_x86_check_processor_compatibility();
+	if (ret)
+		return ret;
+
 	ret = static_call(kvm_x86_hardware_enable)();
 	if (ret != 0)
 		return ret;
-- 
2.38.1.584.g0f3c55d4c2-goog

