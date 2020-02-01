Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9C14F9E8
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgBASzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:55:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:57288 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbgBASwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075598"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 56/61] KVM: SVM: Refactor logging of NPT enabled/disabled
Date:   Sat,  1 Feb 2020 10:52:13 -0800
Message-Id: <20200201185218.24473-57-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a27f83f7521c..80962c1eea8f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1440,16 +1440,14 @@ static __init int svm_hardware_setup(void)
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

