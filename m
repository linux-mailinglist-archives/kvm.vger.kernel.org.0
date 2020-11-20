Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAFE2BAAA2
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgKTM5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:57:22 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:2617 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgKTM5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 07:57:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605877040; x=1637413040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZvF7breKnVUMvpT5TURiIHi2Fn8liTuofYoX6gWJj5c=;
  b=nn0rPQj1WuT2+eAwppIbUyS+PxsEiZhe6TQwKJqjdlxq3Mn2/e3+8vj1
   5nL1ger+BohWqtQH9qLs7GxRUXryGV1w2ljwAmL3t+wDg9k22wr3w9QU4
   RzUR6xVP1ZpdW4y7ynvvH69P+tdcPjKenErd3R9M44sChuvcX8MhTpGvt
   U=;
X-IronPort-AV: E=Sophos;i="5.78,356,1599523200"; 
   d="scan'208";a="64846607"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 20 Nov 2020 12:57:11 +0000
Received: from EX13D49EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 460EDA1FBD;
        Fri, 20 Nov 2020 12:57:07 +0000 (UTC)
Received: from EX13D52EUA002.ant.amazon.com (10.43.165.139) by
 EX13D49EUA004.ant.amazon.com (10.43.165.250) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:57:06 +0000
Received: from uc995cb558fb65a.ant.amazon.com (10.43.162.50) by
 EX13D52EUA002.ant.amazon.com (10.43.165.139) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:57:01 +0000
From:   <darkhan@amazon.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <corbet@lwn.net>, <maz@kernel.org>,
        <james.morse@arm.com>, <catalin.marinas@arm.com>,
        <chenhc@lemote.com>, <paulus@ozlabs.org>, <frankja@linux.ibm.com>,
        <mingo@redhat.com>, <acme@redhat.com>, <graf@amazon.de>,
        <darkhan@amazon.de>, Darkhan Mukashov <darkhan@amazon.com>
Subject: [PATCH 3/3] KVM: introduce new vcpu ioctls KVM_GET_MANY_REGS and KVM_SET_MANY_REGS
Date:   Fri, 20 Nov 2020 13:56:16 +0100
Message-ID: <20201120125616.14436-4-darkhan@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120125616.14436-1-darkhan@amazon.com>
References: <20201120125616.14436-1-darkhan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D32UWB001.ant.amazon.com (10.43.161.248) To
 EX13D52EUA002.ant.amazon.com (10.43.165.139)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Darkhan Mukashov <darkhan@amazon.com>

In order to read/write arbitrary number of registers, one has to call
KVM_(GET|SET)_ONE_REG ioctls multiple times. New KVM APIs
KVM_(GET|SET)_MANY_REGS make it possible to bulk read/write vCPU registers
at one ioctl call. These ioctls can be very useful when vCPU state
serialization/deserialization is required (e.g. live update of kvm, live
migration of guests), hence all registers have to be saved/restored.
KVM_(GET|SET)_MANY_REGS will help avoid performance overhead associated
with syscall (ioctl in our case) handling. Tests conducted on AWS Graviton2
Processors (64-bit ARM Neoverse cores) show that average save/restore time
of all vCPU registers can be optimized ~3.5 times per vCPU with new ioctls.
Test results can be found in Table 1.
+---------+-------------+---------------+
|         | kvm_one_reg | kvm_many_regs |
+---------+-------------+---------------+
| get all |   123 usec  |    33 usec    |
+---------+-------------+---------------+
| set all |   120 usec  |    36 usec    |
+---------+-------------+---------------+
	Table 1. Test results

KVM_(GET|SET)_MANY_REGS accept one argument
struct kvm_many_regs {
	/*
	 * number of regs to be got/set
	 */
	__u64 n;

	/*
	 * the same struct used by KVM_(GET|SET)_ONE_REG
	 */
	struct kvm_one_reg reg[0];
}

New ioctls allow to get/set values of multiple registers implemented in a
vcpu. Registers to get/set are indicated by the 'id' field of each
struct kvm_one_reg in the passed array. On success, KVM_GET_MANY_REGS
writes values of indicated registers to memory locations pointed by
the 'addr' field of each kvm_one_reg, KVM_SET_MANY_REGS changes values
of registers to values located at memory locations pointed by the 'addr'
field of each kvm_one_reg.

KVM_(GET|SET)_MANY_REGS rely on KVM_(GET|SET)_ONE_REG, which are not
implemented in x86. Therefore, new ioctls support all architectures except
x86.

Signed-off-by: Darkhan Mukashov <darkhan@amazon.com>
---
 Documentation/virt/kvm/api.rst | 74 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 11 +++++
 virt/kvm/kvm_main.c            | 42 +++++++++++++++++++
 3 files changed, 127 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6d6135c15729..9a229f7e182e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4808,6 +4808,80 @@ If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
 
 
