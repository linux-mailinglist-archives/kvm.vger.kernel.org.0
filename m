Return-Path: <kvm+bounces-23917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE2994FA00
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B13361F25D1B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24CE1A2C12;
	Mon, 12 Aug 2024 22:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HQHXmcbL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1D31A08B5;
	Mon, 12 Aug 2024 22:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502930; cv=none; b=ARW4vBpu0dToPROzKS2wrAPDGUbYJxLuVyLgTuvBYdzYAoFRrbmrW+CamrzgNsG2410uWn2Oqs/7y/mLs0rIJpucGUsHEpr0j5XP025CvvcFV9V+dZuY6n3oxTEZh50iHHLITS2MHcpgOC4j2DtgXiMfyjoxU3IyQGRW8snU3Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502930; c=relaxed/simple;
	bh=0Gqv13mAvcWK2D1HLrVD5lk09yLAPvz02xaqOkAihRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iqFLxmRT4MV5yVuzH8lxVQSGfhfWwOlDyWNQbHipU0pJPADkUvIHvcx/cO/WTQVSGn9qr1DVZ3etU/MdMuwV/2+z84EI+Rj2dD/0EBba38Fcfjw9/cseqNVXcAVYLPGyDmM6R5XI55K+HJreH6LEvEuUa0q/ffvwmyCAv+suWAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HQHXmcbL; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502928; x=1755038928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Gqv13mAvcWK2D1HLrVD5lk09yLAPvz02xaqOkAihRU=;
  b=HQHXmcbLHy34Lvm0UDSbB70h4er3HPQAFIh7kcjTox5p+MYAA6uO9rQG
   hBpb4LBV+YCQ3PNQ2weaaKkMFSKhfFTEWwIjR6rnWCPCNLrjaUWaLngSh
   IjK7SHxW4OoG5+1BupMdr24XnGZs6o7E8fe47mDz5RtaTe8eldsevrHYb
   LkA1qP8CZLZtNoxLdwpzXr01m89qp6YWQ8sDPF4aYHAZiAsSsgjYPLX38
   O4yIDIwyCofkhqSvcuNF498Oe0WLc/1oKTZrepUG4NnieXzTmbc7UBIDv
   q4tDDELfiFPBkenRgoZ4FUmagzg8b2+dWElXOTspdst/AjZBCdQqs0HBw
   g==;
X-CSE-ConnectionGUID: kFxZ/bxCSDiX07fJeWd3dw==
X-CSE-MsgGUID: kcrw94rlTjSZRrPNHAz3EQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041498"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041498"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:40 -0700
X-CSE-ConnectionGUID: oRanxMFVRpmI3xbhM1l9gA==
X-CSE-MsgGUID: kVsaMHZ0SrOtFrvIh8rkTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008462"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:40 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH 24/25] KVM: x86: Filter directly configurable TDX CPUID bits
Date: Mon, 12 Aug 2024 15:48:19 -0700
Message-Id: <20240812224820.34826-25-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Future TDX modules may provide support for future HW features, but run with
KVM versions that lack support for them. In this case, userspace may try to
use features that KVM does not have support, and develop assumptions around
KVM's behavior. Then KVM would have to deal with not breaking such
userspace.

Simplify KVM's job by preventing userspace from configuring any unsupported
CPUID feature bits.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - New patch
---
 arch/x86/kvm/vmx/tdx.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c6bfeb0b3cc9..d45b4f7b69ba 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1086,8 +1086,9 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	return ret;
 }
 
-static int __maybe_unused tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
+static int tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
 {
+
 	int r;
 	static const u32 funcs[] = {
 		0, 0x80000000, KVM_CPUID_SIGNATURE,
@@ -1235,8 +1236,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 static int __init setup_kvm_tdx_caps(void)
 {
 	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	struct kvm_cpuid_entry2 *cpuid_e;
+	struct kvm_cpuid2 *supported_cpuid;
 	u64 kvm_supported;
-	int i;
+	int i, r = -EIO;
 
 	kvm_tdx_caps = kzalloc(sizeof(*kvm_tdx_caps) +
 			       sizeof(struct kvm_tdx_cpuid_config) * td_conf->num_cpuid_config,
@@ -1263,6 +1266,10 @@ static int __init setup_kvm_tdx_caps(void)
 
 	kvm_tdx_caps->supported_xfam = kvm_supported & td_conf->xfam_fixed0;
 
+	r = tdx_get_kvm_supported_cpuid(&supported_cpuid);
+	if (r)
+		goto err;
+
 	kvm_tdx_caps->num_cpuid_config = td_conf->num_cpuid_config;
 	for (i = 0; i < td_conf->num_cpuid_config; i++) {
 		struct kvm_tdx_cpuid_config source = {
@@ -1283,12 +1290,24 @@ static int __init setup_kvm_tdx_caps(void)
 		/* Work around missing support on old TDX modules */
 		if (dest->leaf == 0x80000008)
 			dest->eax |= 0x00ff0000;
+
+		cpuid_e = kvm_find_cpuid_entry2(supported_cpuid->entries, supported_cpuid->nent,
+						dest->leaf, dest->sub_leaf);
+		if (!cpuid_e) {
+			dest->eax = dest->ebx = dest->ecx = dest->edx = 0;
+		} else {
+			dest->eax &= cpuid_e->eax;
+			dest->ebx &= cpuid_e->ebx;
+			dest->ecx &= cpuid_e->ecx;
+			dest->edx &= cpuid_e->edx;
+		}
 	}
 
+	kfree(supported_cpuid);
 	return 0;
 err:
 	kfree(kvm_tdx_caps);
-	return -EIO;
+	return r;
 }
 
 static void free_kvm_tdx_cap(void)
-- 
2.34.1


