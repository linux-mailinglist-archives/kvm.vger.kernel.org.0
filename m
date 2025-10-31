Return-Path: <kvm+bounces-61654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 214E3C23BFC
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96758189D906
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F0E303C81;
	Fri, 31 Oct 2025 08:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LFOptmJA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5066C2BE7DF;
	Fri, 31 Oct 2025 08:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761898772; cv=none; b=a7gnlu3z4Wi/Bib/UUx6G+MEW8qHQUWz7c0pBYn3Sr5s3erb7Z2cb6Q7x3+m1Dckq9/5B1HxOmrJJjyiNW+1sRkHGMAJq0lTYpaKKJ+RbdLWJ+UBKPtYav21hjBeJAleAP2DhYpkrKw5Aoe7YaRP6KYy02QiKyFStZv36b+xDrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761898772; c=relaxed/simple;
	bh=EzjqWFPbYzjEfpDteBcncRVxcsQvYXXWJGNfJY3z6Qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iq7DMAHP3PaGAM84gslYris5UUNFNIoKihBWCAcmTX4Ov3OFNez7RoNqZjUnFXJl7HQXZjVmAC5CmOlcm//woxANhBBPHKE7B0TP0dz+sHjTNgBSg1OllX0O9aYQ6t/X8Vmra2RbScmFX4C9zbxXOijfudSubc/QIPFDFKEt728=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LFOptmJA; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761898770; x=1793434770;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EzjqWFPbYzjEfpDteBcncRVxcsQvYXXWJGNfJY3z6Qw=;
  b=LFOptmJANNqkz6pzHsk9AEPaajUEL+rEbqEb72Kkk9cdPxdh7/wfFBJX
   Ynh+XWPHbUZLfpD0SKSqcgA6CiTN8ae1jYZu6iY7cHLTMGs6EvDZdkL7r
   mUqh/twj4GZBLhPcQj8oKkGnsck3v+Zt4DqWV8J70+WCygQVgxUMyNuVF
   jfbgYvVoALuIX5B+95mAFnCKNN7HcouTwf2NvAfJ1H2SyvX3JJsWoYMOs
   lWzSCaYowjiHfFN3/RjEf5pUkLgcEtLx8G9pDYrUqz0kxV6oBXtQnBIVI
   QCnsiimj6MFItpa4CDQ7TQgTcZAsorYAlOFTv0eOlCyQ9l9dV6GFOCKm2
   w==;
X-CSE-ConnectionGUID: ArpzwkzBQVyEvIxVgSoIfQ==
X-CSE-MsgGUID: gLKkGtRaTtK2tBoQwUM3hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63939831"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="63939831"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:19:29 -0700
X-CSE-ConnectionGUID: ln37oo4sSVGgtPADrikf7g==
X-CSE-MsgGUID: Cf3BSL1nT0KAv+tRtGKg6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="186112068"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:19:22 -0700
Message-ID: <af023723-63d5-46d3-85bb-c2d2dcfe7b15@linux.intel.com>
Date: Fri, 31 Oct 2025 16:19:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/28] KVM: TDX: WARN if mirror SPTE doesn't have full
 RWX when creating S-EPT mapping
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-13-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Pass in the mirror_spte to kvm_x86_ops.set_external_spte() to provide
> symmetry with .remove_external_spte(), and assert in TDX that the mirror
> SPTE is shadow-present with full RWX permissions (the TDX-Module doesn't
> allow the hypervisor to control protections).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


