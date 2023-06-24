Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06AF73CC24
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjFXRmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjFXRmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:42:20 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7063D2107
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:09 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f918922954so17420995e9.2
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628528; x=1690220528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UX7A/4NpufAJKKWp2HGkO2gs63RM9WYyIFTo3iDzXaM=;
        b=SMLuGhbM3MaDMV9r6KR7RvXRIKqv+XtIKbKhRTt6D/Vm3gPRwn5blrByxm/Fk9daGq
         Eb4uDULNXVOFNfUHg3fRZgZ5xRjJUoWuQu17MVMm3n1dxkZmf9mr8seaW6sh6rqV8TYt
         6SkaklT3irVTc01XNANs6JtTVfJ/FHNjbknlsytNfopuGsAcWX0i+Bz99JeARomRP7wT
         3sX7v4bNKtTFAn7JegwwEUztQwWXg0bS+L/YlefFCRCGukVOw//BD43mbeY6bdWXzIJE
         5DKMSwa60c9c1kSx6wlSfXeF1ud/A4ZzVtV5mMPh9L+rICPmtFtVUo1zCaI4F1bzZEU8
         8N6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628528; x=1690220528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UX7A/4NpufAJKKWp2HGkO2gs63RM9WYyIFTo3iDzXaM=;
        b=AoTw60xnL4idPIu4CXskV46Ly+QnNWkTt6MQJ+7Bzws0lodhe8npsFLzZJTHRxjVYr
         fcdu90uClRUj6ZKG8ZSVl48QC1drUOdrDwzeQmAM5vah4XnGmfbvCR7AyK0dvmcupCbc
         gOqFcKlkGmQmKzPn6rB/hMh/sDp50V/e6R09ZDeffmDHeXOWbAHkwTeQyf7JO+Ck8utf
         hlqmo2qJlUSLZzY9ALWh1rrv59KWIupdt+SIV/2EOpCnfGa51CH6GL9qCGhhz9NUK23d
         ALlnEJylfKhpVNQYkFMOaaP5C3l2hW9fGKR6WFfiAabWXg91317+c0z13/c+0qrcl7KR
         BRNg==
X-Gm-Message-State: AC+VfDx6hJUq3fW396f2hIkIH8pc/SVcF6xIl4gRGdBiNbxSBy7Gl6HF
        DrP5FsDcCmlb5mfh9K/xh6hTXA==
X-Google-Smtp-Source: ACHHUZ7yOaurvWT1v2FwBkdZ9j/78UpmqCV6GWSwnA9KFjQtIRVj6Tbvs3g7WLhoyLu/xsqSjabGsQ==
X-Received: by 2002:a7b:cd97:0:b0:3f9:a6f3:f23d with SMTP id y23-20020a7bcd97000000b003f9a6f3f23dmr13083870wmj.13.1687628527874;
        Sat, 24 Jun 2023 10:42:07 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id p4-20020a7bcc84000000b003f9c8c6bf53sm2714753wma.13.2023.06.24.10.42.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:42:07 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 06/16] accel: Rename 'hax_vcpu' as 'accel' in CPUState
Date:   Sat, 24 Jun 2023 19:41:11 +0200
Message-Id: <20230624174121.11508-7-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
References: <20230624174121.11508-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All accelerators will share a single opaque context
in CPUState. Start by renaming 'hax_vcpu' as 'accel'.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h           |  2 +-
 target/i386/hax/hax-accel-ops.c |  2 +-
 target/i386/hax/hax-all.c       | 18 +++++++++---------
 target/i386/nvmm/nvmm-all.c     |  6 +++---
 target/i386/whpx/whpx-all.c     |  6 +++---
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 4871ad85f0..84b5a866e7 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -441,7 +441,7 @@ struct CPUState {
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

