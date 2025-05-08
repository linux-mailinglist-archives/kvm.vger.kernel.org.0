Return-Path: <kvm+bounces-45940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB8DAAFEA3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 128AB3AE81A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65A9286D48;
	Thu,  8 May 2025 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dpE3Jgbr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE56286D46
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716811; cv=none; b=TNnNklt9y2mA6WULjDZB5IJ2vUeo5htWcUobiDT7z1UhzfI8LoFdgWLYJJ2eJfu7AeXFdJHZSwKIHQRGl/hdhaVpYT9RGaXIUvt5PkA+eVFh9QWk2CEmjGoCp3tbxd33SpoDzsMhtjvdbpLDxCBGhEToCEHtwzhrjMgva2a/4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716811; c=relaxed/simple;
	bh=DpskWjBVasOF9ARPGBQ/sP2V4yk+GIJr+iINMUhtc+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oO6HTHfbbjKYtqOyjbBnkljwDqQDt6reM6SJekUzycklZTgwqrqsiRaUO6TrMDMRcGHRvHexFdUrEkni4P6QpTvPqZauAchHRttqnFZ1UeDjQyEaG+6Qo7YT8HkbtqoEgieH+RacshL1dC26tOP8r+FPwqUSZk48omV/ISLEwFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dpE3Jgbr; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716809; x=1778252809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DpskWjBVasOF9ARPGBQ/sP2V4yk+GIJr+iINMUhtc+I=;
  b=dpE3JgbrCKrEZmEjeMksQRNNsFPtvSb/oimLznioqruUTHrk3ndW2pNQ
   e6mpmMyksaY7QP2J74XnuUqe0AkZFWcN1HVefMqmRhEc4eGNvMpKbgWD0
   epvKLLhUHDH/N2Fex37dyAx35Bk/hkC8rAA2244koGo7ouVg1Uz4Rmo7Y
   o+KKwlauBf8yUG7VVJ67tdrstZydS+TgNjxQHOjOTO63QQYoASWLMQMIc
   y6ZYvCXjxNwhjQcb/AAayLtctahYlgeTgkuRT9g/ygYRIhAhzOZooDVYS
   ENeTEgJmYeY5aL66pIDwZaSa9YEMhdwZoJFKWj7w5s6/p/NIxVTq1iwY7
   g==;
X-CSE-ConnectionGUID: 94R+zrBtRvGJa7r22GN/Xw==
X-CSE-MsgGUID: HIOtkJdJQ1+WodCuIVjhDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888331"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888331"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:49 -0700
X-CSE-ConnectionGUID: mBiE+rTkSlOhWDl6wL4ABA==
X-CSE-MsgGUID: JPk3EyxQQdCt78Pmb3kM+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440273"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:46 -0700
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
Subject: [PATCH v9 37/55] i386/tdx: Disable PIC for TDX VMs
Date: Thu,  8 May 2025 10:59:43 -0400
Message-ID: <20250508150002.689633-38-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Legacy PIC (8259) cannot be supported for TDX VMs since TDX module
doesn't allow directly interrupt injection.  Using posted interrupts
for the PIC is not a viable option as the guest BIOS/kernel will not
do EOI for PIC IRQs, i.e. will leave the vIRR bit set.

Hence disable PIC for TDX VMs and error out if user wants PIC.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 744c5cde3636..4cb767668a3a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -388,6 +388,13 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -EINVAL;
     }
 
+    if (x86ms->pic == ON_OFF_AUTO_AUTO) {
+        x86ms->pic = ON_OFF_AUTO_OFF;
+    } else if (x86ms->pic == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support PIC");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.43.0


