Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834DF55D856
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbiF0QFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238907AbiF0QFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:05:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23D4DB87B
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656345916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hm8K49s6obw8oCEB7C0hpsLALIXOoDHDuJqWVyoKjQk=;
        b=dw7qJ+bbSCQewO2iIAhjGmLyLcl1rHaMvmp05QghOXvDrXeTfhH6Ztz/i8n8QCHE/jz2LC
        0p4WqYV/4EqcNaNseGb4uOP/qAP252QGN3AH5TPS/U81vHBxkE7x4VQqEL/dFlBkC5vH26
        brmzt87OPFvLuULo2yS3D655grGI6TE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-11WT4rn1Nka912BynVaMmQ-1; Mon, 27 Jun 2022 12:05:11 -0400
X-MC-Unique: 11WT4rn1Nka912BynVaMmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6277D101AA69;
        Mon, 27 Jun 2022 16:05:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 805DEC15D40;
        Mon, 27 Jun 2022 16:05:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] KVM: nVMX: Use sanitized required-1 bits for VMX control MSRs
Date:   Mon, 27 Jun 2022 18:04:38 +0200
Message-Id: <20220627160440.31857-13-vkuznets@redhat.com>
In-Reply-To: <20220627160440.31857-1-vkuznets@redhat.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmcs_config has the required information for setting up required-1 bits of
nested VMCS control MSRs, use it to avoid redundant rdmsr()s.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 41cac0390998..c88a9c6b4606 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6538,9 +6538,6 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 {
 	struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
 
-	/* Take the allowed-1 bits from KVM's sanitized VMCS configuration. */
-	u32 ignore_high;
-
 	/*
 	 * Note that as a general rule, the high half of the MSRs (bits in
 	 * the control fields which may be 1) should be initialized by the
@@ -6557,8 +6554,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 	 */
 
 	/* pin-based controls */
-	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, msrs->pinbased_ctls_low, ignore_high);
-	msrs->pinbased_ctls_low |=
+	msrs->pinbased_ctls_low = vmcs_conf->pin_based_exec_ctrl_req1 |
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 
 	msrs->pinbased_ctls_high = vmcs_conf->pin_based_exec_ctrl;
-- 
2.35.3

