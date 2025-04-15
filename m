Return-Path: <kvm+bounces-43339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B59CBA89B34
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 12:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 865383B08FD
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 10:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BA529293D;
	Tue, 15 Apr 2025 10:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kZYjmmWz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9DB1F37B8;
	Tue, 15 Apr 2025 10:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744714170; cv=none; b=sbdwREwh/jxoagmL3A12GHBXMn/tI0fW6TAYOcqCxtUprve8jqNgYoLfXODIDG/Tg6GLa1KtTXH85y7xwBsKUYQBueFbjjH19gziaslzbJ2QB4FyLmBStqBTrknwetgwQybJNhqaBucXjqHkBkQIEJt8n7l8II7M8alMplooI60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744714170; c=relaxed/simple;
	bh=YxBfVWfN4Utc0NInu6fpwo+P9Y4n359ujEjSMOF2fjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/CZsmRHBwS+eVJ7UskNHwZZmyULSYNw85I1AHYZuf/KSelheYfIqsdse1gbw6D1ob+FgBQFbxvaXJPYB4NpTJkM4FEq1qJODN6DjgzkDUH59TVrtgW2z+ZJOVId8wnXBj7n/NjYyoXIp9BmM4S0s1dqDSfdNxYYoyhQ+F0k9M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kZYjmmWz; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744714169; x=1776250169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YxBfVWfN4Utc0NInu6fpwo+P9Y4n359ujEjSMOF2fjE=;
  b=kZYjmmWzLyHwCw/KrpdzVUePolEHKKfkhQ0gpf28eZA4gJ/ihCQh4YVU
   laevxsQySWfa839nmgUbDiHc9YBf/TJpBeryXG3ZsPKbHTRReA9yoxq1N
   eBkrmiFABV44DjqWxuUT94H+398VgF18+j3vlXQ/eHoPftamIyudNxRqI
   mx/BVZF7gROkoJtRJM58k819CEQI3VhXEojXRaG0LbVrdaXFURrr+t7SL
   m43hCtzN+IScmW2ID7F/AHLMmDODlMXK8cakrU+5oib7k/g678wd99McL
   LImaitE0S/EgWcc2JCWRaoBVEUPq8EdiEbf7JjsZR6CozO8zmQM+wuqSK
   w==;
X-CSE-ConnectionGUID: Fv3rX9fCSvaR3vICc2SdvQ==
X-CSE-MsgGUID: pLd62TPdQnmzhpfEb8u1RA==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46132896"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46132896"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 03:48:48 -0700
X-CSE-ConnectionGUID: GrRJ6uJIQ227JEMrDeG8Dg==
X-CSE-MsgGUID: l6dOn79PReWoHPCgJGC/Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="167254354"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.254.135])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 03:48:44 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH 1/2] KVM: x86: Do not use kvm_rip_read() unconditionally in KVM tracepoints
Date: Tue, 15 Apr 2025 13:48:20 +0300
Message-ID: <20250415104821.247234-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250415104821.247234-1-adrian.hunter@intel.com>
References: <20250415104821.247234-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Not all VMs allow access to RIP.  Check guest_state_protected before
calling kvm_rip_read().

This avoids, for example, hitting WARN_ON_ONCE in vt_cache_reg() for
TDX VMs.

Fixes: 81bf912b2c15 ("KVM: TDX: Implement TDX vcpu enter/exit path")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/kvm/trace.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index ccda95e53f62..ba736cbb0587 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -11,6 +11,13 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 
+#ifdef CREATE_TRACE_POINTS
+#define tracing_kvm_rip_read(vcpu) ({					\
+	typeof(vcpu) __vcpu = vcpu;					\
+	__vcpu->arch.guest_state_protected ? 0 : kvm_rip_read(__vcpu);	\
+	})
+#endif
+
 /*
  * Tracepoint for guest mode entry.
  */
@@ -28,7 +35,7 @@ TRACE_EVENT(kvm_entry,
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
-		__entry->rip		= kvm_rip_read(vcpu);
+		__entry->rip		= tracing_kvm_rip_read(vcpu);
 		__entry->immediate_exit	= force_immediate_exit;
 
 		kvm_x86_call(get_entry_info)(vcpu, &__entry->intr_info,
@@ -319,7 +326,7 @@ TRACE_EVENT(name,							     \
 	),								     \
 									     \
 	TP_fast_assign(							     \
-		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
+		__entry->guest_rip	= tracing_kvm_rip_read(vcpu);		     \
 		__entry->isa            = isa;				     \
 		__entry->vcpu_id        = vcpu->vcpu_id;		     \
 		__entry->requests       = READ_ONCE(vcpu->requests);	     \
@@ -423,7 +430,7 @@ TRACE_EVENT(kvm_page_fault,
 
 	TP_fast_assign(
 		__entry->vcpu_id	= vcpu->vcpu_id;
-		__entry->guest_rip	= kvm_rip_read(vcpu);
+		__entry->guest_rip	= tracing_kvm_rip_read(vcpu);
 		__entry->fault_address	= fault_address;
 		__entry->error_code	= error_code;
 	),
-- 
2.43.0


