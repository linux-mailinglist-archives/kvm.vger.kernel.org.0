Return-Path: <kvm+bounces-55281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 915DAB2FAB0
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21E881720AD
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBE4341AAA;
	Thu, 21 Aug 2025 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wkb/QSdH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DD633A013;
	Thu, 21 Aug 2025 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783125; cv=none; b=CMAiOBcUMt17kv1rwCKDpOBv6cO1Bksitfa4u6cqRtsF4XeUjYLJbunYbogiQ2Fb9MoYoj99L2ikJwPO301vso2p9uFOo0VLbZE6/rcZKkGb/gd9Drklt2sAggnB3MM8AwavHv3hkYPo8gyV0nhnKbwLCf/jLvxn470ls6nCwSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783125; c=relaxed/simple;
	bh=wpvcrJHwYBLC5/dciOZjQsOznM/ZeVV2wM2oj/cDelA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWzusRXO1RXp7O/e7uCjpBqi4RdBUAG8tJ3WjAyzqLQiGDI2HI6cNE56FyG5Uuj3uEu31zK3wa+GmdjG9ODMKBgO5gEcFKHbbdRCj2hiTtgukQuBfvAERWmCTg5sj6SUxPiilYN1eJm5TwgrCuFO4BZCPFh+RaWj9ekntIOKUts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wkb/QSdH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783123; x=1787319123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wpvcrJHwYBLC5/dciOZjQsOznM/ZeVV2wM2oj/cDelA=;
  b=Wkb/QSdH71n9CbsmYPyafqWVmbZgRggYB4goMwBpEi9kBkAhMVRCAihz
   iUnlXsSKOE5EEi0/1gWc0JIcUsrxOrENL9ETOaaZbmUZqR4jpV3Z69IBA
   1qNjN1zpcXkc7w9puIngwm3Gn4sexxJ++yRVz23j4QYW0W+1gLZ3gx5kX
   McrL8taMcrL41DCqOZIYDwbBex7W95GB/7GNFvYNWn4FH+xy778VF9Grv
   MiU8y2Db0/DUCFb2TPv52f/oFDuqvv1AYunLHuLLnUD8fSnaqT6ub1Qcg
   u1GSje3u+SABySn/Y3FwZi9DoD6bOOuvS4UCdpwEl9QqDkQCh7M2uit7D
   g==;
X-CSE-ConnectionGUID: 1jqeFnb4TP6nsifyFOhE8w==
X-CSE-MsgGUID: ecGEhA6uSQ6RKNwmpxg5GQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446112"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446112"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: pkxZEeUYR3OSTz3/Z6fH9Q==
X-CSE-MsgGUID: NqhHaLQvQS++c2hG3JREbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285438"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:57 -0700
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
Subject: [PATCH v13 18/21] KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
Date: Thu, 21 Aug 2025 06:30:52 -0700
Message-ID: <20250821133132.72322-19-chao.gao@intel.com>
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

Add consistency checks for CR4.CET and CR0.WP in guest-state or host-state
area in the VMCS12. This ensures that configurations with CR4.CET set and
CR0.WP not set result in VM-entry failure, aligning with architectural
behavior.

Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51d69f368689..a73f38d7eea1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3111,6 +3111,9 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
+	if (CC(vmcs12->host_cr4 & X86_CR4_CET && !(vmcs12->host_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if (CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
 	    CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
@@ -3225,6 +3228,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
+	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
 	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
 	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
-- 
2.47.3


