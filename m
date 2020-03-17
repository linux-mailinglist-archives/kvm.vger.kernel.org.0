Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA2F1878BE
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCQEy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:54:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:34117 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbgCQExU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:20 -0400
IronPort-SDR: nYR2eiJM8rB468PzpJguwE52od/AyMWM3MfaM1FdBXc+UBCwUhrcHZj1smBLyRvZoknFatH7pF
 DQz9JJcanDMw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:19 -0700
IronPort-SDR: DK8Lwi9fXYsuCsnch1Nu2tPbvDX/rgWQS7eRWPcMyhxFeiKsMe+Om31vX31uIoiw6wG/5qq1Jz
 RfQIL5nmQgiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252803"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v2 21/32] KVM: SVM: Document the ASID logic in svm_flush_tlb()
Date:   Mon, 16 Mar 2020 21:52:27 -0700
Message-Id: <20200317045238.30434-22-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a comment in svm_flush_tlb() to document why it flushes only the
current ASID, even when it is invoked when flushing remote TLBs.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index dfa3b53f8437..8c3700b44eb4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5630,6 +5630,13 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * Flush only the current ASID even if the TLB flush was invoked via
+	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
+	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
+	 * unconditionally does a TLB flush on both nested VM-Enter and nested
+	 * VM-Exit (via kvm_mmu_reset_context()).
+	 */
 	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	else
-- 
2.24.1

