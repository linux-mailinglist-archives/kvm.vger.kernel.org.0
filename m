Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3874D3918AE
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhEZNXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:23:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233462AbhEZNXg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xgpwe8+6eZphIoHqZ+wLfs1RRVFh561YjBAgjusQjvo=;
        b=LdRCrpkeW0Rtohz9cgH06Udr8MC/crL821xW8gLq/Hbw5on7denNMD+fA7aBP6nU0PzC/q
        dpSNJ1wUJ7hqrwQE6IRYIFsPBImi0QPjl9uBNrOeTxUqHR9OQ7TO+PdHkQiYzDVugHY93L
        88KSsnxEiWUA1NqtqhdFUQYfjaDM5S0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-nZVq6y1uNGGVkWl0A70nWQ-1; Wed, 26 May 2021 09:22:00 -0400
X-MC-Unique: nZVq6y1uNGGVkWl0A70nWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7553B8186F0;
        Wed, 26 May 2021 13:21:59 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2AB25D9C6;
        Wed, 26 May 2021 13:21:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/11] KVM: nVMX: Release enlightened VMCS on VMCLEAR
Date:   Wed, 26 May 2021 15:20:21 +0200
Message-Id: <20210526132026.270394-7-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4d0867d5e94b..080990ebe989 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4989,6 +4989,8 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 				     vmptr + offsetof(struct vmcs12,
 						      launch_state),
 				     &zero, sizeof(zero));
+	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
+		nested_release_evmcs(vcpu);
 	}
 
 	return nested_vmx_succeed(vcpu);
-- 
2.31.1

