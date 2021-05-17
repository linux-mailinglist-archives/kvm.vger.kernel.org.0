Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0C382DEE
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbhEQNwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:52:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237557AbhEQNwW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 09:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621259465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f4cPLO5cJCciSvcONkbHJ8hsoKgTSNwLQUXz2JjEi7o=;
        b=JaF0e67lMOu/5YYkmwKJeShwxTZBsjLgrMDDbs0uTtgm3UrMik1CDzp+hDdb1ypluh7DJb
        NWauwT0L+Nj7ucS2vHuHBKWVBWzpH3RC7IK3RPEbkPIyGiwkooavR4tvaF+qn/yRuCPJYb
        UmB0towxKPpbmEXBtw8+H4mBq3l8ylY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-0YTG-jOLNOiAvnXwNtMvgg-1; Mon, 17 May 2021 09:51:04 -0400
X-MC-Unique: 0YTG-jOLNOiAvnXwNtMvgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCCEBCC62F;
        Mon, 17 May 2021 13:51:02 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB6315C1A1;
        Mon, 17 May 2021 13:51:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] KVM: nVMX: Release enlightened VMCS on VMCLEAR
Date:   Mon, 17 May 2021 15:50:49 +0200
Message-Id: <20210517135054.1914802-3-vkuznets@redhat.com>
In-Reply-To: <20210517135054.1914802-1-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
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
2.31.1