+4.127 KVM_GET_MANY_REGS
+-----------------------
+
+:Capability: basic
+:Architectures: all except x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_many_regs (in)
+:Returns: 0 on success, negative value on failure
+
+Errors:
+
+  ======   ============================================================
+  E2BIG    the passed array of kvm_one_regs is too big, its size should
+           not exceed KVM_MANY_REGS_MAX_SIZE
+  ======   ============================================================
+
+As this ioctl uses KVM_GET_ONE_REG, errors from KVM_GET_ONE_REG are propagated.
+
+(These error codes are indicative only: do not rely on a specific error
+code being returned in a specific situation.)
+
+::
+
+  struct kvm_many_regs {
+	  __u64 n;
+	  struct kvm_one_reg reg[0];
+  };
+
+This ioctl allows to receive values of multiple registers implemented
+in a vcpu. Registers to read are indicated by the 'id' field of each
+kvm_one_reg struct in the passed array. On success, values of indicated
+registers are written to memory locations pointed by the 'addr' field
+of each kvm_one_reg.
+
+In case of duplicate IDs in the 'reg' array, the register will be read as many
+times as it appears in the array.
+
+The list of registers accessible using this interface is identical to the
+list in 4.68.
+
+4.128 KVM_SET_MANY_REGS
+-----------------------
+
+:Capability: basic
+:Architectures: all except x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_many_regs (in)
+:Returns: 0 on success, negative value on failure
+
+Errors:
+
+  ======   ============================================================
+  E2BIG    the passed array of kvm_one_regs is too big, its size should
+           not exceed KVM_MANY_REGS_MAX_SIZE
+  ======   ============================================================
+
+As this ioctl uses KVM_SET_ONE_REG, errors from KVM_SET_ONE_REG are propagated.
+
+(These error codes are indicative only: do not rely on a specific error
+code being returned in a specific situation.)
+
+This ioctl allows to set values of multiple registers implemented
+in a vcpu. Registers to set are indicated by the 'id' field of each
+kvm_one_reg struct in the passed array. On success, values of registers
+are changed to values located at memory locations pointed by the 'addr'
+field of each kvm_one_reg.
+
+In case of duplicate IDs in the 'reg' array, the register will be set as many
+times as it appears in the array.
+
+The list of registers accessible using this interface is identical to the
+list in 4.68.
+
+
 5. The kvm_run structure
 ========================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..87e799457fc3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1223,6 +1223,14 @@ struct kvm_one_reg {
 	__u64 addr;
 };
 
+/* For KVM_(GET|SET)_MANY_REGS */
+#define KVM_MANY_REGS_MAX_SIZE	16384
+
+struct kvm_many_regs {
+	__u64 n;
+	struct kvm_one_reg reg[0];
+};
+
 #define KVM_MSI_VALID_DEVID	(1U << 0)
 struct kvm_msi {
 	__u32 address_lo;
@@ -1557,6 +1565,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_X86_MSR_FILTER */
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
 
+#define KVM_GET_MANY_REGS            _IOW(KVMIO, 0xc7, struct kvm_many_regs)
+#define KVM_SET_MANY_REGS            _IOW(KVMIO, 0xc8, struct kvm_many_regs)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e14185f4977f..3bb618882d2c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3255,6 +3255,48 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		kvm_arch_after_reg_access(vcpu);
 		break;
 	}
+	case KVM_SET_MANY_REGS:
+	case KVM_GET_MANY_REGS: {
+		struct kvm_many_regs __user *user_regs = argp;
+		struct kvm_many_regs many_regs;
+		struct kvm_one_reg *reg;
+		unsigned int i, size;
+
+		r = kvm_arch_before_reg_access(vcpu);
+		if (r < 0)
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&many_regs, user_regs, sizeof(many_regs)))
+			goto out_after_regs_access;
+
+		r = -E2BIG;
+		size = sizeof(struct kvm_one_reg) * many_regs.n;
+		if (size > KVM_MANY_REGS_MAX_SIZE)
+			goto out_after_regs_access;
+
+		r = -ENOMEM;
+		reg = (struct kvm_one_reg *)memdup_user(user_regs->reg, size);
+		if (IS_ERR(reg))
+			goto out_after_regs_access;
+
+		if (ioctl == KVM_GET_MANY_REGS)
+			for (i = 0; i < many_regs.n; i++) {
+				r = kvm_arch_vcpu_ioctl_get_one_reg(vcpu, &reg[i]);
+				if (r < 0)
+					break;
+			}
+		else
+			for (i = 0; i < many_regs.n; i++) {
+				r = kvm_arch_vcpu_ioctl_set_one_reg(vcpu, &reg[i]);
+				if (r < 0)
+					break;
+			}
+		kfree(reg);
+out_after_regs_access:
+		kvm_arch_after_reg_access(vcpu);
+		break;
+	}
 	case KVM_GET_REGS: {
 		struct kvm_regs *kvm_regs;
 
-- 
2.17.1

