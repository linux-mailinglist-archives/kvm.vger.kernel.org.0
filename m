Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7665B437054
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 05:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhJVDCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 23:02:20 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56893 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232769AbhJVDCS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 23:02:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UtCQfPR_1634871599;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UtCQfPR_1634871599)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Oct 2021 10:59:59 +0800
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
        Alexander Graf <graf@amazon.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: X86: Exit to userspace if RDMSR/WRMSR emulation returns X86EMUL_IO_NEEDED
Date:   Fri, 22 Oct 2021 10:59:57 +0800
Message-Id: <e8ff17592ae36b015bbe7d052b642e21acbccc24.1634870747.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
References: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In em_rdmsr()/em_wrmsr(), it returns X86EMUL_IO_NEEDED if MSR accesses
needed to exit to userspace. However, x86_emulate_insn() doesn't return
X86EMUL_*, so x86_emulate_instruction() doesn't directly act on
X86EMUL_IO_NEEDED, it instead looks for other signals to differentiate
between PIO, MMIO, etc... So RDMSR/WRMSR emulation won't exit to
userspace now.

The userspace_msr_exit_test testcase in seftests had tested RDMSR/WRMSR
emulation with kvm.force_enable_prefix enabled and it was passed.
Because x86_emulate_instruction() returns 1 and guest continues,
but RIP has been updated to point to RDMSR/WRMSR. Then guest would
execute RDMSR/WRMSR and exit to userspace by
kvm_emulate_rdmsr()/kvm_emulate_wrmsr() finally. In such situation,
instruction emulation didn't take effect but userspace exit information
had been filled, which was inappropriate.

Since X86EMUL_IO_NEEDED path would provide a complete_userspace_io
callback, x86_emulate_instruction() should return 0 if callback is
not NULL. Then RDMSR/WRMSR instruction emulation can exit to userspace
and skip RDMSR/WRMSR execution and inteception.

Fixes: 1ae099540e8c7 ("KVM: x86: Allow deflecting unknown MSR accesses to user space")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ea4f6ef2474..4e0dc5b06d03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7950,7 +7950,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			writeback = false;
 		r = 0;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
-	} else if (r == EMULATION_RESTART)
+	} else if (vcpu->arch.complete_userspace_io)
+		r = 0;
+	else if (r == EMULATION_RESTART)
 		goto restart;
 	else
 		r = 1;
-- 
2.31.1

