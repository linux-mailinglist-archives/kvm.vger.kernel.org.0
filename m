Return-Path: <kvm+bounces-9528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 014EB861522
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABACC282252
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8A4823B1;
	Fri, 23 Feb 2024 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+026vrI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5372A186A
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708700692; cv=none; b=eDEnRlQJqgr1UxNnbexApNFdrwM1p2VybwXp00rzRcwgYB6cNqnt1vV88958J1LRWxKuEFm96atofXnPeC/e7DDryoiyQABsOvYA3pawR7Ro+FZefZ3KJTQwgJG7Wm351mj9BpYYwDB+dTWvun8uci1NmsCx8GZUDCyhTGeuKoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708700692; c=relaxed/simple;
	bh=zE5VEPzfxvPlC3BpeQHuFfeO4qV/thHrz7yf4Fc4zQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lBk/RUoTqiYHBH0tKnNbrIIIEftFY/hGtpWfu6dpT+zFG3436LCm8cb8YxKphBTTnQs3NEyXyGv5ATogFUKufvVVss40BGN0O02kVi03fKZd19NhL9oTyanhEkLAT6fVIfVF7Le9Mzwbbh1axT63vnPJ8753yNlodQq2p4+4TSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F+026vrI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708700690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iMO3MnEoqkGGMfR5qCARB8BwTEcfu+rCmzwC1hIJkBM=;
	b=F+026vrIHfatQYBdtoHk98/5yCIq6JetauJGMabmS0LsnVRhXP0VUXp5kn5eEUo78Z1O9O
	StNXPeMzfVuFSGUbUgOSSgkeeZz7/pOMvDB5967tO0UMyeGHxzjfGjg7+XOhF+W0K+9sUh
	fhNIh74IXX2eSQchafxGEX4IxqwD//o=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-O1fisUtOPoijM4qtQEOwHg-1; Fri, 23 Feb 2024 10:04:48 -0500
X-MC-Unique: O1fisUtOPoijM4qtQEOwHg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-565898fef48so101030a12.0
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 07:04:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708700687; x=1709305487;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iMO3MnEoqkGGMfR5qCARB8BwTEcfu+rCmzwC1hIJkBM=;
        b=QPZj85+OuxX17rMLO3CjRJI7vldMrKB/0rWxjcAXqqK6ZuYY5eh3M4ubzGOhkf3I94
         5gEnXjgMKN0BohZx00XpwEJI9CsISrNeZGilgKAeGKFPsP9HRefvQNdjP/OYNcrQdHk8
         PtR81Q14kx0CyW2DVwm2zIexsIqUWOCKmaC0RMvI/ceDw9PIdY0cF+ykN7qjKkxtpDhI
         7WV1S0edpJQPiiQeYoDAiiR9HzxymouFzJ59xsWgBxqxDGE39x1E2mtqYTnT3T8pQSLf
         NREkC5vj7On3NUX6Kvk3Pdg/CWrRo1IhXRO3m2yhyYtf8Hiif921vADtVfciEozqpGhl
         c3xQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5f3AYUb/ERB7dkBKMPAnmp9K+Ba8MPq+sbO5pMVYmSqLdK70R29pktvc2lBllnJ4cflv9TTK3S1ecBO3YaNv12e0E
X-Gm-Message-State: AOJu0YxvrdDRhKv9HsuBnP36w/GgS1lvMbPoqVBc6EWjIpG9Gk8kEVQr
	RwWs0+y0M4yiN8qnoCI6Fl+BmZuiJl+4ixYD1fp1SsvkIUsnPPsqbN+7YTc3v2XxsBxgbshDnWP
	rucirlatoO5b5htbkxxulkmQpdDLg8synWCTDf8/WqNHBf4sfYw==
X-Received: by 2002:aa7:c0da:0:b0:563:c54e:f7 with SMTP id j26-20020aa7c0da000000b00563c54e00f7mr87977edp.17.1708700687401;
        Fri, 23 Feb 2024 07:04:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEV+44vJ6ngt7aiw6q7lJa1KahJov1x6zIxOfHCllRW8t3hsWTfj8EoWBZQ1adpI48fCo9JQA==
X-Received: by 2002:aa7:c0da:0:b0:563:c54e:f7 with SMTP id j26-20020aa7c0da000000b00563c54e00f7mr87960edp.17.1708700687195;
        Fri, 23 Feb 2024 07:04:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e26-20020a50d4da000000b00564024b7845sm6944716edj.38.2024.02.23.07.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 07:04:46 -0800 (PST)
Message-ID: <14430905-c4ed-4e88-ae88-c2d76228935d@redhat.com>
Date: Fri, 23 Feb 2024 16:04:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] KVM: SEV: fix compat ABI for
 KVM_MEMORY_ENCRYPT_OP
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com,
 aik@amd.com
References: <20240223104009.632194-1-pbonzini@redhat.com>
 <20240223104009.632194-2-pbonzini@redhat.com> <ZdipaR9KZSreIrIh@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZdipaR9KZSreIrIh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/24 15:20, Sean Christopherson wrote:
> On Fri, Feb 23, 2024, Paolo Bonzini wrote:
>> The data structs for KVM_MEMORY_ENCRYPT_OP have different sizes for 32- and 64-bit
>> kernels, but they do not make any attempt to convert from one ABI to the other.
>> Fix this by adding the appropriate padding.
> Maybe call out that SEV+ is 64-bit only, so this doesn't matter in practice?  Or
> does this affect .compat_ioctl()?

Yes, .compat_ioctl() is what I had in mind - but that means I have to 
change "32- and 64-bit kernels" to "... userspace".

Paolo


