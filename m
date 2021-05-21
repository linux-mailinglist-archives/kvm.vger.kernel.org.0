Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BF038C4EB
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 12:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhEUKbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 06:31:24 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:59063 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbhEUKaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 06:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621592923; x=1653128923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=I/dhmgQOrgPFob7c+QN00T5JOFYlD1YVnZgZWGNgPY4=;
  b=hRzdCzZDHmlAtPg6iUKZUp0IsUNXTL8atuwIaMHyW6qGmg/hndTqiiYB
   /nBroRUadytdhHmae/aSMPO5cWfKtZrBl4s6kdob17BSyr6ueGZ4SeoAf
   uJDj0h5dpX7QcfaUnrIHJE57XLNHHmzI8LrLeg+faAZEbdZC4aE3trkeq
   g=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="2588341"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 21 May 2021 10:27:57 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 33ACE1201D7;
        Fri, 21 May 2021 10:27:56 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:40 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:40 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.83.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 10:27:38 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v3 11/12] KVM: VMX: Expose TSC scaling to L2
Date:   Fri, 21 May 2021 11:24:48 +0100
Message-ID: <20210521102449.21505-12-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521102449.21505-1-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
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
index f75c4174cbcf..e8183e224706 100644
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
@@ -6483,7 +6484,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
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

