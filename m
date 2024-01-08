Return-Path: <kvm+bounces-5848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D99B8275BD
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09D571F23B83
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7940954662;
	Mon,  8 Jan 2024 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="oL7/MFh4"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6D75465E;
	Mon,  8 Jan 2024 16:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.1.212] (181-28-144-85.ftth.glasoperator.nl [85.144.28.181])
	by linux.microsoft.com (Postfix) with ESMTPSA id 254D420B3CC1;
	Mon,  8 Jan 2024 08:49:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 254D420B3CC1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1704732549;
	bh=j5wUzzW0cb/Fpbwwk5abVFwIxNz3dOC7dlYfblMV53I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oL7/MFh4WwAqWCtS6MZAir1oxt++S6oXKWbLEXMz1KRawee2mKNFPNznQsNVLkDXl
	 1Acxk6vsRkIKA1NbV/62G8TwLpGAU5Sgqc/tXgNFDe9x3FIe9jeh/NCGKUW/GiRQnN
	 ecpu2ijLzzeyXVOnIMVuycK7yrEY8ePWmEmRY3bc=
Message-ID: <0c4aac73-10d8-4e47-b6a8-f0c180ba1900@linux.microsoft.com>
Date: Mon, 8 Jan 2024 17:49:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
 <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
 <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>
 <20240105162142.GEZZgslgQCQYI7twat@fat_crate.local>
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20240105162142.GEZZgslgQCQYI7twat@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/01/2024 17:21, Borislav Petkov wrote:
> On Fri, Jan 05, 2024 at 05:09:16PM +0100, Borislav Petkov wrote:
>> On Thu, Jan 04, 2024 at 12:05:27PM +0100, Jeremi Piotrowski wrote:
>>> Is there a really good reason to perform the snp_probe_smptable_info() check at this
>>> point (instead of in snp_rmptable_init). snp_rmptable_init will also clear the cap
>>> on failure, and bsp_init_amd() runs too early to allow for the kernel to allocate the
>>> rmptable itself. I pointed out in the previous review that kernel allocation of rmptable
>>> is necessary in SNP-host capable VMs in Azure.
>>
>> What does that even mean?>>
>> That function is doing some calculations after reading two MSRs. What
>> can possibly go wrong?!
> 

What I wrote: "allow for the kernel to allocate the rmptable". Until the kernel allocates a
rmptable the two MSRs are not initialized in a VM. This is specific to SNP-host VMs because
they don't have access to the system-wide rmptable (or a virtualized version of it), and the
rmptable is only useful for kernel internal tracking in this case. So we don't strictly need
one and could save the overhead but not having one would complicate the KVM SNP code so I'd
rather allocate one for now.
 
It makes most sense to perform the rmptable allocation later in kernel init, after platform
detection and e820 setup. It isn't really used until device_initcall.

https://lore.kernel.org/lkml/20230213103402.1189285-2-jpiotrowski@linux.microsoft.com/
(I'll be posting updated patches soon).


> That could be one reason perhaps:
> 
> "It needs to be called early enough to allow for AutoIBRS to not be disabled
> just because SNP is supported. By calling it where it is currently called, the
> SNP feature can be cleared if, even though supported, SNP can't be used,
> allowing AutoIBRS to be used as a more performant Spectre mitigation."
> 
> https://lore.kernel.org/r/8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com
> 

This logic seems twisted. Why use firmware rmptable allocation as a proxy for SEV-SNP
enablement if BIOS provides an explicit flag to enable/disable SEV-SNP support. That
would be a better signal to use to control AutoIBRS enablement.

