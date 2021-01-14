Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358DF2F6CAF
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 21:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbhANU4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 15:56:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727152AbhANU4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 15:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610657707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sjyxhinw36uvHQq417p5mpNAZODTNW/mmcrP3tZ/skE=;
        b=WZr/O74j5Dsw1IamrVLKi+7cnLkeXwRrbeuYuu06UWcUJ/BvO4c6pidjZJLAGmBm4c9nOk
        z/X3XEzEvNtnRazBMxclA4aLpNpppVBVU7adtSX2xsGp3sgOz1zQRzw3wQPcM4EsQsYvh7
        UoB0iJtwaefNXd5OpE6omKMw4tRDLnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-zCpK3h7iOsy7slLYsyEwHA-1; Thu, 14 Jan 2021 15:55:03 -0500
X-MC-Unique: zCpK3h7iOsy7slLYsyEwHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76082107ACF9;
        Thu, 14 Jan 2021 20:55:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5E25C1C5;
        Thu, 14 Jan 2021 20:54:55 +0000 (UTC)
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
Subject: [PATCH v2 1/3] KVM: nVMX: Always call sync_vmcs02_to_vmcs12_rare on migration
Date:   Thu, 14 Jan 2021 22:54:47 +0200
Message-Id: <20210114205449.8715-2-mlevitsk@redhat.com>
In-Reply-To: <20210114205449.8715-1-mlevitsk@redhat.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when we are outside the nested guest, some vmcs02 fields
are not in sync vs vmcs12.

However during the migration, the vmcs12 has to be up to date
to be able to load it later after the migration.

To fix that, call that function.

Fixes: 7952d769c29ca ("KVM: nVMX: Sync rarely accessed guest fields only when needed")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0fbb46990dfce..776688f9d1017 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6077,11 +6077,14 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	if (is_guest_mode(vcpu)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
 		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
-	} else if (!vmx->nested.need_vmcs12_to_shadow_sync) {
-		if (vmx->nested.hv_evmcs)
-			copy_enlightened_to_vmcs12(vmx);
-		else if (enable_shadow_vmcs)
-			copy_shadow_to_vmcs12(vmx);
+	} else  {
+		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
+		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
+			if (vmx->nested.hv_evmcs)
+				copy_enlightened_to_vmcs12(vmx);
+			else if (enable_shadow_vmcs)
+				copy_shadow_to_vmcs12(vmx);
+		}
 	}
 
 	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
-- 
2.26.2

