Return-Path: <kvm+bounces-34176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6A79F82E5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 19:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 998F5188076C
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 18:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2E81A0BC5;
	Thu, 19 Dec 2024 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfqPDJzG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF85D19F11B
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734631336; cv=none; b=SBdwbWSQLNoFu1iActos/Jmvyo2EFTgcWNZ8HfK8IgeSyAPr79sYhs1m0JXTetX2umQJRepQgogJqNDQhTMTAW6msr4DrOBLDLLtzp7DPmDutH6qo5vM+KvC+EgAdkbtz6HiGeP3ZWGthBDLC7erGqxAJ9a7rdROe9hF9mPxeQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734631336; c=relaxed/simple;
	bh=IPxXuRAtf7W0AbtGAjV+8CmqH6ICbcdo92iOmbzpvvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nf5brhhTe+VqjlTVQsTefYb/IQx/2Wk7okulGC9L3wun4jfwr2b8qWUp9wE6zfehA1Fq2XI7oaCi3T/VmsGYB0GjxpEQQpEFfC8Q3MOikqS9lT929aYWJw2wdgMW6mwGQps5A1hkmc0RQW8IZkp4pq2zAmlSNmKdSQH94zJcCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hfqPDJzG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734631334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kEzY/0Z4Q2aTtoKz10Bhd7cDXZ4gdI1Peo3uxYuffnQ=;
	b=hfqPDJzG44rkKdKceBFaKHlljbS0+OBh8Okn8HJQtD2VQJTCh3xUL/RCdfxVP6gwtMW4wt
	yLJ7ehf1h2KSsJUO91S3TDJNX8pEpuEDulu7JkEPMch/RRDNGxVxALCwc1BLt+MXsAdGQG
	Klo3gg8VW4tSia1AdR2v+bLqB97KTUI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-dPR5LiRdNBSKHaAalm9BJA-1; Thu, 19 Dec 2024 13:02:11 -0500
X-MC-Unique: dPR5LiRdNBSKHaAalm9BJA-1
X-Mimecast-MFC-AGG-ID: dPR5LiRdNBSKHaAalm9BJA
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385e2579507so536775f8f.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 10:02:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734631330; x=1735236130;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kEzY/0Z4Q2aTtoKz10Bhd7cDXZ4gdI1Peo3uxYuffnQ=;
        b=i1JCpLOjgvlclqwdI/mCiq3u+FV1z8peVlovsSd6Rt19tdqpp/X4CkWWN1HYGOEEun
         3I0pspJM22yOIhHAjTaJKWpergCHmJ5OVIAPg8OCrExh4bTm6v/GYEGl6+AVlYKdgJW/
         VEdrZanr2vJyXe5yDz6S9+nvXHMB/12qunjjqz7TJLJEaTLfRTsLd+C66z6jukVX7o48
         pLgVpuJ/5L5gDLU/pzGhajj/JP+BQClIw4vmtBBmqa5I2usFVgJgAIbxw4fTzc8tUsLf
         WlU8Vbz2WqMqsvFmKtD8YiOzJPziCahGJ/Soanvkh5dWbvLlgHWsAMeqKCnPNCuV+fNw
         k1Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUryi3bjURZfc3QXlwuIg58kUGHSgvovX8B7MJvHE3TLBm2CazNF3YCErdmhueGSYYjZv8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6IveypQkRmhoI3bo+ryBM6aBjd+Y0ZnUHHU+NTyxs/ZJSoVrp
	nTUxDLWgd/lwP9zkK/LISn286JaDz7kNOc8F8sG8sKwax3A5+j+eo+RtIDM5s9AwWV+u2l5+j3f
	e67tvFZ+uCkq3H5UvvvfiAJxfD2VrKzfEIjsmRaPpYA50sr/7kg==
X-Gm-Gg: ASbGncvY7GovRoF9mAKfngbn1IP305rtU1vRow035mW+DHifRv3W2tON+XUHlAr2Wlk
	ImSKMnjkpJ5fxQyjLD/+YkRA7GavMUH0s7jtUDp0e4MzAJNyeK3i0haOuSqf7/T6mNfdl5eKXub
	zI//Qdpt71v3oua4DcItUtIVY33QemFLPaVbSGET5uzr0kBuLoKgo7A5ihml+Udz7LkJmhJx7XH
	fLziGU4kFNdLzqHAmiXLOXQJqczsr7TtcGiwJmo3TkW7w0JPVJMzqNk67g=
X-Received: by 2002:a5d:6d0e:0:b0:385:ec6e:e872 with SMTP id ffacd0b85a97d-38a223f714cmr11495f8f.38.1734631329804;
        Thu, 19 Dec 2024 10:02:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHUU1KHjceG82PmHIi7w1ZKI46aTucVDJ9DAkST3r+nn79jP/qXPNTfiY2pNtpDN8zX3weYAA==
X-Received: by 2002:a5d:6d0e:0:b0:385:ec6e:e872 with SMTP id ffacd0b85a97d-38a223f714cmr11451f8f.38.1734631329354;
        Thu, 19 Dec 2024 10:02:09 -0800 (PST)
Received: from [192.168.1.84] ([93.56.163.127])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c8a6cb1sm2124424f8f.89.2024.12.19.10.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 10:02:08 -0800 (PST)
Message-ID: <a957a662-b4b9-4104-9aea-d3bfb0bb7449@redhat.com>
Date: Thu, 19 Dec 2024 19:02:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] KVM: x86: add new nested vmexit tracepoints
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, Sean Christopherson <seanjc@google.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20240910200350.264245-1-mlevitsk@redhat.com>
 <20240910200350.264245-4-mlevitsk@redhat.com>
 <9ff2be87-117a-4f96-af3b-dacb55467449@redhat.com>
 <4c1c999c29809c683cc79bc8c77cbe5d7eca37b7.camel@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <4c1c999c29809c683cc79bc8c77cbe5d7eca37b7.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 18:49, Maxim Levitsky wrote:
>> Here I probably would have preferred an unconditional tracepoint giving
>> RAX/RBX/RCX/RDX after a nested vmexit.  This is not exactly what Sean
>> wanted but perhaps it strikes a middle ground?  I know you wrote this
>> for a debugging tool, do you really need to have everything in a single
>> tracepoint, or can you correlate the existing exit tracepoint with this
>> hypothetical trace_kvm_nested_exit_regs, to pick RDMSR vs. WRMSR?
> 
> Hi!
> 
> If the new trace_kvm_nested_exit_regs tracepoint has a VM exit number argument, then
> I can enable this new tracepoint twice with a different filter (vm_exit_num number == msr and vm_exit_num == vmcall),
> and each instance will count the events that I need.
> 
> So this can work.
Ok, thanks.  On one hand it may make sense to have trace_kvm_exit_regs 
and trace_kvm_nested_exit_regs (you can even extend the 
TRACE_EVENT_KVM_EXIT macro to generate both the exit and the exit_regs 
tracepoint).  On the other hand it seems to me that this new tracepoint 
is kinda reinventing the wheel; your patch adding nested equivalents of 
trace_kvm_hypercall and trace_kvm_msr seems more obvious to me.

I see Sean's point in not wanting one-off tracepoints, on the other hand 
there is value in having similar tracepoints for the L1->L0 and L2->L0 
cases.  I'll let him choose between the two possibilities (a new 
*_exit_regs pair, or just apply this patch) but I think there should be 
one of these two.

Paolo


