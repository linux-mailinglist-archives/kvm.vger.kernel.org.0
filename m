Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68405607E7F
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 21:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJUTAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 15:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJUTAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 15:00:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EA3132EAE
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:59:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g66-20020a636b45000000b0043a256d3639so1748471pgc.12
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=il9gk1S5qojK7G4xKoqIgvriNuF5wmsn4l8++fZfPGQ=;
        b=QM7yKZWVI2m015h4EqgtiKZ1qMRWhX97e1kYND9ElhVHtmkKi7b31QfcTFg4B4T0Gw
         tMkudKcPS7RGnuUH8Mx+FfiUFFGdatqUQ6LFmVhn0RcMKJ5BErFCE3a5W6fP/eHoz6Ou
         19q51RSrQcOvxm0vN6tZoGTos+bKExVixOuXaUsWApaU5IkPm2Op3d5pikyWXa8E9DOr
         nOYByBNc9QurJ6RwccCdutmrJJi6yZLJGJz2FJc6K7FQXQFfpeOHpLKzdnkcRuA8EhzA
         Js5LlACHGl+j1KOP6qMWkYAZNSiPoh6S+V5CN3wnp4mgrj2pjPwY9fMCHsqShURMaIkx
         VGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=il9gk1S5qojK7G4xKoqIgvriNuF5wmsn4l8++fZfPGQ=;
        b=76X+0iFIcVFdGpKoebiyAYA8q4vrYgfuaGz6W592NAibu0D5hgzlYosA9fTMunvqgY
         Z813hPQeDwaT61Hk//3pt8ujq8lOStLJd6HBaB4kDTudK6x4zg5U0tMsDvp5dgyI2pno
         5Y9K46PYBTvRSEyFvzQk56YqSjH6tN0+8RQWWdJGch5oISH9L/wKopBnT6stvIN+98Zd
         HtN0RJ7n1GEMDoscgypsDrTv8hINOWeuwaGiKtZnglTLxpClQGm22ZeVMtbu3VK8RvZ7
         R+35liMWapI37tJovWT9tegj+IwIloDt9LALsNjVZD1Mb3DcZ+bwcnt7rQhDKwRc6u6W
         M0Nw==
X-Gm-Message-State: ACrzQf0EcVzMifd21CA0Akq1KBIQB6M+AXpj06dpIh/z+UCrRQZSLTrK
        DIkH/5EN9nSHms/QOFe7CjVfNhd1XK1I
X-Google-Smtp-Source: AMsMyM44QesJEnRZVEWJz9kBQyL9A08BTyY9DE0GeJsweUuHrTGYyk8050rr3pYT9Rz89+jSRP8Z1ZZDnNXx
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:1742:b0:565:c73a:90de with SMTP
 id j2-20020a056a00174200b00565c73a90demr21246889pfc.68.1666378766941; Fri, 21
 Oct 2022 11:59:26 -0700 (PDT)
Date:   Fri, 21 Oct 2022 11:59:16 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021185916.1494314-1-vipinsh@google.com>
Subject: [RFC PATCH] Add Hyperv extended hypercall support in KVM
From:   Vipin Sharma <vipinsh@google.com>
To:     vkuznets@redhat.com, seanjc@google.com, pbonzini@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org
Cc:     shujunxue@google.com, terrytaehyun@google.com,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyperv hypercalls above 0x8000 are called as extended hypercalls as per
Hyperv TLFS. Hypercall 0x8001 is used to enquire about available
hypercalls by guest VMs.

Add support for HvExtCallQueryCapabilities (0x8001) and
HvExtCallGetBootZeroedMemory (0x8002) in KVM.

A guest VM finds availability of HvExtCallQueryCapabilities (0x8001) by
using CPUID.0x40000003.EBX BIT(20). If the bit is set then the guest VM
make hypercall HvExtCallQueryCapabilities (0x8001) to know what all
extended hypercalls are supported by hypervisor.

