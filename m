Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B09669F8DD
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 17:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjBVQSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 11:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjBVQSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 11:18:46 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8306E1B30B;
        Wed, 22 Feb 2023 08:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=HfJCJvs/vmINR8JlrJ4yvua1FzzDNAFMvusMr/l33Og=; b=f6p/RpPWtzVHAZ7tcf4tY8uHkO
        SxPEB2cpaRGZajOpxQupqPmwVeXadjJ2AQppRGareITjyaIb4+OndAQT7EpaLpW34xi5JwAgtljHU
        oJhN1a57W5VLzjSB7WqQbdOMo3mcTRmmtO2EM9IKbly7f9M30GEfDVT0+b3Ov0XpAxMe3FsejfWkw
        +77sRU3gQ/kxjSG+GhaRmGp7kTU61NcZY4/tI9sfcbdRweOmBLQZBApCCPfumcWo/qNdfoezIU/eL
        0npSR8O3yIn2mgYg5/X9C8C8R0xIsLED45rCeIcHnYWWCACcuLZZgaJ5+tISX/3Xv3EI2H7jvbmiN
        68GZWong==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUrpK-00D0EZ-Rt; Wed, 22 Feb 2023 16:18:42 +0000
Message-ID: <b69b7e54-4af4-be81-63f7-14d20e7973b5@infradead.org>
Date:   Wed, 22 Feb 2023 08:18:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] KVM: SVM: hyper-v: placate modpost section mismatch error
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20230222073315.9081-1-rdunlap@infradead.org>
 <87k0094wib.fsf@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <87k0094wib.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/22/23 06:15, Vitaly Kuznetsov wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
> 
>> modpost reports section mismatch errors/warnings:
>> WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
>> WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
>> WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
>>
>> Marking svm_hv_hardware_setup() as __init fixes the warnings.
>>
>> I don't know why this should be needed -- it seems like a compiler
>> problem to me since the calling function is marked as __init.
>>
>> This "(unknown) (section: .init.data)" all refer to svm_x86_ops.
>>
>> Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Vineeth Pillai <viremana@linux.microsoft.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: kvm@vger.kernel.org
>> ---
>>  arch/x86/kvm/svm/svm_onhyperv.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -- a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
>> --- a/arch/x86/kvm/svm/svm_onhyperv.h
>> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
>> @@ -30,7 +30,7 @@ static inline void svm_hv_init_vmcb(stru
>>  		hve->hv_enlightenments_control.msr_bitmap = 1;
>>  }
>>  
>> -static inline void svm_hv_hardware_setup(void)
>> +static inline __init void svm_hv_hardware_setup(void)
>>  {
>>  	if (npt_enabled &&
>>  	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
>>
> 
> There's a second empty svm_hv_hardware_setup() implementation 50 lines
> below in the same file for !if IS_ENABLED(CONFIG_HYPERV) case and I
> think it needs to be marked as '__init' as well.
> 

I saw that. I can make that change also. I was optimistic that since it is
empty, gcc would not be fooled by it.

v2 later today.

thanks.
-- 
~Randy
