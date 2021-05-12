Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A0837C32D
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhELPRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:49 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:13419 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhELPOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832417; x=1652368417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=oMhJxrjs2Es+3529yXwQICPY1v/fvMiXw1lk6BUiGrw=;
  b=ewQH27FlzuHxE0FFpiB4EiqJBIMP7B2kPDH0SI4bLUfbebuKsF3G8OFn
   opHigdIfThhBVoFLpK1gfx93PThNiTktioKMxfURapY5Zf0rIi5AQfkSp
   bSAgkRGghNTtVMcjqr9ysWGgo72tPuEK9LHxKsqzXJklUXGTKg4Jq2FB9
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="984968"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 12 May 2021 15:13:29 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 5D4A6A1F8E;
        Wed, 12 May 2021 15:13:25 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:13:15 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:13:15 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:13:13 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 09/10] KVM: VMX: Expose TSC scaling to L2
Date:   Wed, 12 May 2021 16:09:44 +0100
Message-ID: <20210512150945.4591-10-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose the TSC scaling feature to nested guests.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1dff1ebaccb..d431e17dbc5b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2277,7 +2277,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
-				  SECONDARY_EXEC_ENABLE_VMFUNC);
+				  SECONDARY_EXEC_ENABLE_VMFUNC |
+				  SECONDARY_EXEC_TSC_SCALING);
 		if (nested_cpu_has(vmcs12,
 				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 			exec_control |= vmcs12->secondary_vm_exec_control;
@@ -6479,7 +6480,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
-		SECONDARY_EXEC_XSAVES;
+		SECONDARY_EXEC_XSAVES |
+		SECONDARY_EXEC_TSC_SCALING;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
-- 
2.17.1

