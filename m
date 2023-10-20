Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DF57D1430
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 18:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377826AbjJTQiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 12:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjJTQiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 12:38:00 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEA6D61
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:37:58 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-9ba1eb73c27so169010866b.3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697819877; x=1698424677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QpJSioSzBNTf91irQMN8BpZyzwJ1kd2+nNN3fujF2w=;
        b=qBRTZfMyknI6dO/8/o9eqamL6MZM3+TSpGNKwkHjELr90xzl/6bKrGRt09peGvbrtM
         P62Dr55x7iYUJVhXkBwqIac9TuN96uml6xsr5SAv02kzB0EIbbTDTkFbCNVItXTQaJmT
         pX4ZOorILAaLRqKUHLZCLjN7VMNvNg50GGUF5KNARz4kOLx35af8YR/VnXnYBxM84DtT
         rC5e8nghJKaxEBkmY690PgG4KreyUXPFwY1txRnXHhtxAu4kthyE4qJZHLzSc4VGrlzo
         H7fzFHoOUo+AorcFGFM+mZ2NKVKJGCGbCCg1DOZCGlEq+fEYMHFI+Z7V9KDbppdfMO1h
         M/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697819877; x=1698424677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0QpJSioSzBNTf91irQMN8BpZyzwJ1kd2+nNN3fujF2w=;
        b=Dc0MJ48C9gO1U803ChNwpCQyYX5KbdBnaqfqPJ4aZ+re9292HC4RQ4WjtmuPCj0ru6
         HZvRdqyViOroX5TAERMee7fukPaA0+PhUKIo7tYC2XINwBiCW1H2CnpRXWz0tVav1TfW
         CjvPE+lHOaTenh162RU4oIzRYbjTTQrzJb2pjC5HziBL+OYvDEmLkT3CTaRTXyQnovtF
         J2UmbBPWC/mIXws+tFSaONN2X+lJXay+HLlDMRUXNDXZahT23zztSDUZZpdof/rhn/fL
         HlirGwj5OtY4h/JSGBw+rom/R1rSOpSzw3Wmrohs164whl+corTzsHbXJltDCJ1YJrd/
         jR0Q==
X-Gm-Message-State: AOJu0YyXWCRPSoqcIYQ/FEXPta5ZtVYsz7GjMvR6EeKkeOYvsgupleM6
        43OzGAz+LOW0p4x+zsyJ9md+yA==
X-Google-Smtp-Source: AGHT+IHqqcCwQhtVKj3SGAIse1HKAYov1qgaQecpg8n6CsqYo+8qJqXaoPpYybRA/SRbJ+rMfgxwJw==
X-Received: by 2002:a17:907:988:b0:9c5:2806:72e2 with SMTP id bf8-20020a170907098800b009c5280672e2mr1733573ejc.34.1697819877055;
        Fri, 20 Oct 2023 09:37:57 -0700 (PDT)
Received: from m1x-phil.lan (tbo33-h01-176-171-212-97.dsl.sta.abo.bbox.fr. [176.171.212.97])
        by smtp.gmail.com with ESMTPSA id pw17-20020a17090720b100b009bd9ac83a9fsm1771713ejb.152.2023.10.20.09.37.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Oct 2023 09:37:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-arm@nongnu.org, qemu-riscv@nongnu.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Zhao Liu <zhao1.liu@intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 09/19] cpus: Filter for target specific CPU (x86)
Date:   Fri, 20 Oct 2023 18:36:31 +0200
Message-ID: <20231020163643.86105-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020163643.86105-1-philmd@linaro.org>
References: <20231020163643.86105-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enforce qemu_get_cpu() to return X86 CPUs in X86 specific files.

