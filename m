Return-Path: <kvm+bounces-26335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8565E974122
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01B87B260C0
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887A41A38E9;
	Tue, 10 Sep 2024 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JObLiM9f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3214461FE1
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990768; cv=none; b=L8HqQrtmjnoit2YsF2KQAn5TzGHozsO/ZxTio13V71JB5/PfwuvbUsbd2zbKD3esC2Ol+OiKEzOEzDJmg7EFigbAoIh9vcegDvkzVfVn6YV0PHyz/1yQ410D6GZhJs2w6zLv5mnXlafH+zOXAgnOUPR4ruwoElXN/suyw8OpzLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990768; c=relaxed/simple;
	bh=ldUOVhJlKAz9Uo9g+sp16CjBy8xn+zib0h9zRoy4d1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KRedLrH0eIM7AkeQgx25pAMz9rW/0qSxjsfJcP5mUtpVITcXEhyFdmxRSWI/gBcFWbNbHA7CWdGGjjgpALmZZt2P3tqYDlEeNa/U4nE2Lfd/iKZ6LtExQ3UGEMHJfWHKGTSkfrF95LmpyEDgaDP1RvncDFv7RQoRQrmRX55hc0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JObLiM9f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725990765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b/OrD/CRJKAUtRn/CKVg0ziTsih2tmUkBMNn0YhQu98=;
	b=JObLiM9fEuY4ysesI4fRTNZjsNlNChJGbQCuz10ayJCV1qkWFbTfpHOfKaTgHzWloy6RX0
	6d9nJQKc+5qCmZIgxl5I80Ecicqc5tClMgyHVkspj2qRhV5edQFW30iSSkGVgHgF6Szgx/
	2rAwutFcbG/+HvFSj6Y/NBEL1q0xh1g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-RGWtjGpHNCeR88HLvRf7og-1; Tue, 10 Sep 2024 13:52:44 -0400
X-MC-Unique: RGWtjGpHNCeR88HLvRf7og-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374b981dd62so566267f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725990763; x=1726595563;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/OrD/CRJKAUtRn/CKVg0ziTsih2tmUkBMNn0YhQu98=;
        b=fF6TZdDh2h+k0bld0otg0E13y9qn77R2oz3wf//uRJGzhP3ikGgp34z6b16RVdsxpS
         QxmNfo77Z97cIew0mzYxe41eH6mFJ39K17HSzyczhbNF1j06zAVTa+7FcymeA++5QECb
         ZWVHFb7v1murDay8thsYmVg1NNIRXy/du2GP8BUIlCymOmOe0sUQZMYpqSvx25A2IwFw
         xRz4NeuRvcwnaVrw+LO+m2I4Gtpe/djQ7M1x/zRCMGfuAy7/6+I+oiSySU7ZloMptR6c
         hy69S6ggCUFCHfQ0QQ6V01EZwIU59bK3CQWS1+sYbqlX/JLIGiDELtVi9xpfF2xBNB8j
         EmlA==
X-Forwarded-Encrypted: i=1; AJvYcCWeceeMDikn4xm/YvmYLrtAnFpmDWcMg00H3OPEbTfXNOKQObhaXVRccttV8MU6MKYjvyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQs4vs4XtlfgZtGG+dWBOfUSKZ+/tFWXx8ZFxgMa/KiNYMGk+o
	sipK7HklosZNs61UhoW/qOuPM/ZA/bE5BOdGLuwXxTWcRxg0/Dytag+djScoE0MMbWItkaCfajx
	qC7WG5HBDprvDV3Oo22sONsESbu63+WlmYPC+91eTdn2ER5TqQQ==
X-Received: by 2002:a5d:570d:0:b0:378:80ab:9968 with SMTP id ffacd0b85a97d-378b07a4f76mr345457f8f.17.1725990763106;
        Tue, 10 Sep 2024 10:52:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEf13gVRG3AOSNrNN+nopfVG/b6HjB5FCqpgM435rpkMo8hGPTMXtTAxOxZY0Twv3kFYVP2cw==
