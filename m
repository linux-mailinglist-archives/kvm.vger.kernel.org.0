Return-Path: <kvm+bounces-63887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 97995C75833
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id BC6482C3F5
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17F336B07D;
	Thu, 20 Nov 2025 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MdnDExZd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3720833EAE5
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657939; cv=none; b=bIAiHHwE6OX5ojV6FMsxW0wQHoEcf8w9BtiOhWhPJ+l+YuzPfRzO8a8pXZGyArJLYx0aKKznm0qEgx6b7mFME08QwMmuItK0qjNnqNAW836PACzW7KQ8JEtHtK5XYc8ApnSh22ig4+9aOOkb4JPGj8+TAY+2vDnMbxqPRD5DjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657939; c=relaxed/simple;
	bh=6ouzVPxR9/PPKjyMqdy7RdqkBBgQp7JQUydsaa0CmFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aC38CBK+53xdRsVG3k/903U0+ipIoBKF28ueHv6NkglTwMm7e2cEbrIbT3McYtoltXvqyWAzVsP68wxLV9C0sgzslcJ6UDGM/YtdLfaWKRJuX77y5zmaFMguYXHB71Na7hBESls9uN50JqPFdTUrykNk3T0ni4LMIqQfVX+Hgck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MdnDExZd; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b737502f77bso172863366b.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 08:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763657934; x=1764262734; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GX7JIdjzguz3qTiD+nL5d+5EXNXgZMH9j6401828jTY=;
        b=MdnDExZdX6kqkRrcIEYEna4F1cn84qQnxpTYDyrWEw0Yha0XbVCeKswS1nH2vY2W1y
         xBY1GqZYrN+XsFtHeWslk/hKxXgATPSYUlpeVMZeCf4fSiwW5kFIJ+na9g3CK19AEOxe
         WVGWDadPTq/fwtVXsxG/Od6cYdqbUiMD5A1ntN0YuvDTXig1QeSZIsIwW5VyEMySEsv0
         SbmTrOzMf+DXpO5ArunXajB/pl3QYy3tQdWWXdH593Q4D6Hjy32ctu8NmL2pNtBxj312
         ijDNZYSfk7UJzeZJLPZIaEYTJ3K5deQcsxZx80+J7A//n+lethTCZs+aIo1mQe7VYkcy
         s4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763657934; x=1764262734;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GX7JIdjzguz3qTiD+nL5d+5EXNXgZMH9j6401828jTY=;
        b=fFUcyALOtxmj/NrjLizwmnpB6jblbRZwsFqoGlZcyOmZ10xlrBIs4CzPpCqoLhwEU9
         mXW5/qk/XtBm6uBlTItLOKyTGekLjjwIZHp3yO9x7f4eWY8Wbf8f7TrMg3Xt9pm0q3LH
         tIKub2DDBbuPIgIK4gMDR7/HIlIUFEFb7CXblPlsa2bCiAfJXi/HBfVseYBsITxrpXHE
         pmnG/AodmwPd7B+Q8g11dhJ8+eNqiKDpDGwdrpTpfKRQkGhOmFS4H0xgL+lMUSHxaHTJ
         aBKc1VYQcVdissoZS9NrVSHTVWt36uS78ojJFn45rsS2GjQ+XQDqef+0k0lVUC/Tja51
         fOwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpxxG9KCinYTguN4C71Lt8FX6f2qyEp8deg6LtbNKeMCXb7mH6bfUHTSMCo+GnT+YnUcM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2MGv816XLRggj9dRsx50YbE0FpyYLyDoVuOjLHZP8ekXEutGE
	Wk1oeTKzSZHw2KB390euOT0F5voqS9RXTlkM6HyFkEU4a3VE+p6Y2xfdOhuk/4e8C6w=
