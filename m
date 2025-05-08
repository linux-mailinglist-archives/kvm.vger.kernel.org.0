Return-Path: <kvm+bounces-45918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA3CAAFE75
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EEF016B7B4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4005A278E79;
	Thu,  8 May 2025 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DYx+xEVV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB52E2798E2
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716745; cv=none; b=HM0ICShV3IoSPdTIpYkRS5nY5WIbEh1l95KKnbaKY5QvouZCVoRCnjHqxcOGpj9uSyckj0f6evHW/gHtdVF62nWOgCoQWw8O3Ff9QR0bPU27uCeLG4UiyCWu2b/3UNr1IXVQXx5eLnb9CTXeCQKeBulxUPUcIhQpOYfMo83Pnwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716745; c=relaxed/simple;
	bh=GhYGnhWOapkYdaS8EeuvkjSNWWRHW/9wqQrOc0P9p7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rwUNxtOMy6JJ8pqROaKY+d36bTCJ4hcSLhR3NDCMEQoB/pTbbFQX8tbWykhG9S8WLF3wIjuPjY3niVOd6R4dYpc8pqkUyr3u4USMQVCJU7eEOH2mwqaiFBHM3DUCayOR/0wjXmoMeERBVoPHoDGsx/OMB0M0BwgljsYTYAkqiss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DYx+xEVV; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716741; x=1778252741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GhYGnhWOapkYdaS8EeuvkjSNWWRHW/9wqQrOc0P9p7w=;
  b=DYx+xEVVGk3e9JJZt/1mxBOyjDgaCzvyA9S7aF4WmY4eT+dm9PUbEFr0
   +xFY0YKlamG9YN5cdykfMxlK4jVen4fUb8tAw1bHG5XqfWuHuXpIOHbiF
   xPzlT91lS8nx52xdtL0WSLSs59OJlSxGZqOVsI/sNWoFDUUj6Kkb24Sex
   XgIdIXEtn6lsAErDh6k1kSZLzSP64lejcrSqhoChHjMwovviKuvTBiolH
   Tc58kSauO1n9HlL3CMrJYVnldOLKIgXYLDN5X8jUSL92LA8xD+ax+YAmy
   eu1AgWN1enTe9nvmfL12UC+kmwI09D6wOrDggrNgiLFpdIyu6T7yZRl68
   A==;
X-CSE-ConnectionGUID: EhE02I3YTaGqPnLd1zaTnQ==
X-CSE-MsgGUID: QJRBirBsS5qeFRVXMVBluw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888108"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888108"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:40 -0700
X-CSE-ConnectionGUID: gelSrk3wRBCXdcFNqMtVJQ==
X-CSE-MsgGUID: y1XWn8NqRvyFUpkoZAAVIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439901"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:37 -0700
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
Subject: [PATCH v9 15/55] i386/tdx: Implement user specified tsc frequency
Date: Thu,  8 May 2025 10:59:21 -0400
Message-ID: <20250508150002.689633-16-xiaoyao.li@intel.com>
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

Reuse "-cpu,tsc-frequency=" to get user wanted tsc frequency and call VM
scope VM_SET_TSC_KHZ to set the tsc frequency of TD before KVM_TDX_INIT_VM.

Besides, sanity check the tsc frequency to be in the legal range and
legal granularity (required by TDX module).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v3:
- use @errp to report error info; (Daniel)

Changes in v1:
- Use VM scope VM_SET_TSC_KHZ to set the TSC frequency of TD since KVM
  side drop the @tsc_khz field in struct kvm_tdx_init_vm
---
 target/i386/kvm/kvm.c |  9 +++++++++
 target/i386/kvm/tdx.c | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a537699bb7df..7de5014051eb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -869,6 +869,15 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
     int r, cur_freq;
     bool set_ioctl = false;
 
+    /*
+     * TSC of TD vcpu is immutable, it cannot be set/changed via vcpu scope
+     * VM_SET_TSC_KHZ, but only be initialized via VM scope VM_SET_TSC_KHZ
+     * before ioctl KVM_TDX_INIT_VM in tdx_pre_create_vcpu()
+     */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     if (!env->tsc_khz) {
         return 0;
     }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index c96e8eb7b8c2..56ad5f599d4b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -20,6 +20,9 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
+
 #define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
@@ -267,6 +270,28 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
         return r;
     }
 
+    if (env->tsc_khz && (env->tsc_khz < TDX_MIN_TSC_FREQUENCY_KHZ ||
+                         env->tsc_khz > TDX_MAX_TSC_FREQUENCY_KHZ)) {
+        error_setg(errp, "Invalid TSC %ld KHz, must specify cpu_frequency "
+                         "between [%d, %d] kHz", env->tsc_khz,
+                         TDX_MIN_TSC_FREQUENCY_KHZ, TDX_MAX_TSC_FREQUENCY_KHZ);
+       return -EINVAL;
+    }
+
+    if (env->tsc_khz % (25 * 1000)) {
+        error_setg(errp, "Invalid TSC %ld KHz, it must be multiple of 25MHz",
+                   env->tsc_khz);
+        return -EINVAL;
+    }
+
+    /* it's safe even env->tsc_khz is 0. KVM uses host's tsc_khz in this case */
+    r = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, env->tsc_khz);
+    if (r < 0) {
+        error_setg_errno(errp, -r, "Unable to set TSC frequency to %ld kHz",
+                         env->tsc_khz);
+        return r;
+    }
+
     if (tdx_guest->mrconfigid) {
         g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
                               strlen(tdx_guest->mrconfigid), &data_len, errp);
-- 
2.43.0


