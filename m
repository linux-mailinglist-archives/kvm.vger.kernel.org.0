Return-Path: <kvm+bounces-24107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35937951603
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD78E1F22DD6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8B413F01A;
	Wed, 14 Aug 2024 08:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KdMZ9jrX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369113D606
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622560; cv=none; b=LJdeuLufljIvdPc4ayXTemXU+qlT7ELent+yFqlGKj/gTzTZnL8LeyqVDwTmhpkOY3JpWzqusNZ4P8Z0Ijj7xfA0QfT+Cu7Fym7U6/beneV51TuHx1vGtquizih57MXtz5nuEO3ebKYaJeKGdl7YYyKUFEoij1N9FG5LxzXeETM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622560; c=relaxed/simple;
	bh=X3na6+L70Cfx64EUlxwZzmPxVDrsGV+622+OsmsswRI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZwXt87a3y2+FYon6YkpbbHXFtpqDMInMvu4N1JjmjQkyAtFVmTAvvQBtu24m7qt28SUbdUb9yZBHVriP2IQWYZ/6t1tKNT9sjlXeevRKuSwqJxdnzJ8qdd8Z0Pq4gYkRGuBRtl9kNq0+Qj/PqGR2gUOOhmUjHQiqST6AkqfjtX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KdMZ9jrX; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622559; x=1755158559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X3na6+L70Cfx64EUlxwZzmPxVDrsGV+622+OsmsswRI=;
  b=KdMZ9jrXjAZ8jQ6xXhSI2g8acyE7hl1AXZX8sZbEyT4bvyj2DF+4vWOx
   UicynWVgnYOOPKs7WvoL7Wjk8XBRjizenOjVddIgDBUhnka8bZDmi9oB6
   6v8vAQyWMmJ6mOH7Sj+kD7k7LS/yIsotozjNODf7EK+AH6cuCrzVaYsVQ
   CFnK8n9laD1dflhDMESQSt2mWs2pOrx56QwKkLNW110uqR7pGNUIs8nJU
   kwVwAO7uS5fCYKlf8FgnugMxKb4bAd6RCUrWzA1X3v74Ur7Mu08eGlhV7
   LQhsinEsL4r8R4hd6PCVJ8TKK1wj+uRjXbDuiTGhAF/s1UI1O7lwCO3qL
   w==;
X-CSE-ConnectionGUID: 8lR253FMQd+Q77ixnyq/Wg==
X-CSE-MsgGUID: JQzIiad5QMezLGXCcHF+kQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584480"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584480"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:39 -0700
X-CSE-ConnectionGUID: BUEn6TXQQ9G9BU38uK4/2g==
X-CSE-MsgGUID: sSJofb4dTDqskubB5/BOIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048952"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:37 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 4/9] i386/cpu: Construct valid CPUID leaf 5 iff CPUID_EXT_MONITOR
Date: Wed, 14 Aug 2024 03:54:26 -0400
Message-Id: <20240814075431.339209-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814075431.339209-1-xiaoyao.li@intel.com>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When CPUID_EXT_MONITOR is not set, it means no support of MONITOR/MWAIT
leaf, i.e., CPUID leaf 5.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 03376ccf3e75..5bee84333089 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6553,10 +6553,14 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 5:
         /* MONITOR/MWAIT Leaf */
-        *eax = cpu->mwait.eax; /* Smallest monitor-line size in bytes */
-        *ebx = cpu->mwait.ebx; /* Largest monitor-line size in bytes */
-        *ecx = cpu->mwait.ecx; /* flags */
-        *edx = cpu->mwait.edx; /* mwait substates */
+        if (env->features[FEAT_1_ECX] & CPUID_EXT_MONITOR) {
+            *eax = cpu->mwait.eax; /* Smallest monitor-line size in bytes */
+            *ebx = cpu->mwait.ebx; /* Largest monitor-line size in bytes */
+            *ecx = cpu->mwait.ecx; /* flags */
+            *edx = cpu->mwait.edx; /* mwait substates */
+        } else {
+            *eax = *ebx = *ecx = *edx = 0;
+        }
         break;
     case 6:
         /* Thermal and Power Leaf */
-- 
2.34.1


