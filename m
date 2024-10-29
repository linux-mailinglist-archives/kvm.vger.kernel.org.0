Return-Path: <kvm+bounces-29933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E519B4588
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 10:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B556B2217A
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332201EE014;
	Tue, 29 Oct 2024 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ek/mWa/8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFEF1E1021;
	Tue, 29 Oct 2024 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730193579; cv=none; b=sYhA853tOrCM+JL5c2cdjznk2kKEsbTnYqOwi15jM/k7Z0CyMhcQLt9TR/01Tkgl7dBFdRNSt+M5DgUbFQjxjURAA9T9cGZev3rZCckMXHyUy/SLxsW27kM2oK5IHd0SELHGwwsbUW0VRkfW8AGJQkBPld+JXmFt9abEDaEWCiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730193579; c=relaxed/simple;
	bh=usu28eSRElbxXDriqUKRZndXD/DK9cdc7d1N99nY+MY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bZgWNMzRyv0q/3SgnmDyKjyT1iJ6aFxreamncz1zcmSXm8q+d7rhgPeFp1RsDfYZJeyBh3r/JGP7uyjbH8I6IHwzibxBb1cWuUM/+ywu3as4NfudEdIgIkad0RqAfvki0frYWcLC7StVukatswen9RCQDkakovh2o5QEYLjbRIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ek/mWa/8; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730193577; x=1761729577;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=usu28eSRElbxXDriqUKRZndXD/DK9cdc7d1N99nY+MY=;
  b=ek/mWa/8XbiMUEmR7jPYkY+NM15hRRhmczBH9u1BhIwa0hApcQTS6E5B
   lkHCF32SbSSteGi96i40ozVe0luY4gqCES+oDqGEuM3uiTLn0sTVpuvmC
   xGPNGNz4S7EMKxBTHZw9dviiw3jetfNIOfDaCZuh+4Ugqoa/0kIPXWc5E
   XpuqRye02/JHWwVR9VtuxkUT131hqLNpgcIQQ2/jZ2eJs9inh4UK48Y6O
   5StHEYLHxjBu5NR/JWEoxs8N2Q5yXM+/w7ajUTuE/bpXRx1puWY2UVrFl
   PL5gXkIGR6wXEiHxE5n7UM7MNxT4vYnnkxH9QObGPbunUfNL4AtpDY37j
   g==;
X-CSE-ConnectionGUID: Q2sFQZJKQoCGfe8YhIFX1A==
X-CSE-MsgGUID: 8jnMjfQaRRCYZvbiqk380Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="29276563"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="29276563"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 02:19:37 -0700
X-CSE-ConnectionGUID: vdK6Lod3QLaPGNd+X9HX1g==
X-CSE-MsgGUID: 5t+l2VtSSkerk3hH6sHsFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="82327212"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 02:19:32 -0700
Message-ID: <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
Date: Tue, 29 Oct 2024 17:19:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/2024 4:46 PM, Nikunj A. Dadhania wrote:
> 
> 
> On 10/29/2024 2:11 PM, Xiaoyao Li wrote:
>> On 10/28/2024 1:34 PM, Nikunj A Dadhania wrote:
>>> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
>>> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
>>> used cannot be altered by the hypervisor once the guest is launched.
>>>
>>> Secure TSC-enabled guests need to query TSC information from the AMD
>>> Security Processor. This communication channel is encrypted between the AMD
>>> Security Processor and the guest, with the hypervisor acting merely as a
>>> conduit to deliver the guest messages to the AMD Security Processor. Each
>>> message is protected with AEAD (AES-256 GCM). Use a minimal AES GCM library
>>> to encrypt and decrypt SNP guest messages for communication with the PSP.
>>>
>>> Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
>>> Processor and initialize snp_tsc_scale and snp_tsc_offset.
>>
>> Why do it inside mem_encrypt_init()?
> 
> It was discussed here: https://lore.kernel.org/lkml/20240422132058.GBZiZkOqU0zFviMzoC@fat_crate.local/

IMHO, it's a bad starter. As more and more SNP features will be enabled 
in the future, a SNP init function like tdx_early_init() would be a good 
place for all SNP guest stuff.

Just my 2 cents.

> Regards
> Nikunj


