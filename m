Return-Path: <kvm+bounces-5877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1844828590
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 12:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A883E1F25375
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 11:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B5F38DDD;
	Tue,  9 Jan 2024 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="leEnvgxm"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8952938DD8;
	Tue,  9 Jan 2024 11:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.1.210] (181-28-144-85.ftth.glasoperator.nl [85.144.28.181])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5DA60209AF69;
	Tue,  9 Jan 2024 03:56:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5DA60209AF69
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1704801386;
	bh=qTrKm5gfDaGVKWMebrVJloyB8rgSl281DiQxs9lsdz4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=leEnvgxmqMyQcS71Cg/lDkkVYOlAo1MdVzP4smUzAvnnaHz4jrz2ndUmu4HVjlYiQ
	 pQ9ufr8kiXyrTyy7o8s4h6REGjMhslEU9OG1i/Gy8bxqDNExlO0wS6czjMnGF8TyoQ
	 P4TKIMEclkSk/uRWSxMfgue1qpFPR6T4Eu81gM/Y=
Message-ID: <b5b57b60-1573-44f4-8161-e2249eb6f9b6@linux.microsoft.com>
Date: Tue, 9 Jan 2024 12:56:17 +0100
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
 <0c4aac73-10d8-4e47-b6a8-f0c180ba1900@linux.microsoft.com>
 <20240108170418.GDZZwrEiIaGuMpV0B0@fat_crate.local>
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20240108170418.GDZZwrEiIaGuMpV0B0@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/01/2024 18:04, Borislav Petkov wrote:
> On Mon, Jan 08, 2024 at 05:49:01PM +0100, Jeremi Piotrowski wrote:
>> What I wrote: "allow for the kernel to allocate the rmptable".
> 
> What?!
> 
> "15.36.5 Hypervisor RMP Management
> 
> ...
> 
> Because the RMP is initialized by the AMD-SP to prevent direct access to
> the RMP, the hypervisor must use the RMPUPDATE instruction to alter the
> entries of the RMP. RMPUPDATE allows the hypervisor to alter the
> Guest_Physical_Address, Assigned, Page_Size, Immutable, and ASID fields
> of an RMP entry."
>> What you want is something that you should keep far and away from the
> upstream kernel.
>

Can we please not assume I am acting in bad faith. I am explicitly trying to
integrate nicely with AMD's KVM SNP host patches to cover an additional usecase
and get something upstreamable.

Let's separate RMP allocation from who (and how) maintains the entries.

"""
15.36.4 Initializing the RMP
...
Software must program RMP_BASE and RMP_END identically for each core in the
system and before enabling SEV-SNP globally.
"""

KVM expects UEFI to do this, Hyper-V does the allocation itself (on bare-metal).
Both are valid. Afaik it is the SNP_INIT command that hands over control of the
RMP from software to AMD-SP.

When it comes to "who and how maintains the rmp" - that is of course the AMD-SP
and hypervisor issues RMPUPDATE instructions. The paragraph you cite talks about
the physical RMP and AMD-SP - not virtualized SNP (aka "SNP-host VM"/nested SNP).
AMD specified an MSR-based RMPUPDATE for us for that usecase (15.36.19 SEV-SNP
Instruction Virtualization). The RMP inside the SNP-host VM is not related to
the physical RMP and is an entirely software based construct.

The RMP in nested SNP is only used for kernel bookkeeping and so its allocation
is optional. KVM could do without reading the RMP directly altogether (by tracking
the assigned bit somewhere) but that would be a design change and I'd rather see
the KVM SNP host patches merged in their current shape. Which is why the patch
I linked allocates a (shadow) RMP from the kernel.

I would very much appreciate if we would not prevent that usecase from working -
that's why I've been reviewing and testing multiple revisions of these patches
and providing feedback all along.

