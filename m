Return-Path: <kvm+bounces-30729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20CB99BCC32
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB97A283676
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5AF1D47C8;
	Tue,  5 Nov 2024 11:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VEebRM7x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1FA1D3593
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730807615; cv=none; b=PchHjvz1Zbbwrf3FBPvku/fqM3EH7En3X/IE0Anu21VAnsQLn693vobedC5oao5aVQPw8KmUTfWjh9yMmkIN2EsFUug2mB3Czu3LIGdeYUCCYIT86yeVbJt0BHLITtKw+6e+DqRXGmz/mPH9XigotQ7VvU70NCj8+IN3dsOtlyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730807615; c=relaxed/simple;
	bh=lN2iaGDnfG9FBXEjRhKPN+eYVDHZ6GIe34XaLwd2N9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TCAyJURJZO6Psx/beKk11H0I25G+leL91w5xd1eaWvXIeKRxnZ8RSlrMvEsjVqjY+Z1S+5blFIog+0RcH9e9GfqobszegQ+OD4mnJEJrMutw05tf0sjZheCklX6jfQlsejlWxfBvhS05HAD30sQ+9O4yRS9TH0i/s6QTxMzswxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VEebRM7x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730807612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E9GCCeK8H/eNEIQ4EVE9mAtGB0y27+rVaBOR1tTIrZ4=;
	b=VEebRM7xrZszxylRglpECkB3fJ+TVXwvvw0z37Vm4V5REmqBE/9q9tfWZme4us+MDzpkcy
	CZ0ebUVOveiSLAtNS1On1OemWgnqMEJm3M+lC/zYSZ17euWzQO7Sw+7CRJniZL1TRFg3BG
	J55S/mWlVHA3OVWFosjTVLHiilxqbWw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-ekCDYjhJN82E6RmGXd6bBw-1; Tue, 05 Nov 2024 06:53:29 -0500
X-MC-Unique: ekCDYjhJN82E6RmGXd6bBw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-431518e6d8fso35465175e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 03:53:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730807608; x=1731412408;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E9GCCeK8H/eNEIQ4EVE9mAtGB0y27+rVaBOR1tTIrZ4=;
        b=iNJpjE6PcIdsDuPc5CJWXbLkGRSNueSlNHgxTVQ3O0N/1ke19e3k57fqLjoGWO1270
         baw8oh6PSRhyCM2OZobdHqS0pUWQMF15paZ5cTpYUtB/zcnuH8UyU2NmNouupcI0dN6m
         532lsAaaHi8iWhwKCNYrIp3RtsdqptSXoW3p2nXTNFOHe4Yv0DCSjetsuVbIuMb2cfiU
         HWKPZ3Rfp9+VkvZq38JAGzinnNa7YHHQx/BA2FvzHjsllwvxBuHrtJUE7CHZL7BbDPP+
         XGnfEhdytdpUkffpjlmJ58MexcDAbB0ORzNKkNSksIg+zGpCk4J0Csssx0dEP+wrVizJ
         +zCA==
X-Forwarded-Encrypted: i=1; AJvYcCUKPd/0v6JU6/LGFrOk4j49xiILovy8aVQIR4xJr4hoAXpdUNpJnYwHl4d5zUlH4KfHvYg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfan0Gaw3KaDHHiWwDVw/L6zs0HNHxsWRCtztSwIu75/RHQVjc
	MoXBcO7vsgViPOEogB1IR0cPQP2yKLD0bJiTRuJslNCoCaIBd3uuPk3nuS402O2+w37r4VliGqN
	14S/Ea8on1ovci2cE9Zq6GnnJAdiyVAn4M+pVv6fil0cgFxZ/xw==
X-Received: by 2002:a05:600c:354e:b0:431:52f5:f48d with SMTP id 5b1f17b1804b1-43283297ac6mr147935945e9.31.1730807608400;
        Tue, 05 Nov 2024 03:53:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6EqY6VfpsDjvDwkrOiOHAjD2Nj9rcwaC+RwyaQlFF6KPQP+tdcTVgv2YGxElyqcm3HhSRvQ==
X-Received: by 2002:a05:600c:354e:b0:431:52f5:f48d with SMTP id 5b1f17b1804b1-43283297ac6mr147935685e9.31.1730807608018;
        Tue, 05 Nov 2024 03:53:28 -0800 (PST)
Received: from [192.168.10.28] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4327d5e8562sm186017205e9.23.2024.11.05.03.53.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 03:53:27 -0800 (PST)
Message-ID: <44627917-a848-4a86-bddb-20151ecfd39a@redhat.com>
Date: Tue, 5 Nov 2024 12:53:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/60] i386/tdx: implement tdx_cpu_realizefn()
To: Xiaoyao Li <xiaoyao.li@intel.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-35-xiaoyao.li@intel.com>
 <82b74218-f790-4300-ab3b-9c41de1f96b8@redhat.com>
 <2bedfcda-c2e7-4e5b-87a7-9352dfe28286@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <2bedfcda-c2e7-4e5b-87a7-9352dfe28286@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/24 12:38, Xiaoyao Li wrote:
> On 11/5/2024 6:06 PM, Paolo Bonzini wrote:
>> On 11/5/24 07:23, Xiaoyao Li wrote:
>>> +static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
>>> +                              Error **errp)
>>> +{
>>> +    X86CPU *cpu = X86_CPU(cs);
>>> +    uint32_t host_phys_bits = host_cpu_phys_bits();
>>> +
>>> +    if (!cpu->phys_bits) {
>>> +        cpu->phys_bits = host_phys_bits;
>>> +    } else if (cpu->phys_bits != host_phys_bits) {
>>> +        error_setg(errp, "TDX only supports host physical bits (%u)",
>>> +                   host_phys_bits);
>>> +    }
>>> +}
>>
>> This should be already handled by host_cpu_realizefn(), which is 
>> reached via cpu_exec_realizefn().
>>
>> Why is it needed earlier, but not as early as instance_init?  If 
>> absolutely needed I would do the assignment in patch 33, but I don't 
>> understand why it's necessary.
> 
> It's not called earlier but right after cpu_exec_realizefn().
> 
> Patch 33 adds x86_confidenetial_guest_cpu_realizefn() right after 
> ecpu_exec_realizefn(). This patch implements the callback and gets 
> called in x86_confidenetial_guest_cpu_realizefn() so it's called after
> cpu_exec_realizefn().
> 
> The reason why host_cpu_realizefn() cannot satisfy is that for normal 
> VMs, the check in cpu_exec_realizefn() is just a warning and QEMU does 
> allow the user to configure the physical address bit other than host's 
> value, and the configured value will be seen inside guest. i.e., "-cpu 
> phys-bits=xx" where xx != host_value works for normal VMs.
> 
> But for TDX, KVM doesn't allow it and the value seen in TD guest is 
> always the host value.  i.e., "-cpu phys-bits=xx" where xx != host_value 
> doesn't work for TDX.
> 
>> Either way, the check should be in tdx_check_features.
> 
> Good idea. I will try to implement it in tdx_check_features()

Thanks, and I think there's no need to change cpu->phys_bits, either. 
So x86_confidenetial_guest_cpu_realizefn() should not be necessary.

Paolo


