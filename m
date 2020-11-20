Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8D2BAAA1
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgKTM5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:57:13 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:29063 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgKTM5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 07:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605877031; x=1637413031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mQT1D1pR10SCehpnG8yKyjsEYOIN9n/0t7wJIfc5HSs=;
  b=Dx9xD7QVxAKBC9iSzMWWJ4Pi9kFiuxUOy2ti8+xNjevRxvnjUQz+Icgj
   0g2zdFnjt96aRFhBJTDXZZ+GYAE+cyWJPk3gQu0zVF12Cl3rnm6B2AuvR
   Gv+2uq9S45CQeDQCbjMT70mycCPNLRL6lcNeCC64wyzce4DdFtvnp/0E7
   4=;
X-IronPort-AV: E=Sophos;i="5.78,356,1599523200"; 
   d="scan'208";a="97376786"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 20 Nov 2020 12:57:02 +0000
Received: from EX13D49EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 1639DA20E2;
        Fri, 20 Nov 2020 12:57:01 +0000 (UTC)
Received: from EX13D52EUA002.ant.amazon.com (10.43.165.139) by
 EX13D49EUA003.ant.amazon.com (10.43.165.222) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:56:59 +0000
Received: from uc995cb558fb65a.ant.amazon.com (10.43.162.50) by
 EX13D52EUA002.ant.amazon.com (10.43.165.139) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:56:53 +0000
From:   <darkhan@amazon.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <corbet@lwn.net>, <maz@kernel.org>,
        <james.morse@arm.com>, <catalin.marinas@arm.com>,
        <chenhc@lemote.com>, <paulus@ozlabs.org>, <frankja@linux.ibm.com>,
        <mingo@redhat.com>, <acme@redhat.com>, <graf@amazon.de>,
        <darkhan@amazon.de>, Darkhan Mukashov <darkhan@amazon.com>
Subject: [PATCH 2/3] KVM: handle vcpu ioctls KVM_(GET|SET)_ONE_REG in a generic function
Date:   Fri, 20 Nov 2020 13:56:15 +0100
Message-ID: <20201120125616.14436-3-darkhan@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120125616.14436-1-darkhan@amazon.com>
References: <20201120125616.14436-1-darkhan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D32UWB001.ant.amazon.com (10.43.161.248) To
 EX13D52EUA002.ant.amazon.com (10.43.165.139)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Darkhan Mukashov <darkhan@amazon.com>

KVM APIs KVM_GET_ONE_REG and KVM_SET_ONE_REG are handled in arch specific
kvm_arch_vcpu_ioctl functions. These ioctls are supported by all archs
except x86. Implementations for arm64, mips, powerpc, s390 are almost the
same: copy_from_user a kvm_one_reg and pass it to arch specific get/set
function. Therefore, KVM_(GET|SET)_ONE_REG can be handled in a generic
kvm_vcpu_ioctl function. On top of that, this is the first step towards
implementating new vcpu ioctls KVM_GET_MANY_REGS & KVM_SET_MANY_REGS that
can be used to get/set arbitrary number of registers at one ioctl call.
As new ioctls will rely on KVM_(GET|SET)_ONE_REG, this refactoring is
needed for their implementation.

Although implementations of KVM_(GET|SET)_ONE_REG in arch specific
kvm_arch_vcpu_ioctl functions are similar, there are some differences.
These differences stem from differences in implementations of
kvm_arch_vcpu_ioctl functions. For example, vcpu_load and vcpu_put
functions are called in kvm_arch_vcpu_ioctl functions of mips and s390,
but not in arm64 and ppc. In arm64 and s390, there are arch specific
conditions that have to checked before register get/set. All arch specific
checks and operations are summarized in Table 1 below.
+-------+------------------------------+-----------------------+
|  arch |    before register access    | after register access |
+-------+------------------------------+-----------------------+
| arm64 |     kvm_vcpu_initialized     |                       |
+-------+------------------------------+-----------------------+
|  mips |           vcpu_load          |        vcpu_put       |
+-------+------------------------------+-----------------------+
|  ppc  |                              |                       |
+-------+------------------------------+-----------------------+
|  s390 |           vcpu_load          |        vcpu_put       |
|       | kvm_s390_pv_cpu_is_protected |                       |
+-------+------------------------------+-----------------------+
|  x86  |                              |                       |
+-------+------------------------------+-----------------------+
Table 1. Arch specific checks/operations before/after reg get/set

These differences have to be taken into account while KVM_(GET|SET)_ONE_REG
are moved into generic kvm_vcpu_ioctl function. New arch specific functions
kvm_arch_before_reg_access and kvm_arch_after_reg_access are introduced to
handle this issue. They are called before and after register get/set as
their names suggest. These functions have generic "empty" implementations,
but can be overridden by #defining __KVM_HAVE_ARCH_BEFORE_REG_ACCESS and
__KVM_HAVE_ARCH_AFTER_REG_ACCESS and implementing respective functions.

