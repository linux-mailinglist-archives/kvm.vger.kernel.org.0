Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0E764FD8
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 03:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfGKBZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 21:25:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45513 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbfGKBZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 21:25:29 -0400
Received: by mail-ed1-f67.google.com with SMTP id e2so3980383edi.12
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 18:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TrD+b9KcyDXAn9XTri87X4ww/nyNvMC/tz+poqou13c=;
        b=b7KeucFxiHjYP2FVwS6/1td8lEwc2IDxW/qZw2UV4o4/6s270GwKj/wpo4/r1JNnwl
         Gk0zcggU/AFy9AhHic9QAvhBDIjiGHgdLpX6RW96EiBiI9cZ/uhZ00sZTkDKVlRqB6GH
         wTl7oZ+oJ9P0OGUibmo3rPp1Y887B8o1GxVWjCCo5y+ZiAepQz/CJhTzGRJsH67Jbse+
         vwAPcLCzyqHmSRQ9CG35nymSV3XSekzouXQFvK1sjhYJKgXPIMn1kt9U81P/pQdmR8qI
         DAEMtTFcwKKhtDOnJ8FL4yGLwXD8STvPEWSYUgBlOxqOIw053QEaVdgQmNo0UMhng4Ay
         f7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TrD+b9KcyDXAn9XTri87X4ww/nyNvMC/tz+poqou13c=;
        b=uH+ekDIRcgwvFZSblZdIIzwm8ItTPoy75p/feMM0GCdIF84quN/1RM4XZHUbqxfNAS
         0+GRlJ56bVNFKfNNaMPRqlFNoC4iZGKRia1zU+u5udSP7RqoJg0RLCUILxJRxae8giOg
         qRFImlM/DHkpUCBMM/hYgVM/qxz6Ypxmmge2zR4p1bu7p+ZAO0FL//d1pi68OnP7Bzfx
         VySEaB+6ug5JabygtB9WQud4XMvX9k66BB6+mu3nhP9KSdW0n6XKRYwmBL1viWE2pWHQ
         FjfUOsDcEFtxr4P3mr3Hu/gUctloAezfSsn2ybOPw38C5nsn4GajJhPyoLw41yWqZFi3
         n7Jg==
X-Gm-Message-State: APjAAAWRhnMZyPwYE68tOPfwrSGLtDGg9iZ5H2l1fIaXrWO9ZBL18zMY
        r1KfBFGRI3mG3NtYAWGpbwYuTilwDDgqsE8JF0Qi8Q==
X-Google-Smtp-Source: APXvYqy8HxLooNNckIHgDT11raVGawwoRblhEOxb5HkG1Ykl+pEoOU0HYMY4xR+iFSPe/HZr653nn9zLuX9hTeXTiRQ=
X-Received: by 2002:a50:f4d8:: with SMTP id v24mr868769edm.166.1562808326390;
 Wed, 10 Jul 2019 18:25:26 -0700 (PDT)
MIME-Version: 1.0
From:   Eric Hankland <ehankland@google.com>
Date:   Wed, 10 Jul 2019 18:25:15 -0700
Message-ID: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
Subject: [PATCH v2] KVM: x86: PMU Event Filter
To:     Wei Wang <wei.w.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Add a VM ioctl that can control which events the guest can monitor.

