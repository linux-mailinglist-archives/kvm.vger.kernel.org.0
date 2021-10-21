Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7AA435830
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 03:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhJUB3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 21:29:40 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:59538 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231342AbhJUB3j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 21:29:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Ut5Vdx0_1634779640;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Ut5Vdx0_1634779640)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Oct 2021 09:27:21 +0800
Subject: Re: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in
 kvm_invalidate_pcid()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-2-jiangshanlai@gmail.com> <YW7jfIMduQti8Zqk@google.com>
 <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
 <YXBfaqenOhf+M3eA@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <55abc519-b528-ddaa-120d-8d157b520623@linux.alibaba.com>
Date:   Thu, 21 Oct 2021 09:27:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXBfaqenOhf+M3eA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/10/21 02:26, Sean Christopherson wrote:
> On Wed, Oct 20, 2021, Lai Jiangshan wrote:
>> On 2021/10/19 23:25, Sean Christopherson wrote:
>> I just read some interception policy in vmx.c, if EPT=1 but vmx_need_pf_intercept()
>> return true for some reasons/configs, #PF is intercepted.  But CR3 write is not
>> intercepted, which means there will be an EPT fault _after_ (IIUC) the CR3 write if
>> the GPA of the new CR3 exceeds the guest maxphyaddr limit.  And kvm queues a fault to
>> the guest which is also _after_ the CR3 write, but the guest expects the fault before
>> the write.
>>
>> IIUC, it can be fixed by intercepting CR3 write or reversing the CR3 write in EPT
>> violation handler.
> 
> KVM implicitly does the latter by emulating the faulting instruction.
> 
>    static int handle_ept_violation(struct kvm_vcpu *vcpu)
>    {
> 	...
> 
> 	/*
> 	 * Check that the GPA doesn't exceed physical memory limits, as that is
> 	 * a guest page fault.  We have to emulate the instruction here, because
> 	 * if the illegal address is that of a paging structure, then
> 	 * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
> 	 * would also use advanced VM-exit information for EPT violations to
> 	 * reconstruct the page fault error code.
> 	 */
> 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
> 		return kvm_emulate_instruction(vcpu, 0);
> 
> 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>    }
> 
> and injecting a #GP when kvm_set_cr3() fails.

I think the EPT violation happens *after* the cr3 write.  So the instruction to be
emulated is not "cr3 write".  The emulation will queue fault into guest though,
recursive EPT violation happens since the cr3 exceeds maxphyaddr limit.

In this case, the guest is malicious/broken and gets to keep the pieces too.

> 
>    static int em_cr_write(struct x86_emulate_ctxt *ctxt)
>    {
> 	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
> 		return emulate_gp(ctxt, 0);
> 
> 	/* Disable writeback. */
> 	ctxt->dst.type = OP_NONE;
> 	return X86EMUL_CONTINUE;
>    }
> 
