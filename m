Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94FA32C701
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346125AbhCDAap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377767AbhCCS2h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QekL+lZ5BnBNsP996/ujwa8S4r0MydEApZGppEXSzVI=;
        b=Id7Uy3x/b2YuO3TWs7vrx8TQpltGOpCK3efVf+kqVulOk7pjervJS5pw6m5Ud/8tUC4qTR
        LSmitgWsEAWdOPkaP8ylAke5rCIXWEovXzWhRRrs9wE8gOQ85ZOs+UWFaxVv6KJMUUuWDU
        C940LrRRXBAGksUIfxympn7pU+f0bKA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-CyccvvpQOKWSHCfdZQJe6g-1; Wed, 03 Mar 2021 13:23:34 -0500
X-MC-Unique: CyccvvpQOKWSHCfdZQJe6g-1
Received: by mail-wm1-f70.google.com with SMTP id c9so2174866wme.5
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QekL+lZ5BnBNsP996/ujwa8S4r0MydEApZGppEXSzVI=;
        b=nVUa7BCeD1hzwXAZxAcDIxNJR3GoG9cO8lQQJhKRMRff5yKEpMOUrInIhnGtm7zUwB
         C2wUtO6/nL0Ed2wMyZodjo1ip+pJAuWWsadpo5PuMGvVFQOTelCo0rZgsg5sRvsfGOh9
         mv3TIfovZXk45wUc71l7U++A5751LXIWBHR2eJpkhuK+dkmAzU1Of/X5mVzqvLr3tSbV
         e7OEUkAudHBl0EhKM+ho7oaXF6J0VzlxN7dDvhBf2vPAVq5gCtN6rmfqH00TB89wJZ9e
         Ti/iF4py8fzrw43uPu4899/1Ei4dlRtITTM31FoM9vkD0fQ64vlHLVMscAfWyVyBHp3P
         uP5w==
X-Gm-Message-State: AOAM533Rje9JXgB3XWJj7F05iIaDR2l4yR32AnmOJ87dAAEW7hz49GZl
        S7iK7I8eC1ZId91BJG1E6hmuZTZEr9VTMN9Rsnr91d30xiMDhpqmmQPAg3m+Wvf4fGp1XwoDhoW
        jkb0M6PVud2Ce
X-Received: by 2002:a05:6000:18a:: with SMTP id p10mr24167wrx.166.1614795813577;
        Wed, 03 Mar 2021 10:23:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygnk/F+pfVCMu6jAojHIo6THJyDiFCiZ/rv0+FX+yhcbewuYsSOKLGoO8+tY/jOc1YMyvUIQ==
X-Received: by 2002:a05:6000:18a:: with SMTP id p10mr24137wrx.166.1614795813286;
        Wed, 03 Mar 2021 10:23:33 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id 1sm6435516wmj.2.2021.03.03.10.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:32 -0800 (PST)
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
Subject: [RFC PATCH 10/19] accel/hax: Use 'accel_vcpu' generic pointer
Date:   Wed,  3 Mar 2021 19:22:10 +0100
Message-Id: <20210303182219.1631042-11-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the 'accel_vcpu' field which is meant for accelerators.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/core/cpu.h      |  3 ---
 target/i386/hax/hax-i386.h |  4 ++--
 target/i386/hax/hax-all.c  | 14 +++++++-------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index d807645af2b..65ff8d86dbc 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -244,8 +244,6 @@ typedef struct SavedIOTLB {
 struct KVMState;
 struct kvm_run;
 
-struct hax_vcpu_state;
-
 #define TB_JMP_CACHE_BITS 12
 #define TB_JMP_CACHE_SIZE (1 << TB_JMP_CACHE_BITS)
 
@@ -421,7 +419,6 @@ struct CPUState {
     int kvm_fd;
     struct KVMState *kvm_state;
     struct kvm_run *kvm_run;
-    struct hax_vcpu_state *hax_vcpu;
     int hvf_fd;
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
diff --git a/target/i386/hax/hax-i386.h b/target/i386/hax/hax-i386.h
index ee77406a6a6..61ff0d84f2b 100644
--- a/target/i386/hax/hax-i386.h
+++ b/target/i386/hax/hax-i386.h
@@ -26,8 +26,8 @@ typedef HANDLE hax_fd;
 
 extern struct hax_state hax_global;
 
-typedef struct hax_vcpu_state hax_vcpu_state;
-struct hax_vcpu_state {
+typedef struct AccelvCPUState hax_vcpu_state;
+struct AccelvCPUState {
     hax_fd fd;
     int vcpu_id;
     struct hax_tunnel *tunnel;
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index 08c2b60b437..ce671760e64 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -68,7 +68,7 @@ int valid_hax_tunnel_size(uint16_t size)
 
 hax_fd hax_vcpu_get_fd(CPUArchState *env)
 {
-    hax_vcpu_state *vcpu = env_cpu(env)->hax_vcpu;
+    hax_vcpu_state *vcpu = env_cpu(env)->accel_vcpu;
     if (!vcpu) {
         return HAX_INVALID_FD;
     }
@@ -194,7 +194,7 @@ int hax_vcpu_create(int id)
 
 int hax_vcpu_destroy(CPUState *cpu)
 {
-    hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->accel_vcpu;
 
     if (!hax_global.vm) {
         fprintf(stderr, "vcpu %x destroy failed, vm is null\n", vcpu->vcpu_id);
@@ -414,7 +414,7 @@ static int hax_handle_io(CPUArchState *env, uint32_t df, uint16_t port,
 static int hax_vcpu_interrupt(CPUArchState *env)
 {
     CPUState *cpu = env_cpu(env);
-    hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->accel_vcpu;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     /*
@@ -446,7 +446,7 @@ static int hax_vcpu_interrupt(CPUArchState *env)
 
 void hax_raise_event(CPUState *cpu)
 {
-    hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->accel_vcpu;
 
     if (!vcpu) {
         return;
@@ -467,7 +467,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
     int ret = 0;
     CPUState *cpu = env_cpu(env);
     X86CPU *x86_cpu = X86_CPU(cpu);
-    hax_vcpu_state *vcpu = cpu->hax_vcpu;
+    hax_vcpu_state *vcpu = cpu->accel_vcpu;
     struct hax_tunnel *ht = vcpu->tunnel;
 
     if (!hax_enabled()) {
@@ -1113,8 +1113,8 @@ void hax_reset_vcpu_state(void *opaque)
 {
     CPUState *cpu;
     for (cpu = first_cpu; cpu != NULL; cpu = CPU_NEXT(cpu)) {
-        cpu->hax_vcpu->tunnel->user_event_pending = 0;
-        cpu->hax_vcpu->tunnel->ready_for_interrupt_injection = 0;
+        cpu->accel_vcpu->tunnel->user_event_pending = 0;
+        cpu->accel_vcpu->tunnel->ready_for_interrupt_injection = 0;
     }
 }
 
-- 
2.26.2

