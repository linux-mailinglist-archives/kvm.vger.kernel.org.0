Return-Path: <kvm+bounces-26736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2439D976D95
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2E131F25B57
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B351BAEFB;
	Thu, 12 Sep 2024 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eP3Ykjit"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918DB1B373C
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726154296; cv=none; b=G/r6BF09yAFuljinpwQiFh9eQO5OeedZ0nCKnD3AXG7BJkRQmxk+SbV8PUtplVkT5pDdUoz10iOL3ewdqFn2fgzPgxvmwXD7XziLhnDgOKhyZ6ZXRgdm7MNoAcAPq3j8NL4Vz3196Y68s0hI44B4C6kFVnlssNT1ARtO+o1kQ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726154296; c=relaxed/simple;
	bh=z/CSIGhzGAJ6yQfoy1UjHvvviX5AswQ5fkhP/ynCMCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V/fgfPvbj68IaeJxt9CZXUGnkf6hZrYFYZ/VRxCr5ZIsipFxJfSc/OBY4UVTQMOtQ4SjEmSU6nYvpI1oaUtuxnIofGQKKWii7uOISneAxo4jbvEqEETdBc9GeY6PBFOcTG4R4lJFT9aGNL4XN0itg83myYQQJ+vQSX9qvqgImYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eP3Ykjit; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5356ab89665so1248936e87.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 08:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726154292; x=1726759092; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qadnu6w4716R7Te7VmARnSUsF4fCexk0T4oxtMhFq48=;
        b=eP3YkjitaiI61v3kJg2Ko5hl4hCPjRuIVH7p56a5dgzdZpLRFeY2bhz3pR85iSCul7
         QOItqjzy8Qlf7L9AJK6TlFbTy3f9gsSy5T5k5ZMJeWVxExxm18SOTXahFXplC7n35Dnv
         5Bv+hqXETDFZA2hWwH4jbrJwxJ+3b0yNodtVE4KMeS7Cjsca3rjq6HQTMiArspkVqv+W
         lsEWHy36UMzLN2J/iLvca7EuzSuMAHE4d2bDa0q0+wF6MkXwVqn7xA4p+qPX5dYfAee1
         SHtZ5CteIJdFmFz4NPN7wTSHeUonryAv3y4/ii6Vn2n6EWOJDuFa94oBZX4IUv6G3jVY
         nVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726154292; x=1726759092;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qadnu6w4716R7Te7VmARnSUsF4fCexk0T4oxtMhFq48=;
        b=wI0VvXbrAuoHRlE+RRPRuEH4Ibqp6+9IJuZWBgFaqUt8qUHcbLxQdy5PxHXJv+Q8J9
         aO1K2UQ6gzsQ0trs27LFjia4EqynB9D8jyDBy1cCqQbn80NspzpcHvAiv+n29UeohJE/
         P5YjN17V4qNqjPKhGdXXmwnxqBbwA8uQn8E4rSR08O/uUcSG/X8qAdjetclK69W9W5bD
         IRCFBCnwcrVumNfTI4V52iNOS37MULFFrQChjaKflX9R1FArB+1w+En/QXJQbLb9MBuG
         +QlF8G8n+5v2213qqeplFNUEC0BXRjYcJNnQL40o3om7IoQAd/gMI3M6uuW3w1Ffwf+y
         gPSg==
X-Forwarded-Encrypted: i=1; AJvYcCUHZFeh/WfGoOxdw/lzRrT3fhjts3RBCv70GRH7jaNKpcfkF+qRlcZPfMLNk0et1X/roJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq1MRw6MfeI42aj66EDGNXdN657k8GcLGRiZTDDR6NVC5TZYnn
	q1ruPaDu07fY+9RL//oqkalkJgTYKA+9DiFgi80hUmDDbvC6pw4kOrnaxtnK+Aju1fPL03wvAfQ
	s
X-Google-Smtp-Source: AGHT+IFtyhbkBND4k51Ntr0LXILFEPKNCYxivVaYOnX1h0BQLBpP6MGg0hsk0EOia9UyFHLEQvqjbA==
X-Received: by 2002:a05:6512:3b22:b0:536:5644:6086 with SMTP id 2adb3069b0e04-53678ff495bmr2229336e87.52.1726154290817;
        Thu, 12 Sep 2024 08:18:10 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:75b8:2c66:dc25:5ab3:ad59? ([2a10:bac0:b000:75b8:2c66:dc25:5ab3:ad59])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d2593c9a5sm759772466b.52.2024.09.12.08.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 08:18:10 -0700 (PDT)
Message-ID: <b5695d6b-04f2-4569-b7f8-bd8dc87fe552@suse.com>
Date: Thu, 12 Sep 2024 18:18:09 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <caa4407a-b838-4e1b-bb3d-87518f3de66b@suse.com>
 <aa764aad-1736-459f-896e-4f43bfe8b18d@intel.com>
 <2a2dd102-2ad9-4bbd-a5f7-5994de3870ae@suse.com>
 <45963b9e-eec8-40b1-9e86-226504c463b8@intel.com>
 <55366da1-2b9c-4d12-aba7-93c15a1b3b09@suse.com>
 <e2a11f6d-96d3-4607-b3f2-3a42ba036641@intel.com>
 <80555977208f10df437696bac0f2354fd8f6ff61.camel@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <80555977208f10df437696bac0f2354fd8f6ff61.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12.09.24 г. 18:12 ч., Edgecombe, Rick P wrote:
> On Thu, 2024-09-12 at 17:07 +0800, Xiaoyao Li wrote:
>>> I.e if we disable SEPT_VE_DISABLE without having ATTR_DEBUG it results
>>> in a panic.
>>
>> I see now.
>>
>> It's linux TD guest's implementation, which requires SEPT_VE_DISABLE
>> must be set unless it's a debug TD.
>>
>> Yes, it can be the motivation to request KVM to add the support of
>> ATTRIBUTES.DEBUG. But the support of ATTRIBUTES.DEBUG is not just
>> allowing this bit to be set to 1. For DEBUG TD, VMM is allowed to
>> read/write the private memory content, cpu registers, and MSRs, VMM is
>> allowed to trap the exceptions in TD, VMM is allowed to manipulate the
>> VMCS of TD vcpu, etc.
>>
>> IMHO, for upstream, no need to support all the debug capability as
>> described above.
> 
> I think you mean for the first upstream support. I don't see why it would not be
> suitable for upstream if we have upstream users doing it.
> 
> Nikolay, is this hypothetical or something that you have been doing with some
> other TDX tree? We can factor it into the post-base support roadmap.

The real world use case here is a report comes and says " Hey, our TVM 
locks up on certain event". Turns out it happens due to the hypervisor 
not handling correctly some TD exit event caused by a SEPT violation. So 
then I can instruct the person to simply disable SEPT_VE_DISABLE so that 
instead of a TD exit we get a nice oops inside the guest which can serve 
further debugging.


> 
>> But we need firstly define a subset of them as the
>> starter of supporting ATTRIBUTES.DEBUG. Otherwise, what is the meaning
>> of KVM to allow the DEBUG to be set without providing any debug capability?
>>
>> For debugging purpose, you can just hack guest kernel to allow
>> spet_ve_disable to be 0 without DEBUG bit set, or hack KVM to allow
>> DEBUG bit to be set.
> 

