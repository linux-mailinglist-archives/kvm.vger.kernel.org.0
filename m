Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9688818E467
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 21:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgCUU0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 16:26:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:8930 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgCUU0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 16:26:07 -0400
IronPort-SDR: qPmlwfU02OC9s0qWuZ6ZLrUzl9dVV5mxnmgzJXlsduHVXGhQLg+gUJF4klSOC5cnuS5YIpmAwr
 BwSLp7ZIXlBw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 13:26:05 -0700
IronPort-SDR: scn7pZUQDpTF3SQ9rG37pbebi3mtbty3HtYRPENAnoNHIWqdnH+Q8Df4p/ny8v2N2HzwcoFbwe
 7DKC+AlU6sCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="280773535"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 21 Mar 2020 13:26:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/9] KVM: Pass kvm_init()'s opaque param to additional arch funcs
Date:   Sat, 21 Mar 2020 13:25:55 -0700
Message-Id: <20200321202603.19355-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200321202603.19355-1-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass @opaque to kvm_arch_hardware_setup() and
kvm_arch_check_processor_compat() to allow architecture specific code to
reference @opaque without having to stash it away in a temporary global
variable.  This will enable x86 to separate its vendor specific callback
ops, which are passed via @opaque, into "init" and "runtime" ops without
having to stash away the "init" ops.

No functional change intended.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Tested-by: Cornelia Huck <cohuck@redhat.com> #s390
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       |  4 ++--
 arch/powerpc/kvm/powerpc.c |  4 ++--
 arch/s390/kvm/kvm-s390.c   |  4 ++--
 arch/x86/kvm/x86.c         |  4 ++--
 include/linux/kvm_host.h   |  4 ++--
 virt/kvm/arm/arm.c         |  4 ++--
 virt/kvm/kvm_main.c        | 18 ++++++++++++++----
 7 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 78507757ba9a..8f05dd0a0f4e 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -118,12 +118,12 @@ void kvm_arch_hardware_disable(void)
 	kvm_mips_callbacks->hardware_disable();
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return 0;
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 62ee66d5eb6f..f54574564f1e 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -415,12 +415,12 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return kvmppc_core_check_processor_compat();
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 807ed6d722dd..0ac8eb29e5aa 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -235,7 +235,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return 0;
 }
@@ -302,7 +302,7 @@ static struct notifier_block kvm_clock_notifier = {
 	.notifier_call = kvm_clock_sync,
 };
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	gmap_notifier.notifier_call = kvm_gmap_notifier;
 	gmap_register_pte_notifier(&gmap_notifier);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e54c6ad628a8..0f08e1b4e762 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9621,7 +9621,7 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	int r;
 
@@ -9662,7 +9662,7 @@ void kvm_arch_hardware_unsetup(void)
 	kvm_x86_ops->hardware_unsetup();
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 35bc52e187a2..bc48d8fef3e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -886,9 +886,9 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
 
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
-int kvm_arch_hardware_setup(void);
+int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void);
+int kvm_arch_check_processor_compat(void *opaque);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index bfdba1caf59d..57e5a143b0db 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -64,12 +64,12 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 28eae681859f..f4e79c891c25 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4645,14 +4645,22 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
         return &kvm_running_vcpu;
 }
 
-static void check_processor_compat(void *rtn)
+struct kvm_cpu_compat_check {
+	void *opaque;
+	int *ret;
+};
+
+static void check_processor_compat(void *data)
 {
-	*(int *)rtn = kvm_arch_check_processor_compat();
+	struct kvm_cpu_compat_check *c = data;
+
+	*c->ret = kvm_arch_check_processor_compat(c->opaque);
 }
 
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
+	struct kvm_cpu_compat_check c;
 	int r;
 	int cpu;
 
@@ -4676,12 +4684,14 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_0;
 	}
 
-	r = kvm_arch_hardware_setup();
+	r = kvm_arch_hardware_setup(opaque);
 	if (r < 0)
 		goto out_free_1;
 
+	c.ret = &r;
+	c.opaque = opaque;
 	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
+		smp_call_function_single(cpu, check_processor_compat, &c, 1);
 		if (r < 0)
 			goto out_free_2;
 	}
-- 
2.24.1

