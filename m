Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B129D799238
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbjIHWaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343842AbjIHW37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:29:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F481FCA
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7ec535fe42so2301397276.1
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212195; x=1694816995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tw1V6jjZtxQPmQpxo2OqWdUijyBXviuVC0rwevTlCmY=;
        b=QsV6RtPRFPkXSPvAB5TqT08jJf/BL+EdNOI/VVHO4+zqZM8QbnipwdTJ/AFH7ZTqnB
         v8tbZ2Z08OPONId7OL1xCw6oTfbg/mEMtYXSEQRAXvHkj8j86i8FTAFjPQNIJ1bOz4Ur
         59keXBOQ1EpdYq9opjamXZESZzx0GqsHFuij2F1RcDGaKSUMOKpUimPkibO5gOJblHOB
         EGXJEbRu5pV993M3feUy8ippgT0pRQ8Sw2BCVVI19y5DEtxS5QPwuCip3Z1FxgplxRrf
         E6bwjRnUikaJezVJHQqwA/Pl19/WxT3eRi9pBsSZtgpBdqwbQRQi3ceJUow/FFfTu5MJ
         lLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212195; x=1694816995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tw1V6jjZtxQPmQpxo2OqWdUijyBXviuVC0rwevTlCmY=;
        b=CwEK4eJsKddruDWGyjzPmZUN667YnYTKdUd2Vb8W2fCsnDfex+IHVQmhI3h+eLdc+V
         c9LnEEgflYPoXuocPBQUZgkJbWan0RraPpM1PsiY+1G8bS1QznyjiNiEAMaCH1uot55R
         q1YOdbvCEZs2CleuRIMBqow0UJeoTKA4yFR4gWwIHbca0+TY37WjquvAhmcqincDhM7k
         u6rjWXFMrn/vty99qO+y/8uTOvFfYdUD+KvTqrUv71eHrtb6qDJIHM4LRISX/hHFk9l0
         S8YHXSNXpnYqwiMcAWvYzDre7Vf/W+BT07mcjNrswdy+1q0Qs2XhKFraiO2Rak8IWbmR
         pT9g==
X-Gm-Message-State: AOJu0YzDEtfbVVgWjZThVCea5umGUu7+1st87PHdMiJl35K84GzoYvsN
        X+ALQCas6excifFNuQXfksrn4jwHQ8IprQ==
X-Google-Smtp-Source: AGHT+IFidILo8DbI1LLUBkpdLdDWa4EPEgOq/ggpLsuiBitayiGeHEqMSH561wdBMd5QP0I3V80StiKjXtme2Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ac02:0:b0:d7f:f3e:74ab with SMTP id
 w2-20020a25ac02000000b00d7f0f3e74abmr86043ybi.1.1694212195382; Fri, 08 Sep
 2023 15:29:55 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:54 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-8-amoorthy@google.com>
Subject: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement KVM_CAP_MEMORY_FAULT_INFO for guest access failure in
user_mem_abort().

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 587a104f66c3..8ede6c5edc5f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1408,6 +1408,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	uint64_t memory_fault_flags;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1507,8 +1508,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		memory_fault_flags = 0;
+		if (write_fault)
+			memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;
+		else if (exec_fault)
+			memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;
+		else
+			memory_fault_flags = KVM_MEMORY_FAULT_FLAG_READ;
+		kvm_handle_guest_uaccess_fault(vcpu, round_down(gfn * PAGE_SIZE, vma_pagesize),
+					       vma_pagesize, memory_fault_flags);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
-- 
2.42.0.283.g2d96d420d3-goog

