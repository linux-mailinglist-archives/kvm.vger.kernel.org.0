Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5474D78BC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 16:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732773AbfJOOga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 10:36:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42220 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732769AbfJOOg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 10:36:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so9681435pls.9
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 07:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nDdnaFQ+XrlOxK8EOBbb2S0iw996RRsfefgNMs2Lk8w=;
        b=ZxlZ1zpkf0EwO7SCo/1WfIYyjjkrGBVwUBPqjxafsPo11P1eaEqKWl50ahhznkX33A
         /u+xg6HgEkvjzv2kJtKA8SM+9HYVTtoA3QMXzajEJAvYV0OK51S6TGc7X/kEAR9rrS7F
         IaK3lSZ+Z4c/mQtyNcj96hos3YfUgh00lAo/EyFpryKWFUzYh2+4knDxryZaPXZzee0S
         Ax02jA+UN+GwJGI9p5vjL1yChYz44h8gd0o0wJN51ECJbNXEQFt9cZImy9ShjT0jwqwZ
         dPbPL47D63cDusuljj+7bXRlielYcPI7tRdny4L73Kul84cU3gQwFiyIW76My+fpvBbT
         xBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nDdnaFQ+XrlOxK8EOBbb2S0iw996RRsfefgNMs2Lk8w=;
        b=jLVIGHm+1anMKwQTZrt06+6mTldPlQKk7+v1aeMivQRb0eM3NF6tpkYKbCQJzuYeMt
         GpASSXWEn+NKx13Z3zW3t5sDIFZLW+LTUIFLZzvF+c1E42BB6sZTBXg6d4q8ukHxlQtp
         ZSn095labo+PA7yf0lK9v2XT8TFviI0AdckZ2rCSMqPHHeC1HykxPQupBVdaSdwGoOf/
         CiSyjWr46dYObz+SzDRtPLGrt4BJNcg4fxOdOMSbLuu7mYUbK1lwNZIckKCA1439StSz
         QJudyGNDJ6EoMlLacwpdz60r5+gZnUcYjh3NKEnFPs+PAOTUf4ne6Cb/ZHY2iCtRMvzM
         cM3A==
X-Gm-Message-State: APjAAAXOVn3jQRukjqg8iD6sNIv0pZqv0WtBI0BsQZ47SMVXlqfQmf3K
        5KHzHHpp8O33zPJhgX045aY=
X-Google-Smtp-Source: APXvYqzkwFA9UuJi+hpp+bmzkgE58AQvIxqXhomKWsTWWDscCp2u7ffZGA3dfbEgJ9cQjyrQImFFtw==
X-Received: by 2002:a17:902:bd08:: with SMTP id p8mr35891107pls.248.1571150187174;
        Tue, 15 Oct 2019 07:36:27 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.39])
        by smtp.googlemail.com with ESMTPSA id v43sm4913165pjb.1.2019.10.15.07.36.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Oct 2019 07:36:26 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     mst@redhat.com, cohuck@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com,
        vkuznets@redhat.com, rkagan@virtuozzo.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH V2 2/2] target/i386/kvm: Add Hyper-V direct tlb flush support
Date:   Tue, 15 Oct 2019 22:36:10 +0800
Message-Id: <20191015143610.31857-3-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191015143610.31857-1-Tianyu.Lan@microsoft.com>
References: <20191015143610.31857-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V direct tlb flush targets KVM on Hyper-V guest.
Enable direct TLB flush for its guests meaning that TLB
flush hypercalls are handled by Level 0 hypervisor (Hyper-V)
bypassing KVM in Level 1. Due to the different ABI for hypercall
parameters between Hyper-V and KVM, KVM capabilities should be
hidden when enable Hyper-V direct tlb flush otherwise KVM
hypercalls may be intercepted by Hyper-V. Add new parameter
"hv-direct-tlbflush". Check expose_kvm and Hyper-V tlb flush
capability status before enabling the feature.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since V1:
       - Add direct tlb flush's Hyper-V property and use
       hv_cpuid_check_and_set() to check the dependency of tlbflush
       feature.
       - Make new feature work with Hyper-V passthrough mode.
