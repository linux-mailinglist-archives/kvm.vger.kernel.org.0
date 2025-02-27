Return-Path: <kvm+bounces-39454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBA1A470ED
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6714D3B44E4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632AF1B4F0A;
	Thu, 27 Feb 2025 01:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QICB+FfM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9F1B4159;
	Thu, 27 Feb 2025 01:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619183; cv=none; b=MqHgssW6giF+QIG6074ZZEAjiDwCE1PT47pihcZ7yBkX8ZvReOnCboNDhvIoCcAe7uiaODy3t9un6WfFFj/QvZv78y2Jqc5eocBhgs5tgUN1nwvAWqmUrjI/LggzDOSzWM0hP9Jj56MWy9JcNcRJUrxfcYefqPizQ+D9uVIc4ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619183; c=relaxed/simple;
	bh=zItX0PUquswBbQehRZ9Mq2klvkqoMesHQu9V+fBv0nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIiB7i9cOM6P0bPxQR0xWgm28e96GZWxNLrIH0wWu0Dap3TX17c1Qx6w0i6WKipmU+I617BvhomJmoAA6mN39OAStkxwoHzV/9HQ+ETjR4No8Fa8v96+9pXekIQ9MXkiK3pmAXJQpTaf/g/+Jkka9ELvY0yKdL5bA0jlPrPZwcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QICB+FfM; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619182; x=1772155182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zItX0PUquswBbQehRZ9Mq2klvkqoMesHQu9V+fBv0nQ=;
  b=QICB+FfMN4SgBmFcCZBl8h8VA8Bqh/YukE7YhV8rXZezz9NMRGWWpNLX
   +bhdk225ejeQCXHCOMIpG0Fiyi0El6rhJEsb2WV/vT+8YIi6sKTYglO/m
   PRJC/HRGJCiaz6zcuQ7TNW6CXRHJFxFTGkeLBEm9jIMLRVSZUQNjnATi5
   CgRI1c56g6Aiku52JMzT/MbpsLVnncYkDNiK6oJ27TFJ6bciampSB9HTq
   FW8qdrrz+EJ7F8qS5aT1SoURyN3lHepk//sdKAV/gvDTieImMvAsS/3Nc
   waquQWDhT1CV4iDv2765RU8VZfWBGRIpnXhp4rcUenCcwN9xUeq5ww/E+
   g==;
X-CSE-ConnectionGUID: 0VFseoftTSiiw/Y4Vszj2Q==
X-CSE-MsgGUID: ZHefEP26SyqDCpr61Z+3Iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959676"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959676"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:42 -0800
X-CSE-ConnectionGUID: IQQQZUV3S5m+DHW4GByRnA==
X-CSE-MsgGUID: i6SFevVcQGO/Tdq1ptKaqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674923"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:38 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 16/20] KVM: TDX: Ignore setting up mce
Date: Thu, 27 Feb 2025 09:20:17 +0800
Message-ID: <20250227012021.1778144-17-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because vmx_set_mce function is VMX specific and it cannot be used for TDX.
Add vt stub to ignore setting up mce for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No change.
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 554975f053ff..d73ea9ce750d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -843,6 +843,14 @@ static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static void vt_setup_mce(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_setup_mce(vcpu);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -1002,7 +1010,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
-	.setup_mce = vmx_setup_mce,
+	.setup_mce = vt_setup_mce,
 
 #ifdef CONFIG_KVM_SMM
 	.smi_allowed = vt_smi_allowed,
-- 
2.46.0


