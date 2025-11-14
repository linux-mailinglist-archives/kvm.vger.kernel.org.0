Return-Path: <kvm+bounces-63278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1710BC5F97D
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 00:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CCF304E5D4D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 23:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B3130C618;
	Fri, 14 Nov 2025 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAyDQrXU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BijupKiq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E71A08AF
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 23:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763163193; cv=none; b=G18ZIM/djQ0gyrOWMQ9E0PQ3FpupykNgXslOuW93SyEYfwv4fKwjlJFh0MxATALobIyL27S7dP6sStDjm4Td0GcjoFYJHgM5651tOabgGWkp4rYjAtnmEXH3UW5VQfMjBey2R0RZgf8QHEnNVeisLboROoFLuknK7yeEJEG2f+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763163193; c=relaxed/simple;
	bh=wt3aMPTFQiQGC3U38ghU6y+A5m+wLzH6SH1kmcG1VB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a2N//gIAJr619+tchU+XTIA39ilqVbFFakT76e/S5VaRwR4H7uZLixzA9MTP/WntTaPLD4kCFPzSV2+6PBMlaWC9dEEeZnpNDhyC01/qMv0sjpt1IKpJDObO0lW9mOB5aQLwcFc51gEtHRALRdwT9dpnZ2LMl8YQOjIpxg8d4h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LAyDQrXU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BijupKiq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763163191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xzcTfoNqMQQ21c/yBMC2IYTkRzecwHBm9icAEK80Qp0=;
	b=LAyDQrXUGUF8A+hTwbjNc75dRYAASjxMZJDChUCcK0P3BdYzwUIyeIVbmbVcIdRtjyXn2i
	RAq5oCt1N/DEqJxUA66hjqqlxg7IG9N4d6Ji2e6VRa+/DxEQydMOLML4QIRjMYg9SJgWZo
	Do5dRYJ2oncEf8NzrTOPlUPMNgOgCo8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-05NlGRQaPKKg2NLXGEDh6A-1; Fri, 14 Nov 2025 18:33:09 -0500
X-MC-Unique: 05NlGRQaPKKg2NLXGEDh6A-1
X-Mimecast-MFC-AGG-ID: 05NlGRQaPKKg2NLXGEDh6A_1763163189
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso1710236f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 15:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763163188; x=1763767988; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xzcTfoNqMQQ21c/yBMC2IYTkRzecwHBm9icAEK80Qp0=;
        b=BijupKiqUmnC9zp3sERL2+dHh1m3/JwHAT8/k8+5fDgTO2PEIlitjPf2Q1pFOh8WDQ
         TE33AWc3Z3QOctLrzKHFVElK2+JRhENdGLHXaBCm/VC9KsMRE+PmZtQfiiKcza8dQSd6
         rxUrXHOV0MY0wFpBvgBFsUGWRJ+m0aOErTfQD4jA9i8Hr5FJ69oGHu8zDanWvYXpqUWp
         K9w1URBlYuYx9LGO9eD2ypud637vVn71UbDl+Zw+zzvnX8nROnEm/VmkD5Dv+RD2jWJu
         Fowdo4dSE0i8WLaRCsBmDgcsDYBvy1mCZhbVqLcpaCUjPGZ07AlGfLV6+PQBPsAGX9dD
         irEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763163188; x=1763767988;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xzcTfoNqMQQ21c/yBMC2IYTkRzecwHBm9icAEK80Qp0=;
        b=sCE6s36q2bopcKbYGkoConEvzkMbGz/kJXLDlGvb9lhLkm6cBw530+Q01rr8aZX/rV
         R4olhPdwKzCUTjVJ3FA/FUvKSjA5SJDxO5eBVoPiLfR37bHFnmC9ugEFgdkDvavLlOZ5
         d2c/n3G3f8jHBMQkzbxgfylLA7cV07EFDFvtgH7dh+R1r8B3mHWVe1S76K4pkdfsn0EW
         9osblfUsqyf+kBaXNdoRt8jOnaD9NpqVSRFlVQ4sS2dijxqb53BZj7hCkJGxVDIVq8ca
         QCygBpU/RJ7+nM7V0DZaa/BJ/gjSlcqLSFfEtDBe3AbA9XczlmDIWvKvY63cMdnQnZeH
         0fLw==
