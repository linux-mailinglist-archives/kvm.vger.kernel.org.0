Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E78F8719
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 04:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLDez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 22:34:55 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36192 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLDez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 22:34:55 -0500
Received: by mail-pf1-f193.google.com with SMTP id b19so32067pfd.3
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 19:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RjB3o0NjWZXINNESvPz4COiSojg7wROs/y6CgxKZ/Pw=;
        b=Ar5AXk2psvjukJXi6gdH+xtvXmPp9uIXKwTYX28+pv4edMenYVt2Q9cSx6Sir1B8To
         U/Mp7UNwz4u9P6dJcQtjMhdBxKtaekycaC+pbD1ure7q3xluNVB4AY694Wdw5hhbXVnj
         LCOw7QFIpSTm4GC9WPrTKXscJfsQ5h8EPGAgNsqrxdBSfO9qYez338FgkBWHcDsFytET
         4/fJcb2Qp8DPFg75MLd5Ed36cVo8VjZ3GhwtHY9VWQHzYNHgzp95trzk4oApjEOf1+Sv
         GdWYuiYl0LWZalpZUzwibW2heGA4Ks6Bn4tUENTyBrSlyKKZ4H+7oZX0er/id3Ug2alL
         KMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RjB3o0NjWZXINNESvPz4COiSojg7wROs/y6CgxKZ/Pw=;
        b=h4EHiGUUYiOyOK+E+krC5IS4F/Tb3fWcRiBvlz09zFAWeCGjov5PggVDoBYla0FtRv
         cWzGgRReXQDNt69Ahhr1HBIn7CsXGQkJeiu1Y6wXN3biFfYQqBEGgo/BjPsDyvhCAGXn
         quYLbseMm3x0ebxr35GHZCL2+VEUArvBg9IUJt+lLcDkx0+gNWAgrF9pqPUMcu/MfbaC
         8RX6ymjOcwvoNtv17JeLxzZa7pHYnCcbmqtT3MJP8yx1bPeCMGGB0Ku03I8/0Q1BGlx9
         EY2EkJ4/GEDCZGfw7c4csHib9KRIjiXBROqqLXydoLy4bBBcMGedDkK39ZBquZXRaEma
         tEqg==
X-Gm-Message-State: APjAAAXaJtXL7EyYE5ju/mdPqUd1khwcGW2M6jLR0w6k88N0H6KobVoF
        lsUgN4b9FSWaLRl81b/bdqk=
X-Google-Smtp-Source: APXvYqxm3G75qyaUjRQQIkPwyZGO7sh/u2z8W5LqAbtVsVJkIsjXh8sN7kIATp92EqxAESEhDElMYQ==
X-Received: by 2002:a65:46c1:: with SMTP id n1mr11037437pgr.257.1573529693925;
        Mon, 11 Nov 2019 19:34:53 -0800 (PST)
Received: from localhost.corp.microsoft.com ([167.220.255.5])
        by smtp.googlemail.com with ESMTPSA id f5sm114018pjp.1.2019.11.11.19.34.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Nov 2019 19:34:53 -0800 (PST)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com, rkagan@virtuozzo.com, vkuznets@redhat.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH V4] target/i386/kvm: Add Hyper-V direct tlb flush support
Date:   Tue, 12 Nov 2019 11:34:27 +0800
Message-Id: <20191112033427.7204-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
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
Change since v3:
       - Fix logic of Hyper-V passthrough mode with direct
       tlb flush.

Change sicne v2:
       - Update new feature description and name.
       - Change failure print log.

Change since v1:
       - Add direct tlb flush's Hyper-V property and use
       hv_cpuid_check_and_set() to check the dependency of tlbflush
       feature.
       - Make new feature work with Hyper-V passthrough mode.
---
 docs/hyperv.txt   | 10 ++++++++++
 target/i386/cpu.c |  2 ++
 target/i386/cpu.h |  1 +
 target/i386/kvm.c | 24 ++++++++++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/docs/hyperv.txt b/docs/hyperv.txt
index 8fdf25c829..140a5c7e44 100644
--- a/docs/hyperv.txt
+++ b/docs/hyperv.txt
@@ -184,6 +184,16 @@ enabled.
 
 Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
 
+3.18. hv-direct-tlbflush
+=======================
+Enable direct TLB flush for KVM when it is running as a nested
+hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L2
+guests are being passed through to L0 (Hyper-V) for handling. Due to ABI
+differences between Hyper-V and KVM hypercalls, L2 guests will not be
+able to issue KVM hypercalls (as those could be mishanled by L0
+Hyper-V), this requires KVM hypervisor signature to be hidden.
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
index 11b9c854b5..43f5cbc3f6 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -900,6 +900,10 @@ static struct {
         },
         .dependencies = BIT(HYPERV_FEAT_STIMER)
     },
+    [HYPERV_FEAT_DIRECT_TLBFLUSH] = {
+        .desc = "direct paravirtualized TLB flush (hv-direct-tlbflush)",
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
@@ -1243,6 +1248,25 @@ static int hyperv_handle_properties(CPUState *cs,
         goto free;
     }
 
+    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH)) {
+        if (kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0)) {
+            if (!cpu->hyperv_passthrough) {
+                fprintf(stderr,
+                    "Hyper-V %s is not supported by kernel\n",
+                    kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
+                return -ENOSYS;
+            }
+
+            cpu->hyperv_features &= ~BIT(HYPERV_FEAT_DIRECT_TLBFLUSH);
+        } else if (cpu->expose_kvm) {
+            fprintf(stderr,
+                "Hyper-V %s requires KVM hypervisor signature "
+                "to be hidden (-kvm).\n",
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

