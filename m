Return-Path: <kvm+bounces-57922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD68DB813DC
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 19:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FD0417AF20
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33062FF649;
	Wed, 17 Sep 2025 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JhgSprj4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105C02FABFA
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131585; cv=none; b=e3pZSWUMqPEHgOKz/F6Jw9kjX/sz9UnZ2B7b9XFCkBqpm1t1jr2sY9MnsxzaUvotuQLrObqhlsCDtzoKCIJPJKNkSFveQ6wdEQdPiP9dCFiSJvXvpncsfvZKV/RPbsDHbKBNQtqsdF6tV4UyY8ob74Ewlp2xDZPb8otH9FyYyhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131585; c=relaxed/simple;
	bh=dS6P4Fy5DaIo/YXZ79yUSnu6NwFGN22rzXKl7LDAP5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxsNx8VDsyNFAyHnelqD/Pxe8T1dTORDO/QoTPU+17mJKkG1a3kFpglRV77il1F+ozOOKYXYmTg+8PjXvXukhAfQl1g5ERASsY9KafdjGS8sD8JO9s01JYwPs2+k9T2yDQ+Zzf41qexsU5izldJIEzpaoOtwWTK3EybvVvPoQlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JhgSprj4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758131581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BsOoxrYORRFuh2u0wv92Xrzi9f/Pgvquzh9J6cUQvaA=;
	b=JhgSprj4kvchF+4xFpRdk3MGbIwWNMUWDXIJEKzScL9NRb8RuNuxNNMibc18CfQy3h4+F4
	QnE4IsseJvBw5E7KqDNLuoKxRs68Z0HZl9LhZVmtjtAnlGTmTY/H0lCPzyTnf0uuw0+MWw
	wc8Rh5GRFvGHySB13N7fK3InPzRBgNE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-SqBs7385PRuXNttMEgEAhw-1; Wed, 17 Sep 2025 13:53:00 -0400
X-MC-Unique: SqBs7385PRuXNttMEgEAhw-1
X-Mimecast-MFC-AGG-ID: SqBs7385PRuXNttMEgEAhw_1758131579
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so488795e9.0
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 10:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758131579; x=1758736379;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BsOoxrYORRFuh2u0wv92Xrzi9f/Pgvquzh9J6cUQvaA=;
        b=XyJrmbOwjBYO933K9mntoFII49RXii6y7jdEnfrhfpzCX054voAru+I+SJ2uYNVE49
         fiq9U0JYDoR8D13iuP4rmpxnk2klkVE+5R8TXvyEsYpoL1Hp7IM7FsqE0qV8dhaZ/1F8
         hpuQTDqyAOy/Fowqp14p+EFpwkpoeBzJJAS8N5CRW52kiM75GW5SL6JcBcy0WSVOGgkO
         xHMiWDnJq7yyFWh3KyIjvUrnvYbuShcxrnIcFKdTvGgJxHYwCorC5/kUnoVqLlliZVLK
         nv7RLSmuMhfJ2JuvQidgfDfn9xm3gJo9LdXhaLw5JNqaBLk0qTR/AbTFNZCQ0ImTdsl0
         U3eA==
X-Gm-Message-State: AOJu0YyO0U06OpSepZoC1gH3tlg3525gcU6LaheFvlEVvTcmuxPEqMX2
	1evfIRFh0hRcfQ10+Nx53go98HIrmdp7GMzVJfeH68rJOV1O6ND7BhlCV7zP3Vl6lzWF2X/N9qM
	9/mbaYaJ8TGwDheU/c3nWmHvbDY6ubWCrN4zz4tEbT8tZz5Ux4W742lu7yUAeRg==
X-Gm-Gg: ASbGnctJKdPvHZJvbffIcbUmgOWQd2mKp8jyZZdoyHXSUN7zg9y6Enaz0P4pLHmItQS
	wJjx667B5MQEcQly0f2FTMq+Zv1WFOH+dECsGwlao3umic9NCPergT4F9YTyI1LJGEHiQP4cxlw
	leNPjeeLN/pLRc70WzJmj2GmH0K6FUI1RNrXEVp/PofVpZVo9dVodmwFQaCgpeKp+HJVy3NYnvl
	V/pZ/yjpdAegljiKG3NXE63ha+893T4dgBXG00BtsxB1v1bw/caq5MCT1icaFyPrts3kVT3Uj+n
	u5ilTtxf+MSVaHp9gYJCfTadRIXZJ7D4ks8iJKq0wANXAKQ/+29Hi3TjwIZ+NgzxCxQ3rLGBkyW
	wZ28VCW+CSm1CtzNKpYzt74fb3VDra8SYnED9kKydVDo=
X-Received: by 2002:a5d:5f42:0:b0:3ec:4fe:860 with SMTP id ffacd0b85a97d-3ecdfa2b563mr3351046f8f.46.1758131578750;
        Wed, 17 Sep 2025 10:52:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZDdQECqdk4ftkeQUe6DwCYOxRwirGTAlmfFW6vGHNCCmEwkLY9talzACO0i02UjlIlTW7Ig==
X-Received: by 2002:a5d:5f42:0:b0:3ec:4fe:860 with SMTP id ffacd0b85a97d-3ecdfa2b563mr3351017f8f.46.1758131578324;
        Wed, 17 Sep 2025 10:52:58 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.56.250])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc72f5sm213279f8f.39.2025.09.17.10.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 10:52:57 -0700 (PDT)
Message-ID: <0d38af14-53b9-489e-bd10-27bb6c7af470@redhat.com>
Date: Wed, 17 Sep 2025 19:52:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: AVIC vTPR fix for 6.17
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250916003831.630382-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250916003831.630382-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/25 02:38, Sean Christopherson wrote:
> Please grab a single fix for 6.17.  The bug has existed for some time, so it's
> not super critical that it get into 6.17, but it'd be nice to get this on its
> way to LTS kernels sooner than later.  Thanks!
> 
> The following changes since commit 42a0305ab114975dbad3fe9efea06976dd62d381:
> 
>    Merge tag 'kvmarm-fixes-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2025-08-29 12:57:31 -0400)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.17-rcN
> 
> for you to fetch changes up to d02e48830e3fce9701265f6c5a58d9bdaf906a76:
> 
>    KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active (2025-09-10 12:04:16 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 fix for 6.17-rcN
> 
> Sync the vTPR from the local APIC to the VMCB even when AVIC is active, to fix
> a bug where host updates to the vTPR, e.g. via KVM_SET_LAPIC or emulation of a
> guest access, effectively get lost and result in interrupt delivery issues in
> the guest.
> 
> ----------------------------------------------------------------
> Maciej S. Szmigiero (1):
>        KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active
> 
>   arch/x86/kvm/svm/svm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 


