Return-Path: <kvm+bounces-4780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69135818370
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90F9A1C2169C
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC37134D3;
	Tue, 19 Dec 2023 08:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yzjn6pCn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7F011709;
	Tue, 19 Dec 2023 08:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702974918; x=1734510918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yppM1vzyIg0mJzvtILq30t1ac8vqS11G7wocpCARxsA=;
  b=Yzjn6pCn9lHK35vJFmvSSRpYKVJTHpyOp+Z6r5jYoCWDHOl+a5sHi+vM
   4CGWIHvNuNozKqro65WQ2ZALaf2aVyFye2JSGqcSUFcijCQ1/v3Vzl5An
   vjbD1AY9UFWIDEGMDJw9b3L84U2dZ4DA7nXrB2DY5n5egbaW69kY627Rc
   6DEXWIhKsmbOiVMOZK85Pwnn5fM7uML2xvqdi8SUGcab7gT9ExnkGBKEl
   NhALDMBh3AkD7xvzBLKcZeuNZToqHcstKdhsf7tIfSJh6Ghv+DJjifNgI
   lWnDHMuBHHhd48c4gAxxAzSbejB0TmSTZoTCMOchrjHzewuX0Nx/aGJAD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="395355754"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="395355754"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="725658892"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="725658892"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:53 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH v3 1/4] KVM: x86/hyperv: Calculate APIC bus frequency for hyper-v
Date: Tue, 19 Dec 2023 00:34:38 -0800
Message-Id: <ecd345619fdddfe48f375160c90322754cec9096.1702974319.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1702974319.git.isaku.yamahata@intel.com>
References: <cover.1702974319.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove APIC_BUS_FREUQNCY and calculate it based on APIC bus cycles per NS.
APIC_BUS_FREUQNCY is used only for HV_X64_MSR_APIC_FREQUENCY.  The MSR is
not frequently read, calculate it every time.

In order to make APIC bus frequency configurable, we need to make make two
related constants into variables.  APIC_BUS_FREUQNCY and APIC_BUS_CYCLE_NS.
One can be calculated from the other.
   APIC_BUS_CYCLES_NS = 1000 * 1000 * 1000 / APIC_BUS_FREQUENCY.
By removing APIC_BUS_FREQUENCY, we need to track only single variable
instead of two.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v3:
- Newly added according to Maxim Levistsky suggestion.
---
 arch/x86/kvm/hyperv.c | 2 +-
 arch/x86/kvm/lapic.h  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 238afd7335e4..a40ca2fef58c 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1687,7 +1687,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
 		break;
 	case HV_X64_MSR_APIC_FREQUENCY:
-		data = APIC_BUS_FREQUENCY;
+		data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
 		break;
 	default:
 		kvm_pr_unimpl_rdmsr(vcpu, msr);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..a20cb006b6c8 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -17,7 +17,6 @@
 #define APIC_DEST_MASK			0x800
 
 #define APIC_BUS_CYCLE_NS       1
-#define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
 
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
-- 
2.25.1


