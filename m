Return-Path: <kvm+bounces-72259-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DfgA/w8ommq1AQAu9opvQ
	(envelope-from <kvm+bounces-72259-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:55:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E9A1BF86A
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE7873130FC3
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FC0277017;
	Sat, 28 Feb 2026 00:54:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9961F22A7F9;
	Sat, 28 Feb 2026 00:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772240067; cv=none; b=rniUHUJ5RYoTgivtekT7FfTTRYJWe2PEGHlhW2Fx3JQN/LiCliBhext3fUio07uvoWMhpv8YH5f1V7Q/c1PgjfwC20i4+wk20vKmqO0z5o7eRx3iBF0IUkZJTID6HjRqq7RNpwLFqDO00AMDrnqUwkc3EZoWGYvW+bqUudu+qNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772240067; c=relaxed/simple;
	bh=WB4LwFrHufnXrmQeT5Ru1OwtKceQD2Uil9/AlZVovB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ebssWBuPJTPQUxVAitj5ulNev+X0+JrfceydU2OxNUma8m89QAKjkNKoA6Yqidz4Rv/+oe2k8raqMIJ38dMBF5MCUQ2voeqZsXuttR8+MPhJVbxvxD+Nw6LJsjFGjyM50XfoGQ1gtozX8CYcrX/DPhZH8XYqQqr9P24YArBZvfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABXO+KkPKJpPMJ2CQ--.12049S4;
	Sat, 28 Feb 2026 08:53:59 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH v9 2/3] KVM: selftests: Refactor UAPI tests into dedicated function
Date: Sat, 28 Feb 2026 00:53:54 +0000
Message-Id: <20260228005355.823048-3-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260228005355.823048-1-xujiakai2025@iscas.ac.cn>
References: <20260228005355.823048-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXO+KkPKJpPMJ2CQ--.12049S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4kXr17Jw43Kw13WFy5twb_yoW7Zw1fpF
	Z7CrZIqrW8Kr1fKw17Wr4kuF15Gw4kKr4kXrW3uw4rArs5KrZrJF1fCryUuF98GFZ5X3Wf
	Za4SvF47uF4qkaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxd
	M2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRiqjg3UUUUU==
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiCQ4MCWmhsqi6XwABs0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72259-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,iscas.ac.cn,oss.qualcomm.com,gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 69E9A1BF86A
X-Rspamd-Action: no action

Move steal time UAPI tests from steal_time_init() into a separate
check_steal_time_uapi() function for better code organization and
maintainability.

Previously, x86 and ARM64 architectures performed UAPI validation
tests within steal_time_init(), mixing initialization logic with
uapi tests.

Changes by architecture:
x86_64:
  - Extract MSR reserved bits test from steal_time_init()
  - Move to check_steal_time_uapi() which tests that setting
    MSR_KVM_STEAL_TIME with KVM_STEAL_RESERVED_MASK fails
ARM64:
  - Extract three UAPI tests from steal_time_init():
     Device attribute support check
     Misaligned IPA rejection (EINVAL)
     Duplicate IPA setting rejection (EEXIST)
  - Move all tests to check_steal_time_uapi()
RISC-V:
  - Add empty check_steal_time_uapi() stub for future use
  - No changes to steal_time_init() (had no tests to extract)

The new check_steal_time_uapi() function:
  - Is called once before the per-VCPU test loop

No functional change intended.

Suggested-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
V8 -> V9: Created a temporary VM with one vCPU in
           check_steal_time_uapi() instead of adding extra vCPUs to the
           main VM.
          Made check_steal_time_uapi() parameterless for all architectures.
V7 -> V8: Used ST_GPA_BASE directly instead of
           st_gva[]/sync_global_to_guest() in x86_64 and ARM64
           check_steal_time_uapi().
          Created a temporary vcpu in ARM64 check_steal_time_uapi() to
           avoid EEXIST when steal_time_init() later sets IPA for vcpu[0].
          Removed unnecessary comment in RISC-V check_steal_time_uapi().
---
 tools/testing/selftests/kvm/steal_time.c | 67 ++++++++++++++++++------
 1 file changed, 51 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 8edc1fca345ba..75ad067f27260 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -69,16 +69,10 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 
 static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 {
-	int ret;
-
 	/* ST_GPA_BASE is identity mapped */
 	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
 	sync_global_to_guest(vcpu->vm, st_gva[i]);
 
-	ret = _vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME,
-			    (ulong)st_gva[i] | KVM_STEAL_RESERVED_MASK);
-	TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
-
 	vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_MSR_ENABLED);
 }
 
@@ -99,6 +93,21 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 			st->pad[8], st->pad[9], st->pad[10]);
 }
 
+static void check_steal_time_uapi()
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int ret;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	ret = _vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME,
+			    (ulong)ST_GPA_BASE | KVM_STEAL_RESERVED_MASK);
+	TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
+
+	kvm_vm_free(vm);
+}
+
 #elif defined(__aarch64__)
 
 /* PV_TIME_ST must have 64-byte alignment */
@@ -170,7 +179,6 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 {
 	struct kvm_vm *vm = vcpu->vm;
 	uint64_t st_ipa;
-	int ret;
 
 	struct kvm_device_attr dev = {
 		.group = KVM_ARM_VCPU_PVTIME_CTRL,
@@ -178,21 +186,12 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 		.addr = (uint64_t)&st_ipa,
 	};
 
-	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
-
 	/* ST_GPA_BASE is identity mapped */
 	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
 	sync_global_to_guest(vm, st_gva[i]);
 
-	st_ipa = (ulong)st_gva[i] | 1;
-	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
-	TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
-
 	st_ipa = (ulong)st_gva[i];
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
-
-	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
-	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
 }
 
 static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
@@ -205,6 +204,36 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 	ksft_print_msg("    st_time: %ld\n", st->st_time);
 }
 
+static void check_steal_time_uapi()
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	uint64_t st_ipa;
+	int ret;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+		.addr = (uint64_t)&st_ipa,
+	};
+
+	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
+
+	st_ipa = (ulong)ST_GPA_BASE | 1;
+	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
+
+	st_ipa = (ulong)ST_GPA_BASE;
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
+
+	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
+
+	kvm_vm_free(vm);
+}
+
 #elif defined(__riscv)
 
 /* SBI STA shmem must have 64-byte alignment */
@@ -301,6 +330,10 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 	pr_info("\n");
 }
 
+static void check_steal_time_uapi()
+{
+}
+
 #endif
 
 static void *do_steal_time(void *arg)
@@ -369,6 +402,8 @@ int main(int ac, char **av)
 	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
 	ksft_set_plan(NR_VCPUS);
 
+	check_steal_time_uapi();
+
 	/* Run test on each VCPU */
 	for (i = 0; i < NR_VCPUS; ++i) {
 		steal_time_init(vcpus[i], i);
-- 
2.34.1


