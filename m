Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1525C2AE4FA
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 01:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgKKAj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 19:39:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:12588 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKKAj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 19:39:59 -0500
IronPort-SDR: pfxbqvZBzCS9LxdlzFXr1gnXMzqCfGtrBmiAOeht8KeiN2C9HYOYsWwJEmv0pesSolnRdvnbeD
 dSmxwayl4qFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="167489223"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="167489223"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 16:39:57 -0800
IronPort-SDR: yxsyaDteDfcShgJDHe25SY8PLDJkrEfTHmRI7swP+/uvKoOvYh33CH3Zx0r8pzvBKXTdO1wOly
 JUW3MbeEmqxw==
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="356389564"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 16:39:56 -0800
Date:   Tue, 10 Nov 2020 16:39:54 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, Jim Mattson <jmattson@google.com>,
        Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v2] x86/mce: Use "safe" MSR functions when enabling
 additional error logging
Message-ID: <20201111003954.GA11878@agluck-desk2.amr.corp.intel.com>
References: <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
 <20201110063151.GB7290@nazgul.tnic>
 <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
 <20201110095615.GB9450@nazgul.tnic>
 <b8de7f7b-7aa1-d98b-74be-62d7c055542b@redhat.com>
 <20201110155013.GE9857@nazgul.tnic>
 <1b587b45-a5a8-2147-ae53-06d1b284ea11@redhat.com>
 <cacd1cd272e94213a0c82c9871086cf5@intel.com>
 <7bd98718-f800-02ef-037a-4dfc5a7d1a54@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd98718-f800-02ef-037a-4dfc5a7d1a54@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Booting as a guest under KVM results in error messages about
unchecked MSR access:

[    6.814328][    T0] unchecked MSR access error: RDMSR from 0x17f at rIP: 0xffffffff84483f16 (mce_intel_feature_init+0x156/0x270)

because KVM doesn't provide emulation for random model specific registers.

Switch to using rdmsrl_safe()/wrmsrl_safe() to avoid the message.

Reported-by: Qian Cai <cai@redhat.com>
Fixes: 68299a42f842 ("x86/mce: Enable additional error logging on certain Intel CPUs")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index b47883e364b4..42e60ef16c3a 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -521,9 +521,10 @@ static void intel_imc_init(struct cpuinfo_x86 *c)
 	case INTEL_FAM6_SANDYBRIDGE_X:
 	case INTEL_FAM6_IVYBRIDGE_X:
 	case INTEL_FAM6_HASWELL_X:
-		rdmsrl(MSR_ERROR_CONTROL, error_control);
+		if (rdmsrl_safe(MSR_ERROR_CONTROL, &error_control))
+			return;
 		error_control |= 2;
-		wrmsrl(MSR_ERROR_CONTROL, error_control);
+		wrmsrl_safe(MSR_ERROR_CONTROL, error_control);
 		break;
 	}
 }
-- 
2.21.1

