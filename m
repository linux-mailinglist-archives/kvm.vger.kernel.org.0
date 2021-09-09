Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B1D404965
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 13:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbhIILjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 07:39:19 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:55617 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235658AbhIILjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 07:39:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Unnf9Xb_1631187478;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0Unnf9Xb_1631187478)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 19:37:59 +0800
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
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH 2/3] kvm: x86: Refactor kvm_emulate_hypercall() to no skip instruction
Date:   Thu,  9 Sep 2021 19:37:55 +0800
Message-Id: <961516749b864f8f8397905cc5d4a7db60f45dbe.1631186996.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
References: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_emulate_hypercall() to no skip instruction, it can
be used in next patch for emulating hypercall in instruction
emulation.

Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4e2836b94a01..b8d799e1c57c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8636,17 +8636,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+static int kvm_emulate_hypercall_noskip(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
 
-	if (kvm_xen_hypercall_enabled(vcpu->kvm))
-		return kvm_xen_hypercall(vcpu);
-
-	if (kvm_hv_hypercall_enabled(vcpu))
-		return kvm_hv_hypercall(vcpu);
-
 	nr = kvm_rax_read(vcpu);
 	a0 = kvm_rbx_read(vcpu);
 	a1 = kvm_rcx_read(vcpu);
@@ -8664,11 +8658,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
-		static_call(kvm_x86_handle_hypercall_fail)(vcpu);
-		return 1;
-	}
-
 	ret = -KVM_ENOSYS;
 
 	switch (nr) {
@@ -8733,7 +8722,28 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	kvm_rax_write(vcpu, ret);
 
 	++vcpu->stat.hypercalls;
-	return kvm_skip_emulated_instruction(vcpu);
+	return 1;
+}
+
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	if (kvm_xen_hypercall_enabled(vcpu->kvm))
+		return kvm_xen_hypercall(vcpu);
+
+	if (kvm_hv_hypercall_enabled(vcpu))
+		return kvm_hv_hypercall(vcpu);
+
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
+		static_call(kvm_x86_handle_hypercall_fail)(vcpu);
+		return 1;
+	}
+
+	ret = kvm_emulate_hypercall_noskip(vcpu);
+	if (ret)
+		return kvm_skip_emulated_instruction(vcpu);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
-- 
2.31.1

