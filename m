Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F44520F1ED
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 11:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732133AbgF3JsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 05:48:23 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:21770 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732126AbgF3JsX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 05:48:23 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 30 Jun 2020 02:48:19 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 180E6B27E6;
        Tue, 30 Jun 2020 05:48:20 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 2/5] x86: svm: check TSC adjust support
Date:   Tue, 30 Jun 2020 02:45:13 -0700
Message-ID: <20200630094516.22983-3-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630094516.22983-1-namit@vmware.com>
References: <20200630094516.22983-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR_IA32_TSC_ADJUST may be supported by KVM on AMD machines, but it does
not show on AMD manual. Check CPUID to see if it supported before
running the relevant tests.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/svm_tests.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a2c993d..92cefaf 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -893,6 +893,11 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 #define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
 
+static bool tsc_adjust_supported(void)
+{
+    return this_cpu_has(X86_FEATURE_TSC_ADJUST);
+}
+
 static void tsc_adjust_prepare(struct svm_test *test)
 {
     default_prepare(test);
@@ -2010,7 +2015,7 @@ struct svm_test svm_tests[] = {
     { "npt_rw_l1mmio", npt_supported, npt_rw_l1mmio_prepare,
       default_prepare_gif_clear, npt_rw_l1mmio_test,
       default_finished, npt_rw_l1mmio_check },
-    { "tsc_adjust", default_supported, tsc_adjust_prepare,
+    { "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
       default_prepare_gif_clear, tsc_adjust_test,
       default_finished, tsc_adjust_check },
     { "latency_run_exit", default_supported, latency_prepare,
-- 
2.25.1

