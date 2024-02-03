Return-Path: <kvm+bounces-7929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 198078484F3
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:18:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CA3E1C21B46
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC4B5D720;
	Sat,  3 Feb 2024 09:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ewZUn2ec"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25AE5CDD0
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706951869; cv=none; b=pQV0zTJ3DlRtYQw45547qN9e4hpPJ43gh0+zYI2UhU4RwRiM39ydY+sjriWqCVVk9uTSobuaF1YzlceY20uzGTDc5d4tHXs+bj9OhTSDkcm0yYMVEHcy1Az1PnqdUIi3I0xJvTfxOlTcwxnM+j1Z/ALE6EiuNGf3CikVrDBFgr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706951869; c=relaxed/simple;
	bh=868VAJN89eGkinOq4EOD+Tl9/QzBYeTq2J6+WiPTTIA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Th9vTYeEizqaFekaIiAduxxT7+zMD3YdcXGK/pF0L9ZAlp1YOVrZVLIAUIBt2dtXKmfw/qbPUqq4gziVNHLFd7xlT9QO5DkrtB1ZeMYcxOJ7ThqHxFDHfCZyUg8GpztaIwrOu5xWd1MbZLk6jvcGAQkKWHWGlv8JRmQDBYYbt9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ewZUn2ec; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706951868; x=1738487868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=868VAJN89eGkinOq4EOD+Tl9/QzBYeTq2J6+WiPTTIA=;
  b=ewZUn2ecv7ST4Hmft7az1vOn0kxf/DA8ykc5+ix1ZMOW6lbPCJJ2toNJ
   EkSD1+xfGwEhb00cmh4MERnzme0KUQSHf0J6xAfQRArpaVv8BBno0rZcv
   OYFNKMSv6t28ca0wiTd6MurOZql94vUIBPgXCtRpBpHt40FvVvoEMT2z3
   zxPHCWOScA0xNdQHc/abMwgTR4fBANDimWFQ1P5nXpcPDE7muR1pm9x5t
   +Q+UuUSfpcFWjHxdsB6XLlQImKQ9tcyBuKn0jRE5tCGEOFTF0qCowh52l
   3Jv1w2KTief5KbKTnlruBpB+qMLC6Zll4kU5UYsrxOlHPmCxohPePYcEk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="216392"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="216392"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:17:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="31379033"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 03 Feb 2024 01:17:38 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 6/6] i386: Add a new property to set ITD related feature bits for Guest
Date: Sat,  3 Feb 2024 17:30:54 +0800
Message-Id: <20240203093054.412135-7-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203093054.412135-1-zhao1.liu@linux.intel.com>
References: <20240203093054.412135-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

The property enable-itd will be used to set ITD related feature bits
for Guest, which includes PTS, HFI, ITD and HRESET.

Now PTS, HFI, ITD and HRESET are marked as no_autoenable_flags, since
PTS, HFI and ITD have additional restrictions on CPU topology, and
HRESET is only used in ITD case. If user wants to enable ITD for Guest,
he need to specify PTS, HFI, ITD and HRESET explicitly in the -cpu
command.

Thus it's necessary to introduce "-cpu enable-itd" to help set these
feature bits.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 20 +++++++++++++++-----
 target/i386/cpu.h |  3 +++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3b26b471b861..070f7ff43a1b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7304,6 +7304,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
      */
     x86_cpu_hyperv_realize(cpu);
 
+    if (cpu->enable_itd) {
+        env->features[FEAT_6_EAX] |= CPUID_6_EAX_PTS | CPUID_6_EAX_HFI |
+                                     CPUID_6_EAX_ITD;
+        env->features[FEAT_7_1_EAX] |= CPUID_7_1_EAX_HRESET;
+    }
+
     x86_cpu_expand_features(cpu, &local_err);
     if (local_err) {
         goto out;
@@ -7494,22 +7500,25 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
     if (env->features[FEAT_6_EAX] & CPUID_6_EAX_PTS && ms->smp.sockets > 1) {
         error_setg(errp,
-                   "PTS currently only supports 1 package, "
-                   "please set by \"-smp ...,sockets=1\"");
+                   "%s currently only supports 1 package, "
+                   "please set by \"-smp ...,sockets=1\"",
+                   cpu->enable_itd ? "enable-itd" : "PTS");
         return;
     }
 
     if (env->features[FEAT_6_EAX] & (CPUID_6_EAX_HFI | CPUID_6_EAX_ITD) &&
         (ms->smp.dies > 1 || ms->smp.sockets > 1)) {
         error_setg(errp,
-                   "HFI/ITD currently only supports die/package, "
-                   "please set by \"-smp ...,sockets=1,dies=1\"");
+                   "%s currently only supports 1 die/package, "
+                   "please set by \"-smp ...,sockets=1,dies=1\"",
+                   cpu->enable_itd ? "enable-itd" : "HFI/ITD");
         return;
     }
 
     if (env->features[FEAT_6_EAX] & (CPUID_6_EAX_PTS | CPUID_6_EAX_HFI) &&
         !(env->features[FEAT_6_EAX] & CPUID_6_EAX_ITD)) {
-        error_setg(errp,
+        error_setg(errp, "%s", cpu->enable_itd ?
+                   "Host doesn't support ITD" :
                    "In the absence of ITD, Guest does "
                    "not need PTS/HFI");
         return;
@@ -8003,6 +8012,7 @@ static Property x86_cpu_properties[] = {
                      false),
     DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
                      true),
+    DEFINE_PROP_BOOL("enable-itd", X86CPU, enable_itd, false),
     DEFINE_PROP_END_OF_LIST()
 };
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a68c9d8a8660..009ec66dead0 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2071,6 +2071,9 @@ struct ArchCPU {
     int32_t hv_max_vps;
 
     bool xen_vapic;
+
+    /* Set ITD and related feature bits (PTS, HFI and HRESET) for Guest. */
+    bool enable_itd;
 };
 
 typedef struct X86CPUModel X86CPUModel;
-- 
2.34.1


