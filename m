Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0926BC5D9
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 06:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCPFv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 01:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCPFvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 01:51:25 -0400
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE27C4ED3;
        Wed, 15 Mar 2023 22:51:21 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:5da4:0:640:ef2d:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id CEB9260456;
        Thu, 16 Mar 2023 08:51:17 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b420::1:2e] (unknown [2a02:6b8:b081:b420::1:2e])
        by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id GpcvBB0hwqM0-FtYW6EG3;
        Thu, 16 Mar 2023 08:51:17 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1678945877; bh=MmV3iqC5bsbyAV/2LJuRI5otJk5YUkKFYzvzv1ynAM0=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=T3uFjnj96q6dTaVNa/E+ZA5MrgX7V2rKACaOMfdIHMbgmtY7Dbm2/MKN3j8DpBOTt
         L5cX/A2RObrfQstBZrJdvZJkZlyroZ1LdcL3q/7+ddq4WzewlMp9X7XmUd4UV0grgz
         Z8C1u9LyauMBWMgokPf8jLhtXNi13HXzuuWmexjM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <69f0d161-e473-37dc-13a9-c81ec9145de2@yandex-team.ru>
Date:   Thu, 16 Mar 2023 08:51:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] kvm/x86: actually verify that reading MSR_IA32_UCODE_REV
 succeeds
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315195109.580333-1-d-tatianin@yandex-team.ru>
 <ZBInlO18ZlClLbHp@google.com>
Content-Language: en-US
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <ZBInlO18ZlClLbHp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/23 11:16 PM, Sean Christopherson wrote:
> On Wed, Mar 15, 2023, Daniil Tatianin wrote:
>> ...and return KVM_MSR_RET_INVALID otherwise.
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE
>> static analysis tool.
>>
>> Fixes: cd28325249a1 ("KVM: VMX: support MSR_IA32_ARCH_CAPABILITIES as a feature MSR")
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
>> ---
>>   arch/x86/kvm/x86.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 7713420abab0..7de6939fc371 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1661,7 +1661,8 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>>   		msr->data = kvm_caps.supported_perf_cap;
>>   		break;
>>   	case MSR_IA32_UCODE_REV:
>> -		rdmsrl_safe(msr->index, &msr->data);
>> +		if (rdmsrl_safe(msr->index, &msr->data))
>> +			return KVM_MSR_RET_INVALID;
> 
> This is unnecessary and would arguably break KVM's ABI.  KVM unconditionally emulates
> MSR_IA32_UCODE_REV in software and rdmsrl_safe() zeros the result on a fault (see
> ex_handler_msr()).  '0' is a legitimate ucode revid and a reasonable fallback for
> a theoretical (virtual) CPU that doesn't support the MSR.

I see, thanks for the explanation!
