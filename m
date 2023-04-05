Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D026D7987
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbjDEKTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbjDEKTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:19:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C6C5B9A
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:18:58 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j24so35698518wrd.0
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tftOh0BEcl8WGCnB6MC//b/5zdxDYjL5goslSUZJws=;
        b=yPbFhCwGeiCV4thDFylzfI/HwDyG5hzAj4MOzixAzKF25y0uzdJIpFxXuplWi9vjHl
         /pOllACxcM9z8xuQDdRw6M+2mhe134Dj+vuHZkVEnkH+iEToGCJ/gsI/e1vCCyvskKgL
         u3Mvtb6MFtubWA04wRDH74PCwnCAY/i2SngbnxTxDSfmMlutOwruOtZ/lxg1P8mD8QYc
         drS8XHL8crBE+lDtcMRmYU91Oi0ecrSiQz2TIPt5ieGnpP+PuypBCXiw3EMqe02ST1rI
         wsMGZCOdiVWLzTUX7Ca+wgJTbV5lZ6+mNbhvpM8NJsdWCvazgFD200r/8aPIN7ho8VP6
         onNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6tftOh0BEcl8WGCnB6MC//b/5zdxDYjL5goslSUZJws=;
        b=oO3xhDwBYkSY0dyhIZg3LUwboJPUbbwr6uAc8zaklBQYIyRnF54AvP1jAOpb35cPKj
         DrqVWxR2TTFH70gxo4i/69vr9retbPhJVU3qGxj36b6eSJlVAa8ipofoKLlAo3QgCxWU
         3qfBztWriBwzptx6mfm+d2TpeHk8cnL/UFC0oG9KmrkRy/d981/ijyOvYgYwM+NYoS64
         IGK1OYpmILRaQfUZKt/939Zf9CUzNz9hrXOv0Z1jYGjOOsD5QPTTfbEwhAzeKRDFK4LF
         Uochb8UhpFE7h2HezTzkaTpsBMoXVlQJmUv+PiRxiKV0B7BE/EJrTs8WZ2Wvf8YXAJ/B
         gVSw==
X-Gm-Message-State: AAQBX9fFrbaIHc5SF1nBqB4LQyUihc9fC9H/3LqQsdVFSbxxt5QRHicR
        9GzKYtg17yfwR4Q2xHoDfMSAxYELp5lFhYQOZyY=
X-Google-Smtp-Source: AKy350bSSR7dvtgFBRLgKNCzhtqOOQSU+0g5L1LOMUC3nb32jDJaawY9UmLjKaQ4gtEPNgL7gGWKbg==
X-Received: by 2002:a5d:610a:0:b0:2d5:553a:93ac with SMTP id v10-20020a5d610a000000b002d5553a93acmr3978963wrt.7.1680689936532;
        Wed, 05 Apr 2023 03:18:56 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id l18-20020adfe592000000b002c5534db60bsm14659802wrm.71.2023.04.05.03.18.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:18:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 06/14] accel: Use a typedef for struct hax_vcpu_state
Date:   Wed,  5 Apr 2023 12:18:03 +0200
Message-Id: <20230405101811.76663-7-philmd@linaro.org>
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

Use a type definition instead of explicit structure.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/hax/hax-i386.h    | 10 +++++-----
 target/i386/hax/hax-all.c     | 16 ++++++++--------
 target/i386/hax/hax-posix.c   |  4 ++--
 target/i386/hax/hax-windows.c |  4 ++--
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/target/i386/hax/hax-i386.h b/target/i386/hax/hax-i386.h
index 409ebdb4af..3cb3b9bbd0 100644
--- a/target/i386/hax/hax-i386.h
+++ b/target/i386/hax/hax-i386.h
@@ -25,12 +25,12 @@ typedef HANDLE hax_fd;
 #endif
 
 extern struct hax_state hax_global;
