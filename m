Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF0C4D58F8
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346306AbiCKDaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346063AbiCKD3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:52 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01F6F47CF
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:33 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id e1-20020a17090a280100b001bf44b6d74bso7110238pjd.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GjFGC3zkLsAKJ8vvrLjGXYpYaWOgGo2yckKlLK/AIVY=;
        b=KQO3w+xmpoTyRvXAzcDfzPqPSx3WjGUr9L3gTJqQHiDJ2yTrH27YOKscDQl3Bp5Ua3
         JfqPIci9q5Jz4WO1A/G7lKuGKCZy7o4nCNEH/GgMX4qgdeli7FwIJjONYLTXwvxHizcN
         ozj8xFK5uiv1S8Bxp5Q7v9KiTJL0C6gmswS3YDE6EO4srnr7tfn3oEo4fSfRoseyDUPa
         nYhSc4QJzLV3W0edaaRrTPITCokuqgad2WWpUjLMM05Y7Eo0ViwaEzaYdn5qjPsJf2PM
         nHFQ4o/2Gnq/9A+Zylc7yuArpklMIbfeTAmAoMdwT6rHfpUMp50gbBjzoaytKI6TAL+F
         Jx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GjFGC3zkLsAKJ8vvrLjGXYpYaWOgGo2yckKlLK/AIVY=;
        b=RqJjBt+4LahBlXGlmxxVEJZ1Ps5JPvbzyRINF8NlrPPLzXUzN0mzfHX8vK52Aoi2+S
         i1qd6YJwx5mcA0DkeMfemDiTeyo2l/RAQklang8FOc++nHQjhxpXt+EuWUqIwd6+QVlq
         QIbtk2NLSY+xT6nHM7X/6tf02w/gVcpz+LEAC/z3ZzTFmGdHPggD9ZnvRF2gihunq2US
         3IO82D1NnTbmNfuruVBbi32gSn+AeVZsri8WQ4DvjmfVUu0PfS/cixblw36PGLdeYmCk
         rU3a72srS93w06+Zrg8IivphnGDGOOSf+TFxZCDw6PlbiavVW63CB2foLPWsYKoOhfMQ
         dl8w==
X-Gm-Message-State: AOAM530IEVwhLXnOct9yNF8J4TITurs/BLmWzv2dvoDiA1r3+E+Kh8mI
        9+JXwQmCyw3d+x5TyY1oPBJpW93Npps=
X-Google-Smtp-Source: ABdhPJzHDnuZl/O/d0//LQZL3QjijqGxvFKvqsDfvyxeDIx3v/bkVReGqtS28e14C/BWbLfRKeuJ3m7CVLg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d81:b0:1bf:8ce4:4f51 with SMTP id
 oj1-20020a17090b4d8100b001bf8ce44f51mr404251pjb.0.1646969313078; Thu, 10 Mar
 2022 19:28:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:57 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 17/21] KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after
 potential VM-Exit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Determine whether or not new events can be injected after checking nested
events.  If a VM-Exit occurred during nested event handling, any previous
event that needed re-injection is gone from's KVM perspective; the event
is captured in the vmc*12 VM-Exit information, but doesn't exist in terms
of what needs to be done for entry to L1.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1cd2166fe22..327a935712fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9310,7 +9310,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
-	bool can_inject = !kvm_event_needs_reinjection(vcpu);
+	bool can_inject;
 	int r;
 
 	/*
@@ -9375,7 +9375,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	if (r < 0)
 		goto out;
 
-	/* try to inject new event if pending */
+	/*
+	 * New events, other than exceptions, cannot be injected if KVM needs
+	 * to re-inject a previous event.  See above comments on re-injecting
+	 * for why pending exceptions get priority.
+	 */
+	can_inject = !kvm_event_needs_reinjection(vcpu);
+
 	if (vcpu->arch.exception.pending) {
 		trace_kvm_inj_exception(vcpu->arch.exception.vector,
 					vcpu->arch.exception.has_error_code,
-- 
2.35.1.723.g4982287a31-goog

