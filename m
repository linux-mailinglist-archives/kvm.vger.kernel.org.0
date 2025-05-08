Return-Path: <kvm+bounces-45907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D12BEAAFE50
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 040D0985F32
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE32B27C877;
	Thu,  8 May 2025 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SScoqGvf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5283A27B4FC
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716707; cv=none; b=JAap+Gjdnb/SELt8+zNhH9XjnZUHaTvFUVmcC3+y+bIW7NWZnr9jSlPgzO1HSqPqc+m6UX1LQmkAn3bYeit0U+dbI/kLhvzkyNnrPnD192dYpJGMlfC6GsgzSNv7WfOWn5AL3hz16izCiSczyVBngYSfr1LHnCZxZewlB9R/VRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716707; c=relaxed/simple;
	bh=AcCHUB60MLs++YSIZQ5c7AByRdXhthnV6ddQlujaz9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1tnmCkDRF2Yck+fLHs/+mGmECUlBv5dAZFH2cqrmJNCkLdvSl4cHL3XRaO3R2hr4mzM9W4C4v7POOubeZnDWxVJaZThuul/re78DYUK3tDv2vz4z6dUs1kqEmCChgZquEMw9FI341V7JWbm7VY6XqM7zdG+rxR0UoskHAbFw3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SScoqGvf; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716706; x=1778252706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AcCHUB60MLs++YSIZQ5c7AByRdXhthnV6ddQlujaz9c=;
  b=SScoqGvfqXNBMtqVL4iYwMZCL5LlEJLo4FX5MWO64ZMKC4YejdHD47Y5
   pFpD/S8Qdh4HF422hBgfh8UfkxtlsG9GyarPGQmSEAul6N+PSLVntwUEK
   bPxYUnvSB3HHFeSgIyRw6/Fq7hwySlHMAcYoALXQz5n4v1XxwEpaSXt1w
   9juFzLX845UY1vQaByNy8wx7QxMm2Dp8K+v4uCFRVIrFWbd3EInPkRFMz
   AYRqnH3nDlldQ4rf3NtmVQnxpIpErrPJXKAWtvfNnztEvZzvOKrh+KTlq
   Np4heBxiMGK0KoMoasOzhIWy9TWvRqYCnLQdAaPj8JHt/6Njfv4aC3aOJ
   g==;
X-CSE-ConnectionGUID: Jy1BV6B+SKW/wdbs6KMCZg==
X-CSE-MsgGUID: AEsz2xDbQEqg+grajEL2ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888001"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888001"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:06 -0700
X-CSE-ConnectionGUID: Z8B3cQzRQWCHqljreJQeOg==
X-CSE-MsgGUID: WuwS3sMLSiCQLh4KngiXRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439759"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:02 -0700
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
Subject: [PATCH v9 04/55] i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
Date: Thu,  8 May 2025 10:59:10 -0400
Message-ID: <20250508150002.689633-5-xiaoyao.li@intel.com>
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

Implement TDX specific ConfidentialGuestSupportClass::kvm_init()
callback, tdx_kvm_init().

Mark guest state is proctected for TDX VM.  More TDX specific
initialization will be added later.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v6:
 - remove Acked-by from Gerd since the patch changed due to use
   ConfidentialGuestSupportClass::kvm_init();
---
 target/i386/kvm/kvm.c | 11 +----------
 target/i386/kvm/tdx.c | 10 ++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4f1cfb529c19..1af4710556ad 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3206,16 +3206,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     Error *local_err = NULL;
 
     /*
-     * Initialize SEV context, if required
-     *
-     * If no memory encryption is requested (ms->cgs == NULL) this is
-     * a no-op.
-     *
-     * It's also a no-op if a non-SEV confidential guest support
-     * mechanism is selected.  SEV is the only mechanism available to
-     * select on x86 at present, so this doesn't arise, but if new
-     * mechanisms are supported in future (e.g. TDX), they'll need
-     * their own initialization either here or elsewhere.
+     * Initialize confidential guest (SEV/TDX) context, if required
      */
     if (ms->cgs) {
         ret = confidential_guest_kvm_init(ms->cgs, &local_err);
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d785c1f6d173..4ff94860815d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,9 +12,17 @@
 #include "qemu/osdep.h"
 #include "qom/object_interfaces.h"
 
+#include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
 
+static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
+{
+    kvm_mark_guest_state_protected();
+
+    return 0;
+}
+
 static int tdx_kvm_type(X86ConfidentialGuest *cg)
 {
     /* Do the object check */
@@ -49,7 +57,9 @@ static void tdx_guest_finalize(Object *obj)
 
 static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
+    ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
+    klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
 }
-- 
2.43.0


