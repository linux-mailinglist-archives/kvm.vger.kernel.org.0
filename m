Return-Path: <kvm+bounces-69075-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PRAAOLmdmlxYgEAu9opvQ
	(envelope-from <kvm+bounces-69075-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:00:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 20AFB83CD0
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE0033009B2F
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 04:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69593090C9;
	Mon, 26 Jan 2026 04:00:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C8F2BB17;
	Mon, 26 Jan 2026 04:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769400027; cv=none; b=ZxgvJ2+G0DlqAZu67lCmcxTIoNa03F8ik2zgo4suTVrwwcy16Xr1rwTXeC9KkPgTpa8VQP1F7I2HLoZwx4BtoZO/sEgdHoapNDmrBm2mdzwPZZ8TwuESD0s+/G4Bew5PfrvJzW3dLeT/o3xZ1nNToKySk0RjVtHrQsBBbKMPiPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769400027; c=relaxed/simple;
	bh=r/hU7H+WlM01gB6KHVku+qtCFvFZp5WiIiuu9jeoop4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZzG6b1f5JDTGxJvA+Ka438EzpwkJq0VZwBceVHv4FrS8kMcCs3dqXxPVOQ9tXvtTaLNmPjqAgtbwiO6hoAGIDP87fFZSyzgsEz6XgjU62eXvnuFG44HdxXPgNegmXb+ewJiCVwAtMjKJZ91W1lqNVBXdJ1/Fg1cfDyfOwWQ22tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxHMPU5nZpWJoMAA--.40831S3;
	Mon, 26 Jan 2026 12:00:20 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCx+8HF5nZpb1kxAA--.31227S3;
	Mon, 26 Jan 2026 12:00:07 +0800 (CST)
Subject: Re: [PATCH 1/1] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: liushuyu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 rust-for-linux@vger.kernel.org
References: <20260125054322.1237687-1-liushuyu@aosc.io>
 <4b504274-4241-0e3e-3ed3-7804b72b7ee8@loongson.cn>
 <972430be-d2f3-49b6-851b-a057ddfcafec@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <29565e27-f153-c2c5-cbc3-e0457d45f094@loongson.cn>
Date: Mon, 26 Jan 2026 11:57:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <972430be-d2f3-49b6-851b-a057ddfcafec@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx+8HF5nZpb1kxAA--.31227S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3GFW5ZryfGrWkCF1fAw1fuFX_yoW7trWkpr
	ykAFW5Jry5Jrn3Jr1jgw15WFyUAr18J3ZrZrn3XF18ArsFyr12gr18WryqgF1UJ3y8JF40
	vr1UXrnxZrs8J3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUA529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1q6r43M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVW8ZVWrXwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jCMKZUUU
	UU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[27];
	TAGGED_FROM(0.00)[bounces-69075-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[aosc.io,redhat.com,lwn.net,loongson.cn,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,gmail.com,garyguo.net,protonmail.com,google.com,umich.edu,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.995];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,aosc.io:email]
X-Rspamd-Queue-Id: 20AFB83CD0
X-Rspamd-Action: no action



On 2026/1/26 上午11:38, liushuyu wrote:
> Hi Bibo,
>>
>>
>> On 2026/1/25 下午1:43, Zixing Liu wrote:
>>> This ioctl can be used by userspace applications to determine which
>>> (special) registers are get/set-able.
>>>
>>> This can be very useful for cross-platform VMMs so that they do not have
>>> to hardcode register indices for each supported architectures.
>>>
>>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>>> ---
>>>
>>> For example, this ioctl could be used by rust-vmm/rust-kvm or maybe
>>> VirtualBox-kvm in the future.
>>>
>>>    Documentation/virt/kvm/api.rst |  2 +-
>>>    arch/loongarch/kvm/vcpu.c      | 69 ++++++++++++++++++++++++++++++++++
>>>    2 files changed, 70 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst
>>> b/Documentation/virt/kvm/api.rst
>>> index 01a3abef8abb..f46dd8be282f 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>>    ---------------------
>>>      :Capability: basic
>>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>>    :Type: vcpu ioctl
>>>    :Parameters: struct kvm_reg_list (in/out)
>>>    :Returns: 0 on success; -1 on error
>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>> index 656b954c1134..b884eb9c76aa 100644
>>> --- a/arch/loongarch/kvm/vcpu.c
>>> +++ b/arch/loongarch/kvm/vcpu.c
>>> @@ -1186,6 +1186,57 @@ static int kvm_loongarch_vcpu_set_attr(struct
>>> kvm_vcpu *vcpu,
>>>        return ret;
>>>    }
>>>    +static unsigned long kvm_loongarch_num_lbt_regs(void)
>>> +{
>>> +    /* +1 for the LBT_FTOP flag (inside arch.fpu) */
>>> +    return sizeof(struct loongarch_lbt) / sizeof(unsigned long) + 1;
>>> +}
>>> +
>>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>>> +{
>>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>>> +    unsigned long res = CSR_MAX_NUMS + KVM_MAX_CPUCFG_REGS + 1;
>>> +
>>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>>> +        res += kvm_loongarch_num_lbt_regs();
>>> +
>>> +    return res;
>>> +}
>>> +
>>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>>> +                      u64 __user *uindices)
>>> +{
>>> +    u64 reg;
>>> +    unsigned int i;
>>> +
>>> +    for (i = 0; i < CSR_MAX_NUMS; i++) {
>>> +        reg = KVM_IOC_CSRID(i);
>>> +        if (put_user(reg, uindices++))
>>> +            return -EFAULT;
>>> +    }
>> CSR_MAX_NUMS is max number of accessible CSR registers, instead only
>> part of them is used by vCPU model. By my understanding, there will be
>> no much meaning if CSR_MAX_NUMS is returned. And I think it will be
>> better if real CSR register id and number is returned.
>>
> Did you mean we should only return the CSR registers initialized in this
> function
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/loongarch/kvm/main.c?id=63804fed149a6750ffd28610c5c1c98cce6bd377#n48
> ?
> 
> That looks like a very large list and the values of the register IDs are
> not fully continuous. If that is the case, how do we maintain the
> get/set-able CSR register list?
It will be better if CSR register list can be categorized, for example 
with LoongArch CPU manual CSR register is split into 8 types from 
chapter 7.4 -- 7.11

At the beginning, there is big array with size CSR_MAX_NUMS without any 
category, it can be fine-gained in late.

Regards
Bibo Mao
> 
>> Regards
>> Bibo Mao
>>> +
>>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>>> +        reg = KVM_IOC_CPUCFG(i);
>>> +        if (put_user(reg, uindices++))
>>> +            return -EFAULT;
>>> +    }
>>> +
>>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>>> +    if (put_user(reg, uindices++))
>>> +        return -EFAULT;
>>> +
>>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>>> +        return 0;
>>> +
>>> +    for (i = 1; i <= kvm_loongarch_num_lbt_regs(); i++) {
>>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>>> +        if (put_user(reg, uindices++))
>>> +            return -EFAULT;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>    long kvm_arch_vcpu_ioctl(struct file *filp,
>>>                 unsigned int ioctl, unsigned long arg)
>>>    {
>>> @@ -1251,6 +1302,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>            r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>>            break;
>>>        }
>>> +    case KVM_GET_REG_LIST: {
>>> +        struct kvm_reg_list __user *user_list = argp;
>>> +        struct kvm_reg_list reg_list;
>>> +        unsigned n;
>>> +
>>> +        r = -EFAULT;
>>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>>> +            break;
>>> +        n = reg_list.n;
>>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>>> +            break;
>>> +        r = -E2BIG;
>>> +        if (n < reg_list.n)
>>> +            break;
>>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>>> +        break;
>>> +    }
>>>        default:
>>>            r = -ENOIOCTLCMD;
>>>            break;
>>>
>>
> Thanks,
> Zixing
> 


