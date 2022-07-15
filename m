Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8843B576871
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiGOUo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbiGOUnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357AB8AB39
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:12 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h185-20020a636cc2000000b00419b8e7df69so2907846pgc.18
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b1+xk/Y7b8L14xDx8lu5Sp2toyFgT2PYmi9IKXMneac=;
        b=lk6o7V/cUP+Hg7L5UNLK0PIf2rxcTW8RlPtg1EjCwrRTtmRO5gdpjH1klE/QAn0BoV
         VWGAv8FRIcmGr+ZNHWtloV3O42Vcm7SAbf8ti/IgzHAI7+EcjiDGgMsN21IEWZspsOz4
         FTU0f0aKQacQoe4p/mWApwMS40uZ9FuYOsm3V7Tj9gK1AnVaucPPlflX++eVcOH75OZw
         yFpUBuKiW35/lux1y92mFsI/EgtUGlyHIrluO/ZoY+09kPZ4wAUChU2S4iTBUC0hTXI1
         JFx8zBEv/V9xBBe1mrZ3wGTvY+QxlcXt5kbar3DwI/WTWTA+Xe1pZkz8ckQ1EDK2/RX1
         tLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b1+xk/Y7b8L14xDx8lu5Sp2toyFgT2PYmi9IKXMneac=;
        b=FG33+xgKKfrCx4AIYICd1pAoafGjoLDGi38kNeA7hd43vZeogvjtgXr/So6K7SBnnm
         qaoOheZFiBDJI4phZVNwihjFf4NhioEhpScGX/551ocGW3P9RDJ3HfEYTvqFu84+GqnY
         jIWyjBa1BYs1XlcMgBsSPLze5vL/vSzrUpNlWhY4wDk9/ZSQ8yV0HPlo3e8huOWCs4kJ
         KUvkKbAvHpIfKRkoYRuWhs86GjfJugnUCxvE7vS0Hwj6u6GEeMxFK4QDLafyyIssN8ZG
         9zyWdPtwFDt05ellCGiggxdnV49gD6tgqSqtXFlfXlwKZJGPhWbMdKJDU48yoSdwuDK9
         O9sw==
X-Gm-Message-State: AJIora+hggxB8UTkjwfBH/Lxsnk8tAkgUI8PRGVxpEkU/0na6DiiGky5
        GP99FOqJjGmTf559RdWXjMbxA+YcURw=
X-Google-Smtp-Source: AGRyM1tqH6Ngc9Dctqv+GkOtKhVxWahi++xo+RkGolYzcUS4LRAdQ8J994VOKOzr7orRl3z2w4x3ObF75yY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:14d2:b0:52a:d2a1:5119 with SMTP id
 w18-20020a056a0014d200b0052ad2a15119mr15597341pfu.36.1657917781132; Fri, 15
 Jul 2022 13:43:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:18 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 16/24] KVM: x86: Evaluate ability to inject SMI/NMI/IRQ
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 9e20d34d856d..795c799fc767 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9657,7 +9657,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
-	bool can_inject = !kvm_event_needs_reinjection(vcpu);
+	bool can_inject;
 	int r;
 
 	/*
@@ -9722,7 +9722,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
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
2.37.0.170.g444d1eabd0-goog

