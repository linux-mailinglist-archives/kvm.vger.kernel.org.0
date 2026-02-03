Return-Path: <kvm+bounces-70038-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UEJZFEM8gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70038-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:19:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F22DD780
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 548CD30E54EC
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863713D4110;
	Tue,  3 Feb 2026 18:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WsPrWpeg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E55E369207;
	Tue,  3 Feb 2026 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142657; cv=none; b=jK2pYM3P9n5ByvXECw1i7YJ0aft1x7FQH8oAZcuXRBWmoLhbF3mCqx/SekDKQpb7RpM94G610Wugu0QMJD0kSH28HVbswAxpYmBMG36yDUh8xv7sVZ+1RnTZ5b3XRXapHB7rwkeuzXBjzVELIm08wYOxTZ6zbSy9if9MgQhHC3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142657; c=relaxed/simple;
	bh=v6JWNFCO9hbIhS9f+Hpe5Tv6VmFe0s0qenV2T/lAeic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isYok3R80px6bdUVlg3hFTqpoZ29c4tZIjubTg6y/r9UGQM78xaJuzDLp/ViR0jc2rVbUo/8j/gnMn6bCr/IDRD/SyRpayvNRHKnqVqz4KnPFXkJsnIXZJg/Qr9AsMgm8pEifc/YXVVYWkpSt8CyYfEBd03f/T8PtAdNqkC97Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WsPrWpeg; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142654; x=1801678654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v6JWNFCO9hbIhS9f+Hpe5Tv6VmFe0s0qenV2T/lAeic=;
  b=WsPrWpeg/fIHLh1odgBI84Lf6yLtxdipcOc8yufLZ1mefETINpKf2aVe
   GDy2+JMOnaAqoUwnQszeIPVRwSSZ2HgpEEnE0tOvFnqIb31BHtV3g7kar
   ZQMTq5UBNcwC96W+sOygDliL9ujs110fbuP1QktPhpmA5rkr9ysLe1OlO
   JOF9BRJYTYz/OMsFp7nZgPYc9BSdSZNaWBYNlawnzecQtYK4ZMxKhb9EM
   gGkS7wjP8o/NNy243WOZcGj4ZaklqD0KPh6JjX8fMDdQqsRki21BB9N5z
   rqp9Dk9x76RyDw8dYWAIugGtOn0WC6+2Q55Y+SgS0WFF6lyzExpueltds
   w==;
X-CSE-ConnectionGUID: hmWxtI3aQ4+IreKqVjtiAw==
X-CSE-MsgGUID: YWgcCo5ZSCOQuvUM8dxF6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433175"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433175"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:34 -0800
X-CSE-ConnectionGUID: bPAhYS24Sv+GIrYxK4XqwQ==
X-CSE-MsgGUID: bErh3sbBRQSHtmvodQMvcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727487"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:34 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH 05/32] KVM: x86/lapic: Add a trace point for guest virtual timer
Date: Tue,  3 Feb 2026 10:16:48 -0800
Message-ID: <4dfe5a137204456cd984fb0be7c1041898a3a91a.1770116050.git.isaku.yamahata@intel.com>
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
	TAGGED_FROM(0.00)[bounces-70038-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: B5F22DD780
X-Rspamd-Action: no action

From: Yang Zhong <yang.zhong@linux.intel.com>

Add a trace point for changing the guest virtual timer, similar to the hv
timer case.

Co-developed-by: Yang Zhong <yang.zhong@linux.intel.com>
Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c |  5 +++++
 arch/x86/kvm/trace.h | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 080245f6dac1..837f446eea41 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1848,6 +1848,9 @@ static void cancel_apic_virt_timer(struct kvm_lapic *apic)
 
 	kvm_x86_call(cancel_apic_virt_timer)(vcpu);
 	apic->lapic_timer.apic_virt_timer_in_use = false;
+
+	trace_kvm_apic_virt_timer_state(vcpu->vcpu_id,
+					apic->lapic_timer.apic_virt_timer_in_use);
 }
 
 static void apic_cancel_apic_virt_timer(struct kvm_lapic *apic)
@@ -1876,6 +1879,8 @@ static void apic_set_apic_virt_timer(struct kvm_lapic *apic)
 	kvm_x86_call(set_apic_virt_timer)(vcpu, vector);
 	kvm_x86_call(set_guest_tsc_deadline_virt)(vcpu, ktimer->tscdeadline);
 	ktimer->apic_virt_timer_in_use = true;
+
+	trace_kvm_apic_virt_timer_state(vcpu->vcpu_id, ktimer->apic_virt_timer_in_use);
 }
 
 static bool kvm_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e79bc9cb7162..649d06f87619 100644
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


