Return-Path: <kvm+bounces-16818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C120B8BDE67
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C10D284DF1
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAF514E2FF;
	Tue,  7 May 2024 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VLmnnpPn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8958014E2C5
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 09:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074418; cv=none; b=F9wwKeVOpJxKUpUrtD3bF4BFGt6Ab7LaMvMYka9F5esJyuyEZwY95A1QxdgEi7ihhXjnPBQRL8Wt6jhOhawIPO1wRxS2GVhAwVa9ngkBQYsjOfp9uBoiCNsgUctWDbqKd8oQxDB9lAz5R6hYln512cg0tMezR79ZNmonPdn0eYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074418; c=relaxed/simple;
	bh=OS4S2atRIPxzLGtafGYTt3DnsuASfFJ6yCAhTYy1u+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ealiar5SCCbIvbIR5AWW4rdoBLn7b8aRlt31vcJdUZ3R3L2gLS+mOOWy8PuQhL/2tx1cYpr8ipZHQNG13YcyecCE0vLOd2y5fgfKOV6rB/cPUIBeFeCmJqRdBh2rlcP7AUMXxB/+xHcKJOREx8OVTLWN43GHbP6XgXkLqAWf/n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VLmnnpPn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715074415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q55ABqTCNonI0FXQbPBXszur4ikvmXTqLMyy1VF/Rvg=;
	b=VLmnnpPns19Q6vhYrlJ9u/L3S2xeKG3nXwcdDi++n3jn1TDPDovlRDbUnHlf/1jl6/PXCN
	FusJDBU+mQsMh3BSRuYOQRUOyBIRgQo+NEJfYTAslL770KShsfvS3zFBHIaCY9NwuooSzb
	qffrjcKMtqn2LJVb0i88ki9utHT8dec=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-CS7BQwawMBCJ74ZS-o4Wlw-1; Tue, 07 May 2024 05:33:32 -0400
X-MC-Unique: CS7BQwawMBCJ74ZS-o4Wlw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7e17cca0f0eso22674439f.0
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 02:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715074412; x=1715679212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q55ABqTCNonI0FXQbPBXszur4ikvmXTqLMyy1VF/Rvg=;
        b=Ow7RZGSg6mujhjCnUsDtzOGfdhCpoI1qQWhSA2JK03IAEd210wnemrGC7g7jpAvC5j
         NKRSEPn72aVTkpdNEx9VvH+7Pq1Ck7DlXdJRQ1Fj/rqxTr5+XXTB5qOb01uxBxC7Exol
         +wyBJ2GHJvX+TV7OikPOmPiMiY3eRk9QwFZeThw1O+PuG0BFToFNsUBtXZdtI8FM9e2s
         6YOn/Kc8gMXabRnkvlyWShBTSWVq+BRuEVLwGY+6sJX3+2r3gvOon+RZ+eTK5ccMkYez
         NtuydKQqW2r49s55c1NX+T2GxqUFpUCRBd436NmtS9pE3kqKJCtcdf6Vvj7qaUhd5dkb
         FpVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxCOXClUmB2bkbEmVm+fQguHFKtxC7J+Ezm/Db8b20bV7R9BeH8pAYBFxhA+zyiGZEukGvhwWfg5lxjYxxjXfk6nte
X-Gm-Message-State: AOJu0YxBdE3nqAH21YD86sL+EHVu9QEhpTzSPqui2OfWEW2X7FnCZa2x
	YRO8J9zBnP36/+HlIqd+ygSTYxL6oEOq6hWZllPfQYnmi8KNiF2xvh/ZWLRU8ur8oK218qhyKUU
	ikp/MlClEHHefYVLJBHoQE5p8m1Em92loroNiMbgxtgGKBOiIEA==
X-Received: by 2002:a05:6e02:1d13:b0:36c:5572:f69d with SMTP id i19-20020a056e021d1300b0036c5572f69dmr14984575ila.1.1715074411803;
        Tue, 07 May 2024 02:33:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGy8kBGxNUFTj9x5oRKEt9YsqYNbn2od4gy+bBYwdTJXnUWfPHHNdagNmRbwKs8dK03PsgQkw==
X-Received: by 2002:a05:6e02:1d13:b0:36c:5572:f69d with SMTP id i19-20020a056e021d1300b0036c5572f69dmr14984557ila.1.1715074411415;
        Tue, 07 May 2024 02:33:31 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n10-20020aa78a4a000000b006ea8ba9902asm9025877pfa.28.2024.05.07.02.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 02:33:31 -0700 (PDT)
Message-ID: <2df3915c-8928-4c01-979e-8c71603a2279@redhat.com>
Date: Tue, 7 May 2024 17:33:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240409024940.180107-1-shahuang@redhat.com>
 <Zh1j9b92UGPzr1-a@redhat.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <Zh1j9b92UGPzr1-a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 4/16/24 01:29, Daniel P. Berrangé wrote:
> On Mon, Apr 08, 2024 at 10:49:40PM -0400, Shaoqin Huang wrote:
>> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
>> which PMU events are provided to the guest. Add a new option
>> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
>> Without the filter, all PMU events are exposed from host to guest by
>> default. The usage of the new sub-option can be found from the updated
>> document (docs/system/arm/cpu-features.rst).
>>
>> Here is an example which shows how to use the PMU Event Filtering, when
>> we launch a guest by use kvm, add such command line:
>>
>>    # qemu-system-aarch64 \
>>          -accel kvm \
>>          -cpu host,kvm-pmu-filter="D:0x11-0x11"
> 
> I'm still against implementing this one-off custom parsed syntax
> for kvm-pmu-filter values. Once this syntax exists, we're locked
> into back-compatibility for multiple releases, and it will make
> a conversion to QAPI/JSON harder.

Thanks for your effort of reviewing my patch. I think if I need cost 
more time about the QAPI, that's outside my initial idea and deviate 
from supporting the PMU Filter.

So I decide to not update this patch now. And wait until I have time to 
look into the QAPI or the -cpu option has been transformed to QAPI format.

Thanks,
Shaoqin

> 
> With regards,
> Daniel

-- 
Shaoqin


