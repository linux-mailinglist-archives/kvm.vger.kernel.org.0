Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88782457B75
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhKTEzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbhKTEyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:47 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B87C061757
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:29 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id n6-20020a17090a670600b001a9647fd1aaso7795554pjj.1
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AYx9sJvbwxB0sjhZtd5DFNw6mN6V1huadyjHwAl8qyw=;
        b=f+RKeHOw+lES1XSli4Wpoaxhwl+WeKvn1k9OMhsgTilJMSFmV3iHgjFoLtCpkxl3WE
         V5bBEh+2u7V5C527aOhUlnyV1RufARW1OjFiKJdmn7ScVYBEJrrfrC6kcsD9XC9yYoG2
         t3OnPoUfRnBKevyG03GekYE/qSYf1buEGsap0wIQF5akx9JOuKFyvJxNVnVsWyWVI1iT
         N2ry8L7wQOWzWU7135htytqvIu0pSawNjiCtQso5UHn7DLF/XAEqXCkdnc+YHbzHV3N7
         0ExIfdUX6xlJ4XqGizNqYDQxrvngZkem6nSWQ4K/LjWy7PlS09g0nX/4c4GKhh6XZHpM
         woxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AYx9sJvbwxB0sjhZtd5DFNw6mN6V1huadyjHwAl8qyw=;
        b=neBTuQ0tSMc08gygeh7sethh01j+BX3OZ/f/29L9oYj3nCTauk6Bza6BlL4mOaWGdX
         vaJvGiEBeLq4Q2BS+ExOPIQUa82K0U8ouC2wQmY0m0A2xt5nIa+1ocr88oC0iUTd0sln
         aEIkjFG+XZ9N1HfTnM36OdUAXWFKxFHtsyrBdipicjwsj67C3JXoC4XVmfHw2SW4hDjN
         4Sw5yppnvVfr+ym67xlHuYD048uidXHIbPa+ZvGxHkFfdsXS67L55TstquKz6WBHkJF4
         ejf0fCVdGSyvF2d411fyjg5TfJuYvr8QBCrCEOIIILBo1Wv3dosc8NiEGqZM/rBu/J3Y
         XmwA==
X-Gm-Message-State: AOAM531uiwPnQdUnHVIFUkff1gkvToR27YkBeCABEAGGYaVkqBjodpGz
        f0WDnrbN/Mzway/MemO69F5HHYEn1F4=
X-Google-Smtp-Source: ABdhPJwaSJWhoYJY/fMx/Lp60XbTR6Qc8p1gEC2NAp15y6/XV+Y5Mcb3KxEIwLy8gZ54AMTzhL+9ZdZc1Gc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:63c1:: with SMTP id x184mr20729341pgb.401.1637383888887;
 Fri, 19 Nov 2021 20:51:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:40 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 22/28] KVM: x86/mmu: Skip remote TLB flush when zapping all of
 TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't flush the TLBs when zapping all TDP MMU pages, as the only time KVM
uses the slow version of "zap everything" is when the VM is being
destroyed or the owning mm has exited.  In either case, KVM_RUN is
unreachable for the VM, i.e. the guest TLB entries cannot be consumed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 31fb622249e5..e5401f0efe8e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -888,14 +888,15 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
-	bool flush = false;
 	int i;
 
+	/*
+	 * A TLB flush is unnecessary, KVM's zap everything if and only the VM
+	 * is being destroyed or the userspace VMM has exited.  In both cases,
+	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
+	 */
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
 }
 
 /*
-- 
2.34.0.rc2.393.gf8c9666880-goog

