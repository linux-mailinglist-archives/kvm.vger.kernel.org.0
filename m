Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9755F58F32D
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiHJTbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiHJTa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:30:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFA674E21
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso7762564pjh.6
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=ISyf//eKqE0iV9Jad3fzzOnB3Q21JHgqLZOFoVPjKMI=;
        b=Rpt4p2M0H/10ExEF5hENxTIqXeEe2mpTkCUkrm5mtB5m2DgJTHM9DgTYaYdVWE1t70
         Ibz1PyMQMU+JQzBpHh8y77NSSLzNoDgdyNwu4bKW/LeONh1O27Fnef3UG+NqKSxvPOuI
         7K5fxKaOkDXvsux3jkaLsMXNVuVmWuNRkWnfsR63ijxZRE5cHQ/nyYoJ1XnGvlI58xWk
         kt3Niw42xbj0USCsk5HkRyo8Ah6LIVH1L+LqjR6TfQ2sF15B6Vu3JZpCDOCHmf3+oBSB
         JHz7f6lZgjxsPK+fZKVWj/4jKrUcP23UzygWOTRSqFOKGgDwvFbc7eOYYLCGaghgxPf+
         gcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ISyf//eKqE0iV9Jad3fzzOnB3Q21JHgqLZOFoVPjKMI=;
        b=bwvuZYt0Y40+UdBangNnzM7yRk4vgu8PxS2yX23QWqfOwhRDU9+OAMc0OKVfWy3By0
         whp4w2GyZQ3+rKal+zEtB6CYOdA4otsn4U7OUMBSeB/xM3j69IT1j4Lekx/GF3+8jaV3
         SPf6mt7ZHmvWZzQfcKcM40LYhr3u1O/WqX+NgKAPLdOC8S865inQHG8KzNw7TsQl9fT0
         HvnfOmhgNkxw+0NczoKfeWppPDCBRWV2hb3OomEgD6EKiea/GJFM4exmYpcm1Yb/VnpF
         usi21QyWEMqcxnqTWgbs4gEnEnQ8B+zJeLBlgxl3PR8WBIfjGs8f92q/hEdRMzYYidou
         GPAw==
X-Gm-Message-State: ACgBeo0I4OlNa3ZP+xx8+SIIxpQcUXBNYd1rGxLOZOgx1EBb59VB3Jlc
        QnIntY5L43MzyCBIrTkiFSXPUCM=
X-Google-Smtp-Source: AA6agR4gQa4UYbSdbQyWQV6Bwq7wnb+1/ubEBVorjvVta/rIBUuFcRv4Qi6HBrOfdJr722FFyo+zG5I=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a17:902:d54c:b0:170:9ba1:f38f with SMTP id
 z12-20020a170902d54c00b001709ba1f38fmr17494564plf.32.1660159850191; Wed, 10
 Aug 2022 12:30:50 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:30:31 -0700
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Message-Id: <20220810193033.1090251-6-pcc@google.com>
Mime-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 5/7] KVM: arm64: unify the tests for VMAs in memslots when
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
2.37.1.559.g78731f0fdb-goog

