Return-Path: <kvm+bounces-51059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B322AED53D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF41D174458
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E172E21770D;
	Mon, 30 Jun 2025 07:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCHSMWzt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C393278F24;
	Mon, 30 Jun 2025 07:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751267369; cv=none; b=K5/aeZTH46f/rohTDgvzmi4ugwwWRCgohy0ymS1/BRhz6x+VBs55/WQnUUPeIbq0Fs4r+jNPPm0u74EKFIACCZABY3jJTrAu4/R/QgLy1HnbD0I15XgIMKIfdIa89S/gmB2Si0UfKXRSCaZCdxm+n5PDN+3MRFxc8VIOIRxSUNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751267369; c=relaxed/simple;
	bh=2DtDh75BjjG1Bypjj77+rjJnfFomPfSyCzUXJ/6TNg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFjVW6EE8hIHdy5j+xBBnTxRveApLKqbqB/5NOnyt+WXoEIP4F8RFsTCCIGNnHUUG+WSfD/T3gWnW9OzisiTgBTtO70FSbkw246xcO/njvz42NtzwW/ReVeT+BUFbQ9W6xNUToAJV0iAil8iHj2MuPXmcIbe46WkN5URfyG5iCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCHSMWzt; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751267367; x=1782803367;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2DtDh75BjjG1Bypjj77+rjJnfFomPfSyCzUXJ/6TNg4=;
  b=LCHSMWztD71CPBmeMlzVBpo5MP9I6PZBi8f/TVERpyfxNAUVKAkU97Bt
   8oK98VE3//iuXmj3CiULGf3osAn97srB109sGgqlXGWhUTC/OvjjIE/F+
   iXJ9zgY4UqHsiNTldcrxpqJhcaUuEn47DYHLuGKlSZHrys/jmaFBzkQ7M
   jjqVYasgIVM3/6QCipkoC1NGUS35h3C739scNkwasbhNB3RRr44D912hy
   kTFPsZ13AWdJfS/dR1cjsDhjjn22G4KaueTfiZ71RbmJxjcZ5yXY30s8a
   So8Np0xEjRxPV+e6isSVgSE96O1H0jaGjWrmguHXa44GXZZOvKSCMYKwE
   Q==;
X-CSE-ConnectionGUID: 5A58bmdXSVyWIkB1Rkiwhw==
X-CSE-MsgGUID: uhBP6YkQS5uRrjbCQJ5HZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="70916533"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="70916533"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 00:09:27 -0700
X-CSE-ConnectionGUID: Tb+bAqywTYed8cSYmtEGVA==
X-CSE-MsgGUID: NTLoU24QQZSwYdYu57I+4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="153118599"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 00:09:23 -0700
Message-ID: <c8ea05e6-58e5-4371-88fe-cde3f09dd530@linux.intel.com>
Date: Mon, 30 Jun 2025 15:09:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
 <bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
 "sagis@google.com" <sagis@google.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>
References: <cover.1750934177.git.kai.huang@intel.com>
 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
 <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
 <b368fb3399d1e64e98fb9ad6a7a214387c097825.camel@intel.com>
 <0b8948ed672ebf6701ddc350914e4e325032ad87.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <0b8948ed672ebf6701ddc350914e4e325032ad87.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/27/2025 8:30 AM, Huang, Kai wrote:
[...]
>
> And I am not 100% sure whether this issue exists, since allowing CPU hotplug
> during kexec doesn't seem reasonable to me at least on x86, despite it is
> indeed enabled kernel_kexec() common code:
>
>          /*
>           * migrate_to_reboot_cpu() disables CPU hotplug assuming that
>           * no further code needs to use CPU hotplug (which is true in
>           * the reboot case). However, the kexec path depends on using
>           * CPU hotplug again; so re-enable it here.
>           */
>           cpu_hotplug_enable();
>           pr_notice("Starting new kernel\n");
>           machine_shutdown();
>
> I tried to git blame to find clue but failed since the history is lost
> during file move/renaming etc.  I suspect it is for other ARCHs.
>
Had a check in git history, it's related to powerpc kexec code.

First, commit e8e5c2155b00 ("powerpc/kexec: Fix orphaned offline CPUs across kexec")
add the code to online each present CPU.

Later, commit011e4b02f1da (" powerpc, kexec: Fix "Processor X is stuck" issue
during kexec from ST mode") add the code in the common code kernel_kexec() to
enable hotplug to fix the stuck issue.


