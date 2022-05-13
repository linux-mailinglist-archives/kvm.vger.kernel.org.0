Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC53526B63
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384397AbiEMU3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384335AbiEMU3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:29:23 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FFB7A455
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:12 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 15-20020aa7920f000000b0050cf449957fso4472817pfo.9
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HIEyJZRpr2jcyJ/fmafeFJZJ+wHC9HCHT15KsP+KWpI=;
        b=iX2OHbcsw6FoAz7JEDK5rCc0tPJZ6WRbOZwRG6RKbT6jQXE17WlJGssIhPSuOfq4wg
         XIWYuYcX7Qr2tZDPW/lhm/HFLaZITZv+aTjfF8YjFYU0sFPcSEKTdsQf8V8UCBPIFDaJ
         zAX4r9SsXZT4d/vumXd9b2lJvSoFyEdn6BpoxZjDvlRUGV6YUGcOXw1I+2+xVxP9bJfS
         W1UKZ0cG0kKiaF/jhb6RGWAroxpcUtuLqHG2/OVzXh3xkhppxtZHgOnppeAhPozEtFQE
         kWNDFaxhB2KovtE4moxtaq1/N45e6JC2x9tkuceH94bEa+5M6j3HNICKGx6Yavc3s6Nc
         H7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HIEyJZRpr2jcyJ/fmafeFJZJ+wHC9HCHT15KsP+KWpI=;
        b=sk/qTVlxGjfMxsHjg4doKKb/UBKarLpUBuAyPR5RcQhuK2q8lbjDHgc1ujXwA0jN9A
         rhHTNOFd6+tJDLAc8aWZD5VvSdj5Ulr9RAOlEXYI6YE+lQESlxQK4St5d33FIV+xfolp
         wknjSlBgqjy1NbWtZy68c6lMN7ob5nRqn0US4Asw33IXbZd5Yv3U1Vjs6gce7kLvFTY8
         Ahb/+xb5LhWSgN4IwUhR3tgeLzbQjgdeQwGudhxhFJxCvJpKmr1addZUcFcWc4fmIPCr
         rg30XuOF1QhucMKsYU32Q1FvnEC4q/zBuSMoobNVbyWTEMsHu9LIMoSbBACpJqtg8dc8
         a0WQ==
X-Gm-Message-State: AOAM530EOUxrTCQYt/ukxRK6yPEUXwguXnTovjRAbCvO3R5N6HGVBJ06
        K+phZ1/N2Dk3FOIvs6kFxObiiMe1bXVqhA==
X-Google-Smtp-Source: ABdhPJybUih+bwE7FyOBg+qcGDi8Nof6ENpdkam6v1N4A8EAkz8f1UOC2uM61149paY4cu0ueKr5wo9dTOwczg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:cf44:0:b0:50d:6d18:17f9 with SMTP id
 b65-20020a62cf44000000b0050d6d1817f9mr6142945pfg.63.1652473743414; Fri, 13
 May 2022 13:29:03 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:17 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-20-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 19/21] KVM: x86/mmu: Refactor drop_large_spte()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush.

In preparation for eager page splitting, which will need to sometimes
flush when dropping large SPTEs (and sometimes not), push the flushing
logic down into __drop_large_spte() and add a bool parameter to control
it.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef190dd77ccc..4b40fa2e27eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1161,26 +1161,26 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void __drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
+	struct kvm_mmu_page *sp;
 
-	return false;
+	if (!is_large_pte(*sptep))
+		return;
+
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
+
+	drop_spte(kvm, sptep);
+
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
-
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
+	return __drop_large_spte(vcpu->kvm, sptep, true);
 }
 
 /*
-- 
2.36.0.550.gb090851708-goog

