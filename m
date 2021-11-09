Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667DA44B128
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 17:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhKIQbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 11:31:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239782AbhKIQbf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 11:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636475328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pks1M5aK5scQIauGA4FxtBWjfHU4Utb4eruboq9GbbM=;
        b=XcXqqgRzmkSFI2OTJ1Rbp23FN8cB2fA3riiIFSduIDfRoBv1S4k8au7jfSFU6XKtpxUS3e
        ba/6gDr3XxCMlWColCyrhxt5KhuS/rd6b15JgijMTjgA7N1sd59fBxjxjCqXdjGyvmw80i
        GP0CMH0OVu/kGVUe77w885HRXTSM5Tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-eC4qqo9tM3uGjrub5yHbRg-1; Tue, 09 Nov 2021 11:28:46 -0500
X-MC-Unique: eC4qqo9tM3uGjrub5yHbRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F295804140;
        Tue,  9 Nov 2021 16:28:45 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6E1256A91;
        Tue,  9 Nov 2021 16:28:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/8] KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in use
Date:   Tue,  9 Nov 2021 17:28:28 +0100
Message-Id: <20211109162835.99475-2-vkuznets@redhat.com>
In-Reply-To: <20211109162835.99475-1-vkuznets@redhat.com>
References: <20211109162835.99475-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Check the current VMCS controls to determine if an MSR write will be
intercepted due to MSR bitmaps being disabled.  In the nested VMX case,
KVM will disable MSR bitmaps in vmcs02 if they're disabled in vmcs12 or
if KVM can't map L1's bitmaps for whatever reason.

Note, the bad behavior is relatively benign in the current code base as
KVM sets all bits in vmcs02's MSR bitmap by default, clears bits if and
only if L0 KVM also disables interception of an MSR, and only uses the
buggy helper for MSR_IA32_SPEC_CTRL.  Because KVM explicitly tests WRMSR
before disabling interception of MSR_IA32_SPEC_CTRL, the flawed check
will only result in KVM reading MSR_IA32_SPEC_CTRL from hardware when it
isn't strictly necessary.

Tag the fix for stable in case a future fix wants to use
msr_write_intercepted(), in which case a buggy implementation in older
kernels could prove subtly problematic.

Fixes: d28b387fb74d ("KVM/VMX: Allow direct access to MSR_IA32_SPEC_CTRL")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f54d85f104..334323bd787d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -769,15 +769,15 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 /*
  * Check if MSR is intercepted for currently loaded MSR bitmap.
  */
-static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
+static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 {
 	unsigned long *msr_bitmap;
 	int f = sizeof(unsigned long);
 
-	if (!cpu_has_vmx_msr_bitmap())
+	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
-	msr_bitmap = to_vmx(vcpu)->loaded_vmcs->msr_bitmap;
+	msr_bitmap = vmx->loaded_vmcs->msr_bitmap;
 
 	if (msr <= 0x1fff) {
 		return !!test_bit(msr, msr_bitmap + 0x800 / f);
@@ -6751,7 +6751,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
-- 
2.31.1

