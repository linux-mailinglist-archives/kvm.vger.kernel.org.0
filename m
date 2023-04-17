Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF776E4723
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjDQMIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 08:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjDQMIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 08:08:52 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77828A5B
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 05:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1681733276; x=1713269276;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OuJntwGbeRgDEYhgLe+rMLck7qLCknQwH8lGoRAwlT4=;
  b=fHvnV8wu7Hs7p9c3+szFjuNOVog3B+nDdPR0P/T6X38Mcix5OznWCvR+
   TQtxdpTXK1T2lxNtzv2eA19YOZ9INUlr9mK6vjgdXszSHBxgcBRvC6vNE
   /bhOVjaEK43qLIcI1u2kOKEpBxfGya3XJOxlrecafiD85dcj/i7XPRQat
   U=;
X-IronPort-AV: E=Sophos;i="5.99,204,1677542400"; 
   d="scan'208";a="321185288"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 12:07:11 +0000
Received: from EX19MTAUEB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id C40E9A2D48;
        Mon, 17 Apr 2023 12:07:08 +0000 (UTC)
Received: from EX19D008UEC003.ant.amazon.com (10.252.135.194) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 12:06:52 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D008UEC003.ant.amazon.com (10.252.135.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 12:06:52 +0000
Received: from dev-dsk-metikaya-1c-d447d167.eu-west-1.amazon.com
 (10.13.250.103) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Mon, 17 Apr 2023 12:06:50 +0000
From:   Metin Kaya <metikaya@amazon.co.uk>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <x86@kernel.org>, <bp@alien8.de>, <dwmw@amazon.co.uk>,
        <paul@xen.org>, <seanjc@google.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
        <joao.m.martins@oracle.com>, Metin Kaya <metikaya@amazon.co.uk>
Subject: [PATCH] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
Date:   Mon, 17 Apr 2023 12:06:45 +0000
Message-ID: <20230417120645.72242-1-metikaya@amazon.co.uk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HVMOP_flush_tlbs suboperation of hvm_op hypercall allows a guest to
flush all vCPU TLBs. There is no way for the VMM to flush TLBs from
userspace. Hence, this patch adds support for flushing vCPU TLBs to KVM
by making a KVM_REQ_TLB_FLUSH_GUEST request for all guest vCPUs.

Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>

CR: https://code.amazon.com/reviews/CR-89597111
---
 arch/x86/kvm/xen.c                 | 31 ++++++++++++++++++++++++++++++
 include/xen/interface/hvm/hvm_op.h |  3 +++
 2 files changed, 34 insertions(+)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..78fa6d08bebc 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -21,6 +21,7 @@
 #include <xen/interface/vcpu.h>
 #include <xen/interface/version.h>
 #include <xen/interface/event_channel.h>
+#include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/sched.h>
 
 #include <asm/xen/cpuid.h>
@@ -1330,6 +1331,32 @@ static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, bool longmode,
 	return false;
 }
 
+static void kvm_xen_hvmop_flush_tlbs(struct kvm_vcpu *vcpu, bool longmode,
+				     u64 arg, u64 *r)
+{
+	if (arg) {
+		*r = -EINVAL;
+		return;
+	}
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
+	*r = 0;
+}
+
+static bool kvm_xen_hcall_hvm_op(struct kvm_vcpu *vcpu, bool longmode,
+				 int cmd, u64 arg, u64 *r)
+{
+	switch (cmd) {
+	case HVMOP_flush_tlbs:
+		kvm_xen_hvmop_flush_tlbs(vcpu, longmode, arg, r);
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 struct compat_vcpu_set_singleshot_timer {
     uint64_t timeout_abs_ns;
     uint32_t flags;
@@ -1501,6 +1528,10 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 			timeout |= params[1] << 32;
 		handled = kvm_xen_hcall_set_timer_op(vcpu, timeout, &r);
 		break;
+	case __HYPERVISOR_hvm_op:
+		handled = kvm_xen_hcall_hvm_op(vcpu, longmode, params[0], params[1],
+					       &r);
+		break;
 	}
 	default:
 		break;
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
index 03134bf3cec1..373123226c6f 100644
--- a/include/xen/interface/hvm/hvm_op.h
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -16,6 +16,9 @@ struct xen_hvm_param {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_param);
 
+/* Flushes all VCPU TLBs: @arg must be NULL. */
+#define HVMOP_flush_tlbs            5
+
 /* Hint from PV drivers for pagetable destruction. */
 #define HVMOP_pagetable_dying       9
 struct xen_hvm_pagetable_dying {
-- 
2.39.2

