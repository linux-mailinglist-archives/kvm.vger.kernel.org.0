Return-Path: <kvm+bounces-7905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B658484B1
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7B07B286F0
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1671C5D74E;
	Sat,  3 Feb 2024 09:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lcGpilDs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE03B5F57F;
	Sat,  3 Feb 2024 09:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950839; cv=none; b=AXAmzWwC/DEsCtXhMAtwZmBq4Up3PW52ysFlqaKlbCTHKCQO+HT6EIvjIaMc31jhk7rbt3tUqGkjx4rFF+5oJWVyBEuJ4+O4dQLYtXk75zWf4y5E/9zV48RLrflnBy2yW2JrLZyq18qAsoJmflpwNJIvzx9SksjAdo+YBB0ZoQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950839; c=relaxed/simple;
	bh=UAl/onYRs7BB51ytgYE6qoZNfSltN0H9mc+OMwUe7do=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VUNwnOFY3xo24S60n2th706DYvuOAT49F6NeNrhZxrW4vHHv9AJGP0TLh2XgZUwJMxVz1G89eRP4MXBAr7P71rCoTVm2iGbAaw9LJ92y11GNO9HD+0UBwXYlMkjf3Q5WP+NFUrzX7RfUT4n8NU1poaYkNed8AheeqXZp886Ephs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lcGpilDs; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950838; x=1738486838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UAl/onYRs7BB51ytgYE6qoZNfSltN0H9mc+OMwUe7do=;
  b=lcGpilDsIvPVGUbBZqsiAWieRMn5NP+/YQv8j8BzFaaRxpY3x/oM9nlP
   jZecC9uxuFxaM1gB/c1zfVSnbo3HpXz3HvAS4r9Odhb1g3bclBRGgXNOw
   smS0jitA+DYM1HNezy9EPomRwpnRU8kLTX1yBrePN55xje/0UB93iZuCQ
   EkOg47uzCvqFrVtqgiBaoRtBLY3ChNcBDMBxe9Z7Yv4HLCTV+HSVvhkSB
   y/PukPFsi0qjgnzJuNwiimuyyvNpNwK07g3E2uS4Anv9GUx1jgy4SBjS9
   eviMi5IZflCxcVnhzGs/gcn5rZg4fmADgVomk/IIwnl9myXn1Ll6CUohT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131970"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131970"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291279"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:31 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 09/26] KVM: x86: cpuid: Define CPUID 0x06.eax by kvm_cpu_cap_mask()
Date: Sat,  3 Feb 2024 17:11:57 +0800
Message-Id: <20240203091214.411862-10-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

PTS, HFI, and ITD feature bits are to be specified in kvm_cpu_caps and
depend on Host support.

Define kvm_cpu_caps[CPUID_6_EAX] with kvm_cpu_cap_mask() and use this
0x06 cap feature to set the 0x06 leaf of the guest.

Currently, only ARAT is supported in 0x06.eax. Although ARAT is not
available on all CPUs with VMX support[1], commit e453aa0f7e7b ("KVM:
x86: Allow ARAT CPU feature") always sets ARAT for Guest because the
APIC timer is emulated.

Explicitly check ARAT in __do_cpuid_func() and make sure this feature
bit is always set.

[1]: https://lore.kernel.org/kvm/1523455369.20087.16.camel@intel.com/

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 829bb9c6516f..d8cfae17cc92 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -628,6 +628,10 @@ void kvm_set_cpu_caps(void)
 		0 /* HTT */ | F(ACC) | 0 /* Reserved, PBE */
 	);
 
+	kvm_cpu_cap_mask(CPUID_6_EAX,
+		F(ARAT)
+	);
+
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
 		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
 		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
@@ -964,7 +968,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case 6: /* Thermal management */
-		entry->eax = 0x4; /* allow ARAT */
+		cpuid_entry_override(entry, CPUID_6_EAX);
+
+		/* Always allow ARAT since APICs are emulated. */
+		if (!kvm_cpu_cap_has(X86_FEATURE_ARAT))
+			entry->eax |= 0x4;
+
 		entry->ebx = 0;
 		entry->ecx = 0;
 		entry->edx = 0;
-- 
2.34.1


