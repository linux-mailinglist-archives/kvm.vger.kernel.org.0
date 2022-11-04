Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA26618D82
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 02:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiKDBLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 21:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiKDBLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 21:11:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD83C2317E
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 18:11:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36bf9c132f9so33588997b3.8
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 18:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rRZNXnAdmysY3G3Cnao0EYe4NJ/aofq02IxKvLoVlH8=;
        b=TAcPtBFW9pu2h04dOJP3ktSg/vWQP253G1X1Mp4rOUqMYppLxgwjzRSAU2BEPxrBuk
         D79mj3W8lxGP+YQF0QWhctr5CRqqVY/jWBFNL8M8Q2F0S5joY/Upr0pYFRzgCp5c0fCq
         6zS9kPogeqSemrBgnSVyGQ/LvDNYHqaqXUC6w/hFbcgo1GgqT6J/ItAKbEN0OV8T5AG6
         kD6Pijo34xCrWzCSI55GvKl7V03XxC4j8dDpqFXv8Doc81ApggRPbcolAirWEmENC1KF
         rwI5TdfslMbJDhiRERIa3DbqamzXk1McZwEGIi6poQKuJXyL46MtWR88xgYeEhD6ryAf
         WwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rRZNXnAdmysY3G3Cnao0EYe4NJ/aofq02IxKvLoVlH8=;
        b=6tpKF1cMSF8WDIlxFmK9Q1rHVaeSDgT+rP8sBifDkkbJvpduVUVs+vCFQveOo6cqMM
         osQAQ5gsbD5b1NLr3t54oXA7kZ3bAVcnVAGe6I0lwinG0SBGdOJjlMeNmphx1zVvxoqS
         ExJIQropAWmVRxvAU4qYXNLpi8sdXivpBwlnsB03mim+QENZeEiMav3nvw6r9SH2MtiS
         ocWbyw7tBnJOzMORp75JXyhr0y2SmQyHfu/axPtijL6ubDx78FgTjbhzPYJCdvsg+UsE
         BTF+4DGFdIHoA4I9K5ZOi+/Q1mKNWibst1jpidQL5qtlRsLUlWOd0N3pWlMI6VGTa8QG
         P+aw==
X-Gm-Message-State: ACrzQf0PvAk1qjrmZAQJsfQF89RUKterTLZIb2Ul0q3jtHDz855H9V3Q
        BrGXVGjC3wJf/SqlD/fq7ZftEig=
X-Google-Smtp-Source: AMsMyM7AEG/PHRE/PAJfIvirZi/8MBo+6gmKUXgAfN1z2bLvV4rA8HnctJ86FJNToEWiHsMK90jh8VM=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a05:6902:202:b0:6b5:2297:58f2 with SMTP id
 j2-20020a056902020200b006b5229758f2mr32536668ybs.205.1667524274233; Thu, 03
 Nov 2022 18:11:14 -0700 (PDT)
Date:   Thu,  3 Nov 2022 18:10:39 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-7-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 6/8] KVM: arm64: unify the tests for VMAs in memslots when
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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fa2c85b93149..9ff9a271cf01 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1108,6 +1108,19 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
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
@@ -1284,9 +1297,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1730,12 +1742,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
2.38.1.431.g37b22c650d-goog

