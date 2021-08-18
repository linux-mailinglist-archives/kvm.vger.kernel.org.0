Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241B93EF8BB
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 05:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbhHRDhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 23:37:13 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:60699 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236297AbhHRDhJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 23:37:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UjbGkIu_1629257792;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UjbGkIu_1629257792)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Aug 2021 11:36:32 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: fix wrong exception emulation in check_rdtsc
Date:   Wed, 18 Aug 2021 11:36:31 +0800
Message-Id: <1297c0dd3f1bb47a6d089f850b629c7aa0247040.1629257115.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to Intel's SDM Vol2 and AMD's APM Vol3, when
CR4.TSD is set, use rdtsc/rdtscp instruction above privilege
level 0 should trigger a #GP.

Fixes: d7eb82030699e ("KVM: SVM: Add intercept checks for remaining group7 instructions")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2837110e66ed..c589ac832265 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4206,7 +4206,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
 	u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
 
 	if (cr4 & X86_CR4_TSD && ctxt->ops->cpl(ctxt))
-		return emulate_ud(ctxt);
+		return emulate_gp(ctxt, 0);
 
 	return X86EMUL_CONTINUE;
 }
-- 
2.31.1

