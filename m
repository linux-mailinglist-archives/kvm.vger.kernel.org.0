Return-Path: <kvm+bounces-72485-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EADqI681pmlJMQAAu9opvQ
	(envelope-from <kvm+bounces-72485-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 02:13:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6EB1E78D5
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 02:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5019D312DDD5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 01:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC85248880;
	Tue,  3 Mar 2026 01:09:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C81D14EC73;
	Tue,  3 Mar 2026 01:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772500165; cv=none; b=raZhBeJvWU46WWfTKpNeYp6thbrJqrwXcBMReODhx33AZKXZR8ccOckkJj7tfAhDhER4k1FoCtpc1qZK/FY63NigidI8b3MnANmEWwULs4+tHxRA8GtEwwu9uHoIjPq6mxk9RaG1+XZ72vEjvfAmhEE7GJZh+2m1NA9wl16qXHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772500165; c=relaxed/simple;
	bh=3qHbwlfr/iLQZuXlzYXOiVRfVtjL64pE4Js/2Go+JNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DryLZPdEVOl++7BNSFCRhamuR1mFJGRqCIcTY2O3lXS//NKZerefaoCb9i5SWm8hwdPqc9aXaCqGNXuj2AWoh6H03eHWy8f6LD98NTGUCMJMVXrmkrMhfCYWRo1c3dCR/DgsxwyOGOnc0l+hk54j3bb4CoGka/xk0c+Y1OkwM8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABXZ86tNKZp7tu6CQ--.27620S4;
	Tue, 03 Mar 2026 09:09:04 +0800 (CST)
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
Subject: [PATCH v10 2/3] KVM: selftests: Refactor UAPI tests into dedicated function
Date: Tue,  3 Mar 2026 01:08:58 +0000
Message-Id: <20260303010859.1763177-3-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303010859.1763177-1-xujiakai2025@iscas.ac.cn>
References: <20260303010859.1763177-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXZ86tNKZp7tu6CQ--.27620S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4kXr17Jw43Kw13WFy5twb_yoW7tr47pF
	Z7CrZIqrWUKr1fKw17Gr4kuF15Gw4kKr4DXrW3uw4rArs5trsrJF1SkryUuF98GFZ5X3Wf
	Za4SvF47uF4qkaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWl
	nxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4
	CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvj
	eVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I
	1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6w4l
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRK9a9DUUUU
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBgwPCWmmMaoLkQAAsC
X-Rspamd-Queue-Id: DB6EB1E78D5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72485-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,iscas.ac.cn,oss.qualcomm.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.618];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,qualcomm.com:email,iscas.ac.cn:mid,iscas.ac.cn:email]
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
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
---
V9 -> V10: Fixed build warning: add (void) to check_steal_time_uapi().
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
index 8edc1fca345ba..35bace3480f3f 100644
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
 
+static void check_steal_time_uapi(void)
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
 
+static void check_steal_time_uapi(void)
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
 
+static void check_steal_time_uapi(void)
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


