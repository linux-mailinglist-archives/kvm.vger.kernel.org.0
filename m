Return-Path: <kvm+bounces-18635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2692F8D8198
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49AAF1C21519
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0933E86146;
	Mon,  3 Jun 2024 11:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBCrS6+d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0198594E
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415490; cv=none; b=s40jcTO6OrtmTv841rfo83faoAXOF0FBxSdmjpqjmdZewaN7CDUDQMZwSCNgsVSl+2TCd6dPrsKoqo3mPX9i+AGjyPjg3/VEFDRWyBMpUBQz1mtpEV8amzoEfj9aIlcHzVrp1+MdzQHNI9hg9D+vvlrXUJobIDfrzeg12x7Ghak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415490; c=relaxed/simple;
	bh=XRYal3GTCirFOUCbbloZD4Dz8bpTJ45+mdxjcDXQPeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SAOtV+TtGsXwtJWSGRZ7Ud2OrWGDtWMVBv9phpCLwGRkZCNZdzVTAT7wNw5vvM4TEjeI34MivClk6SJmlW9/azCgFNW4VyRRiYcrQv6WH+hEQIvCrILMy4vd6fZ3eUoDRTmOlWe8LW/js5iaog8WwNXQJufAFbD2Udd/9puJrsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBCrS6+d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717415487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vIMhCI/l2CqzYTRvd3bD3lxf2NZCjkM04umQtpaDJMo=;
	b=XBCrS6+diftDISTSfg3mblJE2H3GOG7oGQF8lVEgElP646NgBh8RTR1gIl68cTF39MwQ2t
	WHDPsbzkvre+RM6WUxeuVtpg4Te6Ps7TZt1yFirYxmmatgi/0+gj4XYMIUrpSgXtt2Or2B
	qwrT9eSUaYMEFRAFwingOXKuqJSWM5A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581--MzHdH3HMMGbj3xH7Az10w-1; Mon, 03 Jun 2024 07:51:23 -0400
X-MC-Unique: -MzHdH3HMMGbj3xH7Az10w-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4212e2a3a1bso20059365e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 04:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717415483; x=1718020283;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vIMhCI/l2CqzYTRvd3bD3lxf2NZCjkM04umQtpaDJMo=;
        b=LLONkKH+L7VjbMiT35JMnjc09fCShtz9OjHegfsJDo2GSE/5DVzn1MqSdKInkh4s3x
         Nc1ObWy6YES+ifIYN0oaWgK9wREueE3x9KQYxWmjppY+BrmSU8pNf9n4iRw/ACIeOgJX
         VAoKXWkHWC/d961xCdhGFpeJDNM8ARJKOw8jyOu6W/uC7JPKqlXtikuUW+4SiVsjbtrw
         nH/ZrDBk0VhLs52onsS2fcFWfDRcJpbzAffe1wzV1sXMG3wYjxxJlXiIblW2YwFaaK81
         RDs7DuORShv+7LcZTif1/UGEYRKNaOmIPlSHzelv7v8EltA+mo2PdOAb/m91nj7d6ihX
         63Gw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ+7eah9retbJpb6H6552Zbgcs6GMC5qf9PESYojw8vrXgN1vcVy9upVkDnQhig0R+3uYuj9KVcr3Ws/Cm9yEW03B+
X-Gm-Message-State: AOJu0YzyfOEh1ht+0/XrZE8yu+nMcazsBJcFl9O+JP2KgWTTOoTsEFPD
	q4x6HMl2P1TdYrpwxjHlbw8U72KmqVpGQGBwBInQ5J6gbETmGbT9dSyreWxwZ21Zs3Op1/d68/K
	E0HecVN5zyEV5qkV/Jt4yhEE4/kV+y4QzXevK3k8gPlkTrhAxgQ==
X-Received: by 2002:a05:600c:1383:b0:418:ed23:a9f0 with SMTP id 5b1f17b1804b1-4212e0764d9mr79443525e9.18.1717415482759;
        Mon, 03 Jun 2024 04:51:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjOTKEBtduQRwHaxc2H2U2E0Ga88ec/0WKy2eHj7g9ArTnnrBPoKPXBaGQLDexxlvyF+cwfA==
X-Received: by 2002:a05:600c:1383:b0:418:ed23:a9f0 with SMTP id 5b1f17b1804b1-4212e0764d9mr79443375e9.18.1717415482370;
        Mon, 03 Jun 2024 04:51:22 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212eb6ddf6sm106960815e9.45.2024.06.03.04.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 04:51:22 -0700 (PDT)
Message-ID: <3214310a-1202-4fb6-a51d-bf6f7e73a84e@redhat.com>
Date: Mon, 3 Jun 2024 13:51:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xave kvm-unit-test sometimes failing in CI
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>
References: <11311ff6-9214-4ead-91f9-c114b6aaf5c6@redhat.com>
 <CABgObfY4SCxXCyb8JJtyJ+0j2QLCutB0SU8vKKifEHakEu88pw@mail.gmail.com>
 <CABgObfaSCXyqvfAgqn5kpR6nChqpuUiMmBj9kG4rgcm83yhXJg@mail.gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CABgObfaSCXyqvfAgqn5kpR6nChqpuUiMmBj9kG4rgcm83yhXJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/06/2024 11.56, Paolo Bonzini wrote:
> On Mon, Jun 3, 2024 at 11:55 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On Mon, Jun 3, 2024 at 11:11 AM Thomas Huth <thuth@redhat.com> wrote:
>>>
>>>
>>>    Hi Paolo!
>>>
>>> FYI, looks like the "xsave" kvm-unit-test is sometimes failing in the CI, e.g.:
>>>
>>>    https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000623436
>>>    https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000705993
>>
>> Is this running nested?
> 
> Ah no it's TCG - so it must be a recent regression.

Oh, stupid me, I just noticed that I had a "update CI to Fedora 39" patch 
sitting in one of my branches that I had completely forgot about. So it was 
failing with F39, while it still worked fine with F37 from the master 
branch. Makes sense now, finally :-)

  Thomas



