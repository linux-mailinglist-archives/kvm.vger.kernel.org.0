Return-Path: <kvm+bounces-1765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E58367EBDB8
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74FB4B20DB0
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9175B441A;
	Wed, 15 Nov 2023 07:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MidDKpFX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A9A525F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:20:12 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BEFE9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032811; x=1731568811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v8TW188sEZGLI1koy2qyEbj6fW8WJb8DnDVD4pa2nWQ=;
  b=MidDKpFXgadu/TBHxxU0kG0AHxKVpmdNiFboBm/ivWjlHlVVZlMDYJC/
   umxSvVowUjvAVyVSDEbuePSNT7bSo9EQwZW5kMwJJphEiQcCRKRTCz0xp
   bqIn/WQoEzoWXpIeEKLPqlE2RjyzgCTtnbsmyo0onRCWpRoi8KIdQnwPF
   hU2HprTEY8t1Ur4NJFFdpPZu0e6fbh1qivACZgO2qfwkg7ksJYRo27UB2
   ZGijy3qolelC0IkmR6JiYZObi5FZ0mGZRHXMh+yqt6lNrD17MQ/NVMj7Y
   Mg4y4j4ykf6dExS7GMZmeJ9tDAmtQM7rx3I/nBCmu4E+q7VWiQWn7d6ia
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623089"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623089"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:20:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714799565"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714799565"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:20:00 -0800
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
Subject: [PATCH v3 37/70] kvm/tdx: Ignore memory conversion to shared of unassigned region
Date: Wed, 15 Nov 2023 02:14:46 -0500
Message-Id: <20231115071519.2864957-38-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
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
index 5e862db4af41..89e7183a2738 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2942,6 +2942,18 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
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
+            ret = 0;
+        }
         return ret;
     }
 
-- 
2.34.1


