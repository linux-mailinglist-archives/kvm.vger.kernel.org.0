Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BDE23CE91
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgHES1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbgHES1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECA9122D03;
        Wed,  5 Aug 2020 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651971;
        bh=W24AS4Bq5U16UDVsYGu8+EESYRWDTiZMQfrojw+S804=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilxj4OBluk2cbgHz0R9290zoNQIyIzCl39m0h/b7BSUlY/62Qru60dGmgcqN2gJ8/
         pvIytkdZX0zmbwFQ0AjuVMtUpq89axTvTwB4ra3fdZ7yvKV7XBWfESAKxjXamBw8lh
         pQqHWSMB09m2EOMXZJO2Wugyasek+ElWz1n33e4g=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Ng3-0004w9-LN; Wed, 05 Aug 2020 18:58:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 55/56] KVM: arm64: Don't skip cache maintenance for read-only memslots
Date:   Wed,  5 Aug 2020 18:56:59 +0100
Message-Id: <20200805175700.62775-56-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Will Deacon <will@kernel.org>

If a guest performs cache maintenance on a read-only memslot, we should
inform userspace rather than skip the instruction altogether.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20200729102821.23392-4-will@kernel.org
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 14c6a9df5c9f..85b0ec9dd9ef 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2121,7 +2121,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * So let's assume that the guest is just being
 		 * cautious, and skip the instruction.
 		 */
-		if (kvm_vcpu_dabt_is_cm(vcpu)) {
+		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
 			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 			ret = 1;
 			goto out_unlock;
-- 
2.27.0

