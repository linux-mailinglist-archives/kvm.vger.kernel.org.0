Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE03B0C5D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhFVSHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbhFVSGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:06:11 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88307C03C191
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:53 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id k18-20020ac847520000b029024ec8734412so105519qtp.4
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rUs+966f+CDP8VHde1NoisS+8ww2aUm1j0f8NYlZtqE=;
        b=Fl+C43avI6SiI4WTsJKZYi1XdqV8GHBrHMpvS/ibNPFWN1hA2wusCpPlf5pWbQwNDw
         Psp0XUxCPO55t2Li1b5nvreIrIP93otSJBs8gTJUr+VutLMuOwpKPAtySTDllyGVJT8t
         FPuoLdcXrBl4HE+I6cMmkY1VAuCMPuLr+VsMwb+VN3TZJKgG+35I0R2VXzCnM+mF+Xqe
         6dRRk5DMbiXVc5P3XTcgwYcTKRf62KVxhPyGhVJzGPlqcWvSyZW5Zb76Fw+//rzevQZT
         JAgk7Jn8YrWX9jDpPWk/HwZoi8XH7dWENAAJ5EI8mLPo1PYVDJkNPc0D3IqrgUNcvOnP
         uVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rUs+966f+CDP8VHde1NoisS+8ww2aUm1j0f8NYlZtqE=;
        b=hKnxeKSR5aEX/RFBSqq1/7J2NWQcOfMCokE+C7Sxy4coXv20InpYZ9sG0vv3Wr5R5y
         7YIE/wdHnZ3GWIGZDWtuqTOyn9be2FEd3MxSmmdNOQvCfU/68gUJhxLDUK4fbND96/rL
         frv3pfB+CSeTYu0r8xnGQDzVxAN8QcFtFBwK1bp7EXKmZX6zOshb70iSvgwXjafLXDum
         mSwIC5iNlwZUfbbJ9Vk+OCuRUwZ3bi/ZgZ0v36leTmqEu8Xhu8iG1P7zNfusR7operOS
         Ox56vApLmmbOxsfDc3rD9djzWh4tgZcgeGx5Ynqv07dFAk1ptcONYb5T5klh41Bmq+JX
         cARg==
X-Gm-Message-State: AOAM531TPQccHSwQTeGqwlxEtcv1f7Hl+28hdXpW/KmRKh08nIgiY8MS
        fT42VK7w3swk+B2/pSrAUWyjVzyjiu0=
X-Google-Smtp-Source: ABdhPJwg+s3kNjwriwzqMO3mMxkbDvv/AnG8NwcyEcukQUoufCwMdy4XzMqIuM/miw5QWP8OB3hoX3k4BOs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:c0d7:: with SMTP id c206mr5187941ybf.369.1624384792699;
 Tue, 22 Jun 2021 10:59:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:36 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-52-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 51/54] KVM: x86/mmu: Drop redundant rsvd bits reset for nested NPT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the extra reset of shadow_zero_bits in the nested NPT flow now
that shadow_mmu_init_context computes the correct level for nested NPT.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7849f53fd874..d4969ac98a4b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4693,12 +4693,6 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 
 	shadow_mmu_init_context(vcpu, context, &regs, new_role);
-
-	/*
-	 * Redo the shadow bits, the reset done by shadow_mmu_init_context()
-	 * (above) may use the wrong shadow_root_level.
-	 */
-	reset_shadow_zero_bits_mask(vcpu, context);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
-- 
2.32.0.288.g62a8d224e6-goog

