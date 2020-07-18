Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F037F22494F
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 08:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgGRGjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 02:39:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:30319 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgGRGjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jul 2020 02:39:01 -0400
IronPort-SDR: r0A0JB1oajJ29rhhkVdRyhJiFNBkgkw5/bH233KOrzWx14QjfOLubZhuMWRCYV34j903P6tUU6
 sVcgXATOp2CA==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="151079553"
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="151079553"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 23:39:00 -0700
IronPort-SDR: WqBGYgKWUBAFm9qTIPSxn35YWrWClTpoBhdGM4JL6q7BDnxWQbuQ5EZQ6LUvWOyYLPpnOrth1y
 wIfRME2nTG3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="486690949"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 23:39:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] KVM: x86: Add RIP to the kvm_entry, i.e. VM-Enter, tracepoint
Date:   Fri, 17 Jul 2020 23:38:48 -0700
Message-Id: <20200718063854.16017-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200718063854.16017-1-sean.j.christopherson@intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add RIP to the kvm_entry tracepoint to help debug if the kvm_exit
tracepoint is disable or if VM-Enter fails, in which case the kvm_exit
tracepoint won't be hit.

Read RIP from within the tracepoint itself to avoid a potential VMREAD
and retpoline if the guest's RIP isn't available.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/trace.h | 10 ++++++----
 arch/x86/kvm/x86.c   |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b66432b015d2e..9899ff0fa2534 100644
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
index 5f526d94c33f3..3563359316d64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8547,7 +8547,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_x86_ops.request_immediate_exit(vcpu);
 	}
 
-	trace_kvm_entry(vcpu->vcpu_id);
+	trace_kvm_entry(vcpu);
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-- 
2.26.0

