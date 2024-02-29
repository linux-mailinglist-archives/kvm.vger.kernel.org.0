Return-Path: <kvm+bounces-10389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF6286C102
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EB1EB26B48
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2CE446B4;
	Thu, 29 Feb 2024 06:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJqhRWkc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE214594E
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188872; cv=none; b=MPs87qy4KGZ5vN7nZaDXpE/gbP26ckr8aIvoaPWXT03dU2ckllws8VFFgBEBywpcqaofRvm0O0pyT6PUre21LAtdjQ+9Vyx1Yfp/S/vfZEBx9Ci/+cHQs27KoKvFSSOVPhbU+6/qWaYeM9tS7YNJ/g3wAxqmybvyAjGM0X+TZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188872; c=relaxed/simple;
	bh=TV0zJoSEEfrrhfHkCFBrQ5M3B95rGljdOpW38yTtSf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fBE6AhhHZrrJLKF/NysLTNWpoM8uelSRN/cSD0U9WYz8Sbn6nIQXHOBck3LmZGuU8W28RpnI6/Dj8rcxgA+dBCKUvRi+f6QY/06l9Tk+hK9o/zvBrwOo/KBr3ITzyZ3W48XbBg0qsrVgw6G9jRbN9XJEA7+uwkoF6R1sKvQ2fw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJqhRWkc; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188871; x=1740724871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TV0zJoSEEfrrhfHkCFBrQ5M3B95rGljdOpW38yTtSf8=;
  b=oJqhRWkcYGLrTytVWT9Lp8faDpLCEb8rY0HylIJqkCMRgUwkpjTVcXlh
   s41QoCJN09GZMT8FQABViYi1wo4prsZzSFkgPhZBsT7qUSSD2IAREXkAS
   1kLsMzY+Sq/PXjULmW+jkC0VCDBTCMHAzPf3fSFm2KJ9TqwV9N2Ts2C12
   Mc7vQJOAljjO0cY6rbfAikOIe9I53c/6MfaOFD5Y26ZNxWRxHunWqnH1W
   rmOwVv4Sx4gWhTR0wwCP3hzFiLyz0ygfa+0L7M1Uiy9CDKFXUYtrpqdBA
   eGT2JaVWrPFv6UYpVy+tTi4BKjrEyRyPQjLkgsJ/E4P9PUixlYm9VKjDj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802853"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802853"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:41:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075614"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:41:05 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 33/65] kvm/tdx: Don't complain when converting vMMIO region to shared
Date: Thu, 29 Feb 2024 01:36:54 -0500
Message-Id: <20240229063726.610065-34-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
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
index c9df41efa484..d533e2611ad8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2985,9 +2985,22 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
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


