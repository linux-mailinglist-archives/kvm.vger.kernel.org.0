Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA41C229C96
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgGVQBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:54 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38094 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730402AbgGVQBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2225A305D654;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0D129305FFB6;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 29/34] KVM: vmx: make use of EPTP_INDEX in vmx_handle_exit()
Date:   Wed, 22 Jul 2020 19:01:16 +0300
Message-Id: <20200722160121.9601-30-alazar@bitdefender.com>
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

If the guest has EPTP switching capabilities with VMFUNC, read the
current view from VMCS instead of walking through the EPTP list when #VE
support is active.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96aa4b7e2857..035f6c43a2a4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6269,15 +6269,21 @@ void dump_vmcs(void)
 
 static unsigned int update_ept_view(struct vcpu_vmx *vmx)
 {
-	u64 *eptp_list = phys_to_virt(page_to_phys(vmx->eptp_list_pg));
-	u64 eptp = vmcs_read64(EPT_POINTER);
-	unsigned int view;
+	/* if #VE support is active, read the EPT index from VMCS */
+	if (kvm_ve_supported &&
+	    secondary_exec_controls_get(vmx) & SECONDARY_EXEC_EPT_VE) {
+		vmx->view = vmcs_read16(EPTP_INDEX);
+	} else {
+		u64 *eptp_list = phys_to_virt(page_to_phys(vmx->eptp_list_pg));
+		u64 eptp = vmcs_read64(EPT_POINTER);
+		unsigned int view;
 
-	for (view = 0; view < KVM_MAX_EPT_VIEWS; view++)
-		if (eptp_list[view] == eptp) {
-			vmx->view = view;
-			break;
-		}
+		for (view = 0; view < KVM_MAX_EPT_VIEWS; view++)
+			if (eptp_list[view] == eptp) {
+				vmx->view = view;
+				break;
+			}
+	}
 
 	return vmx->view;
 }
