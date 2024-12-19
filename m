Return-Path: <kvm+bounces-34146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0CA9F7BCB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B49E07A581A
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 12:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA94224B0C;
	Thu, 19 Dec 2024 12:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lz5+tZMk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719C3224AED
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734612460; cv=none; b=syaZ0CzU7Js1g9/7AN6+fcgDlvA+EqNvK4QkhfBsNnUD7OE1uhjmfnK9jyokQ2r7bEHLNOUD7nFQantG6bcYrRDymGv8PmBlj0JXGOWiluyK7/RhimusLMiQH7sQPInQySF1ERghDS12dLOYfBkkp0d4dQtGKLTgD2SwRvMkCpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734612460; c=relaxed/simple;
	bh=ftZIq9qfm0/IYvT7EbMRkTEOVbbyy9BOTA99CQw+pX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RQeGSoa2u51ofNheH10qD3/xaUGzBRUXEGaXxZ+YKrZ7GB+GaZIDb5ZJjD0dFWE0yDbUOWDJJpvSHt5HSFcpv1x1nsgGRrpH3cRhGhz5MJ+0OOB4OY0m0N/c1+qhW0yOFAYaTynn39q4swUaVWOlW9tK65bDh56gJ2JR9yVa9wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lz5+tZMk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734612457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g1HYznC2LCvYpHJ+sLM4nudgW0A3OVD92QPOK6iMV/g=;
	b=Lz5+tZMklyVZCXt3li4CWLEuF3vyJg09ySx+12wDuLfkiO2fyfzJ45/3unsu9npwnN7u8+
	jap2ozzzknoWAX0lRcG06mOQxIQgNC4Pi6cnxphsb5CZHQ0o9fbg9cw6YqfCR2hBkOBKRO
	TMQdZoj/iDN4+yVlnzBgF3A+425dNzA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-7XAu84PkOvKQXJKxdP9_NQ-1; Thu, 19 Dec 2024 07:47:36 -0500
X-MC-Unique: 7XAu84PkOvKQXJKxdP9_NQ-1
X-Mimecast-MFC-AGG-ID: 7XAu84PkOvKQXJKxdP9_NQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43628594d34so4578215e9.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 04:47:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734612455; x=1735217255;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g1HYznC2LCvYpHJ+sLM4nudgW0A3OVD92QPOK6iMV/g=;
        b=CNuLxT4QY9reYMIsJAVcH+vcisHviJ4TPXtYEWaaz+Xe3MQO144xXaBBKI+YaKt0oB
         Wj2V7AEzF4jGkhTRHDSzTlFwUKEAe5yZQ0KZduFxlf7GpmjozZ1J/LpsTCrt6+RhcBsg
         fUzNqAmkIPdjE+noiho1sIppNRgdhCBxEuU7zIPgRW1K+GW1rNkxDM6ZZRhB/gBHmfJQ
         Qr5i8nXjHNiU5XXnKHFWpqQAFLim4/vH6VxcjIQ3oX4IY5kaiWo6m/6TDlVIW8LGIl5/
         tcdbNKupMKvewN/c/TqRJAvDkMM07GS36UhxFoYDA939wkaDa6elac4DGPP4OnP3DOhU
         +liQ==
X-Gm-Message-State: AOJu0Ywbieg4igpGtvn4HP97I9CRKW6Us2F7d6jL241cYoVKy6Qg9nFE
	5bloQ0hiexOMsRVVqwQjiqQVNIIpOzDHzHr1i1G8BlqjtM2/HnpWkkPnXmFbfJreaURUP/SytQh
	JDE3/4Kw1UESjRUJ+7ZQfqxD8oYtERcD8dYw/OMfap+RuymJy5w==
X-Gm-Gg: ASbGncsS10/SH3x0WNSWjHZacPxgUBzIAa4v5xWVMFDxWxsvHzxrTPLXjwrSq0gNMTe
	2J2mIJ7Z8k4XBnXWrmuV0ceFNcHJ2OHSyrDocgQWp6Qmsw1MjEw0SKBOokcpndYUmGB2lX37InL
	S1XpKIkzA1vBwNpdRown1roz/HbEobkuOkExa3Bhcqnay4wxqbIBZVdrQv5MKl/oOVVMn8JDPvD
	zPVBti4+mWVOYBxhi+PgyxcJpLWrGNhMAuQugMQwid0nypgCcSgLp5QYQCr
X-Received: by 2002:a05:600c:1994:b0:434:9f81:76d5 with SMTP id 5b1f17b1804b1-4365c7c991bmr23666635e9.22.1734612454742;
        Thu, 19 Dec 2024 04:47:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEy03z21PozpIW6HImzk1RmN3tYMqTY4e6pqfiJFKvld9W7AYkse87HA4IPEGy82MEoaAzmkQ==
X-Received: by 2002:a05:600c:1994:b0:434:9f81:76d5 with SMTP id 5b1f17b1804b1-4365c7c991bmr23666395e9.22.1734612454422;
        Thu, 19 Dec 2024 04:47:34 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c8acabbsm1473745f8f.93.2024.12.19.04.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 04:47:33 -0800 (PST)
Message-ID: <c20368b8-ef6b-4be5-b9c6-46a577564f79@redhat.com>
Date: Thu, 19 Dec 2024 13:47:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Simon Pilkington <simonp.git@mailbox.org>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <20241211172952.1477605-1-seanjc@google.com>
 <173457547595.3295170.16244454188182708227.b4-ty@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <173457547595.3295170.16244454188182708227.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 03:40, Sean Christopherson wrote:
> On Wed, 11 Dec 2024 09:29:52 -0800, Sean Christopherson wrote:
>> Drop KVM's arbitrary behavior of making DE_CFG.LFENCE_SERIALIZE read-only
>> for the guest, as rejecting writes can lead to guest crashes, e.g. Windows
>> in particular doesn't gracefully handle unexpected #GPs on the WRMSR, and
>> nothing in the AMD manuals suggests that LFENCE_SERIALIZE is read-only _if
>> it exists_.
>>
>> KVM only allows LFENCE_SERIALIZE to be set, by the guest or host, if the
>> underlying CPU has X86_FEATURE_LFENCE_RDTSC, i.e. if LFENCE is guaranteed
>> to be serializing.  So if the guest sets LFENCE_SERIALIZE, KVM will provide
>> the desired/correct behavior without any additional action (the guest's
>> value is never stuffed into hardware).  And having LFENCE be serializing
>> even when it's not _required_ to be is a-ok from a functional perspective.
>>
>> [...]
> 
> Applied to kvm-x86 fixes, thanks!
> 
> [1/1] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
>        https://github.com/kvm-x86/linux/commit/2778c9a4687d

Oh, I missed this!  I assume you're going to send me a pull request 
today or tomorrow?

Paolo


