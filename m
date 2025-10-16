Return-Path: <kvm+bounces-60154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DC5BE4B56
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:58:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC9043BE00E
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6D9346A1A;
	Thu, 16 Oct 2025 16:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="GxHSKKP5"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster1-host2-snip4-6.eps.apple.com [57.103.76.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CC1330D5E
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633835; cv=none; b=DPz/meKo8YKYCCatL7tnEqNn3/UdmfnLpq8wrC0zhJSpW6BO9WNIcSOx5p9FzwDECQK0/xUY/X1zhXlaTQZnEvNBZtNst1Iim/xBkrLPS2+7Gl+zJhsNYWn1j/w9t48PiPz5AXKr1xhVNxJM2KmDq+s2NkVpUrP05wcP7qzQbfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633835; c=relaxed/simple;
	bh=9eQeH1V7naQ6it+UiGCl8Yg3+DXpMtW2ttIFvbR6c1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkRiby8lF5Infg/BitKXQ0v3y0sHiFW0ZeUwk6UZrkM1+YElqfnSkfOtQaLpYUx7CGXeGPyWwTk80LzFeHgz64PAdnRVnQoGRg4BM5zNIBRc4ImNTo5wgPU629Rfc7MId5f2KxyDi3j5FwEJg75yvr5S5C/DkzKIZDO/MnJ3iWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=GxHSKKP5; arc=none smtp.client-ip=57.103.76.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPS id 2606918001FD;
	Thu, 16 Oct 2025 16:57:09 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=h7u/XWsux0pmMZnA7+paR99F4ZhLVNBkIu/tmCtAH0I=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=GxHSKKP5KfdhVWTmVMHw3jnFn1icmcpaUD4AkHd5J4a/5DL9r4L4f7UqPpyROS6voss6jzEIbNLr/Z1S/wob2rlIVqnftqdWIK/YF253oAH+5y2TyY8qLbzJDzA0az/PlRPHnfLWGzgc0nFUA9FFFAq+Q+3ESaSCSVQpln9Nlyu1yvW9KMr/7ImhKfaUfBe/OQBmf7mgzliJbRUANOsg86/VuWq15j0EkAC6Yq3ani2z3WjA9T+IO7mW1wjYEWNoDzviZaPspiHum8Ofbo6b4wxAS7NfCrwrs3/JHRkKQcj+40qhY003yY5yzT9oChSJTBlVirxWT1QShfcAypatbQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-2 (Postfix) with ESMTPSA id 30FF318024C9;
	Thu, 16 Oct 2025 16:55:57 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 10/24] hw, target, accel: whpx: change apic_in_platform to kernel_irqchip
Date: Thu, 16 Oct 2025 18:55:06 +0200
Message-ID: <20251016165520.62532-11-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016165520.62532-1-mohamed@unpredictable.fr>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: bNNSvIik7Ue097Ccdwp2dYK7CeAQcsAP
X-Proofpoint-GUID: bNNSvIik7Ue097Ccdwp2dYK7CeAQcsAP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyMyBTYWx0ZWRfX5sEZ/CG/5J6E
 ioC8LiV6uVceX5Gs06uMbiGwECs5U0DH6EPFxtnThYEq6eGFblYra5oAVonjF1chQqNY0EhPZoz
 2DFv75iZSk9S7c4U1Sma46YXOYAcLEaoCDk9gGJSedSAsLtlUW0FJ3H6Ex3lE4o9/IL3cJOIdp9
 j7w6cXOwT2bnsmCDUpkL0aGCq+BwNfRlSDEQffe/b9RoXasU+wqLwRhbZE72QKZlPGqzJalPb+l
 ZfNgkLbhdPP/7XFTgMe2GhAQGqPRHLYB4TDue4ocn+tivlEvOEl5HP/ecsTQn2wCf+iwNUau4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 clxscore=1030 bulkscore=0
 malwarescore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2510160123
X-JNJ: AAAAAAABg3kEB3Drvjcchx/D8pXJbOWXPSRCp646G7z8pQnooXrmfVOmUjllUzjsUxqaX1z9E15KgZfqmInD4lip4/veg19NR5Rg8tLuzQuJ2Qvr2NYPhhucgn0fQZxGSAYZZuJhhaC7LgpK2Jk6wSgTuA2n+Gw5Apy5vZkaD8meOyvWoQT5524si4n6DYUHQro5EKFIIca9FJHnwgss9RW5EKLr4o0VGw9OP8ybz7Kl7dejQ/JLAO/52rClr8msJQNPw8u4UiirEihHtsyuWuh6LnyAL18RuFkI5zVTOhrRr4izOahdFrcRUIb3QAKMqoTKriXb9eLRkUZqeQLAXtJhnwhHeqoeHPv51OixeWvRArTUp6KV7sGjwrHqrTZxUKjNUIMUZZNceA6Ixl3zZZcF4N00V2hIPWlJ3LIW7WzP56hRFApFLKJnJXV2ba+7qm0s6E/Qp5uqDhuRM0gjZcBVo5hRyH6yfU37m+1qKU0yx1w0+YOgXF+GDTflI/RmOe4tsxi7YP4UsyDouZktzsJ1OHFpE0/D6RDzOERBOFvYrb1w5ugB+I4FYffX4JjDauJwJVcy52KVx08XIAmWCAmpbdeGRp8BoyDKCCXJw2AOm3I1BSyxecYJJZASWAkBymw8rr0UWEy5fo6GZ75zvc7DbQf1WwRSIt/CDbar8/wEse7v52bKf2DBfpotU0xvHgeRxdEz4qAqOw17haPwUfSpFHghtmjyd9nX5nV7YyBSENFGqK5hhCagb3dYTHvOWPwn2ZspHb1rV/6Nyu69vw97jwY+lTnOWqtCfqq1mS4hptxe76bzVe6JitX9QLF5d9Hiptc1TEH1xLJuEJjoloMiv8iee7b2VAWb+UuE4Gqu7X5TWy0MYwj+lgtboND3Mp2cGciEabZ+wuap4pL0bA2Au4fdfjQNW9Q8knpT

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


