Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAB6354B0A
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 04:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbhDFCsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 22:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233030AbhDFCsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 22:48:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21F1861396;
        Tue,  6 Apr 2021 02:48:43 +0000 (UTC)
From:   Huacai Chen <chenhuacai@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: MIPS: Remove a "set but not used" variable
Date:   Tue,  6 Apr 2021 10:49:11 +0800
Message-Id: <20210406024911.2008046-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fix a build warning:

   arch/mips/kvm/vz.c: In function '_kvm_vz_restore_htimer':
>> arch/mips/kvm/vz.c:392:10: warning: variable 'freeze_time' set but not used [-Wunused-but-set-variable]
     392 |  ktime_t freeze_time;
         |          ^~~~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/mips/kvm/vz.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index d0d03bddbbba..e81dfdf7309e 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -388,7 +388,6 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
 				   u32 compare, u32 cause)
 {
 	u32 start_count, after_count;
-	ktime_t freeze_time;
 	unsigned long flags;
 
 	/*
@@ -396,7 +395,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
 	 * this with interrupts disabled to avoid latency.
 	 */
 	local_irq_save(flags);
-	freeze_time = kvm_mips_freeze_hrtimer(vcpu, &start_count);
+	kvm_mips_freeze_hrtimer(vcpu, &start_count);
 	write_c0_gtoffset(start_count - read_c0_count());
 	local_irq_restore(flags);
 
-- 
2.27.0