X-Forwarded-Encrypted: i=1; AJvYcCViczzNGvr3pDUt7K3a0WRh/DnV+ljlNxx4iZAk2y1Rq+UK8M7/IeR0YZEUjbEVyTzvAKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH95f19niU7BSHTfL4k5Hd695zALxKwn5Fp2ROpOaCd7MB2ldo
	S6+HwsGS6WsGU0eRM9mbf6TGInLXv4uagYBBwvW/4yrQwF0OIW0pMe/Yc5llYhtoGVwl7G1g3J0
	xeIlOEDZwQIieYaIqPkzXCN4qmM8bZa4PejGEQYMB7OQLpCDfTUaiXg==
X-Gm-Gg: ASbGnctWvc+8CnVIrs11hZZbL8h3WOUwbYsQf93qxMC1GZYg8YDLYbcI8wY7KYYMJ94
	ftGfYB1DutREJuBECQJDSAowCjbyzDJgVOCYhhoFXYwdaKVFR2UmdWTX1He+uiEVtNHgkXDTIas
	rra7BU3k+zrE/KfTQQBhY3OmA3pivIa8EOFs+eq1aC7P7VX2xcUE2yvHaYVsBdy06NsUN0kBKeb
	HaP9jzL1Rrx7wNnNEEZZJpqsoZWaEsHAamD/lbUpEvwbBoOh3DlSws4ShYcCsnWMNmTOJdDDJ7e
	pwG0tgDOFNB2cYmlcHSR+TNrGBD90nMSHfUTkpTikeqpXDRa5pKQYv5qLHpR3lYQQ+G89rK3wRG
	n1ocvSbXUdF4pFhx7UMRrsv5DTq+pCCvxTFrjkNHT2Dy2kMorTN9Xjjk8voxjjWEbbqT4vhKZN2
	P6xH1d
X-Received: by 2002:a05:6000:2284:b0:411:3c14:3ad9 with SMTP id ffacd0b85a97d-42b58dc1c08mr5411401f8f.21.1763163188580;
        Fri, 14 Nov 2025 15:33:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEHfc0IqhS27PuOIyFgxBdkbYB4ay7P2yMnEdbqJQe0CuJ1VmJB94rOgddACz/D+0WyUxat9w==
X-Received: by 2002:a05:6000:2284:b0:411:3c14:3ad9 with SMTP id ffacd0b85a97d-42b58dc1c08mr5411382f8f.21.1763163188234;
        Fri, 14 Nov 2025 15:33:08 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-42b53e7ae5bsm12647053f8f.8.2025.11.14.15.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 15:33:07 -0800 (PST)
Message-ID: <fed3c66f-c092-4153-a1cf-0a834bcf2397@redhat.com>
Date: Sat, 15 Nov 2025 00:33:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] KVM: SVM: Treat exit_code as an unsigned 64-bit value
 through all of KVM
To: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-8-seanjc@google.com> <aRdKa9jVMt0Rn5tj@google.com>
 <aRdPFEF0XS7Zz5Fx@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aRdPFEF0XS7Zz5Fx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/25 16:47, Sean Christopherson wrote:
> On Fri, Nov 14, 2025, Sean Christopherson wrote:
>> _and_ the hyperv_svm_test selftest fails.  *sigh*
> 
> And the weekend can't come soon enough.  The kernel I'm testing doesn't even have
> these patches.  /facepalm

Yep, my fault; I did the same mistake (in reverse) when preparing the 
last pull request.  Yosry wrote about this a few days ago.

Paolo


