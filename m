Return-Path: <kvm+bounces-65611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EA8CB11A4
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 22:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E69C30E11D2
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 21:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4963112D5;
	Tue,  9 Dec 2025 20:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfLM6Osr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F533303A17
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313575; cv=none; b=i1n1iqYEHu86k9o/w6GA28jZfhBVogvplWFhyLN0WiiFuO4l0TW/VNCmUv4GamR6P6pWALK9RQpWDh0J6ivNPL1AEC6TuYw5qASB45RubI3mouFdMACxMD0Uv+9hMU96D9QEGu4zrqAPE4gqOQjoA4cWR0I/ADoEkH9aWGEM/zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313575; c=relaxed/simple;
	bh=vH4vToO1Kn0jUWaD9r2NByPEBh2j2Tq7llj3z+1eFKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQvFsTk+unojDREhn+Pe32LBfB09o894Hd5vXgwIQS8nEWyPd3dN6nGPYPcH4+7HE/VqqL7Z5WOmXdSDONdrvCoZDwANIkaopgv9zg6RjUasJcCdOWsf324E9G8Mr/q0gbyjYvassUWw7IOS/ofSAIdsAvyQBt9cy1VAURi32FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UfLM6Osr; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c72ccd60f5so11111820a34.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313561; x=1765918361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I7rslOWyfBKryoyVeAdT+vyRO2ASxcyyBGT1wwSBsKE=;
        b=UfLM6Osr3WuEvc2/MDRNGwnEq1XzwvHFX5sTN01PC4xr+LxWC17AzYjhdMY66YviCo
         ei+sCUpzO9xAEvBQKqbVMfQmGUjT6SrNuVEXogoVZPS6whGc+8teRd2fxq/1Jwxewd+v
         NyB7AHV3b6yCkONtYQ5xR8L8qkaPI0B6Pa5GTZxdvswOm/O0lxi5zR3V5ANFrQk5uNN/
         zzwKsRR8M7e00wP4JuIaUb9g1YA3pBA5cyjjk89aNU6FtFUzjbo734EPAW4p9XXZbuKl
         9cCxVSfqZ+CyFo7YtgUU8He+blC1+rF9Flw+W5nH2lPR3k8LOzPz7JdwrcrSNFj6nUvo
         AxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313561; x=1765918361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I7rslOWyfBKryoyVeAdT+vyRO2ASxcyyBGT1wwSBsKE=;
        b=ugP5mCpny+wkZc7L9c2cR48RD1cFyuv/uHMNp0DMxv+7xZB5LMBCqet6cSH5kqMlHt
         OtsCipXR7xvs4xIoHqmIEFclmVsP18lpbJGv/TtHVcdaufn/OR8/Re9ZhgRpx20oigbw
         f7k/XNkudOk30U6fumujeG63BmaAiUi9PBBK7S6S+rMYl6MBfDNQIXoz5JefrLPMT2dx
         1/qUer/p3iYTqK6u2tdOryX5TZBuSXl0mtGmpIDb8yz+GJyhKjo3vJLAVGfJVCvj6YxQ
         rZlf+jqnvTt8+udFGOUcOt1o+uJbQ6LdlYrnWCxyAyAwYzCylV1F6KRdi4GdYmOXZXiz
         g9ig==
X-Gm-Message-State: AOJu0YykJT7Y1QxIQE6zzOjMLrFdWZpz+E7uqC/eBvxfGc3pJyTX3arc
	2NLpcFux17VlY4eo5vGmHvwU9+8zaNejnuC+55Ri1cCgK43PCyBGYsIVhqafnWMrfRgPKM6BvTq
	nW4F+ZYUyKYxEMiyCWtP9Ecu1Ax0zolU5TJY6sp9g/Qo/hzX31Y4mU2411tGAiJV7f0bnF0wKDg
	VigCmi88nglV6aBD/5r1b4yGefq47wyZjpD3bGixg+iQPx1dO0Vgg6xLFKl4g=
X-Google-Smtp-Source: AGHT+IFdNtZkxvJxJ9KoIinFxTXoYCnJbZauUeKj4oIMf+rqE8iUac1MGIbX45NhV6sJzZWUdWJoByDmtDg2d29Vpw==
X-Received: from ilbbc25.prod.google.com ([2002:a05:6e02:99:b0:434:972f:bf92])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4cc2:b0:659:9a49:9050 with SMTP id 006d021491bc7-65b2ac45517mr108480eaf.27.1765313561253;
 Tue, 09 Dec 2025 12:52:41 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:12 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-16-coltonlewis@google.com>
