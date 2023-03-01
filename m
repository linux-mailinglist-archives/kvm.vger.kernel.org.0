Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7526A6BEC
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 12:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCALyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 06:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCALyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 06:54:40 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A8392CC46;
        Wed,  1 Mar 2023 03:54:39 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81E9F2F4;
        Wed,  1 Mar 2023 03:55:22 -0800 (PST)
Received: from [10.57.16.41] (unknown [10.57.16.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DA213F587;
        Wed,  1 Mar 2023 03:54:35 -0800 (PST)
Message-ID: <8e803abd-8856-3c44-6262-40c026216c9a@arm.com>
Date:   Wed, 1 Mar 2023 11:54:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 05/28] arm64: RME: Define the user ABI
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-6-steven.price@arm.com>
 <20230213180413.00000392@gmail.com>
Content-Language: en-GB
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230213180413.00000392@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/2023 16:04, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:09 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> There is one (multiplexed) CAP which can be used to create, populate and
>> then activate the realm.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/virt/kvm/api.rst    |  1 +
>>  arch/arm64/include/uapi/asm/kvm.h | 63 +++++++++++++++++++++++++++++++
>>  include/uapi/linux/kvm.h          |  2 +
>>  3 files changed, 66 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 0dd5d8733dd5..f1a59d6fb7fc 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -4965,6 +4965,7 @@ Recognised values for feature:
>>  
>>    =====      ===========================================
>>    arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
>> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>>    =====      ===========================================
>>  
>>  Finalizes the configuration of the specified vcpu feature.
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index a7a857f1784d..fcc0b8dce29b 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -109,6 +109,7 @@ struct kvm_regs {
>>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
>>  #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>> +#define KVM_ARM_VCPU_REC		7 /* VCPU REC state as part of Realm */
>>  
>>  struct kvm_vcpu_init {
>>  	__u32 target;
>> @@ -401,6 +402,68 @@ enum {
>>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
>>  #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>>  
>> +/* KVM_CAP_ARM_RME on VM fd */
>> +#define KVM_CAP_ARM_RME_CONFIG_REALM		0
>> +#define KVM_CAP_ARM_RME_CREATE_RD		1
>> +#define KVM_CAP_ARM_RME_INIT_IPA_REALM		2
>> +#define KVM_CAP_ARM_RME_POPULATE_REALM		3
>> +#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
>> +
> 
> It is a little bit confusing here. These seems more like 'commands' not caps.
> Will leave more comments after reviewing the later patches.

Sorry for the slow response. Thank you for your review - I hope to post
a new version of this series (rebased on 6.3-rc1) in the coming weeks
with your comments addressed.

They are indeed commands - and using caps is a bit of a hack. The
benefit here is that all the Realm commands are behind the one
KVM_CAP_ARM_RME.

The options I can see are:

a) What I've got here - (ab)using KVM_ENABLE_CAP to perform commands.

b) Add new ioctls for each of the above stages (so 5 new ioctls on top
of the CAP for discovery). With any future extensions requiring new ioctls.

c) Add a single new multiplexing ioctl (along with the CAP for discovery).

I'm not massively keen on defining a new multiplexing scheme (c), but
equally (b) seems like it's burning through ioctl numbers. Which led me
to stick with (a) which at least keeps the rebasing simple (there's only
the one CAP number which could conflict) and there's already a
multiplexing scheme.

But I'm happy to change if there's consensus a different approach would
be preferable.

Thanks,

Steve

>> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256		0
>> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512		1
>> +
>> +#define KVM_CAP_ARM_RME_RPV_SIZE 64
>> +
>> +/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
>> +#define KVM_CAP_ARM_RME_CFG_RPV			0
>> +#define KVM_CAP_ARM_RME_CFG_HASH_ALGO		1
>> +#define KVM_CAP_ARM_RME_CFG_SVE			2
>> +#define KVM_CAP_ARM_RME_CFG_DBG			3
>> +#define KVM_CAP_ARM_RME_CFG_PMU			4
>> +
>> +struct kvm_cap_arm_rme_config_item {
>> +	__u32 cfg;
>> +	union {
>> +		/* cfg == KVM_CAP_ARM_RME_CFG_RPV */
>> +		struct {
>> +			__u8	rpv[KVM_CAP_ARM_RME_RPV_SIZE];
>> +		};
>> +
>> +		/* cfg == KVM_CAP_ARM_RME_CFG_HASH_ALGO */
>> +		struct {
>> +			__u32	hash_algo;
>> +		};
>> +
>> +		/* cfg == KVM_CAP_ARM_RME_CFG_SVE */
>> +		struct {
>> +			__u32	sve_vq;
>> +		};
>> +
>> +		/* cfg == KVM_CAP_ARM_RME_CFG_DBG */
>> +		struct {
>> +			__u32	num_brps;
>> +			__u32	num_wrps;
>> +		};
>> +
>> +		/* cfg == KVM_CAP_ARM_RME_CFG_PMU */
>> +		struct {
>> +			__u32	num_pmu_cntrs;
>> +		};
>> +		/* Fix the size of the union */
>> +		__u8	reserved[256];
>> +	};
>> +};
>> +
>> +struct kvm_cap_arm_rme_populate_realm_args {
>> +	__u64 populate_ipa_base;
>> +	__u64 populate_ipa_size;
>> +};
>> +
>> +struct kvm_cap_arm_rme_init_ipa_args {
>> +	__u64 init_ipa_base;
>> +	__u64 init_ipa_size;
>> +};
>> +
>>  /* Device Control API on vcpu fd */
>>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>>  #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 20522d4ba1e0..fec1909e8b73 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1176,6 +1176,8 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>>  #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>>  
>> +#define KVM_CAP_ARM_RME 300 // FIXME: Large number to prevent conflicts
>> +
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>>  struct kvm_irq_routing_irqchip {
> 

