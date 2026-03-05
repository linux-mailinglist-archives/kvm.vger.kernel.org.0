Return-Path: <kvm+bounces-72891-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qP7bJ9PBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72891-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8B9216767
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B8343170932
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAAD3EB7E0;
	Thu,  5 Mar 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OLu3ZWuk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810073E5EC4;
	Thu,  5 Mar 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732677; cv=none; b=p7+LNa7kxBxlnegPId2RjihYPYTcnRx1wZsD5plDKAioz0sjGxTODOmObYexSfUxMh1blRo+9FUF8XYFwMWlRS+w2eWxgN92lMHAfWThYq9HCqfeIRoParWzeqRDwuxI97nHJ94R4Fx1v5KW3KsFvb+PtVt7+wWOv1lAhD85Vko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732677; c=relaxed/simple;
	bh=Yow8OIG86TjnCjM50N/U6/GhpCYIQvgvpKOXPwEOWGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Szx/l+ZzAwV3i7PRJ92SareRzM0+QFMwbgKzES09fVKwUspqzdHNMAEdSKOYLWFIBCfjwHrJm1FWp8cDMJCuuxJEySJ/6KhrNbZlEO9vriT4YNESxtdrRV7CiFb2OUThZjFJnlA6i62TsaT0jzNKTUiGCS6LEGPf8I7yhO0Sgo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OLu3ZWuk; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732676; x=1804268676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yow8OIG86TjnCjM50N/U6/GhpCYIQvgvpKOXPwEOWGE=;
  b=OLu3ZWuk7QLpwhJ/tkr6aWSctbETXK77UuQZOBdHYzh9UUMF3sk2MTK3
   SHzRrHOcyGsV3YPiaTMlX14L5NPWwCfxEK9cZ3AldZE2UDX1DFl67Uw1G
   Vx1Fmj7+v5W+IHmN27E6JcsK7oxgijd/DLZr/AwRJGUoWDeUn2Nyr284V
   sRJAS3zePeZwaHb/ikbbihlxaUnDPCiqX/X1abhpG1/fKdbd0mW7dBd/L
   ydp3JSjmdsDM+Qludhdn7+coAI6K8JizheIQ7UNlGOckU3rKSeBsdyQHd
   qoAVnM+h2oKX4xLWV2J23MXhVv8tbWIvnFR9lAXfF5aUUAszofvxioJTU
   A==;
X-CSE-ConnectionGUID: PcR7PbocTtiAefMFsSPT9Q==
X-CSE-MsgGUID: xRnhXS4SQ2yPeOzyhiyMlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431553"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431553"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:34 -0800
X-CSE-ConnectionGUID: Rx5TImDLS1S9qWNQNjsutg==
X-CSE-MsgGUID: Dxx303+dTtGs4Yr7CpGvow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447853"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:34 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH v2 05/36] KVM: x86/lapic: Add a trace point for guest virtual timer
Date: Thu,  5 Mar 2026 09:43:45 -0800
Message-ID: <bdedde0a49beb4c148bfb24c281f44cebd40e8fd.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: ED8B9216767
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72891-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Yang Zhong <yang.zhong@linux.intel.com>

Add a trace point for changing the guest virtual timer, similar to the hv
timer case.

Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c |  5 +++++
 arch/x86/kvm/trace.h | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 10aa7040686f..abbd51c4da7f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1895,6 +1895,9 @@ static void cancel_apic_virt_timer(struct kvm_lapic *apic)
 
 	kvm_x86_call(cancel_apic_virt_timer)(vcpu);
 	apic->lapic_timer.apic_virt_timer_in_use = false;
+
+	trace_kvm_apic_virt_timer_state(vcpu->vcpu_id,
+					apic->lapic_timer.apic_virt_timer_in_use);
 }
 
 static void apic_cancel_apic_virt_timer(struct kvm_lapic *apic)
@@ -1923,6 +1926,8 @@ static void apic_set_apic_virt_timer(struct kvm_lapic *apic)
 	kvm_x86_call(set_apic_virt_timer)(vcpu, vector);
 	kvm_x86_call(set_guest_tsc_deadline_virt)(vcpu, ktimer->tscdeadline);
 	ktimer->apic_virt_timer_in_use = true;
+
+	trace_kvm_apic_virt_timer_state(vcpu->vcpu_id, ktimer->apic_virt_timer_in_use);
 }
 
 static bool kvm_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e7fdbe9efc90..ca9456955254 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1649,6 +1649,22 @@ TRACE_EVENT(kvm_hv_timer_state,
 			__entry->hv_timer_in_use)
 );
 
+TRACE_EVENT(kvm_apic_virt_timer_state,
+		TP_PROTO(unsigned int vcpu_id, unsigned int apic_virt_timer_in_use),
+		TP_ARGS(vcpu_id, apic_virt_timer_in_use),
+		TP_STRUCT__entry(
+			__field(unsigned int, vcpu_id)
+			__field(unsigned int, apic_virt_timer_in_use)
+			),
+		TP_fast_assign(
+			__entry->vcpu_id = vcpu_id;
+			__entry->apic_virt_timer_in_use = apic_virt_timer_in_use;
+			),
+		TP_printk("vcpu_id %x apic_virt_timer %x",
+			__entry->vcpu_id,
+			__entry->apic_virt_timer_in_use)
+);
+
 /*
  * Tracepoint for kvm_hv_flush_tlb.
  */
-- 
2.45.2


