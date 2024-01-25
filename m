Return-Path: <kvm+bounces-6923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF3383B7E8
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9526283365
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3AB12B8D;
	Thu, 25 Jan 2024 03:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BJBwheXN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BB0125D9
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153313; cv=none; b=L7tcrDWO8iBDclILoyONE0RQMH8Ofr7mc4shFZY+c38fjUb4GkSB2ARKUjLO7ZWIF46SHv6g2o4KiVr1Vjw3uSUDCfuuvxONiANz1Qk2FsReXrxLtzCJLg4GaSzu26FHkor3A/Yi0c4XPXq5B0P3NxAyGuF4cZLHdQHYhjky81s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153313; c=relaxed/simple;
	bh=lmEwcAjBKpd3d6dQx1hVOkIXooa5afvFKHoaSpmVz3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pqUxSvMj2XYiRdqrWUaJCZ8HVBQ2Pv954DIW/UiXf2jazIMbxuGvaIJ4iF64xHJDebXIV0I8XSxy5rplENgibF1f/ePS72zY5PiPH2bEMETSzwNMEyxl7o/4ilIfulvZJcgzb2vNAo1y4jfw605RVZSPHGl4RKjO34bIiNQGP9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BJBwheXN; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153311; x=1737689311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lmEwcAjBKpd3d6dQx1hVOkIXooa5afvFKHoaSpmVz3w=;
  b=BJBwheXNZXp1VmWC6gA+WfQYubNwKaOvJ+gVOXDr0QMKHEzGowQL+RiB
   /HEgKNsumh/fgKJ308qgpnf2VuJZ9Hw/bSCLadTt2c3l/vKIQmsK5tcuk
   G0vs1eeFsa7/jF9TX90dqHod9k9AILPP4bAJhj9/nH1EWv7E3M7h4aFWF
   pF3kTggP2GHkPYS6QKfyduHSoztcK7WgT+Q8A5ZWePsifTK6TT4CRPE9v
   Dh9TFw1ZUdEgGWIwbtS5GBzBN/qN+p3iWPwrJoKNdqQ/8kzbcOOS0HgzB
   Nb91GiMaPwT4GFGHZagKiaoRUr11ZYPDAWR5BpsBmz8crWw9qBvOVnMu/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428518"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428518"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:25:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085340"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:25:17 -0800
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
Subject: [PATCH v4 19/66] i386/tdx: Update tdx_cpuid_lookup[].tdx_fixed0/1 by tdx_caps.cpuid_config[]
Date: Wed, 24 Jan 2024 22:22:41 -0500
Message-Id: <20240125032328.2522472-20-xiaoyao.li@intel.com>
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

tdx_cpuid_lookup[].tdx_fixed0/1 is QEMU maintained data which reflects
TDX restrictions regrading what bits are fixed by TDX module.

It's retrieved from TDX spec and static. However, TDX may evolve and
change some fixed fields to configurable in the future. Update
tdx_cpuid.lookup[].tdx_fixed0/1 fields by removing the bits that
reported from TDX module as configurable. This can adapt with the
updated TDX (module) automatically.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 2703e97f991d..5dfea0378f26 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -377,6 +377,38 @@ static int get_tdx_capabilities(Error **errp)
     return 0;
 }
 
+static void update_tdx_cpuid_lookup_by_tdx_caps(void)
+{
+    KvmTdxCpuidLookup *entry;
+    FeatureWordInfo *fi;
+    uint32_t config;
+    FeatureWord w;
+
+    for (w = 0; w < FEATURE_WORDS; w++) {
+        fi = &feature_word_info[w];
+        entry = &tdx_cpuid_lookup[w];
+
+        if (fi->type != CPUID_FEATURE_WORD) {
+            continue;
+        }
+
+        config = tdx_cap_cpuid_config(fi->cpuid.eax,
+                                      fi->cpuid.needs_ecx ? fi->cpuid.ecx : ~0u,
+                                      fi->cpuid.reg);
+
+        if (!config) {
+            continue;
+        }
+
+        /*
+         * Remove the configurable bits from tdx_fixed0/1 in case QEMU
+         * maintained fixed0/1 values is outdated to TDX module.
+         */
+        entry->tdx_fixed0 &= ~config;
+        entry->tdx_fixed1 &= ~config;
+    }
+}
+
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(OBJECT(ms->cgs));
@@ -391,6 +423,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         }
     }
 
+    update_tdx_cpuid_lookup_by_tdx_caps();
+
     tdx_guest = tdx;
     return 0;
 }
-- 
2.34.1


