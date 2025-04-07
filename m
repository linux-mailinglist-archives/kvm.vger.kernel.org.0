Return-Path: <kvm+bounces-42857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E67C5A7E6F4
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CEDF3A47EF
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7828620C499;
	Mon,  7 Apr 2025 16:34:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBDB209F59;
	Mon,  7 Apr 2025 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744043665; cv=none; b=Pxg2Zktc5ay9sO/xVAnkT5TMPTH+Ie6+3i3ImvcHeFucYQ//+Y+DdRMv6RYJoRKOGIpYO3r4CxukMXq94Xiz6r7JLZ/4wmqmtf54ola9qRQm7UfA1+MJAuUoe8WCwTBZNqbnIi8ollXJTGivp5S5mAJzkTJ+2mes7b8Tm1S14yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744043665; c=relaxed/simple;
	bh=mQLvDq/c/f6VeVn9jAgvnWRwlfEnoMdYJpZMSAGn4EY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JiuoIbV8BrUNIwQjVx9IKLwfRScLa2O8unk/dnBff5p638x591OP+2TeKQ5z6+vM/5fQ+wK7/FFjd5Jok3jlQtE5bmaGLgCXLxPWRe8UeA7UUGqipgM3bOVkCxS+7QdSU42bCfHxjOG+UnpgjUXnRjNBGZllacC/y3CMhtvH5w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D9F3106F;
	Mon,  7 Apr 2025 09:34:24 -0700 (PDT)
Received: from [10.57.17.31] (unknown [10.57.17.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 231A03F694;
	Mon,  7 Apr 2025 09:34:18 -0700 (PDT)
Message-ID: <95c06abf-591f-4dd0-b1fd-296b0d5ae924@arm.com>
Date: Mon, 7 Apr 2025 17:34:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 17/45] arm64: RME: Handle realm enter/exit
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-18-steven.price@arm.com>
 <80983793-5df7-4828-96e8-90540e7d9183@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <80983793-5df7-4828-96e8-90540e7d9183@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/03/2025 01:03, Gavin Shan wrote:
> On 2/14/25 2:13 AM, Steven Price wrote:
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v6:
>>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>>     vcpu to the error.
>>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>>     this exit type.
>>   * Split code handling a RIPAS change triggered by the guest to the
>>     following patch.
>> Changes since v5:
>>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>>     change on next entry rather than immediately on the exit. This allows
>>     the VMM to 'reject' a RIPAS change by refusing to continue
>>     scheduling.
>> Changes since v4:
>>   * Rename handle_rme_exit() to handle_rec_exit()
>>   * Move the loop to copy registers into the REC enter structure from the
>>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>>     where the handler exits to user space and user space wants to modify
>>     the GPRS.
>>   * Some code rearrangement in rec_exit_ripas_change().
>> Changes since v2:
>>   * realm_set_ipa_state() now provides an output parameter for the
>>     top_iap that was changed. Use this to signal the VMM with the correct
>>     range that has been transitioned.
>>   * Adapt to previous patch changes.
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |   3 +
>>   arch/arm64/kvm/Makefile          |   2 +-
>>   arch/arm64/kvm/arm.c             |  19 +++-
>>   arch/arm64/kvm/rme-exit.c        | 171 +++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/rme.c             |  19 ++++
>>   5 files changed, 208 insertions(+), 6 deletions(-)
>>   create mode 100644 arch/arm64/kvm/rme-exit.c
>>
> 
> With below nitpicks addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>> new file mode 100644
>> index 000000000000..aae1adefe1a3
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme-exit.c
>> @@ -0,0 +1,171 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <kvm/arm_hypercalls.h>
>> +#include <kvm/arm_psci.h>
>> +
>> +#include <asm/rmi_smc.h>
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_rme.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
>> +
> 
> Duplicated to exit_handler_fn, defined in handle_exit.c, need move the
> definition to header file.

While I get this is duplication, I'm a little reluctant to move it to a
header file because this is completely internal to each C file (the
xxx_exit_handler[] arrays are both static). If either side wants to e.g.
add an extra argument there shouldn't be a requirement to reflect that
change in the other.

Specifically I'm wondering if we're going to ever need to pass an RMI
return status into the rme-exit callbacks at some point.

>> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>> +{
>> +    return kvm_handle_guest_abort(vcpu);
>> +}
>> +
>> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long esr = kvm_vcpu_get_esr(vcpu);
>> +    int rt = kvm_vcpu_sys_get_rt(vcpu);
>> +    bool is_write = !(esr & 1);
>> +    int ret;
>> +
>> +    if (is_write)
>> +        vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
>> +
>> +    ret = kvm_handle_sys_reg(vcpu);
>> +
>> +    if (ret >= 0 && !is_write)
>> +        rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
>> +
> 
> Unncessary blank line and the conditon isn't completely correct:
> kvm_handle_sys_reg()
> should return 0 if the requested emulation fails, even it always returns
> 1 for now.

It shouldn't matter, but like you say it's not technically the correct
condition so I'll fix this up.

Thanks,
Steve

>     ret = kvm_handle_sys_reg(vcpu);
>     if (ret > 0 && !is_write)
>         rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
> 
>> +    return ret;
>> +}
>> +
> 
> [...]
> 
> Thanks,
> Gavin
> 


