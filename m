Return-Path: <kvm+bounces-6668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBB5837854
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:14:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D005AB27D72
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760C9745EE;
	Mon, 22 Jan 2024 23:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VxhJyKSd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0E76BB4E;
	Mon, 22 Jan 2024 23:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967762; cv=none; b=iCzspMdLQY0uLm+z+eHI5Vdf7UTovOzgeOGnT6xwXQRfxZ6GsV9Ynt0/WMeRsavNY11xHLX5phN9ozbAeB9zu4vlxnkjmwv74aKOSmei4OehLv1iYssAYOqCprfVhOslw9nEjJO9cMzDJwfBkUbYKuePB1RIPh57/e8uHjwF4i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967762; c=relaxed/simple;
	bh=7SLajzZmwAbfDTz6N1TsSycfpiI5LKK4FrnC371dsU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=llDdlHRKsXZG1a1iHaCqQicI4PPnQRI1ApzdDIbpskhZ55k49QSE+Ra8sBDttGukINq5S4lZ5tGgJ0pFXt2dagp/Y4hk37qeLsmWUEdCL7kaW9uCUZXWSoRKn8Yiwu2ZR7dBtox3xXbbZqAicTDgwWIqx3QSi/j03B1hSSXLyLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VxhJyKSd; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967761; x=1737503761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7SLajzZmwAbfDTz6N1TsSycfpiI5LKK4FrnC371dsU4=;
  b=VxhJyKSd5uR7/ZaDAbOdSbITAmS2+Pld+2kYWZSZrpQhVeEcpdeHWhqs
   DcqRgbZ9vhym85k5vrmWjv2zc961dJFxOTeN/wF9SktfBIfvvXWtpHmno
   z5HpNNDrQeCeZj+0o5+ntFgFpzNIuREAPNp1fYS9O9zpUJkXefsCRSYrL
   iI9xjJb7IoS+/FEMphb6xsMUOwCyGiQtMA2tu7cFXDgzj7X4bHHCDHtVh
   FZFyJ3GosWswvfgjIs4EP7874HLuwxqmgf8HWLeznnf41HTnf3mVhbyoZ
   u82zGv3uLXqn2+H8GVJQKmK3ijxRKjYe3Zg7Yt3jOB4qfb+rtKq839F1L
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016524"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016524"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468251"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:39 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v18 070/121] KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr
Date: Mon, 22 Jan 2024 15:53:46 -0800
Message-Id: <f4ab4e4ecb5884fc974f97f2962d88338402be33.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1b0969430c7c..5cb25e1f83ce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2268,6 +2268,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
+void kvm_user_return_update_cache(unsigned int index, u64 val);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2371a8df9be3..f14e3e888842 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -440,6 +440,15 @@ static void kvm_user_return_msr_cpu_online(void)
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
 	unsigned int cpu = smp_processor_id();
@@ -454,15 +463,21 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
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
 
+/* Update the cache, "curr", and register the notifier */
+void kvm_user_return_update_cache(unsigned int slot, u64 value)
+{
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+
+	msrs->values[slot].curr = value;
+	kvm_user_return_register_notifier(msrs);
+}
+EXPORT_SYMBOL_GPL(kvm_user_return_update_cache);
+
 static void drop_user_return_notifiers(void)
 {
 	unsigned int cpu = smp_processor_id();
-- 
2.25.1


