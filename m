Return-Path: <kvm+bounces-44244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55904A9BD53
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 05:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 386021B67EF4
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 03:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9138F1BD9D0;
	Fri, 25 Apr 2025 03:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="h6tkGPZf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36E5144304;
	Fri, 25 Apr 2025 03:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745552725; cv=none; b=cC+8pVzYVlqcpY/3qUgJucQPZlyZQGBRyQP059KQx2ToW79uqM8dlWCWn1PDeawgna+jUbhmvOhG/got1PnG2JZQK1dEt8ZzLkLF5VikoEkeACmGxR2S/X83XPq5ObOcxvex7/nyIqf7CX4HCWuziebQOFZUfqWzrM8+CstF+0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745552725; c=relaxed/simple;
	bh=GCsuJBHrLb8OOsw0Nrc363phMun5O+wCt6+3FMpkJQo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lJx8m28YeK2c0ANh1LGU6keZyNdiIQ+pOZdvLVRgMX9wMY5xmv0GocMlPNBml9t8GJbqQA9jwODQ1eFx91Db5Vko+RlZUjqVjZZEy2k0vmErs0NlQ6jmSAF0dkHuQyB75fc5hOotHivgORAcw3HUGtShWvxyeJyhv50CnaPDW2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=h6tkGPZf; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [IPV6:2601:646:8081:1f93:ace:6989:11eb:d5d3] ([IPv6:2601:646:8081:1f93:ace:6989:11eb:d5d3])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53P3iRFQ2047105
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 24 Apr 2025 20:44:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53P3iRFQ2047105
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745552672;
	bh=b2EU0c9r4+7Z91N6+uKj1oR80E0vF0IHEbyiUhJnLQA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=h6tkGPZf95yQ3bAcYVi/++g5apF9dA+xDaGqiCLYRc9VcHVlrJdGQsg4l29MEZ7CJ
	 aLVdgM7ERZdGZm+YeYHxkaRoWYmC139k7kZqYZoAzT/znx6Kx6O2GtZpDA/JUfvlJ1
	 CcsBsfRHddjbpCzdM4zIuzpA7epwqsOqTiZB4ua/CkyilKNABnOQlavSOZxha0+wfj
	 cX6ckW2WvvNyLFS1B2A5lWVYkYGzgGJhfmVN53iSVa6vyOu/NY5xsXrNsSQKXTH85b
	 +dwG+fJzWTGalgBqhI1nG1clXUnlMv9jRJvaiZN9wKeE5vSAPLzqIsZZs/a531ezoe
	 HihwH9Nv3ITtg==
Message-ID: <72516271-5b28-434a-838b-d8532e1b4fc1@zytor.com>
Date: Thu, 24 Apr 2025 20:44:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
From: "H. Peter Anvin" <hpa@zytor.com>
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Xin Li
 <xin@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
        linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
        andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
 <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
 <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
 <0cdc6e9d-88eb-4ead-8d55-985474257d53@suse.com>
 <483eb20c-7302-4733-a15f-21d140396919@zytor.com>
Content-Language: en-US
In-Reply-To: <483eb20c-7302-4733-a15f-21d140396919@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/24/25 18:15, H. Peter Anvin wrote:
> On 4/24/25 01:14, Jürgen Groß wrote:
>>>
>>> Actually, that is how we get this patch with the existing alternatives
>>> infrastructure.  And we took a step further to also remove the pv_ops
>>> MSR APIs...
>>
>> And this is what I'm questioning. IMHO this approach is adding more
>> code by removing the pv_ops MSR_APIs just because "pv_ops is bad". And
>> I believe most refusal of pv_ops is based on no longer valid reasoning.
>>
> 
> pvops are a headache because it is effectively a secondary alternatives 
> infrastructure that is incompatible with the alternatives one...
> 
>>> It looks to me that you want to add a new facility to the alternatives
>>> infrastructure first?
>>
>> Why would we need a new facility in the alternatives infrastructure?
> 
> I'm not sure what Xin means with "facility", but a key motivation for 
> this is to:
> 
> a. Avoid using the pvops for MSRs when on the only remaining user 
> thereof (Xen) is only using it for a very small subset of MSRs and for 
> the rest it is just overhead, even for Xen;
> 
> b. Being able to do wrmsrns immediate/wrmsrns/wrmsr and rdmsr immediate/ 
> rdmsr alternatives.
> 
> Of these, (b) is by far the biggest motivation. The architectural 
> direction for supervisor states is to avoid ad hoc and XSAVES ISA and 
> instead use MSRs. The immediate forms are expected to be significantly 
> faster, because they make the MSR index available at the very beginning 
> of the pipeline instead of at a relatively late stage.
> 

Note that to support the immediate forms, we *must* do these inline, or 
the const-ness of the MSR index -- which applies to by far the vast 
majority of MSR references -- gets lost. pvops does exactly that.

Furthermore, the MSR immediate instructions take a 64-bit number in a 
single register; as these instructions are by necessity relatively long, 
it makes sense for the alternative sequence to accept a 64-bit input 
register and do the %eax/%edx shuffle in the legacy fallback code... we 
did a bunch of experiments to see what made most sense.

	-hpa


