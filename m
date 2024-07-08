Return-Path: <kvm+bounces-21091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7DC929EF5
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 11:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FB9D1F220D8
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE3C6F307;
	Mon,  8 Jul 2024 09:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AuGM71Ow"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E835466B;
	Mon,  8 Jul 2024 09:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720430436; cv=none; b=GVoDFxPM4+eOahtKC67DUt/pOTUQT3DbAz2axWSMM7M4jcyHAFg7OXvxnGLvRSY4F94GrKgHGNZZvhVjEGDU8gyqoilC3qKx0XourqyILTxIiopTVlwc6uyrT1qA1hnSpfte3EaXprIyOUC5OSqX2jy9+m3gb0sofd2nshjERbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720430436; c=relaxed/simple;
	bh=0i13OMgZrt/MzQQEsSgZlvpUvxqa2W/rOTQGrfLEHxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl94eDpsYwszbNfVSSeG5iwRTfzgBT+Ryu4ibR+oDPZSs854pOvtZuFXVzHnnsW8pExMLc8swkhBFxVolvJp5mdkqNM0nCgSBGUpzIWXxXsJbE3J1aEVEOshzcR4ElZ6MeQUtIA1jCfVx0qh/gmvD2aKdv56npIGZ048cMHhL1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AuGM71Ow; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720430435; x=1751966435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0i13OMgZrt/MzQQEsSgZlvpUvxqa2W/rOTQGrfLEHxU=;
  b=AuGM71Ow7pu/QY9CiPwZwS4Dp8ijaYtKzz3tjyVkNieMaYpsH3IqPkkj
   GtR+en9qthzhSEUFzk6NFbVrBzG8CnEesZOAtLnDvHsWIAHmY5TQnmx75
   +0cHaTWHLUB0LLnQjWvCwdgRiXux9JpII+2KT0yVSGmYfMW/9uWSOjYRB
   s6mHRq/ApC0b3lPDfofw69GdeVvNIqncpVRVDvJExNFxm8jpSd2swZtrA
   /5Uh0zVXegleZsWrJGiKncPLhrpAmKf6H914LXXdB4NrYxDBtZr5JURUs
   Kom8Af4k8wJZHCSVG8MJ3KHbRT9AG4GVk2ZjkWFu7KnxvGJdea618Zcoh
   A==;
X-CSE-ConnectionGUID: AsFpkOe4SxCEjvy27p89Ug==
X-CSE-MsgGUID: Z3Z9e4pJSgmU6jov4cUlmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="17577720"
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="17577720"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 02:20:35 -0700
X-CSE-ConnectionGUID: /RgI+kNlRxK6zzi3wt70iA==
X-CSE-MsgGUID: 4VJLYcR3RcCag40YbAQ5mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="51866626"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 02:20:32 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	michael.roth@amd.com,
	binbin.wu@linux.intel.com
Subject: [PATCH 1/2] KVM: x86: Check hypercall's exit to userspace generically
Date: Mon,  8 Jul 2024 17:21:49 +0800
Message-ID: <20240708092150.1799371-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240708092150.1799371-1-binbin.wu@linux.intel.com>
References: <20240708092150.1799371-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check whether a KVM hypercall needs to exit to userspace or not based on
hypercall_exit_enabled field of struct kvm_arch.

Userspace can request a hypercall to exit to userspace for handling by
enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
hypercall_exit_enabled.  Make the check code generic based on it.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 arch/x86/kvm/x86.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 994743266480..f84c1f263e9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10223,8 +10223,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	cpl = kvm_x86_call(get_cpl)(vcpu);
 
 	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-		/* MAP_GPA tosses the request to the user space. */
+	if (is_kvm_hc_exit_enabled(vcpu->kvm, nr) && !ret)
+		/* The hypercall is requested to exit to userspace. */
 		return 0;
 
 	if (!op_64_bit)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 50596f6f8320..02809a915d72 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -547,4 +547,8 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
+{
+	return kvm->arch.hypercall_exit_enabled & (1 << hc_nr);
+}
 #endif
-- 
2.43.2


