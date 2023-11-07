Return-Path: <kvm+bounces-1061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB287E4925
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CA671C20D2D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285F236B09;
	Tue,  7 Nov 2023 19:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pm8zABPj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8167136AEB
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 19:23:49 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C0A98;
	Tue,  7 Nov 2023 11:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699385028; x=1730921028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EfGk4P9EdTCEHeXzaxMjw8fYhbS6qxAhbQ9zn/59b5M=;
  b=Pm8zABPjnHaT3888r768Wva65pXiqbCIkEyRthE5hkbeFQUEPuwz48Gn
   dVKHm7fvPu8Y/ntvt6kO2Cz5yPPc/vvyOW7sJwGa51biDEpZI8aRQZ5gw
   DnCL9LKCllVl5V/QqUqhwez0aXjx5Pq4N/jIKqJgG9mIfS9a2EVgDfLqc
   gsDunakmH8MyRN9cSwKTyZ9ymsB3jr39AJZIGDsnCCGvR25gDoMnzA7BA
   d/khnlt8ULS4lSJgLofpLaPhfqtFgeMgbII4cGV96RZV/QBAdgChlbjP9
   efpu9QJ6uFGXy+D7O5akKSOWAzpBUPgnzWTY0VgFP/zdFtRjuNATJnRty
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="475831547"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="475831547"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 11:23:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10937913"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 11:23:48 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH 2/2] KVM: X86: Add a capability to configure bus frequency for APIC timer
Date: Tue,  7 Nov 2023 11:22:34 -0800
Message-Id: <70c2a2277f57b804c715c5b4b4aa0b3561ed6a4f.1699383993.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699383993.git.isaku.yamahata@intel.com>
References: <cover.1699383993.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
frequency.  When using this capability, the user space VMM should configure
CPUID[0x15] to advertise the frequency.

TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  The
x86 KVM hardcodes its freuqncy for APIC timer to be 1GHz.  This mismatch
causes the vAPIC timer to fire earlier than the guest expects. [1] The KVM
APIC timer emulation uses hrtimer, whose unit is nanosecond.  Make the
parameter configurable for conversion from the TMICT value to nanosecond.

This patch doesn't affect the TSC deadline timer emulation.  The TSC
deadline emulation path records its expiring TSC value and calculates the
expiring time in nanoseconds.  The APIC timer emulation path calculates the
TSC value from the TMICT register value and uses the TSC deadline timer
path.  This patch touches the APIC timer-specific code but doesn't touch
common logic.

[1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
Reported-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c       | 14 ++++++++++++++
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9f4991b3e2e..20849d2cd0e8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4625,6 +4625,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6616,6 +6617,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL: {
+		u64 bus_frequency = cap->args[0];
+		u64 bus_cycle_ns;
+
+		if (!bus_frequency)
+			return -EINVAL;
+		bus_cycle_ns = 1000000000UL / bus_frequency;
+		if (!bus_cycle_ns)
+			return -EINVAL;
+		kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
+		kvm->arch.apic_bus_frequency = bus_frequency;
+		return 0;
+	}
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 211b86de35ac..d74a057df173 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1201,6 +1201,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 #define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
+#define KVM_CAP_X86_BUS_FREQUENCY_CONTROL 231
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.1


