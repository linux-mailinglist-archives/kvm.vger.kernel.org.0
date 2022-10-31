Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F028613EF5
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 21:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJaU2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 16:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJaU2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 16:28:13 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5887C12ADA
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 13:28:10 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 29VKRhob4048032
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 31 Oct 2022 13:27:43 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 29VKRhob4048032
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022100601; t=1667248064;
        bh=e+EsO1tMKSa8rfDvUMt00w7B3EmaACAG6w4bBTSiQqA=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=qi66g86durCC382w5immZvLifI1hZqnFQ/g8nrl4JiEqoSRNK++6trH1h9cDLYDhq
         oDN+tJLvdpaCqNoI2COuCfbEmPwbzQvtmURmjIftIWMA61iZ8Mh0rCyVvNEVrxaQD0
         DYuglXsttzc+g1hVvyh17NpdD/xfDiRx9iCbSSxO0rFv9n/MNMuwPuqNOFk+yTgwU/
         EnMqd0I4dsl+hQQh9gm5YpskSpe0S6nyOyqCEB/Y2P16IoOX9/Zz0yKP5BBGTq4nbd
         aKHdJuKrEftMxToXf0newv1378Ue+F/DwBaXlc0kpS/heyyD+59H5pwOGrDF52XsrQ
         lvxjlWEPky87Q==
Date:   Mon, 31 Oct 2022 13:27:42 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Sean Christopherson <seanjc@google.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>
CC:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_KVM=3A_x86=3A_fix_undefined_b?= =?US-ASCII?Q?ehavior_in_bit_shift_for_=5F=5Ffeature=5Fbit?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y2AJIFQlF5C0ozoU@google.com>
References: <20221031113638.4182263-1-cuigaosheng1@huawei.com> <Y2AJIFQlF5C0ozoU@google.com>
Message-ID: <D6AA5A76-46F0-48BA-85B3-C6FD7B1E2A14@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On October 31, 2022 10:42:56 AM PDT, Sean Christopherson <seanjc@google=2Ec=
om> wrote:
>On Mon, Oct 31, 2022, Gaosheng Cui wrote:
>> Shifting signed 32-bit value by 31 bits is undefined, so changing
>> significant bit to unsigned=2E The UBSAN warning calltrace like below:
>>=20
>> UBSAN: shift-out-of-bounds in arch/x86/kvm/reverse_cpuid=2Eh:101:11
>> left shift of 1 by 31 places cannot be represented in type 'int'
>
>PeterZ is contending that this isn't actually undefined behavior given ho=
w the
>kernel is compiled[*]=2E  That said, I would be in favor of replacing the=
 open-coded
>shift with BIT() to make the code a bit more self-documenting, and that w=
ould
>naturally fix this maybe-undefined-behavior issue=2E=20
>
>[*] https://lore=2Ekernel=2Eorg/all/Y1%2FAaJOcgIc%2FINtv@hirez=2Eprogramm=
ing=2Ekicks-ass=2Enet
>
>> ---
>>  arch/x86/kvm/reverse_cpuid=2Eh | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/kvm/reverse_cpuid=2Eh b/arch/x86/kvm/reverse_cpui=
d=2Eh
>> index a19d473d0184=2E=2Eebd6b621d3b8 100644
>> --- a/arch/x86/kvm/reverse_cpuid=2Eh
>> +++ b/arch/x86/kvm/reverse_cpuid=2Eh
>> @@ -98,7 +98,7 @@ static __always_inline u32 __feature_bit(int x86_feat=
ure)
>>  	x86_feature =3D __feature_translate(x86_feature);
>> =20
>>  	reverse_cpuid_check(x86_feature / 32);
>> -	return 1 << (x86_feature & 31);
>> +	return 1U << (x86_feature & 31);
>>  }
>> =20
>>  #define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
>> --=20
>> 2=2E25=2E1
>>=20

One really ought to change the input to unsigned, though, and I would argu=
e >> 5 would be more idiomatic than / 32; / goes with % whereas >> goes wit=
h &; a mishmash is just ugly AF=2E
