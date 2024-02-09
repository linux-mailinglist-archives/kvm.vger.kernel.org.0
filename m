Return-Path: <kvm+bounces-8482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF00984FD97
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 21:31:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70582287D03
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 20:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB53611E;
	Fri,  9 Feb 2024 20:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lwDhLP6K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC315673
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 20:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707510682; cv=none; b=ekjKyejcwlcy/+bvHb100k+j2pCH/S8jWXtZNenJ+bNo2DwV9PgflkTe7Hm9i2SIyxNx2i0NIgRAJPuyPui9gjBiFQaXZj5tytVMzbcnO9duv1p/k9vMjQBoq0hEhg26kiTjsNKqssqPFRRqZPICV4kRFtl/O4RnjBiifPXzBj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707510682; c=relaxed/simple;
	bh=jtlLdqT7JxvhfFw+24KTD5ocDWh9zjIw61lTQPuBtQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bzWzt4LeiASaz36o4+8rIBnlQQ82ERRySUPCLquje6caOrw/j+PfY+DmMrG33LPwdxUM5rnbL25t9MKbNs4tMk9FNvfD6z9t+l8WArRbjbO9RDYP+vRN42knY/tXvIcB4ayKqzYz5DP0nNU/5/JvtGCeYt7J74VeE5yvyLDQwWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lwDhLP6K; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso14731839f.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 12:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707510679; x=1708115479; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O2KY1VYsqophcwtt4/SkR/t54NG5tkSwXfgubEbyghk=;
        b=lwDhLP6KHkVT3YJcxK1mNRY2oOqyMAPb71CHyiIZOXLn7aFwtxVp13GuJOegPr+ueP
         Ok6rY7/tsLQHamp59taTVQhhfjIu6ybqlfCKCuAPT37c/lEFD9Jsm/4ttUSUoQl4DzV7
         JHfLpxkN6MVcuhCU9gUcbWaCtij6/aCNxLyKSVxsDoA9FZ6wR8MXLv6Rve9l0kUDyLTK
         NL/IlwAdVO9G9Wpj+7HA+jlW80OY3LViChzrz9P85Y0rqn55h2kVMBfJoGLsaV14F5Lr
         AOAucWQDy2QBkfPqwMUzwCT37WWZbS1or/tSWYTTrTCkRpB0a+l73yLN21DFSm/JRuaB
         di2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707510679; x=1708115479;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2KY1VYsqophcwtt4/SkR/t54NG5tkSwXfgubEbyghk=;
        b=rweyvNpaP1RYnKj+hqN0JTqqa7eHdrMv5rb68dveOVdpptB0VvHvvH0g9cwPcvj9ol
         1aCY+eGNfPm8DyNB9MGWEtuoX9tr1B5DEQ7vPW3XyPrrhaV9x0gxF5sZvkwCXe8y+8rn
         O05iqxmK0HW3hJLGlWtrIEh7eXabOTL2uQsQFi8U/exqexGWYylKBwLeqBznZKzF3PAn
         bpWmmJ5Z0uz3qaCDOI7pqU2wCG1hN8gRBvc9Yok5mhUiIRGZqZnKqaX5qHZ7Nc+OHHkV
         b93PRXMmxBoJqwRLevO2dW9Rul5tp7KlWN0kqCdLRjIRoElpKhZ4RbFQun/9NnBCa0Bb
         st6A==
X-Forwarded-Encrypted: i=1; AJvYcCXq1vrLWAJpav8qxrMm1+n8vSNoshM9SauU1rup2wJ9L5RDGRTSFcBY+JgqzkP5SVRVoaomJElnOSkVIWFFQK2SSSAD
X-Gm-Message-State: AOJu0YwV+JB14QCLepzbralJqRElaFv6t8Sw9B/dFosNo/Dbc0dVif8V
	61jMdT2Jqi9UgYvvxjt6R+O01hO0KWYmqo+ByMWgi0vBJ32Zm1AEjbJ6cRLc/T4=
