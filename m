Return-Path: <kvm+bounces-43097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A134A84A8C
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 18:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D49B3B5070
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 16:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F371EF36C;
	Thu, 10 Apr 2025 16:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dR3c5Ezb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071B21E9B14
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744304267; cv=none; b=J0egRNzeCU2h1CZbktgiNZkJRrRvSjaNke7GkfNh/xVjbIupmkSSlUqttg9ym8IhssycG0MIHJUYBWWqrHi5O1Gz1gGy0V9fDle/Sr3fgL+9KSyDN5oaGRMM4cnKyFsceZkL7VBFHxcpG0QX7Il00qWSwQG9pRIhMY4Wc8tTiW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744304267; c=relaxed/simple;
	bh=iUFZKfOoEQR0iaLokhYrg/Bzey7i33Jjihcp7Hf5cYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mkJOa91cKVkHC77HHnH1U1TkDIAJ4nXGlxG+0vF4aNZlDjs39wCZgzyxYom8vg4UDbAFuXbeQC7aOl9KpbhbdB/6UMlaZBZ4XInLrR6NVhi6yvUlPF3i/owzAxLmOh1cmgzFQnZnEpSLlb4dVA7L1VWT4tBGbTYbmY+b4q6TZjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dR3c5Ezb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744304263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M5FzrRknDBF+rBZlrff8o23RTzd1+qMrKBFK3Dp7nQ0=;
	b=dR3c5EzbOh9D1Vichh/D0ZfwlDDwQjZDjh+wJT2eS6ag63Y6odpQw1m1xd93CpdeoxtzQJ
	bSb8M7kZDNmWK6JElIp6tCbdcNlO63zkLPjkP27u0swk31hQnbO90juy/hm7L6t042leJg
	HvTkuKwV9IjATi9wjJ58cSo0jokmx0I=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-NW4jThToNYGeRlT7mN855Q-1; Thu, 10 Apr 2025 12:57:41 -0400
X-MC-Unique: NW4jThToNYGeRlT7mN855Q-1
X-Mimecast-MFC-AGG-ID: NW4jThToNYGeRlT7mN855Q_1744304259
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac2aa3513ccso89620266b.0
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 09:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744304259; x=1744909059;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M5FzrRknDBF+rBZlrff8o23RTzd1+qMrKBFK3Dp7nQ0=;
        b=kOcGtAWEOxCOCO8ectMMtmXyuf3zTL0zbXJbJFG/TlM4HLClgrBuTCtjZZjwVsPWjh
         uRdxoZZDySCesFAS/S23aTEanAV7rIFNx1QlBD5DLoU3uMZgp5mBzDvrxhcmrjWN7cIW
         hIW67L58cDhSFC2u58Xsfc5FaLVjbnre93ooAr1la6W5xKtqiFIaaZFu3Mm5xnVuzH3z
         m7Qn/486wkZBviZPmM6qmnZ71tQ7CsG+zBGniQEyKJHCx6CHf/SYDnEPUYqlidqZocI9
         T+vE0kefXZjHytR5hVEiyyr2GBGNw/i+vVNunyShhfNecZTM5MtQqPKxQnCgDn5eMXML
         BSIg==
X-Gm-Message-State: AOJu0Yw/TMkCAJMyEGWzX8jnJM7eRCj6zDwMRcTP/BEDRuRm+I8+xZ0u
	p58E1M6U6Qe6X4i3D5i7bqD8RTXbX51DHWo3OwSqSYZkjxHZEd8yAFbxNCjmCsDzrwKqYzOYngW
	0qjztV12Z9a9dOpsdDzSi73C/q82+cope2vH4dLlndgXD1S19cw==
