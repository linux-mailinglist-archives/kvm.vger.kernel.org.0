Return-Path: <kvm+bounces-45917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E169CAAFE6A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D7639C46FA
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9F6281371;
	Thu,  8 May 2025 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUcClRpt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984F9280CD1
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716739; cv=none; b=UXumzar8xl4TRwZQwS90tXRaMqvHwIVgkkqcG7nPsL3WKBkKkQhC39oudxLDedJA2LzgbGMNgLmoWx8b5PRwbdSdT+fC1E8R9fAVtmV1Jq2Y0RdLnCXI2oPWvde9/DcYzcT2uwdSGfrzHNdQXVTVVsrtvlfNvWcjApa+f4a6ezk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716739; c=relaxed/simple;
	bh=f2K2N6DrwE73hXtHrzTwih79rFdx7FYrVysyYjXVDOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N35ZgmjovtDu3I2YQHmpXwj4ywVgGIw08BwZEYn0yqj4lL8tP9PAN3g35ZMIRdGa7ds14KsyTuVOGXKt2+2YnbiO6DlimSfekQ0pXQxvK2zb1KRnuaqOhlnPLsYPRn58kvMCzJU+tEVFLgw0rym0ob52b8avZpBRQts59zGYdDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUcClRpt; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716737; x=1778252737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f2K2N6DrwE73hXtHrzTwih79rFdx7FYrVysyYjXVDOk=;
  b=mUcClRptO73AFrJT+3hq986bLxurxP8tLaXaoUTOxp8qh28hqU1VGXHp
   zFEvS6JiiLqz8SHcPrSgCvke8QGGyiq7i0aMuHaO3ZnSB+54j8WELjnZk
   G+edYB79sLjbrgEQFqc0HfK5JMpkC47Wf//j2QuOY23A3aRx+OU1yWq3C
   qqBSDVY87yCdmI6BIneDVt5O5MF16M01EHjEQcnSbF3hp5f8bUhQK0Qh6
   jF03GjuZPPiaxHuLnaOdsWG2RGBnOW6RFl6UmRI8wFUb9k2OfOAj74fOM
   Idrm6Roa5HvLIIBvd3vyK5H6uqTumZKSpvGPy4l+wg/wGAw2nG04rSdZO
   g==;
X-CSE-ConnectionGUID: KEnu1MBLTvuyXwEHFEr/mw==
X-CSE-MsgGUID: ioigft/xT2WDlEWyIuBlBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888101"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888101"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:37 -0700
X-CSE-ConnectionGUID: HiGESqzOTWmFJyvG1GoH3g==
X-CSE-MsgGUID: fi6EydKOSSqeER/4W+dKGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439892"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:34 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 14/55] i386/tdx: Set APIC bus rate to match with what TDX module enforces
Date: Thu,  8 May 2025 10:59:20 -0400
Message-ID: <20250508150002.689633-15-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

TDX advertises core crystal clock with cpuid[0x15] as 25MHz for TD
guests and it's unchangeable from VMM. As a result, TDX guest reads
the APIC timer at the same frequency, 25MHz.

While KVM's default emulated frequency for APIC bus is 1GHz, set the
APIC bus rate to match with TDX explicitly to ensure KVM provide correct
emulated APIC timer for TD guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 target/i386/kvm/tdx.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 39fd964c6b27..c96e8eb7b8c2 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -254,6 +254,19 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
+    if (!kvm_check_extension(kvm_state, KVM_CAP_X86_APIC_BUS_CYCLES_NS)) {
+        error_setg(errp, "KVM doesn't support KVM_CAP_X86_APIC_BUS_CYCLES_NS");
+        return -EOPNOTSUPP;
+    }
+
+    r = kvm_vm_enable_cap(kvm_state, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+                          0, TDX_APIC_BUS_CYCLES_NS);
+    if (r < 0) {
+        error_setg_errno(errp, -r,
+                         "Unable to set core crystal clock frequency to 25MHz");
+        return r;
+    }
+
     if (tdx_guest->mrconfigid) {
         g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
                               strlen(tdx_guest->mrconfigid), &data_len, errp);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index e472b11fb0dd..d39e733d9fcc 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -16,6 +16,9 @@ typedef struct TdxGuestClass {
     X86ConfidentialGuestClass parent_class;
 } TdxGuestClass;
 
+/* TDX requires bus frequency 25MHz */
+#define TDX_APIC_BUS_CYCLES_NS 40
+
 typedef struct TdxGuest {
     X86ConfidentialGuest parent_obj;
 
-- 
2.43.0


