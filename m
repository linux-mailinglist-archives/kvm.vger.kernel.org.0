Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5A57D826
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 03:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiGVBvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 21:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiGVBvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 21:51:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EDF95C3F
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l6-20020a25bf86000000b00668c915a3f2so2598530ybk.4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GyooXJlVj4syrTh57O3ydwA+ijcUnjC6dc1fY8noLps=;
        b=YexvIvXmjzIiWZCe0Sk5hw56SQOQK5rCE+GIuFsEHy72Q9kS5JT4M+nBTT7s4wZuAm
         f5dgcRlU/elvPbUhNMcjoONhJPNZbqP9Gx+yqVuAkYgt2j7WBfrWdp2nvpa9il5ZAGcY
         uhOTucAWiXLVs4DCEzbfoEsOlh9g8RMGTfBO6KSXT0jKWgr6d5G6OLdAD8JdvWJd/cAT
         MqdldRcm0mVOGz7Jp90nD+TwbpLxHOWkqwPMedVjuKgHX10c/bwtjdG0JAy5utJ3aJVJ
         2732cZqnk/H+d5WXLQ9+UDeSK1u0VXrOzTEJF49vbxTmV8DJAyfAaRzc8qK5XqgH4gyK
         Xjkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GyooXJlVj4syrTh57O3ydwA+ijcUnjC6dc1fY8noLps=;
        b=Pmmlq+v2Ww26YGZBqdIFfR9ynhQDIVEK+5lXmVYrWsyyFBru5Cir+BRk9I6qRaXbH/
         kG5vwZZIuPkX8jbUgBtRk7OkcYnBVZ1Y2BM2sXJow34IRgA3E7dns590Y+AtR1j+EIi5
         XVHjaUweUmeK3LXVmBpOBtaH5LfYkvJ2Aauy25tTpO/3cZDNe8WI57vB0T0u9g58+hRK
         YuvT6y6cRwBPjuqeSXE6zvHp/U4XBlIufmBvN1PmgP4Q3SngZO+SqzG8oLAdQzqBNOOy
         rUQ97kCu5xoXqWNreE43TstHxoTN148u48tNl/ehRn5i5UuicXpzjCM4fHbROw2M4FwS
         /ycg==
X-Gm-Message-State: AJIora+fnwIEBiC5UtgDA8k68w3BtdVx/QC6SiRpnl4aTCZyg0JA6Ry4
        oX+JkXBkG11x3bUt6OIwvbu2V+Y=
X-Google-Smtp-Source: AGRyM1us6MLr1PJ/EHpCUXmwTwiBBgpEPArK9WyBoVdM3Qtak3DgE3vimbQIEBEpi09h87XBzW/1l2Y=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a25:8404:0:b0:66e:fe43:4f93 with SMTP id
 u4-20020a258404000000b0066efe434f93mr1180184ybk.284.1658454667788; Thu, 21
 Jul 2022 18:51:07 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:50:31 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-6-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 5/7] KVM: arm64: unify the tests for VMAs in memslots when
 MTE is enabled
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously we allowed creating a memslot containing a private mapping that
was not VM_MTE_ALLOWED, but would later reject KVM_RUN with -EFAULT. Now
we reject the memory region at memslot creation time.

Since this is a minor tweak to the ABI (a VMM that created one of
these memslots would fail later anyway), no VMM to my knowledge has
MTE support yet, and the hardware with the necessary features is not
generally available, we can probably make this ABI change at this point.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 750a69a97994..d54be80e31dd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1073,6 +1073,19 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	}
 }
 
+static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
+{
+	/*
+	 * VM_SHARED mappings are not allowed with MTE to avoid races
+	 * when updating the PG_mte_tagged page flag, see
+	 * sanitise_mte_tags for more details.
+	 */
+	if (vma->vm_flags & VM_SHARED)
+		return false;
+
+	return vma->vm_flags & VM_MTE_ALLOWED;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1249,9 +1262,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
-		if ((vma->vm_flags & VM_MTE_ALLOWED) &&
-		    !(vma->vm_flags & VM_SHARED)) {
+		/* Check the VMM hasn't introduced a new disallowed VMA */
+		if (kvm_vma_mte_allowed(vma)) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
 			ret = -EFAULT;
@@ -1695,12 +1707,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		/*
-		 * VM_SHARED mappings are not allowed with MTE to avoid races
-		 * when updating the PG_mte_tagged page flag, see
-		 * sanitise_mte_tags for more details.
-		 */
-		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED) {
+		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.37.1.359.gd136c6c3e2-goog

