Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A07A1CFA3B
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgELQMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 12:12:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726668AbgELQM3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 12:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589299947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QPV0MXj9y6STnb3C69SR8Ih5SV5lXcUAQhXA24YX28s=;
        b=hlLi6/UHLLTI/7foG/J/wW4kyb3V/oQoYAllUWIBduB3w9OrJC9XCh0WNM16tPImFhG+Rl
        o2/lA+71rv5UHbl1Od99/FsUlK0BIR1XDEsKLpTjWPtV/SEYdGpY8SEs27fcgKRwRUs6k/
        SkHuy0lcmYGuT82QkRK4fcGae3+Ficg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-_ON6ShHsO_yAbxWm0m8HPg-1; Tue, 12 May 2020 12:12:24 -0400
X-MC-Unique: _ON6ShHsO_yAbxWm0m8HPg-1
Received: by mail-wr1-f69.google.com with SMTP id r11so7146778wrx.21
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 09:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QPV0MXj9y6STnb3C69SR8Ih5SV5lXcUAQhXA24YX28s=;
        b=ocntlM/mCivFNlM6qHOvgHqybj0Zg0pObz0gIB8SNecxQdwBpm9hjh4Io9dePUAJK4
         C/pHrAKqO9qX+Ce+e2OYkmNBMmfr5jMMcBaaoBQwBcdBteKjnK/3JUFQN7itBfQJrBeU
         iuwuSaca3zn4kCgr2dxHm42/3hPDjPk1cykJtk+jANymV8/X/6lKNc8vf63uNisR0Cl9
         3aHgGp1OCmwWpZiacWEl1rJECscA2Y0Z2kI6M0Oi79SvguT07FrnRCpccgjdnk6iPsIA
         qeWFAAQ+S7Qo1zRD2QEDPuqp+hNnaiOqO+ILGJEmTWeR8Iw3Iii7AFt0pXlHVUCJHbB1
         83EA==
X-Gm-Message-State: AGi0Pub99l29B9+4AuE4MHs+FNWaUm5HNsQhq5vthY83HcKrGIXCa0c8
        BqdLnx8IXYFXLpB3FOscIbxexDXJvrqTNag22peCZcshndG13fhj8l91sqQKM7hFBRTHvqutaxY
        DBhYGwR2Q9qS7
X-Received: by 2002:a1c:740e:: with SMTP id p14mr14850506wmc.102.1589299943396;
        Tue, 12 May 2020 09:12:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypLnDbUBERsV+7uWGR8++oBXOZtaaphKKIjWHSYLxMhl0U1gxW9peQUKDE6Y+RzGQUcoqunwcw==
X-Received: by 2002:a1c:740e:: with SMTP id p14mr14850475wmc.102.1589299943190;
        Tue, 12 May 2020 09:12:23 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t7sm20728424wrq.39.2020.05.12.09.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 09:12:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] KVM: x86: Interrupt-based mechanism for async_pf 'page present' notifications
In-Reply-To: <20200512153209.GC138129@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com> <20200512153209.GC138129@redhat.com>
Date:   Tue, 12 May 2020 18:12:20 +0200
Message-ID: <87ftc5m8t7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Vivek Goyal <vgoyal@redhat.com> writes:

> Hi Vitaly,
>
> Are there any corresponding qemu patches as well to enable new
> functionality. Wanted to test it.
>

Yes, right you are, I forgot to even mention this in the blurb.
Please find patches against current 'master' attached. With '-cpu host'
the feature gets enabled automatically.

Note, guest kernel needs to be updated too.

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-linux-headers-KVM_FEATURE_ASYNC_PF_INT-update.patch

From 24d78c031f5348764f880698b01b574ca8748ea4 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Tue, 12 May 2020 18:03:53 +0200
Subject: [PATCH 1/2] linux headers: KVM_FEATURE_ASYNC_PF_INT update

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 include/standard-headers/asm-x86/kvm_para.h | 11 ++++++++++-
 linux-headers/linux/kvm.h                   |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
index 90604a8fb77b..77183ded2cca 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_ASYNC_PF_INT	14
 
 #define KVM_HINTS_REALTIME      0
 
