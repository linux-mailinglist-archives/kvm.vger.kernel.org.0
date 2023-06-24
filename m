Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3235B73CC26
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbjFXRm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjFXRmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:42:23 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E58F1BF7
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:18 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f86dbce369so2319910e87.0
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628537; x=1690220537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jesYnGv71+FK9NHqSWoHnqh4nOCgnV66g281tGNK4XE=;
        b=PSP13nJmGuGfUIHZYTQrZ7FoGcAETjiVze80Ga5o8kpBQN7EVd6/ZzsWnI0bc5+cf2
         7P4AegcanBm6I0AqxSivnZhhIHWzc1EVaUqUBxf50e78O1SpYR4am8GUmpXnKT00dLaD
         YtjYLG64eb2fi0Z3rW8DTkUaUQ1+9LB1hJizePMmfW38t13xGzSESQ8rr931uMREPgJH
         P/L9BhrWugNQhyCgnRt4wqGOi+9bLjVPyPkRVECeAFCL4odpYkKQuWMMJuNDEEDTmIji
         09xQDF2Yw87T4a6e+eKg+ZG6yJNlTJfQ65Pq4Dryt28VK/9aRDBbVC4TNa/AjZOKojLp
         qRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628537; x=1690220537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jesYnGv71+FK9NHqSWoHnqh4nOCgnV66g281tGNK4XE=;
        b=UXC8jV202omaTr/zQZIbvfCyJWrYpyXW4dxP7G/zxhm+K/muGLwTMJmBbpjbMjeg9F
         bN/Fa/Hhyze+ff0i8T7+cJmiB8z8k8wpoXheh1GuwS3koZTd5zDKF02hYiS17uCukJXM
         agfkWkhaJUW8+8TsQra3Hjn9p5YRFwDVOh6pVbHHTqzBhlG4ORvyd2kUeIBm7swNO2qT
         Q+H4QRt//TPqOo4ofQ4ECHwr2xkjTUh2RzEah8iL91GRNokGejWQ7y7v+2pk/2SST2jT
         JabVqpgXL2NTVFtJuMkpxNEWozKaI9cAIPFpGD7g1pvjhht4MuQW09lyQBe4I+zIxXgZ
         9KUA==
X-Gm-Message-State: AC+VfDzhwPowEGaXx/FBFDVlPV+YG+0FzDtM530NHKLKR/HIhp8z/ark
        uoE9R1IcaRbjP5cbFw9BO9X95w==
X-Google-Smtp-Source: ACHHUZ5HouryARGSWaT/lKrQvSPsvbth8CsYlYA04KZeOzupF4wiRSUljoLeinX5wljmzo5CwWGLfg==
X-Received: by 2002:a05:6512:31c7:b0:4f9:5cb9:5be5 with SMTP id j7-20020a05651231c700b004f95cb95be5mr7691618lfe.65.1687628536208;
        Sat, 24 Jun 2023 10:42:16 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id a25-20020a5d4579000000b003048477729asm2596667wrc.81.2023.06.24.10.42.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:42:15 -0700 (PDT)
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
Subject: [PATCH v3 07/16] accel: Rename HAX 'struct hax_vcpu_state' -> AccelCPUState
Date:   Sat, 24 Jun 2023 19:41:12 +0200
Message-Id: <20230624174121.11508-8-philmd@linaro.org>
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

We want all accelerators to share the same opaque pointer in
CPUState. Start with the HAX context, renaming its forward
declarated structure 'hax_vcpu_state' as 'AccelCPUState'.
Document the CPUState field. Directly use the typedef.

