Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8B65AB4D6
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiIBPQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbiIBPPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:15:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ECFC80516
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 07:47:44 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1342FED1;
        Fri,  2 Sep 2022 07:47:50 -0700 (PDT)
Received: from [10.57.45.3] (unknown [10.57.45.3])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D383F3FA27;
        Fri,  2 Sep 2022 07:47:41 -0700 (PDT)
Message-ID: <5413e00f-251f-9d48-9cbb-07742feec87f@arm.com>
Date:   Fri, 2 Sep 2022 15:47:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings
 with MTE enabled
Content-Language: en-GB
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Peter Collingbourne <pcc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-7-pcc@google.com> <YxII905jjQz0FH4D@arm.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <YxII905jjQz0FH4D@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2022 14:45, Catalin Marinas wrote:
> On Wed, Aug 10, 2022 at 12:30:32PM -0700, Peter Collingbourne wrote:
>> Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
>> on being able to map guest memory as MAP_SHARED. The current restriction
>> on sharing MAP_SHARED pages with the guest is preventing the use of
>> those features with MTE. Now that the races between tasks concurrently
>> clearing tags on the same page have been fixed, remove this restriction.
>>
>> Signed-off-by: Peter Collingbourne <pcc@google.com>
>> ---
>>  arch/arm64/kvm/mmu.c | 8 --------
>>  1 file changed, 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index d54be80e31dd..fc65dc20655d 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>>  
>>  static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>>  {
>> -	/*
>> -	 * VM_SHARED mappings are not allowed with MTE to avoid races
>> -	 * when updating the PG_mte_tagged page flag, see
>> -	 * sanitise_mte_tags for more details.
>> -	 */
>> -	if (vma->vm_flags & VM_SHARED)
>> -		return false;
> 
> I think this is fine with the locking in place (BTW, it may be worth
> mentioning in the commit message that it's a relaxation of the ABI). I'd
> like Steven to have a look as well when he gets the time, in case we
> missed anything on the KVM+MTE side.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Looks fine to me, and thanks for doing the work: I was never very
pleased with the !VM_SHARED restriction, but I couldn't figure a good
way of getting the locking to work.

Reviewed-by: Steven Price <steven.price@arm.com>
