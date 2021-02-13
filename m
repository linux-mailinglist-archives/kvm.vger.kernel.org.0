Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7782B31A93A
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 02:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhBMBGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 20:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbhBMBGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 20:06:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9FEC061788
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id j4so1537466ybt.23
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7xn8o/ghRMywDnWyKQGCThUSnsromvC8HnD8FrfD33c=;
        b=NaxGehxC6eKDL5N5xdIbYtGybwPPhOxUcFMlaZSmJKfznEczu8LIRrR0jsRAPhcFMl
         rueMQU4dp7BNgviiYYDXykntaOwGqotyzVt1qIDToSW3EpJrwvpa+G0aKPZzwOJQJoRO
         8j5tsr8Kb8sa82rZ8s2DlAo+QDaI/ysvPtV/zR5mYVGUIYwA19PYdLqwGWxYIE70FxNk
         ptN2mvq+RVorh/qW8fTW2ZHt5PVnOsKcJrEV4kO/heFpV26wgi4OJ4AJRqS5PboxlMIQ
         +y44T0Q4UP/bpD8fw4v5jjMAVflpOQ+1A14Qs+KuLuvMSxTXR+a693PGr9LxY/qWyrk5
         AAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7xn8o/ghRMywDnWyKQGCThUSnsromvC8HnD8FrfD33c=;
        b=uRoXVVKKwd6+uFWEv3nUnHnwH+hQbTcdh/BptSFNAq55MC2Ek/lk04XahBiz0ZnzAJ
         wfIGA7RZqwYIasOn3uZg3F0zeaM9sPZuoVp3TU2Ur6LgvoVPQPf768c2gf9FbOpvfWJx
         zSGR6YbVIXDrV42VNUSNjv1XlivD5H67fp3JKF7d/T9CYKcPrUzKutJExxnvYJtixDba
         YKGaKMfQjVhFHV7aX0VelcWSBhWcXcahH0nr8YsSmugTEQ36+Trh+GVCCFZA/BWYG3/c
         PkZcLVb300XLE2UthLvP+HDSKBc1pwj6Uv7iL1rXwrOQ4kxdQdp44z4DCZ2J10M9auQI
         9jGQ==
X-Gm-Message-State: AOAM530qaSTPr69duNayewEOZEPeup4QvCxFIUJfRN6e8wyr3AgZe+Wt
        8hIdEI8xpBec2zDJ6FqBHGxxWAC8mYs=
X-Google-Smtp-Source: ABdhPJw9DKV3wwTLHQatJSXRXGRXRz/fqBxe+ClysKcFHqFZMd63KZd0BaAnkNUg8z/cQhoe0q5RysY2az8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:4252:: with SMTP id p79mr7545032yba.492.1613178332046;
 Fri, 12 Feb 2021 17:05:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 17:05:11 -0800
In-Reply-To: <20210213010518.1682691-1-seanjc@google.com>
Message-Id: <20210213010518.1682691-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210213010518.1682691-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 2/9] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check CR3 for an invalid GPA even if the vCPU isn't in long mode.  For
bigger emulation flows, notably RSM, the vCPU mode may not be accurate
if CR0/CR4 are loaded after CR3.  For MOV CR3 and similar flows, the
caller is responsible for truncating the value.

Note, SMRAM.CR3 is read-only, so this is mostly a theoretical bug since
KVM will not have stored an illegal CR3 into SMRAM during SMI emulation.

Fixes: 660a5d517aaa ("KVM: x86: save/load state on SMM switch")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3fa140383f5d..72fd8d384df7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1073,10 +1073,15 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 0;
 	}
 
-	if (is_long_mode(vcpu) && kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	/*
+	 * Do not condition the GPA check on long mode, this helper is used to
+	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
+	 * the current vCPU mode is accurate.
+	 */
+	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
 		return 1;
-	else if (is_pae_paging(vcpu) &&
-		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+
+	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
-- 
2.30.0.478.g8a0d178c01-goog