---
 docs/hyperv.txt   | 12 ++++++++++++
 target/i386/cpu.c |  2 ++
 target/i386/cpu.h |  1 +
 target/i386/kvm.c | 23 +++++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/docs/hyperv.txt b/docs/hyperv.txt
index 8fdf25c829..ceab8c21fe 100644
--- a/docs/hyperv.txt
+++ b/docs/hyperv.txt
@@ -184,6 +184,18 @@ enabled.
 
 Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
 
+3.18. hv-direct-tlbflush
+=======================
+The enlightenment targets KVM on Hyper-V guest. Enable direct TLB flush for
+its guests meaning that TLB flush hypercalls are handled by Level 0 hypervisor
+(Hyper-V) bypassing KVM in Level 1. Due to the different ABI for hypercall
+parameters between Hyper-V and KVM, enabling this capability effectively
+disables all hypercall handling by KVM (as some KVM hypercall may be mistakenly
+treated as TLB flush hypercalls by Hyper-V). So kvm capability should not show
+to guest when enable this capability. If not, user will fail to enable this
+capability.
+
+Requires: hv-tlbflush, -kvm
 
 4. Development features
 ========================
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 44f1bbdcac..7bc7fee512 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6156,6 +6156,8 @@ static Property x86_cpu_properties[] = {
                       HYPERV_FEAT_IPI, 0),
     DEFINE_PROP_BIT64("hv-stimer-direct", X86CPU, hyperv_features,
                       HYPERV_FEAT_STIMER_DIRECT, 0),
+    DEFINE_PROP_BIT64("hv-direct-tlbflush", X86CPU, hyperv_features,
+                      HYPERV_FEAT_DIRECT_TLBFLUSH, 0),
     DEFINE_PROP_BOOL("hv-passthrough", X86CPU, hyperv_passthrough, false),
 
     DEFINE_PROP_BOOL("check", X86CPU, check_cpuid, true),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index eaa5395aa5..3cb105f7d6 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -907,6 +907,7 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
 #define HYPERV_FEAT_EVMCS               12
 #define HYPERV_FEAT_IPI                 13
 #define HYPERV_FEAT_STIMER_DIRECT       14
+#define HYPERV_FEAT_DIRECT_TLBFLUSH     15
 
 #ifndef HYPERV_SPINLOCK_NEVER_RETRY
 #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 11b9c854b5..7e0fbc730e 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -900,6 +900,10 @@ static struct {
         },
         .dependencies = BIT(HYPERV_FEAT_STIMER)
     },
+    [HYPERV_FEAT_DIRECT_TLBFLUSH] = {
+        .desc = "direct tlbflush (hv-direct-tlbflush)",
+        .dependencies = BIT(HYPERV_FEAT_TLBFLUSH)
+    },
 };
 
 static struct kvm_cpuid2 *try_get_hv_cpuid(CPUState *cs, int max)
@@ -1224,6 +1228,7 @@ static int hyperv_handle_properties(CPUState *cs,
     r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_EVMCS);
     r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_IPI);
     r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_STIMER_DIRECT);
+    r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_DIRECT_TLBFLUSH);
 
     /* Additional dependencies not covered by kvm_hyperv_properties[] */
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
@@ -1243,6 +1248,24 @@ static int hyperv_handle_properties(CPUState *cs,
         goto free;
     }
 
+    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) ||
+        cpu->hyperv_passthrough) {
+        if (!cpu->expose_kvm) {
+            r = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0);
+            if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) && r) {
+                fprintf(stderr,
+                    "Hyper-V %s is not supported by kernel\n",
+                    kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
+                return -ENOSYS;
+            }
+        } else if (!cpu->hyperv_passthrough) {
+            fprintf(stderr,
+                "Hyper-V %s requires not to expose KVM capabilities.\n",
+                kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
+            return -ENOSYS;
+        }
+    }
+
     if (cpu->hyperv_passthrough) {
         /* We already copied all feature words from KVM as is */
         r = cpuid->nent;
-- 
2.14.5