X-Gm-Gg: ASbGncvchJmInbJBXhi6n7i90eZw29eEd4IW/qSDeT4Ordf91ddZPGOI1gJFv7mQy2G
	OZk3K+f5+GCvWWd8V+N1udsm98sWWBhRSiy2my18qFKVbmQaZ1hj0tTeDiNQ0dW0po0BO3UZvBr
	M+5M1sxJ8H5e0mfU9arpqRUEm6Ja21YNHfHMVTFQVcOf8va3HEsywSy/OLp1faMrsYrm7LmKgbs
	5I31t8mvaIIg/uzw7zALtoOguQAVbjkzC9fF7jGcNaiTJOawoiUbwncbS0X3Hd3qOEbS17WLihO
	Y8Ap1TC77njdqaIZSrhbchiaMz8uvNRZaboE7B1Zse5axb7QM8FzG1jrUK88O+PxtueWrNKBP7N
	bCqeI7MWzNFXRl3zt2TQTZfPujpivlhwMYGtUtY5mdK9xEQzQxcJsDRoS/U/vOxSqVkPZA10Hkl
	2HYU/Nfg7xX+7zWp5ZEMfT0YEGKCJpuVAfNl5u
X-Google-Smtp-Source: AGHT+IEP6B+bHHp1EliuUtr9obwMpAwLEcAko2PV+mmNgQgp5fyBoKtVQ3Xenohcz+H7W1oTHt7p1w==
X-Received: by 2002:a17:907:940e:b0:b72:d56f:3468 with SMTP id a640c23a62f3a-b7654fe8efcmr349984866b.50.1763657934419;
        Thu, 20 Nov 2025 08:58:54 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd659sm249621766b.7.2025.11.20.08.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 08:58:54 -0800 (PST)
Message-ID: <0541b782-5289-426a-ad76-83ad4b3a3d6c@suse.com>
Date: Thu, 20 Nov 2025 18:58:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>,
 Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-1-1adad4e69ddc@linux.intel.com>
 <abe6849b-4bed-4ffc-ae48-7bda3ab0c996@suse.com>
 <20251120165600.tpxvntu6rv7c34xd@desk>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251120165600.tpxvntu6rv7c34xd@desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 18:56, Pawan Gupta wrote:
> On Thu, Nov 20, 2025 at 06:15:32PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 11/20/25 08:17, Pawan Gupta wrote:
>>> Currently, BHB clearing sequence is followed by an LFENCE to prevent
>>> transient execution of subsequent indirect branches prematurely. However,
>>> LFENCE barrier could be unnecessary in certain cases. For example, when
>>> kernel is using BHI_DIS_S mitigation, and BHB clearing is only needed for
>>> userspace. In such cases, LFENCE is redundant because ring transitions
>>> would provide the necessary serialization.
>>>
>>> Below is a quick recap of BHI mitigation options:
>>>
>>>     On Alder Lake and newer
>>>
>>>     - BHI_DIS_S: Hardware control to mitigate BHI in ring0. This has low
>>>                  performance overhead.
>>>     - Long loop: Alternatively, longer version of BHB clearing sequence
>>> 	       on older processors can be used to mitigate BHI. This
>>> 	       is not yet implemented in Linux.
>>
>> I find this description of the Long loop on "ALder lake and newer" somewhat
>> confusing, as you are also referring "older processors". Shouldn't the
>> longer sequence bet moved under "On older CPUs" heading? Or perhaps it must
>> be expanded to say that the long sequence could work on Alder Lake and newer
>> CPUs as well as on older cpus?
> 
> Ya, it needs to be rephrased. Would dropping "on older processors" help?
> 
>      - Long loop: Alternatively, longer version of BHB clearing sequence
> 		 can be used to mitigate BHI. This is not yet implemented
> 		 in Linux.
> 

nit: Perhaps a sentence about why long loop version might be used on 
newer parts in certain cases or why it shouldn't.

>>>
>>>     On older CPUs
>>>
>>>     - Short loop: Clears BHB at kernel entry and VMexit.
> 
> And also talk about "Long loop" effectiveness here:
> 
>      On older CPUs
> 
>      - Short loop: Clears BHB at kernel entry and VMexit. The "Long loop"
> 		  is effective on older CPUs as well, but should be avoided
> 		  because of unnecessary overhead.
>> <snip>

In any case it's much better and indeed clear!

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

