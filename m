Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569BB587FD5
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiHBQJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbiHBQJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:09:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77D063B945
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lIpaFmFN2wweGqP11BTF91uarfy38qH6oE5t+hOdG0Q=;
        b=cwc6zg9qaDdnmhpiBfxQmOV0+cCh5KqS3vDpZiKWEGku1CZi8fx56L0zi083tzp9wNQaSZ
        dSZ7MQYOT+ktWLObqVnQdWS+B7wn+9IFta4llMBQUEjyuXtkBUyE1BRZBN6loOyxaIdNbu
        dKqySvBRwjUicPBPigtbE6yuXCGg6fU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-sbGPiJUxMIu38wzNFcx31w-1; Tue, 02 Aug 2022 12:08:35 -0400
X-MC-Unique: sbGPiJUxMIu38wzNFcx31w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAED8811768;
        Tue,  2 Aug 2022 16:08:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FDC82166B2B;
        Tue,  2 Aug 2022 16:08:32 +0000 (UTC)
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
Subject: [PATCH v5 12/26] KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
Date:   Tue,  2 Aug 2022 18:07:42 +0200
Message-Id: <20220802160756.339464-13-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VM_ENTRY_IA32E_MODE control is toggled dynamically by vmx_set_efer()
and setup_vmcs_config() doesn't check its existence. On the contrary,
nested_vmx_setup_ctls_msrs() doesn set it on x86_64. Add the missing
check and filter the bit out in vmx_vmentry_ctrl().

No (real) functional change intended as all existing CPUs supporting
long mode and VMX are supposed to have it.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7a18a1828dc0..5429101eea87 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2689,6 +2689,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
 	min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
+#ifdef CONFIG_X86_64
+	min |= VM_ENTRY_IA32E_MODE;
+#endif
 	opt = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
 	      VM_ENTRY_LOAD_IA32_PAT |
 	      VM_ENTRY_LOAD_IA32_EFER |
@@ -4323,9 +4326,14 @@ static u32 vmx_vmentry_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
-	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-	return vmentry_ctrl &
-		~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_EFER);
+	/*
+	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
+	 */
+	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
+			  VM_ENTRY_LOAD_IA32_EFER |
+			  VM_ENTRY_IA32E_MODE);
+
+	return vmentry_ctrl;
 }
 
 static u32 vmx_vmexit_ctrl(void)
-- 
2.35.3

