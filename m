Return-Path: <kvm+bounces-25143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF1B9609EA
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 14:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A13EE282052
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 12:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4712D1A2548;
	Tue, 27 Aug 2024 12:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ge/YhBas"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C32519E838
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 12:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761188; cv=none; b=hFz9PoVYm8Ce2XHCayLWDNq6TWo8EkXORN5KgObD+Skki7leSCMmf7H5EU3OeAx4tEAsfeQtSqSdE9bsqVMDzlNfNRC7lt5seUe3fAlIoj+3D/XKllqSdFp05z9xCKCDSOUpdiEBOcUma7nH4hpZgE/NoyTgnSMZiSmtT7VF5kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761188; c=relaxed/simple;
	bh=twLkCssfgp+ODU10TY3w3gBfyanVw61WPzqH4w9Fg7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q/RRmGS2nyS3t7fbJ/pROWGutoRJB9LeRFHbHuumVk5aEc/GzKZjJ1xo3BNR+sOJ2Vm99zb0dk7wE02mUAPvAUjBR/+DtxYaWiosAIrlGklNVNDqpJkMh9JdyW7dBm4wBh/cB4xvX+D2YhH1BiqGp0gv/aCwwwOTTU9AOay2bSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ge/YhBas; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4281faefea9so46495975e9.2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 05:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724761185; x=1725365985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eqag3zaL6UgiUACaEJiE/DH1bZk03oy4FtP+8QLvcAU=;
        b=Ge/YhBas8ZfUh95NqkzHPljEbVoNji7jOAGctsFd2oYRzjYfHwttv81gvWuhbJNKTv
         OGOuu5TMksT+o/nDeiuNWqboaWZcrNvEhQpxbUlJUwJYKrfJk5oxHHebdhC0zQbvuWkT
         Zrj7XV+jByLIjM1VWwddJG9aHRqVZdVK71QXVZMC0+6ECOrr/9FwrcFPqm/lmYYqqiCd
         yQDDSjFDbPPQBSyINUYwMTwg8nJZb6JtsH1xFNAIOWvvpT/RrjaZhbbFmq3gfd6IJE4h
         4oo+c7ZqoZQf4yXEA96uTcIlgbcZAE1L0xIDWwZGDYVgdQmrrhw7bnUDf3qVtksnLe0Q
         OlBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724761185; x=1725365985;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqag3zaL6UgiUACaEJiE/DH1bZk03oy4FtP+8QLvcAU=;
        b=NQVMZtuOYjIMhkLU1JpM52AFG0oqqBfoNi0QZUWnon7pPE+aiZ0FzZK6uLm/wsAcvt
         4KrcgTKL5WjZ1HnCsxbMXuW6jUzG4VU6rL1ea4v4hhW/ZxFw2BM4w5eliaN9xMREsR0A
         CxPr32Lr3RZiOdTqInwwvoi1A3ZrZSawcoimeuBsn7UlBlsHXCwx17kvF3juY6OHjNqr
         ZRj+R1km8OQPpeUAEr8+rFkPn0qDNBgYqIkAIUmb+W5bOXQFK4aTPdSEO4nEbCWdJdqQ
         JjoRzgSBKMreeQdJA/KvSF/K4LbqlDB3OP6dMwwSTASTw5WE/mKOxo+/iO3oDeNWS9Ch
         R6Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXHiWSE2L2TSGzSNBit0Dkjqn/BVmPGL2QQCh4wnz+8qqxXrMGEfFt+C25LovvLf06irw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqGmW92S76QCQ7pDtefGm6PsX4ddVUt6GClqKx6uBxoDLxAgjR
	nVTzy6HLR7P68MS5L5k4/YpN5ScgPeEIGFuphU6EBFU4vBZmD64Bpu/3NbzMELY=
X-Google-Smtp-Source: AGHT+IHBfHxaObeKoOFTTbKlgpyS/QzTHXZPaEZbYMF7sZwGDN2f27zNYxs8rB72hlCBxG2Bb8Qtww==
X-Received: by 2002:a05:600c:5708:b0:428:1fa1:7b92 with SMTP id 5b1f17b1804b1-42b9e3e6d90mr12539535e9.19.1724761184388;
        Tue, 27 Aug 2024 05:19:44 -0700 (PDT)
Received: from [10.20.4.146] (212-5-158-46.ip.btc-net.bg. [212.5.158.46])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730810fdb0sm12940882f8f.15.2024.08.27.05.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 05:19:44 -0700 (PDT)
Message-ID: <40fe0a1d-9ab8-4662-a781-002d70a1587b@suse.com>
Date: Tue, 27 Aug 2024 15:19:41 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
 <a52010f2-d71c-47ee-aa56-b74fd716ec7b@suse.com>
 <2f9dd848f8ea5092a206906aa99928c2fa47389d.camel@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <2f9dd848f8ea5092a206906aa99928c2fa47389d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 26.08.24 г. 20:46 ч., Edgecombe, Rick P wrote:
> On Mon, 2024-08-26 at 17:09 +0300, Nikolay Borisov wrote:
>>> +               /*
>>> +                * Work around missing support on old TDX modules, fetch
>>> +                * guest maxpa from gfn_direct_bits.
>>> +                */
>>
>>
>> Define old TDX module? I believe the minimum supported TDX version is
>> 1.5 as EMR are the first public CPUs to support this, no? Module 1.0 was
>> used for private previews etc? Can this be dropped altogether?
> 
> Well, today "old" means all released TDX modules. This is a new feature under
> development, that KVM maintainers were ok working around being missing for now.
> The comment should be improved.
> 
> See here for discussion of the design and purpose of the feature:
> https://lore.kernel.org/kvm/f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com/
> 
>> It is
>> much easier to mandate the minimum supported version now when nothing
>> has been merged. Furthermore, in some of the earlier patches it's
>> specifically required that the TDX module support NO_RBP_MOD which
>> became available in 1.5, which already dictates that the minimum version
>> we should care about is 1.5.
> 
> There is some checking in Kai's TDX module init patches:
> https://lore.kernel.org/kvm/d307d82a52ef604cfff8c7745ad8613d3ddfa0c8.1721186590.git.kai.huang@intel.com/

Yes, that's why I mentioned this. I have already reviewed those patches :)

> 
> But beyond checking for supported features, there are also bug fixes that can
> affect usability. In the NO_RBP_MOD case we need a specific recent TDX module in
> order to remove the RBP workaround patches.

My point was that if having the NO_RPB_MOD implied that the CPUID 
0x8000000 configuration capability is also there (not that there is a 
direct connection between the too but it seems the TDX module isn't 
being updated that often, I might be wrong of course!), there is no 
point in having the workaround as NO_RPB_MOD is the minimum required 
version.

Anyway, this was an assumption on my part.

> 
> We could just check for a specific TDX module version instead, but I'm not sure
> whether KVM would want to get into the game of picking preferred TDX module
> versions. I guess in the case of any bugs that affect the host it will have to
> do it though. So we will have to add a version check before live KVM support
> lands upstream.
> 
> Hmm, thanks for the question.

