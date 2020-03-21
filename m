Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744F618E401
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 20:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgCUThz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 15:37:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:55983 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbgCUThy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 15:37:54 -0400
IronPort-SDR: +zoDqsTSQK1GcIgGbhRCiFPDoj4jPHHYpdMd0YkBdhpGSnTRhkWARZH7USRU7HDcDSozr6ohez
 yKMQIwoz788A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 12:37:53 -0700
IronPort-SDR: Lqc48/gyfK7Dvjiwl5Oz5MhClOsTKlGUW0A/k71PzqZ35dNXPcJzWD+lsr/RdAK+G7W2MnT74N
 wp71pyXdkO2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="445353681"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 21 Mar 2020 12:37:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: VMX: Fold loaded_vmcs_init() into alloc_loaded_vmcs()
Date:   Sat, 21 Mar 2020 12:37:50 -0700
Message-Id: <20200321193751.24985-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200321193751.24985-1-sean.j.christopherson@intel.com>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Subsume loaded_vmcs_init() into alloc_loaded_vmcs(), its only remaining
caller, and drop the VMCLEAR on the shadow VMCS, which is guaranteed to
be NULL.  loaded_vmcs_init() was previously used by loaded_vmcs_clear(),
but loaded_vmcs_clear() also subsumed loaded_vmcs_init() to properly
handle smp_wmb() with respect to VMCLEAR.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++----------
 arch/x86/kvm/vmx/vmx.h |  1 -
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index efaca09455bf..07634caa560d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -653,15 +653,6 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
 	return ret;
 }
 
-void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
-{
-	vmcs_clear(loaded_vmcs->vmcs);
-	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
-		vmcs_clear(loaded_vmcs->shadow_vmcs);
-	loaded_vmcs->cpu = -1;
-	loaded_vmcs->launched = 0;
-}
-
 #ifdef CONFIG_KEXEC_CORE
 static void crash_vmclear_local_loaded_vmcss(void)
 {
@@ -2555,9 +2546,12 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	if (!loaded_vmcs->vmcs)
 		return -ENOMEM;
 
+	vmcs_clear(loaded_vmcs->vmcs);
+
 	loaded_vmcs->shadow_vmcs = NULL;
 	loaded_vmcs->hv_timer_soft_disabled = false;
-	loaded_vmcs_init(loaded_vmcs);
+	loaded_vmcs->cpu = -1;
+	loaded_vmcs->launched = 0;
 
 	if (cpu_has_vmx_msr_bitmap()) {
 		loaded_vmcs->msr_bitmap = (unsigned long *)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index be93d597306c..79d38f41ef7a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -492,7 +492,6 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 
 static inline struct vmcs *alloc_vmcs(bool shadow)
-- 
2.24.1

