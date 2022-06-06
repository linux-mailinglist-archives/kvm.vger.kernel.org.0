Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB21553ED93
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiFFSI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiFFSIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:08:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D15C62CD4
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 11:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654538928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJqqZQUOcRF2oy3vYgAuaBcdGGG+GwISZmjun1I/nOo=;
        b=SMPoDwueWDm00jo4WYeNo4fCOYSZhKSOAntRnooIjDe2/O9LTPFdcmK3Xg5ZWbReFHNCL6
        ESTp5YsvztdoEAb+6Ivr6xrg6Cw1RBXPXW76cW6cGKtuVSym0kC/+ISNtGSZFZUdPDl7Sl
        GzMIrebGNML0BGB5YrmGdPF5w7FrDkY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-kfHbEYmWM_2mvX6QVoa8tQ-1; Mon, 06 Jun 2022 14:08:46 -0400
X-MC-Unique: kfHbEYmWM_2mvX6QVoa8tQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5B4E811E7A;
        Mon,  6 Jun 2022 18:08:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D4971121315;
        Mon,  6 Jun 2022 18:08:42 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/7] KVM: x86: SVM: remove avic's broken code that updated APIC ID
Date:   Mon,  6 Jun 2022 21:08:25 +0300
Message-Id: <20220606180829.102503-4-mlevitsk@redhat.com>
In-Reply-To: <20220606180829.102503-1-mlevitsk@redhat.com>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVIC is now inhibited if the guest changes the apic id,
and therefore this code is no longer needed.

There are several ways this code was broken, including:

1. a vCPU was only allowed to change its apic id to an apic id
of an existing vCPU.

2. After such change, the vCPU whose apic id entry was overwritten,
could not correctly change its own apic id, because its own
entry is already overwritten.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8dffd67f60862..072e2c8cc66aa 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -508,35 +508,6 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
-{
-	u64 *old, *new;
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 id = kvm_xapic_id(vcpu->arch.apic);
-
-	if (vcpu->vcpu_id == id)
-		return 0;
-
-	old = avic_get_physical_id_entry(vcpu, vcpu->vcpu_id);
-	new = avic_get_physical_id_entry(vcpu, id);
-	if (!new || !old)
-		return 1;
-
-	/* We need to move physical_id_entry to new offset */
-	*new = *old;
-	*old = 0ULL;
-	to_svm(vcpu)->avic_physical_id_cache = new;
-
-	/*
-	 * Also update the guest physical APIC ID in the logical
-	 * APIC ID table entry if already setup the LDR.
-	 */
-	if (svm->ldr_reg)
-		avic_handle_ldr_update(vcpu);
-
-	return 0;
-}
-
 static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -555,10 +526,6 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 				AVIC_UNACCEL_ACCESS_OFFSET_MASK;
 
 	switch (offset) {
-	case APIC_ID:
-		if (avic_handle_apic_id_update(vcpu))
-			return 0;
-		break;
 	case APIC_LDR:
 		if (avic_handle_ldr_update(vcpu))
 			return 0;
@@ -650,8 +617,6 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
-	if (avic_handle_apic_id_update(vcpu) != 0)
-		return;
 	avic_handle_dfr_update(vcpu);
 	avic_handle_ldr_update(vcpu);
 }
-- 
2.26.3

