Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED62C68D744
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 13:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjBGM4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 07:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBGMz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 07:55:59 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 604C639291;
        Tue,  7 Feb 2023 04:55:58 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DCD0106F;
        Tue,  7 Feb 2023 04:56:40 -0800 (PST)
Received: from [10.57.75.57] (unknown [10.57.75.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E9DD3F71E;
        Tue,  7 Feb 2023 04:55:55 -0800 (PST)
Message-ID: <f849e725-aaa2-40b1-dd67-e8d0b924de6e@arm.com>
Date:   Tue, 7 Feb 2023 12:55:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 06/28] arm64: RME: ioctls to create and configure
 realms
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-7-steven.price@arm.com> <Y+JDNkMpk9Y8ReWM@myrica>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <Y+JDNkMpk9Y8ReWM@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2023 12:25, Jean-Philippe Brucker wrote:
> On Fri, Jan 27, 2023 at 11:29:10AM +0000, Steven Price wrote:
>> +static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
>> +{
>> +	struct kvm_cap_arm_rme_config_item cfg;
>> +	struct realm *realm = &kvm->arch.realm;
>> +	int r = 0;
>> +
>> +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
>> +		return -EBUSY;
> 
> This should also check kvm_is_realm() (otherwise we dereference a NULL
> realm).

Correct, I think this should be done way up in the stack at :

kvm_vm_ioctl_enable_cap() for KVM_CAP_ARM_RME.

> 
> I was wondering about fuzzing the API to find more of this kind of issue,
> but don't know anything about it. Is there a recommended way to fuzz KVM?

Not sure either. kselftests is one possible way to drive these test at 
least for unit-testing the new ABIs. This is something we plan to add.

Thanks for catching this.

Suzuki



> Thanks,
> Jean
> 

