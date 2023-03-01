Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA46A6BF6
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 12:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjCAL4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 06:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjCALz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 06:55:58 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33AB13D088;
        Wed,  1 Mar 2023 03:55:42 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28F652F4;
        Wed,  1 Mar 2023 03:56:25 -0800 (PST)
Received: from [10.57.16.41] (unknown [10.57.16.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A8A43F587;
        Wed,  1 Mar 2023 03:55:39 -0800 (PST)
Message-ID: <5750eead-44f9-260f-283d-4902b5363faf@arm.com>
Date:   Wed, 1 Mar 2023 11:55:37 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 08/28] arm64: RME: Keep a spare page delegated to the
 RMM
Content-Language: en-GB
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
 <20230127112932.38045-9-steven.price@arm.com>
 <20230213184701.00005d3b@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230213184701.00005d3b@gmail.com>
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

On 13/02/2023 16:47, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:12 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> Pages can only be populated/destroyed on the RMM at the 4KB granule,
>> this requires creating the full depth of RTTs. However if the pages are
>> going to be combined into a 4MB huge page the last RTT is only
>> temporarily needed. Similarly when freeing memory the huge page must be
>> temporarily split requiring temporary usage of the full depth oF RTTs.
>>
>> To avoid needing to perform a temporary allocation and delegation of a
>> page for this purpose we keep a spare delegated page around. In
>> particular this avoids the need for memory allocation while destroying
>> the realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_rme.h | 3 +++
>>  arch/arm64/kvm/rme.c             | 6 ++++++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index 055a22accc08..a6318af3ed11 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -21,6 +21,9 @@ struct realm {
>>  	void *rd;
>>  	struct realm_params *params;
>>  
>> +	/* A spare already delegated page */
>> +	phys_addr_t spare_page;
>> +
>>  	unsigned long num_aux;
>>  	unsigned int vmid;
>>  	unsigned int ia_bits;
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 9f8c5a91b8fc..0c9d70e4d9e6 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -148,6 +148,7 @@ static int realm_create_rd(struct kvm *kvm)
>>  	}
>>  
>>  	realm->rd = rd;
>> +	realm->spare_page = PHYS_ADDR_MAX;
>>  	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
>>  
>>  	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
>> @@ -357,6 +358,11 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  		free_page((unsigned long)realm->rd);
>>  		realm->rd = NULL;
>>  	}
>> +	if (realm->spare_page != PHYS_ADDR_MAX) {
>> +		if (!WARN_ON(rmi_granule_undelegate(realm->spare_page)))
>> +			free_page((unsigned long)phys_to_virt(realm->spare_page));
> 
> Will the page be leaked (not usable for host and realms) if the undelegate
> failed? If yes, better at least put a comment.

Yes - I'll add a comment.

In general being unable to undelegate a page points to a programming
error in the host. The only reason the RMM should refuse the request is
it the page is in use by a Realm which the host has configured. So the
WARN() is correct (there's a kernel bug) and the only sensible course of
action is to leak the page and limp on.

Thanks,

Steve

>> +		realm->spare_page = PHYS_ADDR_MAX;
>> +	}
>>  
>>  	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
>>  	for (i = 0; i < pgd_sz; i++) {
> 

