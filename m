Return-Path: <kvm+bounces-23827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A923D94E7E3
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 09:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE3F91C21A09
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 07:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D451A15C143;
	Mon, 12 Aug 2024 07:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTO08Vcg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC867158203
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 07:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723448007; cv=none; b=FGC3dYmcSi969nDxRktTe/REJqk8t/Oq7AZrMszrQuFh9I9bE3DN3OsPWoZRx/6fimkP4tL9lHhSOXHEsCuGvQlTUw/t/bNTCf7kpTYcF2zhXE+y/mMKa/choKlNwcIZOBGscb4WgTlB5R3vW+pZARV1lK1Nr+GWMYXM1bFjeJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723448007; c=relaxed/simple;
	bh=KP/+uM5wKO6T4Po/0S6BCrZKYgCURAJ/+3Qp3Io+aFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rH1cD5KpBxZxNdAppfRg6EpgzpTPGpuKSXt7pzdUHkVTzgFCTxr1c+uJXUPrQ01vjhsNimo9ynRb6EguOCCRV5oz/+ih0JNOoemZyQIY9FdFfKbyAizqgllDfx/NS8/P3KtmXhWFnDZDi9y6asQ02/xWHY41Oe0CknaANEcBm5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTO08Vcg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723448003;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zT6wuCKiRsYdiQxfFQSrTjOcl1iJ0UV60/tdF3C+AGg=;
	b=UTO08Vcgi1bKzVc0+nHZ8Y1uhB6SJbP2gJiAU3PE6elXuhZ87JQmIj6P80IzBPMz2fYbv1
	jzu0bNwO/bi6h5WTa9QSxIz1xnLcRp/FSGELKJp1ADU91BhI4BcOdvJojNjT3RvzwrIFll
	tkw38SI4FXXbMQ8y6o+5XBD7DWqqoX0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-azUyNZKhNFSn7sekAwCNNw-1; Mon, 12 Aug 2024 03:33:10 -0400
X-MC-Unique: azUyNZKhNFSn7sekAwCNNw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4280645e3e0so29096885e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 00:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723447988; x=1724052788;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zT6wuCKiRsYdiQxfFQSrTjOcl1iJ0UV60/tdF3C+AGg=;
        b=TpWkK/LG5tTVNFHjxJ6TPAOtJo9BbJOB9JWKih8Fcoyuzi4CHP1i3dGoCVcle7WW+S
         A1hlQcmsGpFXg5/JR1YihHwTiMsq5vjJ7fNfKrcduK6jWQaEUNWI6MwMJbyYkm2hJIyP
         E46KFnIZ03S1jno246TH+FD9pjM5JCR49CrlwRidjmTBBV/1boLNCzUf/yjDAQDgQtqd
         iTX5OszR8JhkCqEoOahoUC2fvbt3eyc3vOsEUbTtic86twjjI35UviLU4EJ8rMg2U81z
         KGcWy3XsNX9Ieb7IMAkghGhE9fSjS6CMD55gLDPC0b3Zrq5X1A63dMGBC0L4URNkP+RD
         c+Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXwSYwRB1sKBROZdLy8FV86uAAfrWB0M4gGUsv3uOxtB29iYve7eZmkxrp+Xm2CQbFEWKkFf4J9jWZi3Tw5ylXjQqtB
X-Gm-Message-State: AOJu0YzSRZAiX7RHp3wUM2hiBEd5pQDbFUnQtKCRvnroPMXKxEU0UJU8
	D9m7Pcreb25o0kO9Nknts5UDDa10Fh4k9wH1FtH6Js94TmBIziScdMplF7NCovGuukneZ1sZfLl
	0bCMBHV555BXOspB681pKdujMg8MVcQD0G21xheCmgCMRC8es7A==
X-Received: by 2002:a05:600c:45d0:b0:426:5cee:4abc with SMTP id 5b1f17b1804b1-429c3a29abcmr65727395e9.20.1723447988246;
        Mon, 12 Aug 2024 00:33:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnCkcbvTf91I/LLuOWtCCOIOmgKFN1F9vkNdpjC6am8P5LHrXE56bSD+iUiO+VdlmRX8CE9g==
X-Received: by 2002:a05:600c:45d0:b0:426:5cee:4abc with SMTP id 5b1f17b1804b1-429c3a29abcmr65727045e9.20.1723447987778;
        Mon, 12 Aug 2024 00:33:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4c36bd6csm6701474f8f.6.2024.08.12.00.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 00:33:07 -0700 (PDT)
Message-ID: <8b73937b-9361-4ff5-a4b2-344cc64ed6aa@redhat.com>
Date: Mon, 12 Aug 2024 09:33:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 03/13] tests/avocado/intel_iommu.py: increase timeout
Content-Language: en-US
To: Cleber Rosa <crosa@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-4-crosa@redhat.com> <ZqdvR3UFBCAu8wiI@redhat.com>
 <CA+bd_6Lepg=uXs1NViYV5eZBGot2ZRAYUi-NDXwSBsdBk17LPA@mail.gmail.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CA+bd_6Lepg=uXs1NViYV5eZBGot2ZRAYUi-NDXwSBsdBk17LPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Cleber,

On 8/1/24 03:02, Cleber Rosa wrote:
> On Mon, Jul 29, 2024 at 6:30 AM Daniel P. Berrangé <berrange@redhat.com> wrote:
>> On Fri, Jul 26, 2024 at 09:44:28AM -0400, Cleber Rosa wrote:
>>> Based on many runs, the average run time for these 4 tests is around
>>> 250 seconds, with 320 seconds being the ceiling.  In any way, the
>>> default 120 seconds timeout is inappropriate in my experience.
>>> Let's increase the timeout so these tests get a chance to completion.
>> A high watermark of over 5 minutes is pretty long for a test.
>>
> I agree.
>
>> Looking at the test I see it runs
>>
>>    self.ssh_command('dnf -y install numactl-devel')
>>
>> but then never actually uses the installed package.
>>
>> I expect that most of the wallclock time here is coming from having
>> dnf download all the repodata, 4 times over.
>>
> Exactly.
>
>> If the intention was to test networking, then replace this with
>> something that doesn't have to download 100's of MB of data, then
>> see what kind of running time we get before increasing any timeout.
>>
>>
> I was trying not to get in the way of the original test writer.
>
> Eric,
>
> Are you OK with replacing this command for a simpler file transfer?
> Any suggestions?
Sorry I am just returning from PTO. Yes I am OK to replace it with a
file transfer if it takes too much time. When the test was written we
just found out a bug with that exact dnf install command so at that time
this was a reproducer. Either replace it with a dummy file transfer or
withdraw it from the automated tests.

Thanks

Eric
>
> Regards,
> - Cleber.
>


