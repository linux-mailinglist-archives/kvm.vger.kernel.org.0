Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E9D37A59B
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhEKLVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:21:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231479AbhEKLVb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620732024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VdfZtVq1Osm8Hb40n9j/822T1bZFpdUzI7OH3sy8Hg=;
        b=cFrEC6CUljV0FoQXus0rN1uQ7iDk68xBhjVQ9UXAFPthRhsr/oLR0uYRC+FV85u5Jybg84
        z8BiDobEXPbJAdh++0D0HMG/a0MhjftCKlhLY6lTjgosH3tFZJVRg31Qf1ReHUYfW3CLcI
        1IPEWU5/QFTmGtkNikTVic5ZgO46Mgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-d9_f4xHsPSy747llmD-ijw-1; Tue, 11 May 2021 07:20:22 -0400
X-MC-Unique: d9_f4xHsPSy747llmD-ijw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB955107ACC7;
        Tue, 11 May 2021 11:20:21 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E353563746;
        Tue, 11 May 2021 11:20:16 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/7] KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
Date:   Tue, 11 May 2021 13:19:53 +0200
Message-Id: <20210511111956.1555830-5-vkuznets@redhat.com>
In-Reply-To: <20210511111956.1555830-1-vkuznets@redhat.com>
References: <20210511111956.1555830-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'need_vmcs12_to_shadow_sync' is used for both shadow and enlightened
VMCS sync when we exit to L1. The comment in nested_vmx_failValid()
validly states why shadow vmcs sync can be omitted but this doesn't
apply to enlightened VMCS as it 'shadows' all VMCS12 fields.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7970a16ee6b1..3257a2291693 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -194,9 +194,13 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 			| X86_EFLAGS_ZF);
 	get_vmcs12(vcpu)->vm_instruction_error = vm_instruction_error;
 	/*
-	 * We don't need to force a shadow sync because
-	 * VM_INSTRUCTION_ERROR is not shadowed
+	 * We don't need to force sync to shadow VMCS because
+	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
+	 * fields and thus must be synced.
 	 */
+	if (nested_evmcs_is_used(to_vmx(vcpu)))
+		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;
+
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-- 
2.30.2

