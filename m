Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0483936F41E
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 04:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhD3CrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 22:47:15 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:47900 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhD3CrO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 22:47:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UXD5Pfd_1619750782;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UXD5Pfd_1619750782)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 30 Apr 2021 10:46:23 +0800
Subject: Re: [PATCH 3/4] KVM/VMX: Invoke NMI non-IST entry instead of IST
 entry
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
 <20210426230949.3561-4-jiangshanlai@gmail.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <0bec6872-4d08-d00b-9922-61c5038f2476@linux.alibaba.com>
Date:   Fri, 30 Apr 2021 10:46:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426230949.3561-4-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/27 07:09, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In VMX, the NMI handler needs to be invoked after NMI VM-Exit.
> 
> Before the commit 1a5488ef0dcf6 ("KVM: VMX: Invoke NMI handler via
> indirect call instead of INTn"), the work is done by INTn ("int $2").
> 
> But INTn microcode is relatively expensive, so the commit reworked
> NMI VM-Exit handling to invoke the kernel handler by function call.
> And INTn doesn't set the NMI blocked flag required by the linux kernel
> NMI entry.  So moving away from INTn are very reasonable.
> 
> Yet some details were missed.  After the said commit applied, the NMI
> entry pointer is fetched from the IDT table and called from the kernel
> stack.  But the NMI entry pointer installed on the IDT table is
> asm_exc_nmi() which expects to be invoked on the IST stack by the ISA.
> And it relies on the "NMI executing" variable on the IST stack to work
> correctly.  When it is unexpectedly called from the kernel stack, the
> RSP-located "NMI executing" variable is also on the kernel stack and
> is "uninitialized" and can cause the NMI entry to run in the wrong way.
> 
> So we should not used the NMI entry installed on the IDT table.  Rather,
> we should use the NMI entry allowed to be used on the kernel stack which
> is asm_noist_exc_nmi() which is also used for XENPV and early booting.
> 

The problem can be tested by the following testing-patch.

1) the testing-patch can be applied without conflict before this patch 3.
    And it shows the problem that the NMI is missed in the case.

2) you need to manually copy the same logic of this testing-patch to verify
    this patch 3. And it shows that the problem is fixed.

3) the only one line of code in vmenter.S just emulates the situation that
    a "uninitialized" garbage in the kernel stack happens to be 1 and it happens
    to be at the same location of the RSP-located "NMI executing" variable.


diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 3a6461694fc2..32096049c2a2 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -316,6 +316,7 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
  #endif
  	pushf
  	push $__KERNEL_CS
+	movq $1, -24(%rsp) // "NMI executing": 1 = nested, non-1 = not-nested
  	CALL_NOSPEC _ASM_ARG1

  	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcbf0d2139e9..9509d2edd50d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6416,8 +6416,12 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
  	else if (is_machine_check(intr_info))
  		kvm_machine_check();
  	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info))
+	else if (is_nmi(intr_info)) {
+		unsigned long count = this_cpu_read(irq_stat.__nmi_count);
  		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
+		if (count == this_cpu_read(irq_stat.__nmi_count))
+			pr_info("kvm nmi miss\n");
+	}
  }

  static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)

