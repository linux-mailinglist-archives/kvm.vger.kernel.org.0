Return-Path: <kvm+bounces-10412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4937586C122
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05727282779
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C52482C2;
	Thu, 29 Feb 2024 06:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RS7etBSi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEB2481A7
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189023; cv=none; b=pqo7baMmD55Ej0PVhzX7s1dNF7LE3Ejy0Yv6z5kvms3tJeCSpsmlx4mZS4dSv1pB9j9bviP53bnxUYkkega9G2Im/m3lvy81sHnNX+7UXTJVwF1T6YDL9Hudou7ByIgEzIuCBetsbk9uyKXEaWdg8pkpaVL2yn+a2/+5T5BgA+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189023; c=relaxed/simple;
	bh=qxEquHRUuP1fHENC9EWdZcYjn/ViaYGDfv/GBl3pyzM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rENQK72jUzaeFgCkZ1vs5TYq9epuP/HfBzH+zWGcHe3V50sxneH0GzqIcRTZ9lQgICQZTfNBHSqioWUxFE8rqmZQzn9bFKecn9muxmv+TorpHKQzlEp5Qx44s0vRqNKqrJz7wq/8LRvLBUrzIQ0q9lwsnKYVWcf+61PHyOUh0tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RS7etBSi; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709189022; x=1740725022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qxEquHRUuP1fHENC9EWdZcYjn/ViaYGDfv/GBl3pyzM=;
  b=RS7etBSiArK3iaL776hriPHpZXiOEP4FrvRjZClw+FxtLy0au3BSKRtD
   8upTIdtcrKypNVr8rB3PAcxButQV6qQCqBI4oeLs/KP7G59AsiwC3Y35z
   tkp6AmSg69n4w8uVx+34KZyyRGJEVwVbsrLhGBTBI+BaA4zLy5m6c+g6A
   pLiBXxBaBD4dL9QMdsMj6vYsJ2ij9Ki35vP7vFjrof7REw51yGawW+z1Q
   qtwOmXgpwaRz0xKcnSHb+EPdsw4SCDExi1kk2B1k/zYpRDISk4ANcRkH6
   qReRa2kfOwmRAuqB4DPzgFcQ1miD05bZfT9sSMY4gdvSLmXePKRYOsv37
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803177"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803177"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076356"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:43:36 -0800
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
Subject: [PATCH v5 56/65] i386/tdx: Disable PIC for TDX VMs
Date: Thu, 29 Feb 2024 01:37:17 -0500
Message-Id: <20240229063726.610065-57-xiaoyao.li@intel.com>
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

Legacy PIC (8259) cannot be supported for TDX VMs since TDX module
doesn't allow directly interrupt injection.  Using posted interrupts
for the PIC is not a viable option as the guest BIOS/kernel will not
do EOI for PIC IRQs, i.e. will leave the vIRR bit set.

Hence disable PIC for TDX VMs and error out if user wants PIC.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index c3fadbc5c58e..0225a9b79b36 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -720,6 +720,13 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
2.34.1


