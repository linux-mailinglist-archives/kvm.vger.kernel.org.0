Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FD56E0108
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjDLVfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjDLVfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48ADF7D9E
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f810e01f5so49505157b3.0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335333; x=1683927333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g4meCJ11bu24h/cx6LqrB3qAGYM0pv712osrkf0fzPk=;
        b=ksc3Uo2kb7fia25zCArzbWloYH/nh04oxzOH/JXw50ehdelb83OV7185J0dcX5CTUl
         SGpdnP8yVtEWCbN+YKQ1yw8N8CQUKFw5GeaZzxeaIm8mtKU8dAgwpAVgKJavw0O/BKRr
         aANPAgurlfqKrwO6NGZX4gGPSuyn7eKZfTRk38L/4yupoynBZqCFaqDAjRlkDb1iUMh5
         pC0nfYaS0kiBXS6IZr2a1LpJBUYMVii2A3gBADS7dpYAr1eW2Ktxxidq4/+TMOHkiSL7
         o8XlEyDWSf+taexDIlKlaYBbFOU+RE/VhORCsyo31dF0tN3prUOBff0E7D5keRnnyYrE
         Mj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335333; x=1683927333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4meCJ11bu24h/cx6LqrB3qAGYM0pv712osrkf0fzPk=;
        b=eq6Ojvku4F838nihZUO5K/9VowwAmrbr0BCi6kW+pvGvBjsc3nWLCWCAn5m51Jt7nJ
         txB1SXL5PiE3exJqmkPy6u7HBfLaO2jB/3CRYmxrykQFK70gz4sXszoWadB9j1Uss3BB
         FKcIQ58Eshqj4t7gUpILZACgtHaDmjA3oDQPI3ofy6gKIPyLwoXkKuGjfBHFXU8SlbR1
         I/bjoGdQ2rm8r89nxCwwcpGVHgyW08PE8vj1o3Zjf/gtPfHSomhI2JgQjN2bLMW81aXP
         /GLJvuEBh45gkz64bPQdyrfflBV0uWBLBFXlhB92s7LOBGqUdmqcMN5qpim3zMTQI9xV
         ZWOw==
X-Gm-Message-State: AAQBX9e+oYUpTo3OyogQYNiAIg8RvzfyLYjNr2g1qw0WDceMjQSXkEle
        qvqbwxweBMwT5KHZyTrGJAGimoF6R0tzuw==
X-Google-Smtp-Source: AKy350ZG6iLC4X3Y7S8xfkDc/hZ3/74579TfJlfN5A+jNG8WvNeg+IGrAA5URu61LfHolsG/pk2OemadO/dyGw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:c94d:0:b0:54b:fd28:c5ff with SMTP id
 c13-20020a81c94d000000b0054bfd28c5ffmr2814728ywl.3.1681335333086; Wed, 12 Apr
 2023 14:35:33 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:35:08 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-21-amoorthy@google.com>
Subject: [PATCH v3 20/22] KVM: arm64: Implement KVM_CAP_ABSENT_MAPPING_FAULT
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Return -EFAULT from user_mem_abort when the memslot flag is enabled and
fast GUP fails to find a present mapping for the page.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 11 +++++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 452bbca800b15..47f728701aca4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7712,7 +7712,7 @@ reported to the maintainers.
 7.35 KVM_CAP_ABSENT_MAPPING_FAULT
 ---------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a932346b59f61..c9666d7c6c4ff 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -221,6 +221,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_ABSENT_MAPPING_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d5ae636c26d62..26b9485557056 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1206,6 +1206,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool exit_on_memory_fault = kvm_slot_fault_on_absent_mapping(memslot);
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1301,8 +1302,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, exit_on_memory_fault, false, NULL,
+					write_fault, &writable, NULL);
+
+	if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {
+		kvm_populate_efault_info(vcpu,
+				round_down(gfn * PAGE_SIZE, vma_pagesize), vma_pagesize);
+		return -EFAULT;
+	}
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.40.0.577.gac1e443424-goog

