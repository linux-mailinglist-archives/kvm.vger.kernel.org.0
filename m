Return-Path: <kvm+bounces-6906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F3D83B7CC
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12D771C22DD2
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28440CA7C;
	Thu, 25 Jan 2024 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aqDx7CRb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC10A7489
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153288; cv=none; b=rlShiL+Pt6yVkjseb0xVOR5FpwluGu7M6s3y3JhVt4B6ItqocsyQ0Nj2wGmH5eecCErUjgVyF3NXQdLPk78q1jAxAlnTnb7veyAs9MH+uhNkMuW4h48BBVfleJr1HdXEU36L6sN5vMsy7kHAAtkg7lDpiNV2dHjCjzuBV89Sjjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153288; c=relaxed/simple;
	bh=cd95ICCUREoT5IBvq1v8Fe11FptmQcfXH7kQX7VjfAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NNHohTHBj6PMbolJREYx72SnVxSosdZUWH2QKlYJN0bhWLlwwytfwL1zsvlprxGVRxjFGHEvjzb2UK+HgsxsiBUe3SIocWAVN1V9tkTViXmPS/C6DFWHCtQD4vIpyPvONkIMt88hz0FRGPFs2J3d/UEiXV4bobmTS/jstcq1dc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aqDx7CRb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153287; x=1737689287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cd95ICCUREoT5IBvq1v8Fe11FptmQcfXH7kQX7VjfAI=;
  b=aqDx7CRbqEh0ZPUEhIFVHaTZtgKKiQA+XxDng/ICs8Us9T0u+JnMRagq
   EAjSkfyuNdfWKu13VsFBhVbkL89wTPdOyxDH2WdHMwUSFOFVVNWqneNT9
   Wo6MLYbXAZHKRic4AM0/OkGmlL2kqXVqk6Sqw4u6DfYVmITiG3hom6YEh
   67llsgbUG97CHBOUdwaHWR4DKnxwzPcndhyuMGw6dFylH0VgOaadNCvSI
   cIICM2grDtkVF70YIY3fVvMt916NBPy5x+y05SEMlTLzsh1oxKPqjCaX8
   L3GPJtyTVYH0KbciYjXeKauL6dMmNZx3ZAv3Myys3ms1GyxUBw2AHPxf4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9427933"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9427933"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:23:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084481"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:23:54 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 04/66] trace/kvm: Split address space and slot id in trace_kvm_set_user_memory()
Date: Wed, 24 Jan 2024 22:22:26 -0500
Message-Id: <20240125032328.2522472-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The upper 16 bits of kvm_userspace_memory_region::slot are
address space id. Parse it separately in trace_kvm_set_user_memory().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c    | 5 +++--
 accel/kvm/trace-events | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f6b0f8d2db1c..56b41a4ea8dc 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -304,8 +304,9 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
     ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
     slot->old_flags = mem.flags;
 err:
-    trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
-                              mem.memory_size, mem.userspace_addr, ret);
+    trace_kvm_set_user_memory(mem.slot >> 16, (uint16_t)mem.slot, mem.flags,
+                              mem.guest_phys_addr, mem.memory_size,
+                              mem.userspace_addr, ret);
     if (ret < 0) {
         error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
                      " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index a25902597b1b..9f599abc172c 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -15,7 +15,7 @@ kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
 kvm_set_ioeventfd_mmio(int fd, uint64_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%" PRIx64 " val=0x%x assign: %d size: %d match: %d"
 kvm_set_ioeventfd_pio(int fd, uint16_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%x val=0x%x assign: %d size: %d match: %d"
-kvm_set_user_memory(uint32_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
+kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
 kvm_clear_dirty_log(uint32_t slot, uint64_t start, uint32_t size) "slot#%"PRId32" start 0x%"PRIx64" size 0x%"PRIx32
 kvm_resample_fd_notify(int gsi) "gsi %d"
 kvm_dirty_ring_full(int id) "vcpu %d"
-- 
2.34.1


