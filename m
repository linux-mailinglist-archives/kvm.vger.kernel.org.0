Return-Path: <kvm+bounces-33262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 806E19E88D7
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 556121885CDC
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DEE21364;
	Mon,  9 Dec 2024 01:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7c57Ovj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6DF78C9C;
	Mon,  9 Dec 2024 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706348; cv=none; b=Aty+7Hl59eMtcI2NlpM74SJpW75p/kH0Puxq39t0+t6peVYcMAgwaCTgXFn/N8aMrsBkZjUtW/mRjlxDlWHdAJsdDuO6MOjMfmgtaq81W8mCr8HGVReKt9yAYm9tbvHkjCqbNSHY3qy5+MHleaUrGhYRoH1TCmHoCFNSH76PJD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706348; c=relaxed/simple;
	bh=FlmjHVF36tMNoRxEdqDyWr2wygz2UcKHXxq3qf5pJo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIp7yyj9V7ljRvitD1q96FB1o/IEejBiPbES24AqOHq/nE/ONAT2WErEDRCsqQOWEHsukOwXjBFLDwWfodGAlA1STHuuNEFna804nV+cJda6/a4PBnvI0M9z+Eo+JYKeuWaeIWzEysWO3LupTYHbyNW7fn6FRcRlGjtG/EldfkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7c57Ovj; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706347; x=1765242347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FlmjHVF36tMNoRxEdqDyWr2wygz2UcKHXxq3qf5pJo4=;
  b=B7c57OvjpOKMAZ0GELRg12ED+JKceX/XiLuGALFFiwiPn+IEowQNn7T5
   6K504/mk+rWUjF/+ICimFqALZWsN0DgQDc26krUWj1emyA1+cYzeQQxCF
   WRsu2Co1FX+GLP2NyMvKYoO6RQlpKHFdG/rV/xbBF+waqr8lKdDWcbKU7
   Yeuh7KajuRcnbB4780hFn+pFEFxSCnHOKs2JRYuXWiTpqjV1zfIR7R6ct
   qGh3E+/M5RGv9NcRioMNzYvSlMgxnDyXm3tJrWnCEhcZG7uyIJOBo+fVa
   FbNaooscXLT3koiFXnZqcXAPog32d7++ML/8VCGM/N6kkLzbcbBx7mJvH
   w==;
X-CSE-ConnectionGUID: /GiBd0EUSdOoZNS4wi8PhQ==
X-CSE-MsgGUID: BCfaC8sLSla3XOVgnJ6BWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833692"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833692"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:46 -0800
X-CSE-ConnectionGUID: NOPjcuZEQAC2AsNfkMXmbQ==
X-CSE-MsgGUID: CMv1aqGWRwWiSr0LuU/9IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402420"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:42 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 03/16] KVM: TDX: Disable PI wakeup for IPIv
Date: Mon,  9 Dec 2024 09:07:17 +0800
Message-ID: <20241209010734.3543481-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable PI wakeup for IPI virtualization (IPIv) case for TDX.

When a vCPU is being scheduled out, notification vector is switched and
pi_wakeup_handler() is enabled when the vCPU has interrupt enabled and
posted interrupt is used to wake up the vCPU.

For VMX, a blocked vCPU can be the target of posted interrupts when using
IPIv or VT-d PI.  TDX doesn't support IPIv, disable PI wakeup for IPIv.
Also, since the guest status of TD vCPU is protected, assume interrupt is
always enabled for TD. (PV HLT hypercall is not support yet, TDX guest tells
VMM whether HLT is called with interrupt disabled or not.)

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: split into new patch]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts breakout:
- This is split out as a new patch from patch
  "KVM: TDX: remove use of struct vcpu_vmx from posted_interrupt.c"
---
 arch/x86/kvm/vmx/posted_intr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 8951c773a475..651ef663845c 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -211,7 +211,8 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
 	 * notification vector is switched to the one that calls
 	 * back to the pi_wakeup_handler() function.
 	 */
-	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
+	return (vmx_can_use_ipiv(vcpu) && !is_td_vcpu(vcpu)) ||
+		vmx_can_use_vtd_pi(vcpu->kvm);
 }
 
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
@@ -221,7 +222,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 	if (!vmx_needs_pi_wakeup(vcpu))
 		return;
 
-	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
+	if (kvm_vcpu_is_blocking(vcpu) &&
+	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
 		pi_enable_wakeup_handler(vcpu);
 
 	/*
-- 
2.46.0


