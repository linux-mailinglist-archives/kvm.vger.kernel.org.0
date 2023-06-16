Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDA2733245
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 15:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344977AbjFPNeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 09:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbjFPNeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 09:34:00 -0400
X-Greylist: delayed 2316 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Jun 2023 06:33:57 PDT
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD3435AC;
        Fri, 16 Jun 2023 06:33:57 -0700 (PDT)
Received: from [167.98.27.226] (helo=[10.35.6.111])
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1qA8yv-009RVR-6E; Fri, 16 Jun 2023 13:55:14 +0100
Message-ID: <f0026ebc-aa35-6242-fab2-02ee35afa8b2@codethink.co.uk>
Date:   Fri, 16 Jun 2023 13:55:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] riscv: kvm: define vcpu_sbi_ext_pmu in header
Content-Language: en-GB
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.or
References: <20230616115410.166244-1-ben.dooks@codethink.co.uk>
 <20230616-founder-speech-6f57f22e1412@wendy>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <20230616-founder-speech-6f57f22e1412@wendy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/2023 13:22, Conor Dooley wrote:
> Hey Ben,
> 
> On Fri, Jun 16, 2023 at 12:54:10PM +0100, Ben Dooks wrote:
>> Sparse is giving a warning about vcpu_sbi_ext_pmu not being
>> defined, so add a definition to the relevant header to fix
>> the following:
>>
>> arch/riscv/kvm/vcpu_sbi_pmu.c:81:37: warning: symbol 'vcpu_sbi_ext_pmu' was not declared. Should it be static?
>>
>> Fixes: 3e5e56c60a1477 ("riscv: kvm: move extern sbi_ext declarations to a header")
> 
> You sure this is the right fixes tag? This code didn't exist when I
> wrote that commit, should the fixes tag not be
> 	Fixes: cbddc4c4cb9e ("RISC-V: KVM: Add SBI PMU extension support")
> instead?

I think you're right there.

> Cheers,
> Conor.
> 
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>   arch/riscv/include/asm/kvm_vcpu_sbi.h | 3 +++
>>   arch/riscv/kvm/vcpu_sbi.c             | 4 +---
>>   2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>> index 4278125a38a5..b94c7e958da7 100644
>> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
>> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>> @@ -66,4 +66,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
>>   extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
>>   extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
>>   
>> +#ifdef CONFIG_RISCV_PMU_SBI
>> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
>> +#endif
>>   #endif /* __RISCV_KVM_VCPU_SBI_H__ */
>> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
>> index e52fde504433..c973d92a0ba5 100644
>> --- a/arch/riscv/kvm/vcpu_sbi.c
>> +++ b/arch/riscv/kvm/vcpu_sbi.c
>> @@ -20,9 +20,7 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>>   };
>>   #endif
>>   
>> -#ifdef CONFIG_RISCV_PMU_SBI
>> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
>> -#else
>> +#ifndef CONFIG_RISCV_PMU_SBI
>>   static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
>>   	.extid_start = -1UL,
>>   	.extid_end = -1UL,
>> -- 
>> 2.39.2
>>

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

