Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD57425D6C8
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 12:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbgIDKsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 06:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgIDKqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 06:46:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5B5820C56;
        Fri,  4 Sep 2020 10:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599216366;
        bh=nCc55AZ3IGOEPrvp66HRc9DIbXCNXgxfLuV2k8RKjKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUoZVg/IjoiVzDx4ku/+fP10lSWGwkW6n/0IGghZaq1Zamg67QAq/IMENy0PZZckW
         JOGO7ScY01EetEYlUnNOJHCHLkzXXtjX9f2Ba8YASKYcUR9+XHawtuzyodpq7NvZ3G
         diwah0+HwJcDfuPEbXoLLjrfMHbaqbx0C3l4gU2c=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kE9EL-0098oH-6W; Fri, 04 Sep 2020 11:46:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 9/9] KVM: arm64: Update page shift if stage 2 block mapping not supported
Date:   Fri,  4 Sep 2020 11:45:30 +0100
Message-Id: <20200904104530.1082676-10-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
References: <20200904104530.1082676-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, steven.price@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Commit 196f878a7ac2e (" KVM: arm/arm64: Signal SIGBUS when stage2 discovers
hwpoison memory") modifies user_mem_abort() to send a SIGBUS signal when
the fault IPA maps to a hwpoisoned page. Commit 1559b7583ff6 ("KVM:
arm/arm64: Re-check VMA on detecting a poisoned page") changed
kvm_send_hwpoison_signal() to use the page shift instead of the VMA because
at that point the code had already released the mmap lock, which means
userspace could have modified the VMA.

If userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
map the guest fault IPA using block mappings in stage 2. That is not always
possible, if, for example, userspace uses dirty page logging for the VM.
Update the page shift appropriately in those cases when we downgrade the
stage 2 entry from a block mapping to a page.

Fixes: 1559b7583ff6 ("KVM: arm/arm64: Re-check VMA on detecting a poisoned page")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Link: https://lore.kernel.org/r/20200901133357.52640-2-alexandru.elisei@arm.com
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 16b8660ddbcc..f58d657a898d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1871,6 +1871,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
 		force_pte = true;
 		vma_pagesize = PAGE_SIZE;
+		vma_shift = PAGE_SHIFT;
 	}
 
 	/*
-- 
2.27.0

