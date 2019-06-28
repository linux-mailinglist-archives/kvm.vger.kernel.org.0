Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791505992A
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 13:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfF1LXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 07:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfF1LXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 07:23:46 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D84F7307D913;
        Fri, 28 Jun 2019 11:23:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E2515DC18;
        Fri, 28 Jun 2019 11:23:38 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 1/2] x86/KVM/nVMX: don't use clean fields data on enlightened VMLAUNCH
Date:   Fri, 28 Jun 2019 13:23:32 +0200
Message-Id: <20190628112333.31165-2-vkuznets@redhat.com>
In-Reply-To: <20190628112333.31165-1-vkuznets@redhat.com>
References: <20190628112333.31165-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 28 Jun 2019 11:23:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apparently, Windows doesn't maintain clean fields data after it does
VMCLEAR for an enlightened VMCS so we can only use it on VMRESUME.
The issue went unnoticed because currently we do nested_release_evmcs()
in handle_vmclear() and the consecutive enlightened VMPTRLD invalidates
clean fields when a new eVMCS is mapped but we're going to change the
logic.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7abb8e68e990..f1dfb8ef4634 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1766,6 +1766,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct hv_vp_assist_page assist_page;
+	bool evmcs_gpa_changed = false;
 
 	if (likely(!vmx->nested.enlightened_vmcs_enabled))
 		return 1;
@@ -1819,15 +1820,9 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 		}
 
 		vmx->nested.dirty_vmcs12 = true;
-		/*
-		 * As we keep L2 state for one guest only 'hv_clean_fields' mask
-		 * can't be used when we switch between them. Reset it here for
-		 * simplicity.
-		 */
-		vmx->nested.hv_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		vmx->nested.hv_evmcs_vmptr = assist_page.current_nested_vmcs;
 
+		evmcs_gpa_changed = true;
 		/*
 		 * Unlike normal vmcs12, enlightened vmcs12 is not fully
 		 * reloaded from guest's memory (read only fields, fields not
@@ -1841,6 +1836,15 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 		}
 
 	}
+
+	/*
+	 * Clean fields data can't de used on VMLAUNCH and when we switch
+	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
+	 */
+	if (from_launch || evmcs_gpa_changed)
+		vmx->nested.hv_evmcs->hv_clean_fields &=
+			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+
 	return 1;
 }
 
@@ -3074,7 +3078,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (!nested_vmx_handle_enlightened_vmptrld(vcpu, true))
+	if (!nested_vmx_handle_enlightened_vmptrld(vcpu, launch))
 		return 1;
 
 	if (!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull)
-- 
2.20.1

