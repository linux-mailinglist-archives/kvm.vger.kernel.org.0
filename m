Return-Path: <kvm+bounces-70043-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFaEGBw9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70043-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB74DD82B
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 64BDC31621B2
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71453D7D92;
	Tue,  3 Feb 2026 18:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UptHThwQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C73D6678;
	Tue,  3 Feb 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142664; cv=none; b=D84r/ipnTVxwJqCS/6hBezqAPVauYG8cso6q27tRrWW7KFbr7T+9xjdI03GrM7ew0MB85obak60yF3dwM1T8i17V7+EcZvvPY0Uyl6Scx2QTA5LY57yoSfutxp9bgs+YMSPjd9KikvYKq8rvDWzUcUdl/OMddGDy0WCo+R/FOMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142664; c=relaxed/simple;
	bh=ygxoguN3hTv5ACLQU4KD3m9xKTSxYHGGA0so5e174bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXiQA46LdolOyxiK7U+705f4iQ1pQhIfdSzh/HJlir5tUV7m9QNOmh2x092JAkTBxmStuyJP3pNiWsYww9MELMWK5vuUErKS/7F8O4kCLOjOJ0Z02rsTdSdZ7DTis9MdA8Te0DfD78BVrPdic1h0/V9AKQx0qdS4Atws8NHSJ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UptHThwQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142663; x=1801678663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ygxoguN3hTv5ACLQU4KD3m9xKTSxYHGGA0so5e174bw=;
  b=UptHThwQ+eGNMzqlufjIzVX56l4FSEIJ6O0/bASzM2UtWqqDTpArD2Dr
   5M33t6liGDcn5pXXrCe28oJJrU7WP0rFtMHj1wh3FWrYOevmpwRACD9sC
   MyL756nIXhPb2wLtzOn2drRMrRVS5B789jwL8ctbLiOaJI+2bfYSRPol9
   lB22z2kFG9S8Ei0dbJlGJw4X56jYVo4R7miBZ0/9lsgskA7rEKD/ppPfy
   4uNH0+J+m2iJwXSt+94Ob135u8Pk+ZXtLOYvoUGyaNiCwGZiQ1usCxOHT
   wYb0K0ZIMIHylJZPUS+Q1WCJ36a+iWjBKzv4Acs80efx9NEiR/UqvVppC
   g==;
X-CSE-ConnectionGUID: nC+cDCJ5Sh+0p6S/aL2qbw==
X-CSE-MsgGUID: zx0m2uofRm2O04qsBQYuwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745801"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745801"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:42 -0800
X-CSE-ConnectionGUID: qNJiH//jR5O/W/PFqnJftQ==
X-CSE-MsgGUID: 06dt9Ib7QDCwwpBYqfKZ2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605482"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:41 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/32] KVM: nVMX: Update intercept on TSC deadline MSR
Date: Tue,  3 Feb 2026 10:16:55 -0800
Message-ID: <6f8a75e4848e03b84370a57520cc2a7fad799ed2.1770116051.git.isaku.yamahata@intel.com>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70043-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: EEB74DD82B
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

When APIC timer virtualization is enabled, the hardware handles the access
to the guest TSC deadline MSR, not by the VMM.  Disable/enable MSR
intercept on TSC DEADLINE MSR based on the APIC timer virtualization bit of
tertiary processor-based execution control.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3e02dee38e9c..191317479d5e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -595,6 +595,26 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
 	}
 }
 
+static inline void prepare_tsc_deadline_msr_intercepts(struct vmcs12 *vmcs12,
+						       unsigned long *msr_bitmap_l1,
+						       unsigned long *msr_bitmap_l0)
+{
+	if (nested_cpu_has_guest_apic_timer(vmcs12)) {
+		if (vmx_test_msr_bitmap_read(msr_bitmap_l1, MSR_IA32_TSC_DEADLINE))
+			vmx_set_msr_bitmap_read(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+		else
+			vmx_clear_msr_bitmap_read(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+
+		if (vmx_test_msr_bitmap_write(msr_bitmap_l1, MSR_IA32_TSC_DEADLINE))
+			vmx_set_msr_bitmap_write(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+		else
+			vmx_clear_msr_bitmap_write(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+	} else {
+		vmx_set_msr_bitmap_read(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+		vmx_set_msr_bitmap_write(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+	}
+}
+
 #define BUILD_NVMX_MSR_INTERCEPT_HELPER(rw)					\
 static inline									\
 void nested_vmx_set_msr_##rw##_intercept(struct vcpu_vmx *vmx,			\
@@ -701,6 +721,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	prepare_tsc_deadline_msr_intercepts(vmcs12, msr_bitmap_l1, msr_bitmap_l0);
+
 	/*
 	 * Always check vmcs01's bitmap to honor userspace MSR filters and any
 	 * other runtime changes to vmcs01's bitmap, e.g. dynamic pass-through.
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 2a3768a194fe..9ca1df72e228 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -281,6 +281,11 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
 }
 
+static inline bool nested_cpu_has_guest_apic_timer(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has3(vmcs12, TERTIARY_EXEC_GUEST_APIC_TIMER);
+}
+
 /*
  * if fixed0[i] == 1: val[i] must be 1
  * if fixed1[i] == 0: val[i] must be 0
-- 
2.45.2


