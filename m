Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05371878C8
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCQEy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:54:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:34106 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgCQExR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:17 -0400
IronPort-SDR: sLtjLyqztuC7vuiec/F/3BnNz5BLyzqxfuF9ucTuYsAtRGkFupAXjY9lw5y7bxSFlEugFa9Aqx
 UIiUxgWrBUJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:16 -0700
IronPort-SDR: bcIhZL2VZ5/CDztyt4LNvQkVIa+X9pXthdpwYDJQPy6m2wZqQ7EbrGHMqOa99+1snlAhsuoBGt
 8VeVWZ1UyFtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252783"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:16 -0700
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
Subject: [PATCH v2 15/32] KVM: VMX: Clean up vmx_flush_tlb_gva()
Date:   Mon, 16 Mar 2020 21:52:21 -0700
Message-Id: <20200317045238.30434-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor vmx_flush_tlb_gva() to remove a superfluous local variable and
clean up its comment, which is oddly located below the code it is
commenting.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57c1cee58d18..43c0d4706f9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2851,15 +2851,11 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
-	int vpid = to_vmx(vcpu)->vpid;
-
-	vpid_sync_vcpu_addr(vpid, addr);
-
 	/*
-	 * If VPIDs are not supported or enabled, then the above is a no-op.
-	 * But we don't really need a TLB flush in that case anyway, because
-	 * each VM entry/exit includes an implicit flush when VPID is 0.
+	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
+	 * vmx_flush_tlb_guest() for an explanation of why this is ok.
 	 */
+	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
 }
 
 static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
-- 
2.24.1

