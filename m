Return-Path: <kvm+bounces-7912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D20958484C6
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66862290E37
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179F960877;
	Sat,  3 Feb 2024 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ho84Tknx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF8C6086E;
	Sat,  3 Feb 2024 09:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950879; cv=none; b=UaGQTJqd38Ux+1UH/zMbkyTZJ7wyhVeUEwnaGNANCeGAv0uqJUdUM5mudZpYYvtGLXXl7DddxskIzsua+umUPtDLbWo8tGgshtgbNzyHRT00OvZ23SPBwms2Xwiz1Klg1sSB4xZbNaHfCWJCpJGUeis/qSqNcVqe8MCIAKwHuRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950879; c=relaxed/simple;
	bh=o9Ea4he1GyJdoS3fqNSGXkZQw07L9///FXUYj80JU5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oLhRptss+HYgza5tvMN2hw4SKyBx71bmpStT+7/c27Y325Rdwgw/GseVobg/FuTcqMv7+pJxkzeAmBrItsWUwHEHfTQ/sjyJsqlKQhwhTYZfejVc0AoyLvvl+UwTIKJxLTm0XK6lzx+Eg9JixGZagWnTvwwVhI4wR41QrdiTbK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ho84Tknx; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950878; x=1738486878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o9Ea4he1GyJdoS3fqNSGXkZQw07L9///FXUYj80JU5U=;
  b=ho84TknxSFDncqBiIGAInwPEc9R1sZIU2l7u5x6rySaMBs8YvndVtUro
   fVFoF+XKepcIRIVwcLuEKq9GlIWFkjCRBD9+PrLhA/6YBOWhk0FbSz6Df
   x2++Q+OzoyrxVCPDKwWq4ezXLGNY6vd+nrqjXn86RvB2wlGM42xsQmwUp
   1czQ//dGkTV2DoYrMLovGsCbVdudttw8V2nLZ9uJunDS3ZH5VpDNQ6Y46
   SxBsw3eXNOa91AFOVzZDMC6iD0ILANm5zJ+acuD1lHLA1SSbhU1QECmeo
   +5GWtX3O36LE6ZOtZyx81/35TnAZ9eQBwrd4DKuDoRww0gnfsazBe6oF9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132054"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132054"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291457"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:11 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 16/26] KVM: VMX: Update HFI table when vCPU migrates
Date: Sat,  3 Feb 2024 17:12:04 +0800
Message-Id: <20240203091214.411862-17-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

When the vCPU migrates to a different pCPU, the virtual hfi data
corresponding to the vCPU's hfi index should be updated to the new
pCPU's data.

We don't need to re-register HFI notifier because currently ITD/HFI
virtualization is only supported for client platforms (with only one
HFI instance).

In this case, make the request to update the virtual hfi table.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ad5e3473a28..44c09c995120 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1735,6 +1735,17 @@ static void vmx_dynamic_update_hfi_table(struct kvm_vcpu *vcpu)
 	mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 }
 
+static void vmx_vcpu_hfi_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	if (!intel_hfi_enabled())
+		return;
+
+	if (!vmx_hfi_initialized(to_kvm_vmx(vcpu->kvm)))
+		return;
+
+	kvm_make_request(KVM_REQ_HFI_UPDATE, vcpu);
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -1748,6 +1759,9 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_pi_load(vcpu, cpu);
 
 	vmx->host_debugctlmsr = get_debugctlmsr();
+
+	if (unlikely(vcpu->cpu != cpu))
+		vmx_vcpu_hfi_load(vcpu, cpu);
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
-- 
2.34.1


