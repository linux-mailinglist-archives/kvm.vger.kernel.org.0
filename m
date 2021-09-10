Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86895406EDB
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 18:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhIJQIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 12:08:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhIJQIB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 12:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631290010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Qn8xOC0u81X+L8dYSEV2sHlOuYw4WBv1iuDDSSyIQY=;
        b=CuzWoCI2v1GYYE9jRoTf0nLrHIeoCrKC93RHHeUlxKbfiyyzWXO4MFw44/bS/CDwt0vjtC
        sMrYJDRiK6yWotL5LYZRcn7CAfPSX0VGSWbebbqpGyO2HqdhX62oOEQF96Q+vqwZn6SVCd
        9hnCvxe3dpjBW3cwEbVT+mKW4cIVgwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-iQKJxid8MfSfw8_hfx1EiA-1; Fri, 10 Sep 2021 12:06:47 -0400
X-MC-Unique: iQKJxid8MfSfw8_hfx1EiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18E7B835DE0;
        Fri, 10 Sep 2021 16:06:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 395555C1A1;
        Fri, 10 Sep 2021 16:06:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
Date:   Fri, 10 Sep 2021 18:06:31 +0200
Message-Id: <20210910160633.451250-3-vkuznets@redhat.com>
In-Reply-To: <20210910160633.451250-1-vkuznets@redhat.com>
References: <20210910160633.451250-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae470afcb699..ad33032e8588 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3725,6 +3725,17 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
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
@@ -3733,8 +3744,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -3778,8 +3788,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
-- 
2.31.1

