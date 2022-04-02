Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6B64EFDA3
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353664AbiDBBLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353646AbiDBBLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:11:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A7D99EEE
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i5-20020a639d05000000b003822fae3e50so2359573pgd.8
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ypH5s9Nl45kyR4SuhKSlPLb77qSDCCBtuo3KelNxUkU=;
        b=BXvV6YKppMwrneibybdzCprZebgaEvZuaku3g2RP08ReeutXggwQUvUEMu2PdJkNW/
         A0OeCGqKs5NsravDHk7WH5WR0/9K3xTlj8jSH5jMz19zxO6c5vICa+jOJdm5PfsonavW
         GzlcTn15RsgJexM1+R6HT8bULRuo8uhHwG/io90+NPf/VUA7DQY/rjEYkotOnuiffcK2
         2mFahGJuY3hMiBB5eajBIsKa9CNmYVcV2NmeyNJkeCK4SyDKmR9+hi58C4dcY/ftu9Oz
         KYZ1yWUU+lOeGCrRX8XJdUgsmNpaGFeCwI1uNGOM1KALML8V9ri800OZVVfpYSo6aR9t
         X4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ypH5s9Nl45kyR4SuhKSlPLb77qSDCCBtuo3KelNxUkU=;
        b=jyESdGb556kpHwviM2p5FVnKXT+pYhJ/z8CvybayR8VFRUxjrT19HiHXfKfNL0fi1x
         uZAGvP9nZK2lvetEgCLmllsrDVOqrooYOAY18Oh8Bqr6tBeP/Kv/WjFYJkjoHNewokFt
         1p8JZEcRaMC+4jp6pZSrlnKL4IGsBAajD+uPnI9v6PVudKpN6BIEX2GMj2ZyapGCi+L0
         Wt3a7OyFWo+VA//8cgCwbLO2VDlLYrUL872wQvbTPdNNbBSVgUIYxbyj8n0w/0WdxRHZ
         3pSRhv4SEKE/Bcgc2C7fBU8fm7W5O/lxdv3WmpgbWyhKmAPXbKPjnAFCAr3Fkit4VX/o
         W+BA==
X-Gm-Message-State: AOAM533s/UEgFnxReLBuhcoB2dPPiiUy4EcEXH12mov/YPQJ6YefT8zp
        U9/juqRjSsrY9ZtlE/mGMZse2jqJQPs=
X-Google-Smtp-Source: ABdhPJwVqOaLLTOsAFXe7H2DrUpM4AjNGa3ENYnyWHTSNot0jahAIZOQE0GVR+TBjQ6kE1cm0gpXEbB0OFA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bf06:b0:14d:8c72:96c6 with SMTP id
 bi6-20020a170902bf0600b0014d8c7296c6mr13129728plb.156.1648861757108; Fri, 01
 Apr 2022 18:09:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:09:02 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 7/8] KVM: x86: Trace re-injected exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
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

Trace exceptions that are re-injected, not just those that KVM is
injecting for the first time.  Debugging re-injection bugs is painful
enough as is, not having visibility into what KVM is doing only makes
things worse.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a066cf92692..384091600bc2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9382,6 +9382,10 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	trace_kvm_inj_exception(vcpu->arch.exception.nr,
+				vcpu->arch.exception.has_error_code,
+				vcpu->arch.exception.error_code);
+
 	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
 		vcpu->arch.exception.error_code = false;
 	static_call(kvm_x86_queue_exception)(vcpu);
@@ -9439,10 +9443,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
 		vcpu->arch.exception.pending = false;
 		vcpu->arch.exception.injected = true;
 
-- 
2.35.1.1094.g7c7d902a7c-goog

