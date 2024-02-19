Return-Path: <kvm+bounces-9024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1C3859D87
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A06AB1F21753
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4112636129;
	Mon, 19 Feb 2024 07:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jA3xbpzU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FB52D043;
	Mon, 19 Feb 2024 07:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328873; cv=none; b=XXcuN/9/2XncxFWqz4tgWRaft6VMVikSgPHTynrHCdf2ZUfNCUmbedMp6PHuwJQnmCSBnwlro8MA0LGnMW1yJ3aGTASpSgMeygJQ8SLkuUlgEP2DT01ogzmj/tpK3oov4Kw36llaiNHthiXOXnsOJjz+pm8XOSQy2fb+4IKjnMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328873; c=relaxed/simple;
	bh=zsZWtSrIsMEG2dQWduuhWlHPy9Ug6FFiV6Z1WKrBC90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJL1TvKZOawukuIYQ7KASiL8qjSBK659VV30GmkVKswomv+OQpup8H1R3H2fw18RbRUTxUQ/DEmoY4eGZC58mP7QpdVtziHE0ZtNrnGa9ywVtKO3YM4c8Sw7IFLc9/IIeXri8qj4OpVWtAY9WisMt2U665YfVKuhoAj1VvYNXkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jA3xbpzU; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328871; x=1739864871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zsZWtSrIsMEG2dQWduuhWlHPy9Ug6FFiV6Z1WKrBC90=;
  b=jA3xbpzUmS+PRuFNyIQoD6+R1sIadpvmfEbsDKehGjJTNmyZ5y5+QT/K
   tKaTHdGgtPQ5Ct1Ofnyu7L8ctAJdyU73p/wwvYSKt+tWRKUF7tsEqQprd
   4iiRh+P9rRQo/CcVzoAbgXJ54TnczmQ/XMmfiguvVjo3bvlgazyxathrz
   Gk1zzgM/FvaNzasxTRip9vrDbKpDbq6umav1+o++/4KAvwOPj1vaAQoh5
   fwpSLSCJ1GZLQ9KYvhkQFGRLHWKf+aBe+CYoKCompiHTYqYdFyhdl8Mf+
   8UUmeJKbcpXAOaoJxl3hpVn6Ah/LtMoK7YzPKmqJ6n0Ot2JZ4KawkivED
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535092"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535092"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966092"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966092"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 12/27] KVM: x86: Report XSS as to-be-saved if there are supported features
Date: Sun, 18 Feb 2024 23:47:18 -0800
Message-ID: <20240219074733.122080-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
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
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cbd44f904ba8..9eb5c8dbd4fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1464,6 +1464,7 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_XSS,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -7388,6 +7389,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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
2.43.0


