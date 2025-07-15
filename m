Return-Path: <kvm+bounces-52418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF45B04F34
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60D2416663D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C002D1916;
	Tue, 15 Jul 2025 03:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VhYlXVGd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DAF2D12E4
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 03:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550797; cv=none; b=rlp8q3p6LrSO3rCHWDwJ3T4A8WHw0mp1VG88MsC0yX6GT/+WsWoZpKSCZTCemG1q9i3XCB9p3jCCSqBUuUxU9hfD4D3pnpzcr1Bng0UYjg7Ue1PPD48AeMSEyCkZKE0ecCI674hjk5PnmJkOOFusGa9KFiAqsl+4lGu1ra7OVjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550797; c=relaxed/simple;
	bh=2JiUasKMV6cFYaN1ccluHOyPO7F9xXqlVaP37qhNe+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjsfhscgAiCbwrsuzz1xL6D6miJVjcwLz7G209NJTafd6CeLhILjTqzZ/7irrss+GAIwKrsiECsDKBZvInxDElpvy/Cle1ye/vgzZdQI2zGWTdqN4Xce7KJ6GAPNLxbOgrXsfbvcWRZ3JgzaJLxOZzogC9WVFlKAnH3r50KQm4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VhYlXVGd; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752550796; x=1784086796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2JiUasKMV6cFYaN1ccluHOyPO7F9xXqlVaP37qhNe+c=;
  b=VhYlXVGdlih3hAekGX+peH+56+b5U7A8gS2bUFNzDiDNcKWo8bgYwqci
   pfswOvgthrGeeBdQlrECLpiYueSc3wV3KqopUQhrcs3ZENMy8WpHJkbnx
   z3fn6lzsFTgjw4SOWFQ4Yj66rLas0qFR/R+TOBhTE30MGaoHISFoBsRYw
   a4Ivbo1ob8LnLAJ8E5P0keBQzSX9FUREJQwWEgjd1e1jnHmczOfMg+VB9
   Q+lWaxXFIE1c8aytq9g0pl2kdaeHp0Hdsokn071C+zJGL6w//9Hvgjwfz
   rTjK7h/vb1MiVYY9XdyR4tzaBX+PS7WxoiC/SVq/sXwVT/l26DbuB5U4/
   g==;
X-CSE-ConnectionGUID: FlSSvSrvS0GzEMw+OstLXA==
X-CSE-MsgGUID: pyIP9CSgTdK0skcOYeDEBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72334917"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="72334917"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:39:56 -0700
X-CSE-ConnectionGUID: J3CmaLuvT3uAowYkYHY13g==
X-CSE-MsgGUID: XLuACWExQqyhpIE3jykCvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="180808090"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa002.fm.intel.com with ESMTP; 14 Jul 2025 20:39:53 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	ackerleytng@google.com,
	seanjc@google.com
Cc: Fuad Tabba <tabba@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	ira.weiny@intel.com,
	michael.roth@amd.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [POC PATCH 1/5] update-linux-headers: Add guestmem.h
Date: Tue, 15 Jul 2025 11:31:37 +0800
Message-ID: <20250715033141.517457-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250715033141.517457-1-xiaoyao.li@intel.com>
References: <cover.1747264138.git.ackerleytng@google.com>
 <20250715033141.517457-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 scripts/update-linux-headers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index b43b8ef75a63..3f6169a121a8 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -200,7 +200,7 @@ rm -rf "$output/linux-headers/linux"
 mkdir -p "$output/linux-headers/linux"
 for header in const.h stddef.h kvm.h vfio.h vfio_ccw.h vfio_zdev.h vhost.h \
               psci.h psp-sev.h userfaultfd.h memfd.h mman.h nvme_ioctl.h \
-              vduse.h iommufd.h bits.h; do
+              vduse.h iommufd.h bits.h guestmem.h; do
     cp "$hdrdir/include/linux/$header" "$output/linux-headers/linux"
 done
 
-- 
2.43.0


