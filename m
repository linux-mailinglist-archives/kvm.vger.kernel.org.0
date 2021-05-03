Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D21371790
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhECPKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhECPKC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620054548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SBgP2q+jMXRjW+m5Dci4J74cvlT/I0xwnXsUOeHMQjA=;
        b=IpeIaA7+JOmKimIynNNrEOywMoWHLWvYBe9V5taCp4au/yZ2QtD8DNbx+fuW3Rus/A48XJ
        i63X5h4sEdmc0ECam35vFvBtmf50saHj2wV12A/jndCkRvFsZiwdS7rm6nFMKuemj4wFAg
        jSp4pqCClOHkWW0dbMVz54Ev/8Vjglc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-Z_JRf-feNcCjMWrnSnpyIA-1; Mon, 03 May 2021 11:09:06 -0400
X-MC-Unique: Z_JRf-feNcCjMWrnSnpyIA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC6621006708;
        Mon,  3 May 2021 15:09:05 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B57F19C45;
        Mon,  3 May 2021 15:09:03 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: nVMX: Introduce __nested_vmx_handle_enlightened_vmptrld()
Date:   Mon,  3 May 2021 17:08:53 +0200
Message-Id: <20210503150854.1144255-4-vkuznets@redhat.com>
In-Reply-To: <20210503150854.1144255-1-vkuznets@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to mapping eVMCS from vmx_set_nested_state() split
the actual eVMCS mappign from aquiring eVMCS GPA.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2febb1dd68e8..37fdc34f7afc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1972,18 +1972,11 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
  * This is an equivalent of the nested hypervisor executing the vmptrld
  * instruction.
  */
-static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
-	struct kvm_vcpu *vcpu, bool from_launch)
+static enum nested_evmptrld_status __nested_vmx_handle_enlightened_vmptrld(
+	struct kvm_vcpu *vcpu, u64 evmcs_gpa, bool from_launch)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool evmcs_gpa_changed = false;
-	u64 evmcs_gpa;
-
-	if (likely(!vmx->nested.enlightened_vmcs_enabled))
-		return EVMPTRLD_DISABLED;
-
-	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
-		return EVMPTRLD_DISABLED;
 
 	if (unlikely(!vmx->nested.hv_evmcs ||
 		     evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
@@ -2055,6 +2048,21 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	return EVMPTRLD_SUCCEEDED;
 }
 
+static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
+	struct kvm_vcpu *vcpu, bool from_launch)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 evmcs_gpa;
+
+	if (likely(!vmx->nested.enlightened_vmcs_enabled))
+		return EVMPTRLD_DISABLED;
+
+	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
+		return EVMPTRLD_DISABLED;
+
+	return __nested_vmx_handle_enlightened_vmptrld(vcpu, evmcs_gpa, from_launch);
+}
+
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-- 
2.30.2

