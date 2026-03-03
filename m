Return-Path: <kvm+bounces-72487-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id HhyJN9Y1pmkvMgAAu9opvQ
	(envelope-from <kvm+bounces-72487-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 02:13:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6401E78FC
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 02:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E000313C8E9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 01:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC7421A459;
	Tue,  3 Mar 2026 01:09:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469C92222C5;
	Tue,  3 Mar 2026 01:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772500165; cv=none; b=qI9iwFZXfkAQ4kseFf9a/xBkZO1pzwh5UKb/wD3gZkDtJLr+gtgHHCzQnlZlaHVH5Ti2CiZ4i9OU+WitEA7X2Cy3s7sM6mIWyC/MvdOxk75IvwFmj+Lge+mrDG/zZgHhPQ6pxkwodXxiU46OXGJ/sa7BlEVPT24l126a5VMeZ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772500165; c=relaxed/simple;
	bh=Pbf4n9RZ8mDHNaFL/xu6QGfVb+RkkB4dGKrldlcKl1U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ja3yCG/S5j8APJAL/F560klloLuqQ/NbBYo8Mhsyf0hN/gSuVdM1SU0qyWZdSWeR1hXlHLdqDiyNkBJ0bOgUjAlRuzVeNkkzpKeO2WzXD2kuwgTUgQXJQWM2K490KxmHDgOnYEH09lYV8pPOD3/meV8S7F+ZJ3m9YEsZTv96Eso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABXZ86tNKZp7tu6CQ--.27620S5;
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
	Jiakai Xu <jiakaiPeanut@gmail.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>
Subject: [PATCH v10 3/3] RISC-V: KVM: selftests: Add RISC-V SBI STA shmem alignment tests
Date: Tue,  3 Mar 2026 01:08:59 +0000
Message-Id: <20260303010859.1763177-4-xujiakai2025@iscas.ac.cn>
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
X-CM-TRANSID:rQCowABXZ86tNKZp7tu6CQ--.27620S5
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1fKw17CryftrW8KrW3Jrb_yoW5uw4fpF
	WkCrn0gF18Kws3ArWxKF4kXFWrWw4vkr4vvry3Zw40yF4xJrs7AryxKF4DZ3s8ursYqF1a
	vFySqF1UuF4UAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUH014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWl
	nxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4
	CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvj
	eVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I
	1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6w4l
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r
	4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRiqXHPUUUUU==
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBg0PCWmmMaoLmQAAsL
X-Rspamd-Queue-Id: 5A6401E78FC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72487-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,iscas.ac.cn,gmail.com,oss.qualcomm.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.541];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,qualcomm.com:email,reg.id:url,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Action: no action

Add RISC-V KVM selftests to verify the SBI Steal-Time Accounting (STA)
shared memory alignment requirements.

The SBI specification requires the STA shared memory GPA to be 64-byte
aligned, or set to all-ones to explicitly disable steal-time accounting.
This test verifies that KVM enforces the expected behavior when
configuring the SBI STA shared memory via KVM_SET_ONE_REG.

Specifically, the test checks that:
- misaligned GPAs are rejected with -EINVAL
- 64-byte aligned GPAs are accepted
- all-ones GPA is accepted

Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
---
V8 -> V9: Dropped __riscv guard around INVALID_GPA, which is common to
           all architectures.
V7 -> V8: Moved INVALID_GPA definition to kvm_util_types.h.
          Removed comments in RISC-V check_steal_time_uapi().
          Corrected reg.id assignment for SBI STA.
V6 -> V7: Removed RISCV_SBI_STA_REG() macro addition and used existing
           KVM_REG_RISCV_SBI_STA_REG(shmem_lo) instead.
          Refined assertion messages per review feedback.
          Split into two patches per Andrew Jones' suggestion:
           Refactored UAPI tests from steal_time_init() into dedicated
            check_steal_time_uapi() function and added empty stub for
            RISC-V.
           Filled in RISC-V stub with STA alignment tests. (this patch)
---
 .../selftests/kvm/include/kvm_util_types.h    |  2 ++
 tools/testing/selftests/kvm/steal_time.c      | 31 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
index ec787b97cf184..0366e9bce7f93 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -17,4 +17,6 @@
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
+#define INVALID_GPA (~(uint64_t)0)
+
 #endif /* SELFTEST_KVM_UTIL_TYPES_H */
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 35bace3480f3f..bf27c109cc638 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -332,6 +332,37 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 
 static void check_steal_time_uapi(void)
 {
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_one_reg reg;
+	uint64_t shmem;
+	int ret;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	reg.id = KVM_REG_RISCV |
+			 KVM_REG_SIZE_ULONG |
+			 KVM_REG_RISCV_SBI_STATE |
+			 KVM_REG_RISCV_SBI_STA |
+			 KVM_REG_RISCV_SBI_STA_REG(shmem_lo);
+	reg.addr = (uint64_t)&shmem;
+
+	shmem = ST_GPA_BASE + 1;
+	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "misaligned STA shmem returns -EINVAL");
+
+	shmem = ST_GPA_BASE;
+	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
+	TEST_ASSERT(ret == 0,
+		    "aligned STA shmem succeeds");
+
+	shmem = INVALID_GPA;
+	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
+	TEST_ASSERT(ret == 0,
+		    "all-ones for STA shmem succeeds");
+
+	kvm_vm_free(vm);
 }
 
 #endif
-- 
2.34.1


