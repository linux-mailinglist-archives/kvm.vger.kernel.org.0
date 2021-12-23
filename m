Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5D547E96D
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350558AbhLWWZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350730AbhLWWY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:26 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAD3C0613A5
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id s7-20020a5b0447000000b005fb83901511so12382806ybp.11
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hi15fkGhTPSKWg6xnBWyGTdHInFiOYLMR2QZxH+BCyM=;
        b=tV8xL3tDgDWPtfKAnLLJ9aMprxvrR8pzIXGPXy65phS75CA+Zasdrj0BFZdR+hrAmp
         6qrsRJJoKEHZih5zMkJ8pMmdZtylmwvntAWefZogtB7YNZ00Aq5RT5hD/LB8LqFObeIU
         clcsY749fZf2Az67uWjoklCNEoXdL7WAO3pRiXSHe1L9kWTDz+ggbRbzHt4ipBdioI4G
         a7yJS+nlQYOo+Gvbmn3ZEYoLnwr0xB1XZ8VlNlcNuggHArJZy0j2V3xKhYFIGZbNaPkK
         g0sppACPwYYiVxnBwDuymuIbszW3wz7f61hooKdRHLCcYFWgaoaLWv/bw8aLkvbPT/eF
         4W5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hi15fkGhTPSKWg6xnBWyGTdHInFiOYLMR2QZxH+BCyM=;
        b=q+/QWDW5zuVlM6PPH1KLt6LXLKHejfz33nNMsfZvXO2HIu9lIxQCkBziwQBbHC83iO
         YCPplITKZ7tjQX9qpe+Fw35PcuDJG9zSiTA5o/UrTh1d8Jn2kZYEq4+XyNu6kUs6iz0Z
         xbRKQ8DlL2iLDOPFpt1bEqVI82Ji8taagnGCtvRbkZtGjcHb6pj+lgIHhGEPqhLbbKLI
         iy81uA4ANcb3hP8h+TVB2n+0lgsSybA0c/WZ7fQSkB2Nrk3y47NB+ev0ONQPWk8ykKIc
         96OlNAoTpv56qpCxPD5goUxW8TFhA8wqN7UBmcmHK7/+5hZFoVQ0R9prNobPEROlPjzq
         ZXaQ==
X-Gm-Message-State: AOAM532L4x0tajjEqGsfbl0xndqVULimpQDQkhfd9W3+lOM9CWqYS+qs
        wvC8bT8wYyXRiwxlbQBsc6huJiQXUKY=
X-Google-Smtp-Source: ABdhPJz7aPgmvGfRlYLct3l0udDKcXntDEZJSyDbK0UMyC+yQCMJ/vgjWw6/jUNmPpbrxEbhTjlkQc0soPY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:d4c:: with SMTP id 73mr5728847ybn.74.1640298250584;
 Thu, 23 Dec 2021 14:24:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:06 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 18/30] KVM: x86/mmu: Skip remote TLB flush when zapping all
 of TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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
index d23c2d42ad60..e9232ef2194e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -871,14 +871,15 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
-	bool flush = false;
 	int i;
 
+	/*
+	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
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
2.34.1.448.ga2b2bfdf31-goog

