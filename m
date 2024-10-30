Return-Path: <kvm+bounces-30096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB5F9B6CAD
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8D4283576
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0860522802C;
	Wed, 30 Oct 2024 19:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QNbiiXdC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CB821F4A4;
	Wed, 30 Oct 2024 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314876; cv=none; b=LJxEjggQvscvf/qBjGptXa+mouBJo4Qdk1bzCXFLDq8ftSPVsy1Sq1xk/bnVeKjxxwLB/XB53a2b7Ymr+Kqdj+qjE0HvkRka74La2zXc6UQfRXB8AzSleZUeBNvJwhCb28RWY/zKmWu+j7zIknDn+X5CttowyaKPRlNT7SrcjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314876; c=relaxed/simple;
	bh=Au+x7T6/rqwLMWU1pQUqQQMAW+zIxuKwmu5a/UDxj/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNjPegcxN2XPx2GzbxACdlvZQv899E2s6G6WZq0oU/hmBZXBxCceMzQYlFqDqr3v/mnhxaiRXgSnblU9hl/GsaRQSYfey76gdOdGhWT/DKD8oZWt1ew0cwE9g5eO7YSe4AlQc+n/CMXjUENokW5EhLbx/yirpOgkLCNHXS3WwWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QNbiiXdC; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314874; x=1761850874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Au+x7T6/rqwLMWU1pQUqQQMAW+zIxuKwmu5a/UDxj/o=;
  b=QNbiiXdC90MLlrIej/TQO2UMi9iwd5HKeua9XXqUHcWAvg/1IxGGqFxJ
   Fit5rS6adh3dzdl7zXSvbPbPOTS/ekCCUSaMCQVQGvWaVqh7+5ZgWiWAC
   h4/iZb+up1tDhuFNHmKFG8Q7r5o1vTVXGQQXS9xpN6rDvnuF0hpeMg8rB
   Gqg1PBk2EB3/5YZrstuv7xH6RarQ0XbV5cQ0GkY3pIn932tUmbwSk23qO
   ElWKq8foAY1cggq5/EKaHw9oJZvw4SibQv8PVajqVXg1fMtzRYsNV6/Pf
   qBviJBLcNK8TzIB6pP/JDTJcYW6m8H2OLsOIOGT3QVtfAOfR457HiImb6
   w==;
X-CSE-ConnectionGUID: JB4HYZ8CTaeUQOqHfpBYFg==
X-CSE-MsgGUID: dvse+m0WQYqiWzK6fVXvig==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678813"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678813"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:05 -0700
X-CSE-ConnectionGUID: qgYHTSsGSi2GXtc/Gpe2NQ==
X-CSE-MsgGUID: oZJJCf8pTgWWuOm8lHTXJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499430"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:04 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 18/25] KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS extension check
Date: Wed, 30 Oct 2024 12:00:31 -0700
Message-ID: <20241030190039.77971-19-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Change to report the KVM_CAP_MAX_VCPUS extension from globally to per-VM
to allow userspace to be able to query maximum vCPUs for TDX guest via
checking the KVM_CAP_MAX_VCPU extension on per-VM basis.

Today KVM x86 reports KVM_MAX_VCPUS as guest's maximum vCPUs for all
guests globally, and userspace, i.e. Qemu, queries the KVM_MAX_VCPUS
extension globally but not on per-VM basis.

TDX has its own limit of maximum vCPUs it can support for all TDX guests
in addition to KVM_MAX_VCPUS.  TDX module reports this limit via the
MAX_VCPU_PER_TD global metadata.  Different modules may report different
values.  In practice, the reported value reflects the maximum logical
CPUs that ALL the platforms that the module supports can possibly have.

Note some old modules may also not support this metadata, in which case
the limit is U16_MAX.

The current way to always report KVM_MAX_VCPUS in the KVM_CAP_MAX_VCPUS
extension is not enough for TDX.  To accommodate TDX, change to report
the KVM_CAP_MAX_VCPUS extension on per-VM basis.

Specifically, override kvm->max_vcpus in tdx_vm_init() for TDX guest,
and report kvm->max_vcpus in the KVM_CAP_MAX_VCPUS extension check.

Change to report "the number of logical CPUs the platform has" as the
maximum vCPUs for TDX guest.  Simply forwarding the MAX_VCPU_PER_TD
reported by the TDX module would result in an unpredictable ABI because
the reported value to userspace would be depending on whims of TDX
modules.

This works in practice because of the MAX_VCPU_PER_TD reported by the
TDX module will never be smaller than the one reported to userspace.
But to make sure KVM never reports an unsupported value, sanity check
the MAX_VCPU_PER_TD reported by TDX module is not smaller than the
number of logical CPUs the platform has, otherwise refuse to use TDX.

