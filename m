Return-Path: <kvm+bounces-60487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB6BBEFD5C
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E9F93BC954
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4E92EA157;
	Mon, 20 Oct 2025 08:12:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D0C2E9735
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760947931; cv=none; b=M6DkGa9LIgT7XgdX60R6yviIEYa6caZXbF6EgayDBUoZff7RJrVGWxOxh3GNuFR73g+L/Ij0mGqTa6sYSPPw2L5iWNuie1RA5ZW2H+/MR6Tl5FldmUAhiVd3V8SRHdSpjrZNOtCcM8lq5cuYmfZFRU8ojA0g4q8c55EuXTqrP1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760947931; c=relaxed/simple;
	bh=xl6z2MD7z0/kO0NqNyvzx47NhVsRIm787DUwg1dg6zk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BLEy3D5SNA1vayoogrYyc58r2g7ZaZsn/RIjEs4jWhA3F2sKgFLrE8w0B97ALGduhBPxhc+jDLirLW/RKzcvsdgxRqWqU/3tpOLQhcg8aQZe/r2T2StnUa3cvj/SxJXt/l1Wvmnt00ji3h3SB46g7nVH2zu54Pyi2O180kjuJSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxE9DU7vVoAzUYAA--.51591S3;
	Mon, 20 Oct 2025 16:12:04 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxZOTQ7vVohSf4AA--.18451S4;
	Mon, 20 Oct 2025 16:12:03 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Song Gao <gaosong@loongson.cn>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [RFC 2/2] target/loongarch: Add PTW feature support in KVM mode
Date: Mon, 20 Oct 2025 16:11:59 +0800
Message-Id: <20251020081159.2370512-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251020081159.2370512-1-maobibo@loongson.cn>
References: <20251020081159.2370512-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxZOTQ7vVohSf4AA--.18451S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implement Hardware page table walker(PTW for short) feature in KVM mode.
Use OnOffAuto type variable ptw to check the PTW feature. If the PTW
feature is not supported with KVM host, it reports error if there is
ptw=on option.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 target/loongarch/cpu.c     |  5 +++--
 target/loongarch/cpu.h     |  1 +
 target/loongarch/kvm/kvm.c | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index b7b61ff877..9aa8f863e9 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -233,12 +233,13 @@ static void loongarch_set_ptw(Object *obj, bool value, Error **errp)
 {
     LoongArchCPU *cpu = LOONGARCH_CPU(obj);
 
+    cpu->ptw = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
+
     if (kvm_enabled()) {
-        /* PTW feature is only support in TCG mode now */
+        /* kvm feature detection in function kvm_arch_init_vcpu */
         return;
     }
 
-    cpu->ptw = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
     cpu->env.cpucfg[2] = FIELD_DP32(cpu->env.cpucfg[2], CPUCFG2, HPTW, value);
 }
 
diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index b1d6799222..1a14469b3b 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -279,6 +279,7 @@ enum loongarch_features {
     LOONGARCH_FEATURE_PMU,
     LOONGARCH_FEATURE_PV_IPI,
     LOONGARCH_FEATURE_STEALTIME,
+    LOONGARCH_FEATURE_PTW,
 };
 
 typedef struct  LoongArchBT {
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index 4e4f4e79f6..26e40c9bdc 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -931,6 +931,12 @@ static bool kvm_feature_supported(CPUState *cs, enum loongarch_features feature)
         ret = kvm_vm_ioctl(kvm_state, KVM_HAS_DEVICE_ATTR, &attr);
         return (ret == 0);
 
+    case LOONGARCH_FEATURE_PTW:
+        attr.group = KVM_LOONGARCH_VM_FEAT_CTRL;
+        attr.attr = KVM_LOONGARCH_VM_FEAT_PTW;
+        ret = kvm_vm_ioctl(kvm_state, KVM_HAS_DEVICE_ATTR, &attr);
+        return (ret == 0);
+
     default:
         return false;
     }
@@ -1029,6 +1035,29 @@ static int kvm_cpu_check_pmu(CPUState *cs, Error **errp)
     return 0;
 }
 
+static int kvm_cpu_check_ptw(CPUState *cs, Error **errp)
+{
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = cpu_env(cs);
+    bool kvm_supported;
+
+    kvm_supported = kvm_feature_supported(cs, LOONGARCH_FEATURE_PTW);
+    if (cpu->ptw == ON_OFF_AUTO_ON) {
+        if (!kvm_supported) {
+            error_setg(errp, "'ptw' feature not supported by KVM on the host");
+            return -ENOTSUP;
+        }
+    } else if (cpu->ptw != ON_OFF_AUTO_AUTO) {
+        /* disable pmu if ON_OFF_AUTO_OFF is set */
+        kvm_supported = false;
+    }
+
+    if (kvm_supported) {
+        env->cpucfg[2] = FIELD_DP32(env->cpucfg[2], CPUCFG2, HPTW, 1);
+    }
+    return 0;
+}
+
 static int kvm_cpu_check_pv_features(CPUState *cs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
@@ -1123,6 +1152,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
         return ret;
     }
 
+    ret = kvm_cpu_check_ptw(cs, &local_err);
+    if (ret < 0) {
+        error_report_err(local_err);
+        return ret;
+    }
+
     return 0;
 }
 
-- 
2.39.3


