Return-Path: <kvm+bounces-52924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B9F3B0AA0B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 20:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C19691C269BB
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 18:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341C62E7F27;
	Fri, 18 Jul 2025 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="draBhING"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221031DE891
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752862547; cv=none; b=KmsJhdiwJH1iouHqDaEDH9Ul6EOAv6mFvtlq4r5URPzRvInznM36HNZpArCkgI/dEUzmlD/LNvu1pxJ3rHMP327A8BXrlhdtCOGgkcw1pMA67VCMhL0Xty/q0aefpqN4AiJYcfAAK0gU31uxJ/H8GfHQLN9dXAEPU23IXM45htc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752862547; c=relaxed/simple;
	bh=EsUInRltjcg43ASMK5sf5Ox/ZQ7jsY3+RpPODBPg/xw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Xpkd1UDGjINQ+nWv893iuz/POBME0yIbJoknwy6pY4LnZZuBhpWr8ZFh17SWCOaRP8oi+Wp0qHfw7C42mDyj6VE8WmMDfidSlU2iSUK/58lktsyOxiS4U4VlSUrtItES97SNlgO7aLX2h/U3TXX93ul7hjbwtxdQSV8CndfiDJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=draBhING; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31366819969so2259921a91.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752862544; x=1753467344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hkReTPZH1vOPpXxUAOIRDj7kht96jaWhyZgj9Ubwa1c=;
        b=draBhINGf6V3qhcI23nkc3Rvy+xKs20hn62Ezo7lhHGE0wu19QRJZNbzySB2Hx4Mia
         uzEJdXAWNBvX3v4LxAwdIqSG6KHW9SmCqSgbcj9tJW1KNGcMlvyW5myaQmwAlimmclnw
         SvX3zqvsNsKpyoTV287ZVlrvSV4+I5QQKTICFSXqhxmLN+ZWQWEWg3IaGROAfHtx9lcY
         O8Ew0yJfqw6hS7dLQhnxYnvlr1TFRLwl9xswT5pUbqlRO2PG/GHPXzWTREKgElp0bnwi
         yFF533v+R0C6JoRlpfSzo8wyPRAAtIGok1TpBUhoyt9QLRwEO9IK/PCbzMp9KAzPYDm0
         pfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752862544; x=1753467344;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkReTPZH1vOPpXxUAOIRDj7kht96jaWhyZgj9Ubwa1c=;
        b=taRToKZsdw0NMn/L2gYIr7ePU7gP9XIcB1t+QDFrzcJok25V4PX/EFAnXHg4Yc+YOf
         rHv/rfUqse56dF4slepvs/mRN3D3pRJMHk9Po33A4fXycx3S+syzaii0K+09eIdvKjqz
         3gNWVhgoENVh0kygQXyQodKnnXfeDz1mQGSX+kQ84fh8qd2PE5W/crmdSlzulrgiAu7A
         IDip8s3/t2K4k0r63+PnRrXQV2QugOFU1jow7cnVnn3nKpn/POUREfJ0R5zKoAmhZrV+
         JDsbZ3PL8+IWu7as7Q6T8g08K0uNWSQjXH1BH+eGOsdjqQA4VcwjAv9KmgNnAmqetekE
         GsUw==
X-Gm-Message-State: AOJu0Ywbc+NPcce8cN23SnBH8GAjZBVQYhxhuwSCXmzz+su7LR1IUvX1
	e0+dKHKfXeLAW7O2f0W2XFPrMNTg19NAU08IelPA2pTBvXq5ltFOys/W9J6zbJHQjWdgTHbXhwn
	uaXbZtw==
