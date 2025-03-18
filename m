Return-Path: <kvm+bounces-41393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9625A677E9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6B303B5CAB
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835D421018F;
	Tue, 18 Mar 2025 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fT7Ek0IY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C7F19C56C;
	Tue, 18 Mar 2025 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311879; cv=none; b=YgGAsgcFyd6i/PvqWFJRd2Mh6b/w0KIA1lZrsmYDpUjp5nx/ViaR0E4uHWmrZLvmhgzKbJWzl692rLeyvr0WE7PjYqGn8xkhAyRzEKVOykh4mcunFwhSZ+jML7kkFTt6/MI5sTb+y2asKQkFQBFdGqSALvnSwzoPGylBxrzvrK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311879; c=relaxed/simple;
	bh=nCXar2WdGQZ0X6LdpHvfSLsjNYgYiXeRXcUmw8zvhAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDjXKmxbnC7jNNZleQNiIJ612OOyrRa+cs9qUlyOvhH7I3Q2qCckob1oLjX5bzGl4AewVEc8UNonawZ7/fQIyCe4YGgIQ1nn86KbCjzDk5EbdM2oLv7jN4Pm5cJWgxPGZgQxxci+2M+Vjugs/HGnhLRHOqPwiPEFqKSx8utbNEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fT7Ek0IY; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311878; x=1773847878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nCXar2WdGQZ0X6LdpHvfSLsjNYgYiXeRXcUmw8zvhAA=;
  b=fT7Ek0IYsP/WPsWun0E/qLHh2DESnijFNCXlvsZ+lJD7qM+8rc6X60gN
   3M7yuHe3PmeSbY3MHiN9OpwYK+wtXx+5k4TBj+C9NQ5nVttKE9CKny1OY
   q4KcGmMdUWjZwwGH/BVol/NOmZTJ4ZTdlTzWhdGTMr7zgvzDNeUZEVsu4
   MEobDCaScy4t8Q4e4a7P1+WAY9bIC89VSSaXOec97ekARgo+u0V82TiBF
   MlFL7U8BE6TWqtlHbt7hiUG99MrusjfViwpjhQaA4yJedW4Df+OvL/MG4
   CqgVzdbl4NNaSif7PPmdOOzylyjU5ZRDGZFPgM7cMmX0TpzisA8msK6CF
   A==;
X-CSE-ConnectionGUID: mvl10m9kTtuY5gcyhrslCQ==
X-CSE-MsgGUID: +gqV6QW5SNSSFevZzbA1xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="46224316"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="46224316"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:31:17 -0700
X-CSE-ConnectionGUID: tMpVw26YQgaplfNV7iZi1Q==
X-CSE-MsgGUID: R5i14et9SKuHhqW/h7BoLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122122084"
Received: from spr.sh.intel.com ([10.239.53.19])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:31:11 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Li RongQing <lirongqing@baidu.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Subject: [PATCH v4 7/8] x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
Date: Tue, 18 Mar 2025 23:31:57 +0800
Message-ID: <20250318153316.1970147-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250318153316.1970147-1-chao.gao@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Define a new XFEATURE_MASK_SUPERVISOR_GUEST mask to specify the features
that are enabled by default in guest FPUs but not in host FPUs.

Add CET_KERNEL as the first guest-only feature to save host FPUs from
allocating XSAVE buffer space for all threads on CET-capable parts.

Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
Dropped Dave's Suggested-by as the patch has been changed significantly
---
 arch/x86/include/asm/fpu/types.h  | 9 +++++----
 arch/x86/include/asm/fpu/xstate.h | 3 +++
 arch/x86/kernel/fpu/xstate.c      | 5 ++++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 80647c060b32..079f3241e25b 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -568,8 +568,9 @@ struct fpu_state_config {
 	 * @default_size:
 	 *
 	 * The default size of the register state buffer. Includes all
-	 * supported features except independent managed features and
-	 * features which have to be requested by user space before usage.
+	 * supported features except independent managed features,
+	 * guest-only features and features which have to be requested by
+	 * user space before usage.
 	 */
 	unsigned int		default_size;
 
@@ -595,8 +596,8 @@ struct fpu_state_config {
 	 * @default_features:
 	 *
 	 * The default supported features bitmap. Does not include
-	 * independent managed features and features which have to
-	 * be requested by user space before usage.
+	 * independent managed features, guest-only features and features
+	 * which have to be requested by user space before usage.
 	 */
 	u64 default_features;
 
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 8990cf381bef..69db17476061 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -45,6 +45,9 @@
 /* Features which are dynamically enabled for a process on request */
 #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
 
+/* Supervisor features which are enabled only in guest FPUs */
+#define XFEATURE_MASK_SUPERVISOR_GUEST	XFEATURE_MASK_CET_KERNEL
+
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
 					    XFEATURE_MASK_CET_USER | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1dd6ddba8723..b19960215074 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -55,7 +55,7 @@ static const char *xfeature_names[] =
 	"Protection Keys User registers",
 	"PASID state",
 	"Control-flow User registers",
-	"Control-flow Kernel registers",
+	"Control-flow Kernel registers (KVM only)",
 	"unknown xstate feature",
 	"unknown xstate feature",
 	"unknown xstate feature",
@@ -813,6 +813,9 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 	fpu_kernel_cfg.guest_default_features = fpu_kernel_cfg.default_features;
 
+	/* Clean out guest-only features from default */
+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_SUPERVISOR_GUEST;
+
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 	fpu_user_cfg.guest_default_features = fpu_user_cfg.default_features;
-- 
2.46.1


