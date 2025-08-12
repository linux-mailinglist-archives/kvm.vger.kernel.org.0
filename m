Return-Path: <kvm+bounces-54474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0125B21B03
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D29781A22960
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287102E3712;
	Tue, 12 Aug 2025 02:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQctbW2o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D355D26529E;
	Tue, 12 Aug 2025 02:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967390; cv=none; b=guRPvrxAQ7LFNK+j1vzfkSNvUx5jL3KyVGNRpdKFX2BoE386ktxE0LzpbnmWKpWCy4hDC7w1CKAUlYfm3y4VD4tqgOwGc8YCPt07cjYuA4z6g5V1Lk8syzILs4MfNkdOcOrlVqwtbDTqwvoqtcdbp4ZrwJYQRFa1Fm43OIFhtmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967390; c=relaxed/simple;
	bh=F3k+MYbu7ZOn0p/0kCjrCIf8V5yPNvy8jKQh5YApCvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQod1jZTb1I6JmKcZrdv90JIirH7JnX7O5Ot0n/YIhm129V2pAydOExB+V6xXlO2IT+AXxCz8Bpxu9SCsNWzepKcMoaCaP1elD48pHjzbjsvh+uC+/WBls+/lTTZMTDuFOsS08Z6t/CaI+G5kl0tri3S29U/tbZn2A8vLO5GbXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQctbW2o; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967389; x=1786503389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F3k+MYbu7ZOn0p/0kCjrCIf8V5yPNvy8jKQh5YApCvQ=;
  b=KQctbW2oHTFUv/7wj8BfmBRbr8+WfFCbns/TOzlLjkL9aMAm3R0H7RSg
   G6ddlv+/SAtLGL5fHcoakykRvBPad0UhaOVmpCnUoV67AWh0OLjA2Yp3j
   WUZKI/2jzsOxN5/lP2ptB8i/zvq5y+q00Pk6hkEr1fa5sEseYvcGNeg+f
   OLELA2Da4i0GzlnRCWeSeQFras0Gu2YxpS01OXg2wzzV1/RTGwU1x+y0r
   dme6sBacMP/VpFTY5JMIESb7ezjZDw8Xp+GmRmJCNdD5Fgj6VS+eWFuUv
   cqQiT/Ji+N1IqePcs/3GdzF/MLgqQV6THjqHEWcmIxJW1K9IFwvEhjHGL
   A==;
X-CSE-ConnectionGUID: 1yO4Z3ZAQVyB3z8Z1RYCpw==
X-CSE-MsgGUID: XlouCPtjSoqHOeg60pYjFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100438"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100438"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:23 -0700
X-CSE-ConnectionGUID: 6wsujkrgT16mCQij2E8mgg==
X-CSE-MsgGUID: I/opl937T7yHkMyrIgBSSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321222"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:23 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 02/24] KVM: x86: Use double-underscore read/write MSR helpers as appropriate
Date: Mon, 11 Aug 2025 19:55:10 -0700
Message-ID: <20250812025606.74625-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Use the double-underscore helpers for emulating MSR reads and writes in
he no-underscore versions to better capture the relationship between the
two sets of APIs (the double-underscore versions don't honor userspace MSR
filters).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09b106a5afdf..65c787bcfe8b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1932,11 +1932,24 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 				 __kvm_get_msr);
 }
 
+int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	return kvm_get_msr_ignored_check(vcpu, index, data, false);
+}
+EXPORT_SYMBOL_GPL(__kvm_emulate_msr_read);
+
+int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	return kvm_set_msr_ignored_check(vcpu, index, data, false);
+}
+EXPORT_SYMBOL_GPL(__kvm_emulate_msr_write);
+
 int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
 		return KVM_MSR_RET_FILTERED;
-	return kvm_get_msr_ignored_check(vcpu, index, data, false);
+
+	return __kvm_emulate_msr_read(vcpu, index, data);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_msr_read);
 
@@ -1944,21 +1957,11 @@ int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
 		return KVM_MSR_RET_FILTERED;
-	return kvm_set_msr_ignored_check(vcpu, index, data, false);
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_msr_write);
 
-int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
-{
-	return kvm_get_msr_ignored_check(vcpu, index, data, false);
+	return __kvm_emulate_msr_write(vcpu, index, data);
 }
-EXPORT_SYMBOL_GPL(__kvm_emulate_msr_read);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_write);
 
-int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
-{
-	return kvm_set_msr_ignored_check(vcpu, index, data, false);
-}
-EXPORT_SYMBOL_GPL(__kvm_emulate_msr_write);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {
-- 
2.47.1


