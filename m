Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9F432C6FE
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240767AbhCDAao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377410AbhCCS2h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsBSf6h5clRIGLmrmL5o7OQtiQ2QaVSKYYOrh/pYYJA=;
        b=PtStP/5HThJQq2y2Pk/fgc0ugo7dAXOjWCiS0AMo5PQqjYMkAB1CMFSn8+WAOowjhbOpRK
        CaY0IouBC747KxiGhjpkbOtfnZrChCO099cc12P+899lSgQxAC8yAdTG379HoA9ZIWsz17
        vJNbRv/P3F+YAYBoZRHL0wr/gEdXWZo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-Vy8slqxzO6Otqji0NMmGLw-1; Wed, 03 Mar 2021 13:23:24 -0500
X-MC-Unique: Vy8slqxzO6Otqji0NMmGLw-1
Received: by mail-wm1-f71.google.com with SMTP id p8so3389962wmq.7
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsBSf6h5clRIGLmrmL5o7OQtiQ2QaVSKYYOrh/pYYJA=;
        b=C7vzE3P9m6tCrsOclaJGUrzrTb6SX2c5+WHUbDnuoE0OdlHzclT40WsLedQn0QMe1z
         UxuFti95LlPy0XgC81BR2v/SlV3/HF0WfJbghig5I7hZ84W3QVGu8n/Pp1PQjnFmFdfa
         qmz9DirAfJbMaWtJXVqv3uVs9ouFjkFAFtKjkRCAfb4ckSmvuXY6n7Sa2x1RH8KnTkoK
         LdiOWZCJe+b4LkX9AVNsVtZiyCFg/J8KZq+/gQZbhw1esMl4DRl4q8JK1LFo5sgIB/l3
         6IbFKoNlapvsDJ/o8jgzhVql12JjNHVCI26xLz7DadgnCHp3bhQlpX6prfWt122N5vvY
         bCmQ==
X-Gm-Message-State: AOAM532ivvz2cLLGA+XSnkkhfFUbAoyc0zCdOFpW9adR/pvDMEB6Fdjh
        JzLeJONX/jRJBi5TFvJuCnS53/jO+vFOOhxqtfj8NfSV4m+ucln6yEK6QxKmHSOyDFl7/jWisuJ
        V0bFTV1d9I8J/
X-Received: by 2002:a05:6000:24b:: with SMTP id m11mr20773886wrz.393.1614795802951;
        Wed, 03 Mar 2021 10:23:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxT5Mnr/cqn4T3oI+iCl7/2qqSUUEQiDL1NAilJKbe4aa2BGoAiTwZhjp0yFdIrhN8U4ftx4Q==
X-Received: by 2002:a05:6000:24b:: with SMTP id m11mr20773870wrz.393.1614795802788;
        Wed, 03 Mar 2021 10:23:22 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id n6sm13487477wrt.1.2021.03.03.10.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:22 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 09/19] accel/hax: Add typedef for 'struct hax_vcpu_state'
Date:   Wed,  3 Mar 2021 19:22:09 +0100
Message-Id: <20210303182219.1631042-10-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the 'hax_vcpu_state' typedef instead of 'struct hax_vcpu_state'.
This will make the next commits easier to review.

Beside the typedef addition, patch created mechanically using:

  $ sed -i s/struct\ hax_vcpu_state/hax_vcpu_state/ \
      $(git grep -l 'struct hax_vcpu_state')

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/hax/hax-i386.h    |  8 +++++---
 target/i386/hax/hax-all.c     | 18 +++++++++---------
 target/i386/hax/hax-posix.c   |  4 ++--
 target/i386/hax/hax-windows.c |  4 ++--
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/target/i386/hax/hax-i386.h b/target/i386/hax/hax-i386.h
index efbb3462389..ee77406a6a6 100644
--- a/target/i386/hax/hax-i386.h
+++ b/target/i386/hax/hax-i386.h
@@ -25,6 +25,8 @@ typedef HANDLE hax_fd;
 #endif
 
 extern struct hax_state hax_global;