Signed-off-by: Darkhan Mukashov <darkhan@amazon.com>
---
 arch/arm64/include/asm/kvm_host.h  |  5 ++--
 arch/arm64/kvm/arm.c               | 25 ++++++--------------
 arch/arm64/kvm/guest.c             |  6 +++--
 arch/mips/include/asm/kvm_host.h   |  6 +++++
 arch/mips/kvm/mips.c               | 32 ++++++++++++-------------
 arch/powerpc/include/asm/kvm_ppc.h |  2 --
 arch/powerpc/kvm/powerpc.c         | 20 ++++------------
 arch/s390/include/asm/kvm_host.h   |  6 +++++
 arch/s390/kvm/kvm-s390.c           | 38 +++++++++++++++---------------
 arch/x86/kvm/x86.c                 | 12 ++++++++++
 include/linux/kvm_host.h           | 18 ++++++++++++++
 virt/kvm/kvm_main.c                | 20 ++++++++++++++++
 12 files changed, 114 insertions(+), 76 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0aecbab6a7fb..090488079300 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -468,8 +468,6 @@ struct kvm_vcpu_stat {
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
-int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
@@ -639,6 +637,9 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu);
 
 int kvm_set_ipa_limit(void);
 
+#define __KVM_HAVE_ARCH_BEFORE_REG_ACCESS
+int kvm_arch_before_reg_access(struct kvm_vcpu *vcpu);
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f56122eedffc..2f9c0a2000bd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -633,6 +633,13 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 	}
 }
 
+int kvm_arch_before_reg_access(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(!kvm_vcpu_initialized(vcpu)))
+		return -ENOEXEC;
+	return 0;
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
@@ -1089,24 +1096,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl_vcpu_init(vcpu, &init);
 		break;
 	}
-	case KVM_SET_ONE_REG:
-	case KVM_GET_ONE_REG: {
-		struct kvm_one_reg reg;
-
-		r = -ENOEXEC;
-		if (unlikely(!kvm_vcpu_initialized(vcpu)))
-			break;
-
-		r = -EFAULT;
-		if (copy_from_user(&reg, argp, sizeof(reg)))
-			break;
-
-		if (ioctl == KVM_SET_ONE_REG)
-			r = kvm_arm_set_reg(vcpu, &reg);
-		else
-			r = kvm_arm_get_reg(vcpu, &reg);
-		break;
-	}
 	case KVM_GET_REG_LIST: {
 		struct kvm_reg_list __user *user_list = argp;
 		struct kvm_reg_list reg_list;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfb5218137ca..3eb0457fb139 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -710,7 +710,8 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
 }
 
-int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
 {
 	/* We currently use nothing arch-specific in upper 32 bits */
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
@@ -728,7 +729,8 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
 }
 
