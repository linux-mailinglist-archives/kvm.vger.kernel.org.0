Return-Path: <kvm+bounces-4173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5800380E94F
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 11:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E85F1F21906
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 10:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AD35C09C;
	Tue, 12 Dec 2023 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DB3izigl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611EAA7
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 02:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702377583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zE+kaYHKbfi52ZrgmcrCj/fN/75AkohML4TX96iwLs=;
	b=DB3iziglJR39DobJwRcdNlrOKTBURY5WnpZhvwu1NK1XW3xcIKjgunlUo7AsIbIwetjsGy
	9eHl2Jtq9KC1nV/uRN1H1swcop3cv05bvXFjrOlU08PtSUr/Z7aKHzxA9kDRK9PL0ceBpK
	VvG7ovJ/sG76CFq2w3/NKXyE4OP7Svg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-2fk2wz9HOuq6apjbPeHFHQ-1; Tue, 12 Dec 2023 05:39:42 -0500
X-MC-Unique: 2fk2wz9HOuq6apjbPeHFHQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ca0cf1b72aso41096831fa.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 02:39:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702377580; x=1702982380;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2zE+kaYHKbfi52ZrgmcrCj/fN/75AkohML4TX96iwLs=;
        b=wHC6zTHquqQgIfCo8aWnDBsN9ZXNzy4HjjoaBvTN6ifCdC/J1jMwemmcbApXVM5ge5
         gkRnMO+xXXA6oX1koyfmlnXOCYCNgD/suw2udn4D5jNce5C8SkWOgCcpiK/G1KM9BPhB
         sceqBNklXo4wBAKjWikWFgBdwSXHZkUSt9Bn/CHLI1r0Cs7hbd7ZkycxkjH6zHXFV/S3
         Vf49GUd8tFlyHzyTazeAslMCHFBWz3nmv8pvlep7IXqofKfBkZkOvHx2xMo3s5lMmyQx
         BHt9FTd7kpI3y/cmNe5vfxDs2zOnwLjxQXilFV+ylfWG3wGXsMDLZcq2J+21oCm3JV1b
         lSYg==
X-Gm-Message-State: AOJu0Yxz1Rv7P7/aWNLPY8dMvP36SPQuqEaCXyXgu+cHpZAhB/+DE4rA
	Isjg4dtYUsqyy0KlDcdp6l8RegYifcbVd7asr/qs0R4xEZlw6rMzxRUNGAZg88ewiuXa4jw2orE
	ixZCakY3cA5SJ
X-Received: by 2002:ac2:55b2:0:b0:50b:f881:8627 with SMTP id y18-20020ac255b2000000b0050bf8818627mr1010499lfg.109.1702377580615;
        Tue, 12 Dec 2023 02:39:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5+ZfcUkPdFD8mGJYXluwd2s6gyvHtpKB4oC8M/QPBLHm0ss1UoX2crhgPXwwH6ipyoJH2Ww==
X-Received: by 2002:ac2:55b2:0:b0:50b:f881:8627 with SMTP id y18-20020ac255b2000000b0050bf8818627mr1010496lfg.109.1702377580255;
        Tue, 12 Dec 2023 02:39:40 -0800 (PST)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id a9-20020a5d5709000000b003332aa97101sm10509764wrv.38.2023.12.12.02.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 02:39:39 -0800 (PST)
Message-ID: <184e253d-06c4-419e-b2b4-7cce1f875ba5@redhat.com>
Date: Tue, 12 Dec 2023 11:39:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for aarch64
To: Sean Christopherson <seanjc@google.com>,
 Shaoqin Huang <shahuang@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231208184628.2297994-1-pbonzini@redhat.com>
 <ZXPRGzgWFqFdI_ep@google.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZXPRGzgWFqFdI_ep@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/23 03:29, Sean Christopherson wrote:
> On Fri, Dec 08, 2023, Paolo Bonzini wrote:
>> KVM/Arm supports readonly memslots; fix the calculation of
>> supported_flags in set_memory_region_test.c, otherwise the
>> test fails.
> 
> You got beat by a few hours, and by a better solution ;-)
> 
> https://lore.kernel.org/all/20231208033505.2930064-1-shahuang@redhat.com

Better but also wrong---and my patch has the debatable merit of more
clearly exposing the wrongness.  Testing individual architectures is bad,
but testing __KVM_HAVE_READONLY_MEM makes the test fail when running a new
test on an old kernel.

This scenario of course will fail when the test detects a bug, but readonly
memory is just new functionality (think of the case where RISC-V starts
defining __KVM_HAVE_READONLY_MEM in the future).  For new functionality,
the right thing to do is one of 1) skip the whole test 2) skip the individual
test case 3) code the test to adapt to the old kernel.  The third choice is
rarely possible, but this is one of the cases in which it _is_ possible.

So, the only good way to do this is to get _all_ supported_flags from
KVM_CHECK_EXTENSION(KVM_CAP_USER_MEMORY2).  We can change the value returned
by KVM_CHECK_EXTENSION because KVM_CAP_USER_MEMORY2 has not been included in
any released kernel.  Calling KVM_CHECK_EXTENSION subsumes

         supported_flags |= KVM_MEM_READONLY;
         if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
                 supported_flags |= KVM_MEM_GUEST_MEMFD;

and v2_only_flags would be defined as

         const uint32_t v2_only_flags = ~(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY);

(not guaranteed to work in the future, but good enough since new KVM_MEM_*
flags are a very rare occurrence).  Then, the test checks that the supported
flags are consistent with the value returned by KVM_CHECK_EXTENSION.

Shaoqin, would you give it a shot?

Thanks,

Paolo

> 

>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   tools/testing/selftests/kvm/set_memory_region_test.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
>> index 6637a0845acf..dfd1d1e22da3 100644
>> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
>> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
>> @@ -333,9 +333,11 @@ static void test_invalid_memory_region_flags(void)
>>   	struct kvm_vm *vm;
>>   	int r, i;
>>   
>> -#ifdef __x86_64__
>> +#if defined __aarch64__ || defined __x86_64__
>>   	supported_flags |= KVM_MEM_READONLY;
>> +#endif
>>   
>> +#ifdef __x86_64__
>>   	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
>>   		vm = vm_create_barebones_protected_vm();
>>   	else
>> -- 
>> 2.39.1
>>


