Return-Path: <kvm+bounces-60205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A72BE4E12
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 713BE5E13FA
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B337B21FF5F;
	Thu, 16 Oct 2025 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="JN5jeqlo"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster4-host4-snip4-4.eps.apple.com [57.103.78.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABFC21CA13
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636331; cv=none; b=r9NpIQWgjRnxw7upmfuLD9I8BisxyLceNE1N5tL61IBY8BaZNwP1WMe4cquE7VCK8s60SChHmsmLrk839OBiR5UlYVDl83x3ZZEkp5XavRf/qEYOLMBAsMxRkWpjgILTaEgueoqbGMueAFP+9rO+xn1yFdBO5l1GgF4hx/JCFJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636331; c=relaxed/simple;
	bh=9eQeH1V7naQ6it+UiGCl8Yg3+DXpMtW2ttIFvbR6c1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ji9f+jNnEjNRbZksl3CYdzjTBtZTTva7himb6eCWXUDRn+yNxk60g5reCgF6WKTEMZRWOLKfNqZs2M7QtnTADadj8k1Pu2uZZqUfcLpocsFj98tgB5aU+STT1KzJRSBWatMwGctdjzlb9ozxGKQvWuqWl0xJGD0DLBSSWsq95T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=JN5jeqlo; arc=none smtp.client-ip=57.103.78.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 71BFD18000B4;
	Thu, 16 Oct 2025 17:38:43 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=h7u/XWsux0pmMZnA7+paR99F4ZhLVNBkIu/tmCtAH0I=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=JN5jeqlo2Exp4YvILakcUUrx3AjSfjGt663Ogt/r53YZdHbDYW81d6YRofnLWLuggocs2PxdwMi+ILVyXvrO9cYkUQqVQVctlEWC7sOtgTmrI8XSsPRt3butg8HkLJ7xmkne++3HJbH8zlvHLLWTcHZUrhMKOqVkvFWQeNw97LAP9rl2sdY9kc8YzXBhJiTnUaXuyp8X0VqflV9UgZksyrqWzQZUbOjQxXrGQYSGnEFZdIDNhtKL1T3XC1JpKfib71GfxgEqVS+IP5PXUB9q4/pJ9sWnuRYSAVve2PsiN7cFbMmt4gp4hhblKmP64M6Cr9Cgbke1V6HIjdXRYOdFtQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 68FC6180011E;
	Thu, 16 Oct 2025 17:38:39 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Igor Mammedov <imammedo@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 10/24] hw, target, accel: whpx: change apic_in_platform to kernel_irqchip
Date: Thu, 16 Oct 2025 19:37:49 +0200
Message-ID: <20251016173803.65764-11-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016173803.65764-1-mohamed@unpredictable.fr>
References: <20251016173803.65764-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: DnZSo4s4XFJnREjgYizwyW10D3MEFkuo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfXxca1J95xqtkD
 /kiEI75dPjqax2czblyuIxQ+H9QHIbJjDUA88EtUEk464RpKn75D8bgYft16QTJtxy9LGE0V+d7
 vJfmmLynTWXLBdLvTBR/Vlr2a7ihxJ6wJC+tgSDfCeRDLi2FfOum4wmRBX3qh/Hh7JFcjCJbKQF
 Eq1x319FNsAsyFVmqPfNjlpZj82wAsVZ37+zWx3wMVy+er11yG0e7MFeEMi2x1KXI3sgrz23YyY
 AaHh4zty2KrlsM6BxsBpb7of33eCqtmmG0Uy4rwu/65Ce/EqYN5ZruEq/3vPxcFt8zgHnmRuE=
