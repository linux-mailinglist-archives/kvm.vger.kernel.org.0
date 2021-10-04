Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FC44213B5
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhJDQMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 12:12:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236501AbhJDQMe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 12:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633363845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G8UTxH6LSgQAJFwzyStm2FwC6qPpd/N2B6G25DLbUwc=;
        b=UOrlIOsOWSIaULCCYAecXsaU4j/GVB9YjVoXuJL0yezxoSQzqPuMYYf+gTZ4xDzXcNo1SV
        0zctnrXbBjl9cyiXHtONX4Va7AY/KZ+l3PiZZVLpjo0aiUB2Kacqlyg2WL6MQYDHTgMz/g
        H2GLSf5FUe89h63hZKlM9v74H2w31i0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-R-pTBbZmMy6Cm2FcocxX0w-1; Mon, 04 Oct 2021 12:10:44 -0400
X-MC-Unique: R-pTBbZmMy6Cm2FcocxX0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5332B802936;
        Mon,  4 Oct 2021 16:10:40 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 292A818A50;
        Mon,  4 Oct 2021 16:10:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
Date:   Mon,  4 Oct 2021 18:10:27 +0200
Message-Id: <20211004161029.641155-3-vkuznets@redhat.com>
In-Reply-To: <20211004161029.641155-1-vkuznets@redhat.com>
References: <20211004161029.641155-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to enabling 'Enlightened MSR Bitmap' feature for Hyper-V
guests move MSR bitmap update tracking to a dedicated helper.

Note: vmx_msr_bitmap_l01_changed() is called when MSR bitmap might be
updated. KVM doesn't check if the bit we're trying to set is already set
(or the bit it's trying to clear is already cleared). Such situations
should not be common and a few false positives should not be a problem.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e82cdde58119..3fdaaef291e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3726,6 +3726,17 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
 		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
 }
 
+static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
+{
+	/*
+	 * When KVM is a nested hypervisor on top of Hyper-V and uses
+	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
+	 * bitmap has changed.
+	 */
+	if (static_branch_unlikely(&enable_evmcs))
+		evmcs_touch_msr_bitmap();
+}
+
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3734,8 +3745,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -3779,8 +3789,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
-- 
2.31.1

