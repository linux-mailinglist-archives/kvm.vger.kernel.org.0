Return-Path: <kvm+bounces-6915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E180083B7DD
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB772886E5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E02111A0;
	Thu, 25 Jan 2024 03:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kvP3Sgfd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20E9D287
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153302; cv=none; b=ZCd7IGkJkUhDksdTcjRVksA/qSN+EVa6TfLjMbEYI9JQa1LXuo+7tWaStMsbL1jiHVPpA6Et0N2YKdnwUNjVPDqofu1rPjv6Khu5WVQ+zjjr04HhCpx3MF105qJ6QTyVCENRHvAy7ZTssyMf+UMLqUaAtco6bFN4y3WDBVDRNrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153302; c=relaxed/simple;
	bh=Ak9gbkWME/+XOgFurmlCx0ZICYh/+s5jBeuIHp28kNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mkQUncWtidUpeCIuSUzCShhffUACmzpG9spS6jsk5xZSJB8gtwe+M+e4IfPqBB6h84ItW9U1Ln/9zNwkSNui6pDXOf/HJKhTYRxR+p5xYd/1NDR656j9B8HEU//MiwiIu9Btbx3pdDl17DMcgnVryWNDLOKZ5cLgqk/bYWrZvQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kvP3Sgfd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153301; x=1737689301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ak9gbkWME/+XOgFurmlCx0ZICYh/+s5jBeuIHp28kNU=;
  b=kvP3SgfdL7l0QxkgPB9owjKxNlre0FlEUS6GCFHBEI98RVwTVfLSJ2E8
   lQG20rVg+CPu/EAedDJKXsyM4PZa0QziwC2fAUnkWwd3HtT3yMLwzKXhm
   KLA1M/xb3ev5majbZvkqfwF/rD9f5BnDmw3k9MXVgW8/yWtqGtYQPwGUP
   hwaPv1qadY6EW0PTMKsS9n94LHcDfabKQztNBxP0enhWYJ335u93V7Hkc
   KE80J/pG5wLiLl21GumIkQaatY1rHYnIBKoh+YgbXYyZzbUH6tF2/XeUr
   mT7WqCQ12xKpDiW7Wg3wbLMrEBOjE5IN2emrNguwsu1N0bxmjqtBpJhvc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428260"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428260"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084911"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:24:44 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 13/66] target/i386: Introduce kvm_confidential_guest_init()
Date: Wed, 24 Jan 2024 22:22:35 -0500
Message-Id: <20240125032328.2522472-14-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Introduce a separate function kvm_confidential_guest_init(), which
dispatches specific confidential guest initialization function by
ms->cgs type.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm.c | 11 ++++++++++-
 target/i386/sev.c     |  1 -
 target/i386/sev.h     |  2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c961846777cc..f9a774925cf6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2541,6 +2541,15 @@ int kvm_arch_get_default_type(MachineState *ms)
     return 0;
 }
 
+static int kvm_confidential_guest_init(MachineState *ms, Error **errp)
+{
+    if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SEV_GUEST)) {
+        return sev_kvm_init(ms->cgs, errp);
+    }
+
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     uint64_t identity_base = 0xfffbc000;
@@ -2561,7 +2570,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      * mechanisms are supported in future (e.g. TDX), they'll need
      * their own initialization either here or elsewhere.
      */
-    ret = sev_kvm_init(ms->cgs, &local_err);
+    ret = kvm_confidential_guest_init(ms, &local_err);
     if (ret < 0) {
         error_report_err(local_err);
         return ret;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 173de91afe7d..27d58702d6dc 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -39,7 +39,6 @@
 #include "hw/i386/pc.h"
 #include "exec/address-spaces.h"
 
-#define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
 
 
diff --git a/target/i386/sev.h b/target/i386/sev.h
index e7499c95b1e8..1fe25d096dc4 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -20,6 +20,8 @@
 
 #include "exec/confidential-guest-support.h"
 
+#define TYPE_SEV_GUEST "sev-guest"
+
 #define SEV_POLICY_NODBG        0x1
 #define SEV_POLICY_NOKS         0x2
 #define SEV_POLICY_ES           0x4
-- 
2.34.1


