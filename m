Return-Path: <kvm+bounces-10411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E6686C121
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CED31F23820
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FE3481BB;
	Thu, 29 Feb 2024 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ib6dN0/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBFA481A7
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189017; cv=none; b=Z5lQ+BKOF7ApVzmKsAlOhbqWdpDYkkkcJ826gJjNNbWSImiFJUFPY+oCdp+gvSXhzLoORYCzSunP9SMDi4aS0IW4GtPJaS6/EH2T88sbhjoNEc6V6TeBZr9VHcKwX/gwW7PeD4W2frBaiIt6iN/6ExFaeL80IX+227ut6qGuGaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189017; c=relaxed/simple;
	bh=lvAsjZqEiGnouE7rrfFJwW5f/9eba4iLFejeadBD9z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FG86gD4THDQ1MMriRDr/4uzxFqAZAyXK+Qt8YVN2vPmzxo4yrNaEa+xptu/ioJkePmURgbWCrACU36iiyoLXMqAohXtZdqXCcE+djP1O6OQXJn5gR1YwC6cANDVRkfXzkv/WsdiQ4swxOcW5YCzFZmJ1XCXQUHLfjfBgmgvHUs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ib6dN0/W; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709189015; x=1740725015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lvAsjZqEiGnouE7rrfFJwW5f/9eba4iLFejeadBD9z4=;
  b=ib6dN0/W3Xp7jQOvvjz+FOAWIY0demo/uUPToWpIv2OXdEOQNaTDKJpS
   yIJmgy+7jzRqMI+qz9mb11uWV02325sCRbUCcLykesb8c89npDjIj45aj
   Hs0Mc0LSUlHcr1PSsIRWS8yUz16gI+H53lx+DdLpB43TnFRhqAvR7Ty9w
   ua8RfYfD66zD2z/u+dSxfIgV/3K/LB1v3wgP61r7gP/IBlA5a2qpRQHvh
   Zn9GqDM9v1c84tMJHgaaZQ2wMGAuqQFn+VTFNvhJll1lvUgRGDQUEbNR5
   tQjbzsgkYxlCR8u/KOKXcVLdx1ZNiDM0oQ3ur0zwkg1JIi+7VhqDPlJmE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803165"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803165"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:43:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076321"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:43:30 -0800
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
Subject: [PATCH v5 55/65] i386/tdx: Disable SMM for TDX VMs
Date: Thu, 29 Feb 2024 01:37:16 -0500
Message-Id: <20240229063726.610065-56-xiaoyao.li@intel.com>
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

TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
VMM cannot manipulate TDX VM's memory.

Disable SMM for TDX VMs and error out if user requests to enable SMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 811a3b81af99..c3fadbc5c58e 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -707,11 +707,19 @@ static Notifier tdx_machine_done_notify = {
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
+    X86MachineState *x86ms = X86_MACHINE(ms);
     TdxGuest *tdx = TDX_GUEST(cgs);
     int r = 0;
 
     ms->require_guest_memfd = true;
 
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support SMM");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.34.1


