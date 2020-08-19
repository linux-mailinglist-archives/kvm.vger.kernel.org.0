Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD3B249537
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgHSGsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:48:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:36213 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgHSGsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:48:13 -0400
IronPort-SDR: i2uTZaEYLaMByq88Y30RnKMvbB2lX2AcUOTcjmfikVyJl41cfNtJwGDgDxUF8xP8sKLFy11sYN
 /ad45cu6hYzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873217"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873217"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:39 -0700
IronPort-SDR: jyeQKbVFufKsoF2C405qrPn5HWNKSQcANzh/kgsgfWA0lDp4UZTQJYEy1GStJeVtCeqXIBwI+k
 uasgY8qZOiTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679324"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:36 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v10 8/9] x86/split_lock: Set cpu_model_supports_sld to true after the existence of split lock detection is verified BSP
Date:   Wed, 19 Aug 2020 14:47:06 +0800
Message-Id: <20200819064707.1033569-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It should be more resonable to set cpu_model_supports_sld to true after
BSP is verified to have feature split lock detection.

It also avoids externing the cpu_model_supports_sld when enumerate the
split lock detection in a guest via PV interface in a future patch.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5f44e0de04b9..b16f3dd9b9c2 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1052,6 +1052,7 @@ static void __init split_lock_setup(void)
 		return;
 	}
 
+	cpu_model_supports_sld = true;
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
 	if (state == sld_fatal)
 		setup_force_cpu_cap(X86_FEATURE_SLD_FATAL);
@@ -1203,6 +1204,5 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 		return;
 	}
 
-	cpu_model_supports_sld = true;
 	split_lock_setup();
 }
-- 
2.18.4

