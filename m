Return-Path: <kvm+bounces-38745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3A0A3E221
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 439E23B05C3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B45A21CA12;
	Thu, 20 Feb 2025 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ij55wMvP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6835621ADDE
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071204; cv=none; b=oQvYWj/C9q+gAoW+cBjlCe/7wVB0GlCL2EEMCaypei/uFEjvqn7a8qNyVR8TWdYkrfoguHPjk1SWpbF7rPWKeHCNmyOB+z7fC909Q4P4CxHJ3PfuEByhqI8XvAknpblQO49an0gw3UsKcL8W+Q02TG53F2cca/TpPggiQXys+0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071204; c=relaxed/simple;
	bh=2Epm2gwPvyZu8b7MPaPN5NQLedSf+1+e/lOPLDginZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CeWfZBld7ZLEfuDQFUWvDD0RUXSQcr2IQ9LtHa4IIwuvSyMWlbbokMhIinKNuv5QQwyI/uaKFG5AoKrywvxReKBV1db6jQVoSIAwtWMMGeDrIxz9bFGQ78RXxgB5lIxibTkPh2I0W5Zo43nH2/+GyYieXGQRioeFQ8EbUOn5yHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ij55wMvP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3H4yjBWm2WqFP+poiFsbJvKniDl6yxMv7y+gQJGXGlI=;
	b=Ij55wMvPAT0VhfhOxeOy2rFOCqKUD87fCkT8g9UHWdd3QaeFIKrkT0BOhbFVNTW91dRx0Y
	U1/RaG+XWJ3dz12SHJFtXlcY79deFLP3Ya2C2fBPGi4H8m0TVwgiXX6cFjcR67z7bXQOZl
	5e7xBRoU2SqiEBRPnbBBbd9mmbEg1EM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-Al_Nnx4xPoKJW3a0go5eRw-1; Thu,
 20 Feb 2025 12:06:40 -0500
X-MC-Unique: Al_Nnx4xPoKJW3a0go5eRw-1
X-Mimecast-MFC-AGG-ID: Al_Nnx4xPoKJW3a0go5eRw_1740071198
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FF011800876;
	Thu, 20 Feb 2025 17:06:38 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9565519412A3;
	Thu, 20 Feb 2025 17:06:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 21/30] KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS extension check
Date: Thu, 20 Feb 2025 12:05:55 -0500
Message-ID: <20250220170604.2279312-22-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c |  1 +
 arch/x86/kvm/vmx/tdx.c  | 51 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c      |  2 ++
 3 files changed, 54 insertions(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index b655a5051c13..83f0d4d34a4a 100644
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
index c270e2109d7d..60c26600bf18 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -390,6 +390,19 @@ int tdx_vm_init(struct kvm *kvm)
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
@@ -707,6 +720,7 @@ static bool __init kvm_can_support_tdx(void)
 
 static int __init __tdx_bringup(void)
 {
+	const struct tdx_sys_info_td_conf *td_conf;
 	int r;
 
 	/*
@@ -739,6 +753,43 @@ static int __init __tdx_bringup(void)
 	if (!(tdx_sysinfo->features.tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM))
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
index e0b9b845df58..007195d9ab0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4708,6 +4708,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
+		if (kvm)
+			r = kvm->max_vcpus;
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_MAX_VCPU_IDS;
-- 
2.43.5



