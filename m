Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E40A44BE36
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 11:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhKJKDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 05:03:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231197AbhKJKDl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 05:03:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636538453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28X2k1WeI6bPfleaW2HxIWWLVXWVUppijzDYiHE+Gn8=;
        b=ETeDno3uOhTjXXwfVJTLJ240ZvUjTxFWx8vJoG2OTmC0JtBXUJO3oo7X6FyVjiX75bF7if
        ww5f6W5Nzh7MXJzCAv/X1LxOSEedYmmxwt1Bpp+AX9A8oByDbKzOTCvk29i2Ec6Btvs5IZ
        H7GvD7Kp4XMQKNDwhNpxEdrkq7HAzCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-iHx4bk0MP7eYhswcfvyxyQ-1; Wed, 10 Nov 2021 05:00:50 -0500
X-MC-Unique: iHx4bk0MP7eYhswcfvyxyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D375819057AA;
        Wed, 10 Nov 2021 10:00:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02F5510016F4;
        Wed, 10 Nov 2021 10:00:44 +0000 (UTC)
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
Subject: [PATCH 2/3] KVM: nVMX: restore L1's EFER prior to setting the nested state
Date:   Wed, 10 Nov 2021 12:00:17 +0200
Message-Id: <20211110100018.367426-3-mlevitsk@redhat.com>
In-Reply-To: <20211110100018.367426-1-mlevitsk@redhat.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is known that some kvm's users (e.g. qemu) load part of L2's register
state prior to setting the nested state after a migration.

If a 32 bit L2 guest is running in a 64 bit L1 guest, and nested migration
happens, Qemu will restore L2's EFER, and then the nested state load
function will use it as if it was L1's EFER.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 49ae96c0cc4d1..28e270824e5b1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6404,6 +6404,17 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			kvm_state->hdr.vmx.preemption_timer_deadline;
 	}
 
+	/*
+	 * The vcpu might currently contain L2's IA32_EFER, due to the way
+	 * some userspace kvm users (e.g qemu) restore nested state.
+	 *
+	 * To fix this, restore its IA32_EFER to the value it would have
+	 * after VM exit from the nested guest.
+	 *
+	 */
+
+	vcpu->arch.efer = nested_vmx_get_vmcs12_host_efer(vcpu, vmcs12);
+
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
 	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
-- 
2.26.3

