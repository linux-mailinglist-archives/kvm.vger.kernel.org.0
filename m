Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E015A71AC
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiH3XT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiH3XS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B30A2DA3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:53 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id cj15-20020a056a00298f00b0053a700f1178so1447605pfb.14
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=6sbjG07/3BJg7OhuoSrfyiDHRM9Via7ZFsnDogcWimo=;
        b=O4mRBlL1GVybesZRph3jxADQGbSp7RAZAKEKxl/yQutqEWROG+vXriwhT4cwxSC98i
         KN8IqmYHuulMt/uOeEy03Jo3DUBNUrACt4nAnSUY5ePNdu4NFmoy5ave8wuphTBJDLAm
         Ivfv3D6Vx6fa14019uFWe9S4CrPjsH0dmtR9s9Qg/dOks9JKJUfXs8q0ep9abWf9kHIO
         UXeZ8EcHGJK0YT5gFa4JE3tnM+w+k471tss9JvmSJFeK1nkh670haRdum+PkEGCyGGDb
         kIYKV4iMAyv7N0ciA2AKYFPrhgXCoUAhpyCJlbu4VJIAIGzGHXAJQTb2zHignDCAXuNJ
         YgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=6sbjG07/3BJg7OhuoSrfyiDHRM9Via7ZFsnDogcWimo=;
        b=2/Bu4OIyyWu3IQyCszNBhITAmSky7ZSfnZENY6NHisahEdOSMjRqb0nsamV87Ukic3
         n+qvjmzzNmuIbPXHRnUU9BqE6k/+LXPk0A/yP7ySZK5ckvwaDFJImQPBMN4SsRseUfQO
         2EEJEZZ5uT8Kwc3axB9ucOaGzvHOCigbhiw3VNCPMOTYqiSf3BlnwInU9Ih3rYeP6uBq
         RUwWoWF4uSMuVdvh2dlAYREszM8ngjNAUewUW5dbvYhdn3Ry6OAeHB1uBuNwdkFajBTb
         KdDX8WGJsKC9S43D47xDGT7ap8/WXuK7g5NN0BD2zCGiNvHPsPPvSc1OM3m78OZ3fBiY
         vilA==
X-Gm-Message-State: ACgBeo1Y4YppfMT9L+423NI4WP68mMfOJ79wcAbM8Uta/TfaY9G6WsyZ
        f+8iJvKrXouXODxOhXWHN2EGTVwRdWg=
X-Google-Smtp-Source: AA6agR7SjO9JLbxN2xHQ6E0RBIlXXzvLyhqG5+N9qcoWAY4kD36SH0j14mV/yI2xP1mPSJid8n5KjtEfb1I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ac4:b0:535:c08:2da7 with SMTP id
 c4-20020a056a000ac400b005350c082da7mr23729757pfl.69.1661901407279; Tue, 30
 Aug 2022 16:16:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:05 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-19-seanjc@google.com>
Subject: [PATCH v5 18/27] KVM: x86: Evaluate ability to inject SMI/NMI/IRQ
 after potential VM-Exit
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 534484318d52..57f10bfcb90d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9711,7 +9711,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
-	bool can_inject = !kvm_event_needs_reinjection(vcpu);
+	bool can_inject;
 	int r;
 
 	/*
@@ -9776,7 +9776,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
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
 		/*
 		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS
-- 
2.37.2.672.g94769d06f0-goog