Mechanical change using the following coccinelle script:

  @@ expression index; @@
  -   qemu_get_cpu(index, NULL)
  +   qemu_get_cpu(index, TYPE_X86_CPU)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/hyperv/hyperv.c        |  2 +-
 hw/i386/kvm/xen_evtchn.c  |  8 ++++----
 target/i386/kvm/xen-emu.c | 14 +++++++-------
 target/i386/monitor.c     |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index a43f29ad8d..cdda93e14d 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -226,7 +226,7 @@ struct HvSintRoute {
 
 static CPUState *hyperv_find_vcpu(uint32_t vp_index)
 {
-    CPUState *cs = qemu_get_cpu(vp_index, NULL);
+    CPUState *cs = qemu_get_cpu(vp_index, TYPE_X86_CPU);
     assert(hyperv_vp_index(cs) == vp_index);
     return cs;
 }
diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index de3650ba3b..d75b53934d 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -542,7 +542,7 @@ static void deassign_kernel_port(evtchn_port_t port)
 static int assign_kernel_port(uint16_t type, evtchn_port_t port,
                               uint32_t vcpu_id)
 {
-    CPUState *cpu = qemu_get_cpu(vcpu_id, NULL);
+    CPUState *cpu = qemu_get_cpu(vcpu_id, TYPE_X86_CPU);
     struct kvm_xen_hvm_attr ha;
 
     if (!cpu) {
@@ -589,7 +589,7 @@ static bool valid_port(evtchn_port_t port)
 
 static bool valid_vcpu(uint32_t vcpu)
 {
-    return !!qemu_get_cpu(vcpu, NULL);
+    return !!qemu_get_cpu(vcpu, TYPE_X86_CPU);
 }
 
 static void unbind_backend_ports(XenEvtchnState *s)
@@ -917,7 +917,7 @@ static int set_port_pending(XenEvtchnState *s, evtchn_port_t port)
 
     if (s->evtchn_in_kernel) {
         XenEvtchnPort *p = &s->port_table[port];
-        CPUState *cpu = qemu_get_cpu(p->vcpu, NULL);
+        CPUState *cpu = qemu_get_cpu(p->vcpu, TYPE_X86_CPU);
         struct kvm_irq_routing_xen_evtchn evt;
 
         if (!cpu) {
@@ -1779,7 +1779,7 @@ int xen_evtchn_translate_pirq_msi(struct kvm_irq_routing_entry *route,
         return -EINVAL;
     }
 
-    cpu = qemu_get_cpu(s->port_table[port].vcpu, NULL);
+    cpu = qemu_get_cpu(s->port_table[port].vcpu, TYPE_X86_CPU);
     if (!cpu) {
         return -EINVAL;
     }
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index f289af906c..0a973c0259 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -384,7 +384,7 @@ static void do_set_vcpu_info_gpa(CPUState *cs, run_on_cpu_data data)
 
 void *kvm_xen_get_vcpu_info_hva(uint32_t vcpu_id)
 {
-    CPUState *cs = qemu_get_cpu(vcpu_id, NULL);
+    CPUState *cs = qemu_get_cpu(vcpu_id, TYPE_X86_CPU);
     if (!cs) {
         return NULL;
     }
@@ -418,7 +418,7 @@ void kvm_xen_maybe_deassert_callback(CPUState *cs)
 
 void kvm_xen_set_callback_asserted(void)
 {
-    CPUState *cs = qemu_get_cpu(0, NULL);
+    CPUState *cs = qemu_get_cpu(0, TYPE_X86_CPU);
 
     if (cs) {
         X86_CPU(cs)->env.xen_callback_asserted = true;
@@ -427,7 +427,7 @@ void kvm_xen_set_callback_asserted(void)
 
 void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
 {
-    CPUState *cs = qemu_get_cpu(vcpu_id, NULL);
+    CPUState *cs = qemu_get_cpu(vcpu_id, TYPE_X86_CPU);
     uint8_t vector;
 
     if (!cs) {
@@ -491,7 +491,7 @@ static void do_set_vcpu_timer_virq(CPUState *cs, run_on_cpu_data data)
 
 int kvm_xen_set_vcpu_virq(uint32_t vcpu_id, uint16_t virq, uint16_t port)
 {
-    CPUState *cs = qemu_get_cpu(vcpu_id, NULL);
+    CPUState *cs = qemu_get_cpu(vcpu_id, TYPE_X86_CPU);
 
     if (!cs) {
         return -ENOENT;
@@ -588,7 +588,7 @@ static int xen_set_shared_info(uint64_t gfn)
     trace_kvm_xen_set_shared_info(gfn);
 
     for (i = 0; i < XEN_LEGACY_MAX_VCPUS; i++) {
-        CPUState *cpu = qemu_get_cpu(i, NULL);
+        CPUState *cpu = qemu_get_cpu(i, TYPE_X86_CPU);
         if (cpu) {
             async_run_on_cpu(cpu, do_set_vcpu_info_default_gpa,
                              RUN_ON_CPU_HOST_ULONG(gpa));
@@ -834,7 +834,7 @@ static int kvm_xen_hcall_evtchn_upcall_vector(struct kvm_xen_exit *exit,
         return -EINVAL;
     }
 
-    target_cs = qemu_get_cpu(up.vcpu, NULL);
+    target_cs = qemu_get_cpu(up.vcpu, TYPE_X86_CPU);
     if (!target_cs) {
         return -EINVAL;
     }
@@ -1161,7 +1161,7 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_xen_exit *exit, X86CPU *cpu,
 {
     CPUState *cs = CPU(cpu);
     CPUState *dest = cs->cpu_index == vcpu_id ? cs : qemu_get_cpu(vcpu_id,
-                                                                  NULL);
+                                                                  TYPE_X86_CPU);
     int err;
 
     if (!dest) {
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index aca7be61dd..01bfb4e3f1 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -592,7 +592,7 @@ void hmp_mce(Monitor *mon, const QDict *qdict)
     if (qdict_get_try_bool(qdict, "broadcast", false)) {
         flags |= MCE_INJECT_BROADCAST;
     }
-    cs = qemu_get_cpu(cpu_index, NULL);
+    cs = qemu_get_cpu(cpu_index, TYPE_X86_CPU);
     if (cs != NULL) {
         cpu = X86_CPU(cs);
         cpu_x86_inject_mce(mon, cpu, bank, status, mcg_status, addr, misc,
-- 
2.41.0

