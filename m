Return-Path: <kvm+bounces-6677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F80837867
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8F151F22067
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACCE7E582;
	Mon, 22 Jan 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FXPSslui"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683EF768F5;
	Mon, 22 Jan 2024 23:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967769; cv=none; b=iv5ITvhcKFcl/3I+jf6pjvj3heDIHhxUwQ967hqATDs/49m8+gCe8TXmIqik8bkDpUXBOkoDEjwxBL/yPfGbBl+6+Ok8B/C+ZVx5TkW2HDJ2WVTHeONIfFDKSdhe9trUYbtfBATIjrm0zNzaGbJ6Nt5pZlXDCSIPOd6aTEwjK/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967769; c=relaxed/simple;
	bh=RrwjQkGCp/LMRSzlorAgI5S75/rpkqk4fHP6POlnQ9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GVJXnyR4GEZbs0TaORJWNxq3HrBCE1akQR4ycSWRApzJHwOA/P/MyT4RYrnJLHX0QDPFcdRqKWfgdzh5Jtjs5DhPzMLBYL+H1cnNYw5XvzGyD26hHtcMnqLbJoFz/uuiHMZcdbtdJ8b8oLOgLC0EAqxKJ8A6S+9m0PFhro7aHog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FXPSslui; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967765; x=1737503765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RrwjQkGCp/LMRSzlorAgI5S75/rpkqk4fHP6POlnQ9Y=;
  b=FXPSsluiVn/NHEYM8LcTWxsBingrm2SMyZ4BNX/tQ9z/pKJCOz9yVqvq
   GRdiU/n2YPESYBXCBvyGWKng4JTQFzAKcJuE57MAw7OMEmAzzadd5CFTe
   EPOr7RNyum83TMbH1e8pnIBTudf7mBXy9US3njl1m4SluMjlg9l3Xqzib
   exhXNPS6707WsV1e+xTGO35VVywC1uMbVi4xUcDJCQtNODOe/TRCHsHF0
   LZOutxA/wg08JlM7m8GEFpTWcL6Ctcp9T5qgkU6c2DuQ81lGcbEqqwha0
   VcXpzdf6IYwmFYZEWP/xrZYrvlzuDnzWt6cvbPRnU1mqlBkTO6qEtlCfd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217892"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217892"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817999"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:53 -0800
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
Subject: [PATCH v18 104/121] KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
Date: Mon, 22 Jan 2024 15:54:20 -0800
Message-Id: <d2edf32c714ca9c9a541613b6cc5d3e6106a11f4.1705965635.git.isaku.yamahata@intel.com>
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

Implement TDG.VP.VMCALL<GetTdVmCallInfo> hypercall.  If the input value is
zero, return success code and zero in output registers.

TDG.VP.VMCALL<GetTdVmCallInfo> hypercall is a subleaf of TDG.VP.VMCALL to
enumerate which TDG.VP.VMCALL sub leaves are supported.  This hypercall is
for future enhancement of the Guest-Host-Communication Interface (GHCI)
specification.  The GHCI version of 344426-001US defines it to require
input R12 to be zero and to return zero in output registers, R11, R12, R13,
and R14 so that guest TD enumerates no enhancement.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5a2b211a365c..9283d45ea4b8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1403,6 +1403,20 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
+{
+	if (tdvmcall_a0_read(vcpu))
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	else {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+		kvm_r11_write(vcpu, 0);
+		tdvmcall_a0_write(vcpu, 0);
+		tdvmcall_a1_write(vcpu, 0);
+		tdvmcall_a2_write(vcpu, 0);
+	}
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1421,6 +1435,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_GET_TD_VM_CALL_INFO:
+		return tdx_get_td_vm_call_info(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1


