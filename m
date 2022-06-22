Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DF8555182
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 18:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376523AbiFVQo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 12:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359095AbiFVQox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 12:44:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28523381BC
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 09:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655916292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dEd4vE77h1Pw+d5XhGtnzL5zzBP/vPs44XvuPaKduTs=;
        b=IhumMuAMfraFeyZUHlloQ3P4dyI/dADfSI/XzbtuXSWR9Hb3MrS5cDgym5uep81TWigFcg
        qF3dN91C5M8ysXdulrMf6WpxW7dP6B80AV1g4oOjAoYsX84I80bjqgs2lsslM04I5F5t5a
        B2j7CmvY/lYPXuEVIk4/oBeIub5Vc6Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-BdX0B2MvNlWtPcqhe9Kqjw-1; Wed, 22 Jun 2022 12:44:47 -0400
X-MC-Unique: BdX0B2MvNlWtPcqhe9Kqjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3C3980029D;
        Wed, 22 Jun 2022 16:44:46 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8023A40CFD0A;
        Wed, 22 Jun 2022 16:44:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 05/10] KVM: VMX: Add missing VMENTRY controls to vmcs_config
Date:   Wed, 22 Jun 2022 18:44:27 +0200
Message-Id: <20220622164432.194640-6-vkuznets@redhat.com>
In-Reply-To: <20220622164432.194640-1-vkuznets@redhat.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 829d66ab6956..7aab9225c4c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2608,7 +2608,10 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
 	min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
-	opt = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
+	opt = VM_ENTRY_IA32E_MODE |
+	      VM_ENTRY_SMM |
+	      VM_ENTRY_DEACT_DUAL_MONITOR |
+	      VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
 	      VM_ENTRY_LOAD_IA32_PAT |
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
@@ -4237,6 +4240,9 @@ static u32 vmx_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
 
+	vmentry_ctrl &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_SMM |
+			  VM_ENTRY_DEACT_DUAL_MONITOR);
+
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
-- 
2.35.3

