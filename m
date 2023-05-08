Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E216FB454
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbjEHPtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbjEHPtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:49:10 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C14AD25
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:48:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-94f910ea993so726933766b.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560905; x=1686152905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=blFZvUojr5dhE4Jx5u2uh9350JzTZAott5birNxEhcg=;
        b=pYG476BqfI0Rq7cQdmIWBYzsxMQ6qf4Bo97dMqri/IbahRLZlnrKi0gBYk4/Sqpo66
         Q3RlmmLFqrpAvHslTW31KUkKMBSpOPheRzUej3bUiYF9dybrdamzfCdAzqCdxFRbPyFJ
         bbr96HGSF/S2bh8NxsiVxZnK9NEpp8Y9NKvr1QwWUXTnwVc4V0OI1b2W2sLJb+/UbSQD
         Vt7n4ll21udaCfdxONJbLAPbDwKG4i9xpr/gJ5JmT847Adhmuw5tbzn5q+ax7Q/5kT5Z
         y8iyrQIsvbOKciCSmfVMNSqkXum61ae6xiyNSv/sp6Qkf08jmBB3m2eBdmfXXwZG3Sgm
         JA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560905; x=1686152905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=blFZvUojr5dhE4Jx5u2uh9350JzTZAott5birNxEhcg=;
        b=hghvX3bRdvrVGDztqdOKmdoPhuZBOivDpuykbIYBwieP8zNt2aUXpvJzO//StR4EI6
         GhJ0ueF7bjKl+LN7ICSGG1hj/E2ulVqXQh3YrORYtz4beKIfXmD/LEWzs7lgOHhtx6mi
         wzZBumjCZU4YwRH0+Rt8HL7xiDZTRrorl9FJWAoec/pHQAKITk6q7yN+ln18yuUmF1hA
         1v6ukGE3VfeA0zZvKgijUyQof9RFM3IHV+++sZXn9BXBIbYbmZMzkPDv30wFlYHx7m1K
         PFHurwKap9AAp72sHRCycODcHJ8L4Vhlid5usGl5zdmdK1+9bc43gHgPNQiae1dDPmsa
         Ak1Q==
X-Gm-Message-State: AC+VfDyv/+hV/llZRLlMAi7DIBWWk839EMvX8gDmvQTlQmWl9GOf8Lte
        Y6CiEhpu6rlInzaw72mcUMXE/g==
X-Google-Smtp-Source: ACHHUZ6p97wsXEK2KKfsgqHjlyGpBe7C7EV/1INNvqFR8KwoZB1QZozqOGZJE90qgy29jP1yG9L2WQ==
X-Received: by 2002:a17:907:961a:b0:965:fd04:f76b with SMTP id gb26-20020a170907961a00b00965fd04f76bmr10216621ejc.55.1683560905013;
        Mon, 08 May 2023 08:48:25 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm126316eja.49.2023.05.08.08.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:48:24 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 5.10 08/10] KVM: X86: Ensure that dirty PDPTRs are loaded
Date:   Mon,  8 May 2023 17:48:02 +0200
Message-Id: <20230508154804.30078-9-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
References: <20230508154804.30078-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit 2c5653caecc4807b8abfe9c41880ac38417be7bf ]

For VMX with EPT, dirty PDPTRs need to be loaded before the next vmentry
via vmx_load_mmu_pgd()

But not all paths that call load_pdptrs() will cause vmx_load_mmu_pgd()
to be invoked.  Normally, kvm_mmu_reset_context() is used to cause
KVM_REQ_LOAD_MMU_PGD, but sometimes it is skipped:

* commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
when changing CR0.CD and CR0.NW.

* commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
PCID on MOV CR3 w/ flush") skips KVM_REQ_LOAD_MMU_PGD after
load_pdptrs() when rewriting the CR3 with the same value.

* commit a91a7c709600("KVM: X86: Don't reset mmu context when
toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
load_pdptrs() when changing CR4.PGE.

Fixes: d81135a57aa6 ("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
Fixes: 21823fbda552 ("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
Fixes: a91a7c709600 ("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211108124407.12187-2-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.10.x
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2378ec80305..038ac5bbdd19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -794,6 +794,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 
 out:
 
-- 
2.39.2

