Return-Path: <kvm+bounces-70286-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OO8dAZ/3g2kwwQMAu9opvQ
	(envelope-from <kvm+bounces-70286-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:51:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F647EDC86
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 859ED3019190
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 01:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058FF28CF7C;
	Thu,  5 Feb 2026 01:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="DavxXPNZ"
X-Original-To: kvm@vger.kernel.org
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D1928FA9A;
	Thu,  5 Feb 2026 01:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.248.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770256267; cv=none; b=YmoQAgUgkcbVZkSbBdVSX1QbYdVr4GUuy5/QMmfF4q6Uu6bcU2UOS81ijktVEB/t9AT0IreIKEGX6kUlPXWMXSCVLMwFaQQd6bukIJUdStNfTQTmVvSKc5T+AsEsQniHUqI5g1rG/E0YEB7tGmVK0UOVT7W1rjAoncfItOditSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770256267; c=relaxed/simple;
	bh=3tEL440Mn7AwTUWC7fSpvsRHAx2uqRnn/8weT1MhNwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KxcfN8C/rJQgtM5VWrDkMPpW3ynTRzTJuOJOmkukD0xhJT3oP2UTNJjp/GlVDRsK/CKy1J65PlNjZHe3S/4bIJvZS3nkADEysOSVc0rqKGhPyrOJZo0sh33lwiPASMkZaUE8Hr10qRmhKKNQ/V3Ln28XglELWfqP7hi2E2QN5gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=DavxXPNZ; arc=none smtp.client-ip=159.100.248.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.157])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id E8FFC26344;
	Thu,  5 Feb 2026 01:50:58 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay3.mymailcheap.com (Postfix) with ESMTPS id B2ADA3E91A;
	Thu,  5 Feb 2026 01:50:50 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 9E85840073;
	Thu,  5 Feb 2026 01:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1770256244; bh=3tEL440Mn7AwTUWC7fSpvsRHAx2uqRnn/8weT1MhNwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DavxXPNZZtWyCN+XS8J8LorVhbAvPvGyr8/sgJMYgXNjGpf3TBhKWDyMd0hwOCPPm
	 iGrGGO04FKIgMOkGXwEW3jPvac3+MDzLD/uHD/OHhE8KICYvRAhbi4m/H3oS3V9UML
	 UmAQ5eJQ8op/M4kVNxiQBiu03YbEfqzI2Khman3c=
Received: from [127.0.0.1] (unknown [117.151.13.111])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 661004017F;
	Thu,  5 Feb 2026 01:50:36 +0000 (UTC)
Message-ID: <35a29467-662d-4214-97a5-35d8ea92dbdb@aosc.io>
Date: Thu, 5 Feb 2026 09:50:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: Bibo Mao <maobibo@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260204113601.912413-1-liushuyu@aosc.io>
 <02f9aed7-d435-fd0b-4f7e-4b59dd62dcb2@loongson.cn>
