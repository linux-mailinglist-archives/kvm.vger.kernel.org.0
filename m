Return-Path: <kvm+bounces-71857-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCoAOKczn2lXZQQAu9opvQ
	(envelope-from <kvm+bounces-71857-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:38:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5577F19BA90
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12F6E303714E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B653D5238;
	Wed, 25 Feb 2026 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qv7FTEZD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459CE2E717B
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041117; cv=none; b=eQysAf1z2NxNiivqZCziJJ3xTnkJG4Bdvd3Q9wr0wff9nUUxeUeZKfRscUhVsmbbRvxm0b0SWCP7L9NEG1U0MlSJBWPxwa+6e7nmwTJG/FSfHFCu6iuHldm5QFVNwmDPTk0Lpwq9vD1tjs6JWK7H+D3YNjCkEmvtInwdg2yu2rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041117; c=relaxed/simple;
	bh=R/R3DcLkOIdIezNwV80BfBol7Z25b9yKegEl4ZzQ0N0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gbGGKOWxWU/nv3WwmcUO0iiCMavQDObmW91zca8/sqo+FzYYS4QWvaEtdWqDwqEJfDXbVxgCfM5yRnmGPc9YMrYlKCMGCaxf1sVYhg8+5iJy9lbh/4pFeLTckfM2WvlDwisMBAKnWtXtrW6jNZmlE2eGicxfstRqYg0hehMEe4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qv7FTEZD; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7d1950b48f3so76601939a34.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 09:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041115; x=1772645915; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FxE+A5J4HGPNO2s3hfVFIukZ/uILKNBM11tjPpp3P/Y=;
        b=Qv7FTEZDdZoIh1Ud8GajKGxCa2se//sSsZKdpP4tDEMDKHSXGyt608CHyTr235l2xs
         u3p2YA/TxPwkq/7a4udqlQ8BJQkNQSHCNee+6z+hu7pxm5wiqywW1LLI2YuXEA15RVbp
         mM+2ScTViU7Gc/3MWj0AYCwwDJaq6iZLcNJGBOs69w/6ZdFpdzuz/9PgtrUisRYeSdLD
         n5Z1yJnf6C+Z6SLSboL3nyNzk+uNIjuodKYcdxor0CNwMktJOCAjPQQmTZ/t69+pPN/4
         B6xsaKCGIYdz98dOEWuop+rWb305vfwkPCJqlD29Ef7Fcy/Pconpk0D2BFBpjXah5g1W
         4A2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041115; x=1772645915;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FxE+A5J4HGPNO2s3hfVFIukZ/uILKNBM11tjPpp3P/Y=;
        b=QjBsOMXUIvhnubSEIEc5DjGH7jWdacGwCIpZkcPucRaCjegAd3M953cXleTLMgT830
         lmYEcRzLMNXz/aM73RP4ON6jK9I684re8k1s0PMRXb49coTR+ogoh7c/TeyhoBX/uR+J
         /r54luDivOY/tDQ2GxN3VHIKuMK97upEuIBKRUsmIA7nQYN9fDQ+oN5EyLDpuMOLfsWM
         xaeMbO11jkpgL71T9pWfzGpjveT+LQdxDjQygrjWXPJnacg8E6uetzGDR6iWtzIKLtOm
         nFQwuBannEbS1AV6zeU6KbSx3Ingc05rkIrYCgYDsxaOdV3HR4o3ww471bSG0TojMVJN
         3u4Q==
X-Gm-Message-State: AOJu0YyEk8ez6+2CG8X9z28o6Q3z5wG2JBlOmzUDtyag0cqtiZ8fJn++
	HJK0x/dT7jmc8mmYDz2otNwuo1kZbGIkzfv7RbVj0MlCzMKtgAZ3oMKZ+Q9EWmMO4qtGkuc7oTT
	IqDdBfserJdKxgXkgWzHTRL84Nris6gsfiuX9FJqkAyt1EHkPyNp0h0A0k8jelnXrwT+w1cumHo
	OfWIq6PZhwZdZ4h3DzsgozdnLVHdBRCBHPFwbupH0NGPw6z8/F3qjsHZ16YBY=
X-Received: from ilbcf6.prod.google.com ([2002:a05:6e02:2306:b0:447:81b5:ae34])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:b68a:0:b0:679:dcd7:fbe6 with SMTP id 006d021491bc7-679dcd80797mr3115611eaf.31.1772041114890;
 Wed, 25 Feb 2026 09:38:34 -0800 (PST)
Date: Wed, 25 Feb 2026 17:37:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225173732.3135526-1-coltonlewis@google.com>
Subject: [RFC PATCH] arm: enable PMU partitioning
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	kvmarm@lists.linux.dev, qemu-arm@nongnu.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71857-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 5577F19BA90
X-Rspamd-Action: no action

This sets the vCPU device attribute to unconditionally enable
partitioning when a PMU is available on an ARM host.

Note that this patch is experimental to demonstrate the API. That is
why it aborts immediately if the call does not succeed.

For the call to succeed, the host must be running a kernel with the
ARM64 PMU Partitioning feature [1] and set the kernel command line
arm_pmuv3.reserved_host_counters=n where n is between 0 and the number
of counters on the system, inclusive.

[1] https://lore.kernel.org/kvmarm/20260209221414.2169465-1-coltonlewis@google.com/

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 hw/arm/virt.c                 |  1 +
 linux-headers/asm-arm64/kvm.h |  2 ++
 target/arm/kvm-stub.c         |  5 +++++
 target/arm/kvm.c              | 18 ++++++++++++++++++
 target/arm/kvm_arm.h          |  1 +
 5 files changed, 27 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 50865e8115..29082df31c 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2234,6 +2234,7 @@ static void virt_post_cpus_gic_realized(VirtMachineState *vms,
                 if (kvm_irqchip_in_kernel()) {
                     kvm_arm_pmu_set_irq(ARM_CPU(cpu), VIRTUAL_PMU_IRQ);
                 }
+                kvm_arm_pmu_set_partition(ARM_CPU(cpu), true);
                 kvm_arm_pmu_init(ARM_CPU(cpu));
             }
             if (steal_time) {
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 46ffbddab5..69309a182e 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -424,6 +424,8 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
+
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index ea67deea52..afbfffe2cd 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -80,6 +80,11 @@ void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
     g_assert_not_reached();
 }
 
+void kvm_arm_pmu_set_partition(ARMCPU *cpu, bool partition)
+{
+    g_assert_not_reached();
+}
+
 void kvm_arm_pmu_init(ARMCPU *cpu)
 {
     g_assert_not_reached();
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ded582e0da..db1d564462 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1817,6 +1817,24 @@ void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
     }
 }
 
+void kvm_arm_pmu_set_partition(ARMCPU *cpu, bool partition)
+{
+    struct kvm_device_attr part_attr = {
+        .group = KVM_ARM_VCPU_PMU_V3_CTRL,
+        .attr = KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION,
+        .addr = (uint64_t)&partition
+    };
+
+    if (!cpu->has_pmu) {
+        return;
+    }
+
+    if (!kvm_arm_set_device_attr(cpu, &part_attr, "PMU partition")) {
+        error_report("failed to set PMU partition");
+        abort();
+    }
+}
+
 void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa)
 {
     struct kvm_device_attr attr = {
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index cc0b374254..2b55f2956e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -248,6 +248,7 @@ int kvm_arm_vgic_probe(void);
 
 void kvm_arm_pmu_init(ARMCPU *cpu);
 void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq);
+void kvm_arm_pmu_set_partition(ARMCPU *cpu, bool partition);
 
 /**
  * kvm_arm_pvtime_init:

base-commit: afe653676dc6dfd49f0390239ff90b2f0052c2b8
-- 
2.53.0.414.gf7e9f6c205-goog