X-Received: by 2002:a5d:570d:0:b0:378:80ab:9968 with SMTP id ffacd0b85a97d-378b07a4f76mr345436f8f.17.1725990762598;
        Tue, 10 Sep 2024 10:52:42 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37895665ba0sm9551570f8f.48.2024.09.10.10.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 10:52:42 -0700 (PDT)
Message-ID: <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
Date: Tue, 10 Sep 2024 19:52:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240812224820.34826-26-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 00:48, Rick Edgecombe wrote:
> Originally, the plan was to filter the directly configurable CPUID bits
> exposed by KVM_TDX_CAPABILITIES, and the final configured bit values
> provided by KVM_TDX_GET_CPUID. However, several issues were found with
> this. Both the filtering done with KVM_TDX_CAPABILITIES and
> KVM_TDX_GET_CPUID had the issue that the get_supported_cpuid() provided
> default values instead of supported masks for multi-bit fields (i.e. those
> encoding a multi-bit number).
> 
> For KVM_TDX_CAPABILITIES, there was also the problem of bits that are
> actually supported by KVM, but missing from get_supported_cpuid() for one
> reason or another. These include X86_FEATURE_MWAIT, X86_FEATURE_HT and
> X86_FEATURE_TSC_DEADLINE_TIMER. This is currently worked around in QEMU by
> adjusting which features are expected. Some of these are going to be added
> to get_supported_cpuid(), and that is probably the right long term fix.

There are several cases here:

- MWAIT is hidden because it's hard to virtualize its C-state parameters

- HT is hidden because it depends on the topology, and cannot be added 
blindly.

- TSC_DEADLINE_TIMER is queried with KVM_CHECK_EXTENSION for historical 
reasons

There are basically two kinds of userspace:

- those that fetch KVM_GET_SUPPORED_CPUID and pass it blindly to 
KVM_SET_CPUID2.  These mostly work, though they may miss a feature or 
three (e.g. the TSC deadline timer).

- those that know each bit and make an informed decision on what to 
enable; for those, KVM_GET_SUPPORTED_CPUID is just guidance.

Because of this, KVM_GET_SUPPORTED_CPUID doesn't return bits that are 
one; it returns a mix of:

- maximum supported values (e.g. CPUID[7,0].EAX)

- values from the host (e.g. FMS or model name)

- supported features

It's an awfully defined API but it is easier to use than it sounds (some 
of the quirks are being documented in 
Documentation/virt/kvm/x86/errata.rst and 
Documentation/virt/kvm/x86/api.rst).  The idea is that, if userspace 
manages individual CPUID bits, it already knows what can be one anyway.

This is the kind of API that we need to present for TDX, even if the 
details on how to get the supported CPUID are different.  Not because 
it's a great API, but rather because it's a known API.

The difference between this and KVM_GET_SUPPORTED_CPUID are small, but 
the main one is X86_FEATURE_HYPERVISOR (I am not sure whether to make it 
different with respect to X86_FEATURE_TSC_DEADLINE_TIMER; leaning 
towards no).

We may also need a second ioctl specifically to return the fixed-1 bits. 
  Asking Xiaoyao for input with regard to what he'd like to have in QEMU.

> +	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x0, 0);
> +	if (WARN_ON(!entry))
> +		goto err;
> +	/* Fixup of maximum basic leaf */
> +	entry->eax |= 0x000000FF;
> +
> +	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x1, 0);
> +	if (WARN_ON(!entry))
> +		goto err;
> +	/* Fixup of FMS */
> +	entry->eax |= 0x0fff3fff;
> +	/* Fixup of maximum logical processors per package */
> +	entry->ebx |= 0x00ff0000;
> +

I see now why you could blindly AND things in patch 24.

However, the right mode of operation is still to pick manually which 
bits to AND.

Paolo


