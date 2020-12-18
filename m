Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923E42DDC6C
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 01:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgLRAdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 19:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbgLRAdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 19:33:14 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE48C0611C5
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:32:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e68so538374yba.7
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=w0e5jl4JlfaoIUtkUKYlv6RdfB1E6rKWxyRAVNknKcI=;
        b=rrNIVmC7+1psjMOcg4IZPyGbZYaAQcu7Ov+cn7CgIP/Pr87m6qWdWF8ZHCxBvOBmWR
         KdeYR4Lm2ncBIlPQM8SNjxvWw5Qt7cRCtmQnyy04s3V78iNsvxpvckS+V6DnE6KnyOP7
         9xpPbX0SIRymafrVEdAoXAdVpbDDeAVoWPpIDblGhvDoAxSoWM0c9VNr3s8MeGeJdwdZ
         KSIp31tsiA5F5B1DKE1FXRagF1IWtAHFIaxGKqXS+aH3a9O6/JBwnAIIxiZKGfj8Rd+6
         OWoStP+A16tEKzqA8NojNx9xCQNTExRc/NPFHT27xrQUb8ZdIcUXFTrlwU5O+fyhoDF1
         kA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=w0e5jl4JlfaoIUtkUKYlv6RdfB1E6rKWxyRAVNknKcI=;
        b=ZONsl0eyUlXGsiU7+Riupll/NDPkf1+8mmacNYrk9jyEwPWAAK9lK4tQQCIWAMerqg
         G0Tf7ddmDNQ8lNSgmEa/KOsgkwPrfslVmGfXjUJ/kcrxq1O1vTXXE6m94rv3o9XfXE4O
         DiOLaEhj1xko50Lh66yyHeyetvAerfHD7D48gg3MAZ8ROqikaAAG0cUDj19hPKrR9CoP
         fhov2PBlCR6ciggQLFrew2X6pmzaMI+Mzu2d3foku+XunVZPJBdC04QNpSarcOVXCFSS
         O3gFBRVZ7P37Gh7MBbPWUKLpzXfJJxYs4IfZ2vM1oIXYkVFD52FIiu/f1mpTjNGjEUKW
         bfYg==
X-Gm-Message-State: AOAM530uYY5LIjhvtiYAEJlnp4gEesT/ms0ZjQJAf5CoHyegnII1M1Aw
        fvk75OCrV3/6OOLGvOt1oVlIoEErSNk=
X-Google-Smtp-Source: ABdhPJzUXpyjv97hO5c5ID9uNDy7GodRHRxyycz5+CMS86gAEQRD7Z+XyKZntxMahFyoPm/l3UyTBjkvS0s=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:e6c2:: with SMTP id d185mr2559405ybh.304.1608251522057;
 Thu, 17 Dec 2020 16:32:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Dec 2020 16:31:39 -0800
In-Reply-To: <20201218003139.2167891-1-seanjc@google.com>
Message-Id: <20201218003139.2167891-5-seanjc@google.com>
Mime-Version: 1.0
References: <20201218003139.2167891-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH 4/4] KVM: x86/mmu: Optimize not-present/MMIO SPTE check in get_mmio_spte()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check only the terminal leaf for a "!PRESENT || MMIO" SPTE when looking
for reserved bits on valid, non-MMIO SPTEs.  The get_walk() helpers
terminate their walks if a not-present or MMIO SPTE is encountered, i.e.
the non-terminal SPTEs have already been verified to be regular SPTEs.
This eliminates an extra check-and-branch in a relatively hot loop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4798a4472066..769855f5f0a1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3511,7 +3511,7 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 	return leaf;
 }
 
-/* return true if reserved bit is detected on spte. */
+/* return true if reserved bit(s) are detected on a valid, non-MMIO SPTE. */
 static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
 	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
@@ -3534,11 +3534,20 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		return reserved;
 	}
 
+	*sptep = sptes[leaf];
+
+	/*
+	 * Skip reserved bits checks on the terminal leaf if it's not a valid
+	 * SPTE.  Note, this also (intentionally) skips MMIO SPTEs, which, by
+	 * design, always have reserved bits set.  The purpose of the checks is
+	 * to detect reserved bits on non-MMIO SPTEs. i.e. buggy SPTEs.
+	 */
+	if (!is_shadow_present_pte(sptes[leaf]))
+		leaf++;
+
 	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
-	for (level = root; level >= leaf; level--) {
-		if (!is_shadow_present_pte(sptes[level]))
-			break;
+	for (level = root; level >= leaf; level--)
 		/*
 		 * Use a bitwise-OR instead of a logical-OR to aggregate the
 		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
@@ -3546,7 +3555,6 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		 */
 		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level]) |
 			    __is_rsvd_bits_set(rsvd_check, sptes[level], level);
-	}
 
 	if (reserved) {
 		pr_err("%s: detect reserved bits on spte, addr 0x%llx, dump hierarchy:\n",
@@ -3556,8 +3564,6 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 			       sptes[level], level);
 	}
 
-	*sptep = sptes[leaf];
-
 	return reserved;
 }
 
-- 
2.29.2.684.gfbc64c5ab5-goog

