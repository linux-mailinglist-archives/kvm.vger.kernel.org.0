Return-Path: <kvm+bounces-9724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DB3866D68
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 023F51C21938
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A177E592;
	Mon, 26 Feb 2024 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dwxbCuCl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C937E583;
	Mon, 26 Feb 2024 08:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936139; cv=none; b=YVFj8Ad+Y3oEoqKhopnGdpFL8jyKaXbBOlnNoqo6U1YOb19DqWTi37mQu2LbiVmjAD8MiREq1Iyvc2De0p3K5EgphvWqnEpqy6zTpw0zP9P/T/3USdeF2SimVRF4xjlcHtGwyUEqb1uySqOo1P1G9cM9VZj5tMQMps6AAwiHydM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936139; c=relaxed/simple;
	bh=3tymZz66rzCmQ3uC8SJb3tbWD7d20lTx/+E3/aBaoK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KzPJ3z9FLfv67OI/VHX/t65gymhFhDXsaW+R3c8u6LUT8dO6+mkaUh3dqeQAkS1ql35sptVbioQAh6z6kV+bgIXc1ouaIdrlwC0bjHR1YjS7eHBqsfn7GcXNxf472eJq5Yy9ks4qFdbjH5k1OVAt3oNTBK34O5L0wYQI0qKuPQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dwxbCuCl; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936138; x=1740472138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3tymZz66rzCmQ3uC8SJb3tbWD7d20lTx/+E3/aBaoK4=;
  b=dwxbCuClA5R87LNB8WiCzcFz+RnsuzEV1PsaJbrU2he+Xupj2U+hs6zr
   c8YQjjFiMNVrKw4b8vlSlQSw1dBY1qqzvVmDHzGIghNFB+sYyc8dUuKGF
   ikyQCIKJLjIRRloF2ai5a775ADflYbS9tdBiCy6yQiGqpO+3eZY7tL1Rb
   DGdfiVsW5SL0dBSGYB52joi8DNHULW1kH0n7Y9cx73f2QK5fK9hrBRgNt
   losF7c+CdoIWyuB4LZLmqj9O/R/nA71kuL5uW3W3a1PqY43bQ/2FSnuh0
   JLskXJIlrzw0Ic1j8JF3RB1ePEHb6JqUWA33vn8R0vsJpZQWMiukthop0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069596"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069596"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272684"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:57 -0800
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
Subject: [PATCH v19 100/130] KVM: TDX: handle EXIT_REASON_OTHER_SMI
Date: Mon, 26 Feb 2024 00:26:42 -0800
Message-Id: <d1f5a1375c7e402aa121e5970b3599e1a69ffdfb.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

If the control reaches EXIT_REASON_OTHER_SMI, #SMI is delivered and
handled right after returning from the TDX module to KVM nothing needs to
be done in KVM.  Continue TDX vcpu execution.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/vmx.h | 1 +
 arch/x86/kvm/vmx/tdx.c          | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index a5faf6d88f1b..b3a30ef3efdd 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -34,6 +34,7 @@
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
 #define EXIT_REASON_SIPI_SIGNAL         4
+#define EXIT_REASON_OTHER_SMI           6
 
 #define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cba0fd5029be..2f68e6f2b53a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1345,6 +1345,13 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_OTHER_SMI:
+		/*
+		 * If reach here, it's not a Machine Check System Management
+		 * Interrupt(MSMI).  #SMI is delivered and handled right after
+		 * SEAMRET, nothing needs to be done in KVM.
+		 */
+		return 1;
 	default:
 		break;
 	}
-- 
2.25.1


