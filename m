Return-Path: <kvm+bounces-18164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A94E38CF972
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:44:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F988282011
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1A117C60;
	Mon, 27 May 2024 06:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlWtgNAH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D79317BA7
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716792073; cv=none; b=hE/dvp0M5Yw7BlOWybPaxwuwxOuGMQn6v66pvE2FesJ+yU75rQyrOCq6X52Ylgou4P09HPGu9Dl18hAT8kXyf8H8NSPaRK3fTSO/jQ2ttTYkOuEbhefsflQzKh8cHivz67xYyFoLJJNAys9TrrjlkgPSVQ8CT4JnxgAApivuRZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716792073; c=relaxed/simple;
	bh=xqcWoMmgcVTILjPvLmYCSYT/xoReaHBvvDWRAa6SqrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BktiwvbqCOH0W5mBcqOl/M682F9bG+0vU14ZrdTXo/AMwtiBM+Wysu9Bm+o2xMHjZU14E2SbOvMmRqbUS+Y/Q77KyiYPE3LPbldMYHrFjNtONMZZDedGA/lX72q8SHKS70nZWzqLqYK1AnoXTxx5tdBcofyNFQgloez4LBpgxWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YlWtgNAH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716792070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDQ4+f7uSOIPxyxtatT2QjghoY3eF9jP0el/KnAqVDY=;
	b=YlWtgNAHkHllggx3WKwYFhwE+hjJf6JSJwkt/32uBHcv/KAwQDR2IZLhTmBwB+kyMQFb2p
	uwK05Fl/W3A6CppSuW8hymvBMGrpuFwbetQptOamQ1oHxE13UFAqxo/sEmx8c1mHchB/9i
	/7UiZtqksPm/fc+8jXWJ969eOZ+UMzw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424--oHRHL1CP8mzh6aHorICpg-1; Mon, 27 May 2024 02:41:08 -0400
X-MC-Unique: -oHRHL1CP8mzh6aHorICpg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ba0bdd4d63so1107429a91.2
        for <kvm@vger.kernel.org>; Sun, 26 May 2024 23:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716792067; x=1717396867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GDQ4+f7uSOIPxyxtatT2QjghoY3eF9jP0el/KnAqVDY=;
        b=vJzCdRqeiExUDacto1r5daDfDbiqxoHhWBlzI7lOZwpuKC/6kdXn4xFYkwzsBfsyYj
         LcrPHcQ7Z8k87q0Zxg1wSGipQKMN8l4BGnySFZA3XDSAC4RgnIoRY8WIIy+vCpufQO/s
         Xmh6GcJIIEdRxN9h0M6vgFIpUKCrqX7N5YAKkl2/nWmMYiwoSHoxU8zJ5IkpPtVV1SVR
         NkKsIa5fV6tu7d6W45hEhPlm+WqdyKsBUTIfjmpoziURbiWtapwvSEMQ/msvFWKU6ybq
         K0GJKRhm0+1jGzdE87+rfvnRK0PYGacsB9xQEclGayoPcxfzd7ivIuHSTpSNiGLb+Sv8
         xmMA==
X-Forwarded-Encrypted: i=1; AJvYcCXakwdzn2kXReHUFuEcgL0o2/0sxXbBfVHmP+H80LuuKxwneSI1Ugjf2eP4iAO87llmt8b1Gj5ZbQvN6rdam4DWwX9I
X-Gm-Message-State: AOJu0YyUDAo2T2xK5ySrumz8SfldKYr2lf96fsvuxbtOLrohXc68N/gb
	RSihN72M3xv6Wc1FWqRzF1DywYp+ABOLWM6TWE1MUQo4xkdmN8SbeZO5soyI29ezBsmDM1Wvklg
	Q5HqFk2WpW7PMdMtTs7h0SaI4I1y1esRBAOwMNl7A46gOkpf9sA==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr8055013a91.2.1716792066833;
        Sun, 26 May 2024 23:41:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEL7QRzKtBCyiR8SVB39tTRtC2TtbQpijjse3JQktv824/f92qgYmTQuQaeYz4emWsaV/J+/Q==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr8054991a91.2.1716792066333;
        Sun, 26 May 2024 23:41:06 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bdf1f931c8sm6262050a91.50.2024.05.26.23.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 May 2024 23:41:05 -0700 (PDT)
Message-ID: <d3733e25-eb1e-4c19-b77f-d68e871c9f0f@redhat.com>
Date: Mon, 27 May 2024 14:41:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240409024940.180107-1-shahuang@redhat.com>
 <Zh1j9b92UGPzr1-a@redhat.com> <Zjyb43JqMZA+bO4r@intel.com>
 <ZjyZ1ZV7BGME_bY9@redhat.com> <ZkG4nlwRnvz9oUXX@intel.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZkG4nlwRnvz9oUXX@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhao,

Thanks for your proposed idea. If you are willing to take the PMU Filter 
Enabling work, you can do it. I won't update this series anymore due to 
the QAPI restriction. I really appreciate if you can implement that.

Thanks,
Shaoqin

