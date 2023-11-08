Return-Path: <kvm+bounces-1244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A46B7E5DC1
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD34E281225
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0A437165;
	Wed,  8 Nov 2023 19:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GBHs4hUh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF0C32C82;
	Wed,  8 Nov 2023 19:00:27 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DFC2111;
	Wed,  8 Nov 2023 11:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699470020; x=1731006020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KXbsnMJjjkQe9TP5OBPKowAwdzryjmcQQL3QpeWmhAY=;
  b=GBHs4hUho0ZMf44L5H2r6KsMYKRaIPhe2mB70jXBhtTGi9z417AQJczt
   1PMdbZnDFCICdfqWNnakrnWyMeK44l4Eti/MlRF5plOq3SLP0B/ZN9m7Z
   pN79VFWi1LnRj1vO+dbQGuyNNQircgMbBVNS4icWUL52hkSdnFUgfELSM
   YskspKt/XKd3u6qLh1afJ2rpn5cFQt22op8q3kq+gtWbard2ZgupDsqNI
   FlzUWMeOzpFkuwxqDqLXxUpEXMJuoo34k6lIBSm0eQzXHbzofmwIlR+uE
   KHEySALtwHEsm7syEDe9n1WWqvVEmnKHB8vI+CKnCICqIMbi2BZ4Lxclq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="8486241"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="8486241"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:00:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="10892423"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orviesa001.jf.intel.com with ESMTP; 08 Nov 2023 11:00:17 -0800
From: Xin Li <xin3.li@intel.com>
To: kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	corbet@lwn.net,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	vkuznets@redhat.com,
	peterz@infradead.org,
	ravi.v.shankar@intel.com
Subject: [PATCH v1 04/23] KVM: x86: Mark CR4.FRED as not reserved
Date: Wed,  8 Nov 2023 10:29:44 -0800
Message-ID: <20231108183003.5981-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231108183003.5981-1-xin3.li@intel.com>
References: <20231108183003.5981-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when a guest
enumerates FRED, otherwise it is still a reserved bit.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/x86.h              | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e..1e5a6d9439f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -133,7 +133,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_FRED))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5184fde1dc54..60da8cbe6759 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -530,6 +530,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
+		__reserved_bits |= X86_CR4_FRED;        \
 	__reserved_bits;                                \
 })
 
-- 
2.42.0


