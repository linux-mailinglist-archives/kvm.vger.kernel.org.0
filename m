Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B06D34FC5E
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhCaJPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:15:37 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47953 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234349AbhCaJP0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 05:15:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UTwZ0zg_1617182123;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UTwZ0zg_1617182123)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 17:15:24 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] KVM: x86: Fix potential memory access error
Date:   Wed, 31 Mar 2021 17:15:22 +0800
Message-Id: <1617182122-112315-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using __set_bit() to set a bit in an integer is not a good idea, since
the function expects an unsigned long as argument, which can be 64bit wide.
Coverity reports this problem as

High:Out-of-bounds access(INCOMPATIBLE_CAST)
CWE119: Out-of-bounds access to a scalar
Pointer "&vcpu->arch.regs_avail" points to an object whose effective
type is "unsigned int" (32 bits, unsigned) but is dereferenced as a
wider "unsigned long" (64 bits, unsigned). This may lead to memory
corruption.

/home/heyuan.shy/git-repo/linux/arch/x86/kvm/kvm_cache_regs.h:
kvm_register_is_available

Just use BIT instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 2e11da2..cfa45d88 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -52,14 +52,14 @@ static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
 static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
 					       enum kvm_reg reg)
 {
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	vcpu->arch.regs_avail |= BIT(reg);
 }
 
 static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 					   enum kvm_reg reg)
 {
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+	vcpu->arch.regs_avail |= BIT(reg);
+	vcpu->arch.regs_dirty |= BIT(reg);
 }
 
 static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
-- 
1.8.3.1

