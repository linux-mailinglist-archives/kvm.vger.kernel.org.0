Return-Path: <kvm+bounces-39445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DD7A470DB
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D92016EFDC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68B2184540;
	Thu, 27 Feb 2025 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ka/p5YOi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B7017A310;
	Thu, 27 Feb 2025 01:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619154; cv=none; b=MlmcWGgdrIr/3KXWq9E4pxJBi+J8AAxMf8HVOhPRUG3FdzxHk1GtKXLyF/70r5Mm6u7uSci9HNO0U+Mkp2i5nEAwRL4ILEYH1M8jlKsWmFS8PygBwAnSqJv8JKEf+bwfdkVdHnVbY4f+iLMibfEFgwc0Kt6sDsXO49jrTuULni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619154; c=relaxed/simple;
	bh=6j2mZ1I5om5klX55W+lZKIazbOQN+SR/BAi30yYJ+t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+i8PvHe+LEqeObJhmURLLoA/6l6EgXtnHt/+Wp4VD2rpQCYCSzXITco02KPbnBofLTVEJ/sbXkzRJHjMIUxjuJU/S3YjPpybwRMEk4ldeCflK4l2K5tNstA43ah57lThrnnoFJByZ2MNtYqvjDFukuyboZsmPhyztOuG6z5Go4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ka/p5YOi; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619153; x=1772155153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6j2mZ1I5om5klX55W+lZKIazbOQN+SR/BAi30yYJ+t4=;
  b=ka/p5YOicjzYd2ZOzEg1jmuud3kstIn7ZTtrU42/fuv7+5reyRcCZv2h
   1U0Py0QUr1mTbHexRRGQW5rZxpnYvtFIP2tiR1y6skmOFO9k3GiX7M34h
   hSSHasqZHhqCFaqTADdSCF5WFYH5Ci8KXUTd0mBtjMpOTdCEBsfPirNq1
   iXrrDmXv2aaW17cKSv2uTcAl1bZTKJPLffyqQM4Qp9NuaeEgwawLsBbUc
   okx+Vi+uFuRKU13Wv0KvTkiuEcaNPSyDcbtmr/CSY+4YAO+qfHHL8bqNj
   AZpSBHpB8twuK6U0qaXRQwP4nHlSFA4uAyulGLfI7H5Pck1dWlmlMhVqy
   Q==;
X-CSE-ConnectionGUID: xwDc5j/xSIyJEA0m1XrKeA==
X-CSE-MsgGUID: 7kPhUU0hQjSaJXBp2v3hNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959616"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959616"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:12 -0800
X-CSE-ConnectionGUID: A73mde9rTpWfWeCWOxiNKA==
X-CSE-MsgGUID: H+YZyFXsSZKhf/NLRIYiXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674893"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:08 -0800
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
Subject: [PATCH v2 07/20] KVM: x86: Move KVM_MAX_MCE_BANKS to header file
Date: Thu, 27 Feb 2025 09:20:08 +0800
Message-ID: <20250227012021.1778144-8-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Move KVM_MAX_MCE_BANKS to header file so that it can be used for TDX in
a future patch.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: split into new patch]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No Change.

TDX "the rest" v1:
- New patch. Split from "KVM: TDX: Implement callbacks for MSR operations for TDX". (Sean)
  https://lore.kernel.org/kvm/Zg1yPIV6cVJrwGxX@google.com/
---
 arch/x86/kvm/x86.c | 1 -
 arch/x86/kvm/x86.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33b64b65c166..1bd7977006c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -90,7 +90,6 @@
 #include "trace.h"
 
 #define MAX_IO_MSRS 256
-#define KVM_MAX_MCE_BANKS 32
 
 /*
  * Note, kvm_caps fields should *never* have default values, all fields must be
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 72b4cee27d02..772d5c320be1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -10,6 +10,8 @@
 #include "kvm_emulate.h"
 #include "cpuid.h"
 
+#define KVM_MAX_MCE_BANKS 32
+
 struct kvm_caps {
 	/* control of guest tsc rate supported? */
 	bool has_tsc_control;
-- 
2.46.0


