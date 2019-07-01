Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C784E27232
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 00:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfEVWXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 18:23:13 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:33510 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEVWXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 18:23:13 -0400
Received: by mail-vs1-f65.google.com with SMTP id y6so2403874vsb.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2019 15:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DYN9LlFeyKRjq/xcPPmVp8LKn1oRYtGLM+ITTEgUoj8=;
        b=TlpHTH27ENCb9k0Q8+5A/acQGXrYdIrAXa0g7+wD5DdZPKfefo7ZRd0eFnxEw7PJ8B
         Rcvg4m6byxm5zpKRklaLUdLnJ4+79xwm+1kSAF/gFdJjJ8aKqehDepNbBn+vSXzvT6gk
         I8dmgQNaFyoyzjAtQyNNSCshDpfbdt80qJage1IpfZqJU+3LkpVpRsSva4EMSsTm2Rwh
         dGt6it4PCEAHQNy9RdNROYFn8S/7FcztaJpAjGx2/NVy+QIYFgL6A1OyWZTimX2F7RJd
         jw8S6qbQLAa0YTj7Jgf68E6Jfe/O86J3+SyiqFkxuZDwcDn89Vx0PVOEnKrF489bZnew
         1gcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DYN9LlFeyKRjq/xcPPmVp8LKn1oRYtGLM+ITTEgUoj8=;
        b=g4z81DUhi/p/cOrdiYg29OI8iSQdm47FVvwm224SoUMMJfkR5O/s3D3gb2UMis/WVR
         33AEV4Q45u75C7l4JBlIJE9nQb06i7KxtXCSzv6T4pz1LH83RIT9qVLFyd8Fv04NUM4k
         1KLAFXjWHdVwXzOdW6ZMbF/+z1bAMNc7rmAhn2jZphKbI5WrS+XRPtxrPRDH1WHoTnfT
         oPXhQb74HT7D1tjiMIRy3nyLCAMp+6aWffKiCEZDwY+CL5pKCwMbjtpEdVNkz+Y4TcAb
         1pXNVOvIlqH8wtVkjUd9NYqmlKktC5phh7boQxvQ5fmPjHLXse//vQIgBNhbl0jZ2IoU
         q6XA==
X-Gm-Message-State: APjAAAUc+3sE6PVOldZmAyanI9o2ymKKlnmjP/YKOw+oDX0AxRw2Pow6
        mmtDpRdwKoRwrt0MaEYIMWF8Z5Ky56stYwZQvgtwnA==
X-Google-Smtp-Source: APXvYqwuKhVD+ogfR/VeIAquIxZhNEnuyb8mKOSN9dLHcNiBDFmXEaj0ElOAqgbt6GJh+N5QXEQO3j+bwRGykqcMN88=
X-Received: by 2002:a67:ebd6:: with SMTP id y22mr29442238vso.87.1558563791712;
 Wed, 22 May 2019 15:23:11 -0700 (PDT)
MIME-Version: 1.0
From:   Eric Hankland <ehankland@google.com>
Date:   Wed, 22 May 2019 15:23:00 -0700
Message-ID: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
Subject: [PATCH v1] KVM: x86: PMU Whitelist
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Add a VCPU ioctl that can control which events the guest can monitor.

Signed-off-by: ehankland <ehankland@google.com>
---
Some events can provide a guest with information about other guests or the
host (e.g. L3 cache stats); providing the capability to restrict access
to a "safe" set of events would limit the potential for the PMU to be used
in any side channel attacks. This change introduces a new vcpu ioctl that
sets an event whitelist. If the guest attempts to program a counter for
any unwhitelisted event, the kernel counter won't be created, so any
RDPMC/RDMSR will show 0 instances of that event.
---
 Documentation/virtual/kvm/api.txt | 16 +++++++++++
 arch/x86/include/asm/kvm_host.h   |  1 +
 arch/x86/include/uapi/asm/kvm.h   |  7 +++++
 arch/x86/kvm/pmu.c                | 44 +++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h                |  3 +++
 arch/x86/kvm/pmu_amd.c            | 16 +++++++++++
 arch/x86/kvm/vmx/pmu_intel.c      | 16 +++++++++++
 arch/x86/kvm/x86.c                |  7 +++++
 include/uapi/linux/kvm.h          |  4 +++
 9 files changed, 114 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt
