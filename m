Return-Path: <kvm+bounces-49740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9AC8ADD85F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 629E61681C4
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D8F2FA62E;
	Tue, 17 Jun 2025 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tVp1Kfo0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702B02EA745
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178042; cv=none; b=PO70UAGJRzE07+2ebvn3BCiFdr8ftraU6dz/93xuUbJ7ACoq5p+RvEWnZdhv0enj9mhF09eW2spL96WciAqon6ACxuWU8/JOOSUr+YaLpktBl/NNOUVe9xXyTg+YKhRoLMN7rNpQvPVuUSPIsU58e5ax+G443diUY7n/+aRB73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178042; c=relaxed/simple;
	bh=RCEZwtAHcfW1GxuAPgC52UEcCAk/Ta75fPcYz87A0t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pzxs/SEhfjUkvLGJ9v8GVLnB5odsvsEXqD5xqwlWKzwf8sPs9/pyEy371EIPIuXlODaR34XpPQUEftOc9tpF84SALH143MzM4z7ChD0Z1aLx7CPAk9FlPFAbuKrdY3uDPEHFL22uFP+OusZh2iT8qnoh7/pNrlGcKbVHH7CKlck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tVp1Kfo0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so66986385e9.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178039; x=1750782839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0sO4FG8MJlTgihEHf66llt9xMF7CLK1g/3AupI01Bo=;
        b=tVp1Kfo0R68R7khx2cSixr+Dt7RvQd7sUXJKoms7rZOhCAxPPo5Q1bVGw0P4TGuma2
         vt67/+xe3GseDzsedkLDojPeARnjXid0vIWfatbFN4NYlGAvFsberAlEXw2x0nxty60j
         0QmNEB1me0rsPxADGnuzU1GtG6DjTvs27MHPCzGVN29II6Zg6zyO8+fJAgVYbTiDGh9F
         gl34ycMVgCVsZ00AuCSOvPonhOwNXgabzzKbRSIUdPEXpjynyilIwKa6Zphv9vZNdLEr
         6hKbFqy1raIHweqHIzMEQIzcS0OemHpJ508SDMwo7DYAokhiqcPAFUuDIcpLBiqKthf0
         aS+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178039; x=1750782839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0sO4FG8MJlTgihEHf66llt9xMF7CLK1g/3AupI01Bo=;
        b=JdEocSE25Tx73J8ANlyO3dIhw3LtLxjBzZmGcic3Wg7ui51bUFLt0S1ib0r6YBw8QG
         bL/KM3nvM813z3i1k5p7UfBNBrmPPMQ/h1+v1Nd5ue7wZEqH9hhNCM74kfVsd6I5nFkk
         rwG8XZSURrN6S252qYoQInNtymC6I4tp2XsVJ+adbDinEcdp7QNrQWplI55mSpu3vR7s
         eS9b/sAdXRCCQ2o/HINEWSChBaMEnYRUrhofkYq+NLvkkyecIDbHzDUdMj2FOcasOj9y
         bjWQG9ySW3PquCJ65YHZm6wnThuuR1OAUr6/zgnrvJcINgEfemJ6NpdQX2YCAks/ErZe
         M4pA==
X-Forwarded-Encrypted: i=1; AJvYcCWGZoTi6B7nFrWu2qDEOf/5zqNz19+KTNr6Si+9OryQ03FgKbkEZk/eE+RhWYJS3mGJs1o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwziaobTmBfTHFshomJfJCh6FNfIcX6fConBB8GhFiJfCw6fy87
	7LotUuDM+UMPHk5OidWGx7zPUufvtHnuvZ29l6J3YWcQacImR9UUs8ZpF/pzhEpgNzY=
X-Gm-Gg: ASbGncu5b0vZ6FwgXnULjg3ypHEYYO9YM2CW54RT8tfHl9JiBNAKwIQkYOx62j1KAmx
	mXYa/uc+W9UgekpUEx6yRgbkM4eUAPdoLPNNTMdXTXfBqziWY/7fTfNxTFhgGO8uy3Uo1SyqWKO
	EzVDu9tKENBsw7n7d+J0iCfHS/puNnSw0TBO3z/coAF1Vi1hKWjoGT3ztDvku/t63gOd+vd6kBm
	1h0VX2Z3K6PeK17MenmMPWuriDGHQJRUrUxUQdnC2dMtPOBS625YoOsat9/DuANpTh1VYF8zXp0
	PDEAwa4L7761buatv5tzsqzGpcXMgKi9bltYM5AcpEv6SmwoMLNVSD4R8IbYQupMARfvE7gIPQ=
	=
X-Google-Smtp-Source: AGHT+IHtPPp86JB1WL2NUMpWWPzLqOSjoM5yKoDid7gycB2n4vWQmDxDEGw2087UlKh+t1YO5wHSuA==
X-Received: by 2002:a05:600c:3b92:b0:43d:2230:300f with SMTP id 5b1f17b1804b1-4533c9c6e8fmr147105255e9.0.1750178038731;
        Tue, 17 Jun 2025 09:33:58 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a73845sm14651906f8f.35.2025.06.17.09.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C30215F91D;
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
Subject: [RFC PATCH 09/11] kvm/arm: implement sysreg trap handler
Date: Tue, 17 Jun 2025 17:33:49 +0100
Message-ID: <20250617163351.2640572-10-alex.bennee@linaro.org>
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

