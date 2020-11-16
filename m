Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96E02B4F61
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbgKPS2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:48458 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388337AbgKPS2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:23 -0500
IronPort-SDR: jQlx1HG65Jyy1JiKjz5FLH/EeFSoCpvB8MgDvjwXE+Vl5UPGGkGY/KYO9NHzODsS+Pdt/1xUVb
 zu4lmfBKtu6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819213"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819213"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:22 -0800
IronPort-SDR: ugxbilTI9eOuuteaQH2t/r+tGicD2+WLH7F8pD2PSYyMubmdgyHpeMa54D5RFrsg6000ZjO8gz
 NDdX2Huf4b/w==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528381"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:22 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [RFC PATCH 63/67] cpu/hotplug: Document that TDX also depends on booting CPUs once
Date:   Mon, 16 Nov 2020 10:26:48 -0800
Message-Id: <1d588f512e13b0342e6e76aabb2263440bdde8f8.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@linux.intel.com>

Add a comment to explain that TDX also depends on booting logical CPUs
at least once.

TDSYSINITLP must be run on all CPUs, even software disabled CPUs in the
-nosmt case.  Fortunately, current SMT handling for #MC already supports
booting all CPUs once; the to-be-disabled sibling is booted once (and
later put into deep C-state to honor SMT=off) to allow the init code to
set CR4.MCE and avoid an unwanted shutdown on a broadcasted MCE.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
---
 kernel/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6ff2578ecf17..17a8d7db99b2 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -435,6 +435,10 @@ static inline bool cpu_smt_allowed(unsigned int cpu)
 	 * that the init code can get a chance to set CR4.MCE on each
 	 * CPU. Otherwise, a broadcasted MCE observing CR4.MCE=0b on any
 	 * core will shutdown the machine.
+	 *
+	 * Intel TDX also requires running TDSYSINITLP on all logical CPUs
+	 * during boot, booting all CPUs once allows TDX to play nice with
+	 * 'nosmt'.
 	 */
 	return !cpumask_test_cpu(cpu, &cpus_booted_once_mask);
 }
-- 
2.17.1