-struct hax_vcpu_state {
+typedef struct hax_vcpu_state {
     hax_fd fd;
     int vcpu_id;
     struct hax_tunnel *tunnel;
     unsigned char *iobuf;
-};
+} hax_vcpu_state;
 
 struct hax_state {
     hax_fd fd; /* the global hax device interface */
@@ -46,7 +46,7 @@ struct hax_vm {
     hax_fd fd;
     int id;
     int numvcpus;
-    struct hax_vcpu_state **vcpus;
+    hax_vcpu_state **vcpus;
 };
 
 /* Functions exported to host specific mode */
@@ -57,7 +57,7 @@ int valid_hax_tunnel_size(uint16_t size);
 int hax_mod_version(struct hax_state *hax, struct hax_module_version *version);
 int hax_inject_interrupt(CPUArchState *env, int vector);
 struct hax_vm *hax_vm_create(struct hax_state *hax, int max_cpus);
-int hax_vcpu_run(struct hax_vcpu_state *vcpu);
+int hax_vcpu_run(hax_vcpu_state *vcpu);
 int hax_vcpu_create(int id);
 void hax_kick_vcpu_thread(CPUState *cpu);
 
@@ -76,7 +76,7 @@ int hax_host_create_vm(struct hax_state *hax, int *vm_id);
 hax_fd hax_host_open_vm(struct hax_state *hax, int vm_id);
 int hax_host_create_vcpu(hax_fd vm_fd, int vcpuid);
 hax_fd hax_host_open_vcpu(int vmid, int vcpuid);
-int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu);
+int hax_host_setup_vcpu_channel(hax_vcpu_state *vcpu);
 hax_fd hax_mod_open(void);
 void hax_memory_init(void);
 
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index 3865ff9419..a55b18f353 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -62,7 +62,7 @@ int valid_hax_tunnel_size(uint16_t size)
 
 hax_fd hax_vcpu_get_fd(CPUArchState *env)
 {
-    struct hax_vcpu_state *vcpu = env_cpu(env)->accel;
+    hax_vcpu_state *vcpu = env_cpu(env)->accel;
     if (!vcpu) {
         return HAX_INVALID_FD;
     }
@@ -136,7 +136,7 @@ static int hax_version_support(struct hax_state *hax)
 
 int hax_vcpu_create(int id)
 {
-    struct hax_vcpu_state *vcpu = NULL;
+    hax_vcpu_state *vcpu = NULL;
     int ret;
 
     if (!hax_global.vm) {
@@ -149,7 +149,7 @@ int hax_vcpu_create(int id)
         return 0;
     }
 
-    vcpu = g_new0(struct hax_vcpu_state, 1);
+    vcpu = g_new0(hax_vcpu_state, 1);
 
     ret = hax_host_create_vcpu(hax_global.vm->fd, id);
     if (ret) {
@@ -188,7 +188,7 @@ int hax_vcpu_create(int id)
 
 int hax_vcpu_destroy(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    hax_vcpu_state *vcpu = cpu->accel;
 
     if (!hax_global.vm) {
         fprintf(stderr, "vcpu %x destroy failed, vm is null\n", vcpu->vcpu_id);
@@ -263,7 +263,7 @@ struct hax_vm *hax_vm_create(struct hax_state *hax, int max_cpus)
     }
 
     vm->numvcpus = max_cpus;
-    vm->vcpus = g_new0(struct hax_vcpu_state *, vm->numvcpus);
+    vm->vcpus = g_new0(hax_vcpu_state *, vm->numvcpus);
     for (i = 0; i < vm->numvcpus; i++) {
         vm->vcpus[i] = NULL;
     }
@@ -415,7 +415,7 @@ static int hax_handle_io(CPUArchState *env, uint32_t df, uint16_t port,
 static int hax_vcpu_interrupt(CPUArchState *env)
 {
     CPUState *cpu = env_cpu(env);
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    hax_vcpu_state *vcpu = cpu->accel;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     /*
@@ -447,7 +447,7 @@ static int hax_vcpu_interrupt(CPUArchState *env)
 
 void hax_raise_event(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    hax_vcpu_state *vcpu = cpu->accel;
 
     if (!vcpu) {
         return;
@@ -468,7 +468,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
     int ret = 0;
     CPUState *cpu = env_cpu(env);
     X86CPU *x86_cpu = X86_CPU(cpu);
-    struct hax_vcpu_state *vcpu = cpu->accel;
+    hax_vcpu_state *vcpu = cpu->accel;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     if (!hax_enabled()) {
diff --git a/target/i386/hax/hax-posix.c b/target/i386/hax/hax-posix.c
index ac1a51096e..8ee247845b 100644
--- a/target/i386/hax/hax-posix.c
+++ b/target/i386/hax/hax-posix.c
@@ -205,7 +205,7 @@ hax_fd hax_host_open_vcpu(int vmid, int vcpuid)
     return fd;
 }
 
-int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
+int hax_host_setup_vcpu_channel(hax_vcpu_state *vcpu)
 {
     int ret;
     struct hax_tunnel_info info;
@@ -227,7 +227,7 @@ int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
     return 0;
 }
 
-int hax_vcpu_run(struct hax_vcpu_state *vcpu)
+int hax_vcpu_run(hax_vcpu_state *vcpu)
 {
     return ioctl(vcpu->fd, HAX_VCPU_IOCTL_RUN, NULL);
 }
diff --git a/target/i386/hax/hax-windows.c b/target/i386/hax/hax-windows.c
index 59afa213a6..08ec93a256 100644
--- a/target/i386/hax/hax-windows.c
+++ b/target/i386/hax/hax-windows.c
@@ -301,7 +301,7 @@ hax_fd hax_host_open_vcpu(int vmid, int vcpuid)
     return hDeviceVCPU;
 }
 
-int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
+int hax_host_setup_vcpu_channel(hax_vcpu_state *vcpu)
 {
     hax_fd hDeviceVCPU = vcpu->fd;
     int ret;
@@ -327,7 +327,7 @@ int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu)
     return 0;
 }
 
-int hax_vcpu_run(struct hax_vcpu_state *vcpu)
+int hax_vcpu_run(hax_vcpu_state *vcpu)
 {
     int ret;
     HANDLE hDeviceVCPU = vcpu->fd;
-- 
2.38.1

