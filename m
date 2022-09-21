Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CAE5BF513
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiIUDxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiIUDxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:53:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD742A72C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-34558a60c39so41259617b3.16
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date;
        bh=gA2O8oSq7e+d9nyvptw2rqsk9DDWzgsNC9HG6nZ9ojk=;
        b=XIO6ctUJSy+0azvt2pjBnryBUWNbF6hif5gqbPYYTgs6hWqcNPUhpEe9lgmOAUb5lK
         FIEztD6adqYqFeEvBypKlXChVdd8QisgiiSfY+985vqxZPImM0ex7t6ynV1Q5O6tezgt
         NDwiBirb38U/1dEirAo7Y3vns06/c4B8HudINdNTwx88KQNxgx1TmYWG0eQQg8lejZAZ
         /bU52MCOnyPXF6tZePuOkxwp5FG/90ihIjaJ57kWjHQ5T3L7z6Q1dLQcob1PqehxKNrc
         0m9GKeaaZ/knEEBovy0cI9BPTzeBrDuufHMEvKZD7vIi8VDKzbEhuAnwKtKy8Vj4b9pN
         sirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=gA2O8oSq7e+d9nyvptw2rqsk9DDWzgsNC9HG6nZ9ojk=;
        b=5gNhxtI/lvnJ69q3xAhTO8WGL2aYGpD/mAkUm+Kd0ZW4uImcNB9iMde4V6zgH91Fo/
         UnIJl9csy0box2k7V2EmcygWOe1fXmkQaXrYQBFSo+mkMVZYokwSnw5YtC5YAHtzeTNr
         9E5e6czKJbIuA30RgDMkf+XW6UA33gfbf6+B2benrz1YzRiOp8+nh7LWLhImfl1b+EF5
         jYks3hskMomS+os/ckq8UrtsFOSn6tuALO7SM+8uDkEf9ccMTnE9vTBm4uswCILSYFJY
         Gj3Fgu5eRrW7+ECw8lzwnYIpsTxwm+dWm79cr5jSeaCELPHrqRBwDJCbea16I+BQUC8W
         VyGw==
X-Gm-Message-State: ACrzQf1GFSk+w2K6idKN2qZbaSTTEaSdarRpgoG5AXM97y3LVUqo0rbo
        4BkQ4IMXimcLQEzgWVrU0eVEOA4=
X-Google-Smtp-Source: AMsMyM70KZGF5iTWN4vyFkxGmYL4qy9cjP2UuKMDiQgL9O5HmyDhF0srIJOhVM93rWn1O+AMl83PUqU=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a05:690c:823:b0:349:bc6c:630c with SMTP id
 by3-20020a05690c082300b00349bc6c630cmr21877503ywb.223.1663732386243; Tue, 20
 Sep 2022 20:53:06 -0700 (PDT)
Date:   Tue, 20 Sep 2022 20:51:38 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-7-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 6/8] KVM: arm64: unify the tests for VMAs in memslots when
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
index bebfd1e0bbf0..e34fbabd8b93 100644
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
2.37.3.968.ga6b4b080e4-goog

