Return-Path: <kvm+bounces-20530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E539179B0
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 09:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 288321F24782
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 07:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D596115B10D;
	Wed, 26 Jun 2024 07:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jmPj3ZSX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A145978;
	Wed, 26 Jun 2024 07:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719386971; cv=none; b=JXgLsdzQXECaiHTr30rjjSy65xYRCjRTGVewmokB1zxkGCaj9oDtlOOQ1kjr+iWPhs9CVXsexdjmkcvQBMAjn1P0wASkDAyGD8FcLcFJLXrqb/ex00Uqn9vA8UcRC7lksf7BVGYj0HEjlg/syFm9ou7cXMo9i7usPYiJ2lzrXB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719386971; c=relaxed/simple;
	bh=J0eWAsgVkY1jYjZlKFdqP2bghj/1MBcjAvvnIMRcUIc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QsdDZ+Itk8lIqpfTIppqN2cjYBdhkz5qhirar1pdUyVHAglHE0XqTa4+t9jnIw3HP07netShlGpYOLC6nNc5Pbt34at8g0dqQwx1c1/KX9av35QXfR0GGaZjv5/qTgjS1LkYYbQ0HNz9lRnGcdPOCoYbcgbDufvwe0lWvZScotQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jmPj3ZSX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719386970; x=1750922970;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=J0eWAsgVkY1jYjZlKFdqP2bghj/1MBcjAvvnIMRcUIc=;
  b=jmPj3ZSX57vHb3MJ8IeyfV/d/H6W2Mb3rK7tYwLs55qEiLNuiHQbrPrh
   x3d5RBkVrFfHNnJQ/UB+e0uP/ZqAlbIdv59yVotIfWUWJg6nId/w6eWFU
   fUjGe0/7iXjmNtgp97Koh/DJhkOryB40c2nAZdLdzuaMPCTa3VPj3mkbZ
   78lRRjor/x51svzt+E6hDHVjPcmwf8WEE0kfx2aiknDZu947YiSD1pOu8
   GzcSdvm+O6OsHFpHWpoA2TQvifEcKniM1N8jUhy3GuRbY/zYG+Mjt0OZW
   1KIhh7gh8ugtSO85v4Br5VyPzLiaJ3OeVCf0e36I1lF/O/tPv37tYF1MA
   g==;
X-CSE-ConnectionGUID: cduVZm3uTZifxoAqGDIGAA==
X-CSE-MsgGUID: KbRK6O8qTf6Hr2Wtipln6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="27848495"
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="27848495"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 00:29:29 -0700
X-CSE-ConnectionGUID: L/A/1mnXS3Gudf3zXbZmqw==
X-CSE-MsgGUID: fZ6EKJvmSLippSfOtShXcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="44624811"
Received: from qunyang-mobl1.ccr.corp.intel.com (HELO [10.238.2.59]) ([10.238.2.59])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 00:29:25 -0700
Message-ID: <80d06351-3c34-40e9-aecc-524aaeb644f7@linux.intel.com>
Date: Wed, 26 Jun 2024 15:29:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
From: Binbin Wu <binbin.wu@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
 "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Chao Gao <chao.gao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
 <07e410205a9eb87ab7f364b7b3e808e4f7d15b7f.camel@intel.com>
 <edfc5edc-4bf7-4bc6-b760-c9d4341acc9d@linux.intel.com>
Content-Language: en-US
In-Reply-To: <edfc5edc-4bf7-4bc6-b760-c9d4341acc9d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/26/2024 10:09 AM, Binbin Wu wrote:
>
>
> On 6/26/2024 5:09 AM, Edgecombe, Rick P wrote:
>> On Tue, 2024-06-25 at 14:54 +0800, Binbin Wu wrote:
>>>> +               gpa = vcpu->mmio_fragments[0].gpa;
>>>> +               size = vcpu->mmio_fragments[0].len;
>>> Since MMIO cross page boundary is not allowed according to the input
>>> checks from TDVMCALL, these mmio_fragments[] is not needed.
>>> Just use vcpu->run->mmio.phys_addr and vcpu->run->mmio.len?
>> Can we add a comment or something to that check, on why KVM doesn't 
>> handle it?
>> Is it documented somewhere in the TDX ABI that it is not expected to be
>> supported?
> TDX GHCI doesn't have such restriction.
>
> According to the reply from Isaku in the below link, I think current 
> restriction is due to software implementation for simplicity.
> https://lore.kernel.org/kvm/20240419173423.GD3596705@ls.amr.corp.intel.com/ 
>
> +       /* Disallow MMIO crossing page boundary for simplicity. */
> +       if (((gpa + size - 1) ^ gpa) & PAGE_MASK)
>                 goto error;
>
> According to 
> https://lore.kernel.org/all/165550567214.4207.3700499203810719676.tip-bot2@tip-bot2/,
> for Linux as TDX guest, it rejects EPT violation #VEs that split pages 
> based on the reason "MMIO accesses are supposed to be naturally 
> aligned and therefore never cross page boundaries" to handle the 
> load_unaligned_zeropad() case.
>
> I am not sure "MMIO accesses are supposed to be naturally aligned" is 
> true for all other OS as TDX guest, though.
>
> Any suggestion?
>
>
Had some discussion with Gao, Chao.

For TDX PV MMIO hypercall, it has got the GPA already.
I.e, we don't need to worry about case of "contiguous in virtual memory, 
but not be contiguous in physical memory".

Also, the size of the PV MMIO access is limited to 1, 2, 4, 8 bytes. No 
need to be split.

So, for TDX, there is no need to use vcpu->mmio_fragments[] even if the 
MMIO access crosses page boundary.
The check for "Disallow MMIO crossing page boundary" can be removed and 
no extra fragments handling needed.



