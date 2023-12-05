Return-Path: <kvm+bounces-3519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0490C80521F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:21:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34C9D1C20D21
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3729F59E5B;
	Tue,  5 Dec 2023 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YbZjYnno"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBC99A;
	Tue,  5 Dec 2023 03:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775281; x=1733311281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4HjA/ehjhpPNNDfV0w3r41UQQGamUWV+NqHjpKdn1bk=;
  b=YbZjYnnoUkYCqZLBRM/gh+BpSdVFW+Vlhek6Nu8N0BXAzL61644shYH7
   1X0azAKeUjc/MdLrfJfBiNxA3wozIz39WRemZXk8G9sVzh6m3OCYcrWvN
   xadjC7aKYzWwvyddx1vv6g7FMoiisKh3AIs9ostRQ6AT+UkC7ocVzvTb2
   O4OD6NyVyl8ZaYJGgqNMWu0m3xddJ8/y7Ea18xA7KdoAWCveyBMjUexYu
   pPOamlM/BKzaz8O7V87Zd9Mk622ad2xS//aho799ejVjmSTKpaX29fHw8
   aS51tT16oZfCtuE8T27us06IpPX01nlIaC/3r7z7/VBREWYZoGfLCvtXg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942363"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942363"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018192900"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018192900"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:16 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13 02/35] x86/entry: Remove idtentry_sysvec from entry_{32,64}.S
Date: Tue,  5 Dec 2023 02:49:51 -0800
Message-ID: <20231205105030.8698-3-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205105030.8698-1-xin3.li@intel.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

idtentry_sysvec is really just DECLARE_IDTENTRY defined in
<asm/idtentry.h>, no need to define it separately.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/entry_32.S       | 4 ----
 arch/x86/entry/entry_64.S       | 8 --------
 arch/x86/include/asm/idtentry.h | 2 +-
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 4e295798638b..1b0fe4b49ea0 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -649,10 +649,6 @@ SYM_CODE_START_LOCAL(asm_\cfunc)
 SYM_CODE_END(asm_\cfunc)
 .endm
 
-.macro idtentry_sysvec vector cfunc
-	idtentry \vector asm_\cfunc \cfunc has_error_code=0
-.endm
-
 /*
  * Include the defines which emit the idt entries which are shared
  * shared between 32 and 64 bit and emit the __irqentry_text_* markers
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 567d973eed03..5a1660701623 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -370,14 +370,6 @@ SYM_CODE_END(\asmsym)
 	idtentry \vector asm_\cfunc \cfunc has_error_code=1
 .endm
 
-/*
- * System vectors which invoke their handlers directly and are not
- * going through the regular common device interrupt handling code.
- */
-.macro idtentry_sysvec vector cfunc
-	idtentry \vector asm_\cfunc \cfunc has_error_code=0
-.endm
-
 /**
  * idtentry_mce_db - Macro to generate entry stubs for #MC and #DB
  * @vector:		Vector number
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 05fd175cec7d..cfca68f6cb84 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -447,7 +447,7 @@ __visible noinstr void func(struct pt_regs *regs,			\
 
 /* System vector entries */
 #define DECLARE_IDTENTRY_SYSVEC(vector, func)				\
-	idtentry_sysvec vector func
+	DECLARE_IDTENTRY(vector, func)
 
 #ifdef CONFIG_X86_64
 # define DECLARE_IDTENTRY_MCE(vector, func)				\
-- 
2.43.0


