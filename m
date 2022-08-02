Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3958E587FE4
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbiHBQKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237656AbiHBQKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:10:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A8274B0D8
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0YbH0rt1hpcwgrVsFjb7JNOUIegxaqejDVDZQzlBTg=;
        b=cgHckPxvna9OEMZhKoeCjGDPd42huKUjuNNIifNEQuitxZPW5BGv+CM8BQfpgHUfJrAsLL
        cxXrz1GxT4TXwvs6sBC0ejyYdK7/Hou/D33HofeZ9RFLQk9ciyPXI6xAxuhHiy+E8L8EXD
        5DTniWD7phRDOghYRkLUM2MAuZEenOY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46--M_nq93vNd21oTglc4vgGw-1; Tue, 02 Aug 2022 12:08:48 -0400
X-MC-Unique: -M_nq93vNd21oTglc4vgGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ACC4803520;
        Tue,  2 Aug 2022 16:08:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 538742166B2A;
        Tue,  2 Aug 2022 16:08:46 +0000 (UTC)
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
Subject: [PATCH v5 17/26] KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of setup_vmcs_config()
Date:   Tue,  2 Aug 2022 18:07:47 +0200
Message-Id: <20220802160756.339464-18-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering
to vmx_exec_control().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75cadb371fbb..94d7060aebe1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2558,11 +2558,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control))
 		return -EIO;
-#ifdef CONFIG_X86_64
-	if (_cpu_based_exec_control & CPU_BASED_TPR_SHADOW)
-		_cpu_based_exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
-					   ~CPU_BASED_CR8_STORE_EXITING;
-#endif
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		if (adjust_vmx_controls(KVM_REQUIRED_VMX_SECONDARY_VM_EXEC_CONTROL,
 					KVM_OPTIONAL_VMX_SECONDARY_VM_EXEC_CONTROL,
@@ -4333,13 +4328,17 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
 		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
 
-	if (!cpu_need_tpr_shadow(&vmx->vcpu)) {
+	if (!cpu_need_tpr_shadow(&vmx->vcpu))
 		exec_control &= ~CPU_BASED_TPR_SHADOW;
+
 #ifdef CONFIG_X86_64
+	if (exec_control & CPU_BASED_TPR_SHADOW)
+		exec_control &= ~(CPU_BASED_CR8_LOAD_EXITING |
+				  CPU_BASED_CR8_STORE_EXITING);
+	else
 		exec_control |= CPU_BASED_CR8_STORE_EXITING |
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
-	}
 	if (!enable_ept)
 		exec_control |= CPU_BASED_CR3_STORE_EXITING |
 				CPU_BASED_CR3_LOAD_EXITING  |
-- 
2.35.3

