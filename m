Return-Path: <kvm+bounces-12324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F6088183E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 21:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AACBB21873
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 20:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0592285927;
	Wed, 20 Mar 2024 20:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e8NiPO6F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700716BFBA
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 20:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710965106; cv=none; b=FkbFkofNo4/38o/vhdYs4L1iqzOgAZ4teD4nHV2PqLldhbmoAJ5Jb5Gaid08fDqpjJHxgjqX7ugA/ticFST6IeXRDMYMTTaqsVoU32mpSB7Me8Dbf7LcFhLunEniNJ7kCGROVp/7ukXYw2q/bCr2UTk8pJCmeYNHlEm2XziqIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710965106; c=relaxed/simple;
	bh=wBmSCFwHzxpwW7pmKAc876OdyDYp89CQqCU1f/4RM9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=awyoiIhCVt2zTM4IWvfmjKmvSQ4RuAg34I3/iTjI9hzW/BXgNPBotYFv2r2dfWlC3dR8jUqpMQYgTUHZa80VFb1OffxOljIQTWw77dv+A5nOwJHEQw/5d8cbqFOWpS2aarsLW7Cc1FVtuMYMj95B3HqG27q14SvV99HehWyMgHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e8NiPO6F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710965100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=012LzPJqZ7pcVFoiA92zIi0nHnXpZdtZrOPdZIgp9fg=;
	b=e8NiPO6Fx1kUFBEMH9Yv9N/2+V2EMcy19eCwNiH4HT6RxVVy6iuY56YWywniJEtUFehPaN
	4D48neISWtbzmzoCRycZD7R7dn8a5lcLNWhfLwWl9o3NQfAxGGpFlbSWQdiy/7n4dspD20
	8egmVbLstDq1zihj0OgMLtkaRQQFWY4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-sCIN2HzPP3i9Lmkuzt0Rbw-1; Wed, 20 Mar 2024 16:04:56 -0400
X-MC-Unique: sCIN2HzPP3i9Lmkuzt0Rbw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41408ff5eabso1115565e9.2
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 13:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710965095; x=1711569895;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=012LzPJqZ7pcVFoiA92zIi0nHnXpZdtZrOPdZIgp9fg=;
        b=rubsAIaCxEZkeACCiRC2a+bD+152yzkxUL4gaeffOK3gEJ8Iwm18avpxyG9rq0t/5X
         c2dFkqkaRjwJ/r1v/FdK/neb91bH7S1GUzTSDw7mqqMJ/nxt2lh4EqdGOKVAVjWupTqV
         cIwKxoOEdjH67dpVblJutYp9My2X8E1sER1nLj//TUOrocbHQMbYf0ybPXiPYLwDnsgh
         +P/dVouaGCg46HdOmtT/Emxdj7d6gh0Zq3siTbxhxAGRD7nQDGGmQCXr3MuS18xSknYX
         46nEAFkD+V0E8zyCnI+eeEJ0yE4z1NJu07ImvJuY5mk25HDiXooit6gsT4ZSFjNQdUxI
         n7Rg==
X-Forwarded-Encrypted: i=1; AJvYcCXojm6693o+cqC5hXVci6KZq165kECWEAIW+8x/DsaO8pG7j6kHsgEJiRSPNjikWpwyUfh3ScTv+Y2H95fp0EDqnB/T
X-Gm-Message-State: AOJu0YyisZVBLZirDWqN6HXGEMlmALqouDMWAPiuukdBAbfgcGYJp5yk
	nwW5DY1GtNcQxvKnENd5SrhZmO6Soh1P8vyRYyBha3uaNdJGPq8H9IxYgpMFZ92+F3ByUkZtNAn
	+I8kqAdg+oZLtiEKuFTGzsTvJF60mhNAWxqXAJ0JU2Yk4Tu671HYIuCF2BA==
X-Received: by 2002:a05:600c:46cd:b0:412:f015:6fa6 with SMTP id q13-20020a05600c46cd00b00412f0156fa6mr5308412wmo.28.1710965094756;
        Wed, 20 Mar 2024 13:04:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7phc8DqkQGsYqmpZpN1TJx58GypLGtl9t9SwS8/rTvEfh1EfGfwdMOiUYisd5DBWxmU5lNA==
X-Received: by 2002:a05:600c:46cd:b0:412:f015:6fa6 with SMTP id q13-20020a05600c46cd00b00412f0156fa6mr5308394wmo.28.1710965094347;
        Wed, 20 Mar 2024 13:04:54 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:c400:9a2:3872:9372:fbc? (p200300cbc709c40009a2387293720fbc.dip0.t-ipconnect.de. [2003:cb:c709:c400:9a2:3872:9372:fbc])
        by smtp.gmail.com with ESMTPSA id p11-20020a05600c468b00b004133365bbc6sm3204459wmo.19.2024.03.20.13.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 13:04:53 -0700 (PDT)
Message-ID: <48cafaf1-83df-40f3-905a-472cb5f9256e@redhat.com>
Date: Wed, 20 Mar 2024 21:04:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/49] physmem: Introduce
 ram_block_discard_guest_memfd_range()
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-12-michael.roth@amd.com>
 <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
 <20240320173802.bygfnr3ppltkoiq4@amd.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240320173802.bygfnr3ppltkoiq4@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.03.24 18:38, Michael Roth wrote:
> On Wed, Mar 20, 2024 at 10:37:14AM +0100, David Hildenbrand wrote:
>> On 20.03.24 09:39, Michael Roth wrote:
>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> When memory page is converted from private to shared, the original
>>> private memory is back'ed by guest_memfd. Introduce
>>> ram_block_discard_guest_memfd_range() for discarding memory in
>>> guest_memfd.
>>>
>>> Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> "Co-developed-by"
>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>
>> Your SOB should go here.
>>
>>> ---
>>> Changes in v5:
>>> - Collect Reviewed-by from David;
>>>
>>> Changes in in v4:
>>> - Drop ram_block_convert_range() and open code its implementation in the
>>>     next Patch.
>>>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>
>> I only received 3 patches from this series, and now I am confused: changelog
>> talks about v5 and this is "PATCH v3"
>>
>> Please make sure to send at least the cover letter along (I might not need
>> the other 46 patches :D ).
> 
> Sorry for the confusion, you got auto-Cc'd by git, which is good, but
> not sure there's a good way to make sure everyone gets a copy of the
> cover letter. I could see how it would help useful to potential
> reviewers though. I'll try to come up with a script for it and take that
> approach in the future.

A script shared with me in the past to achieve that in most cases:

$ cat cc-cmd.sh
#!/bin/bash

if [[ $1 == *gitsendemail.msg* || $1 == *cover-letter* ]]; then
         grep ': .* <.*@.*>' -h *.patch | sed 's/^.*: //' | sort | uniq
fi


And attach to "git send-email ... *.patch": --cc-cmd=./cc-cmd.sh

-- 
Cheers,

David / dhildenb