-int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
 {
 	/* We currently use nothing arch-specific in upper 32 bits */
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 24f3d0f9996b..ed7ba09dfd57 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -700,6 +700,12 @@ static inline void kvm_change_##name1(struct mips_coproc *cop0,		\
 
 #endif
 
+#define __KVM_HAVE_ARCH_BEFORE_REG_ACCESS
+int kvm_arch_before_reg_access(struct kvm_vcpu *vcpu);
+
+#define __KVM_HAVE_ARCH_AFTER_REG_ACCESS
+void kvm_arch_after_reg_access(struct kvm_vcpu *vcpu);
+
 /*
  * Define accessors for CP0 registers that are accessible to the guest. These
  * are primarily used by common emulation code, which may need to access the
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 3d6a7f5827b1..de9985c31f5d 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -661,8 +661,19 @@ static int kvm_mips_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices)
 	return kvm_mips_callbacks->copy_reg_indices(vcpu, indices);
 }
 
-static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
-			    const struct kvm_one_reg *reg)
+int kvm_arch_before_reg_access(struct kvm_vcpu *vcpu)
+{
+	vcpu_load(vcpu);
+	return 0;
+}
+
+void kvm_arch_after_reg_access(struct kvm_vcpu *vcpu)
+{
+	vcpu_put(vcpu);
+}
+
+int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
+					struct kvm_one_reg *reg)
 {
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
 	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
@@ -773,8 +784,8 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 	}
 }
 
-static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
-			    const struct kvm_one_reg *reg)
+int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
+					struct kvm_one_reg *reg)
 {
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
 	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
@@ -943,19 +954,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl,
 	vcpu_load(vcpu);
 
 	switch (ioctl) {
-	case KVM_SET_ONE_REG:
-	case KVM_GET_ONE_REG: {
-		struct kvm_one_reg reg;
-
-		r = -EFAULT;
-		if (copy_from_user(&reg, argp, sizeof(reg)))
-			break;
-		if (ioctl == KVM_SET_ONE_REG)
-			r = kvm_mips_set_reg(vcpu, &reg);
-		else
-			r = kvm_mips_get_reg(vcpu, &reg);
-		break;
-	}
 	case KVM_GET_REG_LIST: {
 		struct kvm_reg_list __user *user_list = argp;
 		struct kvm_reg_list reg_list;
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 0a056c64c317..76f202bc608e 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -412,8 +412,6 @@ int kvmppc_core_set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs);
 int kvmppc_get_sregs_ivor(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs);
 int kvmppc_set_sregs_ivor(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs);
 
-int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg);
-int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg);
 int kvmppc_get_one_reg(struct kvm_vcpu *vcpu, u64 id, union kvmppc_one_reg *);
 int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id, union kvmppc_one_reg *);
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 13999123b735..cd330c7d50b8 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1673,7 +1673,8 @@ static int kvmppc_emulate_mmio_vmx_loadstore(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_ALTIVEC */
 
-int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
+int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
 {
 	int r = 0;
 	union kvmppc_one_reg val;
@@ -1721,7 +1722,8 @@ int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 	return r;
 }
 
-int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
+int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
 {
 	int r;
 	union kvmppc_one_reg val;
@@ -2049,20 +2051,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 
-	case KVM_SET_ONE_REG:
-	case KVM_GET_ONE_REG:
-	{
-		struct kvm_one_reg reg;
-		r = -EFAULT;
-		if (copy_from_user(&reg, argp, sizeof(reg)))
-			goto out;
-		if (ioctl == KVM_SET_ONE_REG)
-			r = kvm_vcpu_ioctl_set_one_reg(vcpu, &reg);
-		else
-			r = kvm_vcpu_ioctl_get_one_reg(vcpu, &reg);
-		break;
-	}
-
 #if defined(CONFIG_KVM_E500V2) || defined(CONFIG_KVM_E500MC)
 	case KVM_DIRTY_TLB: {
 		struct kvm_dirty_tlb dirty;
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 463c24e26000..c21fb33a2dfe 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -970,6 +970,12 @@ static inline bool kvm_is_error_hva(unsigned long addr)
 	return IS_ERR_VALUE(addr);
 }
 
+#define __KVM_HAVE_ARCH_BEFORE_REG_ACCESS
+int kvm_arch_before_reg_access(struct kvm_vcpu *vcpu);
+
+#define __KVM_HAVE_ARCH_AFTER_REG_ACCESS
+void kvm_arch_after_reg_access(struct kvm_vcpu *vcpu);
+
 #define ASYNC_PF_PER_VCPU	64
 struct kvm_arch_async_pf {
 	unsigned long pfault_token;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..a092f7ef91b4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3409,8 +3409,23 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
-					   struct kvm_one_reg *reg)
+int kvm_arch_before_reg_access(struct kvm_vcpu *vcpu)
+{
+	vcpu_load(vcpu);
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		vcpu_put(vcpu);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+void kvm_arch_after_reg_access(struct kvm_vcpu *vcpu)
+{
+	vcpu_put(vcpu);
+}
+
+int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
 {
 	int r = -EINVAL;
 
@@ -3458,8 +3473,8 @@ static int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
-					   struct kvm_one_reg *reg)
+int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
 {
 	int r = -EINVAL;
 	__u64 val;
@@ -4834,21 +4849,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 				   rc, rrc);
 		}
 		break;
-	case KVM_SET_ONE_REG:
-	case KVM_GET_ONE_REG: {
-		struct kvm_one_reg reg;
-		r = -EINVAL;
-		if (kvm_s390_pv_cpu_is_protected(vcpu))
-			break;
-		r = -EFAULT;
-		if (copy_from_user(&reg, argp, sizeof(reg)))
-			break;
-		if (ioctl == KVM_SET_ONE_REG)
-			r = kvm_arch_vcpu_ioctl_set_one_reg(vcpu, &reg);
-		else
-			r = kvm_arch_vcpu_ioctl_get_one_reg(vcpu, &reg);
-		break;
-	}
 #ifdef CONFIG_KVM_S390_UCONTROL
 	case KVM_S390_UCAS_MAP: {
 		struct kvm_s390_ucas_mapping ucasmap;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..794e981d6136 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9279,6 +9279,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg)
+{
+	return -EINVAL;
+}
+
 static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f2e2a09ebbd..53ca4dd1890f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -886,6 +886,24 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
 
+#ifndef __KVM_HAVE_ARCH_BEFORE_REG_ACCESS
+static inline int kvm_arch_before_reg_access(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+#endif
+
+#ifndef __KVM_HAVE_ARCH_AFTER_REG_ACCESS
+static inline void kvm_arch_after_reg_access(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
+int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg);
+int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
+				    struct kvm_one_reg *reg);
+
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..e14185f4977f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3235,6 +3235,26 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;
 	}
+	case KVM_GET_ONE_REG:
+	case KVM_SET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r = kvm_arch_before_reg_access(vcpu);
+		if (r < 0)
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			goto out_after_reg_access;
+
+		if (ioctl == KVM_GET_ONE_REG)
+			r = kvm_arch_vcpu_ioctl_get_one_reg(vcpu, &reg);
+		else
+			r = kvm_arch_vcpu_ioctl_set_one_reg(vcpu, &reg);
+out_after_reg_access:
+		kvm_arch_after_reg_access(vcpu);
+		break;
+	}
 	case KVM_GET_REGS: {
 		struct kvm_regs *kvm_regs;
 
-- 
2.17.1

