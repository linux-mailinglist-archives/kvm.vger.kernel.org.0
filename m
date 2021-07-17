Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA883CC247
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 11:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhGQJ7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jul 2021 05:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhGQJ7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jul 2021 05:59:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2EE7613D4;
        Sat, 17 Jul 2021 09:56:10 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m4h3I-00DvkH-QK; Sat, 17 Jul 2021 10:56:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 0/5] KVM: Remove kvm_is_transparent_hugepage() and friends
Date:   Sat, 17 Jul 2021 10:55:36 +0100
Message-Id: <20210717095541.1486210-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com, willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A while ago, Willy and Sean pointed out[1] that arm64 is the last user
of kvm_is_transparent_hugepage(), and that there would actually be
some benefit in looking at the userspace mapping directly instead.

This small series does exactly that, although it doesn't try to
support more than a PMD-sized mapping yet for THPs. We could probably
look into unifying this with the huge PUD code, and there is still
some potential use of the contiguous hint.

As a consequence, it removes kvm_is_transparent_hugepage(),
PageTransCompoundMap() and kvm_get_pfn(), all of which have no user
left after this rework.

This has been lightly tested on an Altra box. Although nothing caught
fire, it requires some careful reviewing on the arm64 side.

[1] https://lore.kernel.org/r/YLpLvFPXrIp8nAK4@google.com

Marc Zyngier (5):
  KVM: arm64: Walk userspace page tables to compute the THP mapping size
  KVM: arm64: Avoid mapping size adjustment on permission fault
  KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()
  KVM: arm64: Use get_page() instead of kvm_get_pfn()
  KVM: Get rid of kvm_get_pfn()

 arch/arm64/kvm/mmu.c       | 57 +++++++++++++++++++++++++++++++++-----
 include/linux/kvm_host.h   |  1 -
 include/linux/page-flags.h | 37 -------------------------
 virt/kvm/kvm_main.c        | 19 +------------
 4 files changed, 51 insertions(+), 63 deletions(-)

-- 
2.30.2

