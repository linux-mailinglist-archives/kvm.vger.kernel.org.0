Return-Path: <kvm+bounces-10374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D12A486C0EC
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 724E6B2641A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE72446AD;
	Thu, 29 Feb 2024 06:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Up2Sg6Qj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D6F446AF
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188773; cv=none; b=U7jeXryVQJsUTMrWpL0c1VNvJri244tP2rUufKbFOlA04YzRaMqOq90QjdWt8c9Y8Zvp/q4xv+cSzsfN/snf+DpIb1X6yV4ylp6TYvkf7PqtALpiwftmW8GeXfATU/gtEc0j26pFEe8mHAGN5CJGQFjgy5DOQ91Cws/Hj/qNvH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188773; c=relaxed/simple;
	bh=xcjX8S6Or4RgbxyPFn2A1+rsnCrOWOXt1edq7jIgm+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JZkons/1sYkHbilYJkFBDI2tj9B97jD3eYeLfWQ7DeJ0l24lrrWo8KJGlTgYYfNXNM4xYdd/RDraAqB+nOe/rc4fkTupsTJC9GOOBFNUfwqajRl2zmluyGMvHPPKT+BkxlavFp57TaZ14d481VpyjhwK7BfQvFseHEchM6FxU5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Up2Sg6Qj; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188772; x=1740724772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xcjX8S6Or4RgbxyPFn2A1+rsnCrOWOXt1edq7jIgm+g=;
  b=Up2Sg6QjCrWLyiGWLBmhMqY1S7fkRHo3v5gHpgLs7+UW9ENhKD2kxrjz
   VkPn0/0naJ1Qzz/vaoxh36wpG4vrr4lwmCZ2GXDJVctuvOy4zBT9O50e/
   hsIPSqRri8wx0H5/Aho9z6hNt4LLs8OXtZY8G1ahmSN9Jrl1+p9sPLgFV
   szsfHh823L9ASAUCqG5zdPS/EW1LcJyQn2EbwYqKEVnAP7qc6Dz4Oifq6
   1g/LrCMN4sDhTQcLPQkZ57PLggKl5x8ivdm3kkbg/To2277Jo/NKJS1yO
   hhWkurzaakt7kZjhvRuAWO8NhI+4MTg8MVI9kYAvMiGicRp1pgA7knNzs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802643"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802643"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:39:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075212"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:39:26 -0800
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
Subject: [PATCH v5 18/65] i386/tdx: Make Intel-PT unsupported for TD guest
Date: Thu, 29 Feb 2024 01:36:39 -0500
Message-Id: <20240229063726.610065-19-xiaoyao.li@intel.com>
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

Due to the fact that Intel-PT virtualization support has been broken in
QEMU since Sapphire Rapids generation[1], below warning is triggered when
luanching TD guest:

  warning: host doesn't support requested feature: CPUID.07H:EBX.intel-pt [bit 25]

Before Intel-pt is fixed in QEMU, just make Intel-PT unsupported for TD
guest, to avoid the confusing warning.

[1] https://lore.kernel.org/qemu-devel/20230531084311.3807277-1-xiaoyao.li@intel.com/

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
 - newly added patch;
---
 target/i386/kvm/tdx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 85d96140b450..239170142e4f 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -292,6 +292,11 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
     if (function == 1 && reg == R_ECX && !enable_cpu_pm) {
         *ret &= ~CPUID_EXT_MONITOR;
     }
+
+    /* QEMU Intel-pt support is broken, don't advertise Intel-PT */
+    if (function == 7 && reg == R_EBX) {
+        *ret &= ~CPUID_7_0_EBX_INTEL_PT;
+    }
 }
 
 enum tdx_ioctl_level{
-- 
2.34.1


