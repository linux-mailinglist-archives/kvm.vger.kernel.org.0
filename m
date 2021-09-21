Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE49F412AF4
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbhIUCCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbhIUB5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:04 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747C1C06B670
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:15 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id h16-20020a05621402f000b0037cc26a5659so93458676qvu.1
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TaOFnh9pXKvlFAgxCXG8pz2yPTn2EvG+MXmMc1YbXv8=;
        b=XANYy4kQA/dxnSdwpOjKZufPVeEHBPsLJR8SQwiKtMc/hrrjoE7YTGFtL8MtYJjzkT
         TpYG7RtwfHAcomNdxfIF7ecGtQZ4DOxCFVk1woATwZHhrJKx5O6emgjxNwblBdxfE8ms
         Qpss2GgcvkyBWXNIyQNnNlUEY1GGfmd2r3usj31xYg6GmBvUNLBEWY+Jq+HWQDOc6J3k
         5XtL7dVMZHHKoCt0nnpNLCnh2cahVJfhWeAY60+hwmOW2eOTMEvoPb3YFTqSNqPCRuIL
         PWobg/OwORqfRog2zuhRdv2acJCAICDWYwqN3ANTcGt++s3JAAAibPprfkcwBQNESkJQ
         wcIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TaOFnh9pXKvlFAgxCXG8pz2yPTn2EvG+MXmMc1YbXv8=;
        b=ivxeF7mB6lncthr6DroI/hur+O8KRm0sq9eDT1wuFmS4D8BNJuyfg7nVAbphKUf4uS
         4SBz3c8aZpOrBZbNGl+jzYjdhBREBxJbdtiLDTTlmgQWTQyRuZ42Fs0Z5EtoMGxEXKvB
         RRO8BfDGGqzWx+Ra6gX/ES7WH8JIIwwScz2txEhHhwlsSY9r1fc4026R1jsrrlsuqUII
         dfZGBh0iHDDlSRT5p6X+Sj4GwuJ8rJs2rUqrGt7B4APN3rmG90YUqL8tI1SttmKYEI4V
         ClXq/7kqNakiJTwYgtNseDCoXvedgiELvbYVHS6twGI+emLrComa6/yXdfYUytl7yFxq
         Mr6g==
X-Gm-Message-State: AOAM530xsBkmVpvMeprlVQuva8ss+vvgvT4pVJe26qCWPy8ybFNGGJ/R
        XVX+DLU4me0kVhSp+BOW6KW3meRDc0w=
X-Google-Smtp-Source: ABdhPJxGRjzoPJfx96khcwuanlK/hcJNUg9koX7RsTp6tA76rmSNFpnq0dcsSmvKzzEtOotVi88bp//wcH0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:ad4:4741:: with SMTP id c1mr14047272qvx.7.1632182594679;
 Mon, 20 Sep 2021 17:03:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:02:57 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 04/10] KVM: x86: Remove defunct setting of CR0.ET for
 guests during vCPU create
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop code to set CR0.ET for the guest during initialization of the guest
FPU.  The code was added as a misguided bug fix by commit 380102c8e431
("KVM Set the ET flag in CR0 after initializing FX") to resolve an issue
where vcpu->cr0 (now vcpu->arch.cr0) was not correctly initialized on SVM
systems.  While init_vmcb() did set CR0.ET, it only did so in the VMCB,
and subtly did not update vcpu->cr0.  Stuffing CR0.ET worked around the
immediate problem, but did not fix the real bug of vcpu->cr0 and the VMCB
being out of sync.  That underlying bug was eventually remedied by commit
18fa000ae453 ("KVM: SVM: Reset cr0 properly on vcpu reset").

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab907a0b9eeb..e0bff5473813 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10628,8 +10628,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
 	 * Ensure guest xcr0 is valid for loading
 	 */
 	vcpu->arch.xcr0 = XFEATURE_MASK_FP;
-
-	vcpu->arch.cr0 |= X86_CR0_ET;
 }
 
 void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
-- 
2.33.0.464.g1972c5931b-goog

