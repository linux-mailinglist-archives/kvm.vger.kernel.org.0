Return-Path: <kvm+bounces-55294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1E4B2FAD3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD795621D3E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E36369980;
	Thu, 21 Aug 2025 13:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AtZksvAI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C062353366;
	Thu, 21 Aug 2025 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783133; cv=none; b=glLAxAUs8IpD+iVQmeyLYBm/QVLyN+xK0QsYyvB6QYvmZ6U6xeOhex5p1JYlymfh9mreg8flZe9vQi79WgoL2Kt/21ZMF20939xuaspBjaNc3BeU3Gh7Y+AbrRv57E8o5bE3iaf4FaobFyHlTfDNpbn+t0yrE3v/b69jh5LRlRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783133; c=relaxed/simple;
	bh=nf0inpYa+sfc44de2O1vh89NSTPegEjMA0E7W8+i5AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEqWsQZSe5OFRY0rYL9feXM2i3ZdgAI++1NqmFpV/sPvVAiTeBw4UP1brqzVlC3rxjmifQZ4WnKIGYIz0JNiMfi3uoq9q2GMWKzvnGStRWchEpVX1KQPhXP38zVak3k6y5Gy7osmJ3v1JFDJSUxtp53HW589kymub4iwfW0QAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AtZksvAI; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783132; x=1787319132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nf0inpYa+sfc44de2O1vh89NSTPegEjMA0E7W8+i5AE=;
  b=AtZksvAIGNSZtFd9Xi2DqEdvUi33cOrQupSrf3GPpNSVDsf0EmGq15ja
   HYfRAFfVUyXOYbjanIDxPLZ/BLP7gzksfk1S6hpsZSCXsT6h0iVunVMoW
   CQrj9tp4cHynd9sAobYJIV4vF7A3LxOp8LFyPy+XffPVCNcwvxARAJZ89
   JVVLmbr4n+oGpiqv2Lnk4e/XNu3NCt7rIDtxIE2ATMPTcHNvWd8M0yfMF
   vzBuaiozcWCUKPuHYb4RbgKFUa7uF3CfPhLZ6oe/UKukTtQsHkFWx0OLg
   EClpibtZVoGD/fQkOu/ge41MLum1oETy4Q0JEXqdXOXsRMpqHWiqmu9bY
   g==;
X-CSE-ConnectionGUID: X5ik+wptSVC7hoCKu590sQ==
X-CSE-MsgGUID: W2/Q6t7fT6KyxkAC8eMrNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446239"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446239"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:02 -0700
X-CSE-ConnectionGUID: hR9w0QgeSuCeEL2BVYAH9A==
X-CSE-MsgGUID: dLXOcJHETPenMJY/YxIVtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285444"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:00 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 20/21] KVM: nVMX: Advertise new VM-Entry/Exit control bits for CET state
Date: Thu, 21 Aug 2025 06:30:54 -0700
Message-ID: <20250821133132.72322-21-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise new VM-Entry/Exit control bits as all nested support for
CET virtualization, including consistency checks, is in place.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v13: new
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index edb3b877a0f6..d7e2fb30fc1a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7176,7 +7176,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7198,7 +7198,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_CET_STATE;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
-- 
2.47.3