Fortunately all the information about which sysreg is being accessed
should be in the ISS field of the ESR. Once we process that we can
figure out what we need to do.

[AJB: the read/write stuff should probably go into a shared helper].

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/kvm.c        | 95 +++++++++++++++++++++++++++++++++++++++++
 target/arm/trace-events |  2 +
 2 files changed, 97 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f2255cfdc8..0a852af126 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -24,6 +24,7 @@
 #include "system/runstate.h"
 #include "system/kvm.h"
 #include "system/kvm_int.h"
+#include "cpregs.h"
 #include "kvm_arm.h"
 #include "cpu.h"
 #include "trace.h"
@@ -1414,6 +1415,98 @@ static bool kvm_arm_handle_debug(ARMCPU *cpu,
     return false;
 }
 
+/*
+ * To handle system register traps we should be able to extract the
+ * encoding from the ISS encoding and go from there.
+ */
+static int kvm_arm_handle_sysreg_trap(ARMCPU *cpu,
+                                      uint64_t esr_iss,
+                                      uint64_t elr)
+{
+    int op0 = extract32(esr_iss, 20, 2);
+    int op2 = extract32(esr_iss, 17, 3);
+    int op1 = extract32(esr_iss, 14, 3);
+    int crn = extract32(esr_iss, 10, 4);
+    int rt = extract32(esr_iss, 5, 5);
+    int crm = extract32(esr_iss, 1, 4);
+    bool is_read = extract32(esr_iss, 0, 1);
+
+    uint32_t key = ENCODE_AA64_CP_REG(CP_REG_ARM64_SYSREG_CP, crn, crm, op0, op1, op2);
+    const ARMCPRegInfo *ri = get_arm_cp_reginfo(cpu->cp_regs, key);
+
+    if (ri) {
+        CPUARMState *env = &cpu->env;
+        uint64_t val = 0;
+        bool take_bql = ri->type & ARM_CP_IO;
+
+        if (ri->accessfn) {
+            if (ri->accessfn(env, ri, true) != CP_ACCESS_OK) {
+                g_assert_not_reached();
+            }
+        }
+
+        if (take_bql) {
+            bql_lock();
+        }
+
+        if (is_read) {
+            if (ri->type & ARM_CP_CONST) {
+                val = ri->resetvalue;
+            } else if (ri->readfn) {
+                val = ri->readfn(env, ri);
+            } else {
+                val = CPREG_FIELD64(env, ri);
+            }
+            trace_kvm_sysreg_read(ri->name, val);
+
+            if (rt < 31) {
+                env->xregs[rt] = val;
+            } else {
+                /* this would be deeply weird */
+                g_assert_not_reached();
+            }
+        } else {
+            /* x31 == zero reg */
+            if (rt < 31) {
+                val = env->xregs[rt];
+            }
+
+            if (ri->writefn) {
+                ri->writefn(env, ri, val);
+            } else {
+                CPREG_FIELD64(env, ri) = val;
+            }
+            trace_kvm_sysreg_write(ri->name, val);
+        }
+
+        if (take_bql) {
+            bql_unlock();
+        }
+
+        /*
+         * Set PC to return.
+         *
+         * Note we elr_el2 doesn't seem to be what we need so lets
+         * rely on env->pc being correct.
+         *
+         * TODO We currently skip to the next instruction
+         * unconditionally but that is at odds with the kernels code
+         * which only does that conditionally (see kvm_handle_sys_reg
+         * -> perform_access):
+         *
+         *    if (likely(r->access(vcpu, params, r)))
+         *        kvm_incr_pc(vcpu);
+         *
+         */
+        env->pc = env->pc + 4;
+        return 0;
+    }
+
+    fprintf(stderr, "%s: @ %" PRIx64 " failed to find sysreg crn:%d crm:%d op0:%d op1:%d op2:%d\n",
+            __func__, elr, crn, crm, op0, op1, op2);
+    return -1;
+}
+
 /**
  * kvm_arm_handle_hard_trap:
  * @cpu: ARMCPU
@@ -1443,6 +1536,8 @@ static int kvm_arm_handle_hard_trap(ARMCPU *cpu,
     kvm_cpu_synchronize_state(cs);
 
     switch (esr_ec) {
+    case EC_SYSTEMREGISTERTRAP:
+        return kvm_arm_handle_sysreg_trap(cpu, esr_iss, elr);
     default:
         qemu_log_mask(LOG_UNIMP, "%s: unhandled EC: %x/%x/%x/%d\n",
                 __func__, esr_ec, esr_iss, esr_iss2, esr_il);
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 4438dce7be..69bb4d370d 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,3 +13,5 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+kvm_sysreg_read(const char *name, uint64_t val) "%s => 0x%" PRIx64
+kvm_sysreg_write(const char *name, uint64_t val) "%s <=  0x%" PRIx64
-- 
2.47.2


