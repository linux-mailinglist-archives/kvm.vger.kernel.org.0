Return-Path: <kvm+bounces-6687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B9E83787B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74AB01F21CDF
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610F881ABE;
	Mon, 22 Jan 2024 23:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gnLoQTH+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E596950243;
	Mon, 22 Jan 2024 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967775; cv=none; b=llGGz4NfEvJMbEoL71EuN4N9KanW+pUhwqD/EaxAdiEHIglsiF/gCXYj+9qTnZN961OJSTBqHnmCYpHl849cMfe8uo+01BlGqEmIz48q65xTJ8iX6dnDl01uvpt08sUbWYXvzLAJuxCib+mXjnP48S0WPHYWsinRBpuioUB+tLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967775; c=relaxed/simple;
	bh=CPzg9MzLi+bzjnrxuAOhesiBsliVVuVv8X2j8Iy9fAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=doSIUWwC82FMzM9i6UViDTZvJ/rhE43fUzE1rdM4gL8eX3lUz7SfxTgMwRY0AbA5qqAqc34xMl1W2wyVqhP7Zk0RdUaQwhi+8+taKyhh9gjrVioo2iievyJlrTqrWJtgTQ/TJDXIdkAyj8+Ii/8wsNRVsPRlCysk74jKymRDaEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gnLoQTH+; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967773; x=1737503773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CPzg9MzLi+bzjnrxuAOhesiBsliVVuVv8X2j8Iy9fAU=;
  b=gnLoQTH+cA4wjH9HhJw3h1AfLf1ccDTIAXgVBM+ulNeocuSinaJvyq6/
   TcPOUCiAP9c9i+FcqluzNxW5VFlDKQPlbvtONBX+VeaTUwSXCm+34zdbw
   zX/3oPUD5dt6KmrFMuVQQUQnYNBMMWmKo6YkXjFYN4uiT6SfS0yGobxQw
   kNjiEinWwqNt90Qkxb+orXxHZnpUDFa6IcdjJfIz+H2IJG3vd1yZOA2xQ
   9uAmkXFlTZCiBi4ctaSx44u52C/GUfnJ+dXZWhBj7Esp99q4F6scTZK/D
   oERkHG8NPyOjYFm+ebBYOVXuohf1y6bz4fRP2AuBrfTqxkNogLJoJPq5b
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217945"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217945"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818035"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:58 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 115/121] KVM: TDX: Inhibit APICv for TDX guest
Date: Mon, 22 Jan 2024 15:54:31 -0800
Message-Id: <201f04ffc055319c9958ba0e37dd2e9833084c05.1705965635.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX doesn't support APICV, inhibit APICv for TDX guest.  Follow how SEV
does it.  Define a new inhibit reason for TDX, set it on TD
initialization, and add the flag to kvm_x86_ops.required_apicv_inhibits.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +++++++++
 arch/x86/kvm/vmx/main.c         | 3 ++-
 arch/x86/kvm/vmx/tdx.c          | 4 ++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 59a1c55c48f0..54ac65b75f18 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1314,6 +1314,15 @@ enum kvm_apicv_inhibit {
 	 * mapping between logical ID and vCPU.
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
+
+	/*********************************************************/
+	/* INHIBITs that are relevant only to the Intel's APICv. */
+	/*********************************************************/
+
+	/*
+	 * APICv is disabled because TDX doesn't support it.
+	 */
+	APICV_INHIBIT_REASON_TDX,
 };
 
 struct kvm_arch {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 48d71c2cef1b..dd2859328593 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1005,7 +1005,8 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	 BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |			\
 	 BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	 BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |		\
-	 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
+	 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |		\
+	 BIT(APICV_INHIBIT_REASON_TDX))
 
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a879a7fb0f03..be1cc08dd74a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2533,6 +2533,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto teardown;
 	}
 
+	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
+
 	return 0;
 
 	/*
@@ -2895,6 +2897,8 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 		return -EIO;
 	}
 
+	WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm));
+	vcpu->arch.apic->apicv_active = false;
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	tdx->td_vcpu_created = true;
 	return 0;
-- 
2.25.1