Signed-off-by: ehankland <ehankland@google.com>
---
Changes since v1:
-Moved to a vm ioctl rather than a vcpu one
-Changed from a whitelist to a configurable filter which can either be
white or black
-Only restrict GP counters since fixed counters require extra handling
and they can be disabled by setting the guest cpuid (though only by
setting the number - they can't be disabled individually)
---
 Documentation/virtual/kvm/api.txt | 25 +++++++++++++
 arch/x86/include/asm/kvm_host.h   |  2 +
 arch/x86/include/uapi/asm/kvm.h   | 10 +++++
 arch/x86/kvm/pmu.c                | 61 +++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h                |  1 +
 arch/x86/kvm/x86.c                |  6 +++
 include/uapi/linux/kvm.h          |  3 ++
 7 files changed, 108 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt
b/Documentation/virtual/kvm/api.txt
index 91fd86fcc49f..a9ee8da36595 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4065,6 +4065,31 @@ KVM_ARM_VCPU_FINALIZE call.
 See KVM_ARM_VCPU_INIT for details of vcpu features that require finalization
 using this ioctl.

+4.120 KVM_SET_PMU_EVENT_FILTER
+
+Capability: KVM_CAP_PMU_EVENT_FILTER
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_pmu_event_filter (in)
+Returns: 0 on success, -1 on error
+
+struct kvm_pmu_event_filter {
+       __u32 type;
+       __u32 nevents;
+       __u64 events[0];
+};
+
+This ioctl restricts the set of PMU events that the guest can program to either
+a whitelist or a blacklist of events. The eventsel+umask of each event the
+guest attempts to program is compared against the events field to determine
+whether the guest should have access. This only affects general purpose
+counters; fixed purpose counters can be disabled by changing the perfmon
+CPUID leaf.
+
+Valid values for 'type':
+#define KVM_PMU_EVENT_WHITELIST 0
+#define KVM_PMU_EVENT_BLACKLIST 1
+

 5. The kvm_run structure
 ------------------------

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f46a12a5cf2e..34d017bd1d1b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -933,6 +933,8 @@ struct kvm_arch {

        bool guest_can_read_msr_platform_info;
        bool exception_payload_enabled;
+
+       struct kvm_pmu_event_filter *pmu_event_filter;
 };

 struct kvm_vm_stat {
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index f9b021e16ebc..4d2e905b7d79 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -422,4 +422,14 @@ struct kvm_nested_state {
        __u8 data[0];
 };

+/* for KVM_CAP_PMU_EVENT_FILTER */
+struct kvm_pmu_event_filter {
+       __u32 type;
+       __u32 nevents;
+       __u64 events[0];
+};
+
+#define KVM_PMU_EVENT_WHITELIST 0
+#define KVM_PMU_EVENT_BLACKLIST 1
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index dd745b58ffd8..d674b79ff8da 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -22,6 +22,9 @@
 #include "lapic.h"
 #include "pmu.h"

+/* This keeps the total size of the filter under 4k. */
+#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 63
+
 /* NOTE:
  * - Each perf counter is defined as "struct kvm_pmc";
  * - There are two types of perf counters: general purpose (gp) and fixed.
@@ -144,6 +147,10 @@ void reprogram_gp_counter(struct kvm_pmc *pmc,
u64 eventsel)
 {
        unsigned config, type = PERF_TYPE_RAW;
        u8 event_select, unit_mask;
+       struct kvm_arch *arch = &pmc->vcpu->kvm->arch;
+       struct kvm_pmu_event_filter *filter;
+       int i;
+       bool allow_event = true;

        if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
                printk_once("kvm pmu: pin control bit is ignored\n");
@@ -155,6 +162,24 @@ void reprogram_gp_counter(struct kvm_pmc *pmc,
u64 eventsel)
        if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
                return;

+       rcu_read_lock();
+       filter = rcu_dereference(arch->pmu_event_filter);
+       if (filter) {
+               for (i = 0; i < filter->nevents; i++)
+                       if (filter->events[i] ==
+                           (eventsel & AMD64_RAW_EVENT_MASK_NB))
+                               break;
+               if (filter->type == KVM_PMU_EVENT_WHITELIST &&
+                   i == filter->nevents)
+                       allow_event = false;
+               if (filter->type == KVM_PMU_EVENT_BLACKLIST &&
+                   i < filter->nevents)
+                       allow_event = false;
+       }
+       rcu_read_unlock();
+       if (!allow_event)
+               return;
+
        event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
        unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;

@@ -351,3 +376,39 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 {
        kvm_pmu_reset(vcpu);
 }
+
+int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
+{
+       struct kvm_pmu_event_filter tmp, *filter;
+       size_t size;
+       int r;
+
+       if (copy_from_user(&tmp, argp, sizeof(tmp)))
+               return -EFAULT;
+
+       if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
+               return -E2BIG;
+
+       size = sizeof(tmp) + sizeof(tmp.events[0]) * tmp.nevents;
+       filter = vmalloc(size);
+       if (!filter)
+               return -ENOMEM;
+
+       r = -EFAULT;
+       if (copy_from_user(filter, argp, size))
+               goto cleanup;
+
+       /* Ensure nevents can't be changed between the user copies. */
+       *filter = tmp;
+
+       mutex_lock(&kvm->lock);
+       rcu_swap_protected(kvm->arch.pmu_event_filter, filter,
+                          mutex_is_locked(&kvm->lock));
+       mutex_unlock(&kvm->lock);
+
+       synchronize_rcu();
+       r = 0;
+cleanup:
+       kvfree(filter);
+       return r;
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 22dff661145a..58265f761c3b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -118,6 +118,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
+int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);

 bool is_vmware_backdoor_pmc(u32 pmc_idx);

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e302e977dac..9ddfc7193bc6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3135,6 +3135,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
*kvm, long ext)
        case KVM_CAP_GET_MSR_FEATURES:
        case KVM_CAP_MSR_PLATFORM_INFO:
        case KVM_CAP_EXCEPTION_PAYLOAD:
+       case KVM_CAP_PMU_EVENT_FILTER:
                r = 1;
                break;
        case KVM_CAP_SYNC_REGS:
@@ -4978,6 +4979,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
                r = kvm_vm_ioctl_hv_eventfd(kvm, &hvevfd);
                break;
        }
+       case KVM_SET_PMU_EVENT_FILTER: {
+               r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
+               break;
+
+       }
        default:
                r = -ENOTTY;
        }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c2152f3dd02d..b18ff80e356a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -995,6 +995,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_PMU_EVENT_FILTER 173

 #ifdef KVM_CAP_IRQ_ROUTING

@@ -1329,6 +1330,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_RMMU_INFO    _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
 /* Available with KVM_CAP_PPC_GET_CPU_CHAR */
 #define KVM_PPC_GET_CPU_CHAR     _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
+/* Availabile with KVM_CAP_PMU_EVENT_FILTER */
+#define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO, 0xb2, struct
kvm_pmu_event_filter)

 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE        _IOWR(KVMIO,  0xe0, struct kvm_create_device)
