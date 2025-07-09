Return-Path: <kvm+bounces-51949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A7DAFEBA3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 257937A19AC
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6B12E49A8;
	Wed,  9 Jul 2025 14:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OiGroKsH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6EC19F40B;
	Wed,  9 Jul 2025 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752070741; cv=none; b=muTgQEZY50QyS7xlxkdg0LwIzwd+PYP0gUPEYjC/COqB3vgQJVbug+O3bGZZSZ2ovBIzErH8l1EdIat1Gpg1/Goy7TK5CxLacqnxXIqkS0Gh1pS6ArDJz2MLF0VBBfoWL+7a9pElO74ovm5kdpGadVyqmMN3UODsApvjM3grIyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752070741; c=relaxed/simple;
	bh=Q0+v6om0u8Hl7Q3ONEShIUV7pnpDxFX/pv85baz3E+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JPLHMcj4LlkYq7Thui6SJ9VWyZBALtnpQ1kOiVuXNpSrkroHXlp+j+FxjhMBt/R1H2STOUXZr+QEAZ3VDO3dG9aHHJqXzZ9BkeOAb36i2Fq7072/DedPRM5koMgzosdVOBItVoVGFCCyHhVSuchnTdzFiB+kq+9/yC2g92mZ7OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OiGroKsH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752070740; x=1783606740;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q0+v6om0u8Hl7Q3ONEShIUV7pnpDxFX/pv85baz3E+o=;
  b=OiGroKsHLRuW8ccv5mTr8Mlps5DGn35iTcWgHjoxCY4W8usA9iP7STes
   UV6ZAvfDtF0UPE/X/OeHztolFuUdxvW8TxTqEIA7zs6cFrDCK7XayXwN+
   Gtwtqa4KWDZaXVi1Ky8LKQ0K6/EsaMs2LBDpDV8oUu19os8woPDhWfWhh
   BWGDBJQsENfrCJt6M/qNp3b0lYQt58GBdEec96sDGZVftSr+17t0mq2uW
   E5eserOpWZvMiXGU1r8TTfAj/NUZzfDbUFOpDGbQrdZY1FeTHnZIFWHgD
   wXriBakKlJl/UeCpqDuM5WuTdF2Ds4IWGg9MtODfqXXT1I5K+dWPyp6Uu
   Q==;
X-CSE-ConnectionGUID: PKNJsKWRRTG4FOyF6rp0hA==
X-CSE-MsgGUID: SHjqHjLYSiSMpBWlx8ZDEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54424727"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54424727"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 07:18:59 -0700
X-CSE-ConnectionGUID: vzMjAQSRSVuZTv9KnggjzQ==
X-CSE-MsgGUID: hRjzREp1QoidgpoJSPZTQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155425614"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 07:18:55 -0700
Message-ID: <03dee7cf-8619-4b5d-a0f9-18709a8bb910@intel.com>
Date: Wed, 9 Jul 2025 22:18:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] MAINTAINERS: Update the file list in the TDX entry.
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
 <20250708101922.50560-2-kirill.shutemov@linux.intel.com>
 <4068a586-532f-4c87-bcd3-c345cbf168c0@intel.com>
 <ebdba9aa-ce65-44c9-97f4-cae74a4db586@intel.com>
 <zxgwojg556ni4ap7wago27hsjlawvjfdsgya6toxp5jrricffl@aploj7ygic45>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <zxgwojg556ni4ap7wago27hsjlawvjfdsgya6toxp5jrricffl@aploj7ygic45>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/2025 9:31 PM, Kirill A. Shutemov wrote:
> On Tue, Jul 08, 2025 at 09:26:21PM -0700, Dave Hansen wrote:
>> On 7/8/25 20:31, Xiaoyao Li wrote:
>>> On 7/8/2025 6:19 PM, Kirill A. Shutemov wrote:
>>>> Include files that were previously missed in the TDX entry file list.
>>>> It also includes the recently added KVM enabling.
>>>
>>> Side topic:
>>>
>>> Could we add kvm maillist to the "L:" ?
>>
>> Sure, but send another patch please.
> 
> Xiaoyao, do you want to send a patch, or should I?
> 

I just sent the patch.

Thanks!

