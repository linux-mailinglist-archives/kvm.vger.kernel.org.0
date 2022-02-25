Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32524C4D99
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiBYSXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiBYSX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:23:27 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F12F11AA
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:54 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id u17-20020a63a911000000b0037491401c44so3050616pge.17
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VKMBlWNx4jK1iDVhpsaRZcvzkSOAxKFhhP9NDDoxkLA=;
        b=Fdd0ugG9W3f4EJeeUYsCgb8W9Ynd5MF6AKEcW9LnQwoRU3YEau0D2ZwFmpoNIOuvd1
         J6HppSKpX/QYcTmEka6QjbKpAhYpeQgkge2amIHPVjFS9MehVv+XZZd30rcmdCiItSeY
         0l6W7scfFbqHQAkX4U1MAUk+AlREKywJdodZSG3B2SIZQTZmBi9wJiPUXWioIjh7j1ya
         JnMh5Rv9Ap/QzJQDQXG1x8HwsQ92lTRv/4ln8Vo1StPl4s4CSvXq3bZmdHl7jANIHTPt
         MgOgzVCSzc4MgjTWgS8zkx+e8N0Wo/mApBy98n4knaA8odwbLo7GDc3PWVYrNry/ub6K
         cg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VKMBlWNx4jK1iDVhpsaRZcvzkSOAxKFhhP9NDDoxkLA=;
        b=F1xf+CJYIHbOaYTaykAMZ+ysv6g50N/13LQEubt6oa4+bWzK7wcg0fDpUIVVd7CHDF
         TR8lJH/pmN0V6qWF+uYeFh1dzUIFbyCeeZwAuFT1P9P1cSab6Xquh2hE6/KkPnhGWwU/
         2xa+JPbQ4nCtM5kVFMfF74MJn+JCz/U981eETAaAzcozxkF/RqC1aso3E3wj3DssKtNB
         mLYJRPM+eedUNMWUht+yhLSwnKA3HGJuNle2yKrhWUCUQYOzGEQCgZ5z+SlefqfBC0he
         smRB+wkWqRdplDTtN0RN2QJS6NpOIzHxPRoDNg7pAivAF7oyABTs2RGET1cLnYnXp5Nd
         OE+g==
X-Gm-Message-State: AOAM531L49mCwWiPsd1D5IDXD09idEC9Lgn1k1s8NiXNvRMNmLPOcAlI
        zROLmIzIMRnDoygQg2H7HumyJPcZZaQ=
X-Google-Smtp-Source: ABdhPJxoyxmqX3mxfoFgGAjyblYLJ3fu4AUs1RNVx87TMDdvK+Ro/2u7tKzWPg4caY5UCaJlP+QbMSmje30=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f43:b0:1bc:7e5c:e024 with SMTP id
 pj3-20020a17090b4f4300b001bc7e5ce024mr26606pjb.0.1645813373353; Fri, 25 Feb
 2022 10:22:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 18:22:43 +0000
In-Reply-To: <20220225182248.3812651-1-seanjc@google.com>
Message-Id: <20220225182248.3812651-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v2 2/7] KVM: x86: Invoke kvm_mmu_unload() directly on
 CR4.PCIDE change
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
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

Replace a KVM_REQ_MMU_RELOAD request with a direct kvm_mmu_unload() call
when the guest's CR4.PCIDE changes.  This will allow tweaking the logic
of KVM_REQ_MMU_RELOAD to free only obsolete/invalid roots, which is the
historical intent of KVM_REQ_MMU_RELOAD.  The recent PCIDE behavior is
the only user of KVM_REQ_MMU_RELOAD that doesn't mark affected roots as
obsolete, needs to unconditionally unload the entire MMU, _and_ affects
only the current vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2157284d05b0..579b26ffc124 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1077,7 +1077,7 @@ void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned lon
 	 */
 	if (!tdp_enabled &&
 	    (cr4 & X86_CR4_PCIDE) && !(old_cr4 & X86_CR4_PCIDE))
-		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+		kvm_mmu_unload(vcpu);
 
 	/*
 	 * The TLB has to be flushed for all PCIDs if any of the following
-- 
2.35.1.574.g5d30c73bfb-goog