Subject: [PATCH v5 15/24] KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Setup MDCR_EL2 to handle a partitioned PMU. That means calculate an
appropriate value for HPMN instead of the default maximum setting the
host allows (which implies no partition) so hardware enforces that a
guest will only see the counters in the guest partition.

Setting HPMN to a non default value means the global enable bit for
the host counters is now MDCR_EL2.HPME instead of the usual
PMCR_EL0.E. Enable the HPME bit to allow the host to count guest
events. Since HPME only has an effect when HPMN is set which we only
do for the guest, it is correct to enable it unconditionally here.

Unset the TPM and TPMCR bits, which trap all PMU accesses, if
FGT (fine grain trapping) is being used.

If available, set the filtering bits HPMD and HCCD to be extra sure
nothing in the guest counts at EL2.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h | 11 ++++++
 arch/arm64/kvm/debug.c           | 29 ++++++++++++--
 arch/arm64/kvm/pmu-direct.c      | 65 ++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 60b8a48cad456..8b634112eded2 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -101,6 +101,9 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
@@ -173,6 +176,14 @@ static inline u64 kvm_pmu_fgt2_bits(void)
 {
 	return 0;
 }
+static inline u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3ad6b7c6e4ba7..0ab89c91e19cb 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -36,20 +36,43 @@ static int cpu_has_spe(u64 dfr0)
  */
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
+	int hpmn = kvm_pmu_hpmn(vcpu);
+
 	preempt_disable();
 
 	/*
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
+
+	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+				MDCR_EL2_TDOSA |
+				MDCR_EL2_HPME);
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		/*
+		 * Filtering these should be redundant because we trap
+		 * all the TYPER and FILTR registers anyway and ensure
+		 * they filter EL2, but set the bits if they are here.
+		 */
+		if (is_pmuv3p1(read_pmuver()))
+			vcpu->arch.mdcr_el2 |= MDCR_EL2_HPMD;
+		if (is_pmuv3p5(read_pmuver()))
+			vcpu->arch.mdcr_el2 |= MDCR_EL2_HCCD;
+
+		/*
+		 * Take out the coarse grain traps if we are using
+		 * fine grain traps.
+		 */
+		if (kvm_vcpu_pmu_use_fgt(vcpu))
+			vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR);
+
+	}
 
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 4dd160c878862..7fb4fb5c22e2a 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -154,3 +154,68 @@ void kvm_pmu_host_counters_disable(void)
 	mdcr &= ~MDCR_EL2_HPME;
 	write_sysreg(mdcr, mdcr_el2);
 }
+
+/**
+ * kvm_pmu_guest_num_counters() - Number of counters to show to guest
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate the number of counters to show to the guest via
+ * PMCR_EL0.N, making sure to respect the maximum the host allows,
+ * which is hpmn_max if partitioned and host_max otherwise.
+ *
+ * Return: Valid value for PMCR_EL0.N
+ */
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
+{
+	u8 nr_cnt = vcpu->kvm->arch.nr_pmu_counters;
+	int hpmn_max = armv8pmu_hpmn_max;
+	u8 host_max = *host_data_ptr(nr_event_counters);
+
+	if (vcpu->kvm->arch.arm_pmu)
+		hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		if (nr_cnt <= hpmn_max && nr_cnt <= host_max)
+			return nr_cnt;
+		if (hpmn_max <= host_max)
+			return hpmn_max;
+	}
+
+	if (nr_cnt <= host_max)
+		return nr_cnt;
+
+	return host_max;
+}
+
+/**
+ * kvm_pmu_hpmn() - Calculate HPMN field value
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate the appropriate value to set for MDCR_EL2.HPMN. If
+ * partitioned, this is the number of counters set for the guest if
+ * supported, falling back to hpmn_max if needed. If we are not
+ * partitioned or can't set the implied HPMN value, fall back to the
+ * host value.
+ *
+ * Return: A valid HPMN value
+ */
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	u8 nr_guest_cnt = kvm_pmu_guest_num_counters(vcpu);
+	int nr_guest_cnt_max = armv8pmu_hpmn_max;
+	u8 nr_host_cnt_max = *host_data_ptr(nr_event_counters);
+
+	if (vcpu->kvm->arch.arm_pmu)
+		nr_guest_cnt_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		if (cpus_have_final_cap(ARM64_HAS_HPMN0))
+			return nr_guest_cnt;
+		else if (nr_guest_cnt > 0)
+			return nr_guest_cnt;
+		else if (nr_guest_cnt_max > 0)
+			return nr_guest_cnt_max;
+	}
+
+	return nr_host_cnt_max;
+}
-- 
2.52.0.239.gd5f0c6e74e-goog


