Return-Path: <kvm+bounces-46179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ABF7AB3AF4
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 16:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1315F19E35AE
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 14:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD5A22B8BD;
	Mon, 12 May 2025 14:45:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3122122A1CD;
	Mon, 12 May 2025 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747061126; cv=none; b=sogv/Opnl6lLV4FU7+X/MS1fd6yz9QI6jePy0gHSEWSSIY7eRmpvY/J9RGXT6Giv8+g3SBsLz7YYfIDf1zaE4vXj2W+0OFoRl+VRArJn66qauKTMIEUSJ4SMuh+9jQceBVKWb/YB8vGU27kp7F1+YmHCyLBjCToY6d+9wOaWhq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747061126; c=relaxed/simple;
	bh=Ee7TVXRHpTI483XATox6XW7kAWNu8rFF48cimnraYqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUwlKq7iun/E72wSJkOkMWxgpQ2elOw6y4KBFgQ/dqnbsBOQWNcS9+KxhKV/e5/NfgUdEvcUdmlhYWBDZKQDaKUasI82Mdr4CyftvrmC72c3UptsWHSER1qfrK5xTj2xOgHb0ZDASo1r9h+bSsMm65GBYiphZIje5YVA20Cy8Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DC3314BF;
	Mon, 12 May 2025 07:45:13 -0700 (PDT)
Received: from [10.57.21.218] (unknown [10.57.21.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C95E3F673;
	Mon, 12 May 2025 07:45:20 -0700 (PDT)
Message-ID: <956e661b-6dcf-49cb-a210-b0865588e04c@arm.com>
Date: Mon, 12 May 2025 15:45:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-17-steven.price@arm.com>
 <e6a69a4a-8014-44b4-aef6-37afe0fa8d29@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <e6a69a4a-8014-44b4-aef6-37afe0fa8d29@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/04/2025 12:55, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>>     been read (although that can never happen in the current code). Tidy
>>     up the condition to handle any future refactoring.
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
>>   arch/arm64/kvm/rme-exit.c        | 170 +++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/rme.c             |  19 ++++
>>   5 files changed, 207 insertions(+), 6 deletions(-)
>>   create mode 100644 arch/arm64/kvm/rme-exit.c
>>
> 
> One nitpick below.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks

[...]

>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>> new file mode 100644
>> index 000000000000..a1adf5610455
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme-exit.c
>> @@ -0,0 +1,170 @@
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
>> +    if (ret > 0 && !is_write)
>> +        rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
> 
> kvm_handle_sys_reg() always returns positive value, so it can be:
> 
>     if (!is_write)
>         rc->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);

I'm not sure the "always returns positive values" is a good
justification - that might change in the future (although I guess the
only reason it returns '1' is just to have the correct function
signature - so it's unlike to change).

However there isn't really any harm here in setting the 'enter' value
even if it fails. So I'll drop the "ret > 0" check.

Thanks,
Steve