X-Gm-Gg: ASbGncvrFtFGLrZNLOaFL/SnwsDsYz/CnQyWDiBfCR3kdOXrr87Ro5QzcrjJ6XnIIqQ
	MofxtHyXciXwJU5eqdfWTTxXvZzRxpPw0ttGN6Dod8nXUv4EzdT+Yh9+WlHSOmiHkRSWykVomCN
	zisypX72xbOWaGmer2dmmZ35QsmGpxeE4z0GtN1vRdnHoBm0rSgYX+saetxQE8pOs2wrzT7k7kj
	0V5pvNN0snD5/wA50XGyu2Avpwu28QU0uSP6g9W7Fv/8M2C4X0S7SZVt2yYgMT8N8uuwyHSInci
	OG5YuqCGzAo0bQs3iuv8pZkCeAug4qcOGGhoVopiYI6xl3WuAg==
X-Received: by 2002:a17:907:724b:b0:ac7:3918:752d with SMTP id a640c23a62f3a-acabd51b1f7mr300967066b.58.1744304259241;
        Thu, 10 Apr 2025 09:57:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7b3YQNsyqR+YWy0enFe1MDc4mkL+CJveTRRUjuzDKoemkvUAfjuukLhs1JdhMRlGSCyapag==
X-Received: by 2002:a17:907:724b:b0:ac7:3918:752d with SMTP id a640c23a62f3a-acabd51b1f7mr300964966b.58.1744304258747;
        Thu, 10 Apr 2025 09:57:38 -0700 (PDT)
Received: from [192.168.213.210] (93-33-70-196.ip43.fastwebnet.it. [93.33.70.196])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-acaa1ccd205sm309016566b.141.2025.04.10.09.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Apr 2025 09:57:37 -0700 (PDT)
Message-ID: <60d159a0-afbc-4314-b165-8711383e9086@redhat.com>
Date: Thu, 10 Apr 2025 18:57:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/i386: Reset parked vCPUs together with the online
 ones
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <e8b85a5915f79aa177ca49eccf0e9b534470c1cd.1743099810.git.maciej.szmigiero@oracle.com>
 <afff3782-08ab-42cd-a32d-33c307c5d9b7@maciej.szmigiero.name>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <afff3782-08ab-42cd-a32d-33c307c5d9b7@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/10/25 17:57, Maciej S. Szmigiero wrote:
> On 27.03.2025 19:24, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Commit 3f2a05b31ee9 ("target/i386: Reset TSCs of parked vCPUs too on VM
>> reset") introduced a way to reset TSCs of parked vCPUs during VM reset to
>> prevent them getting desynchronized with the online vCPUs and therefore
>> causing the KVM PV clock to lose PVCLOCK_TSC_STABLE_BIT.
>>
>> The way this was done was by registering a parked vCPU-specific QEMU 
>> reset
>> callback via qemu_register_reset().
>>
>> However, it turns out that on particularly device-rich VMs QEMU reset
>> callbacks can take a long time to execute (which isn't surprising,
>> considering that they involve resetting all of VM devices).
>>
>> In particular, their total runtime can exceed the 1-second TSC
>> synchronization window introduced in KVM commit 5d3cb0f6a8e3 ("KVM:
>> Improve TSC offset matching").
>> Since the TSCs of online vCPUs are only reset from 
>> "synchronize_post_reset"
>> AccelOps handler (which runs after all qemu_register_reset() handlers) 
>> this
>> essentially makes that fix ineffective on these VMs.
>>
>> The easiest way to guarantee that these parked vCPUs are reset at the 
>> same
>> time as the online ones (regardless how long it takes for VM devices to
>> reset) is to piggyback on post-reset vCPU synchronization handler for one
>> of online vCPUs - as there is no generic post-reset AccelOps handler that
>> isn't per-vCPU.
>>
>> The first online vCPU was selected for that since it is easily available
>> under "first_cpu" define.
>> This does not create an ordering issue since the order of vCPU TSC resets
>> does not matter.
>>
>> Fixes: 3f2a05b31ee9 ("target/i386: Reset TSCs of parked vCPUs too on 
>> VM reset")
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
> 
> Friendly ping?

Applied, thanks.

Paolo


