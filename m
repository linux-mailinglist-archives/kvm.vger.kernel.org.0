Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553E9382DF4
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbhEQNwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237576AbhEQNw1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 09:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621259470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aq/mMZIsTMXv1+hlWQiF1uQYzhB0IZF3pQERYOLOn20=;
        b=Q3bBi84mAxtGJ9Dr3syhAZtZBmpAJ+SQjPhSO090sz9bQW69vTVutU/ksL21I4fzppeQn1
        +eeB2fDIpmjc52eEwQ0eoKk4chaiekIDgykPGj0RAGBTxcwYA/h5bKPBsamzzITtY+ogos
        sk4RE7k+pfjQnv6Z5AEewvss8iIlbXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-pjcPGJAEMiCETNNoUGjyEw-1; Mon, 17 May 2021 09:51:09 -0400
X-MC-Unique: pjcPGJAEMiCETNNoUGjyEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEDFE8015F4;
        Mon, 17 May 2021 13:51:07 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C91595C1A1;
        Mon, 17 May 2021 13:51:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
Date:   Mon, 17 May 2021 15:50:51 +0200
Message-Id: <20210517135054.1914802-5-vkuznets@redhat.com>
In-Reply-To: <20210517135054.1914802-1-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
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
index ec476f64df73..eb2d25a93356 100644
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
2.31.1

