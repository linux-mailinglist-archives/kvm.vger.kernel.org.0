Return-Path: <kvm+bounces-45906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CE4AAFEB9
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04FE17B4814
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8462D27C179;
	Thu,  8 May 2025 15:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UQSh3jPs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D7927B4FF
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716704; cv=none; b=tfUpL8yPuSHZ+W36VIgzj//59D6dK/aOgSvK6i3tM4Lf3RjpC+K7IuVTn6WyfPV3zGDonMjEwIARQ3iXZoySxvZpuotkWECr5lznx27ATcCeI6Nu2tJrbzVYY0ZIuu38OG44WflwuPrGUEIGLc9pYbKRhJVowKHc5+mqrf5OC6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716704; c=relaxed/simple;
	bh=kPZwrjTsGupTFDYfyQ3gq04yzM+D8DCccgmpm1ICLYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZobwdNocO4Z73UmNL6vjWD4+UJknV2YqYUt091sF2n0npjRCk7xtZN4hs154p4v+o+2Oeoh7YiJgZsz/bnIfEzJ1DbBO6rrN/HTezQ5y8wf6k3j8Nlq9Xc54KlE22Y/IjtLsFGmqRccfP+66j6KKwB60F9vg0BZzoX1miU/jtLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UQSh3jPs; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716703; x=1778252703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kPZwrjTsGupTFDYfyQ3gq04yzM+D8DCccgmpm1ICLYc=;
  b=UQSh3jPsbgCIhkCltan2lljLudcCFRETGrX2S+ADeAXzQ9MF/3REIfId
   qr9BWLtJeX8HUWkrV7HgNy+88/Fj0Kekvjcl7mtKKBUIsiGz0aitYtxae
   YLEE4D40Pd6EZjVbTxb2XAvCRCMh7KocvguO7n7g+nysyR1GfpCC/gEpy
   6t4uu8UvLu7x+YyY4sxrVHUmIpjlX/v5urQNrnTHHqs7DIwepDlyFEiIb
   GPQwCH67x1xqW85+WVLSX7iSnH31/g4oFfORQldtJcI58OgSdNStPQ047
   rkd0hfn3+UuC0AXKDzGyF7N4FCHKf00hr+wnxnDardnsaTuJy0bDC+23G
   g==;
X-CSE-ConnectionGUID: yeu9vshUSSqty0nVXRmHzQ==
X-CSE-MsgGUID: F5BrRce/TAymRDm6TtMt1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73887995"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73887995"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:02 -0700
X-CSE-ConnectionGUID: fJ7vktR5Qxis1W4GscsMag==
X-CSE-MsgGUID: 67FZOYlBRcKxudS4gJ9sAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439725"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:04:59 -0700
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
Subject: [PATCH v9 03/55] i386/tdx: Implement tdx_kvm_type() for TDX
Date: Thu,  8 May 2025 10:59:09 -0400
Message-ID: <20250508150002.689633-4-xiaoyao.li@intel.com>
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

TDX VM requires VM type to be KVM_X86_TDX_VM. Implement tdx_kvm_type()
as X86ConfidentialGuestClass->kvm_type.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v6:
 - new added patch;
---
 target/i386/kvm/kvm.c |  1 +
 target/i386/kvm/tdx.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee812..4f1cfb529c19 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -191,6 +191,7 @@ static const char *vm_type_name[] = {
     [KVM_X86_SEV_VM] = "SEV",
     [KVM_X86_SEV_ES_VM] = "SEV-ES",
     [KVM_X86_SNP_VM] = "SEV-SNP",
+    [KVM_X86_TDX_VM] = "TDX",
 };
 
 bool kvm_is_vm_type_supported(int type)
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index ec84ae2947bb..d785c1f6d173 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,8 +12,17 @@
 #include "qemu/osdep.h"
 #include "qom/object_interfaces.h"
 
+#include "kvm_i386.h"
 #include "tdx.h"
 
+static int tdx_kvm_type(X86ConfidentialGuest *cg)
+{
+    /* Do the object check */
+    TDX_GUEST(cg);
+
+    return KVM_X86_TDX_VM;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -40,4 +49,7 @@ static void tdx_guest_finalize(Object *obj)
 
 static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
+    X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
+
+    x86_klass->kvm_type = tdx_kvm_type;
 }
-- 
2.43.0


