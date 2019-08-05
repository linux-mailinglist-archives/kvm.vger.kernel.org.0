Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5522281B5F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfHENOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:14:14 -0400
Received: from foss.arm.com ([217.140.110.172]:48486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbfHENON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:14:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B021D337;
        Mon,  5 Aug 2019 06:14:11 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA2003F706;
        Mon,  5 Aug 2019 06:14:09 -0700 (PDT)
Subject: Re: [PATCH 3/9] KVM: arm64: Implement PV_FEATURES call
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-4-steven.price@arm.com> <20190803122124.7700f700@why>
From:   Steven Price <steven.price@arm.com>
Message-ID: <1e0a03b4-1fb6-cbe2-fb7a-8ed39341a187@arm.com>
Date:   Mon, 5 Aug 2019 14:14:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803122124.7700f700@why>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/2019 12:21, Marc Zyngier wrote:
> On Fri,  2 Aug 2019 15:50:11 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
>> This provides a mechanism for querying which paravirtualized features
>> are available in this hypervisor.
>>
>> Also add the header file which defines the ABI for the paravirtualized
>> clock features we're about to add.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/pvclock-abi.h | 20 ++++++++++++++++++++
>>  include/linux/arm-smccc.h            | 14 ++++++++++++++
>>  virt/kvm/arm/hypercalls.c            |  9 +++++++++
>>  3 files changed, 43 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/pvclock-abi.h
>>
>> diff --git a/arch/arm64/include/asm/pvclock-abi.h b/arch/arm64/include/asm/pvclock-abi.h
>> new file mode 100644
>> index 000000000000..1f7cdc102691
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pvclock-abi.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright (C) 2019 Arm Ltd. */
>> +
>> +#ifndef __ASM_PVCLOCK_ABI_H
>> +#define __ASM_PVCLOCK_ABI_H
>> +
>> +/* The below structures and constants are defined in ARM DEN0057A */
>> +
>> +struct pvclock_vcpu_stolen_time_info {
>> +	__le32 revision;
>> +	__le32 attributes;
>> +	__le64 stolen_time;
>> +	/* Structure must be 64 byte aligned, pad to that size */
>> +	u8 padding[48];
>> +} __packed;
>> +
>> +#define PV_VM_TIME_NOT_SUPPORTED	-1
> 
> Isn't the intent for this to be the same value as
> SMCCC_RET_NOT_SUPPORTED?

Yes it is, I guess there's not much point defining it again.

>> +#define PV_VM_TIME_INVALID_PARAMETERS	-2
> 
> It overlaps with SMCCC_RET_NOT_REQUIRED. Is that a problem? Should we
> consider a spec change for this?

Actually INVALID_PARAMETERS is only for Live Physical Time, since we're
not implementing it here, this can go as well.

Thanks,

Steve
