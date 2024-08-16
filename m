Return-Path: <kvm+bounces-24350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E90195414A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 07:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C120F1C21ADE
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 05:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C176182490;
	Fri, 16 Aug 2024 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0cK1Ctv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4BA81ADA
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 05:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723787078; cv=none; b=SsNtF8we2W5z3mv9bGi39f8D1MGQlrkv2pbi/5p5VScDKHuIuxTzkSe7nx+GaDC74L1bZlhZ9mNhsbpZfRnuokB9DvaKA4qrMZ7jOJSimvwR/tgjEutLepQbwgpwTU4dcB02u5lFKQCI+1gInemAf060WKYKx3MHue4cS6fjejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723787078; c=relaxed/simple;
	bh=FUnYa6DkH4IR3VXM443mUghfrqGS9k5yF2vIhCeCsug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iOuVg5Km1AY+pzTK0co4PsooMOXJIBAAdKKLHSOHqqnTUhMtij3kTPEd4KsZJJ79gQc9of9T9yw2YL9nZnABsOIxSbKZrNNSfiJJXxFrsazGy6bcHMGlT9R62g4zxFYMKxPHfvcAQXf5df/m4aAv8sa6hIc7PhqInWWQe2m62Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0cK1Ctv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723787074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6pTYg5o9UAGCHtm5Tigay0B9CNL8ajmd2i2aw5pk7nc=;
	b=C0cK1Ctv2zuGY11wpj3nMgSP4Q3w3+ppV6xO9mL5h5dTeg6QMZsz2SEeOlVvHWgMEIumgY
	HLmutofwWD3VhxqpmAWeIZVgCg3VY3nFt6u5dJ/UEC/N/5NpUEubXZSiX77i7TH2nkYx1C
	xtw1MQYsFutZyKy5sOXY6m1fj3rW0Hs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-zI-qX4gtO0KVEuNMzWAN0g-1; Fri, 16 Aug 2024 01:44:33 -0400
X-MC-Unique: zI-qX4gtO0KVEuNMzWAN0g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42807a05413so11177155e9.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 22:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723787072; x=1724391872;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6pTYg5o9UAGCHtm5Tigay0B9CNL8ajmd2i2aw5pk7nc=;
        b=U5EAlQ3jf6clwuIrvlSjI98QVI+Es9A03iB/XYVHE4nuuH5dCbiwY0JdfQ3/ENPoZu
         ta0ij4imwERGkqhUhBDO9lmFhMWER6nKsiNACbSc3DXSUfWKX5SKAFCdGNRXo+fwrneJ
         a0bN4T0iTp5A0olCrachot35E4qldE+F83+nBfIpIuUPQelt1DtHDYOnioDzyl2DlD7T
         bUz9kWnGr7Ket0uRFx/fUP0YuKiclMQSC9EHk5de8ek4rBHSScLcej1AR3V8KX0lENr2
         Wftad1jt2YxycLZW9Fxd+hU4IDfCPQSPcK5HOFyxArIXUVRh5NIx+zaiHpBskeXp/HAQ
         XP2A==
X-Forwarded-Encrypted: i=1; AJvYcCXWJJfC5A+03yG0+UvlSEHOnADAgX6033VH0HAk9V7HtbP8Kv0Kjc0eDwP8nlysyEqbUyj3xIkhBT2OwUfnTzpqE3Ka
X-Gm-Message-State: AOJu0YwnI/blnGIr+1PH7pjVhz7R4g876k7vm2XvbaQHAz3GPWnBGd5l
	FaCWajJKanqL85gq0YLjdt7UX5M6GqRA0vnvt+oSs8w+e2XBKfEpQXqeAUrl0xGwoXpxkvyah7Z
	7x71j7YdpbHdCPV+D74apUfydl8nkGAKyndBn4igkDxi6Sz2iOQ==
