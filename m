Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298575A652E
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiH3Nkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiH3NkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF5B15C35A
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIDGD8GCQ/FPC65YQ6Szcq+FOUME6vtJY3GqQdCftQc=;
        b=SFAEKkfj1heZIKkYzpUFtjh1dJ1svh2ZfbTbIKzy3o+S8xwo7AqHuMHFAwwv85nq4uEDyh
        0RQ+rK59EiDOJyVDsorayeTpfKNnJsp+BWoWQYj2qvuKHgNxOs4VsvOp2AAT5KAR53gJFy
        /DhlL8zHFGaZz7iLrT0B6q3IcLphgko=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-F_6G9Un-Mxi24sCQ8Z6jQw-1; Tue, 30 Aug 2022 09:38:35 -0400
X-MC-Unique: F_6G9Un-Mxi24sCQ8Z6jQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FD2F1C006AD;
        Tue, 30 Aug 2022 13:38:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FA0B2166B26;
        Tue, 30 Aug 2022 13:38:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 21/33] KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
Date:   Tue, 30 Aug 2022 15:37:25 +0200
Message-Id: <20220830133737.1539624-22-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SECONDARY_EXEC_ENCLS_EXITING is the only control which is conditionally
added to the 'optional' checklist in setup_vmcs_config() but the special
case can be avoided by always checking for its presence first and filtering
out the result later.

Note: the situation when SECONDARY_EXEC_ENCLS_EXITING is present but
cpu_has_sgx() is false is possible when SGX is "soft-disabled", e.g. if
software writes MCE control MSRs or there's an uncorrectable #MC.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cfe1a1157302..9a9cdd4ea34d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2605,9 +2605,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
 			SECONDARY_EXEC_ENABLE_VMFUNC |
 			SECONDARY_EXEC_BUS_LOCK_DETECTION |
-			SECONDARY_EXEC_NOTIFY_VM_EXITING;
-		if (cpu_has_sgx())
-			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
+			SECONDARY_EXEC_NOTIFY_VM_EXITING |
+			SECONDARY_EXEC_ENCLS_EXITING;
+
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -2654,6 +2654,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		vmx_cap->vpid = 0;
 	}
 
+	if (!cpu_has_sgx())
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
+
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
 		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
 
-- 
2.37.2

