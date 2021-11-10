Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD7D44BE34
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 11:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhKJKDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 05:03:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230456AbhKJKDg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 05:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636538449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXmw4UL6pUw7vk0K53uGHVrES63lbb9L++9ywYEo/w4=;
        b=Q4+Sbra6wlfpPnFNDjVd3DKgKDeFPLij8hEVm7DwwQNsiWUiwXPSU+Z+Bj4plzTwWMGPN/
        YqkMgc4x/2Gz9iDG58czQbwKt1qqwuNQXN1pTQsMWzygdjx2JnbfMFgicl3Fue7abU78wp
        z+kB5fFIER7BHSGPCGlukR7JlZ9f1B4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-59RoaI07MfWnaGe3rf7pdQ-1; Wed, 10 Nov 2021 05:00:46 -0500
X-MC-Unique: 59RoaI07MfWnaGe3rf7pdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8971E845F2C;
        Wed, 10 Nov 2021 10:00:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 303891045EBC;
        Wed, 10 Nov 2021 10:00:39 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/3] KVM: nVMX: extract calculation of the L1's EFER
Date:   Wed, 10 Nov 2021 12:00:16 +0200
Message-Id: <20211110100018.367426-2-mlevitsk@redhat.com>
In-Reply-To: <20211110100018.367426-1-mlevitsk@redhat.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be useful in the next patch.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b4ee5e9f9e201..49ae96c0cc4d1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4228,6 +4228,21 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	kvm_clear_interrupt_queue(vcpu);
 }
 
+/*
+ * Given vmcs12, return the expected L1 value of IA32_EFER
+ * after VM exit from that vmcs12
+ */
+static inline u64 nested_vmx_get_vmcs12_host_efer(struct kvm_vcpu *vcpu,
+						  struct vmcs12 *vmcs12)
+{
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
+		return vmcs12->host_ia32_efer;
+	else if (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
+		return vcpu->arch.efer | (EFER_LMA | EFER_LME);
+	else
+		return vcpu->arch.efer & ~(EFER_LMA | EFER_LME);
+}
+
 /*
  * A part of what we need to when the nested L2 guest exits and we want to
  * run its L1 parent, is to reset L1's guest state to the host state specified
@@ -4243,12 +4258,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	enum vm_entry_failure_code ignored;
 	struct kvm_segment seg;
 
-	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
-		vcpu->arch.efer = vmcs12->host_ia32_efer;
-	else if (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
-		vcpu->arch.efer |= (EFER_LMA | EFER_LME);
-	else
-		vcpu->arch.efer &= ~(EFER_LMA | EFER_LME);
+	vcpu->arch.efer = nested_vmx_get_vmcs12_host_efer(vcpu, vmcs12);
 	vmx_set_efer(vcpu, vcpu->arch.efer);
 
 	kvm_rsp_write(vcpu, vmcs12->host_rsp);
-- 
2.26.3

