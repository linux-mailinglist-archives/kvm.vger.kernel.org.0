Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D7156041C
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiF2PIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbiF2PHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:07:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91EFB396A0
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agIhwFkjRHnLjbHDFtkyB4dQ5eVn9ReXWie5804CCQ4=;
        b=TXFdkOEFgH9pxZyJCjcwMPRFtp4L5xWHNiC6H5SroZucxqEUIPPHLkiM9dxO9ynsUfm8fL
        P0l+Lhy6xFJuW/1/xI3J634dItxcj3TFXNEehnIQTiX/arE1KfT63x8RIYpil5zYg8L8bt
        Us/99OHUxAqvahjbsjuykbt6SvAOgNc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-WOQH6bKhO8GxBvave998XA-1; Wed, 29 Jun 2022 11:07:35 -0400
X-MC-Unique: WOQH6bKhO8GxBvave998XA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F05F1811E81;
        Wed, 29 Jun 2022 15:07:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7C1B40EC002;
        Wed, 29 Jun 2022 15:07:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 28/28] KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up nested MSR
Date:   Wed, 29 Jun 2022 17:06:25 +0200
Message-Id: <20220629150625.238286-29-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmcs_config has cased host MSR_IA32_VMX_MISC value, use it for setting
up nested MSR_IA32_VMX_MISC in nested_vmx_setup_ctls_msrs() and avoid the
redundant rdmsr().

No (real) functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8af56be48a43..8b63642157a5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6754,10 +6754,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
 
 	/* miscellaneous data */
-	rdmsr(MSR_IA32_VMX_MISC,
-		msrs->misc_low,
-		msrs->misc_high);
-	msrs->misc_low &= VMX_MISC_SAVE_EFER_LMA;
+	msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
 	msrs->misc_low |=
 		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
 		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
-- 
2.35.3

