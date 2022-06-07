Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9E854272E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443735AbiFHBAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835819AbiFGX5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:57:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6E67B9F9
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 16:24:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e18-20020a170902ef5200b0016153d857a6so10116600plx.5
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 16:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HzWsVgdFm2oYqm1OPj6CBRtZTI++je2WpE9vsT9Q4dE=;
        b=qfNZPl0DGpAwisczdNca9pITU2U9zMEzWm3BrXjbGd897plb5bXbxmk9W2/2Rvcw5k
         yv28W4H+7VJu/PtlIgHIZsV47WgaPwW1qtt3M3gOa9pyxg8/sVDWna3mdIEK8WrIjPLf
         Utgnt+Iy2tBPuYKAJ4WriOfIiJ27Ra12p+CcwljmCA0RcV6d/3WcWADFnwy21L3IOS05
         c+ZNT425BSZ5rPfQZK7AvtaHBI3KS4HB8ZUBIp4vzhG8UEN8qU6qbdxnhFsQRriUP2J4
         XLftzFfLaunpJp5g4sP5m4m1Cl6SAnJ4MCUNAXqNfkYYuGFR23mIZh1g4c0RrCBW4Qjf
         LF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HzWsVgdFm2oYqm1OPj6CBRtZTI++je2WpE9vsT9Q4dE=;
        b=fPp97s2mjOqFynvnOfJ1MfpB5Ba3kFgdHpCgqn0Tb/pAF1Kxc3HFnDZBzr1EFMCZ0F
         U653/EV4ulzZ7X0k8d96q5/Ms2CMDYryKHUJecMlhczD9lzLnDCkHvvMdz30pUeppBme
         l4/Ewta1+s1YxIZKXCzwdHOKVzzCUxBraj9E9WOn4zxDlg9X/oLHDxxvXhw0KShtuSvz
         4402WFkt4LO5cb7moXi5EvrPj/FWt2Lz6Q/tesEBPf3h0zlZu1sn/L1pU9tttkzbEsHi
         FBexg/qdfMItzsMoum2Ol1AEfOW+o1ejxCBQdSuOX9P8wI014XHY/xkzn9/47axriwf4
         FQqw==
X-Gm-Message-State: AOAM531pWt98mJ6svDpzD5jPkENBAXneKcQn3HnMlppGw0IC8t/Uy4wq
        OTfRGGMl+cOA+1EFrIz7WGxzGRD6A98=
X-Google-Smtp-Source: ABdhPJwW+RRDZoQq7Au7i9xNoeOWMcVvfwUqmH7KW55H9yWzXC5KnkE0nQyEfRlvmk0fFjuflWIQaM47J68=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1688:b0:517:cf7b:9293 with SMTP id
 k8-20020a056a00168800b00517cf7b9293mr99735795pfc.7.1654644239818; Tue, 07 Jun
 2022 16:23:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 23:23:52 +0000
In-Reply-To: <20220607232353.3375324-1-seanjc@google.com>
Message-Id: <20220607232353.3375324-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220607232353.3375324-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 2/3] KVM: VMX: Move MSR_IA32_FEAT_CTL.LOCKED check into "is
 valid" helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Move the check on IA32_FEATURE_CONTROL being locked, i.e. read-only from
the guest, into the helper to check the overall validity of the incoming
value.  Opportunistically rename the helper to make it clear that it
returns a bool.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8e83e12373c5..eb4cd66055f8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1755,8 +1755,8 @@ bool nested_vmx_allowed(struct kvm_vcpu *vcpu)
 					FEAT_CTL_SGX_ENABLED		 | \
 					FEAT_CTL_LMCE_ENABLED)
 
-static inline bool vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
-						 struct msr_data *msr)
+static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
+						    struct msr_data *msr)
 {
 	uint64_t valid_bits;
 
@@ -1767,6 +1767,10 @@ static inline bool vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	WARN_ON_ONCE(vmx->msr_ia32_feature_control_valid_bits &
 		     ~KVM_SUPPORTED_FEATURE_CONTROL);
 
+	if (!msr->host_initiated &&
+	    (vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED))
+		return false;
+
 	if (msr->host_initiated)
 		valid_bits = KVM_SUPPORTED_FEATURE_CONTROL;
 	else
@@ -2165,10 +2169,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.mcg_ext_ctl = data;
 		break;
 	case MSR_IA32_FEAT_CTL:
-		if (!vmx_feature_control_msr_valid(vmx, msr_info) ||
-		    (to_vmx(vcpu)->msr_ia32_feature_control &
-		     FEAT_CTL_LOCKED && !msr_info->host_initiated))
+		if (!is_vmx_feature_control_msr_valid(vmx, msr_info))
 			return 1;
+
 		vmx->msr_ia32_feature_control = data;
 		if (msr_info->host_initiated && data == 0)
 			vmx_leave_nested(vcpu);
-- 
2.36.1.255.ge46751e96f-goog

