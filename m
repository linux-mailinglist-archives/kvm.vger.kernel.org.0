Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CC94CDD84
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiCDT7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB242240DCE;
        Fri,  4 Mar 2022 11:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423445; x=1677959445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qKx+rgcTFhpEcERIfgphya3th3nYVglGjlcgVoVagDo=;
  b=SERP3ohGCtd88ukRyLcKW2ET0lLrU+7MVfKJaoYfwhVPNyfxq9XGKV/0
   5V8l6CxhKp8zop9QSNlv38EvgJZt0nzaXntISfemlpob0C4Urv4NVjXow
   C6D1cnbKlBXMon7HOvnA3192wOOavsmI6OfOx2xOhMCsEUMMXxSTR0wTv
   6ZGZ4vjtFpRY8qJCx6TQARlSQ0NpkUbJdFfu0mEgZ9kWsbWGNOwCgPjzV
   9IPojf/VM2/0kaYILdhmj7tVWIbvm6DmjkTtRkg3mYJotfo77/u/RVvCX
   ITEP9tEvl93e5zV2SI5E5bpfKWQXqmGpt+4eSHjygOWInU1JD7k/XQZw9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779653"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779653"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344557"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:43 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 091/104] KVM: TDX: Handle TDX PV CPUID hypercall
Date:   Fri,  4 Mar 2022 11:49:47 -0800
Message-Id: <e3621e9893796d2bd8ea8b1f16c1616ae9df3f37.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV CPUID hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 53f59fb92dcf..f7c9170d596a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -893,6 +893,30 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+
+	/* EAX and ECX for cpuid is stored in R12 and R13. */
+	eax = tdvmcall_p1_read(vcpu);
+	ecx = tdvmcall_p2_read(vcpu);
+
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
+
+	/*
+	 * The returned value for CPUID (EAX, EBX, ECX, and EDX) is stored into
+	 * R12, R13, R14, and R15.
+	 */
+	tdvmcall_p1_write(vcpu, eax);
+	tdvmcall_p2_write(vcpu, ebx);
+	tdvmcall_p3_write(vcpu, ecx);
+	tdvmcall_p4_write(vcpu, edx);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -904,6 +928,9 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_vmcall(vcpu);
 
 	switch (tdvmcall_exit_reason(vcpu)) {
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
+
 	default:
 		break;
 	}
-- 
2.25.1

