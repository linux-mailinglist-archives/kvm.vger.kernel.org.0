Return-Path: <kvm+bounces-38928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51763A404C4
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68EE97AF2E2
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468191FF1BF;
	Sat, 22 Feb 2025 01:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R5bXlJYq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77FF1FAC42;
	Sat, 22 Feb 2025 01:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188461; cv=none; b=LFYn5JqkOi/1nYZ7lGwrJ3DLMrHWfqeIF8AwHodt7lpHI+90JwiIwxy/rP+s+IpO0F4+l8bRNPLRhsPdPzSvlioW0fXAqRGtnK6YtO628CEJ9t8OKz4aYmk0s/6M4PUE2dv2MMBlsa9MD5PNOAuUp7yiSeqynRoQZm+Ce7ic/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188461; c=relaxed/simple;
	bh=ySYH9hbc9/2+JlRdr+9eFJsonG3NTdIu0QBzzBYw10M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fD85rlxmqPs02nsFZkBlwVmcuhmQj7Ng8l1lnItwwGzBBp9fSFkTJqUKkQ+1B2Rb+4bUY+6qx2lnZTiLqaLozTNRj3llfJxFrSUPeptUiarQu2/ZDLLVaDlBoo/75BbG5Vxdq5F8qiyNkS82XiWtlcgAjskoh0xh0FOA6xqvujg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R5bXlJYq; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188460; x=1771724460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ySYH9hbc9/2+JlRdr+9eFJsonG3NTdIu0QBzzBYw10M=;
  b=R5bXlJYqYYjZI/XhJ3sH0Bo80adRzo55UVcRh/iTjtsN1689ZvqtCHQs
   5innFvBEjdZTmxkWg3Lo2p2WC+b4B7AVS/9jYJx2MhjzKrskkCQeH43m3
   BxnoAyd1yiSz4t0T1PUO5cZyc5n0VlPZMpBPwCphIBHTtqXRQr+D2lks8
   zDoZ1S0i+ycYI5et4dArghpU3iaprio0e2eM8ZE2xbiEqddMuXMFV0BSU
   kKgEaNGdXvVtRwhYLAY5p+2H4sE1e5t+wwtSwALMcZrDFDOwjV1SHoKMf
   sYPj56bS901W+MKLpHTFkE8Osm0sx8pjuWrIUUp5sveggaPaOVljkkou8
   A==;
X-CSE-ConnectionGUID: k6xzC0iFR4Wk/b2fZvmXeA==
X-CSE-MsgGUID: YBvnLFxAQjeODrNUVI0Y/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893256"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893256"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:40:59 -0800
X-CSE-ConnectionGUID: ECe0ivhOTha0/Hs8hDk7xg==
X-CSE-MsgGUID: hWZ/yPtEQTmdZlO9tMeRGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370235"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:40:56 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 2/9] KVM: x86: Move pv_unhaulted check out of kvm_vcpu_has_events()
Date: Sat, 22 Feb 2025 09:42:18 +0800
Message-ID: <20250222014225.897298-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014225.897298-1-binbin.wu@linux.intel.com>
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move pv_unhaulted check out of kvm_vcpu_has_events(), check pv_unhaulted
explicitly when handling PV unhalt and expose kvm_vcpu_has_events().

kvm_vcpu_has_events() returns true if pv_unhalted is set, and pv_unhalted
is only cleared on transitions to KVM_MP_STATE_RUNNABLE.  If the guest
initiates a spurious wakeup, pv_unhalted could be left set in perpetuity.
Currently, this is not problematic because kvm_vcpu_has_events() is only
called when handling PV unhalt.  However, if kvm_vcpu_has_events() is used
for other purposes in the future, it could return the unexpected results.

Export kvm_vcpu_has_events() for its usage in broader contexts.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace v3:
- New added.
---
 arch/x86/kvm/x86.c       | 11 +++++------
 include/linux/kvm_host.h |  1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 62dded70932d..8877d6db9b84 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11133,7 +11133,7 @@ static bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 		!vcpu->arch.apf.halted);
 }
 
-static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
+bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 {
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
@@ -11142,9 +11142,6 @@ static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	    kvm_apic_init_sipi_allowed(vcpu))
 		return true;
 
-	if (vcpu->arch.pv.pv_unhalted)
-		return true;
-
 	if (kvm_is_exception_pending(vcpu))
 		return true;
 
@@ -11182,10 +11179,12 @@ static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 
 	return false;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_has_events);
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
+	return kvm_vcpu_running(vcpu) || vcpu->arch.pv.pv_unhalted ||
+	       kvm_vcpu_has_events(vcpu);
 }
 
 /* Called within kvm->srcu read side.  */
@@ -11321,7 +11320,7 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	 */
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
-		if (kvm_vcpu_has_events(vcpu))
+		if (kvm_vcpu_has_events(vcpu) || vcpu->arch.pv.pv_unhalted)
 			vcpu->arch.pv.pv_unhalted = false;
 		else
 			vcpu->arch.mp_state = state;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bfe3140f444..ed1968f6f841 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1609,6 +1609,7 @@ void kvm_arch_disable_virtualization(void);
 int kvm_arch_enable_virtualization_cpu(void);
 void kvm_arch_disable_virtualization_cpu(void);
 #endif
+bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
-- 
2.46.0


