Return-Path: <kvm+bounces-43929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C680A9888B
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F7A6189A7B2
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8121A270574;
	Wed, 23 Apr 2025 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K7G/Vykz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280DF26FA46
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407610; cv=none; b=Tfyd+n2OdE0TfCHfZoiSXXqzpoBTyvezo97fYsMehAUBHfIxkEXbPXmvf4IjaJN4Wn/8gzp1poZiq6Jo/YAgWYjlhxl2/VI+BbYJzo/VfvWxTnW6L8I+LcQdnE6jYOIcigVetvLhtKZU3bTV8z6FQ7iYvtHM9knTFUJalPs2jaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407610; c=relaxed/simple;
	bh=dpAgjvFZpHGJGhZZSq1pgwGCVmFSsMCmYasOajOmwzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PTceBQdMqA3V+oQWmazsM2fOundyTDDrkT/b0PtKPtGd2b943J+zN6Yv8cUFYJ1k4RBx6Y3e7f/j+sWN4FrcRE1CusHYgFMIO8acVYkD9XugrYxK5yESeNMio5rIgxogyw7ZuUNhmxcJe4A2yxl0UsqcnPSnX9rldRIJ+EDQjW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K7G/Vykz; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407609; x=1776943609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dpAgjvFZpHGJGhZZSq1pgwGCVmFSsMCmYasOajOmwzE=;
  b=K7G/VykzoEseJFEoSEs4aECgUejbVJXL8ROI4Ud+Q+0WmhLy3kRf5ZLu
   9HnwHxbvC+QCdYHz0TQYPxGLeewaRzhoSV3qdp9YwpUKHxZvsmPLigyKC
   F84JWRJBzUUQ3q4N5IZPEwo9qXK1mgyvsX8JGUjrfKhCD3FiBkDbdVPM8
   JvcDCJ4DPHOEPNaU5T7WUHARrsD+fTb73dYILdJe3JTAOdiZmGRwjwspu
   u4uRbuwGmLaADFIBevEyyPORCHdW5gwi9lM6qvPWaEeFqMpS/VYkcUrUK
   MdjCuJ7gCo2bjStcgqtimnzBlLse8lhM3eNsfCyAlu+1tpDCYRqbbfE5W
   A==;
X-CSE-ConnectionGUID: 40dBtLzXR0uschCrEu6xnw==
X-CSE-MsgGUID: HSsLGGKrQaSfiVgCeRav+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825333"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825333"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:49 -0700
X-CSE-ConnectionGUID: ja6nxVJHQhOL5H5ugAyeqw==
X-CSE-MsgGUID: +liuPxK7SUe9OSjxja4HXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150833"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:45 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 10/10] i386/cpu: Enable 0x1f leaf for SapphireRapids by default
Date: Wed, 23 Apr 2025 19:47:02 +0800
Message-Id: <20250423114702.1529340-11-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Host SapphireRapids CPU has 0x1f leaf by default, so that enable it for
Guest CPU by default as well.

Suggested-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 38b330aaed4f..5573a9fd6c61 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4548,8 +4548,11 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             },
             {
                 .version = 4,
-                .note = "with spr-sp cache model",
+                .note = "with spr-sp cache model and 0x1f leaf",
                 .cache_info = &xeon_spr_cache_info,
+                .props = (PropValue[]) {
+                    { "cpuid-0x1f", "on" },
+                }
             },
             { /* end of list */ }
         }
-- 
2.34.1


