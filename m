Return-Path: <kvm+bounces-19423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E33FA904EEC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 777382812D7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE6516D9D7;
	Wed, 12 Jun 2024 09:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIRt93KF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9764516D4C3
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 09:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718183732; cv=none; b=XkM6GmrXUhsld7F2Hh/uJdFZ5pMHvHtX/FO1ZqSWTYv7zwcWoDE6vXfcjMWgQ4gNvs2f2OWq9wIWvlpnjZT65q1SaoxLSrv/BwCk0zkjjP8UYjVdHFp3z1dSP/5gIGRX8PskJFIL9XpCqwMnULUJnOZ7UM2G3Bo9HwXqCJ4JI/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718183732; c=relaxed/simple;
	bh=ZZLDZGrsXleuFBc4RsExldckDr+PAkGbC1Cmc2bDEB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s3dXx4/dk8WwN04wOc0rN5GAa4nzfaDcYZtgeBPxMGl8SGjjsi6+VxX4g9duNOGEI56S3YxLOyekCYN1lXQ/DQ2OE1VrRTkfE8Fi4WPZOfnP2+AKX/KwtGhMe80kA5hXhAj3kgen8/8zWlNer7IcSJYAz5v+LVQQHvC8eKJdznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gIRt93KF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718183729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=un8SRk1QK3gh73P062VSrSrJKKXRnZBfCkdy6o8Wkfg=;
	b=gIRt93KFx2i0XCm+L8zMKHuXL6HrCpzHFHb73tBciPEoJNO2CS38Paeftb82QFDB0vmafm
	VyumD6ZUo3HkPpoH9EAv0fX/ZXw2mdaeq3ktJL4LJ6mehOUdZrnwf9ppQe8FGcRWjCmAge
	2pzsX1AKazTCZUVix4/LA+vb62V6V68=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-uv12xrZGPjadgiPNRRTPQA-1; Wed, 12 Jun 2024 05:15:27 -0400
X-MC-Unique: uv12xrZGPjadgiPNRRTPQA-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2c2c5ca75a2so1552506a91.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 02:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718183726; x=1718788526;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=un8SRk1QK3gh73P062VSrSrJKKXRnZBfCkdy6o8Wkfg=;
        b=iXmcVt/3mNbtuysoseDvjfDHp5qCdEAagGHfnbsm00D/GyEXRZXH1M+aYWIgqrVrN9
         ixP++RVZLCjM26K4xLaQlrh6ybJKWXXPhEgdfgvezQefaLin4yDxjXOlvsHNmnipavkQ
         52cNylqf6xPScb2dRQYrEtj/aGZTzHZulv98A9S4QCL3RoTS0961Vx8K6wsKqZycehM1
         xOgjZWaCG6XcqvhKlcXKg/I+O5JXyLFf9PMsuOw7m0ftZevVbk5r6F30zLwTc0PVCMmt
         W7Mf5RuM6u8obaBEZqGiPxbg55DR3qrWZ6CNWPnF/BzlG5HlrKa71UgZ5HD2yldKal0G
         HIeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrwM/ehFV79Cyehikngf48WkBUvATBMlvdjduID1Mlckok4caWZkoDWNHRgedOHhYLl4qjBVLHNNltoBDK+y4Gi5bv
X-Gm-Message-State: AOJu0YyHPnJZS8CXIxUZEEco9NCQD62cDWCEWc5eCrKpWRavBB68Shx6
	LaC28MWmdCIjN1idzXD8Jc9twvwBc85FnYRnThFgIshq+jXSIiYWBgFipNShbToivgXTDCssBZo
	U+zXVdobF9/C7TK06lEzfLkKTwshETiyMAu7QedKxLFJ4+rpwdT8FRdrs7ysa8rg=
X-Received: by 2002:a17:903:32d0:b0:1f5:e635:21e9 with SMTP id d9443c01a7336-1f83b5f24f8mr14183335ad.2.1718183726600;
        Wed, 12 Jun 2024 02:15:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlfi8iK/GU9xosOkQREwF9CY2gAivPhKjECT4Z/o9Qr5ZBG4/An2Y8v8HVWdDCyHn+JqWBBg==
X-Received: by 2002:a17:903:32d0:b0:1f5:e635:21e9 with SMTP id d9443c01a7336-1f83b5f24f8mr14183205ad.2.1718183726217;
        Wed, 12 Jun 2024 02:15:26 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f2adsm118813225ad.24.2024.06.12.02.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 02:15:25 -0700 (PDT)
Message-ID: <d1b3e694-820c-4693-bee4-1569941be486@redhat.com>
Date: Wed, 12 Jun 2024 17:15:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1
 writable
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Catalin Marinas
 <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20240612023553.127813-1-shahuang@redhat.com>
 <Zmkyi39Pz6Wqll-7@linux.dev>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <Zmkyi39Pz6Wqll-7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 6/12/24 13:30, Oliver Upton wrote:
> Hi Shaoqin,
> 
> On Tue, Jun 11, 2024 at 10:35:50PM -0400, Shaoqin Huang wrote:
>> Hi guys,
>>
>> I'm trying to enable migration from MtCollins(Ampere Altra, ARMv8.2+) to
>> AmpereOne(AmpereOne, ARMv8.6+), the migration always fails when migration from
>> MtCollins to AmpereOne due to some register fields differing between the
>> two machines.
>>
>> In this patch series, we try to make more register fields writable like
>> ID_AA64PFR1_EL1.BT. This is first step towards making the migration possible.
>> Some other hurdles need to be overcome. This is not sufficient to make the
>> migration successful from MtCollins to AmpereOne.
> 
> It isn't possible to transparently migrate between these systems. The
> former has a cntfrq of 25MHz, and the latter has a cntfrq of 1GHz. There
> isn't a mechanism for scaling the counter frequency, and I have zero
> appetite for a paravirt interface.

Thanks for letting me know the cntfrq will block the migration between 
the two machine. And we don't have the solution for it, which means it's 
impossible to migrate between these systems which have different cntfrq.

> 
> On top of that, erratum AC03_CPU_38 seems to make a migration from
> Neoverse-N1 to AmpereOne quite perilous, unless you hide FEAT_HAFDBS on
> the source.
> 
> These issues are separate, though, from any possible changes to the
> writability of ID_AA64PFR1_EL1, which still may be useful to userspace.
> 
I think I can still making the ID_AA64PFR1_EL1 writable to enable 
migration on some other machines.

Thanks,
Shaoqin

-- 
Shaoqin