X-Google-Smtp-Source: AGHT+IHcDmXuHAkGrM0JU+hJKxb+Mr26Xk4UsUGJPp6H3XHnx79km1fA7r4jshGN4U8romr1XVv5uQ==
X-Received: by 2002:a5e:c706:0:b0:7c4:3a7e:ccc with SMTP id f6-20020a5ec706000000b007c43a7e0cccmr555511iop.0.1707510679074;
        Fri, 09 Feb 2024 12:31:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU032Qk23ZO/SpfO9usp9xETVY6Y0LyvDwtcN9rGuAyd7wQ/bi9wtDDm4s8ZTW2T4bmdxoYdm9BaB0pS6JYTm6GJBpbNLZP0k9cMSFt7liNpVESHJxcDYLXh1iC6JDSgIZl79LSrrfG9SdKprmMTmcWCtRZN9Ly2oLL7Agb7qCKs/pjs2mH8SIsJthVL5PmPaQfTgKInH6BR3ccaFX62zUiAPzpd7CYB0/RK1VIkCVhhWnAks/BdOKPkIn+xrOyAHWhPPsuiPzMnx1GRNQ9M3VaTVsmADK244Uit0oAMayI2pjE9B0CmCBBfF574vXOnNPntEfKXgDAiElTroarmYfvOHyPjmK2gXCXNsOF2Zi7pH4oKqHHLuMVv7PQyAFTXrlltF90a9QJtnJvMQIgm0LXAywby8u0Fi6I2UiWrOJBANOZdlAseUaI4rr/k4cKaqMqE4CKO4ASh78GAjv56xPINNwRCTcL/0G7wA9svgzA62cMZJny7S1/vDAcLGrHKFJSaLo0jLBkGDEyD/Oy5MDEiyFvBfwwmMRPAQ==
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p18-20020a5d9852000000b007c408b504f9sm24837ios.50.2024.02.09.12.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 12:31:18 -0800 (PST)
Message-ID: <9285b29c-6556-46db-b0bb-7a85ad40d725@kernel.dk>
Date: Fri, 9 Feb 2024 13:31:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] Coalesced Interrupt Delivery with posted MSI
Content-Language: en-US
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
 Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
 Paul Luse <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
 <051cf099-9ecf-4f5a-a3ac-ee2d63a62fa6@kernel.dk>
 <20240209094307.4e7eacd0@jacob-builder>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240209094307.4e7eacd0@jacob-builder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/24 10:43 AM, Jacob Pan wrote:
> Hi Jens,
> 
> On Thu, 8 Feb 2024 08:34:55 -0700, Jens Axboe <axboe@kernel.dk> wrote:
> 
>> Hi Jacob,
>>
>> I gave this a quick spin, using 4 gen2 optane drives. Basic test, just
>> IOPS bound on the drive, and using 1 thread per drive for IO. Random
>> reads, using io_uring.
>>
>> For reference, using polled IO:
>>
>> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
>> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
>> IOPS=20.37M, BW=9.95GiB/s, IOS/call=31/31
>>
>> which is abount 5.1M/drive, which is what they can deliver.
>>
>> Before your patches, I see:
>>
>> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
>> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
>> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
>> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
>>
>> at 2.82M ints/sec. With the patches, I see:
>>
>> IOPS=14.73M, BW=7.19GiB/s, IOS/call=32/31
>> IOPS=14.90M, BW=7.27GiB/s, IOS/call=32/31
>> IOPS=14.90M, BW=7.27GiB/s, IOS/call=31/32
>>
>> at 2.34M ints/sec. So a nice reduction in interrupt rate, though not
>> quite at the extent I expected. Booted with 'posted_msi' and I do see
>> posted interrupts increasing in the PMN in /proc/interrupts, 
>>
> The ints/sec reduction is not as high as I expected either, especially
> at this high rate. Which means not enough coalescing going on to get the
> performance benefits.

Right, it means that we're getting pretty decent commands-per-int
coalescing already. I added another drive and repeated, here's that one:

IOPS w/polled: 25.7M IOPS

Stock kernel:

IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32
IOPS=21.44M, BW=10.47GiB/s, IOS/call=32/32
IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32

at ~3.7M ints/sec, or about 5.8 IOPS / int on average.

Patched kernel:

IOPS=21.90M, BW=10.69GiB/s, IOS/call=31/32
IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/31
IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/32

at the same interrupt rate. So not a reduction, but slighter higher
perf. Maybe we're reaping more commands on average per interrupt.

Anyway, not a lot of interesting data there, just figured I'd re-run it
with the added drive.

> The opportunity of IRQ coalescing is also dependent on how long the
> driver's hardirq handler executes. In the posted MSI demux loop, it does
> not wait for more MSIs to come before existing the pending IRQ polling
> loop. So if the hardirq handler finishes very quickly, it may not coalesce
> as much. Perhaps, we need to find more "useful" work to do to maximize the
> window for coalescing.
> 
> I am not familiar with optane driver, need to look into how its hardirq
> handler work. I have only tested NVMe gen5 in terms of storage IO, i saw
> 30-50% ints/sec reduction at even lower IRQ rate (200k/sec).

It's just an nvme device, so it's the nvme driver. The IRQ side is very
cheap - for as long as there are CQEs in the completion ring, it'll reap
them and complete them. That does mean that if we get an IRQ and there's
more than one entry to complete, we will do all of them. No IRQ
coalescing is configured (nvme kind of sucks for that...), but optane
media is much faster than flash, so that may be a difference.

-- 
Jens Axboe


