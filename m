Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ECD6D7982
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbjDEKTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbjDEKTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:19:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652B22135
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:18:48 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l12so35622606wrm.10
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKKj8/4pIvX0Y2G0Iw2NvkVvuNOgIGf3wL1krYyOhFI=;
        b=zZVWJRJJOaN+7Gbu5U00rRVxIF+M1REi0nasLd2+TX7rCZ676M8HfGZvzPUiiR+jmJ
         LzK21sAAN+g/5CA7pY0t71M+JRU/D0i2mKppiG11wKsb+ATVhKWStv+h8AcYfYWJ7o7q
         ZkVpkMfk04QTu63lwsYX09N6qWIm7uJJV67xns5BXbF7sXdcTtMRBlCsegTqDBPUcmBh
         ARAhBXK711g76VGI42qECVpEmFzwZ0PK4jFw+pyEwqyKB+BJxwBLM0WD1/uRxXapkmvf
         Ej+a+b8eIjRl0xMwS3Wlq5n5DK62HsO8B/0gtpHvOMwDIRcustaLrz9inDPWuLWLPEfj
         UczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JKKj8/4pIvX0Y2G0Iw2NvkVvuNOgIGf3wL1krYyOhFI=;
        b=i15qMUcXxZkOfIjgROVBhsQDnJneC/dKQ2SuXkAtmBxi5ymnJdIW+m9VVfpfthWDvO
         el9sQdc+5t1V8pKyqFD/zBCw3RUbKS3LaIHP7qjsS514BZODbsMFEe0DZFO3pAR0efAC
         tqE2yAIHnIZnEF78t5vfD1ZsPGBvOO37OpLph/Ejx/NqNrTVYACTcLMGLJLYuOWLDQwT
         gQdyoSCBqacSgYsOdtgGNPGZZQs2X+4F8VpJ6DESuW8sA/QfYiVK9zmTm5J5tFkKpOeG
         TUhxDlTuUxMLX0495hywDvTSduKP9x20J3zsrmBsNn/o5Dq+BYAp7cmfFgniz7i1LApH
         iwsg==
X-Gm-Message-State: AAQBX9fMErqAziolirW3PUFsFKLhMgm7nUl2k225qCzsjt6HyqIma2ML
        QMYHIHtupFpz3sWbbUaQ1+KlNA==
X-Google-Smtp-Source: AKy350bkMz7m3CqlZANDFC+N8H247sFug5Oc9sidBbssiHByDywSp20m46NTY3RF7XV/gx2ANc24Hw==
X-Received: by 2002:a5d:68ca:0:b0:2e4:bfa0:8c32 with SMTP id p10-20020a5d68ca000000b002e4bfa08c32mr3774527wrw.47.1680689926542;
        Wed, 05 Apr 2023 03:18:46 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id c1-20020adfef41000000b002d322b9a7f5sm14646618wrp.88.2023.04.05.03.18.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:18:46 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH 05/14] accel: Rename 'hax_vcpu' as 'accel' in CPUState
Date:   Wed,  5 Apr 2023 12:18:02 +0200
Message-Id: <20230405101811.76663-6-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405101811.76663-1-philmd@linaro.org>
References: <20230405101811.76663-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All accelerators will share a single opaque context
in CPUState. Start by renaming 'hax_vcpu' as 'accelCPUState'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h           |  2 +-
 target/i386/hax/hax-accel-ops.c |  2 +-
 target/i386/hax/hax-all.c       | 18 +++++++++---------
 target/i386/nvmm/nvmm-all.c     |  6 +++---
 target/i386/whpx/whpx-all.c     |  6 +++---
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 397fd3ac68..193494cde4 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -442,7 +442,7 @@ struct CPUState {
     /* Used for user-only emulation of prctl(PR_SET_UNALIGN). */
     bool prctl_unalign_sigbus;
 
-    struct hax_vcpu_state *hax_vcpu;
+    struct hax_vcpu_state *accel;
 
     struct hvf_vcpu_state *hvf;
 
diff --git a/target/i386/hax/hax-accel-ops.c b/target/i386/hax/hax-accel-ops.c
index 0157a628a3..a8512efcd5 100644
--- a/target/i386/hax/hax-accel-ops.c
+++ b/target/i386/hax/hax-accel-ops.c
@@ -71,7 +71,7 @@ static void hax_start_vcpu_thread(CPUState *cpu)
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, hax_cpu_thread_fn,
                        cpu, QEMU_THREAD_JOINABLE);
