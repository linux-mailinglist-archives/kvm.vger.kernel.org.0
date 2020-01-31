Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543A614F03E
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAaP5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:57:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34228 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbgAaP5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 10:57:25 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1ixYfZ-0005XW-Gz; Fri, 31 Jan 2020 15:57:22 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kvm: do not setup pv tlb flush when not paravirtualized
Date:   Fri, 31 Jan 2020 12:56:55 -0300
Message-Id: <20200131155655.49812-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_setup_pv_tlb_flush will waste memory and print a misguiding message
when KVM paravirtualization is not available.

Intel SDM says that the when cpuid is used with EAX higher than the
maximum supported value for basic of extended function, the data for the
highest supported basic function will be returned.

So, in some systems, kvm_arch_para_features will return bogus data,
causing kvm_setup_pv_tlb_flush to detect support for pv tlb flush.

Testing for kvm_para_available will work as it checks for the hypervisor
signature.

Besides, when the "nopv" command line parameter is used, it should not
continue as well, as kvm_guest_init will no be called in that case.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/kernel/kvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 81045aabb6f4..d817f255aed8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -736,6 +736,9 @@ static __init int kvm_setup_pv_tlb_flush(void)
 {
 	int cpu;
 
+	if (!kvm_para_available() || nopv)
+		return 0;
+
 	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
-- 
2.24.0

