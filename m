Return-Path: <kvm+bounces-17649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3418C8A90
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B36A1F24B9C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0274A13DB9B;
	Fri, 17 May 2024 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0yTdLDU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BFE13D8A8
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715965798; cv=none; b=ClTURepKQzxs5Ndw9sRpY9/Nvosglr4jjsKt6kfUmvR4Dd+c9Q8BNY0Xb15z6bVM0+Si7YSIGrhIeUwY8xosUoT5TwYGc0A/aDpavvq/apbt2+ynZGuE8D3Z52dRq+tqhLVzrMumzX0l+fo+rIMOKVm6TgAFQaoWnr1NUk5MSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715965798; c=relaxed/simple;
	bh=x7Bw4tG2gXrUHLF36e6j3ojXvbwM76d82R/kfpkt0DI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAl8tVcLEOBCQEs3YTBIkWIMG5BK8gCUHhmd0s5HXVL9QOByi1vxMcvZCRxVNmXwIv5XHXxmy2ha3G6O0+Ynu3D2XGBUD8wN0Ro/eNBEEGKLerSK8Ui2leuQUcplrY8rHDhJVwGxnD3AWTc2073C32Ls2Krq0fJBwmuSFm45Xmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0yTdLDU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715965794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+pdp9Fgv06c5uCl9iN53c2RFQnQI9vJm8SjFQl4B3n8=;
	b=b0yTdLDUlU8skMJHbdCiKrnAMvye1sAflKsOCklhygm+urh/xsUssIe+9t5lzt+IOtfj86
	WLGpcjZ0fLg3A4WmA+5BCBoNnaXuPWvCcKR5HIDq8g4EimAm3IdGSae3rIH/Xa+8Y+BgPv
	lthjxGYqHQpoeXyW71dFl3vsqDVpp4A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-E7i_qLLTNE-zQxk4a4omlA-1; Fri, 17 May 2024 13:09:52 -0400
X-MC-Unique: E7i_qLLTNE-zQxk4a4omlA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a59a0014904so552618366b.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715965791; x=1716570591;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+pdp9Fgv06c5uCl9iN53c2RFQnQI9vJm8SjFQl4B3n8=;
        b=i34Eu+vqDZUZj9KfQdxqyPaoBS1VK7g/jffAhZrnonmugqESZ1GEMrkBQgc3sNspF3
         DX/UUcaIWpFIMtBW364/Lv15DtZ4FusEPubYWD21pCYok9lEFwWIQiMEdmVG7ueJoi9y
         cjxup4BeUIt33DWsC76HqINmHX9FPpLmf9PnVW2ryHUJS2SkN794ZoRdqJFfCmE/te/N
         H4w6rKSvYvJZvHuw6lkDu2zpOgaM9+OP1VqlXzyyGnDeUMTsRBNzwhwc7HL0fuFOED1M
         nLg8E2IfWnDT+pWx3qrIv/+xc7WN5QTYfgXILbfpY4mKvcnweiylJi157sNO+VT2q7OK
         e4uA==
X-Forwarded-Encrypted: i=1; AJvYcCVxohRlFHpP6RZz9BfDbr3MTLaRncKj4QgGu0hnb9qPOawOKIgvi4Jakbqw0I8tOPayGWdJHyET2VFavJCsdd1txm5C
X-Gm-Message-State: AOJu0YxLQEhM1hCW80C2Q5vKJKXaBGmwRZmqBoymF5TZCIJPG+Inm9Wc
	624qhW8RaPa1GaoBvdPUGPqERxXE+57E1Ei69ylACnzwjhVRhb++VdPu1owk7B8vUYRsXIRYOlh
	sRjDbvJWN3d2/RI5ShAHLysnyMz3Z2Q9MTtYnMixaMq41pHqahA==
X-Received: by 2002:a17:907:2d86:b0:a5a:423:a69f with SMTP id a640c23a62f3a-a5a2d53b9bemr1782609466b.9.1715965791658;
        Fri, 17 May 2024 10:09:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYcIyM25DJsjwG8pQ3v5lZeUr/4DXwGSEQJ5iM9+qxyiEshE0I9OVO/et+WIqR/gWd+drwyA==
X-Received: by 2002:a17:907:2d86:b0:a5a:423:a69f with SMTP id a640c23a62f3a-a5a2d53b9bemr1782608366b.9.1715965791307;
        Fri, 17 May 2024 10:09:51 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a5a55275e80sm856667566b.8.2024.05.17.10.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 10:09:50 -0700 (PDT)
Message-ID: <2450ce49-2230-45a2-bc0d-b21071f2cce6@redhat.com>
Date: Fri, 17 May 2024 19:09:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240507154459.3950778-1-pbonzini@redhat.com>
 <20240507154459.3950778-8-pbonzini@redhat.com> <ZkVHh49Hn8gB3_9o@google.com>
 <7c0bbec7-fa5c-4f55-9c08-ca0e94e68f7c@redhat.com>
 <ZkeH8agqiHzay5r9@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZkeH8agqiHzay5r9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/24 18:38, Sean Christopherson wrote:
>>> I've hit this three times now when running KVM-Unit-Tests (I'm pretty sure it's
>>> the EPT test, unsurprisingly).  And unless I screwed up my testing, I verified it
>>> still fires with Isaku's fix[*], though I'm suddenly having problems repro'ing.
>>>
>>> I'll update tomorrow as to whether I botched my testing of Isaku's fix, or if
>>> there's another bug lurking.
>>>
>>> https://lore.kernel.org/all/20240515173209.GD168153@ls.amr.corp.intel.com
>> I cannot reproduce it on a Skylake (Xeon Gold 5120), with or without Isaku's
>> fix, with either ./runtests.sh or your reproducer line.
>>
>> However I can reproduce it only if eptad=0 and with the following line:
>>
>> ./x86/run x86/vmx.flat -smp 1 -cpu max,host-phys-bits,+vmx -m 2560 \
>>    -append 'ept_access_test_not_present ept_access_test_read_only'
>
> FWIW, I tried that on RPL, still no failure.

Ok, so it does look like a CPU issue.  Even with the fixes you 
identified, I don't see any other solution than adding scary text in 
Kconfig, defaulting it to "n", and adding an also-very-scary 
pr_err_once("...") the first time VMPTRLD is executed with 
CONFIG_KVM_INTEL_PROVE_VE.

Paolo


