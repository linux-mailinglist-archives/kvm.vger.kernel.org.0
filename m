Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDE06E5E60
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjDRKNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjDRKN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:13:28 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E8E76BD
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1681812801; x=1713348801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cAjxYkkeRSCzgrpXxpzIzKMLy7MpdwgBTi50ZLdSD+w=;
  b=TFns3aXZ/z4P7zaTapFLDsxxIEwwnzRsBABCTfW7mx0clA7lTkhrHgnx
   CLuFRSFOqJE0lLHfkYdvDOXkJ1u7bMzfhICXghl84jPPw5iGGbf1KjdLJ
   rG409HOX9ATbr1L7AO6ejhsoqCR7kmm34uyprcA1vxlzRXzF6h0vObtw1
   4=;
X-IronPort-AV: E=Sophos;i="5.99,206,1677542400"; 
   d="scan'208";a="321637039"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:13:14 +0000
Received: from EX19MTAUEC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id B509F80F9A;
        Tue, 18 Apr 2023 10:13:12 +0000 (UTC)
Received: from EX19D008UEA002.ant.amazon.com (10.252.134.125) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 10:13:12 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19D008UEA002.ant.amazon.com (10.252.134.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 10:13:12 +0000
Received: from dev-dsk-metikaya-1c-d447d167.eu-west-1.amazon.com
 (10.13.250.103) by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25 via Frontend Transport; Tue, 18 Apr 2023 10:13:09 +0000
From:   Metin Kaya <metikaya@amazon.co.uk>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <x86@kernel.org>, <bp@alien8.de>, <dwmw@amazon.co.uk>,
        <paul@xen.org>, <seanjc@google.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
        <joao.m.martins@oracle.com>, Metin Kaya <metikaya@amazon.co.uk>
Subject: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
Date:   Tue, 18 Apr 2023 10:13:06 +0000
Message-ID: <20230418101306.98263-1-metikaya@amazon.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
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

Implement in-KVM support for Xen's HVMOP_flush_tlbs hypercall, which
allows the guest to flush all vCPU's TLBs. KVM doesn't provide an
ioctl() to precisely flush guest TLBs, and punting to userspace would
likely negate the performance benefits of avoiding a TLB shootdown in
the guest.

Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>

---
v3:
  - Addressed comments for v2.
  - Verified with XTF/invlpg test case.

v2:
  - Removed an irrelevant URL from commit message.
---
 arch/x86/kvm/xen.c                 | 15 +++++++++++++++
 include/xen/interface/hvm/hvm_op.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..a63c48e8d8fa 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -21,6 +21,7 @@
 #include <xen/interface/vcpu.h>
 #include <xen/interface/version.h>
 #include <xen/interface/event_channel.h>
+#include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/sched.h>
 
 #include <asm/xen/cpuid.h>
@@ -1330,6 +1331,17 @@ static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, bool longmode,
 	return false;
 }
 
+static bool kvm_xen_hcall_hvm_op(struct kvm_vcpu *vcpu, int cmd, u64 arg, u64 *r)
+{
+	if (cmd == HVMOP_flush_tlbs && !arg) {
+		kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_TLB_FLUSH_GUEST);
+		*r = 0;
+		return true;
+	}
+
+	return false;
+}
+
 struct compat_vcpu_set_singleshot_timer {
     uint64_t timeout_abs_ns;
     uint32_t flags;
@@ -1501,6 +1513,9 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 			timeout |= params[1] << 32;
 		handled = kvm_xen_hcall_set_timer_op(vcpu, timeout, &r);
 		break;
+	case __HYPERVISOR_hvm_op:
+		handled = kvm_xen_hcall_hvm_op(vcpu, params[0], params[1], &r);
+		break;
 	}
 	default:
 		break;
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
index 03134bf3cec1..240d8149bc04 100644
--- a/include/xen/interface/hvm/hvm_op.h
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -16,6 +16,9 @@ struct xen_hvm_param {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_param);
 
+/* Flushes guest TLBs for all vCPUs: @arg must be 0. */
+#define HVMOP_flush_tlbs            5
+
 /* Hint from PV drivers for pagetable destruction. */
 #define HVMOP_pagetable_dying       9
 struct xen_hvm_pagetable_dying {
-- 
2.39.2

