Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5862247382D
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244041AbhLMW7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242437AbhLMW7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:23 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A34CC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:23 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id h17-20020aa79f51000000b0049473df362dso1596690pfr.12
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gtNPOCDR3DbNyqbZWIIfJnGYbH6wsvGmr+VRgwX1ZFs=;
        b=qYPn8QtLxWzWyCID5h01OZ8d2Y1qcV38gxv2flMXQFxiMNxN6TsNQ8OfSUMQBCyQWl
         RiAknD7NM0UJXk6myByqfXLAu0Rvgg+ZSCdZZ9qDolADAHtWs8pigBmiydN2gW7HSbkB
         Pa+7PKHKcVzkRZvSv67uR+M/nhpw3QsRGeMdpQ2WbD0TUlB6gPk8f6DUMWCejc/mAtIE
         K2jeqZ5DAZ5fzFV0vNglF3PEBrcMGVdjyb3utgMT5PeWpvgC5kEc5m4Y8BEsurB5hoxg
         SssVOsegmBN3lhSGkeoUzCnbkz6BUo3W2QAxdRvojWz4Ke8OK1BokVAvHUaKM03jR9oZ
         S6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gtNPOCDR3DbNyqbZWIIfJnGYbH6wsvGmr+VRgwX1ZFs=;
        b=bcs3XQ5p7KJFYfcJMW2SGLuz1jaBFYaiOPBPnWQaldyG0jcGJrnCHq0GpNLwo4aIPw
         lHnHqGb/QZNLNPN/QucHAJ/OK9p/P5XC5tI5HPI6R5IfgCN+cytSnwxqnc/URD+2TbmU
         eec/xY/w4/icxXfHAbBomIHBAGTUKeYRh7kqhkNd04mBD6O9H6/BNdwI5j9ZPkHwS/4m
         MhuqM5t3mAuXJWKfKp9DHlXojHSW2BXl/7+VbbEuL/0RXrKlcWMMUgQPDEcrgNhbZ0h6
         Jxo8Iu1xQ0KScs97mfQPV6X7db+I+95Jr5QrI4qc16hSgQHPbHb+54TgUK96U9npdpJs
         a2tw==
X-Gm-Message-State: AOAM530Cy36SpCPa+Da0S+NSOLiQOcsZuOTqVQAEiFu5pzA68zZrfzTJ
        S3ERwGr0tvR6teR7FSxgxyt0+So4az+93A==
X-Google-Smtp-Source: ABdhPJwsaCFlbJed4eBWy4RskyP0rehNDsaD+zpJgRfqOYjOstc3oQpb1kQb4lwXtEpFUY5vPQBNNgsqAXpNXQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:b7cb:b0:141:b33a:9589 with SMTP
 id v11-20020a170902b7cb00b00141b33a9589mr1182476plz.9.1639436362919; Mon, 13
 Dec 2021 14:59:22 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:06 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 01/13] KVM: x86/mmu: Rename rmap_write_protect to kvm_vcpu_write_protect_gfn
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rmap_write_protect is a poor name because we may not even touch the rmap
if the TDP MMU is in use. It is also confusing that rmap_write_protect
is not a simpler wrapper around __rmap_write_protect, since that is the
typical flow for functions with double-underscore names.

Rename it to kvm_vcpu_write_protect_gfn to convey that we are
write-protecting a specific gfn in the context of a vCPU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ccee4d17481..87c3135222b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1421,7 +1421,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	return write_protected;
 }
 
-static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
+static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
 
@@ -2024,7 +2024,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 		bool protected = false;
 
 		for_each_sp(pages, sp, parents, i)
-			protected |= rmap_write_protect(vcpu, sp->gfn);
+			protected |= kvm_vcpu_write_protect_gfn(vcpu, sp->gfn);
 
 		if (protected) {
 			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, true);
@@ -2149,7 +2149,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
 		account_shadowed(vcpu->kvm, sp);
-		if (level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
+		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
 	trace_kvm_mmu_get_page(sp, true);

base-commit: 1c10f4b4877ffaed602d12ff8cbbd5009e82c970
-- 
2.34.1.173.g76aa8bc2d0-goog

