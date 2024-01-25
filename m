Return-Path: <kvm+bounces-6959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C687783B842
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 061961C20DD2
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063D279E2;
	Thu, 25 Jan 2024 03:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bqDUS+eE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5720B882D
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153467; cv=none; b=qqwruSl6jd9eSlEzZZ27fp4eCads6L7LadB5lfenxg98DKGx0VAx+oPA8ZHGGiBa8ECK+1v8jzhZBmbtMPGVZEgKd95yeQc/WWqRYsGQcnGdGt50TjLgd6SovL91ZZoZCWjhsmhDeyxuK3vgnjfu3c8wvO/s+uh99wTZpPWdjjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153467; c=relaxed/simple;
	bh=dYbC6/O6Cy+T1AZ7szpJepdFNBXHXc3/nDTSns21eRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tp/3olb0l2fWeeA/ng/U3tTsZgW0TVQXh2CwFiGXIUYBide/mzVpbvLRGAuCdnKfW90X69ZpRXrSrKxDoyuVvpVr/Wx7zdBctkbe6+SffMCPSaBxwwj+ovwXAwhGYDHkiAftT3q5nn/MrJG7gji3fqcyqokF5dPa1BCMxBdEZ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bqDUS+eE; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153466; x=1737689466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dYbC6/O6Cy+T1AZ7szpJepdFNBXHXc3/nDTSns21eRk=;
  b=bqDUS+eEkyA7Bwltfgy19wLdsVY1bgl8FN/oA14bAUdKP5jNrMCOP7pL
   RtDS298HNqnrGK6RG11HNeQT1WJ5FDiQGmPwlxawk32t90ymRgMexXKSA
   8+mNDhwYtoqQ6D4qZ0aFgpKYMNDbyaC61uN+oIBqHFXx3utZJj1Z2m7wv
   s9IbA94Rgu4zkFU95jgoA4LokuMeHZYD0SFgDjMV88gdnSw9gXA+iDuAn
   JmCsDQbTW2n3RTMV5ywUr/ArRfJExaa2fc1UCeBHChx9EIDmg2pydlr5D
   r9bcxH0/HnRmmJR/fX/yNkpK3EuW9nsda/IDydCYtiUEUaaZA46/svWnk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430352"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430352"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:28:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086423"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:28:44 -0800
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
Subject: [PATCH v4 57/66] i386/tdx: Disable PIC for TDX VMs
Date: Wed, 24 Jan 2024 22:23:19 -0500
Message-Id: <20240125032328.2522472-58-xiaoyao.li@intel.com>
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
index 7eb3628763ae..838b7916278c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -708,6 +708,13 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
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


