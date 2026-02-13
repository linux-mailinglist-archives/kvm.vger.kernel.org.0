Return-Path: <kvm+bounces-71040-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIBWCff+jmmOGwEAu9opvQ
	(envelope-from <kvm+bounces-71040-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 11:37:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B50135260
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 11:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC7F6306FCE0
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 10:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A83934F481;
	Fri, 13 Feb 2026 10:37:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B463D335543;
	Fri, 13 Feb 2026 10:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770979021; cv=none; b=EVobwycMUoy6OzHTl9ih7yoArFEnxptpJrwGrUcRoMRJqgqjfsQWWsu2qCnWs0AlcE+ZgF0XS3NBbVBd15Hy+9GAEQGHRiGCy6IZBXhEWGbe9q7G//t3ylMoaA2oPWa/QZMJoMm/JG58dLtoQ5BXUuMmkZguYfSetPHhgFhyWzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770979021; c=relaxed/simple;
	bh=zwMKAQFVwkPKkCQMq65uZ1GxN38XckvtletF7h923/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hPXqFmUou802tEtOcwEKH5QvIP7OUJx3owcZM0q/QLFDSmGJpWCgCUW0QZ9m0zR176eQFfaIZvNeANDYPzsoAYg9idHbm9rSx8RoVn6Zl+ID3nGY3b2edVgiQ1oyWxjzWj2FDPH7c8cnTuuRoyPfw+LKJ3FDzOQbIr4W1cNbAT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAC3RgqO_o5pQN4uCA--.25463S4;
	Fri, 13 Feb 2026 18:36:01 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH v7 2/3] KVM: selftests: Refactor UAPI tests into dedicated function
Date: Fri, 13 Feb 2026 10:35:56 +0000
Message-Id: <20260213103557.3207335-3-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260213103557.3207335-1-xujiakai2025@iscas.ac.cn>
References: <20260213103557.3207335-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAC3RgqO_o5pQN4uCA--.25463S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4kXr17Gr18Jr17urWUtwb_yoW7XFWkpF
	97CrZIqrW8tr4fKw1xWrWv9F15Gw4vkrn7Zry7Zw4rAr4kKrZrJF1xCryjvF98KFZ5X3Wf
	Za4SvF47uF4qkF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vY
	z4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4
	IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbyCJJUUUUU==
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBwoRCWmOijX6igAAs9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71040-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,redhat.com,iscas.ac.cn,gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 91B50135260
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

Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
 tools/testing/selftests/kvm/steal_time.c | 63 ++++++++++++++++++------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 8edc1fca345ba..a814f6f3f8b41 100644
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
 
@@ -99,6 +93,18 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 			st->pad[8], st->pad[9], st->pad[10]);
 }
 
+static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	st_gva[0] = (void *)(ST_GPA_BASE);
+	sync_global_to_guest(vcpu->vm, st_gva[0]);
+
+	ret = _vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME,
+			    (ulong)st_gva[0] | KVM_STEAL_RESERVED_MASK);
+	TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
+}
+
 #elif defined(__aarch64__)
 
 /* PV_TIME_ST must have 64-byte alignment */
@@ -170,7 +176,6 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 {
 	struct kvm_vm *vm = vcpu->vm;
 	uint64_t st_ipa;
-	int ret;
 
 	struct kvm_device_attr dev = {
 		.group = KVM_ARM_VCPU_PVTIME_CTRL,
@@ -178,21 +183,12 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
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
@@ -205,6 +201,34 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 	ksft_print_msg("    st_time: %ld\n", st->st_time);
 }
 
+static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vm *vm = vcpu->vm;
+	uint64_t st_ipa;
+	int ret;
+
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+		.addr = (uint64_t)&st_ipa,
+	};
+
+	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
+
+	st_gva[0] = (void *)(ST_GPA_BASE);
+	sync_global_to_guest(vm, st_gva[0]);
+
+	st_ipa = (ulong)st_gva[0] | 1;
+	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
+
+	st_ipa = (ulong)st_gva[0];
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
+
+	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
+}
+
 #elif defined(__riscv)
 
 /* SBI STA shmem must have 64-byte alignment */
@@ -301,6 +325,11 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 	pr_info("\n");
 }
 
+static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
+{
+	/* RISC-V UAPI tests will be added in a subsequent patch */
+}
+
 #endif
 
 static void *do_steal_time(void *arg)
@@ -369,6 +398,8 @@ int main(int ac, char **av)
 	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
 	ksft_set_plan(NR_VCPUS);
 
+	check_steal_time_uapi(vcpus[0]);
+
 	/* Run test on each VCPU */
 	for (i = 0; i < NR_VCPUS; ++i) {
 		steal_time_init(vcpus[i], i);
-- 
2.34.1


