Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD6C31DBCA
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhBQO7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:59:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhBQO66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LN2px05F08WrD3YKLDLusn49XXFwsDBda/Tl6rjbljY=;
        b=eO/BZyxzJfYj59+l6ZWim8dhogslADYkD/AWUBE6c7kuJmwhoG/rQRWg4baZBRCBEJ9DgR
        gfFVB8C1sJw+8GFA/L0EIkSs/I6AiW4fFI4sWMJ73DSuKlO2do22hjriFRQWwluyv1q8TJ
        92VnTy8tEpz0tN7OXd3cEY1U4D80Zss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-aC41oIWZNXCRCwhLfsdBdg-1; Wed, 17 Feb 2021 09:57:28 -0500
X-MC-Unique: aC41oIWZNXCRCwhLfsdBdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80193801979;
        Wed, 17 Feb 2021 14:57:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3226C10016FF;
        Wed, 17 Feb 2021 14:57:22 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/7] KVM: VMX: read idt_vectoring_info a bit earlier
Date:   Wed, 17 Feb 2021 16:57:12 +0200
Message-Id: <20210217145718.1217358-2-mlevitsk@redhat.com>
In-Reply-To: <20210217145718.1217358-1-mlevitsk@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

trace_kvm_exit prints this value (using vmx_get_exit_info)
so it makes sense to read it before the trace point.

Fixes: dcf068da7eb2 ("KVM: VMX: Introduce generic fastpath handler")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3e36dc3f164..e428d69e21c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6921,13 +6921,15 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
+	if (likely(!vmx->exit_reason.failed_vmentry))
+		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+
 	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
 
 	if (unlikely(vmx->exit_reason.failed_vmentry))
 		return EXIT_FASTPATH_NONE;
 
 	vmx->loaded_vmcs->launched = 1;
-	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
-- 
2.26.2

