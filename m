Return-Path: <kvm+bounces-72261-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uO2iOVE9ommq1AQAu9opvQ
	(envelope-from <kvm+bounces-72261-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:56:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DAB1BF8D2
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:56:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3156318938E
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CDE28CF6F;
	Sat, 28 Feb 2026 00:54:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760E327877D;
	Sat, 28 Feb 2026 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772240070; cv=none; b=LTYM+ZxGGYYUu/vZLUeR26y5soUrfX1f56HIcVU7kgW+lJhfUNV7w52Cxzp7PS0TJ2aUuFXl5q2s2PKP7lFl4MVWPvGYv86FKIJQYJzpyFq1aOwz7o/mg4aF//8oSn5f9m/FTOf80ycgQYc0ZbKJ8P06tlBkRRtL7L+SrvCwulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772240070; c=relaxed/simple;
	bh=I3OFU7Wa+FZhaC249xFdwa9snfn0Na0pOXW+7rzo+1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W39RmCLAKxgffbcFb5i6OZ7F1EstueCsB/mVO8XZpR5cfmGrafQZVrP2QGncuH+ShTrbcUxTjaDOgLiNnasJDSGKvxEmHwaJUGwyBP7XMpByjKXUztPhI7l3bGQqNZUUwlvker7EipEI+DvDVs8yKww31+6y6CqvY8EqCyXLFB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABXO+KkPKJpPMJ2CQ--.12049S3;
	Sat, 28 Feb 2026 08:53:58 +0800 (CST)
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
Subject: [PATCH v9 1/3] RISC-V: KVM: Validate SBI STA shmem alignment in  kvm_sbi_ext_sta_set_reg()
Date: Sat, 28 Feb 2026 00:53:53 +0000
Message-Id: <20260228005355.823048-2-xujiakai2025@iscas.ac.cn>
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
X-CM-TRANSID:rQCowABXO+KkPKJpPMJ2CQ--.12049S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4xXFyfKw4fZrW5Cry7trb_yoWrJF1UpF
	42kw15ZrW8tFZ2k39rZw4vgr15u3ykKr1jqFy3W34xZF4kta4Yyrna93y7ZF98JryvvFWI
	yF10vF1DCw45AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHab7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280
	aVCY1x0267AKxVWxJr0_GcWlnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcV
	AaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0E
	x4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI
	8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_
	GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2ZqWUU
	UUU
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiCRAMCWmhsqi6XgAAsq
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72261-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,iscas.ac.cn,gmail.com,oss.qualcomm.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 60DAB1BF8D2
X-Rspamd-Action: no action

The RISC-V SBI Steal-Time Accounting (STA) extension requires the shared
memory physical address to be 64-byte aligned, or set to all-ones to
explicitly disable steal-time accounting.

KVM exposes the SBI STA shared memory configuration to userspace via
KVM_SET_ONE_REG. However, the current implementation of
kvm_sbi_ext_sta_set_reg() does not validate the alignment of the configured
shared memory address. As a result, userspace can install a misaligned
shared memory address that violates the SBI specification.

Such an invalid configuration may later reach runtime code paths that
assume a valid and properly aligned shared memory region. In particular,
KVM_RUN can trigger the following WARN_ON in
kvm_riscv_vcpu_record_steal_time():

  WARNING: arch/riscv/kvm/vcpu_sbi_sta.c:49 at
  kvm_riscv_vcpu_record_steal_time

WARN_ON paths are not expected to be reachable during normal runtime
execution, and may result in a kernel panic when panic_on_warn is enabled.

Fix this by validating the computed shared memory GPA at the
KVM_SET_ONE_REG boundary. A temporary GPA is constructed and checked
before committing it to vcpu->arch.sta.shmem. The validation allows
either a 64-byte aligned GPA or INVALID_GPA (all-ones), which disables
STA as defined by the SBI specification.

This prevents invalid userspace state from reaching runtime code paths
that assume SBI STA invariants and avoids unexpected WARN_ON behavior.

Fixes: f61ce890b1f074 ("RISC-V: KVM: Add support for SBI STA registers")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
---
V5 -> V6: Initialized new_shmem to INVALID_GPA as suggested.
V4 -> V5: Added parentheses to function name in subject.
V3 -> V4: Declared new_shmem at the top of kvm_sbi_ext_sta_set_reg().
          Initialized new_shmem to 0 instead of vcpu->arch.sta.shmem.
          Added blank lines per review feedback.
V2 -> V3: Added parentheses to function name in subject.
V1 -> V2: Added Fixes tag.
---
 arch/riscv/kvm/vcpu_sbi_sta.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index afa0545c3bcfc..3b834709b429f 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -181,6 +181,7 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
 				   unsigned long reg_size, const void *reg_val)
 {
 	unsigned long value;
+	gpa_t new_shmem = INVALID_GPA;
 
 	if (reg_size != sizeof(unsigned long))
 		return -EINVAL;
@@ -191,18 +192,18 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t hi = upper_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = value;
-			vcpu->arch.sta.shmem |= hi << 32;
+			new_shmem = value;
+			new_shmem |= hi << 32;
 		} else {
-			vcpu->arch.sta.shmem = value;
+			new_shmem = value;
 		}
 		break;
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t lo = lower_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = ((gpa_t)value << 32);
-			vcpu->arch.sta.shmem |= lo;
+			new_shmem = ((gpa_t)value << 32);
+			new_shmem |= lo;
 		} else if (value != 0) {
 			return -EINVAL;
 		}
@@ -211,6 +212,11 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
 		return -ENOENT;
 	}
 
+	if (new_shmem != INVALID_GPA && !IS_ALIGNED(new_shmem, 64))
+		return -EINVAL;
+
+	vcpu->arch.sta.shmem = new_shmem;
+
 	return 0;
 }
 
-- 
2.34.1