b/Documentation/virtual/kvm/api.txt
index ba6c42c576dd..79cbe7339145 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4065,6 +4065,22 @@ KVM_ARM_VCPU_FINALIZE call.
 See KVM_ARM_VCPU_INIT for details of vcpu features that require finalization
 using this ioctl.

+4.120 KVM_SET_PMU_WHITELIST
+
+Capability: KVM_CAP_PMU_WHITELIST
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_pmu_whitelist (in)
+Returns: 0 on success, -1 on error
+
+struct kvm_pmu_whitelist {
+       __u64 event_mask;
+       __u16 num_events;
+       __u64 events[0];
+};
+This ioctl restricts the set of PMU events that the guest can program to the
+set of whitelisted events.
+
 5. The kvm_run structure
 ------------------------

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 450d69a1e6fa..942647475999 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -477,6 +477,7 @@ struct kvm_pmu {
        struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
        struct irq_work irq_work;
        u64 reprogram_pmi;
+       struct kvm_pmu_whitelist *whitelist;
 };

 struct kvm_pmu_ops;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7a0e64ccd6ff..2633b48b75cd 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -421,4 +421,11 @@ struct kvm_nested_state {
        __u8 data[0];
 };

+/* for KVM_SET_PMU_WHITELIST */
+struct kvm_pmu_whitelist {
+       __u64 event_mask;
+       __u16 num_events;
+       __u64 events[0];
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e39741997893..d0d81cd3626d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -101,6 +101,9 @@ static void pmc_reprogram_counter(struct kvm_pmc
*pmc, u32 type,
                                  bool exclude_kernel, bool intr,
                                  bool in_tx, bool in_tx_cp)
 {
+       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+       int i;
+       u64 event_config;
        struct perf_event *event;
        struct perf_event_attr attr = {
                .type = type,
@@ -127,6 +130,19 @@ static void pmc_reprogram_counter(struct kvm_pmc
*pmc, u32 type,
                attr.config |= HSW_IN_TX_CHECKPOINTED;
        }

+       if (pmu->whitelist) {
+               event_config = attr.config;
+               if (type == PERF_TYPE_HARDWARE)
+                       event_config = kvm_x86_ops->pmu_ops->get_event_code(
+                               attr.config);
+               event_config &= pmu->whitelist->event_mask;
+               for (i = 0; i < pmu->whitelist->num_events; i++)
+                       if (event_config == pmu->whitelist->events[i])
+                               break;
+               if (i == pmu->whitelist->num_events)
+                       return;
+       }
+
        event = perf_event_create_kernel_counter(&attr, -1, current,
                                                 intr ? kvm_perf_overflow_intr :
                                                 kvm_perf_overflow, pmc);
@@ -244,6 +260,34 @@ int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu
*vcpu, unsigned idx)
        return kvm_x86_ops->pmu_ops->is_valid_msr_idx(vcpu, idx);
 }

+int kvm_vcpu_ioctl_set_pmu_whitelist(struct kvm_vcpu *vcpu,
+                                    struct kvm_pmu_whitelist __user *whtlst)
+{
+       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+       struct kvm_pmu_whitelist *old = pmu->whitelist;
+       struct kvm_pmu_whitelist *new = NULL;
+       struct kvm_pmu_whitelist tmp;
+       int r;
+       size_t size;
+
+       r = -EFAULT;
+       if (copy_from_user(&tmp, whtlst, sizeof(struct kvm_pmu_whitelist)))
+               goto err;
+
+       size = sizeof(tmp) + sizeof(tmp.events[0]) * tmp.num_events;
+       new = kvzalloc(size, GFP_KERNEL_ACCOUNT);
+       r = -ENOMEM;
+       if (!new)
+               goto err;
+       pmu->whitelist = new;
+
+       kvfree(old);
+       return 0;
+err:
+       kvfree(new);
+       return r;
+}
+
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
 {
        switch (pmc_idx) {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ba8898e1a854..7d4a37fcb043 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -23,6 +23,7 @@ struct kvm_pmu_ops {
        unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
                                    u8 unit_mask);
        unsigned (*find_fixed_event)(int idx);
+       u64 (*get_event_code)(unsigned event_type);
        bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
        struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
        struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx);
@@ -108,6 +109,8 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);

 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
+int kvm_vcpu_ioctl_set_pmu_whitelist(struct kvm_vcpu *vcpu,
+                                    struct kvm_pmu_whitelist __user *whtlst);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 1495a735b38e..1d977b20c863 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -145,6 +145,21 @@ static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
        return amd_event_mapping[i].event_type;
 }

