Return-Path: <kvm+bounces-19774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CED90ADF4
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 14:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C24D61C2234F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 12:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DCD195985;
	Mon, 17 Jun 2024 12:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCEEk1A5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC2B190052
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718627378; cv=none; b=I16obBHNRdZkWMdrE+K4xR0rFQJrwfxes+qEsH/U8f7/D2DwqJtOed82vYcHsx2rHFL3HqFOEONEwheu1iN/itXX4Yy/qu7eDbId4dTidtf0Phq/4A+djdrzAQFWXihuciExlchfByh/cr4HsdsLKt7G18gE/dBRbx3cb+HNOKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718627378; c=relaxed/simple;
	bh=oXXpiunHz1XPLIz1naFMTm6sFnP7b0TdXzOlcK0P/sM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YpdgQGqP1ekE2JRmrA5I5PqvBknI/GRX0bSYZE/OPp54pTuqVQzZ617uEKKGmrvRU9cBRmaBetWxayH49HkBINb2R8LDufoH1Tm73Bg6ESoP4q/UMarDUjyi3CpHs6LxGEshq0yDUuvGeqenHN8lwu2UAhyD4fUCrItpeiw1UhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iCEEk1A5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718627375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4ssGu5P5LE/MFN4qx06ygb2gBN8nmvpUBOwBXD3IEM=;
	b=iCEEk1A5RwhT6ajl9PMgt54qFxNeUk2yT/6UqTaBmjvTn1pk6allBIZvBZlUMp/mKXtdY4
	hOW6oPtybHwF37uTU0e1sASbdqocQDroWcISELbAlYvcpBk+69u4sKqNTYLC2iXxgdz8DY
	khZeDW3DULqxBuG2AUScjWUK1SpUQ1I=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-EruT_elJPCK3HyrOOPy-vw-1; Mon, 17 Jun 2024 08:29:34 -0400
X-MC-Unique: EruT_elJPCK3HyrOOPy-vw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2c2db44fac9so1167111a91.3
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 05:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718627373; x=1719232173;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4ssGu5P5LE/MFN4qx06ygb2gBN8nmvpUBOwBXD3IEM=;
        b=JJAZQAN1IeVibR9Ucpa8NcOdnWaYav/O1MgN7E5zG4+IapZoKwWYOWpahMeJNzLo6E
         i+crg/L56YLQIqHYiYf3aCe/G2LUz1QlQfL9RszxixrjaX6SrZlD44dNyryql4E7W97L
         TysrEmtYnK4mIjAucbyc0dh5+K8JUi1d3mwEJNoJ4ar4OnbyOlhXGzEG+qglEFctvNu7
         +vHMEmLQmpilRMVR2MZ0FEaYCXZLSZ3wGSZWf3tlcn/HoEhSugy9dffyf+MRWmqsR47B
         oAAbA2XsO6CINN5/aSZoraSSJr82rKD8jnv9rRzoyoG3vEM204U5spikK6gUL38J4glW
         161A==
X-Forwarded-Encrypted: i=1; AJvYcCVy9JeIHSnN4bxyhA0ojrYBl504+oRCtPCEWGucOBsc1T/5Hc68PzMbtH8LKLJH7E5/+kSHsEjptef0m0alSXZzJIsv
X-Gm-Message-State: AOJu0Yy8mrWCuBK+wRjY6zlGHuV2J6xqcPv9uBCfbEaxXv9uwrs7R+n3
	0oQ5xMHrfWC/nSNMLgeo2+RqHiHld/dqpxmi/qWG25kk8AyBIYrzudObBpkOZDOQp7xb5ZC8yAm
	10VpMhClwVZjZ+JAbtkToucueuwBGgsiUfVCUBqvx2XC9X4QusQ==
X-Received: by 2002:a05:6a20:5aa9:b0:1b0:1be7:3708 with SMTP id adf61e73a8af0-1bae7e3d928mr8545363637.1.1718627373367;
        Mon, 17 Jun 2024 05:29:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOU5fYRtot9iBJXy2SS9IX2XSkrNEwI68apkvLYUeP2Vlv30jHjv3k+GFqCmYhxr4fz+B5Wg==
X-Received: by 2002:a05:6a20:5aa9:b0:1b0:1be7:3708 with SMTP id adf61e73a8af0-1bae7e3d928mr8545338637.1.1718627372892;
        Mon, 17 Jun 2024 05:29:32 -0700 (PDT)
Received: from [10.72.112.55] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc967356sm7261218b3a.63.2024.06.17.05.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 05:29:32 -0700 (PDT)
Message-ID: <9db95188-71c2-491a-a4c7-434e7cd3c407@redhat.com>
Date: Mon, 17 Jun 2024 20:29:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1
 writable
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Catalin Marinas
 <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20240612023553.127813-1-shahuang@redhat.com>
 <Zmkyi39Pz6Wqll-7@linux.dev> <8634pilbja.wl-maz@kernel.org>
 <7f1ca739-42f5-4e3a-a0c9-b1eac4522a97@redhat.com>
 <86zfrpjkt6.wl-maz@kernel.org>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <86zfrpjkt6.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 6/13/24 16:42, Marc Zyngier wrote:
> On Thu, 13 Jun 2024 09:31:45 +0100,
> Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> If we don't care about the FEAT_CNTSC right now. Could I fix the
>> compile issue and respin this again without the background of enabling
>> migration between MtCollins and AmpereOne, and just keep the
>> information of the different BT field between different machine?
> 
> As I said, I think this patch is valuable. But maybe you should
> consider tackling the full register, rather than only addressing a
> single field.

Yes, it would be better to tackling the full register. I will put more 
time on other fields in the register and try to making more field to be 
writable. But currently I just respin the series with deleting the 
machine specific information and fixing the compilation issue.

Thanks,
Shaoqin

> 
> Thanks,
> 
> 	M.
> 

-- 
Shaoqin


