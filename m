Return-Path: <kvm+bounces-38943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6E0A404E9
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F28EC701ADF
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA50202C53;
	Sat, 22 Feb 2025 01:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+X2Jg4C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C98201266;
	Sat, 22 Feb 2025 01:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188801; cv=none; b=YDVHwHgyzibRZqtHHailguDSD2O+H6h1O3rUniEW4w+UTIBvAC0/ax29rc7fianuUyq+UwRxfM2yaghF3qkuMqZIgFuh/IV4QMjhOvEWkQOjiNYCoZe4gcJK7UaJh4f5a4JslFlUpSzCQxG0i5/jYLAkcWL05J5IOCwhcYC28fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188801; c=relaxed/simple;
	bh=6bMkGhNFdhzlupZHZT6aIepQK8ccOzu9xdGx9GnQsJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiW793B2O2gNGTeIwRbq9Rlid0ITIc88Z7wuQaHVSizoKuto3HA46n5qYj2zUry61YIX8LThCPq5CGXw/++sdv3tKceXZcDC5avePzGwCgGRwEivfBqhmz08MsREDdtm/rpE+pcU3HBsO2NwqbcT4ZcYl08nPZr9CiNeC10w/D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+X2Jg4C; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188800; x=1771724800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6bMkGhNFdhzlupZHZT6aIepQK8ccOzu9xdGx9GnQsJg=;
  b=d+X2Jg4CwEnwh90X8foesbzALPGuceH8s77S6x8wIBc97aRqQ2y1jOug
   BTdleI0jjphQFYLiC7TiAE2OVmb58PMM+kyHDjHn3hsvbEeoz/hJmiAxU
   IJyyZq+6+R5I5KCVUx+uHDi2+tlWyFfSptXgU02lLzyMvw8l/RPeV6CQw
   nlsjyn1kaZvSC3+1+n68qhEuKxPvV2LZBJU4Ge0HM+Dp52QS0z7zTz5xF
   uzp4CvhoYonW1eioTqR/uC44legig8LkVrbrNXnQkXqlrN9R9BOLYwChS
   9tX7DFqi3B7XXvVOj/Doh0ism7OMDXCsUai5yN7w7oPmcdICNt28d8F83
   Q==;
X-CSE-ConnectionGUID: o6QQMrzoROm/0v8zQ2Ia3w==
X-CSE-MsgGUID: HhRHLRJ0QzqU56xUAlS5rg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449027"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449027"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:40 -0800
X-CSE-ConnectionGUID: CWfAwgaRRWujPjLSMjJE6g==
X-CSE-MsgGUID: 0Rr7jHvdRkm82LtR9q2Iuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621635"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:37 -0800
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
Subject: [PATCH v3 05/16] KVM: x86: Assume timer IRQ was injected if APIC state is protected
Date: Sat, 22 Feb 2025 09:47:46 +0800
Message-ID: <20250222014757.897978-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

If APIC state is protected, i.e. the vCPU is a TDX guest, assume a timer
IRQ was injected when deciding whether or not to busy wait in the "timer
advanced" path.  The "real" vIRR is not readable/writable, so trying to
query for a pending timer IRQ will return garbage.

Note, TDX can scour the PIR if it wants to be more precise and skip the
"wait" call entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v3:
 - Fix whitespace (Chao)

TDX interrupts v2:
 - No change.

TDX interrupts v1:
 - Renamed from "KVM: x86: Assume timer IRQ was injected if APIC state is proteced"
   to "KVM: x86: Assume timer IRQ was injected if APIC state is protected", i.e.,
   fix the typo 'proteced'.
---
 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index bbdede07d063..e78b1d223230 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1797,8 +1797,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	u32 reg;
 
+	/*
+	 * Assume a timer IRQ was "injected" if the APIC is protected.  KVM's
+	 * copy of the vIRR is bogus, it's the responsibility of the caller to
+	 * precisely check whether or not a timer IRQ is pending.
+	 */
+	if (apic->guest_apic_protected)
+		return true;
+
+	reg = kvm_lapic_get_reg(apic, APIC_LVTT);
 	if (kvm_apic_hw_enabled(apic)) {
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;
-- 
2.46.0


