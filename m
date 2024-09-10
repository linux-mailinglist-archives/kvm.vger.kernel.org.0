Return-Path: <kvm+bounces-26319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37707973DE1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6807287800
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D332A1A2578;
	Tue, 10 Sep 2024 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YgTEh6G4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D4316C684
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725987495; cv=none; b=QAO6lDgHvxSiwm0e2wcww8aBV5ITMAmiEi9a8L0SP7Mrtb6vafvA6Q3gmdaveD6jjxrmT5aaNgS/kukabvA1+Z8wJUE1HAy8GK8b+R3YB1TrCKNiOTKcaxfbnVPgAIYJpKmiwnJACOZJmpj2ruv4EHPkeVm69Vm4uW9jW+R1mzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725987495; c=relaxed/simple;
	bh=4v52kYrlZvcwhIJAHl9ilmcQ71L0ovXMd1HF1OIcHbA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LFNbm0BE96I8ZypmKiGyVmgoqJyNrjbVUZf3evUJtyv8cvhFhkXYEHLBCb/83hCV9q3khhw6jmeMglV1axpl9O7pHtts2aBpMnOyxl4aUDwy13M2aYiIMRFrp35cjlXZj+OSqT2zWbTv3Jzhzw18mSi5PXLKLypjq/STOvrXE/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YgTEh6G4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725987492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L3+edoe6WxSd0OTGPdj4N81sBPaLPjfWiCyN1a2X/cc=;
	b=YgTEh6G4ln9sv7otD5VWB7lEaGnsIPJJn5k2qnWejf9993kHsdRxHxby2M/n/xfhiO0K++
	LMwIOkj3VOMES6pFwzv8WrlOqiXxq7E2ptDEVwvllASqNVCrYsJ3OmOtsE3TkKtlNyCznx
	BTtJ+P8/SGovx7wBG77qD0xuaARybm8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-wlVbLBaNP_-YS67QM143_A-1; Tue, 10 Sep 2024 12:58:11 -0400
X-MC-Unique: wlVbLBaNP_-YS67QM143_A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-377a26a5684so2698555f8f.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 09:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725987490; x=1726592290;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L3+edoe6WxSd0OTGPdj4N81sBPaLPjfWiCyN1a2X/cc=;
        b=kxNc0p8I9YvRFHVc0Hg399NWsrvPc1h6z1U10CBgk4zC45H+aBcpX+y1fsqk1poj+k
         KadUQ+AAnuKsMaIat7C0ytzUPguvKNcfRecutP6C7XqvT/BlTKfMN+4XLWyK9kRBSadp
         G6xQeC4eNT/Dezhc35mXNaMQHMoGpFXCa4iC1fbSHJPSeid28d/+oM7nV6x117pGr5fU
         YjhTNmfVXbMzikTWyqRLqYKwTSmFur7YQyj4sKtj4EuMPvpNBAT4qTOjtICvXJsay1Co
         tZsvpS6YFp9V2TIbzeEpEaEqiu+43iCJm2+hL7UmvsV+918fO4j2Og/fhZZqXsM95Jnd
         qtAA==
X-Forwarded-Encrypted: i=1; AJvYcCWxPQn9+Pm0gVIW3sdjrFLDpqewTtvJsoLi/asPg8fCfyO2BwguPWicW+7LHwSE9M3m0qs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfLMGTWQVOz5BOaxSDGB2tktjrx98efR1w2TL/tJD1lJ8+Fsng
	zxWKtczaPcYhtjmILbs6bqW+gOWZmC1ZBX8cuGmVDH12+a1c742BE8hW202/Ox/rpj0vDrkOttJ
	vV6BLSLLHj84pqASDnZ6jpMRanFnOtCENCN9JZYJNI5gZ6DGmZA==
X-Received: by 2002:adf:b1c2:0:b0:368:5b0c:7d34 with SMTP id ffacd0b85a97d-378895c8b74mr9587253f8f.22.1725987489616;
        Tue, 10 Sep 2024 09:58:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQap9ZxfyGUQuX0INHN1FqrQ5iDp3n7nwg3x781wvh/c+dC6wQ8IL9oYZNBmvnWeNdIbQVYg==
X-Received: by 2002:adf:b1c2:0:b0:368:5b0c:7d34 with SMTP id ffacd0b85a97d-378895c8b74mr9587237f8f.22.1725987489078;
        Tue, 10 Sep 2024 09:58:09 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3789564a18asm9375772f8f.15.2024.09.10.09.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:58:07 -0700 (PDT)
Message-ID: <9aa024ba-a0b7-41b4-80e1-e9979a9495ec@redhat.com>
Date: Tue, 10 Sep 2024 18:58:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Tony Lindgren <tony.lindgren@linux.intel.com>,
 Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
 xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZrrSMaAxyqMBcp8a@chao-email> <ZtGEBiAS7-NzBIoE@tlindgre-MOBL1>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZtGEBiAS7-NzBIoE@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/30/24 10:34, Tony Lindgren wrote:
> On Tue, Aug 13, 2024 at 11:25:37AM +0800, Chao Gao wrote:
>> On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>> +static int __init setup_kvm_tdx_caps(void)
>>> +{
>>> +	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
>>> +	u64 kvm_supported;
>>> +	int i;
>>> +
>>> +	kvm_tdx_caps = kzalloc(sizeof(*kvm_tdx_caps) +
>>> +			       sizeof(struct kvm_tdx_cpuid_config) * td_conf->num_cpuid_config,
>>
>> struct_size()
>>
>>> +			       GFP_KERNEL);
>>> +	if (!kvm_tdx_caps)
>>> +		return -ENOMEM;
> 
> This will go away with the dropping of struct kvm_tdx_caps. Should be checked
> for other places though.

What do you mean exactly by dropping of struct kvm_tdx_caps?

Paolo


