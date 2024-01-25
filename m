Return-Path: <kvm+bounces-6936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CD883B80B
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:32:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A082820B2
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FE018EAF;
	Thu, 25 Jan 2024 03:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WXJ5ZnVl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56518E00
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153389; cv=none; b=dgNfzriXsZlGcIdKywE6zrsg1wRqLkDYsuitcT6sgUAKtT4GkSVdHUrnG8mtDb4PicxQP4yG7a2xkVAbqMjl3GIzag8wtzG40Pxjjl3A8QtfW3DWP9GVCwHibPg4X95muTRND2g3/PlNZuE2e3RA/HfzwoeW1Dxckbg7dCcUdho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153389; c=relaxed/simple;
	bh=iNM9pCGVMbyxVuz0wFBBI7zYmOMZam6gMTxzOMMdo6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yc+Af1hvT6qQ/A4FobwyaZz3OGdqGFHrTJaaZPBSdCtil5K/NsP30ODwmj1ZVboxWHte37H2g19cSzdfbofYiG2OASQFM7H0ucfmaAJk4Ms2S9EAPWoVwuCX1I/oAAREoR6FbjAMryVGcvazM3GOWHtMGBwZbnAHS82csjiaOTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WXJ5ZnVl; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153388; x=1737689388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iNM9pCGVMbyxVuz0wFBBI7zYmOMZam6gMTxzOMMdo6k=;
  b=WXJ5ZnVln86d0ZfS/J/NehrtZBeV68sxK5q7rhQOMlesZqujSWhyZyJ8
   NIon3J+JkD/6nkkXYl3Qljwgt2dPzdfahro65ljwlB0/UwgUrl9IAzzvO
   Y8jy3FFCRYUiAJi0Ac2ULcNlnQAQmu1WmgVifRpxoIY7muLCfsO0ep1vU
   k/gY/jXXN0PDPWQh2VrMKkQRqQA5ZVPzSub/sMDDt0X6IK2QVBZvQLxg4
   +gyIAcr9nXucRZaGNxNMm5qBzu9Hrx5/ShfeFSrLYlkVNsfUD7BaA4bq/
   7y+s3zZUdJIcnMDVD7aYuVagaa/CPqyZB85kHzm44dGQNsOJDaR0qII9s
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429216"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429216"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:26:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085800"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:26:39 -0800
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
Subject: [PATCH v4 34/66] kvm/tdx: Don't complain when converting vMMIO region to shared
Date: Wed, 24 Jan 2024 22:22:56 -0500
Message-Id: <20240125032328.2522472-35-xiaoyao.li@intel.com>
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

Because vMMIO region needs to be shared region, guest TD may explicitly
convert such region from private to shared.  Don't complain such
conversion.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 094ce7695e16..e26e9121b30d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2975,9 +2975,22 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
             ret = ram_block_discard_guest_memfd_range(rb, offset, size);
         }
     } else {
-        error_report("Convert non guest_memfd backed memory region "
-                    "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
-                    start, size, to_private ? "private" : "shared");
+        /*
+         * Because vMMIO region must be shared, guest TD may convert vMMIO
+         * region to shared explicitly.  Don't complain such case.  See
+         * memory_region_type() for checking if the region is MMIO region.
+         */
+        if (!to_private &&
+            !memory_region_is_ram(mr) &&
+            !memory_region_is_ram_device(mr) &&
+            !memory_region_is_rom(mr) &&
+            !memory_region_is_romd(mr)) {
+		    ret = 0;
+        } else {
+            error_report("Convert non guest_memfd backed memory region "
+                        "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
+                        start, size, to_private ? "private" : "shared");
+        }
     }
 
     memory_region_unref(section.mr);
-- 
2.34.1


