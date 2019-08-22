Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E729299324
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbfHVMTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 08:19:22 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62393 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbfHVMTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 08:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566476362; x=1598012362;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=NUsQatsxKYNB87527GnfXFNToYtVT+w6m283v7nP9NI=;
  b=TVt3XxUNDp7jkPL9muhbDWu3oWJQwL3RfjgrzZpJ99yIbmngB7lgCd6k
   kuRxwUk9J+W4DdGEnpZR49oU/VJLL2u/YHdkm7f3VwA0DgfYHlTuVO86O
   3N37DYGoLvjx1z4xDNWt9yUUGdwKJJRNmqz6YLvDfRseAwwImVvOrDdsU
   o=;
X-IronPort-AV: E=Sophos;i="5.64,416,1559520000"; 
   d="scan'208";a="822655259"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 Aug 2019 12:19:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 8C1431A73D5;
        Thu, 22 Aug 2019 12:19:20 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 22 Aug 2019 12:19:19 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 22 Aug 2019 12:19:15 +0000
Subject: Re: [PATCH v5 11/20] RISC-V: KVM: Handle WFI exits for VCPU
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-12-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <29b8f7c6-4b9d-91fc-61e7-82ecfd26ff88@amazon.com>
Date:   Thu, 22 Aug 2019 14:19:12 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822084131.114764-12-anup.patel@wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.67]
X-ClientProxiedBy: EX13D02UWC001.ant.amazon.com (10.43.162.243) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.08.19 10:45, Anup Patel wrote:
> We get illegal instruction trap whenever Guest/VM executes WFI
> instruction.
> 
> This patch handles WFI trap by blocking the trapped VCPU using
> kvm_vcpu_block() API. The blocked VCPU will be automatically
> resumed whenever a VCPU interrupt is injected from user-space
> or from in-kernel IRQCHIP emulation.
> 
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/riscv/kvm/vcpu_exit.c | 88 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 88 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index efc06198c259..fbc04fe335ad 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -12,6 +12,9 @@
>   #include <linux/kvm_host.h>
>   #include <asm/csr.h>
>   
> +#define INSN_MASK_WFI		0xffffff00
> +#define INSN_MATCH_WFI		0x10500000
> +
>   #define INSN_MATCH_LB		0x3
>   #define INSN_MASK_LB		0x707f
>   #define INSN_MATCH_LH		0x1003
> @@ -179,6 +182,87 @@ static ulong get_insn(struct kvm_vcpu *vcpu)
>   	return val;
>   }
>   
> +typedef int (*illegal_insn_func)(struct kvm_vcpu *vcpu,
> +				 struct kvm_run *run,
> +				 ulong insn);
> +
> +static int truly_illegal_insn(struct kvm_vcpu *vcpu,
> +			      struct kvm_run *run,
> +			      ulong insn)
> +{
> +	/* TODO: Redirect trap to Guest VCPU */
> +	return -ENOTSUPP;
> +}
> +
> +static int system_opcode_insn(struct kvm_vcpu *vcpu,
> +			      struct kvm_run *run,
> +			      ulong insn)
> +{
> +	if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
> +		vcpu->stat.wfi_exit_stat++;
> +		if (!kvm_arch_vcpu_runnable(vcpu)) {
> +			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> +			kvm_vcpu_block(vcpu);
> +			vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> +		}
> +		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> +		return 1;
> +	}
> +
> +	return truly_illegal_insn(vcpu, run, insn);
> +}
> +
> +static illegal_insn_func illegal_insn_table[32] = {

Every time I did experiments on PowerPC with indirect tables like this 
over switch() in C, the switch() code won. CPUs are pretty good at 
predicting branches. Predicting indirect jumps however, they are 
terrible at.

So unless you consider the jump table more readable / maintainable, I 
would suggest to use a simple switch() statement. It will be faster and 
smaller.


Alex


> +	truly_illegal_insn, /* 0 */
> +	truly_illegal_insn, /* 1 */
> +	truly_illegal_insn, /* 2 */
> +	truly_illegal_insn, /* 3 */
> +	truly_illegal_insn, /* 4 */
> +	truly_illegal_insn, /* 5 */
> +	truly_illegal_insn, /* 6 */
> +	truly_illegal_insn, /* 7 */
> +	truly_illegal_insn, /* 8 */
> +	truly_illegal_insn, /* 9 */
> +	truly_illegal_insn, /* 10 */
> +	truly_illegal_insn, /* 11 */
> +	truly_illegal_insn, /* 12 */
> +	truly_illegal_insn, /* 13 */
> +	truly_illegal_insn, /* 14 */
> +	truly_illegal_insn, /* 15 */
> +	truly_illegal_insn, /* 16 */
> +	truly_illegal_insn, /* 17 */
> +	truly_illegal_insn, /* 18 */
> +	truly_illegal_insn, /* 19 */
> +	truly_illegal_insn, /* 20 */
> +	truly_illegal_insn, /* 21 */
> +	truly_illegal_insn, /* 22 */
> +	truly_illegal_insn, /* 23 */
> +	truly_illegal_insn, /* 24 */
> +	truly_illegal_insn, /* 25 */
> +	truly_illegal_insn, /* 26 */
> +	truly_illegal_insn, /* 27 */
> +	system_opcode_insn, /* 28 */
> +	truly_illegal_insn, /* 29 */
> +	truly_illegal_insn, /* 30 */
> +	truly_illegal_insn  /* 31 */
> +};
> +
> +static int illegal_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			      unsigned long stval)
> +{
> +	ulong insn = stval;
> +
> +	if (unlikely((insn & 3) != 3)) {
> +		if (insn == 0)
> +			insn = get_insn(vcpu);
> +		if ((insn & 3) != 3)
> +			return truly_illegal_insn(vcpu, run, insn);
> +	}
> +
> +	return illegal_insn_table[(insn & 0x7c) >> 2](vcpu, run, insn);
> +}
> +
>   static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>   			unsigned long fault_addr)
>   {
> @@ -439,6 +523,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>   	ret = -EFAULT;
>   	run->exit_reason = KVM_EXIT_UNKNOWN;
>   	switch (scause) {
> +	case EXC_INST_ILLEGAL:
> +		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> +			ret = illegal_inst_fault(vcpu, run, stval);
> +		break;
>   	case EXC_INST_PAGE_FAULT:
>   	case EXC_LOAD_PAGE_FAULT:
>   	case EXC_STORE_PAGE_FAULT:
> 