Remove the amusing but now unnecessary casts in NVMM / WHPX.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h         |  5 ++---
 include/qemu/typedefs.h       |  1 +
 target/i386/hax/hax-i386.h    |  9 +++++----
 target/i386/hax/hax-all.c     | 16 ++++++++--------
 target/i386/hax/hax-posix.c   |  4 ++--
 target/i386/hax/hax-windows.c |  4 ++--
 target/i386/nvmm/nvmm-all.c   |  2 +-
 target/i386/whpx/whpx-all.c   |  2 +-
 8 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 84b5a866e7..a7fae8571e 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -240,7 +240,6 @@ typedef struct SavedIOTLB {
 struct KVMState;
 struct kvm_run;
 
-struct hax_vcpu_state;
 struct hvf_vcpu_state;
 
 /* work queue */
@@ -308,6 +307,7 @@ struct qemu_work_item;
  * @next_cpu: Next CPU sharing TB cache.
  * @opaque: User data.
  * @mem_io_pc: Host Program Counter at which the memory was accessed.
+ * @accel: Pointer to accelerator specific state.
  * @kvm_fd: vCPU file descriptor for KVM.
  * @work_mutex: Lock to prevent multiple access to @work_list.
  * @work_list: List of pending asynchronous work.
@@ -422,6 +422,7 @@ struct CPUState {
     uint32_t can_do_io;
     int32_t exception_index;
 
+    AccelCPUState *accel;
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
 
@@ -441,8 +442,6 @@ struct CPUState {
     /* Used for user-only emulation of prctl(PR_SET_UNALIGN). */
     bool prctl_unalign_sigbus;
 
-    struct hax_vcpu_state *accel;
-
     struct hvf_vcpu_state *hvf;
 
     /* track IOMMUs whose translations we've cached in the TCG TLB */
diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
index 8c1840bfc1..834b0e47a0 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -21,6 +21,7 @@
  * Incomplete struct types
  * Please keep this list in case-insensitive alphabetical order.
  */
+typedef struct AccelCPUState AccelCPUState;
 typedef struct AccelState AccelState;
 typedef struct AdapterInfo AdapterInfo;
 typedef struct AddressSpace AddressSpace;
diff --git a/target/i386/hax/hax-i386.h b/target/i386/hax/hax-i386.h
index 409ebdb4af..4372ee596d 100644
--- a/target/i386/hax/hax-i386.h
+++ b/target/i386/hax/hax-i386.h
@@ -25,7 +25,8 @@ typedef HANDLE hax_fd;
 #endif
 
 extern struct hax_state hax_global;
-struct hax_vcpu_state {
+
+struct AccelCPUState {
     hax_fd fd;
     int vcpu_id;
     struct hax_tunnel *tunnel;
@@ -46,7 +47,7 @@ struct hax_vm {
     hax_fd fd;
     int id;
     int numvcpus;
-    struct hax_vcpu_state **vcpus;
+    AccelCPUState **vcpus;
 };
 
 /* Functions exported to host specific mode */
@@ -57,7 +58,7 @@ int valid_hax_tunnel_size(uint16_t size);
 int hax_mod_version(struct hax_state *hax, struct hax_module_version *version);
 int hax_inject_interrupt(CPUArchState *env, int vector);
 struct hax_vm *hax_vm_create(struct hax_state *hax, int max_cpus);
-int hax_vcpu_run(struct hax_vcpu_state *vcpu);
+int hax_vcpu_run(AccelCPUState *vcpu);
 int hax_vcpu_create(int id);
 void hax_kick_vcpu_thread(CPUState *cpu);
 
@@ -76,7 +77,7 @@ int hax_host_create_vm(struct hax_state *hax, int *vm_id);
 hax_fd hax_host_open_vm(struct hax_state *hax, int vm_id);
 int hax_host_create_vcpu(hax_fd vm_fd, int vcpuid);
 hax_fd hax_host_open_vcpu(int vmid, int vcpuid);
-int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu);
+int hax_host_setup_vcpu_channel(AccelCPUState *vcpu);
 hax_fd hax_mod_open(void);
 void hax_memory_init(void);
 
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index 3865ff9419..9d9011cc38 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -62,7 +62,7 @@ int valid_hax_tunnel_size(uint16_t size)
 
 hax_fd hax_vcpu_get_fd(CPUArchState *env)
 {
-    struct hax_vcpu_state *vcpu = env_cpu(env)->accel;
+    AccelCPUState *vcpu = env_cpu(env)->accel;
     if (!vcpu) {
         return HAX_INVALID_FD;
     }
@@ -136,7 +136,7 @@ static int hax_version_support(struct hax_state *hax)
 
 int hax_vcpu_create(int id)
 {
-    struct hax_vcpu_state *vcpu = NULL;
+    AccelCPUState *vcpu = NULL;
     int ret;
 
     if (!hax_global.vm) {
@@ -149,7 +149,7 @@ int hax_vcpu_create(int id)
         return 0;
     }
 
-    vcpu = g_new0(struct hax_vcpu_state, 1);
+    vcpu = g_new0(AccelCPUState, 1);
 
     ret = hax_host_create_vcpu(hax_global.vm->fd, id);
     if (ret) {
@@ -188,7 +188,7 @@ int hax_vcpu_create(int id)
 
 int hax_vcpu_destroy(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    AccelCPUState *vcpu = cpu->accel;
 
     if (!hax_global.vm) {
         fprintf(stderr, "vcpu %x destroy failed, vm is null\n", vcpu->vcpu_id);
@@ -263,7 +263,7 @@ struct hax_vm *hax_vm_create(struct hax_state *hax, int max_cpus)
     }
 
     vm->numvcpus = max_cpus;
-    vm->vcpus = g_new0(struct hax_vcpu_state *, vm->numvcpus);
+    vm->vcpus = g_new0(AccelCPUState *, vm->numvcpus);
     for (i = 0; i < vm->numvcpus; i++) {
         vm->vcpus[i] = NULL;
     }
@@ -415,7 +415,7 @@ static int hax_handle_io(CPUArchState *env, uint32_t df, uint16_t port,
 static int hax_vcpu_interrupt(CPUArchState *env)
 {
     CPUState *cpu = env_cpu(env);
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    AccelCPUState *vcpu = cpu->accel;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     /*
@@ -447,7 +447,7 @@ static int hax_vcpu_interrupt(CPUArchState *env)
 
 void hax_raise_event(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    AccelCPUState *vcpu = cpu->accel;
 
     if (!vcpu) {
         return;
@@ -468,7 +468,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
     int ret = 0;
     CPUState *cpu = env_cpu(env);
     X86CPU *x86_cpu = X86_CPU(cpu);
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    AccelCPUState *vcpu = cpu->accel;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     if (!hax_enabled()) {
diff --git a/target/i386/hax/hax-posix.c b/target/i386/hax/hax-posix.c
index ac1a51096e..a057a5bd94 100644
--- a/target/i386/hax/hax-posix.c
+++ b/target/i386/hax/hax-posix.c
@@ -205,7 +205,7 @@ hax_fd hax_host_open_vcpu(int vmid, int vcpuid)
     return fd;
 }
 
-int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
+int hax_host_setup_vcpu_channel(AccelCPUState *vcpu)
 {
     int ret;
     struct hax_tunnel_info info;
@@ -227,7 +227,7 @@ int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
     return 0;
 }
 
-int hax_vcpu_run(struct hax_vcpu_state *vcpu)
+int hax_vcpu_run(AccelCPUState *vcpu)
 {
     return ioctl(vcpu->fd, HAX_VCPU_IOCTL_RUN, NULL);
 }
diff --git a/target/i386/hax/hax-windows.c b/target/i386/hax/hax-windows.c
index 59afa213a6..bf4b0ad941 100644
--- a/target/i386/hax/hax-windows.c
+++ b/target/i386/hax/hax-windows.c
@@ -301,7 +301,7 @@ hax_fd hax_host_open_vcpu(int vmid, int vcpuid)
     return hDeviceVCPU;
 }
 
-int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
+int hax_host_setup_vcpu_channel(AccelCPUState *vcpu)
 {
     hax_fd hDeviceVCPU = vcpu->fd;
     int ret;
@@ -327,7 +327,7 @@ int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
     return 0;
 }
 
-int hax_vcpu_run(struct hax_vcpu_state *vcpu)
+int hax_vcpu_run(AccelCPUState *vcpu)
 {
     int ret;
     HANDLE hDeviceVCPU = vcpu->fd;
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index cf4f0af24b..b3c3adc59a 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -995,7 +995,7 @@ nvmm_init_vcpu(CPUState *cpu)
     }
 
     cpu->vcpu_dirty = true;
-    cpu->accel = (struct hax_vcpu_state *)qcpu;
+    cpu->accel = qcpu;
 
     return 0;
 }
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index d1ad6f156a..410b34d8ec 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2258,7 +2258,7 @@ int whpx_init_vcpu(CPUState *cpu)
 
     vcpu->interruptable = true;
     cpu->vcpu_dirty = true;
-    cpu->accel = (struct hax_vcpu_state *)vcpu;
+    cpu->accel = vcpu;
     max_vcpu_index = max(max_vcpu_index, cpu->cpu_index);
     qemu_add_vm_change_state_handler(whpx_cpu_update_state, cpu->env_ptr);
 
-- 
2.38.1