X-Proofpoint-GUID: DnZSo4s4XFJnREjgYizwyW10D3MEFkuo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABdYQDfXaimbPEVmD7jPciPmOIiYTIt+BYBc5nSBvYHn/MWMS4G7zM07R8USejcSp4bl0qBRtJE9+3JOBumNcGZO4aMhIx3bRLlmGVNQ2kwKicNAV3tOrrLPEV8ZlsZVkluEYJ7mSfemSOKHGPBXVblU9N7T5I10w8Gg5ijqz7GoWSBJ+xoUbM+1Hjl2hJoA2Q2A2qTNsCsk94x5SP4i1Uoan4t+TppG6imzpR4PSuWGgnT9WZdf46qwS2gDyIzCTTPCbK41wNL1vFTm/jV4D0S+lzusUXSuP1Q0Tcv1qs0HrDmoM5oVfTB2IUAy8mxaNYGbU7pt3PbD+8jHR+0lzPjzldGMFyr6krPKfQxRiBoPsmvU329XpdShLuv1PQCDAMgwu+h+fL63RYOhSyfuEShTUkiPSRHhLBZFLwxKQOFBveEyyPFD8DQdJHOk2kJEt6i3BJLANYv+uiCEAnm3jbLph9aAlNMF0Taio7lgGBPkXxGl5stpt4DGOjMiCCGhf0vD+iWOsC9rEBS5RPg0k6rrX2kdAnQKFWu/utUk3zjgp0fIII5qiSVSXA5pOsK4bLrr93eUbHffo8nSUaYv92UVEcdgHpBfGItpQirsaZfjsmpY/BgwlmNOwfMSoL+pOnrivNfpOOpr3LBWFBQ0NR5COdgoWU9aynWgcMP75bqrYJu7J96Cu4bfBT/T4Hz/FtkmhVjI2UCTck+mqSoLLn2FV7eAZ/CsBwzcESiaQ4es5Mj6vDY7OVTxInzxgRGcALDTZ1SRSPJ4nS5vMQ5NLoYrH4T7gngR9wOnb3JJZIe0jv9C/W0FamZbZH+UZ0CMQF6UV9IgT33djtyhvZlQlJsZeCfOjyHOAqunKKAkTwnbsYtqB7W0s6f394T+2dN+/J54zjM6fkr/mjYrJ7ootYLM5xAKX+mj4=

