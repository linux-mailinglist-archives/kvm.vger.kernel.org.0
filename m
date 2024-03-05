Return-Path: <kvm+bounces-10875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 838AC871615
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A77D21C20C2E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95D47BAF5;
	Tue,  5 Mar 2024 06:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bD2RNtHi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF2E43AC5
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 06:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709621577; cv=none; b=E7WQZOVMFFOjk29VY4te4IiesHff4FOtUL0xUB7O9vSBDLAlzeMSvMcYAxIGgClHwmTVEjKkLCBtOt7qrntUoS3G6klbFAnoQIy1xZbNune26uQ0sCxryt953w90JcfHH9XwdETzWyJ4LRRLKgqxPzKfC1JBbrTSOXufADXR7bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709621577; c=relaxed/simple;
	bh=ymocqJc1f5kWMMreqMv5DLV3/0cLM8ClbEnLpTzgif8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FoAlniqjqBOJJGtAGA8LdDva5DLhui6esq9YvfhzqryopUBszPVnNYeN883xKgldkTrWLP/VSZ1U6Vo36U5yQAwE4KJZHiguuX6HwLwb81Z9grRrMI1aekB6QN8vjDHUkS2L/2Ehe76nWJvEtEbkdR6Fr9KRpAa+gMZLAcS45kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bD2RNtHi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709621574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=055i0Cw+qSF55YTg7cbDTnODJKfJ+o7mIN7GUyBDy/4=;
	b=bD2RNtHiYl/pi5Bd8fKQPZfG0tfgGEBEJ8NOy6MMx7QUKMOwIrhmgBgMft+2NfmiBQSub2
	x1wcqBmbX4IBCn4mWDAeUDOrTXAAW2vh0OOQViF4OqD2M/a/ajLBLi+q1U3TrbzbV6jfhY
	XHIGx8X6gbMIxYU4wmLmY6SLtKma3gE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-AqHKUjwPNNCljqlqjUk7_Q-1; Tue, 05 Mar 2024 01:52:53 -0500
X-MC-Unique: AqHKUjwPNNCljqlqjUk7_Q-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a3fb52f121eso362769866b.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 22:52:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709621552; x=1710226352;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=055i0Cw+qSF55YTg7cbDTnODJKfJ+o7mIN7GUyBDy/4=;
        b=N/dLU3pMYFMrXJDeZP1AInH/1EEm1vk+LBVMTp+lU43U4Y/Ma2uMMPR6C+92W4SpAQ
         gu6KKQe2kAajT/OpDX4IzYazaGpI75ozolaP6l2RMmZZ9LeiCYY6y/kQvCIHmFiPER92
         mhYhiMrYFu91AEJMUFQvt+JlmhsJbe8vPlytsPAgb3lRsHR6Acxtv9BpRmncY83Nfyyy
         I7Zcuf5zl3oopOyPXKMNSmsaRJPD2iC5ifBbdWSkLJ3eG6RPcj6pcSKMPYkcumIujfxl
         i+TdFCnYct1+bFvEfiOxgA01xgYPxWYo0WHDV07uPQUBcUQWkMoyoTY/JeykoXlM4mnK
         ao1A==
X-Gm-Message-State: AOJu0YwGJ/MrAvzLQxVGyK6FPFlzsuAKLROra5jfTitCcYP5Hfg3l8p7
	ojpXJu1T2wy3faKLEjzSJ7ARN/EMUVHoWE7EdpqxGEkzx8JFARo8paQBkf6ZQknUclOyu9NhCnG
	89Zwn0LHhov3867ojnqBJqGPY55Sc7FgNjg71VvARANcSnPe3DNxoAb0ZjQ==
X-Received: by 2002:a17:906:475a:b0:a40:4711:da20 with SMTP id j26-20020a170906475a00b00a404711da20mr7932087ejs.34.1709621552521;
        Mon, 04 Mar 2024 22:52:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFajVdOaJs4uKX0LYrWLK+X2XMHvDfhEUWWpjcLyw7CAYFHHlfoPf9mDziaodNnuUxasFUVcg==
X-Received: by 2002:a17:906:475a:b0:a40:4711:da20 with SMTP id j26-20020a170906475a00b00a404711da20mr7932065ejs.34.1709621552193;
        Mon, 04 Mar 2024 22:52:32 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-243.web.vodafone.de. [109.43.178.243])
        by smtp.gmail.com with ESMTPSA id uz3-20020a170907118300b00a44bb63f29csm4007506ejb.47.2024.03.04.22.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 22:52:31 -0800 (PST)
Message-ID: <839ca22a-b6e6-4e53-9819-cf803fb18101@redhat.com>
Date: Tue, 5 Mar 2024 07:52:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 7/7] common: add memory dirtying vs
 migration test
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
 linux-s390@vger.kernel.org
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-8-npiggin@gmail.com>
 <e967e7a6-eb20-4b2b-ab7a-fc5052a3eb52@redhat.com>
 <CZLH3XUGU8Z8.2R73ILJ3ISWN8@wheely>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CZLH3XUGU8Z8.2R73ILJ3ISWN8@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/03/2024 03.50, Nicholas Piggin wrote:
> On Mon Mar 4, 2024 at 4:22 PM AEST, Thomas Huth wrote:
>> On 26/02/2024 10.38, Nicholas Piggin wrote:
>>> This test stores to a bunch of pages and verifies previous stores,
>>> while being continually migrated. This can fail due to a QEMU TCG
>>> physical memory dirty bitmap bug.
>>
>> Good idea, but could we then please drop "continuous" test from
>> selftest-migration.c again? ... having two common tests to exercise the
>> continuous migration that take quite a bunch of seconds to finish sounds
>> like a waste of time in the long run to me.
> 
> Yeah if you like. I could shorten them up a bit. I did want to have
> the selftests for just purely testing the harness with as little
> "test" code as possible.

Ok, but then please shorten the selftest to ~ 2 seconds if possible, please.

  Thomas



