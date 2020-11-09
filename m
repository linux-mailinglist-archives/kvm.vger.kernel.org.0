Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDD32AC946
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 00:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbgKIXYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 18:24:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:7001 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbgKIXYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 18:24:04 -0500
IronPort-SDR: ID0Hd7zq6ENP88mZc7V0tz9D0YDzA4YLVkszv6mgrxKfpJX+Js0e0v4Qy5pox5+D3lPx/5SCan
 PazxTL9ggC5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170038978"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="170038978"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 15:24:03 -0800
IronPort-SDR: GpZbytWzBTV4P7UoNJU0CtTmo7uvwa2hvA0jdHPZGeGaba7dR/GNinokcc8VgiKXTCs/iFFDHk
 g3eGxblBjDOQ==
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="473180423"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 15:24:03 -0800
Date:   Mon, 9 Nov 2020 15:24:02 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Borislav Petkov <bp@alien8.de>, Jim Mattson <jmattson@google.com>
Cc:     Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, Boris Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>, x86 <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Message-ID: <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Booting as a guest under KVM results in error messages about
unchecked MSR access:

[    6.814328][    T0] unchecked MSR access error: RDMSR from 0x17f at rIP: 0xffffffff84483f16 (mce_intel_feature_init+0x156/0x270)

because KVM doesn't provide emulation for random model specific registers.

Check for X86_FEATURE_HYPERVISOR and skip trying to enable the mode (a
guest shouldn't be concerned with corrected errors anyway).

Reported-by: Qian Cai <cai@redhat.com>
Fixes: 68299a42f842 ("x86/mce: Enable additional error logging on certain Intel CPUs")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index b47883e364b4..7f7d863400b7 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -517,6 +517,9 @@ static void intel_imc_init(struct cpuinfo_x86 *c)
 {
 	u64 error_control;
 
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return;
+
 	switch (c->x86_model) {
 	case INTEL_FAM6_SANDYBRIDGE_X:
 	case INTEL_FAM6_IVYBRIDGE_X:
-- 
2.21.1

