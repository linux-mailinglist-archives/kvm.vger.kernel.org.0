Return-Path: <kvm+bounces-12070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8719687F5F5
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 04:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02EAEB21BCA
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 03:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C189F7BAF0;
	Tue, 19 Mar 2024 03:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlDHceFk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D45A4CD
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 03:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710817933; cv=none; b=srxnGirF5ntqmX77PoYZpLtCrWRdgx/cxBVN/NGcDv7qK+QCIzjB8DcuSZ1KgmuwLgP4+E5bOMtNqacNmO6nK8eQCtrBW0DF7rUqqYf+D8loWwXwQl8Qf/3gYFQdejVt5T19CZsfKR1sLbZbFGVzGsrZ3l9hbK53wN2TkBpLxE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710817933; c=relaxed/simple;
	bh=x+eSJN1gAxALjKFsAG60BqaCYY/A7SwtyGzqCvwpu5E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=eoQPA0Ey4Gr5LYVHMbrFDl2iEt/B6A4eeT9Wrm31OJS6xrDru6MFsziy9pOJoIl+54OMezCu80n6Bi7mqRhopza/3FDldwdsTGDBWDklBCgRI+yPru+Y630SfeSOhuBo9nB4UQhr/qKEBEaC0sxWhd/bo63SXBvTALEPTIRdgtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlDHceFk; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710817932; x=1742353932;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x+eSJN1gAxALjKFsAG60BqaCYY/A7SwtyGzqCvwpu5E=;
  b=UlDHceFk6V62X81s/1mszPlcqUJbKx3ZFCXZVdMQSRP0rRlL9JPVu7KW
   oQv2XwpEOr8uDEeq8r2/uNVOk159qQb1CY/RJ1TNJovM5FlCiIFz0gt+U
   gbXmUoEaz9/pKeTyhmsTa9FlH+wWkQpVElQU0CISMFZ6jAdmIilrItP2E
   l2ztKIiMvtNfmv+DWQjc/VPf5I5XCykSRVAkdNbAxVw1YO7RTIe7yioeh
   hYv5tRExSa2qEVZBG95MxJx7BVpojaNnrjc54Xe1CQlCy1IxltY5CBjww
   OBOh46m1+9sUMm5POHKY1s5QGY/3qD78PEv9UjFhXfYNw0EcGX1S4lHQ+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5845799"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="5845799"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 20:12:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="18248781"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmviesa003.fm.intel.com with ESMTP; 18 Mar 2024 20:12:10 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH] KVM: x86: Fix the condition of #PF interception caused by MKTME
Date: Tue, 19 Mar 2024 11:11:11 +0800
Message-Id: <20240319031111.495006-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Intel MKTME repurposes several high bits of physical address as 'keyID',
so boot_cpu_data.x86_phys_bits doesn't hold physical address bits reported
by CPUID anymore.

If guest.MAXPHYADDR < host.MAXPHYADDR, the bit field of ‘keyID’ belongs
to reserved bits in guest’s view, so intercepting #PF to fix error code
is necessary, just replace boot_cpu_data.x86_phys_bits with
kvm_get_shadow_phys_bits() to fix.

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 65786dbe7d60..79b1757df74a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -15,6 +15,7 @@
 #include "vmx_ops.h"
 #include "../cpuid.h"
 #include "run_flags.h"
+#include "../mmu.h"
 
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
@@ -719,7 +720,8 @@ static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
 	if (!enable_ept)
 		return true;
 
-	return allow_smaller_maxphyaddr && cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
+	return allow_smaller_maxphyaddr &&
+		cpuid_maxphyaddr(vcpu) < kvm_get_shadow_phys_bits();
 }
 
 static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)

base-commit: b3603fcb79b1036acae10602bffc4855a4b9af80
-- 
2.34.1


