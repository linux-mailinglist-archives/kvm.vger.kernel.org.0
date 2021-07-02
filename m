Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A563BA5B0
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhGBWJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:15309 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233176AbhGBWIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168415"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168415"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:32 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814893"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [RFC PATCH v2 64/69] cpu/hotplug: Document that TDX also depends on booting CPUs once
Date:   Fri,  2 Jul 2021 15:05:10 -0700
Message-Id: <a934180cca67fc275659719696fff01de708565e.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 kernel/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index e538518556f4..58377a03e9d6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -446,6 +446,10 @@ static inline bool cpu_smt_allowed(unsigned int cpu)
 	 * that the init code can get a chance to set CR4.MCE on each
 	 * CPU. Otherwise, a broadcasted MCE observing CR4.MCE=0b on any
 	 * core will shutdown the machine.
+	 *
+	 * Intel TDX also requires running TDH_SYS_LP_INIT on all logical CPUs
+	 * during boot, booting all CPUs once allows TDX to play nice with
+	 * 'nosmt'.
 	 */
 	return !cpumask_test_cpu(cpu, &cpus_booted_once_mask);
 }
-- 
2.25.1