@@ -50,6 +51,8 @@
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_ASYNC_PF_INT	0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 
 struct kvm_steal_time {
 	uint64_t steal;
@@ -81,6 +84,11 @@ struct kvm_clock_pairing {
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
 #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
+
+/* MSR_KVM_ASYNC_PF_INT */
+#define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
+
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
@@ -113,7 +121,8 @@ struct kvm_mmu_op_release_pt {
 
 struct kvm_vcpu_pv_apf_data {
 	uint32_t reason;
-	uint8_t pad[60];
+	uint32_t pageready_token;
+	uint8_t pad[56];
 	uint32_t enabled;
 };
 
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 9804495a46c5..3d0216d1c73f 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_ASYNC_PF_INT 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.4


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=0002-WIP-ASYNC_PF_INT.patch

From f1db3c1cb5d40140028ddae812bfa924ca247556 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Fri, 24 Apr 2020 15:09:45 +0200
Subject: [PATCH 2/2] WIP: ASYNC_PF_INT

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 target/i386/cpu.c     |  2 +-
 target/i386/cpu.h     |  1 +
 target/i386/kvm.c     | 10 ++++++++++
 target/i386/machine.c | 19 +++++++++++++++++++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9c256ab15910..ea794f3f52b5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -810,7 +810,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
             NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
-            "kvm-poll-control", "kvm-pv-sched-yield", NULL, NULL,
+            "kvm-poll-control", "kvm-pv-sched-yield", "kvm-asyncpf-int", NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             "kvmclock-stable-bit", NULL, NULL, NULL,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e818fc712aca..673e31e191cc 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1474,6 +1474,7 @@ typedef struct CPUX86State {
     uint64_t wall_clock_msr;
     uint64_t steal_time_msr;
     uint64_t async_pf_en_msr;
+    uint64_t async_pf_int_msr;
     uint64_t pv_eoi_en_msr;
     uint64_t poll_control_msr;
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 4901c6dd747d..d2b286f9dcb9 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -283,6 +283,7 @@ static const struct kvm_para_features {
     { KVM_CAP_NOP_IO_DELAY, KVM_FEATURE_NOP_IO_DELAY },
     { KVM_CAP_PV_MMU, KVM_FEATURE_MMU_OP },
     { KVM_CAP_ASYNC_PF, KVM_FEATURE_ASYNC_PF },
+    { KVM_CAP_ASYNC_PF_INT, KVM_FEATURE_ASYNC_PF_INT },
 };
 
 static int get_para_features(KVMState *s)
@@ -2798,6 +2799,9 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
         }
+        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
+            kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_int_msr);
+        }
         if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
             kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, env->pv_eoi_en_msr);
         }
@@ -3183,6 +3187,9 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, 0);
     }
+    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
+        kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
+    }
     if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
         kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, 0);
     }
@@ -3423,6 +3430,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_KVM_ASYNC_PF_EN:
             env->async_pf_en_msr = msrs[i].data;
             break;
+        case MSR_KVM_ASYNC_PF_INT:
+            env->async_pf_int_msr = msrs[i].data;
+            break;
         case MSR_KVM_PV_EOI_EN:
             env->pv_eoi_en_msr = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 0c96531a56f0..dc124cf57de7 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -394,6 +394,13 @@ static bool async_pf_msr_needed(void *opaque)
     return cpu->env.async_pf_en_msr != 0;
 }
 
+static bool async_pf_int_msr_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+
+    return cpu->env.async_pf_int_msr != 0;
+}
+
 static bool pv_eoi_msr_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -467,6 +474,17 @@ static const VMStateDescription vmstate_async_pf_msr = {
     }
 };
 
+static const VMStateDescription vmstate_async_pf_int_msr = {
+    .name = "cpu/async_pf_int_msr",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = async_pf_int_msr_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.async_pf_int_msr, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static const VMStateDescription vmstate_pv_eoi_msr = {
     .name = "cpu/async_pv_eoi_msr",
     .version_id = 1,
@@ -1409,6 +1427,7 @@ VMStateDescription vmstate_x86_cpu = {
     .subsections = (const VMStateDescription*[]) {
         &vmstate_exception_info,
         &vmstate_async_pf_msr,
+        &vmstate_async_pf_int_msr,
         &vmstate_pv_eoi_msr,
         &vmstate_steal_time_msr,
         &vmstate_poll_control_msr,
-- 
2.25.4


--=-=-=--

