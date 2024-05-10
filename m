Return-Path: <kvm+bounces-17145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C358C1C4D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 04:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A55CEB213A7
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 02:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6056A13BAC6;
	Fri, 10 May 2024 02:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X6FcFFZu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD1D29CE1
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 02:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715306724; cv=none; b=cQnzkETxouGLorEMWEEvFN/dXrnTzESlOKQYGj/vSJ0Hu9it8ILjJq6G2dmBRd3AsMkjy8w+xwYHcP9oT2nMNGlggwcEyGmxbtOJZguIcmkCT8ZOmi6mz5t8V8eBBamshNKrGbQg/D+Famn3jVv0nrpCDJ94hcodK2f65yCzJAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715306724; c=relaxed/simple;
	bh=q+nz/MO+vpwFIWCzXrHy0Bc7VGa4ly0pm252oT43Ne4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UTFn9iub5AcTsDW06woLFDVFwp3wxQqBOLoaBNLJDZEt2SCOTcdRNH/T8sEEdAiPMXgL2REftJaedP0ORX4vs/KgWRaD69V37Zfke2W10p0r1CKjytD9hTtEBPhTMidJMQVpdxSOytBt73m2Qck+RdlwM0UQSiYyav66kyIvl4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X6FcFFZu; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715306723; x=1746842723;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q+nz/MO+vpwFIWCzXrHy0Bc7VGa4ly0pm252oT43Ne4=;
  b=X6FcFFZuHlN+R75Spq4XymRg+ZNKxfAmenIDviyHlaI51q3spEYp+LjP
   nAA1XhaAAUXMjFjx2VD8wJO1jAntGn854f2sD97HZEHFzv/EG/6EISy9H
   C9eWaQCwFmOVmQLwbRxN2wsxU4Kt49zNjK07taxr82Jb3r0DFbOcIWDpX
   As+917VHD3H4mpdii1ZjUtg3hxsnx+JhyNook3Sx7fOa8r+6Jg+rzPErP
   9TZx3ynnn7+/Ceo2h+F62sPz7POTt7X3R8SApDSnuMetR93OGtqhnFZfz
   M7s6QtQYyF46PcQ/f1MNP6nJ9MCxmzsI3qDXJY0iqPQhicPdoHIM/Esjz
   Q==;
X-CSE-ConnectionGUID: PHLghji/QMuMg84HRfGiZQ==
X-CSE-MsgGUID: MSpNfPxkTF6sKXEUrMEEZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="22664755"
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="22664755"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 19:05:22 -0700
X-CSE-ConnectionGUID: J2GUTQLsRXK9DSANW/p6MQ==
X-CSE-MsgGUID: VbOfeRNwQmCAYyNXYWB4iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="66901065"
Received: from unknown (HELO st-server.bj.intel.com) ([10.240.193.102])
  by orviesa001.jf.intel.com with ESMTP; 09 May 2024 19:05:20 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	yi1.lai@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH v2] KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits
Date: Fri, 10 May 2024 10:03:46 +0800
Message-Id: <20240510020346.12528-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
dirty_log_test...) add RAM regions close to max_gfn, so guest may access
GPA beyond its mappable range and cause infinite loop.

Adjust max_gfn in vm_compute_max_gfn() since x86 selftests already
overrides vm_compute_max_gfn() specifically to deal with goofy edge cases.

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65

Changelog:
v1 -> v2:
 - Only adjust vm->max_gfn in vm_compute_max_gfn()
 - Add Yi Lai's Tested-by

v1: https://lore.kernel.org/all/20240508064205.15301-1-tao1.su@linux.intel.com/
---
 tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 81ce37ec407d..ff99f66d81a0 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
 #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
 #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
+#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
 #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 74a4c736c9ae..aa9966ead543 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1293,10 +1293,16 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
-	unsigned long ht_gfn, max_gfn, max_pfn;
+	unsigned long ht_gfn, max_gfn, max_pfn, max_bits = 0;
 	uint8_t maxphyaddr;
 
-	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
+	if (kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR))
+		max_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
+
+	if (!max_bits)
+		max_bits = vm->pa_bits;
+
+	max_gfn = (1ULL << (max_bits - vm->page_shift)) - 1;
 
 	/* Avoid reserved HyperTransport region on AMD processors.  */
 	if (!host_cpu_is_amd)

base-commit: 448b3fe5a0eab5b625a7e15c67c7972169e47ff8
-- 
2.34.1


