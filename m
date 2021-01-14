Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CDE2F6CB2
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 21:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbhANU4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 15:56:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40862 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729262AbhANU4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 15:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610657716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLHJA1TpNmni7zCQ/Lgvyb1GSyvjz6b0bgrDebQHL0w=;
        b=a2YR93xfHHPmIN4d/Mq2WE017OSpfqv/UZXpN+2YA836bS3ylblYFPSeGx53XlmRuBlz57
        j5MLA7vhLLWejiFyC+yyfjzbaE+QHLgBWPjREzyjIfdc50L0hiXJR+tiondwzpkref2Pb5
        5rjIkeyoGxTQv2LxPW5IKTupWMu5+BI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-EISxNTwcPnWDvzfUTYdWnw-1; Thu, 14 Jan 2021 15:55:15 -0500
X-MC-Unique: EISxNTwcPnWDvzfUTYdWnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A55E100F341;
        Thu, 14 Jan 2021 20:55:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A35B5C1C5;
        Thu, 14 Jan 2021 20:55:07 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/3] KVM: VMX: read idt_vectoring_info a bit earlier
Date:   Thu, 14 Jan 2021 22:54:49 +0200
Message-Id: <20210114205449.8715-4-mlevitsk@redhat.com>
In-Reply-To: <20210114205449.8715-1-mlevitsk@redhat.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows it to be printed correctly by the trace print
that follows.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2af05d3b05909..9b6e7dbf5e2bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6771,6 +6771,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
+	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+
 	if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
@@ -6780,7 +6782,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		return EXIT_FASTPATH_NONE;
 
 	vmx->loaded_vmcs->launched = 1;
-	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
-- 
2.26.2

