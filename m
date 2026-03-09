Return-Path: <kvm+bounces-73254-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEOWIk1FrmkrBgIAu9opvQ
	(envelope-from <kvm+bounces-73254-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 04:58:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8CD233986
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 04:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 67124300F582
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 03:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927B5286417;
	Mon,  9 Mar 2026 03:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b="VLkDzgE3";
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="YaJhHei8"
X-Original-To: kvm@vger.kernel.org
Received: from relay1-o.mailbaby.net (relay1-o.mailbaby.net [206.72.200.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0882B27FD45
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 03:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=206.72.200.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773028681; cv=pass; b=nGfofrx/u+EfsjHbE7aUh5QsTVvs7lsk3a5M5imuuV8jWBRk1Qzr8N8Vsq7PohU4SiVLCHLBpwHKHY3qHsTo9e0bwvMQqs62Jpn5hW9QejSo0C1u+M9rzJkl/3g68gqKlNxJkQOmkNkKOShlBRhPxbRuc4p8ndcIzUpfB+D60II=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773028681; c=relaxed/simple;
	bh=lwwoDMt07BHVae2SSuCm++Lq88pVo29Jxl5PRDwfYYo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=NeVqKnujmJaj/bTh/EWBtjrTNN6JrFzXLBTGcp7ODPbW820wu91j7xSbnuXVJ8OZRo5DCN9SaVYR6hTpH8yfTpifha6ukCG2AqpSOCAmtZpCaKOq1nqLeNapq3dWN0oErsjuR0jw+Dsu4GVmvk5ro/2BVSCrFl95EUBBpXQew6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b=VLkDzgE3; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=YaJhHei8; arc=pass smtp.client-ip=206.72.200.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbaby.net;
 q=dns/txt; s=key2; bh=lwwoDMt07BHVae2SSuCm++Lq88pVo29Jxl5PRDwfYYo=;
 h=from:subject:date:message-id:to:cc:mime-version:content-type:content-transfer-encoding:in-reply-to:references:feedback-id;
 b=VLkDzgE3OGbb8Vzk68XKf2ucmQVWpaqCmdwOWds8VRRGjoVUf0H+vtQkOsMEu7A6fsiBAjY6D
 Afp/Mfp0TGxJ0p3vvlJtoxSZPSWs9PNSdlXd3wWNVX4gVGp5/pPHayyTTp3Lj2sCg75zZu7/nuh
 goIuIFme3svYYOgtxWdmSPc=
Received: from mb-nj-kvm1.internal (mb-nj-kvm1.internal [10.10.2.10])
 (Authenticated sender: mb86144)
 by relay1-o.mailbaby.net (MailBabyMTA) with ESMTPSA id 19cd0b9c0600003c69.001
 for <kvm@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 09 Mar 2026 03:52:40 +0000
X-Zone-Loop: 7c02d7f363910f71accc11795ae95160b4f8f065076a
ARC-Authentication-Results: i=1;	rspamdcluster9.mailbaby.net;	auth=pass
 smtp.auth=mb86144 smtp.mailfrom=liushuyu@aosc.io
ARC-Seal: i=1; a=rsa-sha256; d=mailbaby.net; s=detka; cv=none;
 t=1773028360;
	b=WARoSrt8GSSjWdM7b02KAe/7w0dF0zfSIm9Dl/yNQcaZkXnioTQXNJJA08D3A+xDkGFrrl
	8pzTEuPtwHyMBp/K1uy96mZOhwyflBYAifX8+5cUQfAw858uNTkyUk4/a50NE/lUHYuu1l
	g4bRsH2BDFEDpu//fLNYVe+lLSFVb5bbYkxHmeiG80Z6Q8yaf93BdXsxYYftrkLjBDkWTl
	Bwq5ejy4v1a+HSKt9uxECv+1o9u5XXj8YmqoI9pJcfHqraXnr/iLFxORoG1aR4diAYz5vu
	uj/UGZj09SHx3328eqiQbh9FRl7IO8hPnlGPRI7BY0GCjbfWPqb6wCDZYMG4AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailbaby.net;	s=detka; t=1773028360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwwoDMt07BHVae2SSuCm++Lq88pVo29Jxl5PRDwfYYo=;
	b=cSOv5hNAqjai+OcBb56RWBWmi+reQuL2NfNs1z3JOSmFirMUugzm7qfWAMI7QaBt4Kg9ph
	6Tavt8DH5wivkgTMXELj/z5Tfm+mFHhu2WdrcD0PYjzhCB62kJ2FAQWuWB6ahje1z1ZaWC
	N6d6cfXEHQaLL9wWX+zi+QmHh0X5OrW43oHQ9IiCNBzP4FguIrceGn2l9Sw0Xk+oton4/U
	wttFGibIyWkOuWMpFUvZ5rbY8Pjvb77glMGpFg9ldff/S+AC93qowSF0wyiVoUp3r3Iur0
	Piu6whDLX9RBtNhc7NdLeaEgH4e4o3cymzyG7ZUC0A992CEpxMRi83y4pUigMQ==
X-MB-ID: mb86144
X-SPF: pass
Feedback-ID: mb86144:19cd0b9c0600003c69:587f4d465843594778405947455d:mbaby
X-NS-SCAN: PASS
X-MAILBABY-ORIGIN: PASS
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.113.132])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 8F56220130;
	Mon,  9 Mar 2026 03:52:30 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 429653EB87;
	Mon,  9 Mar 2026 03:52:22 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 0A7CE40087;
	Mon,  9 Mar 2026 03:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1773028341; bh=lwwoDMt07BHVae2SSuCm++Lq88pVo29Jxl5PRDwfYYo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=YaJhHei8YyBBteM0/73IuHjvJ4YA5IX1eyAPh0R7r47WGTBXoQzSr0R+CUEBF2WmT
	 fh2Z4Ef8uIP6BggGtP0nJ86kqugBRyeDMF8p9Lp/OTDZDK+3vay7X60YQDjb8Bgmy2
	 USehboiKw4Y3vNOW6t8eDGZgbiQBenKpe/NraWOw=
Received: from [127.0.0.1] (unknown [117.151.13.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 9049640D09;
	Mon,  9 Mar 2026 03:52:17 +0000 (UTC)
Message-ID: <f39c14fc-6fe9-4478-b595-b7480f859443@aosc.io>
Date: Mon, 9 Mar 2026 11:52:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: liushuyu <liushuyu@aosc.io>
Subject: Re: [PATCH v5] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: Bibo Mao <maobibo@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260205051822.1318253-1-liushuyu@aosc.io>
 <aa35c7a6-6361-9f83-a726-89d7deff8560@loongson.cn>
 <c4be7e68-6e51-4f2b-8a51-bef658a8ac4a@aosc.io>
 <f4ba7538-e413-d8c8-d4b6-7c8686c4aec6@loongson.cn>
Content-Language: en-US-large, en-US
In-Reply-To: <f4ba7538-e413-d8c8-d4b6-7c8686c4aec6@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C8CD233986
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[aosc.io,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[mailbaby.net:s=key2,aosc.io:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73254-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[mailbaby.net:+,aosc.io:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mailbaby.net:dkim];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.991];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

Hi Bibo,

It seems like my last email might have got bounced or landed in your
spam filter.

So this email is a re-send of the last one.

> On 2026/2/10 上午11:23, liushuyu wrote:
>> Hi Bibo,
>>
>>>
>>> On 2026/2/5 下午1:18, Zixing Liu wrote:
>>>> This ioctl can be used by the userspace applications to determine
>>>> which
>>>> (special) registers are get/set-able in a meaningful way.
>>>>
>>>> This can be very useful for cross-platform VMMs so that they do not
>>>> have
>>>> to hardcode register indices for each supported architectures.
>>>>
>>>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>>>> ---
>>>>    Documentation/virt/kvm/api.rst |   2 +-
>>>>    arch/loongarch/kvm/vcpu.c      | 120
>>>> +++++++++++++++++++++++++++++++++
>>>>    2 files changed, 121 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/virt/kvm/api.rst
>>>> b/Documentation/virt/kvm/api.rst
>>>> index 01a3abef8abb..f46dd8be282f 100644
>>>> --- a/Documentation/virt/kvm/api.rst
>>>> +++ b/Documentation/virt/kvm/api.rst
>>>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>>>    ---------------------
>>>>      :Capability: basic
>>>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if
>>>> KVM_CAP_ONE_REG)
>>>>    :Type: vcpu ioctl
>>>>    :Parameters: struct kvm_reg_list (in/out)
>>>>    :Returns: 0 on success; -1 on error
>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>> index 656b954c1134..de02e409ae39 100644
>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>> @@ -5,6 +5,7 @@
>>>>      #include <linux/kvm_host.h>
>>>>    #include <asm/fpu.h>
>>>> +#include <asm/kvm_host.h>
>>>>    #include <asm/lbt.h>
>>>>    #include <asm/loongarch.h>
>>>>    #include <asm/setup.h>
>>>> @@ -14,6 +15,8 @@
>>>>    #define CREATE_TRACE_POINTS
>>>>    #include "trace.h"
>>>>    +#define NUM_LBT_REGS 6
>>>> +
>>>>    const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>>>        KVM_GENERIC_VCPU_STATS(),
>>>>        STATS_DESC_COUNTER(VCPU, int_exits),
>>>> @@ -1186,6 +1189,105 @@ static int kvm_loongarch_vcpu_set_attr(struct
>>>> kvm_vcpu *vcpu,
>>>>        return ret;
>>>>    }
>>>>    +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64
>>>> __user *uindices)
>>>> +{
>>>> +    unsigned int i, count;
>>>> +    const unsigned int csrs_to_save[] = {
>>>> +        LOONGARCH_CSR_CRMD,      LOONGARCH_CSR_PRMD,
>>>> +        LOONGARCH_CSR_EUEN,      LOONGARCH_CSR_MISC,
>>>> +        LOONGARCH_CSR_ECFG,      LOONGARCH_CSR_ESTAT,
>>>> +        LOONGARCH_CSR_ERA,      LOONGARCH_CSR_BADV,
>>>> +        LOONGARCH_CSR_BADI,      LOONGARCH_CSR_EENTRY,
>>>> +        LOONGARCH_CSR_TLBIDX,      LOONGARCH_CSR_TLBEHI,
>>>> +        LOONGARCH_CSR_TLBELO0,      LOONGARCH_CSR_TLBELO1,
>>>> +        LOONGARCH_CSR_ASID,      LOONGARCH_CSR_PGDL,
>>>> +        LOONGARCH_CSR_PGDH,      LOONGARCH_CSR_PGD,
>>>> +        LOONGARCH_CSR_PWCTL0,      LOONGARCH_CSR_PWCTL1,
>>>> +        LOONGARCH_CSR_STLBPGSIZE, LOONGARCH_CSR_RVACFG,
>>>> +        LOONGARCH_CSR_CPUID,      LOONGARCH_CSR_PRCFG1,
>>>> +        LOONGARCH_CSR_PRCFG2,      LOONGARCH_CSR_PRCFG3,
>>>> +        LOONGARCH_CSR_KS0,      LOONGARCH_CSR_KS1,
>>>> +        LOONGARCH_CSR_KS2,      LOONGARCH_CSR_KS3,
>>>> +        LOONGARCH_CSR_KS4,      LOONGARCH_CSR_KS5,
>>>> +        LOONGARCH_CSR_KS6,      LOONGARCH_CSR_KS7,
>>>> +        LOONGARCH_CSR_TMID,      LOONGARCH_CSR_CNTC,
>>>> +        LOONGARCH_CSR_TINTCLR,      LOONGARCH_CSR_LLBCTL,
>>>> +        LOONGARCH_CSR_IMPCTL1,      LOONGARCH_CSR_IMPCTL2,
>>>> +        LOONGARCH_CSR_TLBRENTRY,  LOONGARCH_CSR_TLBRBADV,
>>>> +        LOONGARCH_CSR_TLBRERA,      LOONGARCH_CSR_TLBRSAVE,
>>>> +        LOONGARCH_CSR_TLBRELO0,      LOONGARCH_CSR_TLBRELO1,
>>>> +        LOONGARCH_CSR_TLBREHI,      LOONGARCH_CSR_TLBRPRMD,
>>>> +        LOONGARCH_CSR_DMWIN0,      LOONGARCH_CSR_DMWIN1,
>>>> +        LOONGARCH_CSR_DMWIN2,      LOONGARCH_CSR_DMWIN3,
>>>> +        LOONGARCH_CSR_TVAL,      LOONGARCH_CSR_TCFG,
>>>> +    };
>>> this increases much kernel stack size usage :)
>>>
>>> Please wait a moment, I am considering how to cleanup code about CSR
>>> registers.
>> Okay.

I am also very interested in how this CSR register logic clean-up would
work.

Can you share some details regarding this clean-up?

>>> And KVM_GET_REG_LIST is not so urgent, else there is
>>> KVM_read_from_REG_LIST/KVM_write_from_REG_LIST ioctl commands to
>>> access registers in batch mode.
>>>
>> Adding KVM_GET_REG_LIST is not urgent. However, unlike
>> KVM_read_from_REG_LIST and KVM_write_from_REG_LIST, KVM_GET_REG_LIST
>> serves a different purpose.
>>
>> The KVM_GET_REG_LIST ioctl lets user-space VMMs determine the number of
>> get/set-able registers (via KVM_GET_ONE_REG/KVM_SET_ONE_REG) and their
>> register IDs. User-space VMMs use this ioctl so they don't have to
>> hardcode a register ID table for each architecture.
> In theory it is so, I only know QEMU VMM now, is there other VMMs
> which does not use hardcoded register ID for different architecture?
> Which one if there is actually.
There is https://github.com/firecracker-microvm/firecracker (from
Amazon), which uses https://github.com/rust-vmm/kvm as the VMM library
(which uses the KVM_GET_REG_LIST ioctl to determine how many registers
to save).
> There is some potential issues by my knowledge such as:
> 1. How to solve the compatible issue if KVM_GET_REG_LIST does not
> support? 
I agree this could be an issue for LoongArch as we are trying to add
this ioctl very late. I am guessing we either tell the user that you
will need to use Linux 7.1 or something for this to work; or, for older
kernel versions, we have to resort to embedding a table in the
user-space VMM (and maybe remove it after a few years). For other
architectures, they implemented it somewhat early and did not have this
issue.
> 2. How to solve dependency between registers? Dependency should be
> solved in VMM or KVM hypervisr. 
If the dependency issue can be solved by simply re-ordering the register
IDs in the list returned to the user space, we can help the user space
VMM by sorting the list to the correct order when the kernel-side is
walking the CSR list (for instance, put the registers that require other
registers to be saved last). If that is not the case, we will need to
add a paragraph to the KVM documentation explaining how to properly
interpret the list returned by this ioctl.
> Regards
> Bibo Mao
>> I also had trouble finding information on the KVM_read_from_REG_LIST and
>> KVM_write_from_REG_LIST ioctl commands. As of commit
>> 3d29a326eba82d987a82fd59379d6d668b769965, I could not find any logic or
>> identifiers for these two ioctls.
>>
>> In some cases, KVM_GET_REG_LIST is a prerequisite for using
>> KVM_read_from_REG_LIST or KVM_write_from_REG_LIST (assuming they exist),
>> as you still need to know the register IDs to use these ioctls.
>>
>>> Regards
>>> Bibo Mao
>>>
>>>> +
>>>> +    for (i = 0, count = 0;
>>>> +         i < sizeof(csrs_to_save) / sizeof(csrs_to_save[0]); i++) {
>>>> +        const u64 reg = KVM_IOC_CSRID(i);
>>>> +        if (uindices && put_user(reg, uindices++))
>>>> +            return -EFAULT;
>>>> +        count++;
>>>> +    }
>>>> +
>>>> +    /* Skip PMU CSRs if not supported by the guest */
>>>> +    if (!kvm_guest_has_pmu(&vcpu->arch))
>>>> +        return count;
>>>> +    for (i = LOONGARCH_CSR_PERFCTRL0; i <= LOONGARCH_CSR_PERFCNTR3;
>>>> i++) {
>>>> +        const u64 reg = KVM_IOC_CSRID(i);
>>>> +        if (uindices && put_user(reg, uindices++))
>>>> +            return -EFAULT;
>>>> +        count++;
>>>> +    }
>>>> +
>>>> +    return count;
>>>> +}
>>>> +
>>>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>>>> +    unsigned long res =
>>>> +        kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS
>>>> + 1;
>>>> +
>>>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>>>> +        res += NUM_LBT_REGS;
>>>> +
>>>> +    return res;
>>>> +}
>>>> +
>>>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>>>> +                      u64 __user *uindices)
>>>> +{
>>>> +    u64 reg;
>>>> +    unsigned int i;
>>>> +
>>>> +    i = kvm_loongarch_walk_csrs(vcpu, uindices);
>>>> +    if (i < 0)
>>>> +        return i;
>>>> +    uindices += i;
>>>> +
>>>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>>>> +        reg = KVM_IOC_CPUCFG(i);
>>>> +        if (put_user(reg, uindices++))
>>>> +            return -EFAULT;
>>>> +    }
>>>> +
>>>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>>>> +    if (put_user(reg, uindices++))
>>>> +        return -EFAULT;
>>>> +
>>>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>>>> +        return 0;
>>>> +
>>>> +    for (i = 1; i <= NUM_LBT_REGS; i++) {
>>>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>>>> +        if (put_user(reg, uindices++))
>>>> +            return -EFAULT;
>>>> +    }
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>>    long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>                 unsigned int ioctl, unsigned long arg)
>>>>    {
>>>> @@ -1251,6 +1353,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>            r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>>>            break;
>>>>        }
>>>> +    case KVM_GET_REG_LIST: {
>>>> +        struct kvm_reg_list __user *user_list = argp;
>>>> +        struct kvm_reg_list reg_list;
>>>> +        unsigned n;
>>>> +
>>>> +        r = -EFAULT;
>>>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>>>> +            break;
>>>> +        n = reg_list.n;
>>>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>>>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>>>> +            break;
>>>> +        r = -E2BIG;
>>>> +        if (n < reg_list.n)
>>>> +            break;
>>>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>>>> +        break;
>>>> +    }
>>>>        default:
>>>>            r = -ENOIOCTLCMD;
>>>>            break;
>>>>
>>>
>> Thanks,
>> Zixing
>>
>
Thanks,
Zixing