A userspace VMM can query capability KVM_CAP_HYPERV_EXT_CALL_QUERY to
know which extended hypercalls are supported in KVM. After which the
userspace will enable capabilities for the guest VM.

HvExtCallQueryCapabilities (0x8001) is handled by KVM in kernel,
whereas, HvExtCallGetBootZeroedMemory (0x8002) is passed to userspace
for further action.

Change-Id: Ib3709fadbf11f91be2842c8486bcbe755e09cbea
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---

Hi,

This is an RFC patch based on the previous discussion
https://lore.kernel.org/kvm/CAHVum0cbWBXUnJ4s32Yn=TfPXLypv_RRT6LmA_QoBHw3Y+kA7w@mail.gmail.com/#t

Things missing in this RFC patch which I will add when sending proper
patch:
1. Documentation
2. Selftest
3. Multiple smaller patches instead of one.

I also need suggestions regarding KVM_ENABLE_CAP usage in this patch. My
idea is userspace can query to know what all capabilities are supported by KVM
and based on that it can call KVM_ENABLE_CAP to enable only select
capabilities. Also userspace need to enforce hyperv CPUID check by
KVM_CAP_HYPERV_ENFORCE_CPUID to make sure these are enforced (hyperv
default is to accept all, hv_check_hypercall_access()).

Current approach is storing capabilities given by userspace in struct kvm_hv{},
I was not sure which will be good place, struct kvm_hv{} or struct
kvm_vcpu_hv{}.

Thanks
Vipin

 arch/x86/include/asm/hyperv-tlfs.h |  3 ++
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/hyperv.c              | 55 ++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h              |  1 +
 arch/x86/kvm/x86.c                 |  5 +++
 include/asm-generic/hyperv-tlfs.h  |  4 ++-
 include/uapi/linux/kvm.h           |  1 +
 7 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 3089ec352743..421279a61a9a 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -158,6 +158,9 @@
 #define HV_SHARED_GPA_BOUNDARY_ACTIVE			BIT(5)
 #define HV_SHARED_GPA_BOUNDARY_BITS			GENMASK(11, 6)
 
