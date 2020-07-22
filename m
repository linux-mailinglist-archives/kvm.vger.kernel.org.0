Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EA5229C8A
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgGVQBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:42 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37948 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730292AbgGVQBl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B9D1E305D770;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B0358305FFAB;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 24/34] KVM: vmx: trigger vm-exits for mmio sptes by default when #VE is enabled
Date:   Wed, 22 Jul 2020 19:01:11 +0300
Message-Id: <20200722160121.9601-25-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

All sptes, including mmio sptes must have SVE bit set by default, in
order to trigger vm-exits instead of #VEs (in case of an EPT violation).
MMIO sptes were overlooked in commit 28b8bc704111 ("KVM: VMX: Suppress EPT violation #VE by default (when enabled)")
which provided a new mask for non-mmio sptes.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3428857c6157..b65bd0d144e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4367,11 +4367,19 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 
 static void ept_set_mmio_spte_mask(void)
 {
+	u64 mmio_value = VMX_EPT_MISCONFIG_WX_VALUE;
+
+	/* All sptes, including mmio sptes should trigger vm-exits by
+	 * default, instead of #VE (when supported)
+	 */
+	if (kvm_ve_supported)
+		mmio_value |= VMX_EPT_SUPPRESS_VE_BIT;
+
 	/*
 	 * EPT Misconfigurations can be generated if the value of bits 2:0
 	 * of an EPT paging-structure entry is 110b (write/execute).
 	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE, 0);
+	kvm_mmu_set_mmio_spte_mask(mmio_value, 0);
 }
 
 static int vmx_alloc_eptp_list_page(struct vcpu_vmx *vmx)
