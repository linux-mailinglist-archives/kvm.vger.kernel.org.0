Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620823B8E1C
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 09:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhGAHWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 03:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234553AbhGAHWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 03:22:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9F2B61450;
        Thu,  1 Jul 2021 07:19:35 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lyqyz-00AwZh-BQ; Thu, 01 Jul 2021 08:19:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org
Cc:     kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: selftests: x86: Address missing vm_install_exception_handler conversions
Date:   Thu,  1 Jul 2021 08:19:28 +0100
Message-Id: <20210701071928.2971053-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kernel-team@android.com, drjones@redhat.com, ricarkol@google.com, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit b78f4a59669 ("KVM: selftests: Rename vm_handle_exception")
raced with a couple of new x86 tests, missing two vm_handle_exception
to vm_install_exception_handler conversions.

Help the two broken tests to catch up with the new world.

Cc: Andrew Jones <drjones@redhat.com>
CC: Ricardo Koller <ricarkol@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 2 +-
 tools/testing/selftests/kvm/x86_64/mmu_role_test.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 42bd658f52a8..af27c7e829c1 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -615,7 +615,7 @@ int main(void)
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	pr_info("Testing access to Hyper-V specific MSRs\n");
 	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
index 523371cf8e8f..da2325fcad87 100644
--- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
@@ -71,7 +71,7 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
 	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, PF_VECTOR, guest_pf_handler);
+	vm_install_exception_handler(vm, PF_VECTOR, guest_pf_handler);
 
 	r = _vcpu_run(vm, VCPU_ID);
 	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
-- 
2.30.2

