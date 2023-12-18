Return-Path: <kvm+bounces-4726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA5681725B
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:08:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF6441F24649
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 14:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3087042399;
	Mon, 18 Dec 2023 14:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g8RTBr1n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02614988C
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702908355; x=1734444355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Gy1A3/GFh4TPqV/6cJydyIFDiQu1Xmai2B2mjJZfBQ=;
  b=g8RTBr1nq02Q2WxOMiISszszO6Qdh6AA9w5bKXnswvIPU/dMIGEnJVjc
   vMKkBwBQ+L0EEkoPF/H65Y3wlyQJeYbgi+f2JWieoNjnSSEMJmtpWlz0p
   Th6/uO1ek8qC8MDUcGtGpRdTMrG0npGMwQyb6CjMIq9avpLtjO0xIGZag
   PIg4SP7kSOyEUYKZopiC01pZqv8v90SaEcI06lsGOrkM/BXcwCWqRHwYK
   8N4TJSECTtFcNrSANnWxZQ/Z2TbnssotarfVo4rqMX0oijWJqtyLCUfaB
   P4bNThuSgWdGHK9T5UJgxqPN+6atw3NW1dTDm3SxpYA0C/p/tuMi0eXVi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2346370"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="2346370"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 06:05:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106957785"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="1106957785"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga005.fm.intel.com with ESMTP; 18 Dec 2023 06:05:50 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	yuan.yao@linux.intel.com,
	yi1.lai@intel.com,
	xudong.hao@intel.com,
	chao.p.peng@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH 2/2] x86: KVM: Emulate instruction when GPA can't be translated by EPT
Date: Mon, 18 Dec 2023 22:05:43 +0800
Message-Id: <20231218140543.870234-3-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218140543.870234-1-tao1.su@linux.intel.com>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With 4-level EPT, bits 51:48 of the guest physical address must all
be zero; otherwise, an EPT violation always occurs, which is an unexpected
VM exit in KVM currently.

Even though KVM advertises the max physical bits to guest, guest may
ignore MAXPHYADDR in CPUID and set a bigger physical bits to KVM.
Rejecting invalid guest physical bits on KVM side is a choice, but it will
break current KVM ABI, e.g., current QEMU ignores the physical bits
advertised by KVM and uses host physical bits as guest physical bits by
default when using '-cpu host', although we would like to send a patch to
QEMU, it will still cause backward compatibility issues.

For GPA that can't be translated by EPT but within host.MAXPHYADDR,
emulation should be the best choice since KVM will inject #PF for the
invalid GPA in guest's perspective and try to emulate the instructions
which minimizes the impact on guests as much as possible.

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1..a8aa2cfa2f5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5774,6 +5774,13 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.exit_qualification = exit_qualification;
 
+	/*
+	 * Emulate the instruction when accessing a GPA which is set any bits
+	 * beyond guest-physical bits that EPT can translate.
+	 */
+	if (unlikely(gpa & rsvd_bits(kvm_mmu_tdp_maxphyaddr(), 63)))
+		return kvm_emulate_instruction(vcpu, 0);
+
 	/*
 	 * Check that the GPA doesn't exceed physical memory limits, as that is
 	 * a guest page fault.  We have to emulate the instruction here, because
-- 
2.34.1


