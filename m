Return-Path: <kvm+bounces-2410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 297797F6D78
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8D3D281D3E
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8559D1803E;
	Fri, 24 Nov 2023 07:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BvfzpAqK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB4A10F6;
	Thu, 23 Nov 2023 23:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812725; x=1732348725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5NwdFWB8PYqE9sGf4NOEiLQEKXylN+xEDDw+kzJt/SQ=;
  b=BvfzpAqKXlFPm/yaTspJK3HzWJgd/tkCjhIx3LP7Lkq0OOyuA6vyB1yi
   ybavQSg41I+2osqGuwqIdVcuG88lvkhZkRgJtQEE4Td7sOl9YuHMqeIeS
   Jp/cwAsw6Uf8vW9eusCL7srgTe45dI3rjp+HEuJD2+ANtN9UrTNYJLsVQ
   ZZOwODip4CVINxXIwStSQhte1NPlabuP9Suw3FwisvpRFc3W/Mwb0BPDg
   l6TaWyqUOTUr/WIkX1kmNUNo3Y3QqpkkXGEp2+6Uji26n93ztRmwimU6Q
   OaF6ZxX+o3nfPK+bP8jcl6m33YTv6ezw76qMMqOc+a7ehDRPET/yBBING
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872334"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872334"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629826"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629826"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:39 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v7 12/26] KVM: x86: Report XSS as to-be-saved if there are supported features
Date: Fri, 24 Nov 2023 00:53:16 -0500
Message-Id: <20231124055330.138870-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add MSR_IA32_XSS to list of MSRs reported to userspace if supported_xss
is non-zero, i.e. KVM supports at least one XSS based feature.

Before enabling CET virtualization series, guest IA32_MSR_XSS is
guaranteed to be 0, i.e., XSAVES/XRSTORS is executed in non-root mode
with XSS == 0, which equals to the effect of XSAVE/XRSTOR.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 360f4b8a4944..f7d4cc61bc55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1464,6 +1464,7 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_XSS,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -7317,6 +7318,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
 			return;
 		break;
+	case MSR_IA32_XSS:
+		if (!kvm_caps.supported_xss)
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.27.0


