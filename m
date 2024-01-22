Return-Path: <kvm+bounces-6642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CB383781B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D37B5B25C88
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A51265BC0;
	Mon, 22 Jan 2024 23:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M8Kid/46"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00F564CCC;
	Mon, 22 Jan 2024 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967752; cv=none; b=Rs9WFxW24dMEwNw4aufxAJNmVrITAJ3NM2gN22zy0UoOcEkTt9aAk2U312MUiXXL3eMfKXDvMRPuiyuWK9smRALL0J1Fd2A87rxddWPneOwHR5S4vq5uUc4wD2xhoRTMnN/CjLrKv2z1BwzAiGwBIU6+SQEN+vO32cpJW43/gn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967752; c=relaxed/simple;
	bh=mZ+MFyXcmzFyYUGrDI5n769PmLb8ZAFJWjPxQ6G7bJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dD0J/+1SdlF0g8E6D8Yw21MOLkrlbrbSe+59jofli/eFSjSWjTqppbTgtS+PPn1sXiigwZeka63HdxCCvAf5CLiF//egrG+nfW2pu2/E1cmyVIOMUUCCh6WBkFZNYV4S2VLYLVQNqs5UiIIpKD93xGHwv+EphkxlVX/Vf7Blos0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M8Kid/46; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967750; x=1737503750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mZ+MFyXcmzFyYUGrDI5n769PmLb8ZAFJWjPxQ6G7bJs=;
  b=M8Kid/46E80IwcSfDQ3+FqmuG90weSirYaIaChmlUJL5B7KEPmCg8znf
   85Ki2bnzEYmg352j9fLqUZlTVmYc9S/Etc4Yn3R5OVOhgZnT+YuFxlNAI
   KrnEWT23MOKsOlpmOrGiUZtsNUAl0+7Q5eZ4vjkLmS4s+RX6h+pqpk2Fp
   TbKLxaHUSSbHrvjxqX70tn3Q8ZMRlI6NVcger+JCrXw4d65Ru9TwCbkeg
   7DgrDGChPLHLrqHZjOFT/HfBzfRFMVWWOPpO25dLC4r8BSVAw7AhyZw+l
   6HmADUPp0wmsbwqfZ0RQs7r4NcUcuXfxLevA1RX8Y134P6EUUsfc0l9tz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217793"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217793"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817925"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:44 -0800
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
Subject: [PATCH v18 082/121] KVM: TDX: Implements vcpu request_immediate_exit
Date: Mon, 22 Jan 2024 15:53:58 -0800
Message-Id: <e675c1a2755f0db31ff4e5affe5dde840c97077a.1705965635.git.isaku.yamahata@intel.com>
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

Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
unblock on pending events, request immediate exit methods is also needed.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 619c5da771ee..aef78aa393ad 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -385,6 +385,16 @@ static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
 	vmx_enable_irq_window(vcpu);
 }
 
+static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		__kvm_request_immediate_exit(vcpu);
+		return;
+	}
+
+	vmx_request_immediate_exit(vcpu);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -531,7 +541,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
+	.request_immediate_exit = vt_request_immediate_exit,
 
 	.sched_in = vt_sched_in,
 
-- 
2.25.1


