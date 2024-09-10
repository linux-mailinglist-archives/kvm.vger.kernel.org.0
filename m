Return-Path: <kvm+bounces-26324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5744197402B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B32C228AEEF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157131A38EA;
	Tue, 10 Sep 2024 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuEW1NqZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DB219E802
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725989360; cv=none; b=X0MRdvXcjLUcm49970fv4iTCge1JZ5mL4VNv2k2pfOwqGd3nogfMv/eQU+296XauCOvXqDMo0O/LTJVpKOCsxMYBD42EEFG8MtMl3/QkUDu2MxIJN88+v4kFZjdN4FosP9ZXeE/1EMYkI7aftIQNR2gSNIZ0iXPW108oRFJ08Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725989360; c=relaxed/simple;
	bh=5avglLTzaN/lW4oGmMajIUre8qphYQfx8vo2KTrJ9A0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ew1EdAfIPRHJ1YrpsT0awR3taauW5mXRDr7ruVjCMhqF73Cd/HNzuVhUScsGuGCVX9mVz+5AQwcl5nVmHLT9IAEmz8Nunm/o7S9+5uA0qa8blbXf81QkMbug8Ku4Yb4VtiUJOPAD22QA7hoKjpRfBzpN0NxYcvVFVULpTFHSEps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NuEW1NqZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725989357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jUbhmFdyFbPRoGsa9jieyzkkCsPJBLBvnfTW0iiKGgY=;
	b=NuEW1NqZ1oXBxB2Wk9+zEH6ruHZpyA093kc5CUtNZup+fEz85BFeLidPksDgRYApbxjiUd
	y9KpK8TT5KPEGfL6V/TBZLx2LGd4jRaONb+MkKvPM8sgdENDY5g9RY1lapG1UcxPypg8ry
	VcbAm3sG8wh6QCdjPS95+sUfaHkXXPo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-D-qCkDKGOxi8NVnw-9VFzg-1; Tue, 10 Sep 2024 13:29:16 -0400
X-MC-Unique: D-qCkDKGOxi8NVnw-9VFzg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374c301db60so2520400f8f.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725989355; x=1726594155;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUbhmFdyFbPRoGsa9jieyzkkCsPJBLBvnfTW0iiKGgY=;
        b=HXw0WpS+UljdVbK1SZewTs+zN3I151xueZPCsoBCFiCznpAGeMuLFH+fgKb8gBshfN
         16k5iiAQvlKKPFZO2aK9gGahaFM7bb8NAkZ7I/unjzCYm+OGRWMiWCr+jxybYM05iSho
         5ZkxfDoSBCHx867F50xSxrwtv980l6KbS5wYFFI0K9p3MLVdjq4GTgYHtiKjkm4uG84j
         A2wMDcZYihYB24x20rndUCwwvFjqGqikbrfFRNOvLtZMlA7PhsjZnFW3D5YhRDRQOvB2
         dYGxb3A2PSlz/mDY/SFQ6D+yQds1srO5r4yO2tWqDA2dvYFxq2s3oKTBe2PnYTGfglI1
         9eOw==
X-Forwarded-Encrypted: i=1; AJvYcCUCqjxqNLnnLvrVEo+5s9h3kzhb34voZV/QTVx1t2bl9JecahXq2xj9F3eBW95JEk5pFkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBitX6GcpP3X7coObQpzLdZrk8hH1z6apwi92WfCkRLH9TPFxc
	+Pn4RyobXCiI5ttYPMAV7hVLjPqMSWYKCnkPu1eVWa4WYKqERCrN881eUPYcRf+CLw7926IsvO6
	j27a6mCraUJSy5vfQ0b1CDcmZxYCuRHICpnFV2FHXCz8le2xjCQ==
X-Received: by 2002:a5d:5451:0:b0:368:4910:8f49 with SMTP id ffacd0b85a97d-37892685908mr7210481f8f.12.1725989355034;
        Tue, 10 Sep 2024 10:29:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcN/rJ34FCL0Fqt0gTzyCYFtEk3KFLr0pIYV05bM4SFGF2TLFYKaKuXzqr5B56bJEbzN/Cqw==
X-Received: by 2002:a5d:5451:0:b0:368:4910:8f49 with SMTP id ffacd0b85a97d-37892685908mr7210460f8f.12.1725989354493;
        Tue, 10 Sep 2024 10:29:14 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37895675b21sm9450681f8f.49.2024.09.10.10.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 10:29:14 -0700 (PDT)
Message-ID: <a59e021f-fe90-41d1-aa8d-6ce0a0abcfcc@redhat.com>
Date: Tue, 10 Sep 2024 19:29:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
To: Tony Lindgren <tony.lindgren@linux.intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
 xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
 <ZsLRyk5F9SRgafIO@yilunxu-OptiPlex-7050> <Zta4if4oEHiAIkz7@tlindgre-MOBL1>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zta4if4oEHiAIkz7@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/24 09:19, Tony Lindgren wrote:
>>> +			gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
>>> +			unsigned int g_maxpa = __ffs(gpa_bits) + 1;
>>> +
>>> +			output_e->eax &= ~0x00ff0000;
>>> +			output_e->eax |= g_maxpa << 16;
>> Is it possible this workaround escapes the KVM supported bits check?
>
> Yes it might need a mask for (g_maxpa << 16) & 0x00ff0000 to avoid setting
> the wrong bits, will check.

The mask is okay, __ffs(gpa_bits) + 1 will be between 1 and 64.

The question is whether the TDX module will accept nonzero bits 16..23 
of CPUID[0x80000008].EAX.

Paolo


