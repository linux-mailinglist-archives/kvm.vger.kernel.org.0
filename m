Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A31570FC8
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiGLB6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLB6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:58:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6513A1158
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:58:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c16-20020a170902b69000b0016a71a49c0cso4821321pls.23
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Y0CjAgq6supMoxk4TH1/4zRwjn0Pact/l2vMZyAt9GA=;
        b=QJaAKqQCW0/d5mjHyaHxMaXEl3uqeGDeikCIDIdSj//Q2pJ1NIJV//lz0ua65/T8qK
         jFbSoghPVz7L3q1i0RLtAQe8+hW7jPEDJ1sj4USQ+wYCNAbBdTbeZavgxKqKWIUdNgNa
         viKgW/k8XS9/ZgN9abeg0oJWqVVy/jy3VsmS4vNLud4CbEswyR0yT1rN4rJux4OtSJOG
         5IAUwsMxue/ZEiq1kWHTwQaTjQQJL7W2sM0OayxHKh7GB06XzPx5H5HVYdHUNIz7wfww
         IluC9iQZefTx1yw80Dm3aiz656NLyCGeLVrKVFLzb/K9T1IWq4cVwOJDFlacIwl6JDPV
         z8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Y0CjAgq6supMoxk4TH1/4zRwjn0Pact/l2vMZyAt9GA=;
        b=0R4bn/glUag0HA2e4uYkkeItzmH31XSY0SjkWaWwAXIdQTCbuuYUAHFXJMezoHvTHu
         IaaR8wIsbtHlqctrN+dUgiVanETSqAv8BwnEksHcSAAqOqSSSZvjEkRIV/mkGmoLBKsT
         wpnXDJZl6bskFx6rTCjfttm+iLMNJ9kQ5tQKnjb73GjFfS1sy5A+aYZCbCenx2dAhlDH
         U5jOa4TRxtkn4mypyJmsvm73n1baGjFhV8wWXyeVRuAo6YvzGovFugZkXd0vPqc7ULq/
         156rbFMlTng4PJkeJXfqoimkdkZt8qFJor5+1x5J3Ir4cLUTv79n7K+ISrhdagErC25A
         i7Qg==
X-Gm-Message-State: AJIora9njgtmXL2cjNT0W66UXf/VK1bMfvO56Yrm9233QJwfPxoD9Q97
        2LJZZFwhpAPorYAsu2IPVKkP9K6MxqE=
X-Google-Smtp-Source: AGRyM1sNI+6xOoDh+FCD+9HNCz58MEGIGdZiC6EF2YWTRAH3vdRMA795CEPy0BOmw00HoZFwU6YOTXpJpHc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1496:b0:52a:c3fb:8ec7 with SMTP id
 v22-20020a056a00149600b0052ac3fb8ec7mr11708706pfu.25.1657591120960; Mon, 11
 Jul 2022 18:58:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 01:58:38 +0000
Message-Id: <20220712015838.1253995-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH] KVM: VMX: Update PT MSR intercepts during filter change iff
 PT in host+guest
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
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

Update the Processor Trace (PT) MSR intercepts during a filter change if
and only if PT may be exposed to the guest, i.e. only if KVM is operating
in the so called "host+guest" mode where PT can be used simultaneously by
both the host and guest.  If PT is in system mode, the host is the sole
owner of PT and the MSRs should never be passed through to the guest.

Luckily the missed check only results in unnecessary work, as select RTIT
MSRs are passed through only when RTIT tracing is enabled "in" the guest,
and tracing can't be enabled in the guest when KVM is in system mode
(writes to guest.MSR_IA32_RTIT_CTL are disallowed).

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 74ca64e97643..e6ab2c2c4d3b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4004,7 +4004,9 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
 	}
 
-	pt_update_intercept_for_msr(vcpu);
+	/* PT MSRs can be passed through iff PT is exposed to the guest. */
+	if (vmx_pt_mode_is_host_guest())
+		pt_update_intercept_for_msr(vcpu);
 }
 
 static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,

base-commit: 5406e590ac8fa33e390616031370806cdbcc5791
-- 
2.37.0.144.g8ac04bfd2-goog

