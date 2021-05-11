Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1741A37A597
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhEKLVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:21:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231437AbhEKLVZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620732018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQGXKcpbTj9W5HMDC/xqbHnC/drWo+ssAo6yFyhsgGc=;
        b=NMCnxztPtfZIhAOh+t3qoCCikZxPGOd+pId36D3Rja+hRFpbzJcfbI4Xh2C8PdJU2KPIsj
        6/hW817W48B7C84oYKiTwFToMTH7dYCLVXKhKEnr2ZmZ4XyBkIHZJFTQL7n0e4atveh0cM
        uorL0NtKjIKozv34n8Ybdi0wB8rKSYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-Ne0XkzhRO-itrzJlNBE64g-1; Tue, 11 May 2021 07:20:15 -0400
X-MC-Unique: Ne0XkzhRO-itrzJlNBE64g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 353611006C80;
        Tue, 11 May 2021 11:20:14 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7ED1C63C40;
        Tue, 11 May 2021 11:20:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/7] KVM: nVMX: Release enlightened VMCS on VMCLEAR
Date:   Tue, 11 May 2021 13:19:51 +0200
Message-Id: <20210511111956.1555830-3-vkuznets@redhat.com>
In-Reply-To: <20210511111956.1555830-1-vkuznets@redhat.com>
References: <20210511111956.1555830-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unlike VMREAD/VMWRITE/VMPTRLD, VMCLEAR is a valid instruction when
enlightened VMCS is in use. TLFS has the following brief description:
"The L1 hypervisor can execute a VMCLEAR instruction to transition an
enlightened VMCS from the active to the non-active state". Normally,
this change can be ignored as unmapping active eVMCS can be postponed
until the next VMLAUNCH instruction but in case nested state is migrated
with KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE, keeping eVMCS mapped
may result in its synchronization with VMCS12 and this is incorrect:
L1 hypervisor is free to reuse inactive eVMCS memory for something else.

Inactive eVMCS after VMCLEAR can just be unmapped.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3080e00c8f90..ea2869d8b823 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5008,6 +5008,8 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 				     vmptr + offsetof(struct vmcs12,
 						      launch_state),
 				     &zero, sizeof(zero));
+	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
+		nested_release_evmcs(vcpu);
 	}
 
 	return nested_vmx_succeed(vcpu);
-- 
2.30.2

