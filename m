Return-Path: <kvm+bounces-6937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7240383B80C
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A830282E26
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB1A199A0;
	Thu, 25 Jan 2024 03:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LDiZI49b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E011F18EC3
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153394; cv=none; b=tq2mHxHGf3f7QE0eWFuBhH25FhkC+knrjiCI1bQh4v/j4tWtqhOw9Y7/Jm1shMlI4YNhrtHDztt8WtVcyy2ItY1v3RrweyqOdVEMuDXX6e+HcLqVLHrlXkVDRs/EAiu1qXbT4noqf+MQq3kTxHnBmdavxW62bjJJVioe8tBYY9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153394; c=relaxed/simple;
	bh=uTljjXS9RD18pQISuHrBizkOSd90HeW/IsWeJlzYk+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kBDf0pF34WBLg9yICldhybRbwf4RN+7Hp3NkBPx8rL4rKFEEU8P6wS7+KqluSAqlRayNTqy3+vKC4sDStVFoMrJaKmTC1Fb0iNrVCm5z+t5VeKi6tHf6H4Q9m3EQ/LpLGTqBSAwe6G7Gz4o+Q7y8BMicAPEfLfLWhXiRZLTbEng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LDiZI49b; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153393; x=1737689393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uTljjXS9RD18pQISuHrBizkOSd90HeW/IsWeJlzYk+4=;
  b=LDiZI49bqnzMdbZESNUbYGDM8nYfORoPQgapUBYIRYEEee/dYzrqdiGw
   2LtgnH2xGUT13q7VFIdtl5NDn5AVZzYCyVC5hSOGsD5lJbGpy2PYfDbiy
   GJfHkG4/bhq8T821XYgoXajibo4l4RoYJViReJIi3eI/Dc5lKpkE3ann1
   n0q/45xrYjyql9vBwp8Nfk3xfw0TnhZ3z3SZhUUAtmpFH2r1tVETGCdVS
   SL4aV8dsMJ86fhm6vsrMrlvWAphXux7rLpM6U5C62CDeJBgqwe3qTQyS1
   WAlLJT6op06EF/OrKuXgpV/BcE2CTChCQCvA7CNmK8eOqt/4WhDOHvVKy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429274"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429274"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:26:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085819"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:26:45 -0800
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
Subject: [PATCH v4 35/66] kvm/tdx: Ignore memory conversion to shared of unassigned region
Date: Wed, 24 Jan 2024 22:22:57 -0500
Message-Id: <20240125032328.2522472-36-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires vMMIO region to be shared.  For KVM, MMIO region is the region
which kvm memslot isn't assigned to (except in-kernel emulation).
qemu has the memory region for vMMIO at each device level.

While OVMF issues MapGPA(to-shared) conservatively on 32bit PCI MMIO
region, qemu doesn't find corresponding vMMIO region because it's before
PCI device allocation and memory_region_find() finds the device region, not
PCI bus region.  It's safe to ignore MapGPA(to-shared) because when guest
accesses those region they use GPA with shared bit set for vMMIO.  Ignore
memory conversion request of non-assigned region to shared and return
success.  Otherwise OVMF is confused and panics there.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e26e9121b30d..eb8b3925dbe1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2943,6 +2943,18 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     section = memory_region_find(get_system_memory(), start, size);
     mr = section.mr;
     if (!mr) {
+        /*
+         * Ignore converting non-assigned region to shared.
+         *
+         * TDX requires vMMIO region to be shared to inject #VE to guest.
+         * OVMF issues conservatively MapGPA(shared) on 32bit PCI MMIO region,
+         * and vIO-APIC 0xFEC00000 4K page.
+         * OVMF assigns 32bit PCI MMIO region to
+         * [top of low memory: typically 2GB=0xC000000,  0xFC00000)
+         */
+        if (!to_private) {
+            return 0;
+        }
         return -1;
     }
 
-- 
2.34.1


