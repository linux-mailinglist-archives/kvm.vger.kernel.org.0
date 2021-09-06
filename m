Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800D4401A3A
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhIFK5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:57:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhIFK5w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630925807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RK2Ni9Cbo/+wilrr5SKGs0bqB6QPRnMOhzJVRr0kJ8Y=;
        b=e4DWBZs+wjfDbLjsZfCzBdB0XpLjrRk4/nRSksZZSaTnsb+qOPbExRgLLFsoYXa4gFNO3E
        AsObtLW7sVJwGxZIh/h3Xn72NFXTZDquA3YJzg7nM6P7jfxOaNxhAmfGyLmWHu65zmbq2u
        LelzM8Wf3Az6gRebn9mT6/kIj43u3Ic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-uZJrnWC_Prqlk6lZB4ZTgA-1; Mon, 06 Sep 2021 06:56:46 -0400
X-MC-Unique: uZJrnWC_Prqlk6lZB4ZTgA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92BB2107ACE8;
        Mon,  6 Sep 2021 10:56:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ADBD18649;
        Mon,  6 Sep 2021 10:56:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: MMU: mark role_regs and role accessors as maybe unused
Date:   Mon,  6 Sep 2021 06:56:44 -0400
Message-Id: <20210906105644.3686909-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is reasonable for these functions to be used only in some configurations,
for example only if the host is 64-bits (and therefore supports 64-bit
guests).  It is also reasonable to keep the role_regs and role accessors
in sync even though some of the accessors may be used only for one of the
two sets (as is the case currently for CR4.LA57)..

Because clang reports warnings for unused inlines declared in a .c file,
mark both sets of accessors as __maybe_unused.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9b0cdec8b62d..2d7e61122af8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -204,7 +204,7 @@ struct kvm_mmu_role_regs {
  * the single source of truth for the MMU's state.
  */
 #define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
-static inline bool ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
+static inline bool __maybe_unused ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
 {									\
 	return !!(regs->reg & flag);					\
 }
@@ -226,7 +226,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
  * and the vCPU may be incorrect/irrelevant.
  */
 #define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
-static inline bool is_##reg##_##name(struct kvm_mmu *mmu)	\
+static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
 {								\
 	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
 }
-- 
2.27.0

