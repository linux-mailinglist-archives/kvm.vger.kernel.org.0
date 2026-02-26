Return-Path: <kvm+bounces-71941-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WE0gHJEFoGl/fQQAu9opvQ
	(envelope-from <kvm+bounces-71941-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:34:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B481A2A32
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DA4930A2BAC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2533394490;
	Thu, 26 Feb 2026 08:33:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33152C0F6F;
	Thu, 26 Feb 2026 08:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772094789; cv=none; b=TNR8FWkWrOygbYgDKBZmFbePJFkb1xKoWuu+ykI7QOIKaTs4qYoqfn3BfM7//1agG8MKz7zFYOyP/iRffGPzkCp9Zjr8wAW18/UFqx0mwRNQdRdjWjDZBaKQFQrcWdTvNGGK9hP+9As3XhVArMB+GUgLCgQL4jvEbEzHmZEJ5Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772094789; c=relaxed/simple;
	bh=rHO6/pOQ78+7RUX6EmYeqVaafWwenambqT3Mo6TQyfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ndaTQ3fUwgGFz1LYWLGwkXqhrILJkiexOU5U5lRzmqgIQrp7tnHqiSIMw4aGuI87ZWa7ByWcS+gcXViWl8HWfg/gId25SheLeAbzZcaR8iLsi5nsd426QQ6BAqlGgqXE1nskA7WSycynZTuVo5+zx4Vr5CPaAdVYX/260nzn8TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowAB3HWkjBaBpUDDFCA--.13513S4;
	Thu, 26 Feb 2026 16:32:38 +0800 (CST)
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
Subject: [PATCH v8 2/3] KVM: selftests: Refactor UAPI tests into dedicated function
Date: Thu, 26 Feb 2026 08:32:33 +0000
Message-Id: <20260226083234.634716-3-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226083234.634716-1-xujiakai2025@iscas.ac.cn>
References: <20260226083234.634716-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3HWkjBaBpUDDFCA--.13513S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4kXr17Jw43Kw13ZFWfuFg_yoW7CryDpF
	Z7CrsIqrW8trWfKw17Gr4kuF15Gw4kKr4kury3Zw4rAr4kKrZrJF1IgFyUZF98GFWkX3Wf
	Za4rZF47uF4qkaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	ACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pR2Q6LUUUUU=
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiCQ4KCWmf1uCqDwABsg
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71941-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,iscas.ac.cn,oss.qualcomm.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email,qualcomm.com:email]
X-Rspamd-Queue-Id: 09B481A2A32
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
V7 -> V8: Used ST_GPA_BASE directly instead of
           st_gva[]/sync_global_to_guest() in x86_64 and ARM64
           check_steal_time_uapi().
          Created a temporary vcpu in ARM64 check_steal_time_uapi() to
           avoid EEXIST when steal_time_init() later sets IPA for vcpu[0].
          Removed unnecessary comment in RISC-V check_steal_time_uapi().
---
 tools/testing/selftests/kvm/steal_time.c | 59 +++++++++++++++++-------
 1 file changed, 43 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 8edc1fca345ba..6f77df4deaad3 100644
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
 
@@ -99,6 +93,15 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 			st->pad[8], st->pad[9], st->pad[10]);
 }
 
+static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	ret = _vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME,
+			    (ulong)ST_GPA_BASE | KVM_STEAL_RESERVED_MASK);
+	TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
+}
+
 #elif defined(__aarch64__)
 
 /* PV_TIME_ST must have 64-byte alignment */
@@ -170,7 +173,6 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 {
 	struct kvm_vm *vm = vcpu->vm;
 	uint64_t st_ipa;
-	int ret;
 
 	struct kvm_device_attr dev = {
 		.group = KVM_ARM_VCPU_PVTIME_CTRL,
@@ -178,21 +180,12 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
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
@@ -205,6 +198,34 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 	ksft_print_msg("    st_time: %ld\n", st->st_time);
 }
 
+static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vm *vm = vcpu->vm;
+	struct kvm_vcpu *tmp_vcpu = vm_vcpu_add(vm, NR_VCPUS, guest_code);
+	uint64_t st_ipa;
+	int ret;
+
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+		.addr = (uint64_t)&st_ipa,
+	};
+
+	vcpu_ioctl(tmp_vcpu, KVM_HAS_DEVICE_ATTR, &dev);
+
+	st_ipa = (ulong)ST_GPA_BASE | 1;
+	ret = __vcpu_ioctl(tmp_vcpu, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
+
+	st_ipa = (ulong)ST_GPA_BASE;
+	vcpu_ioctl(tmp_vcpu, KVM_SET_DEVICE_ATTR, &dev);
+
+	ret = __vcpu_ioctl(tmp_vcpu, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
+
+	vm_vcpu_rm(vm, tmp_vcpu);
+}
+
 #elif defined(__riscv)
 
 /* SBI STA shmem must have 64-byte alignment */
@@ -301,6 +322,10 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 	pr_info("\n");
 }
 
+static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
+{
+}
+
 #endif
 
 static void *do_steal_time(void *arg)
@@ -369,6 +394,8 @@ int main(int ac, char **av)
 	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
 	ksft_set_plan(NR_VCPUS);
 
+	check_steal_time_uapi(vcpus[0]);
+
 	/* Run test on each VCPU */
 	for (i = 0; i < NR_VCPUS; ++i) {
 		steal_time_init(vcpus[i], i);
-- 
2.34.1


