Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F875320F8A
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 03:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhBVCrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 21:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhBVCrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 21:47:00 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6797AC061793
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 18:45:48 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k22so6838703pll.6
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 18:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YI7HyzDG3owLPU4UQfa7tiUEs9jP6yMxkdlolNtJ+LQ=;
        b=oFZXsVYacLQwXAQgBXWMVNd4tYXERP+aOxK5JtlWHh10GwD8sUEk2xy3lHQcfTdxNJ
         A6c9eWv3q8ddSG8D4h1LqOoseHnCbmYkxklZ6Xfy3SnqUUMRHonQ6E6OabJC+EI947OM
         +XuAC7e32rEtYRhECOHtBOFGA47fYnVe624N4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YI7HyzDG3owLPU4UQfa7tiUEs9jP6yMxkdlolNtJ+LQ=;
        b=nQFCG3iY+2gI59Gyl9dG2CvBFaqRQjy1NCLloTZQ8E1rC4HgGsWJVzzno7ZETDDSYn
         6h5TNL0VQpa3Ekp9zGtXoZDncyGOEtETGfzbj5qkTJbU/muhnKWCUsniH0JVGTtb8TJ4
         2LpC+9966CJvZOrqXTDa1OPFiwcZozCYWSEbgT7b9LEGk6xzIHJ14zenVd7Tf8KHtAkN
         6e+BvHfNUD4m1nTAft36tV/zUfO9zC0XTauUnMuR7sccfTp56DnhmW4KlL22LSboBvU6
         ichJ9xUXOP/Y4mPPdl5aHxpjfzqZch12bA0fc2KFXDnTORSfLgA5wpXbj2x8IktC3NS4
         4rtA==
X-Gm-Message-State: AOAM531k1HFEfj5peJzNEouU9G9zVygz12YCy0gi1HqxOzrFFnZ5AgNM
        14w+0EiXnnviuPEPPk9taSU1/g==
X-Google-Smtp-Source: ABdhPJx0ONsyfWmAv6BuRaUkUpIoDCKbgVlmXVQvduvaRKvsylbKwcg3SupTc3g+xjmq0KI028TOMQ==
X-Received: by 2002:a17:90a:4882:: with SMTP id b2mr20682824pjh.78.1613961947967;
        Sun, 21 Feb 2021 18:45:47 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:11b3:5e1a:7cb:7e1f])
        by smtp.gmail.com with UTF8SMTPSA id y2sm15413682pjw.36.2021.02.21.18.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 18:45:47 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH v4 1/2] KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault
Date:   Mon, 22 Feb 2021 11:45:21 +0900
Message-Id: <20210222024522.1751719-2-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
In-Reply-To: <20210222024522.1751719-1-stevensd@google.com>
References: <20210222024522.1751719-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Don't retry a page fault due to an mmu_notifier invalidation when
handling a page fault for a GPA that did not resolve to a memslot, i.e.
an MMIO page fault.  Invalidations from the mmu_notifier signal a change
in a host virtual address (HVA) mapping; without a memslot, there is no
HVA and thus no possibility that the invalidation is relevant to the
page fault being handled.

Note, the MMIO vs. memslot generation checks handle the case where a
pending memslot will create a memslot overlapping the faulting GPA.  The
mmu_notifier checks are orthogonal to memslot updates.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..9ac0a727015d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3725,7 +3725,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..ab54263d857c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -869,7 +869,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
-- 
2.30.0.617.g56c4b15f3c-goog

