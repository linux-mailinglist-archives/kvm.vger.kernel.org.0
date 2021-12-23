Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B2A47E95C
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350720AbhLWWYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350513AbhLWWX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:59 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B67C061757
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:59 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id z13-20020a63e10d000000b0033b165097ccso3881866pgh.6
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/ZFHgDnOl20L+13r6dn56W2Dom/tt9hnv2FmIwxRFwM=;
        b=c7aAabUUEF7Z0aGr0vLvyy8IDuhevj0wCx5ERJGhthQ2s6qPdaPwqBwnFLd2+hCpU1
         ajO/w2PpD2ZTOFjStPEcYbebnJqx3MrwhY342jfEWaFCHweuJHErV77v9/x0bHrNitbI
         4EYWtrsNTOyCbefcd9QpqyApzGr+VQcV+rFNM4VtRHaTewni+4jMqz9B2BiSHJpZ6Ur0
         fliWu8+4/bS0dJlA3tA7Uf1ADlNcXuuWy3PbWUmzxXcfKHhsLBcqHi6edjz7yM9alCx0
         88AycimElIkDw7Aa2zdt0E5F47ngPmKgIKVxEEcOBwzooU48hif2xF7sa89GTrTyo1D+
         TXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/ZFHgDnOl20L+13r6dn56W2Dom/tt9hnv2FmIwxRFwM=;
        b=37e7DZXVp71wj+vCS1xgJfgQcpObbEtRxNGY91KZlOtWiBMI+0IYHTIrrEwbEyLtaV
         YlRQQZYsQC0W4JFV51nUd1Yr3m8DHiBPXPW7S8vMoo8MZopwvYTLhP8WKqnuGPuNo8OO
         XNaQDYAwHd+1CiIk7E5LuXfrhFjRrhE/X3HxdYwJnePOXrCnKrhvKswbCYaIBJUEmIqO
         3V87vRiz9exWtzdd1IDdWCgTQgUzybqql6hOAlxqJ3ckzEFH9sZWmkcgGovnNzZ15qi9
         bzPTqP4HooeQgdXeIilpJMLCcaUzFUt3l/CSGcPH61DiWbqi17ablaFkJP1mVKFRef+G
         wP7Q==
X-Gm-Message-State: AOAM530iH/w46+Wv29hs6bpkVWpopRJuM/s+Gq7li8HAUi35Bzd6v1VR
        dnQWEUnSrIzW8rxtf4YgHjIKn0v+5Qc=
X-Google-Smtp-Source: ABdhPJye2bSrwx441l0MON1QuD1KSBcBGpRHORrrKCjLQRY2tJ5LQ2b+BT+QRa723WlukEfY87wnLs+P5HM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2391:b0:4a2:cb64:2e01 with SMTP id
 f17-20020a056a00239100b004a2cb642e01mr4191029pfc.45.1640298238813; Thu, 23
 Dec 2021 14:23:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:59 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-12-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 11/30] KVM: x86/mmu: Check for !leaf=>leaf, not PFN change,
 in TDP MMU SP removal
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

Look for a !leaf=>leaf conversion instead of a PFN change when checking
if a SPTE change removed a TDP MMU shadow page.  Convert the PFN check
into a WARN, as KVM should never change the PFN of a shadow page (except
when its being zapped or replaced).

From a purely theoretical perspective, it's not illegal to replace a SP
with a hugepage pointing at the same PFN.  In practice, it's impossible
as that would require mapping guest memory overtop a kernel-allocated SP.
Either way, the check is odd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3b13249bbbe1..05f35541ff2f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -518,9 +518,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
-	 * the paging structure.
+	 * the paging structure.  Note the WARN on the PFN changing without the
+	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
+	 * pages are kernel allocations and should never be migrated.
 	 */
-	if (was_present && !was_leaf && (pfn_changed || !is_present))
+	if (was_present && !was_leaf &&
+	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_tdp_mmu_page(kvm,
 				spte_to_child_pt(old_spte, level), shared);
 }
-- 
2.34.1.448.ga2b2bfdf31-goog

