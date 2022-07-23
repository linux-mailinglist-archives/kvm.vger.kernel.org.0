Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179FA57EAD8
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiGWAxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236686AbiGWAxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:53:07 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7631C198B
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:20 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 92-20020a17090a09e500b001d917022847so2611478pjo.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zf1eynWwF6SwWvKmGCaEsitzwxnpNnaxjN9o7uERh5g=;
        b=gVYbLiB34SPJY8UCNCCv3Rf2F3pQkuldFm+43P0MJ0KurE0TUCTdgwU2TCYZ/YHkXg
         EeqYYYNDTnEM2QfB76TshJzpMFOOUmSTazGFE1f9QKo/kVKBS/HBoI3Bez53HmNDUzwF
         Eb1vKH/RcDAZx6JIG+FuoiZhkpef6zY8zC1AKQ2+j7sDK8E4eeBKy8vs8QoENxVQ5zEV
         uqei9JvDti3GJ2+w1gr+5C0zd9MrkEBx8dl1n5QzWkhPIqP0zSCZIQfkpG+EoALGbY8h
         Cdi1HNvafvLUgZu7J9vbVSeT1UWm29ieff1O60DmIUFgbc2TARdjShimRFaGKOVBxEyn
         zEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zf1eynWwF6SwWvKmGCaEsitzwxnpNnaxjN9o7uERh5g=;
        b=bU6u4IfggEgTmRRlrz+aI8lQQtxPMBjnJZeIQnEbVgVq3yZglDCh2V68QCeHdxJM0f
         SZ8Te+X2qYuUeqBsZQRG/kHnqO2Ay9Xl9fCC8YUlxjio0/vp0FE+O71zUlNyRXsbskq2
         Do9gOHfKwh5W0l5pxoMX6iWANCOUbEyBZccH6ZhTQhQHZjpk3VBT04G2Bvweb3WFkRCo
         Y/VHMYLTG3XGys0iI1BSr8e2AQs39SKZzSc5ez+ZM955abONON+DqhfKJoWQ1k/sgm81
         cq/2th7hejgjWDEnghJ7svp8VGiiDvX3qUKOFvYmVWJYN+047Dcd4NvgTckBqb4ns7P0
         KpNw==
X-Gm-Message-State: AJIora87ES+QP2yOXdF/OEUyGs3Dzvt/x2wn4B+Bb2sZxszE/3mURqae
        Sl6UDpzu3FvnvqPtDYzMo/KgQRRAhqE=
X-Google-Smtp-Source: AGRyM1tJVp9yOsLQRQ8KAjsSrzkqlug1qHo5gpI86daWUDzYqWInlZsRDmq4fCXmJ4FxoVVDpPm0yOCHrKw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:993:b0:52a:dd93:f02d with SMTP id
 u19-20020a056a00099300b0052add93f02dmr2563317pfg.12.1658537527236; Fri, 22
 Jul 2022 17:52:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:29 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 16/24] KVM: x86: Evaluate ability to inject SMI/NMI/IRQ
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
index 046c8c2fbd8f..fb9edbb6ee1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9670,7 +9670,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
-	bool can_inject = !kvm_event_needs_reinjection(vcpu);
+	bool can_inject;
 	int r;
 
 	/*
@@ -9735,7 +9735,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
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
2.37.1.359.gd136c6c3e2-goog