X-Google-Smtp-Source: AGHT+IEUPZwCXkwy3/ez7ACZb3qNlftOADqswjLSR8iL5SS8XmO58YJAHkhk6DgqIAlhL2PdYHLu/3P6+74=
X-Received: from pjyr15.prod.google.com ([2002:a17:90a:e18f:b0:31c:2fe4:33b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:47:b0:311:b005:93d4
 with SMTP id 98e67ed59e1d1-31c9e778b03mr15950630a91.25.1752862544466; Fri, 18
 Jul 2025 11:15:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 18 Jul 2025 11:15:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250718181541.98146-1-seanjc@google.com>
Subject: [PATCH v5] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="UTF-8"

Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
which enables more efficient reclaim of private memory.

Private memory is removed from MMU/TDP when guest_memfds are closed.  If
the HKID has not been released, the TDX VM is still in the RUNNABLE state,
and so pages must be removed using "Dynamic Page Removal" procedure (refer
to the TDX Module Base spec) which involves a number of steps:
	Block further address translation
	Exit each VCPU
	Clear Secure EPT entry
	Flush/write-back/invalidate relevant caches

However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state,
where all TDX VM pages are effectively unmapped, so pages can be reclaimed
directly.

Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
reclaim time.  For example:

  VCPUs    Size (GB)    Before (secs)    After (secs)
      4           18		   72              24
     32          107		  517             134
     64          400		 5539             467

Add kvm_tdx_capabilities.supported_caps along with KVM_TDX_CAP_TERMINATE_VM
to advertise support to userspace.  Use a new field in kvm_tdx_capabilities
instead of adding yet another generic KVM_CAP to avoid bleeding TDX details
into common code (and #ifdefs), and so that userspace can query TDX
capabilities in one shot.  Enumerating capabilities as a mask of bits does
limit supported_caps to 64 capabilities, but in the unlikely event KVM
needs to enumerate more than 64 TDX capabilities, there are another 249
u64 entries reserved for future expansion.

Link: https://lore.kernel.org/r/Z-V0qyTn2bXdrPF7@google.com
Link: https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v5:
 - Add KVM_TDX_CAP_TERMINATE_VM to enumerate support [Xiaoyao].

V4:
 - https://lore.kernel.org/all/20250611095158.19398-1-adrian.hunter@intel.com
 - Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
 - Use KVM_BUG_ON() instead of WARN_ON().
 - Correct kvm_trylock_all_vcpus() return value.

v3:
 - Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it would
   trigger on the error path from __tdx_td_init()
 - Put cpus_read_lock() handling back into tdx_mmu_release_hkid()
 - Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
   tdx_vm_ioctl() deal with kvm->lock

 Documentation/virt/kvm/x86/intel-tdx.rst | 22 ++++++++++++++-
 arch/x86/include/uapi/asm/kvm.h          |  7 ++++-
 arch/x86/kvm/vmx/tdx.c                   | 36 ++++++++++++++++++------
 3 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 5efac62c92c7..bcfa97e0c9e7 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -38,6 +38,7 @@ ioctl with TDX specific sub-ioctl() commands.
           KVM_TDX_INIT_MEM_REGION,
           KVM_TDX_FINALIZE_VM,
           KVM_TDX_GET_CPUID,
+          KVM_TDX_TERMINATE_VM,
 
           KVM_TDX_CMD_NR_MAX,
   };
@@ -92,7 +93,10 @@ to be configured to the TDX guest.
         __u64 kernel_tdvmcallinfo_1_r12;
         __u64 user_tdvmcallinfo_1_r12;
 
-        __u64 reserved[250];
+        /* Misc capabilities enumerated via the KVM_TDX_CAP_* namespace. */
+        __u64 supported_caps;
+
+        __u64 reserved[249];
 
         /* Configurable CPUID bits for userspace */
         struct kvm_cpuid2 cpuid;
@@ -227,6 +231,22 @@ struct kvm_cpuid2.
 	  __u32 padding[3];
   };
 
+KVM_TDX_TERMINATE_VM
+--------------------
+:Capability: KVM_TDX_CAP_TERMINATE_VM
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Release Host Key ID (HKID) to allow more efficient reclaim of private memory.
+After this, the TD is no longer in a runnable state.
+
+Using KVM_TDX_TERMINATE_VM is optional.
+
+- id: KVM_TDX_TERMINATE_VM
+- flags: must be 0
+- data: must be 0
+- hw_error: must be 0
+
 KVM TDX creation flow
 =====================
 In addition to the standard KVM flow, new TDX ioctls need to be called.  The
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..e019111e2150 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -940,6 +940,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
+	KVM_TDX_TERMINATE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -962,6 +963,8 @@ struct kvm_tdx_cmd {
 	__u64 hw_error;
 };
 
+#define KVM_TDX_CAP_TERMINATE_VM       _BITULL(0)
+
 struct kvm_tdx_capabilities {
 	__u64 supported_attrs;
 	__u64 supported_xfam;
@@ -971,7 +974,9 @@ struct kvm_tdx_capabilities {
 	__u64 kernel_tdvmcallinfo_1_r12;
 	__u64 user_tdvmcallinfo_1_r12;
 
-	__u64 reserved[250];
+	__u64 supported_caps;
+
+	__u64 reserved[249];
 
 	/* Configurable CPUID bits for userspace */
 	struct kvm_cpuid2 cpuid;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..573d6f7d1694 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -188,6 +188,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
 	if (!caps->supported_xfam)
 		return -EIO;
 
+	caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM;
+
 	caps->cpuid.nent = td_conf->num_cpuid_config;
 
 	caps->user_tdvmcallinfo_1_r11 =
@@ -520,6 +522,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		goto out;
 	}
 
+	write_lock(&kvm->mmu_lock);
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -544,7 +547,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	} else {
 		tdx_hkid_free(kvm_tdx);
 	}
-
+	write_unlock(&kvm->mmu_lock);
 out:
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
@@ -1884,13 +1887,13 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
+		KVM_BUG_ON(!kvm->vm_dead, kvm);
+		ret = tdx_reclaim_page(page);
+		if (!ret)
+			tdx_unpin(kvm, page);
+		return ret;
+	}
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -2886,6 +2889,20 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_terminate_vm(struct kvm *kvm)
+{
+	if (kvm_trylock_all_vcpus(kvm))
+		return -EBUSY;
+
+	kvm_vm_dead(kvm);
+
+	kvm_unlock_all_vcpus(kvm);
+
+	tdx_mmu_release_hkid(kvm);
+
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -2913,6 +2930,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_FINALIZE_VM:
 		r = tdx_td_finalize(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_TERMINATE_VM:
+		r = tdx_terminate_vm(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;

base-commit: 31bac41e445518c36b21e1d3198a8301125e3cb4
-- 
2.50.0.727.gbf7dc18ff4-goog