+/* Extended hypercalls supported by KVM */
+#define HV_EXT_CALL_QUERY_CAPABILITIES_MASK		BIT(0)
+
 enum hv_isolation_type {
 	HV_ISOLATION_TYPE_NONE	= 0,
 	HV_ISOLATION_TYPE_VBS	= 1,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..b1892ea39a23 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1041,6 +1041,8 @@ struct kvm_hv {
 
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
+
+	u64 extended_hypercalls_cap;
 };
 
 struct msr_bitmap_range {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0adf4a437e85..5f0b7d8789a8 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -32,6 +32,7 @@
 #include <linux/eventfd.h>
 
 #include <asm/apicdef.h>
+#include <asm/hyperv-tlfs.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -2140,6 +2141,8 @@ static void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
 
 static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 {
+	struct kvm_hv *hv;
+
 	if (!hv_vcpu->enforce_cpuid)
 		return true;
 
@@ -2178,6 +2181,14 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 	case HVCALL_SEND_IPI:
 		return hv_vcpu->cpuid_cache.enlightenments_eax &
 			HV_X64_CLUSTER_IPI_RECOMMENDED;
+	case HV_EXT_CALL_QUERY_CAPABILITIES:
+		return hv_vcpu->cpuid_cache.features_ebx &
+				HV_ENABLE_EXTENDED_HYPERCALLS;
+	case HV_EXT_CALL_GET_BOOT_ZEROED_MEMORY:
+		hv = to_kvm_hv(hv_vcpu->vcpu->kvm);
+		return hv->extended_hypercalls_cap &
+			HV_EXT_CAPABILITY_GET_BOOT_ZEROED_MEMORY;
+		break;
 	default:
 		break;
 	}
@@ -2189,6 +2200,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_hv_hcall hc;
+	struct kvm_hv *hv;
 	u64 ret = HV_STATUS_SUCCESS;
 
 	/*
@@ -2345,6 +2357,30 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
 	}
+	case HV_EXT_CALL_QUERY_CAPABILITIES:
+		if (unlikely(hc.fast)) {
+			ret = HV_STATUS_INVALID_PARAMETER;
+			break;
+		}
+		hv = to_kvm_hv(hv_vcpu->vcpu->kvm);
+		if (kvm_vcpu_write_guest(vcpu, hc.outgpa,
+					 &hv->extended_hypercalls_cap,
+					 sizeof(hv->extended_hypercalls_cap)))
+			ret = HV_STATUS_OPERATION_DENIED;
+		break;
+	case HV_EXT_CALL_GET_BOOT_ZEROED_MEMORY:
+		if (unlikely(hc.fast)) {
+			ret = HV_STATUS_INVALID_PARAMETER;
+			break;
+		}
+		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
+		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
+		vcpu->run->hyperv.u.hcall.input = hc.param;
+		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
+		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
+		vcpu->arch.complete_userspace_io =
+				kvm_hv_hypercall_complete_userspace;
+		return 0;
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
@@ -2494,6 +2530,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
+			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
 
 			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
@@ -2578,3 +2615,21 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 	return 0;
 }
+
+int kvm_hv_set_ext_call_cap(struct kvm_vcpu *vcpu, uint64_t cap)
+{
+	struct kvm_hv *hv;
+	int r;
+
+	if (cap & ~HV_EXT_CALL_QUERY_CAPABILITIES_MASK)
+		return -EINVAL;
+
+	r = kvm_hv_vcpu_init(vcpu);
+	if (r)
+		return r;
+
+	hv = to_kvm_hv(vcpu->kvm);
+	hv->extended_hypercalls_cap = cap;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 1030b1b50552..b92f8abdbf0d 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -150,5 +150,6 @@ int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce);
 int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
+int kvm_hv_set_ext_call_cap(struct kvm_vcpu *vcpu, uint64_t cap);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..caca1f537f6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4515,6 +4515,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_NOTIFY_VMEXIT:
 		r = kvm_caps.has_notify_vmexit;
 		break;
+	case KVM_CAP_HYPERV_EXT_CALL_QUERY:
+		r = HV_EXT_CALL_QUERY_CAPABILITIES_MASK;
+		break;
 	default:
 		break;
 	}
@@ -5510,6 +5513,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 			kvm_update_pv_runtime(vcpu);
 
 		return 0;
+	case KVM_CAP_HYPERV_EXT_CALL_QUERY:
+		return kvm_hv_set_ext_call_cap(vcpu, cap->args[0]);
 	default:
 		return -EINVAL;
 	}
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index fdce7a4cfc6f..15ffc2c5d950 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -162,6 +162,7 @@ struct ms_hyperv_tsc_page {
 
 /* Extended hypercalls */
 #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
+#define HV_EXT_CALL_GET_BOOT_ZEROED_MEMORY	0x8002
 #define HV_EXT_CALL_MEMORY_HEAT_HINT		0x8003
 
 #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
@@ -170,7 +171,8 @@ struct ms_hyperv_tsc_page {
 #define HV_FLUSH_USE_EXTENDED_RANGE_FORMAT	BIT(3)
 
 /* Extended capability bits */
-#define HV_EXT_CAPABILITY_MEMORY_COLD_DISCARD_HINT BIT(8)
+#define HV_EXT_CAPABILITY_GET_BOOT_ZEROED_MEMORY	BIT(0)
+#define HV_EXT_CAPABILITY_MEMORY_COLD_DISCARD_HINT	BIT(8)
 
 enum HV_GENERIC_SET_FORMAT {
 	HV_GENERIC_SET_SPARSE_4K,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..42860137e545 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_HYPERV_EXT_CALL_QUERY 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.38.0.135.g90850a2211-goog

