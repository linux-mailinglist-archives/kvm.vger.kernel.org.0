Return-Path: <kvm+bounces-16476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 774FF8BA68E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 07:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64847B21EED
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 05:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE419139590;
	Fri,  3 May 2024 05:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MgS1IHrR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1A5139586
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 05:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714713232; cv=none; b=ZohyH6cLW9vp921b3mepAYvw5zy1GdFShBYjN9binLC0yXxeqQCOcy35DOp6F60wh80hzayuA9zOdXvJhk/Gu9oQ2cnDsB2UsEfdaa/bhdv0bAd5pcA8s1vsh94Dzh/uV73hkIaeYjoaCOzMmNEr8ohpaiqjNcah/t+Pu9QLUJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714713232; c=relaxed/simple;
	bh=RT9/PmKCnW4nOT5ejHyHi2G/78U2RlAU3posvNIoMnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=baG3/3eyaQyo+xNr+3xclBFSEudfml4E1sFmPCxtYiK1o2LHascZESuxbQ5pMlKezPNP0O2dOhbVYli9qZWwX3JNhqTeoLYMsxrFHlyjMrQIS1SKddQIDFD3CU5iBRNoXo4w+MmY+BGn3gmUxvYmuEgqV52eXLsmbz+Jp2jQil8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MgS1IHrR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714713229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Opojcr/NBDOoIzZkhJbTlqDTHfqUYKezeK7i6rDG2Vg=;
	b=MgS1IHrRkUWANqZPw+Uu7yS9TrpR4+tUs9CAtRRhMrMgyUJfpQtA9DvSh6yLYwS3wvFkRs
	61PAGi0OMmOsX1Zkc7g71KlRPMOzkIjRF4IUPwkSF7wMoBj6smiSeWCoDhx6BiVuv7jukw
	ZbbVqcMIjcl82fkFjyAMJtHkoJVSelY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-5umPQb-6PNaeXDk9i0IYfg-1; Fri, 03 May 2024 01:13:47 -0400
X-MC-Unique: 5umPQb-6PNaeXDk9i0IYfg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79088c219ccso1313433185a.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 22:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714713227; x=1715318027;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Opojcr/NBDOoIzZkhJbTlqDTHfqUYKezeK7i6rDG2Vg=;
        b=qCKbfUxmppEd08qKRyqNnDmiDYBP5qWbWI4nVxayDAAiINY4ObaRi9iBFPWea9rCvv
         E4w66eR0rHHrxkw8apSbnAYNOtBKq+on7hu/scYkqiYAEyjDD/tnc4e2svgXaC4LPbJ0
         sHWEyvrrMxp8al3HWwedAoqPsgUarEldgZgW19fYUbuvXjZHl6I2IfUT8/8Mqec5Ph/d
         VMO7jcn4Oy3QM9Iw79s/u+WhAGbbvU5YUIR1peXD5L2cWVr4xEZhlYvRa30R1e/vnpPm
         MI3bk4JC+c8qOWt8SF8vIHlfAerFWIjrt45dS1KZ9ZPgouhOfaHHOsRAePdXlu+j8tjK
         dFBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU3HSFpX9yS2SdlA+Dlbc5gE8Px8U1Bv37u7e5BW+djh87S2SJl/vag52gr6NbBrC4tq8ngGPknJW4dqEWpNTDVj/K
X-Gm-Message-State: AOJu0YynePUScvQYzSvaFkojI81ewsG2OZTdGOX88XhdBZW4M0WX7dV/
	6wN7KZBLwv/rp9tYu74CtkxA8eyJQvaeIfkOjCvmW314G6qT1iAhTtAZMDvI1pT+k51GYwqDYec
	fuph8EAkZ4vqZVoamdZpV51DWg+5hNSokeXuIbyaZjzEQsDf0lg==
X-Received: by 2002:a05:620a:172b:b0:78e:d2e7:3e9e with SMTP id az43-20020a05620a172b00b0078ed2e73e9emr2131183qkb.68.1714713227284;
        Thu, 02 May 2024 22:13:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9BdZ/K1alGXgb2csMR8tC5uIoyHecq+rjFXh+y2bCp7O4HtpsnfSxnbJvLhK2n50FqDu/8g==
X-Received: by 2002:a05:620a:172b:b0:78e:d2e7:3e9e with SMTP id az43-20020a05620a172b00b0078ed2e73e9emr2131160qkb.68.1714713226902;
        Thu, 02 May 2024 22:13:46 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id fj15-20020a05622a550f00b00434946547d3sm1183826qtb.53.2024.05.02.22.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 22:13:46 -0700 (PDT)
Message-ID: <4b934481-49f9-42e6-87f5-74318f2597db@redhat.com>
Date: Fri, 3 May 2024 07:13:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, =?UTF-8?Q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 David Woodhouse <dwmw@amazon.co.uk>, Ricardo Koller <ricarkol@google.com>,
 rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20240501112938.931452-1-npiggin@gmail.com>
 <2be99a78-878c-4819-8c42-1b795019af2f@redhat.com>
 <20240502-d231f770256b3ed812eb4246@orel>
 <28975cc5-ef8f-4471-baca-0bb792a62084@redhat.com>
 <D0ZQV7VH839A.3RQVN9RKAGH2N@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <D0ZQV7VH839A.3RQVN9RKAGH2N@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/2024 07.02, Nicholas Piggin wrote:
> On Thu May 2, 2024 at 7:34 PM AEST, Thomas Huth wrote:
>> On 02/05/2024 10.56, Andrew Jones wrote:
>>> On Thu, May 02, 2024 at 10:23:22AM GMT, Thomas Huth wrote:
>>>> On 01/05/2024 13.29, Nicholas Piggin wrote:
>>>>> This is based on upstream directly now, not ahead of the powerpc
>>>>> series.
>>>>
>>>> Thanks! ... maybe you could also rebase the powerpc series on this now? (I
>>>> haven't forgotten about it, just did not find enough spare time for more
>>>> reviewing yet)
>>>>
>>>>> Since v2:
>>>>> - Rebased to upstream with some patches merged.
>>>>> - Just a few comment typos and small issues (e.g., quoting
>>>>>      `make shellcheck` in docs) that people picked up from the
>>>>>      last round.
>>>>
>>>> When I now run "make shellcheck", I'm still getting an error:
>>>>
>>>> In config.mak line 16:
>>>> AR=ar
>>>> ^-- SC2209 (warning): Use var=$(command) to assign output (or quote to
>>>> assign string).
>>>
>>> I didn't see this one when testing. I have shellcheck version 0.9.0.
>>
>> I'm also using 0.9.0 (from Fedora). Maybe we've got a different default config?
> 
> I have 0.10.0 from Debian with no changes to config defaults and no
> warning.

If I understood it correctly, it warns for AR=ar but it does not warn for 
AR=powerpc-linux-gnu-ar ... could you try the first term, too, if you 
haven't done so yet?

>> Anyway, I'm in favor of turning this warning of in the config file, it does
>> not seem to be really helpful in my eyes. What do you think?
> 
> Maybe it would be useful. I don't mind quoting strings usually, although
> for this kind of pattern it's a bit pointless and config.mak is also
> Makefile so that has its own issues. Maybe just disable it for this
> file?

Yes, either for this file only, or globally ... I don't mind. Could you send 
a patch, please?

  Thanks,
   Thomas