From: liushuyu <liushuyu@aosc.io>
Content-Language: en-US-large, en-US
In-Reply-To: <02f9aed7-d435-fd0b-4f7e-4b59dd62dcb2@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[aosc.io:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70286-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[aosc.io];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[aosc.io:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gitlab.com:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,aosc.io:email,aosc.io:dkim,aosc.io:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6F647EDC86
X-Rspamd-Action: no action

Hi Bibo,

> Hi Zixing,
>
> Thanks for doing this.
>
> On 2026/2/4 下午7:36, Zixing Liu wrote:
>> This ioctl can be used by the userspace applications to determine which
>> (special) registers are get/set-able in a meaningful way.
>>
>> This can be very useful for cross-platform VMMs so that they do not have
>> to hardcode register indices for each supported architectures.
>>
>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>> ---
>>   Documentation/virt/kvm/api.rst |  2 +-
>>   arch/loongarch/kvm/vcpu.c      | 87 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 88 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst
>> b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..f46dd8be282f 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>   ---------------------
>>     :Capability: basic
>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_reg_list (in/out)
>>   :Returns: 0 on success; -1 on error
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 656b954c1134..bd855ee20ee2 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -3,6 +3,7 @@
>>    * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>>    */
>>   +#include "asm/kvm_host.h"
> Had better put after #include <asm/fpu.h>, and keep alphabetical order.
>>   #include <linux/kvm_host.h>
>>   #include <asm/fpu.h>
>>   #include <asm/lbt.h>
>> @@ -14,6 +15,8 @@
>>   #define CREATE_TRACE_POINTS
>>   #include "trace.h"
>>   +#define NUM_LBT_REGS 6
>> +
>>   const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>       KVM_GENERIC_VCPU_STATS(),
>>       STATS_DESC_COUNTER(VCPU, int_exits),
>> @@ -1186,6 +1189,72 @@ static int kvm_loongarch_vcpu_set_attr(struct
>> kvm_vcpu *vcpu,
>>       return ret;
>>   }
>>   +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64
>> __user *uindices)
>> +{
>> +    unsigned int i, count;
>> +
>> +    for (i = 0, count = 0; i < CSR_MAX_NUMS; i++) {
>> +        if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
>> +            continue;
>> +        if (i >= LOONGARCH_CSR_PERFCTRL0 && i <=
>> LOONGARCH_CSR_PERFCNTR3) {
>> +            /* Skip PMU CSRs if not supported by the guest */
>> +            if (!kvm_guest_has_pmu(&vcpu->arch))
>> +                continue;
>> +        }
> This is workable, gcsr_flag can be changed with structure, and new
> element "int required_features" added. However it does not matter, it
> can be done in later.
>
> CSR registers relative with msgint feature can be done with this
> method also.
>
> How about debug/watch CSR registers? can it be skipped also?  the same
> MERR CSR registers with LOONGARCH_CSR_MERR*.
>
> The CSR register list difference can be checked with
> kvm_loongarch_get_csr() in qemu VMM, with website
> https://gitlab.com/qemu-project/qemu/-/blob/master/target/loongarch/kvm/kvm.c?ref_type=heads 
>
Do you think for KVM guests, the only CSRs need to be saved are listed
at
https://gitlab.com/qemu-project/qemu/-/blob/master/target/loongarch/kvm/kvm.c?ref_type=heads#L375-544?

Then the concern about embedding a big list will become valid again.
What do you think?

> Regards
> Bibo Mao 

Thanks,

Zixing

>> +        const u64 reg = KVM_IOC_CSRID(i);
>> +        if (uindices && put_user(reg, uindices++))
>> +            return -EFAULT;
>> +        count++;
>> +    }
>> +
>> +    return count;
>> +}
>> +
>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>> +{
>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>> +    unsigned long res =
>> +        kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS + 1;
>> +
>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>> +        res += NUM_LBT_REGS;
>> +
>> +    return res;
>> +}
>> +
>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>> +                      u64 __user *uindices)
>> +{
>> +    u64 reg;
>> +    unsigned int i;
>> +
>> +    i = kvm_loongarch_walk_csrs(vcpu, uindices);
>> +    if (i < 0)
>> +        return i;
>> +    uindices += i;
>> +
>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>> +        reg = KVM_IOC_CPUCFG(i);
>> +        if (put_user(reg, uindices++))
>> +            return -EFAULT;
>> +    }
>> +
>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>> +    if (put_user(reg, uindices++))
>> +        return -EFAULT;
>> +
>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>> +        return 0;
>> +
>> +    for (i = 1; i <= NUM_LBT_REGS; i++) {
>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>> +        if (put_user(reg, uindices++))
>> +            return -EFAULT;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   long kvm_arch_vcpu_ioctl(struct file *filp,
>>                unsigned int ioctl, unsigned long arg)
>>   {
>> @@ -1251,6 +1320,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>           r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>           break;
>>       }
>> +    case KVM_GET_REG_LIST: {
>> +        struct kvm_reg_list __user *user_list = argp;
>> +        struct kvm_reg_list reg_list;
>> +        unsigned n;
>> +
>> +        r = -EFAULT;
>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>> +            break;
>> +        n = reg_list.n;
>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>> +            break;
>> +        r = -E2BIG;
>> +        if (n < reg_list.n)
>> +            break;
>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>> +        break;
>> +    }
>>       default:
>>           r = -ENOIOCTLCMD;
>>           break;
>>
>

