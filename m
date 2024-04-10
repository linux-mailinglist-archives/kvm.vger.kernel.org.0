Return-Path: <kvm+bounces-14162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C42228A02E3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F342C1C223DD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540CE19DF4E;
	Wed, 10 Apr 2024 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lkGMhVRD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1F2184139;
	Wed, 10 Apr 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786880; cv=none; b=n9LJ3Izg3PucseSeXknQTNBVnbZt9S5BW/3yqLMgSn6JNG+Lq+9hRt58FlLuZaDp11+lpCeG9XcwGxQ0RYUHUHfB70cO849DQgH8GYyfH/4w1buJTyRE9Y08ws+vjxkqQ3spj6uXdEACWmVxJjqZ3yvjWY5CReIcvocR9KJcrmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786880; c=relaxed/simple;
	bh=KzbwiK5L28jvxhKDLMs0XV3x+kKU7fDkmDzZGqeBXiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gekK0Skyd2AundcdrhwDzdXrSVHIaNztYPKrON9yeRHg4WokcMlsqQuleOQoB/qnxDMatPcgQD0YkFaIDX0KQO/MkqBrs9suxxHjxPTdC5Ee9PWUXMYg/c5yh+p+oGL2TNj1BkGos3M5KLEhhYIbtor7AknBHGRNv6a/5X6S470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lkGMhVRD; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786878; x=1744322878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KzbwiK5L28jvxhKDLMs0XV3x+kKU7fDkmDzZGqeBXiQ=;
  b=lkGMhVRDwAX0QIYlwg2ynAs+clrqQu4M6KXFGp9aZSerMfZuM8qjP1FU
   EoKUJLpChAwL0gH1clWRkStd1l2uNI9+qRrbF5gmgiUXQmLq805TpzbNp
   4Z6qNOYOvHpa7+t9RlofHi60RJxXsFio1l6t0IwSncm5ADTxQH7KOw+ux
   gxntHbmoQjFPQTaJr6D5PRkg9sfmqxrUVWyKgvZDPNVhLBlZIQairCNIn
   eGqI3lqLxoSz7dM2w4zZfkbECscmxfn08BuVrvffm7hjBHLcdlNHdoTMV
   H0ZoCtQu74jA0vDF26pwU90n7PIpRqlGcbRU5Y6NPVodbBczcqQruze5d
   Q==;
X-CSE-ConnectionGUID: lP3LAkFOSAKbMbzBepZ98A==
X-CSE-MsgGUID: y66Y/KT8Sjyf/qMS49dQBA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041136"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041136"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:56 -0700
X-CSE-ConnectionGUID: eiG0t2F9QHqTBdWvNxKo/g==
X-CSE-MsgGUID: HVYTcesfSvuhlROSA5i/1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476314"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:56 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 06/10] KVM: x86: Implement kvm_arch_vcpu_map_memory()
Date: Wed, 10 Apr 2024 15:07:32 -0700
Message-ID: <7138a3bc00ea8d3cbe0e59df15f8c22027005b59.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire KVM_MAP_MEMORY ioctl to kvm_mmu_map_tdp_page() to populate guest
memory.  When KVM_CREATE_VCPU creates vCPU, it initializes the x86
KVM MMU part by kvm_mmu_create() and kvm_init_mmu().  vCPU is ready to
invoke the KVM page fault handler.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Catch up the change of struct kvm_memory_mapping. (Sean)
- Removed mapping level check. Push it down into vendor code. (David, Sean)
- Rename goal_level to level. (Sean)
- Drop kvm_arch_pre_vcpu_map_memory(), directly call kvm_mmu_reload().
  (David, Sean)
- Fixed the update of mapping.
---
 arch/x86/kvm/x86.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d2619d3eee4..2c765de3531e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4713,6 +4713,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_MAP_MEMORY:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -5867,6 +5868,35 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+			     struct kvm_memory_mapping *mapping)
+{
+	u64 end, error_code = 0;
+	u8 level = PG_LEVEL_4K;
+	int r;
+
+	/*
+	 * Shadow paging uses GVA for kvm page fault.  The first implementation
+	 * supports GPA only to avoid confusion.
+	 */
+	if (!tdp_enabled)
+		return -EOPNOTSUPP;
+
+	/* reload is optimized for repeated call. */
+	kvm_mmu_reload(vcpu);
+
+	r = kvm_tdp_map_page(vcpu, mapping->base_address, error_code, &level);
+	if (r)
+		return r;
+
+	/* mapping->base_address is not necessarily aligned to level-hugepage. */
+	end = (mapping->base_address & KVM_HPAGE_MASK(level)) +
+		KVM_HPAGE_SIZE(level);
+	mapping->size -= end - mapping->base_address;
+	mapping->base_address = end;
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-- 
2.43.2


