Return-Path: <kvm+bounces-10647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C455986E2D7
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 14:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3934AB22831
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 13:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3FF6EB6B;
	Fri,  1 Mar 2024 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1gO54np"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC6969E1C
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 13:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709301433; cv=none; b=UXUwH/3LYgMk8VxA8er7wB7mT68yKy/i+WTPmK5mxS5jx1uuSSCm0BCSJNDQFDLd0zQ6u/OB5IUsHLybijYVLmJNAoDbrL3i4L3K0KTJeqJ4Ei63oeqDrXGr4+EegNafgzmUOi/2VHSkZDC9ZsqXJHoNrQKQHMxS/JDvkXWtsWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709301433; c=relaxed/simple;
	bh=f/xHck/+LG443adeLDpgOLPz0VMLQVBodeAE5wF558g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EwltJvYGEVcymaYZLUEQChmCCS4G3noDPe3uNGB+PyrQXooigobZngmSmBlfF43eu4QmlIjPp91+qks4V3gC6q+Pe4kGH1XuumPgmaXZ4z2bf2xokVlIhYCxizmbtS5KgRYafXKvAl7gthe7jGiy0G/JuF6b2vF9a/yUWx//+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T1gO54np; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709301431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X7PBjlrpvNONsqh2uMY775tMAp1gZn/T320+nNQVSQ8=;
	b=T1gO54npBC0gYzodTHqP92oUWinnQKGHe+QuC1X86Xnuok+EP1R8OcnTUIfJdgfZbv4Y3u
	sp892Bcfs00E6FRDdWqZbywMN6yyZ7q/JGKO4i8okhp4Bkv5mgBJKfJ/E7br2X1aBhcCgI
	wKgmf+sHbKopcaSOhrk2Fpvy6GVQZcQ=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-Saiu1idUMG2I7qA7Nw3bWw-1; Fri, 01 Mar 2024 08:57:09 -0500
X-MC-Unique: Saiu1idUMG2I7qA7Nw3bWw-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-59fb255d718so2053571eaf.3
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 05:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709301429; x=1709906229;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7PBjlrpvNONsqh2uMY775tMAp1gZn/T320+nNQVSQ8=;
        b=jx2pb+LqF/iBG/dmNq07wAacf4+oImJPpJSmJ2hZeF/TCEH/ehtdRhJZUnPRd5WhdA
         lnEXabkAZK9DsV6SgaD5+F993RbFMk/142jrjtBqlOOeNFbaDf3LiIG3JUq5VA8z61Dy
         /NoKxlZ3z/9kPQZooeWkh59p2ju2U9m4lc1jfgZR5u/OMEl1Gh/cAjX/ZPoa3+Tka5+5
         oav47px1w63ojw0LpmdeQsO0s3qVaAUdW56oLefC5S/Ni2tWeMyd5TV7M/opEKio2gdP
         IEI4wn6tTHaDjVrXispFpHiV/rBbDLcK9Rc6uZuHLzbEfkxouMdGNGj8/MAOmc6oXiRX
         Bjsw==
X-Forwarded-Encrypted: i=1; AJvYcCU3NTeM8ehli5pKKJg0AKbYepn88ILZ5Tp4iSLHJTc805Q/geQtnLwOYXy0dbwyABDh2wPyAcbWjgqLki+iT7u1ZL49
X-Gm-Message-State: AOJu0Ywp1RSrnLgUsYuPDJJpO/qH8WfBgjENjiNUUV2s6yYvh2fA0HW6
	rKQgZPIBUGt/MQGvwGXHfxVcS2dToXBRfgJ1FLr6q30sSrPeM4zLC4lS69sBwQypaysdA+uQ0VZ
	367kzBvtOfpTwEEFFHTMXC9HsTS1HANmX+XP51MerQ0IZdY6/Jg==
X-Received: by 2002:a05:6359:4104:b0:17b:581c:430e with SMTP id kh4-20020a056359410400b0017b581c430emr1629943rwc.3.1709301429081;
        Fri, 01 Mar 2024 05:57:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHAALUYF3MjHnSxAWn3yxvvW7J/Y+wZ+qYcQuBwbpMuvxGNhVX2UbCWs/R+c5oDVW3YrxDr8Q==
X-Received: by 2002:a05:6359:4104:b0:17b:581c:430e with SMTP id kh4-20020a056359410400b0017b581c430emr1629929rwc.3.1709301428811;
        Fri, 01 Mar 2024 05:57:08 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id a19-20020a0ce353000000b00690314356a4sm1874327qvm.80.2024.03.01.05.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 05:57:08 -0800 (PST)
Message-ID: <b4a1b995-e5cd-40e9-afc1-445a9e5f6fa5@redhat.com>
Date: Fri, 1 Mar 2024 14:57:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Laurent Vivier <lvivier@redhat.com>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
 <20240301-65a02dd1ea0bc25377fb248f@orel>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240301-65a02dd1ea0bc25377fb248f@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/03/2024 14.45, Andrew Jones wrote:
> On Fri, Mar 01, 2024 at 01:41:22PM +0100, Thomas Huth wrote:
>> On 26/02/2024 11.12, Nicholas Piggin wrote:
>>> Add basic testing of various kinds of interrupts, machine check,
>>> page fault, illegal, decrementer, trace, syscall, etc.
>>>
>>> This has a known failure on QEMU TCG pseries machines where MSR[ME]
>>> can be incorrectly set to 0.
>>
>> Two questions out of curiosity:
>>
>> Any chance that this could be fixed easily in QEMU?
>>
>> Or is there a way to detect TCG from within the test? (for example, we have
>> a host_is_tcg() function for s390x so we can e.g. use report_xfail() for
>> tests that are known to fail on TCG there)
> 
> If there's nothing better, then it should be possible to check the
> QEMU_ACCEL environment variable which will be there with the default
> environ.

Well, but that's only available from the host side, not within the test 
(i.e. the guest). So that does not help much with report_xfail...
I was rather thinking of something like checking the device tree, e.g. for 
the compatible property in /hypervisor to see whether it's KVM or TCG...?

  Thomas



