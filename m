Return-Path: <kvm+bounces-32320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D03E39D53CD
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 885661F229EE
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDED91DE2BD;
	Thu, 21 Nov 2024 20:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AmVOsVPr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480B31DE2B5;
	Thu, 21 Nov 2024 20:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220139; cv=none; b=jkDezVvEmUMFPsbaCzkrCPsJDvpDENKZkDBCnDN/vsgWdecEu7B/Jh8AbwQ+X0Etz+HIKzZZPsmzM/qzaVmWaQU5lLJxoFbi3/iFjruhv8JDqWsStX6I4BXlaemGFCOVvJxq8ta8VverNmlNTHXmxwX4kwUqkcRcNcLOgXrtF4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220139; c=relaxed/simple;
	bh=PatvNqUnDEkJGUkiPz9VCdWdENsRWsvrlvB8gF01Pcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYdN4mAmBTPQNxyQf7qlQspBgyU5x1juSLtGSJwZpF5Ui7b/IXdcG0rVv7z7yTdsmFHjhu79xLpvU2XJZgnV89EhrZ8wPHGvi7LN7R3/qRRDhRhTNrewsNSiBO7JDBgxHmxjbqd4MPZXp/jAuMpRa82gc78XLn1vgqpEOOtD+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AmVOsVPr; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732220138; x=1763756138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PatvNqUnDEkJGUkiPz9VCdWdENsRWsvrlvB8gF01Pcw=;
  b=AmVOsVPr+syPu8VjcYW5UaoJ7iDbWpTj8v3b7yXN2pEiEY/voQFOnn0B
   CHBGaOE/2TfBCX791bqUa5TBbWVUgDj8my0P0LSDOzBLEU0DnR7bQ8Qp9
   HtaI7Sn1VVnuYHRJV0msnxnIgfluYtYl48yfLVH7dwfNg64Ezc+t3/9WZ
   3pNnYoNfZp5/FLOxnAFMNQI3OtOIebooZzFW2BjGTsKM33o1ixEgig49P
   9I3UZGomNeo1V8ab63GRQQUR6o1wHuqb5RN4d0Xxgs6VB7oCRkDSSbUiR
   UeMwQfpIlWaF85WaSjsGNpwEjhbJC2pUIqFAGy+6uxE6kk2F4XqPAlzbr
   w==;
X-CSE-ConnectionGUID: t0VPECI5Q82VIVpsRf90rQ==
X-CSE-MsgGUID: 1zQNSqMtRO6/YvC32bkA9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31715906"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="31715906"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:37 -0800
X-CSE-ConnectionGUID: ODRuC8OMSWCSmdLpsnA7Xg==
X-CSE-MsgGUID: pXrabNxUTyOCY/RWC8eHVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90161118"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.16.81])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:31 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH 5/7] KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr
Date: Thu, 21 Nov 2024 22:14:44 +0200
Message-ID: <20241121201448.36170-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241121201448.36170-1-adrian.hunter@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Several MSRs are constant and only used in userspace(ring 3).  But VMs may
have different values.  KVM uses kvm_set_user_return_msr() to switch to
guest's values and leverages user return notifier to restore them when the
kernel is to return to userspace.  To eliminate unnecessary wrmsr, KVM also
caches the value it wrote to an MSR last time.

TDX module unconditionally resets some of these MSRs to architectural INIT
state on TD exit.  It makes the cached values in kvm_user_return_msrs are
inconsistent with values in hardware.  This inconsistency needs to be
fixed.  Otherwise, it may mislead kvm_on_user_return() to skip restoring
some MSRs to the host's values.  kvm_set_user_return_msr() can help correct
this case, but it is not optimal as it always does a wrmsr.  So, introduce
a variation of kvm_set_user_return_msr() to update cached values and skip
that wrmsr.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TD vcpu enter/exit v1:
 - Rename functions and remove useless comment (Binbin)
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 24 +++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dfa89a5d15ef..e51a95aba824 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2303,6 +2303,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
+void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92de7ebf2cee..2b5b0ae3dd7e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -637,6 +637,15 @@ static void kvm_user_return_msr_cpu_online(void)
 	}
 }
 
+static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
+{
+	if (!msrs->registered) {
+		msrs->urn.on_user_return = kvm_on_user_return;
+		user_return_notifier_register(&msrs->urn);
+		msrs->registered = true;
+	}
+}
+
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
@@ -650,15 +659,20 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 		return 1;
 
 	msrs->values[slot].curr = value;
-	if (!msrs->registered) {
-		msrs->urn.on_user_return = kvm_on_user_return;
-		user_return_notifier_register(&msrs->urn);
-		msrs->registered = true;
-	}
+	kvm_user_return_register_notifier(msrs);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
+void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
+{
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+
+	msrs->values[slot].curr = value;
+	kvm_user_return_register_notifier(msrs);
+}
+EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
+
 static void drop_user_return_notifiers(void)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
-- 
2.43.0


