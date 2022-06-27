Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA84055CC66
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242160AbiF0V6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241649AbiF0V4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:56:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D2318B02;
        Mon, 27 Jun 2022 14:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366910; x=1687902910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z2v9awnUY4jkBBjDyMt8sC+0XqJ7pmCWw7adCSxhLw0=;
  b=Xr/NpRFKqhc/q7fRUs78MrPQqR1A8NqTAR/ZJDDMdFj4nGeFQ47yyJNm
   0QUxEzswxmNqD0T3gIhUsUN8ODoKk/AOB+2slLyJ0fasBQJPufiO3PW3h
   Q8rmtunfyiZ7CSEofK+PQQvAdMvyXiFHh3HdJ/iqHj4Q2qHEbWijEGa/h
   ac8ASPNLWz0COpjNtNfSWWuOUuSBW7vAeet/51loeNkiTHbq8DWcyd9Mg
   p+3v2Z2Wmu5UoWnF2WvtqgdTZjfo1/WX/WH/rcgrq+aYGF6Oqybupk/9N
   bwZaBgzIe4cAHW0LZutFoPIWC6b3bX/rO3gwLYIYtC8DDd/SWG+nN9Z9K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116150"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116150"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863764"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 097/102] KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
Date:   Mon, 27 Jun 2022 14:54:29 -0700
Message-Id: <76d4e3cef05d6560a8c7606d66acefd2b1298db3.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index d4ac573d9db3..b1a1a7d96f39 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1203,6 +1203,20 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
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
 static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -1297,6 +1311,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_GET_TD_VM_CALL_INFO:
+		return tdx_get_td_vm_call_info(vcpu);
 	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
 	case TDG_VP_VMCALL_MAP_GPA:
-- 
2.25.1

