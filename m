Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837D4587FDB
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbiHBQKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbiHBQJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:09:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F6FE4D822
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syV1QiP2D6qZdx5gYvh2Pf05AnQv08n8h4vqFGHxi1Q=;
        b=cETlJG/cDweQ0l9TjtSEozdneMcu6Whh+1SWl88yXz7rvtU+3wwYbBLiqSj+hK5qCLLffv
        aGjIonhYXbk7GhdrVBaqm+VBOspG38yb/28VM0clpFJzJiCBOrAw4RhEF7sSaS6ctU3zN8
        cUVPHnac8CLsZP9XDhlJQCuYO99Uwqk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-xh9QOW45OmmwuAfiGpF2_Q-1; Tue, 02 Aug 2022 12:08:40 -0400
X-MC-Unique: xh9QOW45OmmwuAfiGpF2_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CA0D3803914;
        Tue,  2 Aug 2022 16:08:40 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D00672166B26;
        Tue,  2 Aug 2022 16:08:37 +0000 (UTC)
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
Subject: [PATCH v5 14/26] KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
Date:   Tue,  2 Aug 2022 18:07:44 +0200
Message-Id: <20220802160756.339464-15-vkuznets@redhat.com>
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
---
 arch/x86/kvm/vmx/vmx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 554326651372..2323783024b7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2607,9 +2607,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
@@ -2656,6 +2656,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		vmx_cap->vpid = 0;
 	}
 
+	if (!cpu_has_sgx())
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
+
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
 		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
 
-- 
2.35.3

