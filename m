Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E079A369DF7
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244359AbhDXAsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244173AbhDXAsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:48:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D11C061346
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so14639571ybn.21
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Jt+QADH41QWXYhePdcqYrOCInHjfAIgUcTFitJT85II=;
        b=VKCD32tNE1gQlT8ZBHmOFQRMkonRpIDU2w8ZcZmMWG/7LY6e4AiT3pguQltFHx+cnZ
         Q1K5jdZDD7ObiUHwqs3LK8yW6Lm8azAWM8On3E0EOePkJjeVIpQbzl2NYdOA5DtnD0uE
         /tJeuBOOcMgrXvAXgj70Gx2Raox3rxVrhxzxWGsTAydHbW/6kYjdTuiuVSQIZHDBcG7c
         AOHXWD+1aSRrWePdu/il24DPE9Vd7L+uPsF+KwVKzddyZzCGn6HO8wm66J0kx3dIBVHX
         Y3KTVdZKSBede+UunwTlNnFwh9QSaXzNjWKYCayzmuVdBWs22HkiQ5fltixxunX2zl7w
         Zy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Jt+QADH41QWXYhePdcqYrOCInHjfAIgUcTFitJT85II=;
        b=ZeJ0dNZE4y/hXkNUsPgFimK3JiPrghmnwfgngO/SqGERM1hAjm39LoQW8TILXC3ZEE
         XZTQxJX7m2CiH1ZAAosxH9fZvLI34edTpLnoqwb4WyMy0Odd3Je+wqx//VUXTcK1DT9u
         kParI7jSmKywkSgbFL7FUtuXcPfz5Ugd3ZcVr3cgf4cs4GH2v3EB2A21yTIn0snIMEDT
         1EHCK0mu383VcUsqRIJYxUC9C/S/C0Sy3Ur4zyamDuLYoleGbW9k3eHPqsXaOf13eOg/
         JyNI7tnpvHtTnn2wqdIPZXJ839FVjkHXZ/1P3HiX9IiiyRJvNnT4ezpOsFnLChFmiMnB
         6MNg==
X-Gm-Message-State: AOAM5322eafN/jQB8YBB2qve3k46dpkSZSQ620YUG0zIZ6hSbAKGnGbS
        sQ/e0BffPWEmdqQBiEbRK1QyH0DxAOI=
X-Google-Smtp-Source: ABdhPJwcTnmC6X0oWuujcgYVmlJxsbfvu4nwR2aDmxuh3bzRd3SWRELPe0JgJ/qSwHhiHda4+AZA0+IYfiQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:6f85:: with SMTP id k127mr10032078ybc.270.1619225237656;
 Fri, 23 Apr 2021 17:47:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:10 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 08/43] KVM: SVM: Drop explicit MMU reset at RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop an explicit MMU reset in SVM's vCPU RESET/INIT flow now that the
common x86 path correctly handles conditional MMU resets, e.g. if INIT
arrives while the vCPU is in 64-bit mode.

This reverts commit ebae871a509d ("kvm: svm: reset mmu on VCPU reset").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4d7720ce42f..fbea2f45de9a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1216,7 +1216,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * It also updates the guest-visible cr0 value.
 	 */
 	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
-	kvm_mmu_reset_context(vcpu);
 
 	save->cr4 = X86_CR4_PAE;
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

