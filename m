Return-Path: <kvm+bounces-21092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2794E929EF8
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 11:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4E71B24931
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B561D75816;
	Mon,  8 Jul 2024 09:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g5xk6fUs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E236F2E9;
	Mon,  8 Jul 2024 09:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720430437; cv=none; b=kX4koq1RgrQ7XTZKM+3m3g0ORvKaEbLdz57jTcmM09E64mmW8v551+Z8mc6Ts0zOf2gjHWug6Uzra2t67eUgNiqn4wmaGPrbeltKbK7bW9V0oRyTYJQaQcIdmwPiZXZIX1y3BXUWj31wlI9eraR73DqUT97vBIpzyERmgnqjEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720430437; c=relaxed/simple;
	bh=gjQUODsu+gw87w2W9bA7NO+17xGjpExlTBwcwJx/TSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE2hHCWziTD/lHlMoKbitKvhop46bj50lsQOaeJ+OLljDLjtJKj9SxMdmV51zbFMlkS0TQqpKsfEP8HaApX17ldkS6hd2GhuMq7yhoxDfWvxC0wvLBZZTCvYx5m7En6jkBKyR9OpZX6IFY7D36TCNMUfJyEju8H86fDmqLuy0Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g5xk6fUs; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720430437; x=1751966437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gjQUODsu+gw87w2W9bA7NO+17xGjpExlTBwcwJx/TSc=;
  b=g5xk6fUsYE6tD+ytApm014u0gnHViIqkOPOMZcksax4P6nI2WkZGeQfa
   WeHD54zz3jbmQs0/x8ur20CPVaRufxmJ6F+7vRX2hswDexH7O++7eCgXK
   +a5yr1fZObTmCozWvYaZ2kVDviq4T+PzwcCMSrCh5VR4vN33aKmphebm1
   aIo4M2lqTNt5tX0rLSBrdgaS6ryyctBv+dam3NDBo9AizQ9JUR67cmco7
   cDOMg4r3aqiKvDYR+PvxmjRLusSKLa9J8xxSgjbh6GEhyP5Iq/jkdSOwb
   nMKvgI5A3oYd0jFDyopSIChTbxqHsRq1dSZPAnDtHbE2etoKWZdlXFo7Z
   A==;
X-CSE-ConnectionGUID: 6vfRm9XURNST3biiyWVuWg==
X-CSE-MsgGUID: 6tDBcvzJQBec4V/DlxEFUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="17577727"
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="17577727"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 02:20:37 -0700
X-CSE-ConnectionGUID: 55muiDxcRyifFniJIJ/xIw==
X-CSE-MsgGUID: 2ockUX/5THOYx3iIzwhPOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="51866645"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 02:20:34 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	michael.roth@amd.com,
	binbin.wu@linux.intel.com
Subject: [PATCH 2/2] KVM: x86: Use is_kvm_hc_exit_enabled() instead of opencode
Date: Mon,  8 Jul 2024 17:21:50 +0800
Message-ID: <20240708092150.1799371-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240708092150.1799371-1-binbin.wu@linux.intel.com>
References: <20240708092150.1799371-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use is_kvm_hc_exit_enabled() instead of opencode.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/x86.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 43a450fb01fd..ed55ff5d1ed5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3548,7 +3548,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 		return 1; /* resume guest */
 	}
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
 		return 1; /* resume guest */
 	}
@@ -3631,7 +3631,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	bool huge;
 	u64 gfn;
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f84c1f263e9b..ec9ebc258bf3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10168,7 +10168,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 		u64 gpa = a0, npages = a1, attrs = a2;
 
 		ret = -KVM_ENOSYS;
-		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
+		if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
 			break;
 
 		if (!PAGE_ALIGNED(gpa) || !npages ||
-- 
2.43.2


