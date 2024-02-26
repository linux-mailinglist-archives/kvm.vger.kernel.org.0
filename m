Return-Path: <kvm+bounces-9777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE17866EF8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77D5D1F27310
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54747C6EF;
	Mon, 26 Feb 2024 09:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dUwThaGG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489037C6DE
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 09:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938504; cv=none; b=FJy/du86MDjpK/3rbebGk1HFjcakePDMkmN5DvfRwxET1VTKKP9hwz1o8v4XesBIkt7sqqNwzYpgvEiJcavGuYSUx2JnDZBh0B/wNrgzMOcxEgKwKk+lPqzTg/xeBrt6NDkrj6PkmrbmqggncSfyxONLyDysb2Ij14M8Awpk9H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938504; c=relaxed/simple;
	bh=tBZE/eacc6Q7GBJFLAV/5+38gZ+VtYaaXoBQ10tKnVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkkjXc4NDSkH8tAfvStrtoBBUCY+pLWeJpZa0lPKjU3+JINKA8lHedgS2yBYz7ES3GgSIJSX0EU1Zyt25ah64AYoK/W3Fs10hugOQiCqNvUylVTDWz09jy8dMvPdglqdQIuYWHrAxChyelI1jHMmDL4MzzqS0uEuQM8Klf2Xqoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dUwThaGG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708938501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nd4KNSHTsPg8sEq3delbthyC/APIQx24iJ0AiYrHHVk=;
	b=dUwThaGG8mYIi57UaaQsSd7f0aYIMvHG5yxgq31Pu2+tUCkESC0IZ+RYH1ImWHxzyWqCGm
	yaFlpFQWKyoNgc5WRh0hG6PCRW8sd9NMHOc0UnED9UrtO/rAOHmB5aGFQzEipY8ZqqN8VY
	Tt0C1uVNCy909uOIU4Gj8bQFhkiCm1E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-hbzsDbr8N4Se4eyCeMU9sA-1; Mon, 26 Feb 2024 04:08:19 -0500
X-MC-Unique: hbzsDbr8N4Se4eyCeMU9sA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d60ac6781so907095f8f.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 01:08:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708938498; x=1709543298;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nd4KNSHTsPg8sEq3delbthyC/APIQx24iJ0AiYrHHVk=;
        b=wSIjQdWyGbz01rahq0h2fVYTDyLSTJdEtvZgisZCcZIvgghxiKimhrE1ubCdFRnTeP
         t815AZ6FPapnSr8SL38V5ucHDm5G7hqCi/+8C1BaAIlebTTNv8DVDxoyXmcvdSi8vT2w
         rV8UzScZLZtaHadSLE31LdMzEYwDNsWnKBvD47sp79551vM2GWnWf05nRED0JYmbhZ0C
         ltrRdgDIcMqACenQ1VDNCO5lJsbg2P0LYLi2LQhzoQIoKys3ZrrxgzSR/havquYU/tOf
         OWAFpXrxSE4t50++HxHBzOdIP2el6DQRwz70wvkJJeXhSL55Gf5QMWinQuSNZrFg3yc5
         DVRA==
X-Gm-Message-State: AOJu0YwtS8yWsPS2UwXjNSHPnyT+/J+MPtKKhCKTYRFLPR2cXuHz+M1r
	iMN8klxJ5WNxg9q9XigZd0m4QNhOLx+1OnBbDXLc33b3/cuSeiwfUogDxmqx6ReRBcqIHJYnael
	hORuDNUGnLPqu/sui9ERpfY2gzmRb1MifKUsGDYKHBh+aWPX94Q==
X-Received: by 2002:adf:f350:0:b0:33d:855d:7457 with SMTP id e16-20020adff350000000b0033d855d7457mr4399503wrp.21.1708938498792;
        Mon, 26 Feb 2024 01:08:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFjmnajipOzaVs1cymu3XapHbGqxmQuOJVM3lzDCaND8iWQ5Iz+3PcFM5ZHEhGzbfZOV1QvQ==
X-Received: by 2002:adf:f350:0:b0:33d:855d:7457 with SMTP id e16-20020adff350000000b0033d855d7457mr4399486wrp.21.1708938498451;
        Mon, 26 Feb 2024 01:08:18 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-176-215.web.vodafone.de. [109.43.176.215])
        by smtp.gmail.com with ESMTPSA id w4-20020a5d4044000000b0033b7ce8b496sm7491263wrp.108.2024.02.26.01.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 01:08:18 -0800 (PST)
Message-ID: <d7d4644f-0c82-42b8-b211-f53d8135786c@redhat.com>
Date: Mon, 26 Feb 2024 10:08:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v5 0/8] Multi-migration support
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240221032757.454524-1-npiggin@gmail.com>
 <5383a1b2-20ca-4d07-9729-e9d5115948dc@redhat.com>
 <CZEUWE22JA80.3S73L9F5A04RK@wheely>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CZEUWE22JA80.3S73L9F5A04RK@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 09.10, Nicholas Piggin wrote:
> On Fri Feb 23, 2024 at 5:06 PM AEST, Thomas Huth wrote:
>> On 21/02/2024 04.27, Nicholas Piggin wrote:
>>> Now that strange arm64 hang is found to be QEMU bug, I'll repost.
>>> Since arm64 requires Thomas's uart patch and it is worse affected
>>> by the QEMU bug, I will just not build it on arm. The QEMU bug
>>> still affects powerpc (and presumably s390x) but it's not causing
>>> so much trouble for this test case.
>>>
>>> I have another test case that can hit it reliably and doesn't
>>> cause crashes but that takes some harness and common lib work so
>>> I'll send that another time.
>>>
>>> Since v4:
>>> - Don't build selftest-migration on arm.
>>> - Reduce selftest-migration iterations from 100 to 30 to make the
>>>     test run faster (it's ~0.5s per migration).
>>
>> Thanks, I think the series is ready to go now ... we just have to wait for
>> your QEMU TCG migration fix to get merged first. Or should we maybe mark the
>> selftest-migration with "accel = kvm" for now and remove that line later
>> once QEMU has been fixed?
> 
> Could we merge it? I'm juggling a bunch of different things and prone to
> lose track of something :\ I'll need to drum up a bit of interest to
> review the QEMU fixes from those who know the code too, so that may take
> some time.

Ok, I merged it, but with "accel = kvm" for the time being (otherwise this 
would be quite a pitfall for people trying to run the k-u-t with TCG when 
they don't know that they have to fetch a patch from the mailing list to get 
it working).

> I left it out of arm unittests.cfg entirely, and s390 and powerpc seems
> to work by luck enough to be useful for gitlab CI so I don't think there
> is a chnage needed really unless you're paranoid.

At least the s390x test does not work reliably at all when running with TCG 
without your QEMU patch, so I think we really need the "accel = kvm" for the 
time being here.

> I do have a later patch that adds a memory tester that does trigger it
> right away on powerpc. I'll send that out after this series is merged...
> but we do still have the issue that the gitlab CI image has the old QEMU
> don't we? Until we update distro.

We only run selected tests in the gitlab-CI, so unless you add it to 
.gitlab-ci.yml, the selftest-migration test won't be run there.

  Thomas



