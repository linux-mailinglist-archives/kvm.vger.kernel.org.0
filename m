Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF176E4796
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 14:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjDQMYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 08:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjDQMYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 08:24:31 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB7E40E3
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 05:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1681734238; x=1713270238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gfe+8HDjV5SU9/ZBrdrb4UQOBSL9RtsaG8eEKBBNBCg=;
  b=lO71bB7ILdpmZd20/vvTjKwfiv+kDrQS4bbf067S1IWHNOLm4RMou5Fj
   T/RzBFyv9VGS8Tv6fvQUBAvltS6/iQN6JkUIdIjk61Umk4Z2noiexNYHC
   JEABn9XBx+Rmbg6mxdzBEOmxUpWz3lO3l4KE1siRnal7ijhHRMzkyi/zJ
   k=;
X-IronPort-AV: E=Sophos;i="5.99,204,1677542400"; 
   d="scan'208";a="1123273937"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 12:23:10 +0000
Received: from EX19MTAUEC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id 289E74516E;
        Mon, 17 Apr 2023 12:23:06 +0000 (UTC)
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 12:22:48 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 12:22:47 +0000
Received: from dev-dsk-metikaya-1c-d447d167.eu-west-1.amazon.com
 (10.13.250.103) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Mon, 17 Apr 2023 12:22:45 +0000
From:   Metin Kaya <metikaya@amazon.co.uk>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <x86@kernel.org>, <bp@alien8.de>, <dwmw@amazon.co.uk>,
        <paul@xen.org>, <seanjc@google.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
        <joao.m.martins@oracle.com>, Metin Kaya <metikaya@amazon.co.uk>
Subject: [PATCH v2] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
Date:   Mon, 17 Apr 2023 12:22:06 +0000
Message-ID: <20230417122206.34647-2-metikaya@amazon.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417122206.34647-1-metikaya@amazon.co.uk>
References: <20230417122206.34647-1-metikaya@amazon.co.uk>
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

