Return-Path: <kvm+bounces-70059-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AK8ZMuc9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70059-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:26:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D59BDD8EC
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 041BF314EFA9
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3912E3EF0A9;
	Tue,  3 Feb 2026 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hxX8nFLR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E5D3ED120;
	Tue,  3 Feb 2026 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142674; cv=none; b=tg9O+b7RyXS52CI6T29LStOizM2s2HFyIn3cQCsgKTvFxpNKZyVzlGu7zjMdfs20JbdFxt4qwozMdivxYW9Mj4LMxiHdNZOkPC/wPdZAtwVr91RK/5OkK8k6Fu1qH/6QXgBDObTNeFB3gpL5AJ4i9pJ2mTaOH2+p/rZnGm72jiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142674; c=relaxed/simple;
	bh=MTUlsvIH1AkRzwWJPF1ATD3Q1XzZXcMIgmLGy8/GHBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS1bkC7aMt2Q9sVW8E+kFTRWxk/vZ00aAeUXgE0UGOUFCQPAWLKGOaBaJmsT1L0ePzBCIc1RQePBXe65+HLszvoyv+DCKegCuAzcIPQyInLTWNI3UFS8T0krth/DJwdBHMbwEvgLQ41gFeqJWxFLaiTvI8rZqJ9CF/s+S0pKZEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hxX8nFLR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142673; x=1801678673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MTUlsvIH1AkRzwWJPF1ATD3Q1XzZXcMIgmLGy8/GHBA=;
  b=hxX8nFLR//vXwEsUtnXx9l7jP4tlB1RaE3gSgxF6//A2Ig8vE/8mdZfp
   ivKTQikX8Zpc3ozYn4OpRG1Ad7hXUP/K7IPOk7+y0VWtf4up1JCcz8PO/
   JDR5A+c8swsejJO+BSoy7kNdNpm/yn0dMnF81zKMnCoo0mRG2UxmY7ZtN
   t8ekvSwCoZWkYOtdN7H3FDAY/ZN2aQRK65808oa9D+kbe9aARlua0gKmZ
   LKFW8+vvKQTc9CYBm0+lD7IYKLsngPZdVD847UKQ0jhwT3+JLPcfllpnL
   4QfM+lmqZ6IxdoqEnJwHbzpVQD8QBSyNHsQS417ARZm9peNWnWXopwanm
   w==;
X-CSE-ConnectionGUID: xJ1nz92OTH6u7isXBCqrfA==
X-CSE-MsgGUID: VXDfuw4HSheLehZQw7znpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745867"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745867"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:48 -0800
X-CSE-ConnectionGUID: Rm0jqLTXTgq1ii+5qBwmHA==
X-CSE-MsgGUID: mIfTUGxNT/SWtA3Sj0DQ2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605538"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:47 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 27/32] KVM: selftests: Add test vmx_set_nested_state_test with EVMCS disabled
Date: Tue,  3 Feb 2026 10:17:10 -0800
Message-ID: <8935e63039b4cfc9a343a2ed7dc7bc25b392fa33.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70059-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2D59BDD8EC
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Hyper-V EVMCS capability, KVM_CAP_HYPERV_ENLIGHTENED_VMCS, is optional.
To increase test coverage, when Hyper-V EVMCS is supported, additionally
run tests with EVMCS disabled.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../selftests/kvm/x86/vmx_set_nested_state_test.c    | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
index 67a62a5a8895..cbf6a8ff626e 100644
--- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
@@ -298,6 +298,18 @@ int main(int argc, char *argv[])
 	test_nested_state_expect_einval(vcpu, &state);
 
 	test_vmx_nested_state(vcpu);
+	if (have_evmcs) {
+		/*
+		 * KVM_CAP_HYPERV_ENLIGHTENED_VMCS can be only enabled.
+		 * Because There is no way to disable it, re-create vm and vcpu.
+		 */
+		have_evmcs = false;
+		kvm_vm_free(vm);
+		vm = vm_create_with_one_vcpu(&vcpu, NULL);
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_VMX);
+
+		test_vmx_nested_state(vcpu);
+	}
 
 	kvm_vm_free(vm);
 	return 0;
-- 
2.45.2