+
+typedef struct hax_vcpu_state hax_vcpu_state;
 struct hax_vcpu_state {
     hax_fd fd;
     int vcpu_id;
@@ -46,7 +48,7 @@ struct hax_vm {
     hax_fd fd;
     int id;
     int numvcpus;
-    struct hax_vcpu_state **vcpus;
+    hax_vcpu_state **vcpus;
 };
 
 #ifdef NEED_CPU_H
@@ -58,7 +60,7 @@ int valid_hax_tunnel_size(uint16_t size);
 int hax_mod_version(struct hax_state *hax, struct hax_module_version *version);
 int hax_inject_interrupt(CPUArchState *env, int vector);
 struct hax_vm *hax_vm_create(struct hax_state *hax, int max_cpus);
-int hax_vcpu_run(struct hax_vcpu_state *vcpu);
+int hax_vcpu_run(hax_vcpu_state *vcpu);
 int hax_vcpu_create(int id);
 void hax_kick_vcpu_thread(CPUState *cpu);
 
@@ -78,7 +80,7 @@ int hax_host_create_vm(struct hax_state *hax, int *vm_id);
 hax_fd hax_host_open_vm(struct hax_state *hax, int vm_id);
 int hax_host_create_vcpu(hax_fd vm_fd, int vcpuid);
 hax_fd hax_host_open_vcpu(int vmid, int vcpuid);
-int hax_host_setup_vcpu_channel(struct hax_vcpu_state *vcpu);
+int hax_host_setup_vcpu_channel(hax_vcpu_state *vcpu);
 hax_fd hax_mod_open(void);
 void hax_memory_init(void);
 
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index bf65ed6fa92..08c2b60b437 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -68,7 +68,7 @@ int valid_hax_tunnel_size(uint16_t size)
 
 hax_fd hax_vcpu_get_fd(CPUArchState *env)
 {
-    struct hax_vcpu_state *vcpu = env_cpu(env)->hax_vcpu;
+    hax_vcpu_state *vcpu = env_cpu(env)->hax_vcpu;
     if (!vcpu) {
         return HAX_INVALID_FD;
     }
@@ -142,7 +142,7 @@ static int hax_version_support(struct hax_state *hax)
 
 int hax_vcpu_create(int id)
 {
-    struct hax_vcpu_state *vcpu = NULL;
+    hax_vcpu_state *vcpu = NULL;
     int ret;
 
     if (!hax_global.vm) {
@@ -155,7 +155,7 @@ int hax_vcpu_create(int id)
         return 0;
     }
 
-    vcpu = g_new0(struct hax_vcpu_state, 1);
+    vcpu = g_new0(hax_vcpu_state, 1);
 
     ret = hax_host_create_vcpu(hax_global.vm->fd, id);
     if (ret) {
@@ -194,7 +194,7 @@ int hax_vcpu_create(int id)
 
 int hax_vcpu_destroy(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->hax_vcpu;
 
     if (!hax_global.vm) {
         fprintf(stderr, "vcpu %x destroy failed, vm is null\n", vcpu->vcpu_id);
@@ -225,7 +225,7 @@ int hax_init_vcpu(CPUState *cpu)
         exit(-1);
     }
 
-    cpu->hax_vcpu = hax_global.vm->vcpus[cpu->cpu_index];
+    cpu->accel_vcpu = hax_global.vm->vcpus[cpu->cpu_index];
     cpu->vcpu_dirty = true;
     qemu_register_reset(hax_reset_vcpu_state, (CPUArchState *) (cpu->env_ptr));
 
@@ -265,7 +265,7 @@ struct hax_vm *hax_vm_create(struct hax_state *hax, int max_cpus)
     }
 
     vm->numvcpus = max_cpus;
-    vm->vcpus = g_new0(struct hax_vcpu_state *, vm->numvcpus);
+    vm->vcpus = g_new0(hax_vcpu_state *, vm->numvcpus);
     for (i = 0; i < vm->numvcpus; i++) {
         vm->vcpus[i] = NULL;
     }
@@ -414,7 +414,7 @@ static int hax_handle_io(CPUArchState *env, uint32_t df, uint16_t port,
 static int hax_vcpu_interrupt(CPUArchState *env)
 {
     CPUState *cpu = env_cpu(env);
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->hax_vcpu;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     /*
@@ -446,7 +446,7 @@ static int hax_vcpu_interrupt(CPUArchState *env)
 
 void hax_raise_event(CPUState *cpu)
 {
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->hax_vcpu;
 
     if (!vcpu) {
         return;
@@ -467,7 +467,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
     int ret = 0;
     CPUState *cpu = env_cpu(env);
     X86CPU *x86_cpu = X86_CPU(cpu);
-    struct hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->hax_vcpu;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     if (!hax_enabled()) {
diff --git a/target/i386/hax/hax-posix.c b/target/i386/hax/hax-posix.c
index ac1a51096eb..8ee247845b7 100644
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
index 59afa213a6d..08ec93a256c 100644
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
2.26.2