-    assert(cpu->hax_vcpu);
+    assert(cpu->accel);
 #ifdef _WIN32
     cpu->hThread = qemu_thread_get_handle(cpu->thread);
 #endif
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index 38a4323a3c..3865ff9419 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -62,7 +62,7 @@ int valid_hax_tunnel_size(uint16_t size)
 
 hax_fd hax_vcpu_get_fd(CPUArchState *env)
 {
-    struct hax_vcpu_state *vcpu = env_cpu(env)->hax_vcpu;
+    struct hax_vcpu_state *vcpu = env_cpu(env)->accel;
     if (!vcpu) {
         return HAX_INVALID_FD;
     }
@@ -188,7 +188,7 @@ int hax_vcpu_create(int id)
 
 int hax_vcpu_destroy(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    struct hax_vcpu_state *vcpu = cpu->accel;
 
     if (!hax_global.vm) {
         fprintf(stderr, "vcpu %x destroy failed, vm is null\n", vcpu->vcpu_id);
@@ -209,7 +209,7 @@ int hax_vcpu_destroy(CPUState *cpu)
     CloseHandle(cpu->hThread);
 #endif
     g_free(vcpu);
-    cpu->hax_vcpu = NULL;
+    cpu->accel = NULL;
     return 0;
 }
 
@@ -223,7 +223,7 @@ int hax_init_vcpu(CPUState *cpu)
         exit(-1);
     }
 
-    cpu->hax_vcpu = hax_global.vm->vcpus[cpu->cpu_index];
+    cpu->accel = hax_global.vm->vcpus[cpu->cpu_index];
     cpu->vcpu_dirty = true;
     qemu_register_reset(hax_reset_vcpu_state, cpu->env_ptr);
 
@@ -415,7 +415,7 @@ static int hax_handle_io(CPUArchState *env, uint32_t df, uint16_t port,
 static int hax_vcpu_interrupt(CPUArchState *env)
 {
     CPUState *cpu = env_cpu(env);
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    struct hax_vcpu_state *vcpu = cpu->accel;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     /*
@@ -447,7 +447,7 @@ static int hax_vcpu_interrupt(CPUArchState *env)
 
 void hax_raise_event(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    struct hax_vcpu_state *vcpu = cpu->accel;
 
     if (!vcpu) {
         return;
@@ -468,7 +468,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
     int ret = 0;
     CPUState *cpu = env_cpu(env);
     X86CPU *x86_cpu = X86_CPU(cpu);
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    struct hax_vcpu_state *vcpu = cpu->accel;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     if (!hax_enabled()) {
@@ -1114,8 +1114,8 @@ void hax_reset_vcpu_state(void *opaque)
 {
     CPUState *cpu;
     for (cpu = first_cpu; cpu != NULL; cpu = CPU_NEXT(cpu)) {
-        cpu->hax_vcpu->tunnel->user_event_pending = 0;
-        cpu->hax_vcpu->tunnel->ready_for_interrupt_injection = 0;
+        cpu->accel->tunnel->user_event_pending = 0;
+        cpu->accel->tunnel->ready_for_interrupt_injection = 0;
     }
 }
 
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index b75738ee9c..cf4f0af24b 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -52,7 +52,7 @@ static struct qemu_machine qemu_mach;
 static struct qemu_vcpu *
 get_qemu_vcpu(CPUState *cpu)
 {
-    return (struct qemu_vcpu *)cpu->hax_vcpu;
+    return (struct qemu_vcpu *)cpu->accel;
 }
 
 static struct nvmm_machine *
@@ -995,7 +995,7 @@ nvmm_init_vcpu(CPUState *cpu)
     }
 
     cpu->vcpu_dirty = true;
-    cpu->hax_vcpu = (struct hax_vcpu_state *)qcpu;
+    cpu->accel = (struct hax_vcpu_state *)qcpu;
 
     return 0;
 }
@@ -1030,7 +1030,7 @@ nvmm_destroy_vcpu(CPUState *cpu)
     struct qemu_vcpu *qcpu = get_qemu_vcpu(cpu);
 
     nvmm_vcpu_destroy(mach, &qcpu->vcpu);
-    g_free(cpu->hax_vcpu);
+    g_free(cpu->accel);
 }
 
 /* -------------------------------------------------------------------------- */
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 52af81683c..d1ad6f156a 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -262,7 +262,7 @@ static bool whpx_has_xsave(void)
 
 static struct whpx_vcpu *get_whpx_vcpu(CPUState *cpu)
 {
-    return (struct whpx_vcpu *)cpu->hax_vcpu;
+    return (struct whpx_vcpu *)cpu->accel;
 }
 
 static WHV_X64_SEGMENT_REGISTER whpx_seg_q2h(const SegmentCache *qs, int v86,
@@ -2258,7 +2258,7 @@ int whpx_init_vcpu(CPUState *cpu)
 
     vcpu->interruptable = true;
     cpu->vcpu_dirty = true;
-    cpu->hax_vcpu = (struct hax_vcpu_state *)vcpu;
+    cpu->accel = (struct hax_vcpu_state *)vcpu;
     max_vcpu_index = max(max_vcpu_index, cpu->cpu_index);
     qemu_add_vm_change_state_handler(whpx_cpu_update_state, cpu->env_ptr);
 
@@ -2300,7 +2300,7 @@ void whpx_destroy_vcpu(CPUState *cpu)
 
     whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
     whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
-    g_free(cpu->hax_vcpu);
+    g_free(cpu->accel);
     return;
 }
 
-- 
2.38.1

