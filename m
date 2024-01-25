Return-Path: <kvm+bounces-6946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC59D83B822
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B84E1F217B6
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCAF10A3E;
	Thu, 25 Jan 2024 03:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FkXyxkU4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D90710A11
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153421; cv=none; b=o/vowjQ3RYzcHdT1XyXTm09HD0QxqIkmKGIt2cH4HBVOHxZ7MccPCzWk0Khd1NJOj9e+nCGZdJjPoKQsXY4Qhl272upzXOxRYSoRGgOERX/+JQCjmJMsTfvyBG5hYSq7QyBFXGx3D5OC6yr87UqN1UbGaNF1j1e8fpr+/YcDgsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153421; c=relaxed/simple;
	bh=2NuxnG8VbXHFmMOZ0L26zFg3CmyzEDrgVzHzIE9y7nE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c+JNw0tvKDTM+lAiCzFtbEHMkQAiENddY5b2wZUeaUtWIF3vvynR+ZfIITIjwhYRddsS76zUd9X+jkKobADGwwMDOcZCEKhOKiHynh7AJqqGeng2qz2hxtp+ri7wZObhBi8BsCNkPfgeq+sayPqYTNG1VpT08o8AfvPtohI3K/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FkXyxkU4; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153420; x=1737689420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2NuxnG8VbXHFmMOZ0L26zFg3CmyzEDrgVzHzIE9y7nE=;
  b=FkXyxkU4q9Ap2N1uywkLPnUxAM4hSBecNkiVQHbvkS8Anp9Fo9u/GZYu
   byZm9UKdW4OMJTLsjr0o7dggGaD/kYtSNzya3WKbEUqljuCX89+H4/zmK
   +P/XtI8XLbvbc7hXO1jAx9PIWCamrDIEmE4SCfQRiQWzwVpN0UvF/0kVN
   Xexj/HQYZ1TwRsXp77tJoEmDIKYPQwftRBZLUmTFuwy7rZfBbIAtYaxHm
   k1OwLcXqcqy5TClSHx1iOssD7vRes5UzS9VTjBqT5iOq/e+rfTuFTKAXp
   75GcibSP9vVSqH2jqJT8fShRCYKSJ35MsCNzdWAnPhl6skqtOO2J4yuWY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429713"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429713"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086038"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:27:34 -0800
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
Subject: [PATCH v4 44/66] i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
Date: Wed, 24 Jan 2024 22:23:06 -0500
Message-Id: <20240125032328.2522472-45-xiaoyao.li@intel.com>
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

TDVF firmware (CODE and VARS) needs to be added/copied to TD's private
memory via KVM_TDX_INIT_MEM_REGION, as well as TD HOB and TEMP memory.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>

---
Changes in v1:
  - rename variable @metadata to @flags
---
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 7f84aa0e64a9..af4107514fc9 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -589,6 +589,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    int r;
 
     tdx_init_ram_entries();
 
@@ -614,6 +615,29 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
           sizeof(TdxRamEntry), &tdx_ram_entry_compare);
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_tdx_init_mem_region mem_region = {
+            .source_addr = (__u64)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size / 4096,
+        };
+
+        __u32 flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
+                      KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        r = tdx_vm_ioctl(KVM_TDX_INIT_MEM_REGION, flags, &mem_region);
+        if (r < 0) {
+             error_report("KVM_TDX_INIT_MEM_REGION failed %s", strerror(-r));
+             exit(1);
+        }
+
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
+            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
+            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+            entry->mem_ptr = NULL;
+        }
+    }
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1


