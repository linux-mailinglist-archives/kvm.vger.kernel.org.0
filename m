Return-Path: <kvm+bounces-45945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D95AAFEAE
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71BA4B425FF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D872882A8;
	Thu,  8 May 2025 15:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LYbUyUHf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444F427B4E1
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716826; cv=none; b=Nq7YMPvFr7BjA57lW7jrayqZ/ar4Zh7plbk36k/vgARMQbdwh951RzQu213+zkvc5ARHsDHXsRi0a6mbw/u5xYaAnCaxnM8TtRy+OKtMx73FAoYV03rH+w0GikS1lL6mqJ9/v4g2vveGM5dh0ORJSifdaG4oFDu6pqfcH5qQgaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716826; c=relaxed/simple;
	bh=x5pYL8yriUeHcJC0Spu1U1YR7f9qwaR9C4p6JrpuYzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF+srD9UbsDfu3iUbe3Q2sduOjzweSaGiTeXWdo8UpxV1mmAtHIltpywN+MZSvcWIke0eE9uk/j4xIHmtdtYFdNDEseQbEN8FUKs5tYPboY+BSDqfx9SbJxX8dfm+Du1hPZFMA3AG97VBdng11VFaEDbi4h+IHMeJ6iqdEBbA9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LYbUyUHf; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716825; x=1778252825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x5pYL8yriUeHcJC0Spu1U1YR7f9qwaR9C4p6JrpuYzw=;
  b=LYbUyUHf8Thn+cZWhNrmEmewLQulvNoQKZQcEiIDgegbJyEYkReWQK2y
   3cqCj4At5xkZYi1ybvMqhMakA6SVeumKwWNlOf2PsGIZLTczJ8oIhtbqC
   muZlxJj2lbJ2QH/i5zsfljkEAF9c/SNqqWpQgtOrdqphPySC/Qw7qZrn7
   s1aVv+AueJVJ3iSQRr1FP5bE7GA4uf+Hbus0iZgN3HbsaGtA2uWZO3UCP
   xJKWOeuHCTTmj9G/bRd2bUxhAJWZmK++LmQbRl0wWiHnhULNxgKT0adPN
   U+PpzB6mIcssnIQL6rDueVh/FSbPy9gho+GvShVFyinqbR8osJzpzd8/8
   g==;
X-CSE-ConnectionGUID: 6/m4HNhVTGGk2x4Cbs6/3g==
X-CSE-MsgGUID: Mi+pKCSBSR6Zs6wSfKaOKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888434"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888434"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:04 -0700
X-CSE-ConnectionGUID: aBjHnwqFSTmbwwJV488puQ==
X-CSE-MsgGUID: H48PU95TRwutAvMxNKykNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440385"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:01 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 42/55] cpu: Don't set vcpu_dirty when guest_state_protected
Date: Thu,  8 May 2025 10:59:48 -0400
Message-ID: <20250508150002.689633-43-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

QEMU calls kvm_arch_put_registers() when vcpu_dirty is true in
kvm_vcpu_exec(). However, for confidential guest, like TDX, putting
registers is disallowed due to guest state is protected.

Only set vcpu_dirty to true with guest state is not protected when
creating the vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v7:
 - new patch to replace "i386/tdx: Don't get/put guest state for TDX VMs"
   in v6;
---
 accel/kvm/kvm-all.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5835d840f3ad..9862d8ff1d38 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -466,7 +466,9 @@ int kvm_create_vcpu(CPUState *cpu)
 
     cpu->kvm_fd = kvm_fd;
     cpu->kvm_state = s;
-    cpu->vcpu_dirty = true;
+    if (!s->guest_state_protected) {
+        cpu->vcpu_dirty = true;
+    }
     cpu->dirty_pages = 0;
     cpu->throttle_us_per_full = 0;
 
-- 
2.43.0


