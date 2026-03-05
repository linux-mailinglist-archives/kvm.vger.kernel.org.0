Return-Path: <kvm+bounces-72916-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAEFIOTCqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72916-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:52:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B0121691D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A6BEF3065121
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0704611EB;
	Thu,  5 Mar 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCOIktax"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBAF42F561;
	Thu,  5 Mar 2026 17:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732697; cv=none; b=sAD4h8yrPPw7Gx0gfNdvyui2sBHyTdMhwhX1LRudrDRYxV/3g2eT40yJ860EuOEv258jTrVibkDKF88KZXhI6ujW5LD4tmRSQ8jp20hsqtWJqq91/c3+wnaiZe0mJkmwmAqxyi3jw8KuFT19weiM4Rd50Xlw5facwpWFWxqbSVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732697; c=relaxed/simple;
	bh=zshUvpKmzz3SENkRLcVwh5m3fL3cvqsdLUmGu1zQKY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5qNQPYE0Ih0Bvq5JjK/SPfNB8YkqbK0EDjKbs/k5shWd41myD2tVMxcw0dm6H7ZJ2HmrlYOABfEusyqXQM6kJ6E7En7psa9rIQOaaT81Adnsgoy9H8UgzZefCSZiUtupNCxzu+R9Vud6r9tlKoUThoAKJ0Bb5NFZfeLYdfzE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCOIktax; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732692; x=1804268692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zshUvpKmzz3SENkRLcVwh5m3fL3cvqsdLUmGu1zQKY8=;
  b=gCOIktaxHI+bgTVouP4PAnKtRLiSLt1UGrrb3SRORgEpv5tvRA5dVB7o
   zxkVLxKuWJ7BV5IMDS40iNwHWV9kQ8wx16ZyUFJUDa/vrWjw2Iuv/AtQQ
   TuVj2rWiiaXDes01rd++f7VO5DMv0+sLP3cyOQdQebyGQhwUFKKwWfV9O
   VZcQVgQeC0DH6bA0u+369R3+gppUoaMblXHQkzwQtM5eyr6afsCfadK1V
   DjAbsoQ8fr9D6oaqOeYNUSuDdTxZO5uv9RA4uJoo5umXXuZ5g7nOCr5hV
   UZb+tkutW3JD18a5+4Q5xyWQde8LBLEzixS2uaDUYblxr5CabKdhSzfQH
   w==;
X-CSE-ConnectionGUID: +TkPqOzkSmOq/d3p9OeYJQ==
X-CSE-MsgGUID: OaewdEx7Qqyg1hq2+SX2Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85301961"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85301961"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:50 -0800
X-CSE-ConnectionGUID: FIuvQipAQYeLjs6dVl/RaA==
X-CSE-MsgGUID: ugB+JbBYSa26W+p8upaKHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="222896533"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:49 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 28/36] KVM: selftests: Add test vmx_set_nested_state_test with EVMCS disabled
Date: Thu,  5 Mar 2026 09:44:08 -0800
Message-ID: <ecae10483e8a1f6094cd2842090c638c930ee086.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: 23B0121691D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72916-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Hyper-V EVMCS capability, KVM_CAP_HYPERV_ENLIGHTENED_VMCS, is optional.
To increase test coverage, when Hyper-V EVMCS is supported, additionally
run tests with EVMCS disabled.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../selftests/kvm/x86/nested_set_state_test.c       | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/nested_set_state_test.c b/tools/testing/selftests/kvm/x86/nested_set_state_test.c
index 0f2102b43629..9651282df4d3 100644
--- a/tools/testing/selftests/kvm/x86/nested_set_state_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_set_state_test.c
@@ -401,6 +401,19 @@ int main(int argc, char *argv[])
 	else
 		test_svm_nested_state(vcpu);
 
+	if (kvm_cpu_has(X86_FEATURE_VMX) && have_evmcs) {
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
+
 	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.45.2


