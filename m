Return-Path: <kvm+bounces-6759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E50D0839F69
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21AC71C21315
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429AA17744;
	Wed, 24 Jan 2024 02:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jzIb/tY7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC46171BC;
	Wed, 24 Jan 2024 02:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064161; cv=none; b=AhAZ8YpcKlUrH8BU8kq4v7E01JpX10M8otlCPOTYD1UsiKH6ixnXFgWJ4riH9UgOHtlqIKe32Ffxn1Ed5jBJ0alY0m7NvLkhNSDeQTG34ybRwyrdC6iY2VGTr6BicxtKMcIQU+ed5K/HROCJ0NiXkFEl5wVPDY2QyIgge4qC/hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064161; c=relaxed/simple;
	bh=cxpPX3Wn0VREKtBeuHc/MZkj33xyM0sqH6UvdE/wBRo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T/bpQ2Oq51itYJDTgjul5LlKMC08SDBTmFcf9CWE1eJ02yX6DerK18H1yKipuwvIWoeFHhkudW2cmJ1nIvOflsvO6Xb0DpeOm3E6RspZZ3pyo6OapaERN2IuXJBPaKN73LOrCdrlhjbHfqX4nrKxBIAaFy1EWWYeIKkkJKMUjus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jzIb/tY7; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064159; x=1737600159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cxpPX3Wn0VREKtBeuHc/MZkj33xyM0sqH6UvdE/wBRo=;
  b=jzIb/tY7JY9v72xklDRzq6stw171yM3YJ5nXSAYV9G0enQNgUIvFBKtP
   AyOtGxxbqekdBKOtVoxU4auKKNWpi/616w404wtiwnkaFanvy9I17BqGN
   yBgHnRRUY4dwGDGcTuBIr55A2x8jRzNUZ01NtoRfN2206o9x4rhDJdtv5
   fKfhjK5F+ir3wm/OgoGzwK1fdTyR9N6tQVwaTLinq2aPCc4+Aqvs6x00e
   +uYeEhYiBPBVjWNd2H1ZNHCP66T8BBWF13ZEycWjJDHiU5mH0ScRepCWr
   KCSpmqplOj6PzcDzFXcI5KJYbTm1FXYgsPLemNj8dilsPiayaNFTkRX8/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586478"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586478"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825855"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:35 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 10/27] KVM: x86: Refine xsave-managed guest register/MSR reset handling
Date: Tue, 23 Jan 2024 18:41:43 -0800
Message-Id: <20240124024200.102792-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tweak the code a bit to facilitate resetting more xstate components in
the future, e.g., adding CET's xstate-managed MSRs.

No functional change intended.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e7dc3398293..3671f4868d1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12205,6 +12205,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 		static_branch_dec(&kvm_has_noapic_vcpu);
 }
 
+static inline bool is_xstate_reset_needed(void)
+{
+	return kvm_cpu_cap_has(X86_FEATURE_MPX);
+}
+
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_cpuid_entry2 *cpuid_0x1;
@@ -12262,7 +12267,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
+	if (vcpu->arch.guest_fpu.fpstate && is_xstate_reset_needed()) {
 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
 		/*
@@ -12272,8 +12277,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
 
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+		if (kvm_cpu_cap_has(X86_FEATURE_MPX)) {
+			fpstate_clear_xstate_component(fpstate,
+						       XFEATURE_BNDREGS);
+			fpstate_clear_xstate_component(fpstate,
+						       XFEATURE_BNDCSR);
+		}
 
 		if (init_event)
 			kvm_load_guest_fpu(vcpu);
-- 
2.39.3


