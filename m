Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF874913D6
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 02:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbiARB5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 20:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbiARB5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 20:57:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF55C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:57:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id i8-20020a17090a718800b001b35ee7ac29so946359pjk.3
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FFJ0LKVBXmV+PQlVXimlN+9PR3R1f2e8LV1lWAds9CU=;
        b=pfvIFT7tUQ/lfy5xV/tlxtndZnM0AlSEqqjfbmpgRPXnF0D+BHDAvTalj9NsO+HEPq
         mSksHH9PCLFVenOrrjwk6g8CIKYlWCpf9xvEq5H+TgteXC37n+OXomLW9LvYHuVof9Qp
         5jwBfAvBbhY+qMSlMX6ss1g6P4zYIh/ismtJXFIyHek36v9da2fltoPoiR0rKUfnfn9t
         aeqqWj6NxMnvm8p32CgwWtSYBMmmYiq6jJwtYk/7oLFqm74Xlx8QJJAq+4W3o65Sb3or
         aN6CWExuC6Og1Jt6whszPn/rwoquDJpfo/DNmcTzJ9LCsmHsOEIhVmi+X/HpN69Dfufm
         j/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FFJ0LKVBXmV+PQlVXimlN+9PR3R1f2e8LV1lWAds9CU=;
        b=U0pcLydApOIpYnunqyd4JdnJG4Wv3lnEzN6JPs8afenQW9b1dZYqEceERcgbmAARX4
         r9GaDByR5mzRjzr7Dn6LcIEWE0coo1BWRo3o/hLmiCfPulmVrHnmqA85QxivacnLrKfL
         hCTWpleUSE4/lI7ZsRzxnnUOK4ONfovhAQt6wlPXIZ+5NDNreF7bSmm1mtTmngckwQDl
         2NuFKkWu2rLnEXuYogfhPJ5EP4/IRogeyRQU6YZBipSKzbgvjZRmAtwXkAwp2t9a+jzF
         8A0XnKlKSWqoTyMrxnN4UrMpgtl2eYB2IsEYy59WQoZZzJWAWL4A4sQZyZG0dhv/jVt6
         uTjw==
X-Gm-Message-State: AOAM533FdfOydW8NL5b9hDs9u2LyI69I0rymLXQKC6nig47D8FIC6PYa
        xYGhpnEFd8yNu9qU/rzMBz+JwvNN2kZx2G1nkRGhV2XkAB06pc/6XwyHGmS+JMl/m0C/g9lS/Ve
        Rt2atLepf0kIZM9UzFD2Tn0PSEnJ8v4T8/VPVJeMya6vpVI/nYXmaQM9nJLAOZ4bR3st77V8=
X-Google-Smtp-Source: ABdhPJxhGRe+V900JEd7wGouyItkJhnzMy8lso2rLIVPW2lAzYzOWPMFZVPT+b8tM61zC+Z0DPCs4S/OSQ9SimggFw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:3a89:: with SMTP id
 om9mr7859711pjb.103.1642471030415; Mon, 17 Jan 2022 17:57:10 -0800 (PST)
Date:   Tue, 18 Jan 2022 01:57:02 +0000
In-Reply-To: <20220118015703.3630552-1-jingzhangos@google.com>
Message-Id: <20220118015703.3630552-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To reduce MMU lock contention during dirty logging, all permission
relaxation operations would be performed under read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cafd5813c949..10df5d855d54 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1080,6 +1080,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool logging_perm_fault = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1114,6 +1115,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
+		logging_perm_fault = (fault_status == FSC_PERM && write_fault);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1212,7 +1214,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	write_lock(&kvm->mmu_lock);
+	/*
+	 * To reduce MMU contentions and enhance concurrency during dirty
+	 * logging dirty logging, only acquire read lock for permission
+	 * relaxation.
+	 */
+	if (logging_perm_fault)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1271,7 +1281,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	write_unlock(&kvm->mmu_lock);
+	if (logging_perm_fault)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
-- 
2.34.1.703.g22d0c6ccf7-goog

