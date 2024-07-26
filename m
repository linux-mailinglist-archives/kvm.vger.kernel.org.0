Return-Path: <kvm+bounces-22308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DE893D00F
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 11:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A50B61F21A9E
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6A5176FC5;
	Fri, 26 Jul 2024 09:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TM1tYn5J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18BA13C8F9
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 09:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721984722; cv=none; b=Dk3jkKBoFa/YAGviHKj84jQ23/eVM1trEmvtyei0+yGOtbwCWzhjfh5FE6nQDFCWcFh94XxchIdw9Sl3KLC0N3ISBp0oQdqZA69v2nUT4dISKi5qaYbWKoHAF+kaybaIBPy9u36SM8gM6WhUPZSm+m7M5/D52gZkB+9UDHHsl3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721984722; c=relaxed/simple;
	bh=TfMAVMmemdCyQxc+aatfEmZS83cBvnNOc+9YsE89iug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DD3yQBDYS3Yoevb1Z4jTv49Y+M4kVZVhQnq3qRw2SuCjQYRni5zkH8mHqecwsxEwyH3AXZFuFjZqJxhvcQt4Io9w5cERXdxRSPW6/PdAvKGNeuXy4ZXPzsMMT7bLs2TdjtXG4+YcX154mxw+H3jAs5sCIDqiAKQKuBGBwpz7ukc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TM1tYn5J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721984719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HRGCaxSvc666yYmWNbyZKl/wJUaVbOHVwo8Yj4hCL/0=;
	b=TM1tYn5J5riqUsN9Tzkjp03Zn24jILzicoZzLrdBxACAtXwoqluAYjqq2WM5nJzi1f5Hla
	Gm8DOJsvqLfVGH433oiOsOvhNBOJPsGy5MwoNwg3suUH+l19eToRZUAYavwiXHstpFDwWt
	jPvLJwrNRVufTOTBgoLCmCGH2GSSSPw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-GhWltfUxPv6Kxp88BgizAg-1; Fri, 26 Jul 2024 05:05:17 -0400
X-MC-Unique: GhWltfUxPv6Kxp88BgizAg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4280291f739so14037405e9.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 02:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721984716; x=1722589516;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRGCaxSvc666yYmWNbyZKl/wJUaVbOHVwo8Yj4hCL/0=;
        b=GNmZmGT9tjgEwWzKdPrLmUYttgZ/YtWTVZp+4CguiJwpR2GI6bWbFX9Ge8CsprG1Z0
         t+LafPr39Mki9zSc+XYYCdz8VJL3Lf7vrlLzoDd8Nxg2FI5rUmVJ8LHPUnuXPhIap7Q0
         vDHTklOloVpbVIvlyvedzUy0J6KCqrCS3QUl44jT/b4Lhy5nsO7TFS2jKSv0E307G7cg
         VjxxKticfhmOFNOa7NCvjilAUliczQSymchmQETv/vEStINDs152vsRBnq5kX3eKOuZQ
         cR+0nr5h0HFhQBrbrCUZE8hymjBPd1t+bv5/Dh3678NkjN+GabLc6VfLwq99Yo0n3unr
         qWzQ==
X-Gm-Message-State: AOJu0YwLXuLYshBt7k4YF3GF732MqxT+tAuiM59BAqd1CNih5JINjcYp
	DB6Or5g/F2DhBoQk4YJ4tDlbbcDE3Jkziyq7wq2iMOFjN337JH+1hhJLndM7ZdS5Frz6RiMOb2p
	ggTvV7Cif7Pnp2O79Vr8X61FpVp4Rj2HQiEgUNTg8m4RF9IAXrg==
X-Received: by 2002:a05:600c:19d2:b0:426:6f5f:9da6 with SMTP id 5b1f17b1804b1-4280578b9b6mr35448345e9.27.1721984716019;
        Fri, 26 Jul 2024 02:05:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwk07jUaAT8ojnh2s98h6UPE6SOVmQ7wq5CBJHKGpwRHZk1gVq/4L8tg0+qalxenlpWVy2Gg==
