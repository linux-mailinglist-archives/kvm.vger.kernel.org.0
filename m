Return-Path: <kvm+bounces-57725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EAB0B597E0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 981457A9265
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BF7311953;
	Tue, 16 Sep 2025 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEL82LAf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B22020E029
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758030012; cv=none; b=GHEq+02SGf8pMLvzRaCoYxiJ1MuciUEcFPbYPdUAoTyQrJyGI3Ne2qXqVirGj5XUlcPnLRmt6tuTyOML2lB5Hts80uKz7uBOshnrSvaOOhTeFOxla8W0HETgEd8n7kETOumlxeO9QpdI01olyOjnySZ1tTKJk3fyJWh6j86eDRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758030012; c=relaxed/simple;
	bh=4KwKRAZzBvHEFbPxRYtiuAKnqozrUsazxK7rvaqb1jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VU4ac59tQk+EGkNw9daca2sf2l8yWBdY+RpYTK6q18Q1gT1fGAnhDVpt3NARCGiXRZ91/fPcAJDuzaw+jt3D+G/DLP+AjOJZE3Z46kpB2Letxif+I9v2rlypWaHrF4ru+YLOieyFgOSiAZFeXxUW+C6aaVyWUmYI5JpGh+Jyxkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEL82LAf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E158CC4CEEB;
	Tue, 16 Sep 2025 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758030011;
	bh=4KwKRAZzBvHEFbPxRYtiuAKnqozrUsazxK7rvaqb1jc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dEL82LAfT0O1e4sLvWvtHYjixi0K7YoluLlIhURENbihxh7/hkXqS8LcrQxkxtpYG
	 wT/yo3J+12U0+YBZ3Y10YCdK+2mPxG3OedRK/WB09GLncipbChHYEvI75x7wgeWyHa
	 Q2VtBH12rITleDtOT5lFX4ePCMEGAANizVeoKJbLItfvwsIGEye5I/744ZyL0aVxnI
	 MKuo65K3xohZvZ1vuRFnPwLXBb8McLxqvt8vE/0c9m299ITl/JhxbncLVDUAqanbk4
	 HcywHjGVgKkkd4uV6wcWNMPqUB3ADtWNnfWerfK6upMxL7eP2oqj2qxaT3GEu577PN
	 jWnQg2lGfIxZA==
Message-ID: <f9d43ba5-0655-4a4e-b911-30b11615361d@kernel.org>
Date: Tue, 16 Sep 2025 08:40:10 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/5] KVM: SVM: Stop warning if x2AVIC feature bit
 alone is enabled
To: Naveen N Rao <naveen@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Vasant Hegde <vasant.hegde@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
References: <cover.1756993734.git.naveen@kernel.org>
 <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
 <aMhxaAh6a3Eps_NJ@google.com>
 <wo2sfg7sxkpnemiznpjtjou4xc6alad2muewkjulqk2wr2lc5q@vlb7m34ez2il>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <wo2sfg7sxkpnemiznpjtjou4xc6alad2muewkjulqk2wr2lc5q@vlb7m34ez2il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/25 2:14 AM, Naveen N Rao wrote:
> On Mon, Sep 15, 2025 at 01:04:56PM -0700, Sean Christopherson wrote:
>> On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
>>> A platform can choose to disable AVIC by turning off the AVIC CPUID
>>> feature bit, while keeping x2AVIC CPUID feature bit enabled to indicate
>>> AVIC support for the x2APIC MSR interface. Since this is a valid
>>> configuration, stop printing a warning.
>>>
>>> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
>>> ---
>>>   arch/x86/kvm/svm/avic.c | 8 +-------
>>>   1 file changed, 1 insertion(+), 7 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>>> index a34c5c3b164e..346cd23a43a9 100644
>>> --- a/arch/x86/kvm/svm/avic.c
>>> +++ b/arch/x86/kvm/svm/avic.c
>>> @@ -1101,14 +1101,8 @@ bool avic_hardware_setup(void)
>>>   	if (!npt_enabled)
>>>   		return false;
>>>   
>>> -	/* AVIC is a prerequisite for x2AVIC. */
>>> -	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
>>> -		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
>>> -			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
>>> -			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
>>
>> I agree with the existing code, KVM should treat this as a firmware bug, where
>> "firmware" could also be the host VMM.  AIUI, x2AVIC can't actualy work without
>> AVIC support, so enumerating x2AVIC without AVIC is pointless and unexpected.
> 
> There are platforms where this is the case though:
> 
> $ cpuid -1 -l 0x8000000A | grep -i avic
>        AVIC: AMD virtual interrupt controller  = false
>        X2AVIC: virtualized X2APIC              = true
>        extended LVT AVIC access changes        = true
> 
> The above is from Zen 4 (Phoenix), and my primary concern is that we
> will start printing a warning by default. Besides, there isn't much a
> user can do here (except start using force_avic, which will taint the
> kernel). Maybe we can warn only if AVIC is being explicitly enabled?
> 

I'd say if you need to say something downgrade it to info instead and 
not mark it as firmware bug.

> There is another aspect to this: if we are force-enabling AVIC, then
> this can serve as a way to discover support for x2AVIC mode (this is
> what we do currently).  Otherwise, we may want to force-enable x2AVIC
> based on cpu family/model.
> 
> 
> - Naveen
> 


