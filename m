Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81338587FB8
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiHBQIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbiHBQIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:08:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E71671E3F5
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzeOjCx87rv6I5YNd+w0POkbksRIrx5wEWj1v56VOGU=;
        b=TOnjhISXOjoN1jwzBY5aSoeaKMb6VFnimKHnStWvrpWzZqTKbjSylVAcTcSIk1OEj8d0XQ
        5XMK/sZ3BQWBzL4qh6XpiQvmdC04H14WnZe0nxMS8FPfBMjgzW5JuwWnojtsAVYW0Dgc0S
        Dvbc/LtF+9b1oap3AkjhomnHkLAQsrQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-qwiG5OguPOqrS1ANgEXU6w-1; Tue, 02 Aug 2022 12:08:11 -0400
X-MC-Unique: qwiG5OguPOqrS1ANgEXU6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A02B1019DE1;
        Tue,  2 Aug 2022 16:08:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFE702166B26;
        Tue,  2 Aug 2022 16:08:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/26] KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
Date:   Tue,  2 Aug 2022 18:07:34 +0200
Message-Id: <20220802160756.339464-5-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 definition was updated with new fields, support
them in KVM by defining VMCS-to-EVMCS conversion.

Note: SSP, CET and Guest LBR features are not supported by KVM yet and
the corresponding fields are not defined in 'enum vmcs_field', leave
them commented out for now.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 6a61b1ae7942..8bea5dea0341 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -28,6 +28,8 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
 	EVMCS1_FIELD(HOST_IA32_EFER, host_ia32_efer,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	EVMCS1_FIELD(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
 	EVMCS1_FIELD(HOST_CR0, host_cr0,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
 	EVMCS1_FIELD(HOST_CR3, host_cr3,
@@ -78,6 +80,8 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(GUEST_IA32_EFER, guest_ia32_efer,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	EVMCS1_FIELD(GUEST_IA32_PERF_GLOBAL_CTRL, guest_ia32_perf_global_ctrl,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(GUEST_PDPTR0, guest_pdptr0,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(GUEST_PDPTR1, guest_pdptr1,
@@ -126,6 +130,28 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(XSS_EXIT_BITMAP, xss_exit_bitmap,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+	EVMCS1_FIELD(ENCLS_EXITING_BITMAP, encls_exiting_bitmap,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+	EVMCS1_FIELD(TSC_MULTIPLIER, tsc_multiplier,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+	/*
+	 * Not used by KVM:
+	 *
+	 * EVMCS1_FIELD(0x00006828, guest_ia32_s_cet,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	 * EVMCS1_FIELD(0x0000682A, guest_ssp,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
+	 * EVMCS1_FIELD(0x0000682C, guest_ia32_int_ssp_table_addr,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	 * EVMCS1_FIELD(0x00002816, guest_ia32_lbr_ctl,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	 * EVMCS1_FIELD(0x00006C18, host_ia32_s_cet,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	 * EVMCS1_FIELD(0x00006C1A, host_ssp,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	 * EVMCS1_FIELD(0x00006C1C, host_ia32_int_ssp_table_addr,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	 */
 
 	/* 64 bit read only */
 	EVMCS1_FIELD(GUEST_PHYSICAL_ADDRESS, guest_physical_address,
-- 
2.35.3

