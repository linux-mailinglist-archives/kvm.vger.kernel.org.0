Return-Path: <kvm+bounces-49737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD36ADD7F4
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:50:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE0992C67AD
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9448C2EA75B;
	Tue, 17 Jun 2025 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WUywVdJD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02822F94B3
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178040; cv=none; b=npqAqDjzmzbt6EJbCsdSTeuFtiqks6vPjmfqjcSmY3wxp1XOL7j7Ax+fowZ7b0I39s8DVXPrh+xxnVUZ8Hde8V+Co/b5voHfvZvsPOSD5nzJC7u5j60AERIXi2bdS9h3eaQFxqWIzBR+htN+F93inDNGYZ/jLb1YtHBwjuYZ54w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178040; c=relaxed/simple;
	bh=TBdiCdDqA4EB9Ivecqd5vC8Pw/FYB3hTQSvbbs9O174=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CF6JnfpB6VXM78tt/YYUCAwy0DrlNgymMJdFos9oC1d2WCkOocFyXBzbXLBu+kZRRLr/ebqOdVzahHVhTinNxNrv0ehlzHix4yo866VSgQDOuglNGLnGEIRlD6YX45SNPwJ+Wy7eXMQBfWKewRGNOs2T7dHlx5bTFRvATD7iRdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WUywVdJD; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a50fc7ac4dso3505494f8f.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178037; x=1750782837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=08AiNc4t9QnXpXVjsIzl22ewoa/Tdv5ZaJHW+qjaXxo=;
        b=WUywVdJDdWb+nLOfx4xzfzqk370cTbLInZBDSmB4JunUWBjb+/gkR8/PiPhpKzPuN1
         l9R12lDtgbSejJQPdVuBEUNgBDcFxCUv3L2TzUYHbaZNYx2nfSjGM48FePhtM9DmK8cE
         MCz14cGTOvlcXNQk0EOGYVXM+CEJkTVh6B+TQ5WCOkVX2D54unPG72R0IMM2VTIc+jED
         xC3HPwcVrWFkSoQAYciMqVwdYzOymh7eRD9pE79K+9cf3wtoE/JlXESRanuLfR21vH0Q
         DIG/XGBVYawszsmccUkN2EJ9UerFkx5kYnwvf3lA+vnA5NF6PIi5z4GvuHx+JojCizmp
         S6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178037; x=1750782837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=08AiNc4t9QnXpXVjsIzl22ewoa/Tdv5ZaJHW+qjaXxo=;
        b=NkdygZG4ePRe2KD6KLDZwFbOHRyg4sduhLLR8I3L35BrCAFnvt1wy2uTLMW6fih4rb
         h3BEQ+PVQ08TJMr5xVMNg2oQbVgAD1vMcoaORjNQPTKXhknh6nV7VIIslCMBiFXK9+Td
         MWhXFzDYu594EDb5tuYWNNrAYvvvUHzmUzG3fl1qD9HUPeL+shRpZRJ48mnvOgIla8CY
         rppsPnk+KK2oXZlOkbafMkId1OqgAH4fJfjF+M2xiFFdnDB0yZhQEG2pZjnc2rtcs1CQ
         VytDUxItxoY9Z4agArSTQe2ZClCrcdaCY6Ibwdyv5hmFYdUZYMAybql0ZcJR8HeHJL2K
         IZ9g==
X-Forwarded-Encrypted: i=1; AJvYcCWs4g+qesULYd7diSiEGjh7p9c4hcyhtF1wMtANJLrirb2f84ddH/AXTYZT6Pm4dIlF59w=@vger.kernel.org
X-Gm-Message-State: AOJu0YynwCLV3C1/KfZIX3DeCoz6WmfWng9kyFe4ZtSmJsjIDovhCBAb
	gS9xU0i9nMvb5i0ExwpqJhATOyfIRGi6nSTssfxAhCPjyFtwuLY465V7NJBNpG/Ithw=
X-Gm-Gg: ASbGnctmR/gg/e6U5PYPKAzMpdNxCYiWC0E8LVXUwQNIc7yMSmBQBFWgWELLfeDbAMw
	AuVb4Yvq8mXZBvmQhWj0s1gfz9P09TJuQjrLhfXDVO1iIsqGEVa6YOu32e5WcMa04mt4JjCjCwP
	mqsTxCy1PpqYX1qXdIBndLmkblE57/rHD1tKkP9ox7DPPbxSUeM2xkk/AtGtQNk02iW/NCtkBZ5
	bcB41JQ4yqjapFzk6LIYaYFbk0n4n0jkwg3oLbvuAtPSOfskozvVE9QrKGfmzPkqtYtjuvFkj4K
	tsTj0krF2o5YZgL3q5Nurjr3cMdCTxkNJtsYsbFaTeMemczuAR0blpk01Ah9Ilc=
