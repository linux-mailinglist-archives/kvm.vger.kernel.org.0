Return-Path: <kvm+bounces-70055-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IITrAbY9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70055-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:25:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA50DD8C9
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A295531062B9
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF183ECBFC;
	Tue,  3 Feb 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEiw8wzS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4883E95A4;
	Tue,  3 Feb 2026 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142670; cv=none; b=iUSeLq5wh4GLSJwIhX8TinnBWTZ+DJDB8SiboL4BahtgVfBdLsbll6eTR1vr5wDHZ1qMacnGEQ/8Mr+vCTZGcW+ammuIafyrz+cDBydqRiIhEuylcl4U8Qu6yejU9+tfsRksIu8eSXouNczURvBqkB/d8ZoNXTQmS5fAhMWwMHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142670; c=relaxed/simple;
	bh=GagopKe8p6DQVgcXl32pCqybRoXB7F0rArot8lPxFz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8ALv0QPbKNs0zROMtWdZFQ5EI9ed/WrzL33h6J2oatf45NixZNTFGXHgyEUfZnPrblKkb0zwviJ2XX5z3HIsmaiNEnVZBb1Gr+Nt8Eu0qklwsKFOrUVhMo14DgMH0Qmm8bNLvmUC5ksBNG93QB9o4fSBmkinDUjvA6gvCClVAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEiw8wzS; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142670; x=1801678670;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GagopKe8p6DQVgcXl32pCqybRoXB7F0rArot8lPxFz4=;
  b=FEiw8wzSkLv0V1pJon/Dt5rvDNj8iZm9OYcwaFF85AtbRBe6yQYKMjgh
   HTUHskdAacTub3emFptHouV2lyOwyRaO2JI0umnA/+4ML+n6424m0TXcn
   TCgJSRZKoKOcaCVSLsbQv/80QYKj2YhwO2XPIOMOHUcwHc+bRhiuToSdj
   BIAkF9DL3oGu+MMVeMlCO6DWPfk/JsN4RTdwYtDbxsk6m3rMfwIGUGF81
   lxzoNk75BLrkr3t3Aq8B/zO5QXUQF8YqVlDz4Jwwm+uxfaos9vZHC4rwD
   WRR7HQwiTAlD7ADbAAnxk8KaAQ4jAIk4SWyJlbXRtGjZOaiMgXzMf8QAz
   g==;
X-CSE-ConnectionGUID: YJ8s4vh1TIyv+3D0dE6w1w==
X-CSE-MsgGUID: X+fLN5jsTIK1mjdk6um7Ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745847"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745847"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:46 -0800
X-CSE-ConnectionGUID: edytMeF7SVmamA8GNScu6Q==
X-CSE-MsgGUID: U2dz4GLdTjO6xLeTDDe8zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605519"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:45 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH 22/32] KVM: VMX: Introduce module parameter for APIC virt timer support
Date: Tue,  3 Feb 2026 10:17:05 -0800
Message-ID: <aa16814721131adc3b133945a3437436fd544eb8.1770116051.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70055-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9CA50DD8C9
X-Rspamd-Action: no action

From: Yang Zhong <yang.zhong@linux.intel.com>

Introduce a new module parameter, apic_timer_virt, to control the
virtualization of the APIC timer in KVM. The primary improvement offered by
APIC timer virtualization over the preemption timer is the passthrough of
MSR_IA32_TSC_DEADLINE to the VM. This passthrough capability reduces the
number of VM exits triggered by MSR write operations, thereby enhancing the
performance of the virtual machine.

The apic_timer_virt parameter is set to true by default on processor
platforms that support APIC timer virtualization.  On platforms that do not
support this feature, the parameter will indicate that APIC timer
virtualization is not available.

Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5496f4230424..76725f8dd228 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -118,6 +118,9 @@ module_param(enable_ipiv, bool, 0444);
 
 module_param(enable_device_posted_irqs, bool, 0444);
 
+static bool __read_mostly enable_apic_timer_virt = true;
+module_param_named(apic_timer_virt, enable_apic_timer_virt, bool, 0444);
+
 /*
  * If nested=1, nested virtualization is supported, i.e., guests may use
  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
@@ -2799,7 +2802,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
 
-	if (!IS_ENABLED(CONFIG_X86_64) ||
+	if (!IS_ENABLED(CONFIG_X86_64) || !enable_apic_timer_virt ||
 	    !(_cpu_based_2nd_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
 		_cpu_based_3rd_exec_control &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
 
@@ -8748,6 +8751,9 @@ __init int vmx_hardware_setup(void)
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
 
+	if (!cpu_has_vmx_apic_timer_virt())
+		enable_apic_timer_virt = false;
+
 	if (enable_preemption_timer) {
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 
-- 
2.45.2


