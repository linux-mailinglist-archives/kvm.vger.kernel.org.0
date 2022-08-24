Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E889159F1C1
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiHXDEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbiHXDDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1017E32D
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r13-20020a17090a454d00b001f04dfc6195so152777pjm.2
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=100R8KB8sp54zNizYkSyo3dwNXMydCkPPZEmTAWlwFQ=;
        b=RxX89c1Ei1n7hs3jaYncBNDrkTFCFWhYi1TMfRTr+jZ+lxMy+UcPgpoShGIYY3Jgzw
         H5LD7MKw4KtNlZOdpz5sWrSSmapT3d4lAd+o9O2gNxtWu5ooE1/yNYtxwk2zRSVWQY3y
         RuqyG0eWgGpKTp58/dKgbYaggk+4MtQGLjtSN0BGgWiOg1XTTuByELx8cDkinZGnnxAH
         RUZgB916eHhRgnFgv5jcdvRVQl0axZJbrZrpGQi5sFSHl1+pFz7Q4ezQJnXfNpKqEqlD
         kkiFa3yjtuUb8vnlduDijHUYnY2RNyid9cibM2glE8kav0Tv2E2pxGH7oTZpJ+qEFyIW
         vROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=100R8KB8sp54zNizYkSyo3dwNXMydCkPPZEmTAWlwFQ=;
        b=T89N8f7V/SQxt1+Hlxe2PFlinVKka/p92c85B72q9HFshpoPzXVnJW/v3QNtHluhvq
         py4CwIBEkaXNRuVm97eFJ9YtDuI2yxQBBClvHJzVgeTxyXcSdlURLSMeMpAUolQyd5fz
         Nbi1KvRO+0np1bZTAW/RYIKdweExpdPEajebIKtLFNlNE3EXPhgW26QUpNce6kaMrqA5
         YouIXlyljtFRduBjQYsrjYBRmtBiKMsd1Ako6nDoMYhRh686lOVCwQs69O7Cwv2B9Cxi
         6RhU1Bz1nm7axOmlYP3uaolKCemvldptMqReDRb6/Yx/nMqFiRo33hcA/DI8lNC0y7Fs
         UUZw==
X-Gm-Message-State: ACgBeo3VTUEEq7g8TaD0E60Tmw0XjDtboPrHDfKKHA43ptLJMW0vcgZd
        p69D2mfdB8hGIHXOzpTFgQCghLdIwnQ=
X-Google-Smtp-Source: AA6agR73cypLE3h+YuYEF24Aao/vV9s2yWoQYOl4a+gS75cmqkeFSwVp47ayhmIriH05EXE/MB1LlCSQOWI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9486:0:b0:536:b212:172f with SMTP id
 z6-20020aa79486000000b00536b212172fmr11167373pfk.70.1661310141375; Tue, 23
 Aug 2022 20:02:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:26 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-25-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 24/36] KVM: VMX: Tweak the special handling of
 SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

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
index 7acbe43030e4..e694eb2190f3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2601,9 +2601,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
@@ -2650,6 +2650,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		vmx_cap->vpid = 0;
 	}
 
+	if (!cpu_has_sgx())
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
+
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
 		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
 
-- 
2.37.1.595.g718a3a8f04-goog

