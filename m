Return-Path: <kvm+bounces-26820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFC097813C
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7E681C22E6E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A98A1DB52A;
	Fri, 13 Sep 2024 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PkfGVPwC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8099A43144;
	Fri, 13 Sep 2024 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726234447; cv=none; b=KvgLPm2Z9H9p/4+3EoO94eaWs5ZP0FlICEmhSoXF2XrPN7daDIbAvtDZdNvoHzW/QOCeYFuPD7MAJi/HBIhwm5ppI7YoNYxUJ+MbTMaw9rJIbfE75jF3/Yt6HiaQl4m7t14ihfE+RqVfXa6oACAYzFRSPt9xbWCOImxoeOhdHzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726234447; c=relaxed/simple;
	bh=Z58heOtdImW9TNemzsMbb5fjxo1uAQzEYvYQJQpm5k0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEhCari54lSFu8122BFC83KYkkPkIVFjS574TanLyzBe5rSx1H8zdW/Tj0zDHLVZnqTQFhgUFOG3LieFlix1Laghu25dcZaOZf4fZAK1nCZeCSCqadITBdltKDlDbWitOo8IdzojkO87kALCLmza2AYmeuJ+LjRnqZIrTnt1Iak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PkfGVPwC; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726234446; x=1757770446;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z58heOtdImW9TNemzsMbb5fjxo1uAQzEYvYQJQpm5k0=;
  b=PkfGVPwCkCJSmgaC+yrYY+mquv4xhtty6jjGl3Zt/YgA0N16ZsJpobkz
   aRHcQSaQiaCPCr+VILVu7S2PlobqhIzXmo6uTXJs068uxpiXoQdWDfyqD
   W4cIbt13gBQ4AHfgejBJ8qz/jNjAQdM9oKdSEKv0HoC8wXaZg3tgyeX0I
   ev5+N5318CeqG/tlHtiDwyL2Kd6OlmUvwGZs35z5FSlNpz2TpGZaWnW+7
   0sPtUBdxJl8Q+SGpXXZFicL6UHCIB4BxVyQEpszpeTf2whDslmrmA1KUf
   aSH9gBmpSg4Snhmlq0kwjpand2Rc1Af5/qnSgwckYwMv1CqKVMkrQNqy2
   A==;
X-CSE-ConnectionGUID: 17goPnmFSYeJHOqLi8xHyw==
X-CSE-MsgGUID: U5a5eR7iQoyUc+1jAxwAyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="28912859"
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="28912859"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 06:34:04 -0700
X-CSE-ConnectionGUID: oJ45DZiRR92UZZbnLUtjbQ==
X-CSE-MsgGUID: NjX8WKH9RqqFQt+HIjdwTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="72427350"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.0.178])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 06:34:00 -0700
Message-ID: <0fed1792-806d-41e2-a543-8ed28b314e2a@intel.com>
Date: Fri, 13 Sep 2024 16:33:51 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "dmatlack@google.com" <dmatlack@google.com>, "Huang, Kai"
 <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
 <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-17-rick.p.edgecombe@intel.com>
 <6d0198fc-02ba-4681-8332-b6c8424eec59@redhat.com>
 <32a4ef78dcdfc45b7fae81ceb344afaf913c9e4b.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <32a4ef78dcdfc45b7fae81ceb344afaf913c9e4b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/09/24 03:19, Edgecombe, Rick P wrote:
> On Tue, 2024-09-10 at 12:24 +0200, Paolo Bonzini wrote:
>> On 9/4/24 05:07, Rick Edgecombe wrote:
>>> +static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
>>> +                                         enum pg_level level, kvm_pfn_t
>>> pfn)
>>> +{
>>> +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>>> +
>>> +       /* Returning error here to let TDP MMU bail out early. */
>>> +       if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm)) {
>>> +               tdx_unpin(kvm, pfn);
>>> +               return -EINVAL;
>>> +       }
>>
>> Should this "if" already be part of patch 14, and in 
>> tdx_sept_set_private_spte() rather than tdx_mem_page_record_premap_cnt()?
> 
> Hmm, makes sense to me. Thanks.

It is already in patch 14, so just remove it from this patch
presumably.