+static u64 amd_get_event_code(unsigned event_type)
+{
+       int i;
+       u64 event_code = 0;
+
+       for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
+               if (amd_event_mapping[i].event_type == event_type) {
+                       event_code = amd_event_mapping[i].eventsel |
+                               ((u64)amd_event_mapping[i].unit_mask << 8);
+                       break;
+               }
+
+       return event_code;
+}
+
 /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
 static unsigned amd_find_fixed_event(int idx)
 {
@@ -306,6 +321,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 struct kvm_pmu_ops amd_pmu_ops = {
        .find_arch_event = amd_find_arch_event,
        .find_fixed_event = amd_find_fixed_event,
+       .get_event_code = amd_get_event_code,
        .pmc_is_enabled = amd_pmc_is_enabled,
        .pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
        .msr_idx_to_pmc = amd_msr_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f8502c376b37..01a5d5a3bf3d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -67,6 +67,21 @@ static void global_ctrl_changed(struct kvm_pmu
*pmu, u64 data)
                reprogram_counter(pmu, bit);
 }

+static u64 intel_get_event_code(unsigned event_type)
+{
+       int i;
+       u64 event_code = 0;
+
+       for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
+               if (intel_arch_events[i].event_type == event_type) {
+                       event_code = intel_arch_events[i].eventsel |
+                               ((u64) intel_arch_events[i].unit_mask << 8);
+                       break;
+               }
+
+       return event_code;
+}
+
 static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
                                      u8 event_select,
                                      u8 unit_mask)
@@ -350,6 +365,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)

 struct kvm_pmu_ops intel_pmu_ops = {
        .find_arch_event = intel_find_arch_event,
+       .get_event_code = intel_get_event_code,
        .find_fixed_event = intel_find_fixed_event,
        .pmc_is_enabled = intel_pmc_is_enabled,
        .pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 536b78c4af6e..089de23289f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3089,6 +3089,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
*kvm, long ext)
        case KVM_CAP_GET_MSR_FEATURES:
        case KVM_CAP_MSR_PLATFORM_INFO:
        case KVM_CAP_EXCEPTION_PAYLOAD:
+       case KVM_CAP_PMU_WHITELIST:
                r = 1;
                break;
        case KVM_CAP_SYNC_REGS:
@@ -4285,6 +4286,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
                r = 0;
                break;
        }
+       case KVM_SET_PMU_WHITELIST: {
+               struct kvm_pmu_whitelist __user *whitelist = argp;
+
+               r = kvm_vcpu_ioctl_set_pmu_whitelist(vcpu, whitelist);
+               goto out;
+       }
        default:
                r = -EINVAL;
        }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b40d503..140a6ac52981 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_PMU_WHITELIST 173

 #ifdef KVM_CAP_IRQ_ROUTING

@@ -1451,6 +1452,9 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE    _IOW(KVMIO,  0xc2, int)

+/* Available with KVM_CAP_PMU_WHITELIST */
+# define KVM_SET_PMU_WHITELIST   _IOW(KVMIO, 0xc3, struct kvm_pmu_whitelist)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
        /* Guest initialization commands */
