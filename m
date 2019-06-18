Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CE44AE30
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbfFRWvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:51:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:48878 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730847AbfFRWvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009345"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:10 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 03/17] x86/split_lock: Align x86_capability to unsigned long to avoid split locked access
Date:   Tue, 18 Jun 2019 15:41:05 -0700
Message-Id: <1560897679-228028-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

set_cpu_cap() calls locked BTS and clear_cpu_cap() calls locked BTR to
operate on bitmap defined in x86_capability.

Locked BTS/BTR accesses a single unsigned long location. In 64-bit mode,
the location is at:
base address of x86_capability + (bit offset in x86_capability / 64) * 8

Since base address of x86_capability may not be aligned to unsigned long,
the single unsigned long location may cross two cache lines and
accessing the location by locked BTS/BTR introductions will cause
split lock.

To fix the split lock issue, align x86_capability to size of unsigned long
so that the location will be always within one cache line.

Changing x86_capability's type to unsigned long may also fix the issue
because x86_capability will be naturally aligned to size of unsigned long.
But this needs additional code changes. So choose the simpler solution
by setting the array's alignment to size of unsigned long.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/processor.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c34a35c78618..d3e017723634 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -93,7 +93,9 @@ struct cpuinfo_x86 {
 	__u32			extended_cpuid_level;
 	/* Maximum supported CPUID level, -1=no CPUID: */
 	int			cpuid_level;
-	__u32			x86_capability[NCAPINTS + NBUGINTS];
+	/* Aligned to size of unsigned long to avoid split lock in atomic ops */
+	__u32			x86_capability[NCAPINTS + NBUGINTS]
+				__aligned(sizeof(unsigned long));
 	char			x86_vendor_id[16];
 	char			x86_model_id[64];
 	/* in KB - valid for CPUS which support this call: */
-- 
2.19.1