On 5/13/24 14:52, Zhao Liu wrote:
> Hi Daniel,
> 
>> Please describe it in terms of a QAPI definition, as that's what we're
>> striving for with all QEMU public interfaces. Once the QAPI design is
>> agreed, then the -object mapping is trivial, as -object's JSON format
>> supports arbitrary QAPI structures.
> 
> Thank you for your guidance!
> 
> I rethought and and modified my previous proposal:
> 
> Let me show the command examples firstly:
>    * Add a single event:
>      (x86) -object kvm-pmu-event,id=e0,action=allow,format=x86-default,\
>                    select=0x3c,umask=0x00
>      (arm or general) -object kvm-pmu-event,id=e1,action=deny,\
>                               format=raw,code=0x01
>   
>    * Add a counter bitmap:
>      (x86) -object kvm-pmu-counter,id=cnt,action=allow,type=x86-fixed,\
>                    bitmap=0xffff0000
>   
>    * Add an event list (must use Json syntax format):
>     (x86) -object '{"qom-type":"kvm-pmu-event-list","id"="filter0","action"="allow","format"="x86-default","events=[{"select"=0x3c,"umask"=0x00},{"select"=0x2e,"umask"=0x4f}]'
>     (arm) -object '{"qom-type":"kvm-pmu-event-list","id"="filter1","action"="allow","format"="raw","events"=[{"code"=0x01},{"code"=0x02}]'
> 
> 
> The specific JSON definitions are as follows (IIUC, this is "in terms of
> a QAPI definition", right? ;-)):
> * Define PMU event and counter bitmap with JSON format:
>    - basic filter action:
> 
>    { 'enum': 'KVMPMUFilterAction',
>      'prefix': 'KVM_PMU_FILTER_ACTION',
>      'data': ['deny', 'allow' ] }
> 
>    - PMU counter:
> 
>    { 'enum': 'KVMPMUCounterType',
>      'prefix': 'KVM_PMU_COUNTER_TYPE',
>      'data': [ 'x86-fixed' ] }
> 
>    { 'struct': 'KVMPMUX86FixedCounter',
>      'data': { 'bitmap': 'uint32' } }
> 
>    - PMU events (total 3 formats):
> 
>    # 3 encoding formats: "raw" is compatible with shaoqin's ARM format as
>    # well as the x86 raw format, and could support other architectures in
>    # the future.
>    { 'enum': 'KVMPMUEventEncodeFmt',
>      'prefix': 'KVM_PMU_EVENT_ENCODE_FMT',
>      'data': ['raw', 'x86-default', 'x86-masked-entry' ] }
> 
>    # A general format.
>    { 'struct': 'KVMPMURawEvent',
>      'data': { 'code': 'uint64' } }
> 
>    # x86-specific
>    { 'struct': 'KVMPMUX86DefalutEvent',
>      'data': { 'select': 'uint16',
>                'umask': 'uint16' } }
> 
>    # another x86 specific
>    { 'struct': 'KVMPMUX86MaskedEntry',
>      'data': { 'select': 'uint16',
>                'match': 'uint8',
>                'mask': 'uint8',
>                'exclude': 'bool' } }
> 
>    # And their list wrappers:
>    { 'struct': 'KVMPMURawEventList',
>      'data': { 'events': ['KVMPMURawEvent'] } }
> 
>    { 'struct': 'KVMPMUX86DefalutEventList',
>      'data': { 'events': ['KVMPMUX86DefalutEvent'] } }
> 
>    { 'struct': 'KVMPMUX86MaskedEntryList',
>      'data': { 'events': ['KVMPMUX86MaskedEntryList'] } }
> 
> 
> Based on the above basic structs, we could provide 3 new more qom-types:
>    - 'kvm-pmu-counter': 'KVMPMUFilterCounter'
> 
>    # This is a single object option to configure PMU counter
>    # bitmap filter.
>    { 'union': 'KVMPMUFilterCounter',
>      'base': { 'action': 'KVMPMUFilterAction',
>                'type': 'KVMPMUCounterType' },
>      'discriminator': 'type',
>      'data': { 'x86-fixed': 'KVMPMUX86FixedCounter' } }
> 
> 
>    - 'kvm-pmu-counter': 'KVMPMUFilterCounter'
> 
>    # This option is used to configure a single PMU event for
>    # PMU filter.
>    { 'union': 'KVMPMUFilterEvent',
>      'base': { 'action': 'KVMPMUFilterAction',
>                'format': 'KVMPMUEventEncodeFmt' },
>      'discriminator': 'format',
>      'data': { 'raw': 'KVMPMURawEvent',
>                'x86-default': 'KVMPMUX86DefalutEvent',
>                'x86-masked-entry': 'KVMPMUX86MaskedEntry' } }
> 
> 
>    - 'kvm-pmu-event-list': 'KVMPMUFilterEventList'
> 
>    # Used to configure multiple events.
>    { 'union': 'KVMPMUFilterEventList',
>      'base': { 'action': 'KVMPMUFilterAction',
>                'format': 'KVMPMUEventEncodeFmt' },
>      'discriminator': 'format',
>      'data': { 'raw': 'KVMPMURawEventList',
>                'x86-default': 'KVMPMUX86DefalutEventList',
>                'x86-masked-entry': 'KVMPMUX86MaskedEntryList' } }
> 
> 
> Compared to Shaoqin's original format, kvm-pmu-event-list is not able to
> enumerate events continuously (similar to 0x00-0x30 before), and now
> user must enumerate events one by one individually.
> 
> What do you think about the above 3 new commands?
> 
> Thanks and Best Regards,
> Zhao
> 

-- 
Shaoqin


