Return-Path: <kvm+bounces-46826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA8FAB9FBF
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 833804E2720
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB32D1C6FEC;
	Fri, 16 May 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZV9tA62V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83170E55B;
	Fri, 16 May 2025 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747408861; cv=none; b=gfqdq1j0HXwiJ4Pc4x4YrsbvRlkJLujjAE3OTFOVSkQdvb2Buxv6zAzOSbmmQTND31QLfUcrkIofl1XLC2nrEhLnxTvm2GymDwm5C9/VRNEORuMbJEXkmOJQPl6sJhkVJ48XRZXCu0UTXNTqemnD+GCjPKOtjTBSgQ/1naRAvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747408861; c=relaxed/simple;
	bh=50QJX481Cjdf1FZZLN/up0UnCy+7NcEcqq6vvJTrSr4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=TUTCswnu4LAz6H8808hE4xoY3idSN1CVo1iucgzHPCTwS+ut4k8esGjhiXvH/4Vdbks7Eu2QaSp7QTe9z/JhYWAmH19JMVSKNH7VnLlo+QrnI07bvf8rZleadJCgPWdNFfXHdnctZ3ERHfvzcfSQWellR468vXAGp2EcFvcLtAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZV9tA62V; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747408859; x=1778944859;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=50QJX481Cjdf1FZZLN/up0UnCy+7NcEcqq6vvJTrSr4=;
  b=ZV9tA62VifFG7pWpaIEYooodFLhd+WwXF4sxtLdnNvzp2WGkve7w8yYh
   myp+EAiS3BfJtEYCnazIE03QMJLM/mCPFOgI/3YRJoM0cElaV65+T3adE
   856plIfg8L4eLzcqsZLj9CDBR0VCuJSKuNK/CGrwNjqYebGGaz5zq/Yq6
   J0ri8L+Pc1NSMNfmvNRt8DiOQvvg8snU7jW6IMK2pEIGkcK7OO5r8aB8H
   A48Timgse4puIfgeNjolbkZ5WZenTaKsxrIr3MDrZIpsNDLn5Ntl6YnZM
   HKU7eWwzGWzMEF/VpJUnwz9T+NMMspJQ+FZgm+mjYPf/RAFUB7tSBpgF6
   Q==;
X-CSE-ConnectionGUID: i2qE3bfqTkqeiPN0KPaa0w==
X-CSE-MsgGUID: LkW3VtkwS1C8FbI/FzfMYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="49311592"
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="49311592"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 08:20:58 -0700
X-CSE-ConnectionGUID: POl1KhS6R9+FVvROK00msQ==
X-CSE-MsgGUID: 04hJ46ftQcuXDQiu8tKxlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="138576002"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.109.57]) ([10.125.109.57])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 08:20:58 -0700
Message-ID: <ed3adddc-50a9-4538-9928-22dea0583e24@intel.com>
Date: Fri, 16 May 2025 08:20:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 0/6] Introduce CET supervisor state support
To: Ingo Molnar <mingo@kernel.org>, Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
 peterz@infradead.org, rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
 john.allen@amd.com, bp@alien8.de, chang.seok.bae@intel.com,
 xin3.li@intel.com, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Eric Biggers
 <ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Kees Cook <kees@kernel.org>,
 Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy
 <levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>,
 Oleg Nesterov <oleg@redhat.com>, Samuel Holland <samuel.holland@sifive.com>,
 Sohil Mehta <sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>,
 Uros Bizjak <ubizjak@gmail.com>, Vignesh Balasubramanian <vigbalas@amd.com>,
 Zhao Liu <zhao1.liu@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
 <aCYLMY00dKbiIfsB@gmail.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aCYLMY00dKbiIfsB@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/15/25 08:41, Ingo Molnar wrote:
> * Chao Gao <chao.gao@intel.com> wrote:
>> I kindly request your consideration for merging this series. Most of 
>> patches have received Reviewed-by/Acked-by tags.
> I don't see anything objectionable in this series.
> 
> The upcoming v6.16 merge window is already quite crowded in terms of 
> FPU changes, so I think at this point we are looking at a v6.17 merge, 
> done shortly after v6.16-rc1 if everything goes well. Dave, what do you 
> think?

It's getting into shape, but it has a slight shortage of reviews. For
now, it's an all-Intel patch even though I _thought_ AMD had this
feature too. It's also purely for KVM and has some suggested-by's from
Sean, but no KVM acks on it.

Sean is not exactly the quiet type about things, but it always warms me
heart to see an acked-by accompanying a suggested-by because it
indicates that the suggestion was heard and implemented properly.

