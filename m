Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AF32761BF
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgIWUNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:13:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:49295 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgIWUNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:13:50 -0400
IronPort-SDR: /OBzYv/O9YrOj3CWG0trck4RZikROSRGaw+l96twlMsNdZhkBJE6swaGCJshRDKwvG6uHgK2Ab
 5nHsGBrJrJbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140472232"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140472232"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 13:13:50 -0700
IronPort-SDR: 90NV0U+DsvdbgCFbgCd0gNO1XvAW9VxnTaukmjX7XMMrMzwn3K3ypTYFi3omi6v3XCPP3hu4PG
 bqnCRJ0O9TXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="349004936"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2020 13:13:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: x86: Add RIP to the kvm_entry, i.e. VM-Enter, tracepoint
Date:   Wed, 23 Sep 2020 13:13:43 -0700
Message-Id: <20200923201349.16097-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923201349.16097-1-sean.j.christopherson@intel.com>
References: <20200923201349.16097-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add RIP to the kvm_entry tracepoint to help debug if the kvm_exit
tracepoint is disabled or if VM-Enter fails, in which case the kvm_exit
tracepoint won't be hit.

Read RIP from within the tracepoint itself to avoid a potential VMREAD
and retpoline if the guest's RIP isn't available.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/trace.h | 10 ++++++----
 arch/x86/kvm/x86.c   |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 11cb4c070f0c..7e8edc7a1f73 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -15,18 +15,20 @@
  * Tracepoint for guest mode entry.
  */
 TRACE_EVENT(kvm_entry,
-	TP_PROTO(unsigned int vcpu_id),
-	TP_ARGS(vcpu_id),
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
+		__field(	unsigned long,	rip		)
 	),
 
 	TP_fast_assign(
-		__entry->vcpu_id	= vcpu_id;
+		__entry->vcpu_id        = vcpu->vcpu_id;
+		__entry->rip		= kvm_rip_read(vcpu);
 	),
 
-	TP_printk("vcpu %u", __entry->vcpu_id)
+	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
 );
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17f4995e80a7..95f8e5685911 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8546,7 +8546,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_x86_ops.request_immediate_exit(vcpu);
 	}
 
-	trace_kvm_entry(vcpu->vcpu_id);
+	trace_kvm_entry(vcpu);
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-- 
2.28.0

