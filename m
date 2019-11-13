Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F23FA029
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 02:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKMBb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 20:31:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:55392 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfKMBb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 20:31:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 17:31:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,298,1569308400"; 
   d="scan'208";a="235090663"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by fmsmga002.fm.intel.com with ESMTP; 12 Nov 2019 17:31:25 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH] KVM: X86: Reset the three MSR list number variables to 0 in kvm_init_msr_list()
Date:   Wed, 13 Nov 2019 09:15:21 +0800
Message-Id: <20191113011521.32255-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When applying commit 7a5ee6edb42e ("KVM: X86: Fix initialization of MSR
lists"), it forgot to reset the three MSR lists number varialbes to 0
while removing the useless conditionals.

Fixes: 7a5ee6edb42e (KVM: X86: Fix initialization of MSR lists)
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c8a5e20ea06..9368b0e6bf21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5102,6 +5102,10 @@ static void kvm_init_msr_list(void)
 
 	perf_get_x86_pmu_capability(&x86_pmu);
 
+	num_msrs_to_save = 0;
+	num_emulated_msrs = 0;
+	num_msr_based_features = 0;
+
 	for (i = 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
 		if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
 			continue;
-- 
2.19.1

