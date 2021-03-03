Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE04C32C6E0
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451122AbhCDAaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349976AbhCCS2d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614795971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dPrv/DkAiyl42NA4omCqrPAwJ/Yioej+8U34dhimaag=;
        b=gHNeinA52kWcEFQdSxmeQ0ujVH237ok3zGg+EWuE3f0roCcHpLvRbs5dAbv4qvngv58pn8
        XSFms8Hbb3HdX08aJFGo1MusAmL47poC1HbavwtIC1bvoDN+jSkcKZ5zsOx3O4i2dkN5xb
        Xshkw/ezeCBxsOykHPMdVWCR8n1GAbM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-AyZ3BGUQN1-URpoJ9edY4A-1; Wed, 03 Mar 2021 13:22:41 -0500
X-MC-Unique: AyZ3BGUQN1-URpoJ9edY4A-1
Received: by mail-wm1-f69.google.com with SMTP id p8so3388929wmq.7
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dPrv/DkAiyl42NA4omCqrPAwJ/Yioej+8U34dhimaag=;
        b=JeQ40NIEXbSS//YMTzNuY8rfzreZYhEy6zLaTmxYzHw0JVBqaoVj6ZJDl0gBTGxS7G
         guhRjZx07Wl0SwLhEu/2zkWXhysExRl3FWz2STNJ+ScNefvqZGT4Srl/uMvLTiGPHo20
         5IXTcNvozsxhdeLfiyWBFdFDw54GLyPEsjSLdU0d82j3NwL4EMA3fbrLJuNWRd9pWq5/
         sgY/GXPviu4OTyRpiG59OKgQNaZ0yfw8WbmxCtSyYybnhACNHb1pnF+i5eG3/TNSKVo+
         HdmOPxY5R61Rzv/5D/yrmhmkEdyaJ2Q+hwDUoBMFYWv74YaIUjJlbUKqWARJIW7I+jjR
         K50Q==
X-Gm-Message-State: AOAM530i7QMysVkOlIbhClhMMi/M97CgCibu22oE3Wg/++SebsP6fsmx
        FWBXdDUlTK77fP9aLxOgfQEYHlBWFVlmbYO/6fbX8i4MwmRWZWzGv78CvjlJZPhizY1HUseRhi3
        lnbxhmLH2ecOq
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr240922wmq.143.1614795759826;
        Wed, 03 Mar 2021 10:22:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXxCQPSMt1p4gHnR3Ywd1Kul89hiZNYH0SsYELKDXDY9Tt9PJ1TBkjbrz5JshRHXS5s1Y5rw==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr240887wmq.143.1614795759484;
        Wed, 03 Mar 2021 10:22:39 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id s3sm13959189wrt.93.2021.03.03.10.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:22:39 -0800 (PST)
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
Subject: [PATCH 03/19] target/s390x/kvm: Reduce deref by declaring 'struct kvm_run' on stack
Date:   Wed,  3 Mar 2021 19:22:03 +0100
Message-Id: <20210303182219.1631042-4-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to make one of the next commits easier to review,
declare 'struct kvm_run' on the stack when it is used in
various places in a function.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/s390x/kvm.c | 128 +++++++++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 63 deletions(-)

diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index 73f816a7222..d8ac12dfc11 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -467,6 +467,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 {
     S390CPU *cpu = S390_CPU(cs);
     CPUS390XState *env = &cpu->env;
+    struct kvm_run *run = cs->kvm_run;
     struct kvm_sregs sregs;
     struct kvm_regs regs;
     struct kvm_fpu fpu = {};
@@ -474,13 +475,13 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     int i;
 
     /* always save the PSW  and the GPRS*/
-    cs->kvm_run->psw_addr = env->psw.addr;
-    cs->kvm_run->psw_mask = env->psw.mask;
+    run->psw_addr = env->psw.addr;
+    run->psw_mask = env->psw.mask;
 
     if (can_sync_regs(cs, KVM_SYNC_GPRS)) {
         for (i = 0; i < 16; i++) {
-            cs->kvm_run->s.regs.gprs[i] = env->regs[i];
-            cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_GPRS;
+            run->s.regs.gprs[i] = env->regs[i];
+            run->kvm_dirty_regs |= KVM_SYNC_GPRS;
         }
     } else {
         for (i = 0; i < 16; i++) {
@@ -494,17 +495,17 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 
     if (can_sync_regs(cs, KVM_SYNC_VRS)) {
         for (i = 0; i < 32; i++) {
-            cs->kvm_run->s.regs.vrs[i][0] = env->vregs[i][0];
-            cs->kvm_run->s.regs.vrs[i][1] = env->vregs[i][1];
+            run->s.regs.vrs[i][0] = env->vregs[i][0];
+            run->s.regs.vrs[i][1] = env->vregs[i][1];
         }
-        cs->kvm_run->s.regs.fpc = env->fpc;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_VRS;
+        run->s.regs.fpc = env->fpc;
+        run->kvm_dirty_regs |= KVM_SYNC_VRS;
     } else if (can_sync_regs(cs, KVM_SYNC_FPRS)) {
         for (i = 0; i < 16; i++) {
-            cs->kvm_run->s.regs.fprs[i] = *get_freg(env, i);
+            run->s.regs.fprs[i] = *get_freg(env, i);
         }
-        cs->kvm_run->s.regs.fpc = env->fpc;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_FPRS;
+        run->s.regs.fpc = env->fpc;
+        run->kvm_dirty_regs |= KVM_SYNC_FPRS;
     } else {
         /* Floating point */
         for (i = 0; i < 16; i++) {
@@ -524,12 +525,12 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     }
 
     if (can_sync_regs(cs, KVM_SYNC_ARCH0)) {
-        cs->kvm_run->s.regs.cputm = env->cputm;
-        cs->kvm_run->s.regs.ckc = env->ckc;
-        cs->kvm_run->s.regs.todpr = env->todpr;
-        cs->kvm_run->s.regs.gbea = env->gbea;
-        cs->kvm_run->s.regs.pp = env->pp;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_ARCH0;
+        run->s.regs.cputm = env->cputm;
+        run->s.regs.ckc = env->ckc;
+        run->s.regs.todpr = env->todpr;
+        run->s.regs.gbea = env->gbea;
+        run->s.regs.pp = env->pp;
+        run->kvm_dirty_regs |= KVM_SYNC_ARCH0;
     } else {
         /*
          * These ONE_REGS are not protected by a capability. As they are only
@@ -544,16 +545,16 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     }
 
     if (can_sync_regs(cs, KVM_SYNC_RICCB)) {
-        memcpy(cs->kvm_run->s.regs.riccb, env->riccb, 64);
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_RICCB;
+        memcpy(run->s.regs.riccb, env->riccb, 64);
+        run->kvm_dirty_regs |= KVM_SYNC_RICCB;
     }
 
     /* pfault parameters */
     if (can_sync_regs(cs, KVM_SYNC_PFAULT)) {
-        cs->kvm_run->s.regs.pft = env->pfault_token;
-        cs->kvm_run->s.regs.pfs = env->pfault_select;
-        cs->kvm_run->s.regs.pfc = env->pfault_compare;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_PFAULT;
+        run->s.regs.pft = env->pfault_token;
+        run->s.regs.pfs = env->pfault_select;
+        run->s.regs.pfc = env->pfault_compare;
+        run->kvm_dirty_regs |= KVM_SYNC_PFAULT;
     } else if (cap_async_pf) {
         r = kvm_set_one_reg(cs, KVM_REG_S390_PFTOKEN, &env->pfault_token);
         if (r < 0) {
@@ -572,11 +573,11 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     /* access registers and control registers*/
     if (can_sync_regs(cs, KVM_SYNC_ACRS | KVM_SYNC_CRS)) {
         for (i = 0; i < 16; i++) {
-            cs->kvm_run->s.regs.acrs[i] = env->aregs[i];
-            cs->kvm_run->s.regs.crs[i] = env->cregs[i];
+            run->s.regs.acrs[i] = env->aregs[i];
+            run->s.regs.crs[i] = env->cregs[i];
         }
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_ACRS;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_CRS;
+        run->kvm_dirty_regs |= KVM_SYNC_ACRS;
+        run->kvm_dirty_regs |= KVM_SYNC_CRS;
     } else {
         for (i = 0; i < 16; i++) {
             sregs.acrs[i] = env->aregs[i];
@@ -589,30 +590,30 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     }
 
     if (can_sync_regs(cs, KVM_SYNC_GSCB)) {
-        memcpy(cs->kvm_run->s.regs.gscb, env->gscb, 32);
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_GSCB;
+        memcpy(run->s.regs.gscb, env->gscb, 32);
+        run->kvm_dirty_regs |= KVM_SYNC_GSCB;
     }
 
     if (can_sync_regs(cs, KVM_SYNC_BPBC)) {
-        cs->kvm_run->s.regs.bpbc = env->bpbc;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_BPBC;
+        run->s.regs.bpbc = env->bpbc;
+        run->kvm_dirty_regs |= KVM_SYNC_BPBC;
     }
 
     if (can_sync_regs(cs, KVM_SYNC_ETOKEN)) {
-        cs->kvm_run->s.regs.etoken = env->etoken;
-        cs->kvm_run->s.regs.etoken_extension  = env->etoken_extension;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_ETOKEN;
+        run->s.regs.etoken = env->etoken;
+        run->s.regs.etoken_extension  = env->etoken_extension;
+        run->kvm_dirty_regs |= KVM_SYNC_ETOKEN;
     }
 
     if (can_sync_regs(cs, KVM_SYNC_DIAG318)) {
-        cs->kvm_run->s.regs.diag318 = env->diag318_info;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_DIAG318;
+        run->s.regs.diag318 = env->diag318_info;
+        run->kvm_dirty_regs |= KVM_SYNC_DIAG318;
     }
 
     /* Finally the prefix */
     if (can_sync_regs(cs, KVM_SYNC_PREFIX)) {
-        cs->kvm_run->s.regs.prefix = env->psa;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_PREFIX;
+        run->s.regs.prefix = env->psa;
+        run->kvm_dirty_regs |= KVM_SYNC_PREFIX;
     } else {
         /* prefix is only supported via sync regs */
     }
@@ -623,19 +624,20 @@ int kvm_arch_get_registers(CPUState *cs)
 {
     S390CPU *cpu = S390_CPU(cs);
     CPUS390XState *env = &cpu->env;
+    struct kvm_run *run = cs->kvm_run;
     struct kvm_sregs sregs;
     struct kvm_regs regs;
     struct kvm_fpu fpu;
     int i, r;
 
     /* get the PSW */
-    env->psw.addr = cs->kvm_run->psw_addr;
-    env->psw.mask = cs->kvm_run->psw_mask;
+    env->psw.addr = run->psw_addr;
+    env->psw.mask = run->psw_mask;
 
     /* the GPRS */
     if (can_sync_regs(cs, KVM_SYNC_GPRS)) {
         for (i = 0; i < 16; i++) {
-            env->regs[i] = cs->kvm_run->s.regs.gprs[i];
+            env->regs[i] = run->s.regs.gprs[i];
         }
     } else {
         r = kvm_vcpu_ioctl(cs, KVM_GET_REGS, &regs);
@@ -650,8 +652,8 @@ int kvm_arch_get_registers(CPUState *cs)
     /* The ACRS and CRS */
     if (can_sync_regs(cs, KVM_SYNC_ACRS | KVM_SYNC_CRS)) {
         for (i = 0; i < 16; i++) {
-            env->aregs[i] = cs->kvm_run->s.regs.acrs[i];
-            env->cregs[i] = cs->kvm_run->s.regs.crs[i];
+            env->aregs[i] = run->s.regs.acrs[i];
+            env->cregs[i] = run->s.regs.crs[i];
         }
     } else {
         r = kvm_vcpu_ioctl(cs, KVM_GET_SREGS, &sregs);
@@ -667,15 +669,15 @@ int kvm_arch_get_registers(CPUState *cs)
     /* Floating point and vector registers */
     if (can_sync_regs(cs, KVM_SYNC_VRS)) {
         for (i = 0; i < 32; i++) {
-            env->vregs[i][0] = cs->kvm_run->s.regs.vrs[i][0];
-            env->vregs[i][1] = cs->kvm_run->s.regs.vrs[i][1];
+            env->vregs[i][0] = run->s.regs.vrs[i][0];
+            env->vregs[i][1] = run->s.regs.vrs[i][1];
         }
-        env->fpc = cs->kvm_run->s.regs.fpc;
+        env->fpc = run->s.regs.fpc;
     } else if (can_sync_regs(cs, KVM_SYNC_FPRS)) {
         for (i = 0; i < 16; i++) {
-            *get_freg(env, i) = cs->kvm_run->s.regs.fprs[i];
+            *get_freg(env, i) = run->s.regs.fprs[i];
         }
-        env->fpc = cs->kvm_run->s.regs.fpc;
+        env->fpc = run->s.regs.fpc;
     } else {
         r = kvm_vcpu_ioctl(cs, KVM_GET_FPU, &fpu);
         if (r < 0) {
@@ -689,15 +691,15 @@ int kvm_arch_get_registers(CPUState *cs)
 
     /* The prefix */
     if (can_sync_regs(cs, KVM_SYNC_PREFIX)) {
-        env->psa = cs->kvm_run->s.regs.prefix;
+        env->psa = run->s.regs.prefix;
     }
 
     if (can_sync_regs(cs, KVM_SYNC_ARCH0)) {
-        env->cputm = cs->kvm_run->s.regs.cputm;
-        env->ckc = cs->kvm_run->s.regs.ckc;
-        env->todpr = cs->kvm_run->s.regs.todpr;
-        env->gbea = cs->kvm_run->s.regs.gbea;
-        env->pp = cs->kvm_run->s.regs.pp;
+        env->cputm = run->s.regs.cputm;
+        env->ckc = run->s.regs.ckc;
+        env->todpr = run->s.regs.todpr;
+        env->gbea = run->s.regs.gbea;
+        env->pp = run->s.regs.pp;
     } else {
         /*
          * These ONE_REGS are not protected by a capability. As they are only
@@ -712,27 +714,27 @@ int kvm_arch_get_registers(CPUState *cs)
     }
 
     if (can_sync_regs(cs, KVM_SYNC_RICCB)) {
-        memcpy(env->riccb, cs->kvm_run->s.regs.riccb, 64);
+        memcpy(env->riccb, run->s.regs.riccb, 64);
     }
 
     if (can_sync_regs(cs, KVM_SYNC_GSCB)) {
-        memcpy(env->gscb, cs->kvm_run->s.regs.gscb, 32);
+        memcpy(env->gscb, run->s.regs.gscb, 32);
     }
 
     if (can_sync_regs(cs, KVM_SYNC_BPBC)) {
-        env->bpbc = cs->kvm_run->s.regs.bpbc;
+        env->bpbc = run->s.regs.bpbc;
     }
 
     if (can_sync_regs(cs, KVM_SYNC_ETOKEN)) {
-        env->etoken = cs->kvm_run->s.regs.etoken;
-        env->etoken_extension = cs->kvm_run->s.regs.etoken_extension;
+        env->etoken = run->s.regs.etoken;
+        env->etoken_extension = run->s.regs.etoken_extension;
     }
 
     /* pfault parameters */
     if (can_sync_regs(cs, KVM_SYNC_PFAULT)) {
-        env->pfault_token = cs->kvm_run->s.regs.pft;
-        env->pfault_select = cs->kvm_run->s.regs.pfs;
-        env->pfault_compare = cs->kvm_run->s.regs.pfc;
+        env->pfault_token = run->s.regs.pft;
+        env->pfault_select = run->s.regs.pfs;
+        env->pfault_compare = run->s.regs.pfc;
     } else if (cap_async_pf) {
         r = kvm_get_one_reg(cs, KVM_REG_S390_PFTOKEN, &env->pfault_token);
         if (r < 0) {
@@ -749,7 +751,7 @@ int kvm_arch_get_registers(CPUState *cs)
     }
 
     if (can_sync_regs(cs, KVM_SYNC_DIAG318)) {
-        env->diag318_info = cs->kvm_run->s.regs.diag318;
+        env->diag318_info = run->s.regs.diag318;
     }
 
     return 0;
-- 
2.26.2

