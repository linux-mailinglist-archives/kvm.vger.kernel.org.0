Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B678A574858
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiGNJQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbiGNJP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D01746DA3
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ygN09/Et0x9AXxOLKNcgOKq7+SIjoPvaEFk+cetSQ+s=;
        b=jMwfe9XPwC/pST2il/mZzIdrkyMmwu3YUC3Xp4JVonDyMzEfEGLMqmz4bCDRmvfMaWQs2W
        wt82PIZf3zlwTqsF7N6S35xjc/mdzNNstT7o8xOMKMxWMe9dhdy5a26crJ1g43GC9STuYE
        b9quOywqR/d2q1alVyovu/iCqUgbc9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-ImxbPXs0Nourh8Mjop-Dqw-1; Thu, 14 Jul 2022 05:14:18 -0400
X-MC-Unique: ImxbPXs0Nourh8Mjop-Dqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B520185A794;
        Thu, 14 Jul 2022 09:14:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A2E02166B26;
        Thu, 14 Jul 2022 09:14:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 19/25] KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not setup
Date:   Thu, 14 Jul 2022 11:13:21 +0200
Message-Id: <20220714091327.1085353-20-vkuznets@redhat.com>
In-Reply-To: <20220714091327.1085353-1-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Clear the CR3 and INVLPG interception controls at runtime based on
whether or not EPT is being _used_, as opposed to clearing the bits at
setup if EPT is _supported_ in hardware, and then restoring them when EPT
is not used.  Not mucking with the base config will allow using the base
config as the starting point for emulating the VMX capability MSRs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9771c771c8f5..eca6875d6732 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2501,13 +2501,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	rdmsr_safe(MSR_IA32_VMX_EPT_VPID_CAP,
 		&vmx_cap->ept, &vmx_cap->vpid);
 
-	if (_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) {
-		/* CR3 accesses and invlpg don't need to cause VM Exits when EPT
-		   enabled */
-		_cpu_based_exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
-					     CPU_BASED_CR3_STORE_EXITING |
-					     CPU_BASED_INVLPG_EXITING);
-	} else if (vmx_cap->ept) {
+	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
+	    vmx_cap->ept) {
 		pr_warn_once("EPT CAP should not exist if not support "
 				"1-setting enable EPT VM-execution control\n");
 
@@ -4264,10 +4259,11 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 		exec_control |= CPU_BASED_CR8_STORE_EXITING |
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
-	if (!enable_ept)
-		exec_control |= CPU_BASED_CR3_STORE_EXITING |
-				CPU_BASED_CR3_LOAD_EXITING  |
-				CPU_BASED_INVLPG_EXITING;
+	/* No need to intercept CR3 access or INVPLG when using EPT. */
+	if (enable_ept)
+		exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
+				  CPU_BASED_CR3_STORE_EXITING |
+				  CPU_BASED_INVLPG_EXITING);
 	if (kvm_mwait_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~(CPU_BASED_MWAIT_EXITING |
 				CPU_BASED_MONITOR_EXITING);
-- 
2.35.3