X-Received: by 2002:adf:e388:0:b0:368:4e28:47f7 with SMTP id ffacd0b85a97d-37194314f7emr870093f8f.6.1723787071689;
        Thu, 15 Aug 2024 22:44:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwO6vjWgIisfOS+yFSGJsBwXt8nBZXP1ahtaBXuPvOLnVwCE1dKIJRERg7nGsOFrCCJv1+zw==
X-Received: by 2002:adf:e388:0:b0:368:4e28:47f7 with SMTP id ffacd0b85a97d-37194314f7emr870075f8f.6.1723787071144;
        Thu, 15 Aug 2024 22:44:31 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-177-15.web.vodafone.de. [109.43.177.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3718985ae26sm2849734f8f.55.2024.08.15.22.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 22:44:30 -0700 (PDT)
Message-ID: <66f144dd-f098-443b-8a34-d68bbdecc48f@redhat.com>
Date: Fri, 16 Aug 2024 07:44:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
To: Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org,
 Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org>
 <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
 <Zr3g7lEfteRpNYVC@redhat.com>
 <CAFEAcA8xMjd2w5tT-sMcHKuKGXbqZg4HtTerNFG=_YpNRVVhxQ@mail.gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CAFEAcA8xMjd2w5tT-sMcHKuKGXbqZg4HtTerNFG=_YpNRVVhxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/08/2024 19.54, Peter Maydell wrote:
> On Thu, 15 Aug 2024 at 12:05, Daniel P. Berrangé <berrange@redhat.com> wrote:
>>
>> On Thu, Aug 15, 2024 at 11:12:39AM +0100, Peter Maydell wrote:
>>> On Wed, 14 Aug 2024 at 23:42, Pierrick Bouvier
>>> <pierrick.bouvier@linaro.org> wrote:
>>>>
>>>> When building with gcc-12 -fsanitize=thread, gcc reports some
>>>> constructions not supported with tsan.
>>>> Found on debian stable.
>>>>
>>>> qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
>>>>     36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
>>>>        |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>
>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> ---
>>>>   meson.build | 10 +++++++++-
>>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/meson.build b/meson.build
>>>> index 81ecd4bae7c..52e5aa95cc0 100644
>>>> --- a/meson.build
>>>> +++ b/meson.build
>>>> @@ -499,7 +499,15 @@ if get_option('tsan')
>>>>                            prefix: '#include <sanitizer/tsan_interface.h>')
>>>>       error('Cannot enable TSAN due to missing fiber annotation interface')
>>>>     endif
>>>> -  qemu_cflags = ['-fsanitize=thread'] + qemu_cflags
>>>> +  tsan_warn_suppress = []
>>>> +  # gcc (>=11) will report constructions not supported by tsan:
>>>> +  # "error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’"
>>>> +  # https://gcc.gnu.org/gcc-11/changes.html
>>>> +  # However, clang does not support this warning and this triggers an error.
>>>> +  if cc.has_argument('-Wno-tsan')
>>>> +    tsan_warn_suppress = ['-Wno-tsan']
>>>> +  endif
>>>
>>> That last part sounds like a clang bug -- -Wno-foo is supposed
>>> to not be an error on compilers that don't implement -Wfoo for
>>> any value of foo (unless some other warning/error would also
>>> be emitted).
>>
>> -Wno-foo isn't an error, but it is a warning... which we then
>> turn into an error due to -Werror, unless we pass -Wno-unknown-warning-option
>> to clang.
> 
> Which is irritating if you want to be able to blanket say
> '-Wno-silly-compiler-warning' and not see any of that
> warning regardless of compiler version. That's why the
> gcc behaviour is the way it is (i.e. -Wno-such-thingy
> is neither a warning nor an error if it would be the only
> warning/error), and if clang doesn't match it that's a shame.

I thought that Clang would behave the same way as GCC, but apparently it 
does not (anymore?):

$ gcc -Wno-flux-capacitors testprg.c -o testprg
$ clang -Wno-flux-capacitors testprg.c -o testprg
warning: unknown warning option '-Wno-flux-capacitors' 
[-Wunknown-warning-option]
1 warning generated.

  Thomas


