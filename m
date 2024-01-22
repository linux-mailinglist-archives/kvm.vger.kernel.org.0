Return-Path: <kvm+bounces-6676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7010837864
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C9A6B265D1
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B5A7C0B1;
	Mon, 22 Jan 2024 23:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kt0kVQ1A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF6D74E37;
	Mon, 22 Jan 2024 23:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967767; cv=none; b=rfUQ7ww9rVftkaydPIR/G8ksgSSBgOdhZIXILPYlz2o9JhEMAAb9bpGeMwNXQyy6v33dKC/Q+pFh7Ph9q42BFq8T3osu4VVrABE2q4VAkce4lM20hmX25ajJEYUykh+fZjLpv9v86Ce2YavlY2ny1Ql1XCXy8RHLdrzJxJVTcME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967767; c=relaxed/simple;
	bh=tAZhX5hYYxeNuPqmnsVeBXmDWknqCmqZz4xkIwUygHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W50FZAM7Gi55ruHPYw70QSynBFcN2P6Lfb3LBLTP22W0MSJNZZg3A8KUf78+zEP3Z7omCJ+ZoMaxrF0vHCNUnUBZVzrMD4u2s7wTHYgF7AHVI17xeiaYj8otYSPoxBKBzDF6QlJpKyZg8dFeWB3aVPgABt5IjM/CFkMwbGwK2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kt0kVQ1A; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967765; x=1737503765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tAZhX5hYYxeNuPqmnsVeBXmDWknqCmqZz4xkIwUygHk=;
  b=Kt0kVQ1AeC36InflJjgxxd9H29YKRtYsuLKjsSf3iK6/56i79Rl4g/Hb
   nplumGwAjX8p/7heetXQSE9+YREG+LbygMRqpvHGKbfYZ2ViAdLpjf9VJ
   HsgIQbkZXwyFn5Jd+urhtWg/+dWO7KigZ9bh4aCjXx8idNsFujOb0/tYI
   1rE8yAFnIZ0AxzRiy9NLdRdzLPl1NJYtUcY6TzK3lMsI0ViFvzgU0KbB7
   +N884vMQxGFeXry5rwE7rohp5shTng1Pc25mPh+mG7BX2lBeooK/3ZEoO
   A2lpr6kD2asHK5FVQT6n7Poe1kZIAqIuw931cBgGgVAITnzNP5uln6PvS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217888"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217888"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817996"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:53 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 103/121] KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL
Date: Mon, 22 Jan 2024 15:54:19 -0800
Message-Id: <334cc24d982d9cb73fc7b6b8fcb6f2e1f9ea44ff.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

MCE and MCA is advertised via cpuid based on the TDX module spec.  Guest
kernel can access IA32_FEAT_CTL for checking if LMCE is enabled by platform
and IA32_MCG_EXT_CTL to enable LMCE.  Make TDX KVM handle them.  Otherwise
guest MSR access to them with TDG.VP.VMCALL<MSR> on VE results in GP in
guest.

Because LMCE is disabled with qemu by default, "-cpu lmce=on" to qemu
command line is needed to reproduce it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a75275f6f161..5a2b211a365c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1998,6 +1998,7 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 		default:
 			return true;
 		}
+	case MSR_IA32_FEAT_CTL:
 	case MSR_IA32_APICBASE:
 	case MSR_EFER:
 		return !write;
@@ -2012,6 +2013,20 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_FEAT_CTL:
+		/*
+		 * MCE and MCA are advertised via cpuid. guest kernel could
+		 * check if LMCE is enabled or not.
+		 */
+		msr->data = FEAT_CTL_LOCKED;
+		if (vcpu->arch.mcg_cap & MCG_LMCE_P)
+			msr->data |= FEAT_CTL_LMCE_ENABLED;
+		return 0;
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		msr->data = vcpu->arch.mcg_ext_ctl;
+		return 0;
 	case MSR_MTRRcap:
 		/*
 		 * Override kvm_mtrr_get_msr() which hardcodes the value.
@@ -2030,6 +2045,11 @@ int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		vcpu->arch.mcg_ext_ctl = msr->data;
+		return 0;
 	case MSR_MTRRdefType:
 		/*
 		 * Allow writeback only for all memory.
-- 
2.25.1


