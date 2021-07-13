Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED7C3C74AC
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhGMQgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbhGMQgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8084C0613EE
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o12-20020a5b050c0000b02904f4a117bd74so27727775ybp.17
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Yi6bDLPGCrbqS09Vb1Q1YxAsIO5UfWIqGpJKeQgB6SM=;
        b=IVnOLNaL2eWedum/MsETC2COPdFjr41LCUU0dWy0VQ24GHK+90gGUlHlDQeoU8HW1d
         mmZ1yZqe9nXwNxMCwWOpj3gCIcVAat5HY7uNR5tiFwITBNaq+DXV9yOhggr1MdNKUb/g
         QrqZ1ZNJHkRub0g1yBYxgv51Da5cgu4KZ4YESMWLgP8GrcT3ARqrjmmwA0JbSFfCbLFM
         026R2zcJndSlaBgezEKyQObEjkqDmPNqUxBbPJAwDunR+PPzo8UceXVLjBwkpicIxDvF
         1J5/mCRFFkGEHBcITYmPmDxZEtL2Ov1hnEOlpQd5OBFvhuVAP7y35LmQTsxHT74r0uUB
         +61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Yi6bDLPGCrbqS09Vb1Q1YxAsIO5UfWIqGpJKeQgB6SM=;
        b=WC12WViW9pJ/5Y974Pb90CMFvzdCFi/2zwxym5e22Lll+IjR4xfzkVSUd8FqLmjJTy
         z1Siuhd9xAa9MLemllNdzaB5q9xXAdMFeEKyCZgg+exyeHhvAK3Jhv/ZvmRPLea7TCoc
         RijPxVa232vGX8f3kNyyFeHieCuMC7MLkqZdICOMubJRx34Hu5d4lnDgcGskoT2OxxAs
         WeSmZBcCrY61S0zumis0et1EXR0KPLTU9Riw829GH4W/taDlc+OC5NL7gPRsYgUCDt1j
         5VxT0e0ljmqlmdfVM/DfLDUPscYfmcHzXoDlF/CSaVUP48OrIjfECpSs1JQi03Ay8aCL
         foKQ==
X-Gm-Message-State: AOAM532PlGR7op4g7UClGxce007WGyGZvwZiyc4u4yRyvTtNmjfu59sO
        QTIIaFI6hJmUCTl+/JYlDnXmm+LdoOI=
X-Google-Smtp-Source: ABdhPJwBGiKmMkpMUzwxlAmBPHwwMkjSyv361z6WDe1EupMy+LnGBNRjp8Wby34ZiMJVsA4w5V0A1rK4PJs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:550:: with SMTP id 77mr7152673ybf.452.1626194030009;
 Tue, 13 Jul 2021 09:33:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:46 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 08/46] KVM: SVM: Drop explicit MMU reset at RESET/INIT
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

Drop an explicit MMU reset in SVM's vCPU RESET/INIT flow now that the
common x86 path correctly handles conditional MMU resets, e.g. if INIT
arrives while the vCPU is in 64-bit mode.

This reverts commit ebae871a509d ("kvm: svm: reset mmu on VCPU reset").

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7da214660c64..44248548be7d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1274,7 +1274,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * It also updates the guest-visible cr0 value.
 	 */
 	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
-	kvm_mmu_reset_context(vcpu);
 
 	save->cr4 = X86_CR4_PAE;
 
-- 
2.32.0.93.g670b81a890-goog

