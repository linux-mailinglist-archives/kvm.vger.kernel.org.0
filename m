Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF21646114F
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 10:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343760AbhK2Jwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 04:52:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244922AbhK2Jue (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Nov 2021 04:50:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638179237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nqwlPQbSnrJS+HZ3l5Y76qEmAk5pxw9IMLc+1eOJDlQ=;
        b=Okm/c0bWqzzP5DmWUdvmjEbEzEFdbLNcgxocOwl8kYbKkDrRNu52PzK1T/VsN27Jlr6I9F
        MZwxEX9ENi6IRhspESp+j8kV7lR2A3xtTVIC/zEOZZoHFzHNCIYZGfhSg0gsY7Iq9rXdtr
        xe76J0ix/XjetTyF33BIgbZMqbsUxtw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-tDsWkuGDNyOpASgba64aZA-1; Mon, 29 Nov 2021 04:47:13 -0500
X-MC-Unique: tDsWkuGDNyOpASgba64aZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50BB81006AA1;
        Mon, 29 Nov 2021 09:47:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.195.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CB9C5D6B1;
        Mon, 29 Nov 2021 09:47:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/4] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
Date:   Mon, 29 Nov 2021 10:47:01 +0100
Message-Id: <20211129094704.326635-2-vkuznets@redhat.com>
In-Reply-To: <20211129094704.326635-1-vkuznets@redhat.com>
References: <20211129094704.326635-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM runs as a nested hypervisor on top of Hyper-V it uses Enlightened
VMCS and enables Enlightened MSR Bitmap feature for its L1s and L2s (which
are actually L2s and L3s from Hyper-V's perspective). When MSR bitmap is
updated, KVM has to reset HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP from
clean fields to make Hyper-V aware of the change. For KVM's L1s, this is
done in vmx_disable_intercept_for_msr()/vmx_enable_intercept_for_msr().
MSR bitmap for L2 is build in nested_vmx_prepare_msr_bitmap() by blending
MSR bitmap for L1 and L1's idea of MSR bitmap for L2. KVM, however, doesn't
check if the resulting bitmap is different and never cleans
HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP in eVMCS02. This is incorrect and
may result in Hyper-V missing the update.

The issue could've been solved by calling evmcs_touch_msr_bitmap() for
eVMCS02 from nested_vmx_prepare_msr_bitmap() unconditionally but doing so
would not give any performance benefits (compared to not using Enlightened
MSR Bitmap at all). 3-level nesting is also not a very common setup
nowadays.

Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
now.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index efcc5a58abbc..901809c44773 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2652,15 +2652,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 		if (!loaded_vmcs->msr_bitmap)
 			goto out_vmcs;
 		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
-
-		if (IS_ENABLED(CONFIG_HYPERV) &&
-		    static_branch_unlikely(&enable_evmcs) &&
-		    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
-			struct hv_enlightened_vmcs *evmcs =
-				(struct hv_enlightened_vmcs *)loaded_vmcs->vmcs;
-
-			evmcs->hv_enlightenments_control.msr_bitmap = 1;
-		}
 	}
 
 	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
@@ -6851,6 +6842,19 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err < 0)
 		goto free_pml;
 
+	/*
+	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
+	 * nested (L1) hypervisor and Hyper-V in L0 supports it. Enable the
+	 * feature only for vmcs01, KVM currently isn't equipped to realize any
+	 * performance benefits from enabling it for vmcs02.
+	 */
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
+	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		evmcs->hv_enlightenments_control.msr_bitmap = 1;
+	}
+
 	/* The MSR bitmap starts with all ones */
 	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-- 
2.33.1