Note, when creating a TDX guest, TDX actually requires the "maximum
vCPUs for _this_ TDX guest" as an input to initialize the TDX guest.
But TDX guest's maximum vCPUs is not part of TDREPORT thus not part of
attestation, thus there's no need to allow userspace to explicitly
_configure_ the maximum vCPUs on per-VM basis.  KVM will simply use
kvm->max_vcpus as input when initializing the TDX guest.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Implement proposal from Sean: (Kai)
   - https://lore.kernel.org/kvm/ZmzaqRy2zjvlsDfL@google.com/
   - https://lore.kernel.org/kvm/fcbc5a898c3434af98656b92a83dbba01d055e51.camel@intel.com/
 - Change title from "KVM: TDX: Allow userspace to configure maximum
   vCPUs for TDX guests"
 - Correct setting of kvm->max_vcpus (Kai)

uAPI breakout v1:
 - Change to use exported 'struct tdx_sysinfo' pointer.
 - Remove the code to read 'max_vcpus_per_td' since it is now done in
   TDX host code.
 - Drop max_vcpu ops to use kvm.max_vcpus
 - Remove TDX_MAX_VCPUS (Kai)
 - Use type cast (u16) instead of calling memcpy() when reading the
   'max_vcpus_per_td' (Kai)
 - Improve change log and change patch title from "KVM: TDX: Make
   KVM_CAP_MAX_VCPUS backend specific" (Kai)
---
 arch/x86/kvm/vmx/main.c |  1 +
 arch/x86/kvm/vmx/tdx.c  | 51 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c      |  2 ++
 3 files changed, 54 insertions(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ed4afa45b16b..559f9450dec7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -7,6 +7,7 @@
 #include "pmu.h"
 #include "posted_intr.h"
 #include "tdx.h"
+#include "tdx_arch.h"
 
 static __init int vt_hardware_setup(void)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 50217f601061..c9093b003c13 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -385,6 +385,19 @@ int tdx_vm_init(struct kvm *kvm)
 {
 	kvm->arch.has_private_mem = true;
 
+	/*
+	 * TDX has its own limit of maximum vCPUs it can support for all
+	 * TDX guests in addition to KVM_MAX_VCPUS.  TDX module reports
+	 * such limit via the MAX_VCPU_PER_TD global metadata.  In
+	 * practice, it reflects the number of logical CPUs that ALL
+	 * platforms that the TDX module supports can possibly have.
+	 *
+	 * Limit TDX guest's maximum vCPUs to the number of logical CPUs
+	 * the platform has.  Simply forwarding the MAX_VCPU_PER_TD to
+	 * userspace would result in an unpredictable ABI.
+	 */
+	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
+
 	/* Place holder for TDX specific logic. */
 	return __tdx_td_init(kvm);
 }
@@ -702,6 +715,7 @@ static int __init __do_tdx_bringup(void)
 
 static int __init __tdx_bringup(void)
 {
+	const struct tdx_sys_info_td_conf *td_conf;
 	int r;
 
 	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
@@ -741,6 +755,43 @@ static int __init __tdx_bringup(void)
 	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
 		goto get_sysinfo_err;
 
+	/*
+	 * TDX has its own limit of maximum vCPUs it can support for all
+	 * TDX guests in addition to KVM_MAX_VCPUS.  Userspace needs to
+	 * query TDX guest's maximum vCPUs by checking KVM_CAP_MAX_VCPU
+	 * extension on per-VM basis.
+	 *
+	 * TDX module reports such limit via the MAX_VCPU_PER_TD global
+	 * metadata.  Different modules may report different values.
+	 * Some old module may also not support this metadata (in which
+	 * case this limit is U16_MAX).
+	 *
+	 * In practice, the reported value reflects the maximum logical
+	 * CPUs that ALL the platforms that the module supports can
+	 * possibly have.
+	 *
+	 * Simply forwarding the MAX_VCPU_PER_TD to userspace could
+	 * result in an unpredictable ABI.  KVM instead always advertise
+	 * the number of logical CPUs the platform has as the maximum
+	 * vCPUs for TDX guests.
+	 *
+	 * Make sure MAX_VCPU_PER_TD reported by TDX module is not
+	 * smaller than the number of logical CPUs, otherwise KVM will
+	 * report an unsupported value to userspace.
+	 *
+	 * Note, a platform with TDX enabled in the BIOS cannot support
+	 * physical CPU hotplug, and TDX requires the BIOS has marked
+	 * all logical CPUs in MADT table as enabled.  Just use
+	 * num_present_cpus() for the number of logical CPUs.
+	 */
+	td_conf = &tdx_sysinfo->td_conf;
+	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
+		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
+				td_conf->max_vcpus_per_td, num_present_cpus());
+		r = -EINVAL;
+		goto get_sysinfo_err;
+	}
+
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
 	 * successfully.  TDX CPU hotplug depends on this.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8a103c29dcd0..95a10c7bc507 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4744,6 +4744,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
+		if (kvm)
+			r = kvm->max_vcpus;
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_MAX_VCPU_IDS;
-- 
2.47.0


