Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386E45A71A0
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiH3XSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiH3XSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B72A2217
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:41 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a12-20020a65604c000000b0042a8c1cc701so6095849pgp.1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=5F8+14Brh5MBr8u2d1sOMFBu5HJ9d+HmFP+Lqn7cDOc=;
        b=AhzYyLfFNuGgbjuIQkFVfgenN4nYB5fqEYsB7EXL5is96NH1JMK4lxC+5cEqSQnDeg
         xYtK2k+qu9V6IpkOfgcI54ZjUlsUXUgMWRiFqK2gLvXtLwhSJIfaImxh0jD5JNKqZRgh
         tU/HkpmM3/idqCBZvq5o56ItWTF5GShK86ESJbtY5y/7hd9rbZidBDEiDv6MGAe9lc5X
         CywobWBGB7FyVn0Emv25v85c1naYsWbm7u83FWGT8GA8s0PqUVtbmBNcn6uSwp7B7X43
         lWCiedpbC7iWoc9T71zbr6gEkJvZuFx6GrRmWrBKZh6rbx7KfXyUC1VKygj7P1ZfAIZ8
         ZLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=5F8+14Brh5MBr8u2d1sOMFBu5HJ9d+HmFP+Lqn7cDOc=;
        b=FBOxtVaa5VxCxBVwgOBPZbewVtj6u1J9c8oivrfwspmzbJ61xAtAGMqVK0zOosCoif
         3xbEOSCpNg2A854/h7KXzkxMmsu0VGLCtQktwCEHNtAr8kwWAmwhi8icZgE1NAuE9nJm
         4wf3d3y/AXnvbDWS3nNfMzK1YyKes6xKCsVcpTQ37FXCnmryryDimcV22oQE5n8AKgjo
         Qao9y2LS+UyOaHvjI24dJiWrJsf/ZMJb6e1m/ZHTucIlu34J+GtvJc9D5K5tO6j4u94j
         q9PGtZVQ/nAepKkE9TPF79kYfW83522Cvo5+sngOkWdc6Z/a25mkEEVO0utCCnyMiHNa
         gxUQ==
X-Gm-Message-State: ACgBeo1PYMzx9FCyTW/KK6QNhb3UPVOfhkhnhhVwe6RSNvHBYmeRxZ+u
        HMWckVL/u/Oq1aDlk3eOMlsLTkDDwN0=
X-Google-Smtp-Source: AA6agR6SCG/hxGLoCedS3jsDdR66U15jGtF+14OiyOp6Xd21xNUd8Utew7Vms6pnqUwaGStMPtlP8W4qYqs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8614:0:b0:538:1024:904e with SMTP id
 p20-20020aa78614000000b005381024904emr14961575pfn.49.1661901393819; Tue, 30
 Aug 2022 16:16:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:57 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-11-seanjc@google.com>
Subject: [PATCH v5 10/27] KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU
 is not in WFS
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

Fall through to handling other pending exception/events for L2 if SIPI
is pending while the CPU is not in Wait-for-SIPI.  KVM correctly ignores
the event, but incorrectly returns immediately, e.g. a SIPI coincident
with another event could lead to KVM incorrectly routing the event to L1
instead of L2.

Fixes: bf0cd88ce363 ("KVM: x86: emulate wait-for-SIPI and SIPI-VMExit")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5298457b3a1f..d11c785b2c1c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3932,10 +3932,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
-		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
+		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
 						apic->sipi_vector & 0xFFUL);
-		return 0;
+			return 0;
+		}
+		/* Fallthrough, the SIPI is completely ignored. */
 	}
 
 	/*
-- 
2.37.2.672.g94769d06f0-goog

