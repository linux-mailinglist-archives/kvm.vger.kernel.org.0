Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB81768DE
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgCCAAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:00:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:17173 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbgCBX51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384799"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 58/66] KVM: SVM: Refactor logging of NPT enabled/disabled
Date:   Mon,  2 Mar 2020 15:57:01 -0800
Message-Id: <20200302235709.27467-59-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tweak SVM's logging of NPT enabled/disabled to handle the logging in a
single pr_info() in preparation for merging kvm_enable_tdp() and
kvm_disable_tdp() into a single function.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9dc614cfd129..efc3ec9d8fef 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1457,16 +1457,14 @@ static __init int svm_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_NPT))
 		npt_enabled = false;
 
-	if (npt_enabled && !npt) {
-		printk(KERN_INFO "kvm: Nested Paging disabled\n");
+	if (npt_enabled && !npt)
 		npt_enabled = false;
-	}
 
-	if (npt_enabled) {
-		printk(KERN_INFO "kvm: Nested Paging enabled\n");
+	if (npt_enabled)
 		kvm_enable_tdp();
-	} else
+	else
 		kvm_disable_tdp();
+	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	if (nrips) {
 		if (!boot_cpu_has(X86_FEATURE_NRIPS))
-- 
2.24.1

