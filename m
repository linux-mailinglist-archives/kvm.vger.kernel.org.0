Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39CF49A1BD
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 23:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388778AbfHVVLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 17:11:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:61963 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbfHVVL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 17:11:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 14:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="186688734"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 14:11:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386
Date:   Thu, 22 Aug 2019 14:11:22 -0700
Message-Id: <20190822211122.27579-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use 'lea' instead of 'add' when adjusting %rsp in CALL_NOSPEC so as to
avoid clobbering flags.

KVM's emulator makes indirect calls into a jump table of sorts, where
the destination of the CALL_NOSPEC is a small blob of code that performs
fast emulation by executing the target instruction with fixed operands.

  adcb_al_dl:
     0x000339f8 <+0>:   adc    %dl,%al
     0x000339fa <+2>:   ret

A major motiviation for doing fast emulation is to leverage the CPU to
handle consumption and manipulation of arithmetic flags, i.e. RFLAGS is
both an input and output to the target of CALL_NOSPEC.  Clobbering flags
results in all sorts of incorrect emulation, e.g. Jcc instructions often
take the wrong path.  Sans the nops...

  asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
     0x0003595a <+58>:  mov    0xc0(%ebx),%eax
     0x00035960 <+64>:  mov    0x60(%ebx),%edx
     0x00035963 <+67>:  mov    0x90(%ebx),%ecx
     0x00035969 <+73>:  push   %edi
     0x0003596a <+74>:  popf
     0x0003596b <+75>:  call   *%esi
     0x000359a0 <+128>: pushf
     0x000359a1 <+129>: pop    %edi
     0x000359a2 <+130>: mov    %eax,0xc0(%ebx)
     0x000359b1 <+145>: mov    %edx,0x60(%ebx)

  ctxt->eflags = (ctxt->eflags & ~EFLAGS_MASK) | (flags & EFLAGS_MASK);
     0x000359a8 <+136>: mov    -0x10(%ebp),%eax
     0x000359ab <+139>: and    $0x8d5,%edi
     0x000359b4 <+148>: and    $0xfffff72a,%eax
     0x000359b9 <+153>: or     %eax,%edi
     0x000359bd <+157>: mov    %edi,0x4(%ebx)

For the most part this has gone unnoticed as emulation of guest code
that can trigger fast emulation is effectively limited to MMIO when
running on modern hardware, and MMIO is rarely, if ever, accessed by
instructions that affect or consume flags.

Breakage is almost instantaneous when running with unrestricted guest
disabled, in which case KVM must emulate all instructions when the guest
has invalid state, e.g. when the guest is in Big Real Mode during early
BIOS.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Fixes: 1a29b5b7f347a ("KVM: x86: Make indirect calls in emulator speculation safe")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/nospec-branch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 109f974f9835..80bc209c0708 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -192,7 +192,7 @@
 	"    	lfence;\n"					\
 	"       jmp    902b;\n"					\
 	"       .align 16\n"					\
-	"903:	addl   $4, %%esp;\n"				\
+	"903:	lea    4(%%esp), %%esp;\n"			\
 	"       pushl  %[thunk_target];\n"			\
 	"       ret;\n"						\
 	"       .align 16\n"					\
-- 
2.22.0