X-Google-Smtp-Source: AGHT+IEN9d1okWsq/8zsxuLsJHKVkJr9o41irpI2tw2DJJ8y8sNzt8REZAmA1XvhJWVvCccTBndiHg==
X-Received: by 2002:a05:6000:708:b0:3a5:5278:e635 with SMTP id ffacd0b85a97d-3a572367577mr10901001f8f.3.1750178037072;
        Tue, 17 Jun 2025 09:33:57 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a68b0esm14233217f8f.29.2025.06.17.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id A920F5F914;
	Tue, 17 Jun 2025 17:33:52 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 08/11] kvm/arm: plumb in a basic trap harder handler
Date: Tue, 17 Jun 2025 17:33:48 +0100
Message-ID: <20250617163351.2640572-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617163351.2640572-1-alex.bennee@linaro.org>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently we do nothing but report we don't handle anything and let
KVM come to a halt.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/syndrome.h |  4 ++++
 target/arm/kvm-stub.c |  5 +++++
 target/arm/kvm.c      | 44 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/target/arm/syndrome.h b/target/arm/syndrome.h
index 3244e0740d..29b95bdd36 100644
--- a/target/arm/syndrome.h
+++ b/target/arm/syndrome.h
@@ -88,6 +88,10 @@ typedef enum {
 #define ARM_EL_ISV_SHIFT 24
 #define ARM_EL_IL (1 << ARM_EL_IL_SHIFT)
 #define ARM_EL_ISV (1 << ARM_EL_ISV_SHIFT)
+#define ARM_EL_ISS_SHIFT 0
+#define ARM_EL_ISS_LENGTH 25
+#define ARM_EL_ISS2_SHIFT 32
+#define ARM_EL_ISS2_LENGTH 24
 
 /* In the Data Abort syndrome */
 #define ARM_EL_VNCR (1 << 13)
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 34e57fab01..765efb1848 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -60,6 +60,11 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
     g_assert_not_reached();
 }
 
+int kvm_arm_get_type(MachineState *ms)
+{
+    g_assert_not_reached();
+}
+
 int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
 {
     g_assert_not_reached();
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c5374d12cf..f2255cfdc8 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1414,6 +1414,43 @@ static bool kvm_arm_handle_debug(ARMCPU *cpu,
     return false;
 }
 
+/**
+ * kvm_arm_handle_hard_trap:
+ * @cpu: ARMCPU
+ * @esr: full exception state register
+ * @elr: exception link return address
+ * @far: fault address (if used)
+ *
+ * Returns: 0 if the exception has been handled, < 0 otherwise
+ */
+static int kvm_arm_handle_hard_trap(ARMCPU *cpu,
+                                    uint64_t esr,
+                                    uint64_t elr,
+                                    uint64_t far)
+{
+    CPUState *cs = CPU(cpu);
+    int esr_ec = extract64(esr, ARM_EL_EC_SHIFT, ARM_EL_EC_LENGTH);
+    int esr_iss = extract64(esr, ARM_EL_ISS_SHIFT, ARM_EL_ISS_LENGTH);
+    int esr_iss2 = extract64(esr, ARM_EL_ISS2_SHIFT, ARM_EL_ISS2_LENGTH);
+    int esr_il = extract64(esr, ARM_EL_IL_SHIFT, 1);
+
+    /*
+     * Ensure register state is synchronised
+     *
+     * This sets vcpu->vcpu_dirty which should ensure the registers
+     * are synced back to KVM before we restart.
+     */
+    kvm_cpu_synchronize_state(cs);
+
+    switch (esr_ec) {
+    default:
+        qemu_log_mask(LOG_UNIMP, "%s: unhandled EC: %x/%x/%x/%d\n",
+                __func__, esr_ec, esr_iss, esr_iss2, esr_il);
+        return -1;
+    }
+}
+
+
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1430,9 +1467,16 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ret = kvm_arm_handle_dabt_nisv(cpu, run->arm_nisv.esr_iss,
                                        run->arm_nisv.fault_ipa);
         break;
+    case KVM_EXIT_ARM_TRAP_HARDER:
+        ret = kvm_arm_handle_hard_trap(cpu,
+                                       run->arm_trap_harder.esr,
+                                       run->arm_trap_harder.elr,
+                                       run->arm_trap_harder.far);
+        break;
     default:
         qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
                       __func__, run->exit_reason);
+        ret = -1;
         break;
     }
     return ret;
-- 
2.47.2


