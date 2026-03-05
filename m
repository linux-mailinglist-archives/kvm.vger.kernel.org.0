Return-Path: <kvm+bounces-72893-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CyhJgfCqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72893-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F31B7216794
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1800D319B3C6
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEDD3E5ED5;
	Thu,  5 Mar 2026 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgLSfh+5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF6D3E5592;
	Thu,  5 Mar 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732677; cv=none; b=A789GpREYRKniVXyBEFcabspUcaThwVYBScnsS6xONofE4GYeWJzjNICyF22CVuv0JnOkeGkwqUjliF3CEbJxFD4oQJNWrCaAIw/ppJSUsXfSI/l/wWDCNCteo572tLo/00gBvus2Ji5B7mOYtfvVABSmd9owprgLF8KXzNf2rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732677; c=relaxed/simple;
	bh=xB2Kfqn84lfYRfoS8Qtq4/aK7PLAYxPYq1braCsQrkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsXVhwrn1xHJgXlUKmR0BvdIri6Zyk0br8nB4NBWteSHal5Nni0zJrW+Mo2kkGLUQfHlQW9sLoI6mlsRABw9PKbRzCh0MvuKbXdscgHophdGPqmo8M1HxgcwdbDIid6PPQMxP0Inq3gdr4DEiLDArzjIQN+cSv/EVX2ZnemZr2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgLSfh+5; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732676; x=1804268676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xB2Kfqn84lfYRfoS8Qtq4/aK7PLAYxPYq1braCsQrkg=;
  b=KgLSfh+5g2rsvt3fKV9ie2JxlKEefudeeiIQ0PiyR4gJ9l2M/h+fQwqt
   uT0xduG67JArRAzHe2oCnYbEQlM5C8dsmhXe7yrvALIcI9lakxwLzF1Et
   Y1V2IPoBdecDGmW1mR3a1VW1iwB2/uETCO1GLJCafVP8qs5/cm27sGuuO
   5rWY7gUjK+PajEFm4fqBYYkCGSCzjTvIifzYBTDzd/RsbwyXe92WG2Q3i
   hzIjBz2dOxya3Wf8kpP/6sAGNm0FmN+XacuovOiavQ+/g4Q/dN9h5aJw7
   hnyCCNdyD35rZgxCCO1uejtrNEmQlqsDmGv7WM6mo5HGhGknA+U489wTl
   Q==;
X-CSE-ConnectionGUID: NT/W91gxRSahBVFInqsTcA==
X-CSE-MsgGUID: afFbghvJR5KfawJRPNwPxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431548"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431548"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:34 -0800
X-CSE-ConnectionGUID: dXOB0RGwRHCLoBCHodR6cw==
X-CSE-MsgGUID: 768vz48QRYKESR4DVzZsPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447850"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:34 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/36] KVM: x86/lapic: Wire DEADLINE MSR update to guest virtual TSC deadline
Date: Thu,  5 Mar 2026 09:43:44 -0800
Message-ID: <3f740669e391708e4420d91bd7f7d61a40b84463.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: F31B7216794
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72893-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire userpace read/write (KVM_GET_MSRS, KVM_SET_MSRS) of TSCDEADLINE MSR to
the vendor backend to update the VMCS field of GUEST TSCDEADLINE and
GUEST TSCDEADLINE shadow.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ab59722e291e..10aa7040686f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2802,6 +2802,10 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu) || !apic_lvtt_tscdeadline(apic))
 		return 0;
 
+	if (apic->lapic_timer.apic_virt_timer_in_use)
+		apic->lapic_timer.tscdeadline =
+			kvm_x86_call(get_guest_tsc_deadline_virt)(vcpu);
+
 	return apic->lapic_timer.tscdeadline;
 }
 
@@ -2814,6 +2818,8 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	apic->lapic_timer.tscdeadline = data;
+	if (apic->lapic_timer.apic_virt_timer_in_use)
+		kvm_x86_call(set_guest_tsc_deadline_virt)(vcpu, data);
 	start_apic_timer(apic);
 }
 
-- 
2.45.2


