Return-Path: <kvm+bounces-12305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BDE8811F0
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:58:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 334F31F243BE
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA09C40847;
	Wed, 20 Mar 2024 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IEkblvoq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749DC3FB95
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710939506; cv=none; b=cR33bXSdaYJulP3dhPX0Hx9n7d3lhxj/YOk8WMby3pGyLMrjm9MbEqvI5rSVHZEiIE68VdATMriCpx0WvimI2/9J3alhiGSY+4iQUwYj/VVUuhAMcYKUlZ0EE6NCZU/HcmQ/1SXD0E+d5QvYScA4S4omFMSlqPOTlXtzDVu+eRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710939506; c=relaxed/simple;
	bh=B1rZ6tQdktcFOJULMHhp2UU/43KYaCCgVqVIMD6UbhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HcPpdX6iyCShIrKEzmr9pFSlusGVOVIMqnzwNqogGINHS+FDfi3gN492bG6wQ+FZcOX3DfOZBocPhj0522SzeHFwvGPkt3oLWnVtHHT6txd3dCRwSAm6fHZ2uHKuD2pXkaITwP0b7UFz/ZzKrD+15pY/bQOw9xFE1h7ILmlwLDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IEkblvoq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710939503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M0fKxVqF0QMkNW08p3lEvYY3G+cqCO+f1iYO6r2IrV0=;
	b=IEkblvoq+uqldgTe1cFpBmj7FkkNCPIxpnu6EZOG300S/W2tdnig3oxrlVAON1MugMugKb
	U22YAENvYRkaJO3ksPFBOAQ33s4qq2/LCiIvLIzAn0O4PZqZFArFlnEzUt/zzp31bPGGF5
	A+q6S0+TBJaulDpH1QxtcLfFDoE3M9w=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-o2SfXBlRMEWK4dB5r8W3NQ-1; Wed, 20 Mar 2024 08:58:20 -0400
X-MC-Unique: o2SfXBlRMEWK4dB5r8W3NQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5148eaa60acso2903534e87.0
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 05:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710939498; x=1711544298;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0fKxVqF0QMkNW08p3lEvYY3G+cqCO+f1iYO6r2IrV0=;
        b=ZGKygrWDAxBmF0L+bgt7WlACTBAuf7pkwWP8HHK/CBsH+iBB6i7SYUqf7W0cwlFCMY
         y1p6UsIhqLAs84QIjrJw54VoVkZErTMYDGhnZWwKlTGMgDu2ggiBL19dzv8RONcE+3+A
         vDnx0ZsxZ977NFwj3HBxyKxygbmOtSUKcB8hTX0nVeYsq5MfJlBEkU4Ym95r12mCSMEo
         HM0nBi3+3pTAjuB3RJ7k+bdplJ7hLTbFo0ByCzlL5uw1l33M7geXYmeoHXzTijw/HJoz
         6yjr8zkErBw8HYU6HFE0i7/F8xey5urCEu9KImd6d8ythqRjX3ZWHda+3wEGnQ0AWtyP
         GylA==
X-Gm-Message-State: AOJu0YwWnY+6yRmWqkdpdgC/aUc4DmepEPXG+gGMK5rB0sqE0FI7fV79
	Z+4rRn/mq6GwO7w1ruOOD77fPBy5QTgswycBdnl+6oMqUjwJZBqnGJylJIg4fCe9Z7OZopSc9Y9
	bX0lfb2E4ASrup6+4yI9PGTvnWnsJnJVf9/gwym84KdvFi35O5g==
X-Received: by 2002:a19:3804:0:b0:513:ec2a:8fd1 with SMTP id f4-20020a193804000000b00513ec2a8fd1mr1442033lfa.47.1710939498523;
        Wed, 20 Mar 2024 05:58:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG95Q7DIpkise2QVbD2rcTNPi48IWJPocRUJi0nROGOFQeT50v8Uca8hdiOLHuMG/dWvQLDuQ==
X-Received: by 2002:a19:3804:0:b0:513:ec2a:8fd1 with SMTP id f4-20020a193804000000b00513ec2a8fd1mr1441958lfa.47.1710939496167;
        Wed, 20 Mar 2024 05:58:16 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:c400:9a2:3872:9372:fbc? (p200300cbc709c40009a2387293720fbc.dip0.t-ipconnect.de. [2003:cb:c709:c400:9a2:3872:9372:fbc])
        by smtp.gmail.com with ESMTPSA id jh2-20020a05600ca08200b00413e63bb140sm2172298wmb.41.2024.03.20.05.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 05:58:15 -0700 (PDT)
Message-ID: <7f8aad63-b14f-4582-a9a7-c14b0d47bbc1@redhat.com>
Date: Wed, 20 Mar 2024 13:58:14 +0100
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
To: Xiaoyao Li <xiaoyao.li@intel.com>, Michael Roth <michael.roth@amd.com>,
 qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-12-michael.roth@amd.com>
 <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
 <8498f23d-0e11-46a6-8519-fc3261457ec3@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <8498f23d-0e11-46a6-8519-fc3261457ec3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20.03.24 13:43, Xiaoyao Li wrote:
> On 3/20/2024 5:37 PM, David Hildenbrand wrote:
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
> 
> Michael is using the patch from my TDX-QEMU v5 series[1]. I need to fix it.
> 
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
>>>     next Patch.
>>>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>
>> I only received 3 patches from this series, and now I am confused:
>> changelog talks about v5 and this is "PATCH v3"
> 
> As above, because the guest_memfd patches in my TDX-QEMU v5[1] were
> directly picked for this series, so the change history says v5. They are
> needed by SEV-SNP as well.

Thanks, I was missing the context without a cover letter. These comments 
here likely should be dropped here.

-- 
Cheers,

David / dhildenb