X-Received: by 2002:a05:600c:19d2:b0:426:6f5f:9da6 with SMTP id 5b1f17b1804b1-4280578b9b6mr35447975e9.27.1721984715417;
        Fri, 26 Jul 2024 02:05:15 -0700 (PDT)
Received: from [10.33.192.191] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42805730e47sm69535525e9.1.2024.07.26.02.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 02:05:15 -0700 (PDT)
Message-ID: <8c9ca85f-0995-4c34-bb57-5a8490f74b50@redhat.com>
Date: Fri, 26 Jul 2024 11:05:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
To: Nicholas Piggin <npiggin@gmail.com>,
 Segher Boessenkool <segher@kernel.crashing.org>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>,
 Marc Hartmayer <mhartmay@linux.ibm.com>, kvm-riscv@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
References: <20240612044234.212156-1-npiggin@gmail.com>
 <20240612082847.GG19790@gate.crashing.org>
 <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
 <20240614010856.GK19790@gate.crashing.org>
 <D1ZLRVNGPWTV.5H76A3E8DJCV@gmail.com> <D2Z6GP2VFOJ8.2KU7OB25CUXTC@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <D2Z6GP2VFOJ8.2KU7OB25CUXTC@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/07/2024 06.15, Nicholas Piggin wrote:
> On Fri Jun 14, 2024 at 6:38 PM AEST, Nicholas Piggin wrote:
>> On Fri Jun 14, 2024 at 11:08 AM AEST, Segher Boessenkool wrote:
>>> On Fri, Jun 14, 2024 at 10:43:39AM +1000, Nicholas Piggin wrote:
>>>> On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
>>>>> On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
>>>>>> arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
>>>>>> in dependency chains that cause them to be made as intermediate files,
>>>>>> which get removed when make finishes. This results in unnecessary
>>>>>> partial rebuilds. If make is run again, this time the .aux.o targets
>>>>>> are not intermediate, possibly due to being made via different
>>>>>> dependencies.
>>>>>>
>>>>>> Adding .aux.o files to .PRECIOUS prevents them being removed and solves
>>>>>> the rebuild problem.
>>>>>>
>>>>>> s390x does not have the problem because .SECONDARY prevents dependancies
>>>>>> from being built as intermediate. However the same change is made for
>>>>>> s390x, for consistency.
>>>>>
>>>>> This is exactly what .SECONDARY is for, as its documentation says,
>>>>> even.  Wouldn't it be better to just add a .SECONDARY to the other
>>>>> targets as well?
>>>>
>>>> Yeah we were debating that and agreed .PRECIOUS may not be the
>>>> cleanest fix but since we already use that it's okay for a
>>>> minimal fix.
>>>
>>> But why add it to s390x then?  It is not a fix there at all!
>>
>> Eh, not a big deal. I mentioned that in the changelog it doesn't seem to
>> pracicaly fix something. And I rather the makefiles converge as much as
>> possible rather than diverge more.
>>
>> .SECONDARY was added independently and not to fix this problem in
>> s390x. And s390x has .SECONDARY slightly wrong AFAIKS. It mentions
>> .SECONDARY: twice in a way that looks like it was meant to depend on
>> specific targets, it actually gives it no dependencies and the
>> resulting semantics are that all intermediate files in the build are
>> treated as secondary. So somethig there should be cleaned up. If the
>> .SECONDARY was changed to only depend on the .gobj and .hdr.obj then
>> suddenly that would break .aux.o if I don't make the change.
>>
>> So I'm meaning to work out what to do with all that, i.e., whether to
>> add blanket .SECONDARY for all and trim or remove the .PRECIOUS files,
>> or remove s390x's secondary, or make it more specific, or something
>> else. But it takes a while for me to do makefile work.
> 
> Hi Thomas,
> 
> Ping on this patch?

I assumed that Marc would chime in on the s390x part here?

  Thomas



