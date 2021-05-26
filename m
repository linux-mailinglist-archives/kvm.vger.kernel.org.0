Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C2B3918B9
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhEZNYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:24:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233767AbhEZNY3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JdCTF5PBzPxW9MAYm7aSIdB7yWytV+JiqIPxyeydDk=;
        b=AcgptbAGvIF4dtaLQRod8u54yn51FhKg63ik6U0YlegZ32BcfT8K+2XWtxriA2Vwo1Lijg
        Mt2Uentjr2T/UipbnW8Vc/3gj9ziXZoFLqZXOSc/gNbL5dH554/BPtJultbjB5P8qwt4rk
        W6yEaWrs+xRFb7VQAsbcIw2biSMFw2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-4V_3p3v1ODyE3bFv22Bjeg-1; Wed, 26 May 2021 09:22:56 -0400
X-MC-Unique: 4V_3p3v1ODyE3bFv22Bjeg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AF2C800D62;
        Wed, 26 May 2021 13:22:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71D095D9C6;
        Wed, 26 May 2021 13:22:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/11] KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
Date:   Wed, 26 May 2021 15:20:25 +0200
Message-Id: <20210526132026.270394-11-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCS12 is used to keep the authoritative state during nested state
migration. In case 'need_vmcs12_to_shadow_sync' flag is set, we're
in between L2->L1 vmexit and L1 guest run when actual sync to
enlightened (or shadow) VMCS happens. Nested state, however, has
no flag for 'need_vmcs12_to_shadow_sync' so vmx_set_nested_state()->
set_current_vmptr() always sets it. Enlightened vmptrld path, however,
doesn't have the quirk so some VMCS12 changes may not get properly
reflected to eVMCS and L1 will see an incorrect state.

Note, during L2 execution or when need_vmcs12_to_shadow_sync is not
set the change is effectively a nop: in the former case all changes
will get reflected during the first L2->L1 vmexit and in the later
case VMCS12 and eVMCS are already in sync (thanks to
copy_enlightened_to_vmcs12() in vmx_get_nested_state()).

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0f2e8eea2110..6682b1923d3a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3111,6 +3111,12 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 		if (evmptrld_status == EVMPTRLD_VMFAIL ||
 		    evmptrld_status == EVMPTRLD_ERROR)
 			return false;
+
+		/*
+		 * Post migration VMCS12 always provides the most actual
+		 * information, copy it to eVMCS upon entry.
+		 */
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	}
 
 	return true;
-- 
2.31.1