Change terminology to match the KVM one, as APIC is x86-specific.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/whpx/whpx-accel-ops.c    |  2 +-
 accel/whpx/whpx-common.c       |  4 ++--
 hw/i386/x86-cpu.c              |  4 ++--
 include/system/whpx-internal.h |  2 +-
 include/system/whpx.h          |  4 ++--
 target/i386/cpu-apic.c         |  2 +-
 target/i386/whpx/whpx-all.c    | 14 +++++++-------
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/accel/whpx/whpx-accel-ops.c b/accel/whpx/whpx-accel-ops.c
index c84a25c273..50fadea0fd 100644
--- a/accel/whpx/whpx-accel-ops.c
+++ b/accel/whpx/whpx-accel-ops.c
@@ -78,7 +78,7 @@ static void whpx_kick_vcpu_thread(CPUState *cpu)
 
 static bool whpx_vcpu_thread_is_idle(CPUState *cpu)
 {
-    return !whpx_apic_in_platform();
+    return !whpx_irqchip_in_kernel();
 }
 
 static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index c0ff6cacb8..18d93225c1 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -496,9 +496,9 @@ static const TypeInfo whpx_cpu_accel_type = {
  * Partition support
  */
 
-bool whpx_apic_in_platform(void)
+bool whpx_irqchip_in_kernel(void)
 {
-    return whpx_global.apic_in_platform;
+    return whpx_global.kernel_irqchip;
 }
 
 static void whpx_accel_class_init(ObjectClass *oc, const void *data)
diff --git a/hw/i386/x86-cpu.c b/hw/i386/x86-cpu.c
index c876e6709e..778607e7ca 100644
--- a/hw/i386/x86-cpu.c
+++ b/hw/i386/x86-cpu.c
@@ -45,7 +45,7 @@ static void pic_irq_request(void *opaque, int irq, int level)
 
     trace_x86_pic_interrupt(irq, level);
     if (cpu_is_apic_enabled(cpu->apic_state) && !kvm_irqchip_in_kernel() &&
-        !whpx_apic_in_platform()) {
+        !whpx_irqchip_in_kernel()) {
         CPU_FOREACH(cs) {
             cpu = X86_CPU(cs);
             if (apic_accept_pic_intr(cpu->apic_state)) {
@@ -71,7 +71,7 @@ int cpu_get_pic_interrupt(CPUX86State *env)
     X86CPU *cpu = env_archcpu(env);
     int intno;
 
-    if (!kvm_irqchip_in_kernel() && !whpx_apic_in_platform()) {
+    if (!kvm_irqchip_in_kernel() && !whpx_irqchip_in_kernel()) {
         intno = apic_get_interrupt(cpu->apic_state);
         if (intno >= 0) {
             return intno;
diff --git a/include/system/whpx-internal.h b/include/system/whpx-internal.h
index e57d2c8526..366bc525a3 100644
--- a/include/system/whpx-internal.h
+++ b/include/system/whpx-internal.h
@@ -42,7 +42,7 @@ struct whpx_state {
 
     bool kernel_irqchip_allowed;
     bool kernel_irqchip_required;
-    bool apic_in_platform;
+    bool kernel_irqchip;
 };
 
 extern struct whpx_state whpx_global;
diff --git a/include/system/whpx.h b/include/system/whpx.h
index 00f6a3e523..98fe045ba1 100644
--- a/include/system/whpx.h
+++ b/include/system/whpx.h
@@ -26,10 +26,10 @@
 #ifdef CONFIG_WHPX_IS_POSSIBLE
 extern bool whpx_allowed;
 #define whpx_enabled() (whpx_allowed)
-bool whpx_apic_in_platform(void);
+bool whpx_irqchip_in_kernel(void);
 #else /* !CONFIG_WHPX_IS_POSSIBLE */
 #define whpx_enabled() 0
-#define whpx_apic_in_platform() (0)
+#define whpx_irqchip_in_kernel() (0)
 #endif /* !CONFIG_WHPX_IS_POSSIBLE */
 
 #endif /* QEMU_WHPX_H */
diff --git a/target/i386/cpu-apic.c b/target/i386/cpu-apic.c
index 242a05fdbe..d4d371a616 100644
--- a/target/i386/cpu-apic.c
+++ b/target/i386/cpu-apic.c
@@ -32,7 +32,7 @@ APICCommonClass *apic_get_class(Error **errp)
         apic_type = "kvm-apic";
     } else if (xen_enabled()) {
         apic_type = "xen-apic";
-    } else if (whpx_apic_in_platform()) {
+    } else if (whpx_irqchip_in_kernel()) {
         apic_type = "whpx-apic";
     }
 
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index d1f8e49cb2..feabbec427 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -607,7 +607,7 @@ void whpx_get_registers(CPUState *cpu)
                      hr);
     }
 
-    if (whpx_apic_in_platform()) {
+    if (whpx_irqchip_in_kernel()) {
         /*
          * Fetch the TPR value from the emulated APIC. It may get overwritten
          * below with the value from CR8 returned by
@@ -749,7 +749,7 @@ void whpx_get_registers(CPUState *cpu)
 
     assert(idx == RTL_NUMBER_OF(whpx_register_names));
 
-    if (whpx_apic_in_platform()) {
+    if (whpx_irqchip_in_kernel()) {
         whpx_apic_get(x86_cpu->apic_state);
     }
 
@@ -1379,7 +1379,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
     }
 
     /* Get pending hard interruption or replay one that was overwritten */
-    if (!whpx_apic_in_platform()) {
+    if (!whpx_irqchip_in_kernel()) {
         if (!vcpu->interruption_pending &&
             vcpu->interruptable && (env->eflags & IF_MASK)) {
             assert(!new_int.InterruptionPending);
@@ -1552,7 +1552,7 @@ int whpx_vcpu_run(CPUState *cpu)
 
     if (exclusive_step_mode == WHPX_STEP_NONE) {
         whpx_vcpu_process_async_events(cpu);
-        if (cpu->halted && !whpx_apic_in_platform()) {
+        if (cpu->halted && !whpx_irqchip_in_kernel()) {
             cpu->exception_index = EXCP_HLT;
             qatomic_set(&cpu->exit_request, false);
             return 0;
@@ -1641,7 +1641,7 @@ int whpx_vcpu_run(CPUState *cpu)
             break;
 
         case WHvRunVpExitReasonX64ApicEoi:
-            assert(whpx_apic_in_platform());
+            assert(whpx_irqchip_in_kernel());
             ioapic_eoi_broadcast(vcpu->exit_ctx.ApicEoi.InterruptVector);
             break;
 
@@ -2186,7 +2186,7 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
                 goto error;
             }
         } else {
-            whpx->apic_in_platform = true;
+            whpx->kernel_irqchip = true;
         }
     }
 
@@ -2195,7 +2195,7 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
     prop.ExtendedVmExits.X64MsrExit = 1;
     prop.ExtendedVmExits.X64CpuidExit = 1;
     prop.ExtendedVmExits.ExceptionExit = 1;
-    if (whpx_apic_in_platform()) {
+    if (whpx_irqchip_in_kernel()) {
         prop.ExtendedVmExits.X64ApicInitSipiExitTrap = 1;
     }
 
-- 
2.50.1 (Apple Git-155)


