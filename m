Return-Path: <kvm+bounces-20006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E76D990F553
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F611284040
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53617156F5B;
	Wed, 19 Jun 2024 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FcdPT7qT"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28F4156C6A
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818857; cv=none; b=n7NMIFg8VubcGcqIJWt1IrlM+tTkbOdP5quQkczMYjl1PAzBgyfn/MFPsnN80A/xlgPY0hkivxGTyY04oBrsrDyJ9+LmBo4vmPkdL2EZdgVvz1hdyt9Dz9AF3aCqfRwPI6eqK2uErPVyZuFBzf5+NtkuQlx5YN5kUN/4T8FP0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818857; c=relaxed/simple;
	bh=N7k5uWwrcFHS53eyMjKkXAoPYVwtOEETyqISWK+D1b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5tfwiGPr2q9TUx3ciBlODB/+hwgC1J5wTyAI+HAs6oMX7gWvwjAv9bAzy36mwdOMCIS+/oa9/A+IqDsPGd1eBfSeDiQ3aeFF4pIrPztlhQKD1uMrqo/qSLzH5+LWbAMQlYy99N8tlclizao4lT/ilBLS3Vjqers+VlivVh7kQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FcdPT7qT; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EnNh/GcywKLpR8hrRbpV8T2xmfVNkKxHyMrohajMHxM=;
	b=FcdPT7qT0QHKkceQNov9nrpneIJDxuLSOJdZ30YK+xQSmhEEB3q9ajLVtpN1Y8lIhcuXON
	uBOhWHmqo7lzl8Sa2IZzxQxrhPhSAhWD/6Yg+r59YBAJ7RMc7TspnzPXK8sc4MuA5RQWAG
	0EfoLU0GX5V+hp6+hTiaHPlUidkmjEU=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 03/10] KVM: arm64: Use read-only helper for reading VM ID registers
Date: Wed, 19 Jun 2024 17:40:29 +0000
Message-ID: <20240619174036.483943-4-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

IDREG() expands to the storage of a particular ID reg, which can be
useful for handling both reads and writes. However, outside of a select
few situations, the ID registers should be considered read only.

Replace current readers with a new macro that expands to the value of
the field rather than the field itself.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 16 +++++++++++++++-
 arch/arm64/kvm/pmu-emul.c         |  2 +-
 arch/arm64/kvm/sys_regs.c         |  6 +++---
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..1201af636551 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1332,6 +1332,20 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
+{
+	switch (reg) {
+	case sys_reg(3, 0, 0, 1, 0) ... sys_reg(3, 0, 0, 7, 7):
+		return &ka->id_regs[IDREG_IDX(reg)];
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+}
+
+#define kvm_read_vm_id_reg(kvm, reg)					\
+	({ u64 __val = *__vm_id_reg(&(kvm)->arch, reg); __val; })
+
 #define __expand_field_sign_unsigned(id, fld, val)			\
 	((u64)SYS_FIELD_VALUE(id, fld, val))
 
@@ -1348,7 +1362,7 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
 #define get_idreg_field_unsigned(kvm, id, fld)				\
 	({								\
-		u64 __val = IDREG((kvm), SYS_##id);			\
+		u64 __val = kvm_read_vm_id_reg((kvm), SYS_##id);	\
 		FIELD_GET(id##_##fld##_MASK, __val);			\
 	})
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a35ce10e0a9f..7848daeafd03 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -54,7 +54,7 @@ static u32 __kvm_pmu_event_mask(unsigned int pmuver)
 
 static u32 kvm_pmu_event_mask(struct kvm *kvm)
 {
-	u64 dfr0 = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
+	u64 dfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
 
 	return __kvm_pmu_event_mask(pmuver);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1036f865c826..0692a109fd4d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1565,7 +1565,7 @@ static u64 kvm_read_sanitised_id_reg(struct kvm_vcpu *vcpu,
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	return IDREG(vcpu->kvm, reg_to_encoding(r));
+	return kvm_read_vm_id_reg(vcpu->kvm, reg_to_encoding(r));
 }
 
 static bool is_feature_id_reg(u32 encoding)
@@ -2760,7 +2760,7 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+		u64 dfr = kvm_read_vm_id_reg(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
 		u32 el3 = kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, EL3, IMP);
 
 		p->regval = ((SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr) << 28) |
@@ -3519,7 +3519,7 @@ static int idregs_debug_show(struct seq_file *s, void *v)
 		return 0;
 
 	seq_printf(s, "%20s:\t%016llx\n",
-		   desc->name, IDREG(kvm, reg_to_encoding(desc)));
+		   desc->name, kvm_read_vm_id_reg(kvm, reg_to_encoding(desc)));
 
 	return 0;
 }
-- 
2.45.2.627.g7a2c4fd464-goog


