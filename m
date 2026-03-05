Return-Path: <kvm+bounces-72913-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHjZF5TCqWkhEQEAu9opvQ
	(envelope-from <kvm+bounces-72913-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:51:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 498192168B0
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:51:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8B825307DCBF
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E60E4301DA;
	Thu,  5 Mar 2026 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XHexieip"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD472428823;
	Thu,  5 Mar 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732692; cv=none; b=ZUM7g18QxUWzP16cS+REzwBWnYDvxrJ1iLK4V4yHujy07jmqOnYUSesUf4ciBxQcAR/24eG8PJZwQ+7htyk7tOSbhjbYY93x1zumgtz4fUAqpm5Kk1SXdNHI4uYb+ogRK1B3FtaUMzCb0U/YOit9+1eJcm905zgDtQ+7I+yi0bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732692; c=relaxed/simple;
	bh=DpdvT4loSRtnqsfH5MCvFkTqHKXLyWdscTJIsNn82z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ug/gmJE1FeM7S9Aa8qXbYOmC/LZoPasrE/AN0XBn3fGo3RX10D+ohZyg2v5FjNw9Bog9QYgexNSLHxSgpwgo7yM27+AEqXeVDODyZEsNookdDZyz/zf6o9R4g06zlrK5TZ2UYLvxiORD5IDpsTnPkQ0wqrxFmPR3g4g5xWmJ9FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XHexieip; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732690; x=1804268690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DpdvT4loSRtnqsfH5MCvFkTqHKXLyWdscTJIsNn82z0=;
  b=XHexieipkYAmqwtNIOkygGim3dlflrRNVtTfqTuDiiwPscNjjrG1O8Cu
   f7vGC+nj/wDwb0bkExxePCcRJlvsnGsyHhLxvLQ76M82zpALIIjfZW5B8
   ZFIcAR4dD7e8R85aCJYvDncFaA4G8ohJDfJL99pzjEaERQjTZ9YgBGPk8
   Z4l8viFoKvc8/EcE16GqFny0VHa4u5JZHyTIcI7Hkl5r/vXyK3J2yLQtH
   frQpI6pFMV2ym8DY144HHpExBF/lw1At1NQCl38PUG4Vp9sLIkIagLWP6
   j0BX91oLXNKxfDbnjTDuXmrzVNNjnkCxMXQs8aYMq7AB68Xo6vQixdA11
   Q==;
X-CSE-ConnectionGUID: xvX6Bre6SZ6x28QzwbWIbA==
X-CSE-MsgGUID: 5TKVszEmRgW+kZuI4MFZnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85301946"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85301946"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:47 -0800
X-CSE-ConnectionGUID: ZO75T+yNS26b3/26mqgKPg==
X-CSE-MsgGUID: w0SNUiuzRGCiEqHZ+rEwKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="222896514"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:43 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 22/36] KVM: VMX: Enable APIC timer virtualization
Date: Thu,  5 Mar 2026 09:44:02 -0800
Message-ID: <9a50051868ffc58a831e784f6fefe31968f062fc.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 498192168B0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72913-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Don't clear TERTIARY_EXEC_GUEST_APIC_TIMER bit unconditionally from
KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL when calculating supported bit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- Move the bit disable to the caller of adjust_vmx_controls64() to avoid
  compile time error because KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL is
  used for compile time check.
---
 arch/x86/kvm/vmx/vmx.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e665fc7f3377..b3974125a902 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2801,15 +2801,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 		_cpu_based_3rd_exec_control =
-			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL
-					      /*
-					       * Disable apic timer
-					       * virtualization until the logic
-					       * is imlemented.
-					       * Once it's supported, add
-					       * TERTIARY_EXEC_GUEST_APIC_TIMER.
-					       */
-					      & ~TERTIARY_EXEC_GUEST_APIC_TIMER,
+			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
 
 	if (!IS_ENABLED(CONFIG_X86_64) ||
-- 
2.45.2


