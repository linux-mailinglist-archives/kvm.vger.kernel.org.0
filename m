Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E852E1878D7
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgCQEzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:55:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:34105 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgCQExN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:13 -0400
IronPort-SDR: vqy1bLstdA9x/QUbFPuHEaM/7NlHJ9V8Rl9EaALeczuM4itEwh3Vkqb6xXcJN2Sy2LiGut6/ji
 WwNgY7CJl11g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:13 -0700
IronPort-SDR: vM7OJp7X91z6nOnMqc6nQyav74o1PYSBiswzroOdSGvtqEpspYtfA4UyKNWD3AQoTcyXQJxc+j
 VToWf7z1Qiaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252758"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:12 -0700
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
Subject: [PATCH v2 08/32] KVM: VMX: Skip global INVVPID fallback if vpid==0 in vpid_sync_context()
Date:   Mon, 16 Mar 2020 21:52:14 -0700
Message-Id: <20200317045238.30434-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the global INVVPID in the unlikely scenario that vpid==0 and the
SINGLE_CONTEXT variant of INVVPID is unsupported.  If vpid==0, there's
no need to INVVPID as it's impossible to do VM-Enter with VPID enabled
and vmcs.VPID==0, i.e. there can't be any TLB entries for the vCPU with
vpid==0.  The fact that the SINGLE_CONTEXT variant isn't supported is
irrelevant.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 45eaedee2ac0..33645a8e5463 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -285,7 +285,7 @@ static inline void vpid_sync_context(int vpid)
 {
 	if (cpu_has_vmx_invvpid_single())
 		vpid_sync_vcpu_single(vpid);
-	else
+	else if (vpid != 0)
 		vpid_sync_vcpu_global();
 }
 
-- 
2.24.1

