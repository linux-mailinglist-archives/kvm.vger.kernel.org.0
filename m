Return-Path: <kvm+bounces-61144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B4DC0C8F6
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F2E4401704
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 09:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7CA2367B5;
	Mon, 27 Oct 2025 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fn92Uak3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9752DE6F5;
	Mon, 27 Oct 2025 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761555721; cv=none; b=ul4FOq4ZzLerCWzW0bGNXn+/GiG43H0iQZdYrmpBnczOfARx69mklQ2MDP8afxTPsORHqoj/9+BpyzeJPqdNb2OCBP5+Gyj/cBBP1ucsphs2eMUUSWmdJ+cK7OLzeKMsKtsU+G9M5aDiX9jg0/Hqqo7t3r0Ap8V26YP8Ml7hKgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761555721; c=relaxed/simple;
	bh=275YkRCyZVfjEDUsCr12iYfs5/SgTlKkXm5iRoBP66c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JTkWiickBbDcYj9HVArT/uulGYaZ++47UmmfbjA2K8KotCu5VUZ+tplcnYm+9HNDq86GsOeUdWqQPWn1cT134EhT0fqEHl+mDPeSKZ9WYkJoBK8uHBOdBASn6J2W3isESOOpJF9rYAhD2Tjpj/2+31E/WN2HNt3QFJGpgiex7Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fn92Uak3; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761555720; x=1793091720;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=275YkRCyZVfjEDUsCr12iYfs5/SgTlKkXm5iRoBP66c=;
  b=Fn92Uak3va2SCJY6D4AlJ/Bar4OEIFtUlohQEASvWtQohpeW4oFN//S8
   5hJAaMFqdkvwP5GrwdPV6H6Q6jV27AZJ7JY5JQOq461XIgy7vVnwaCz6s
   0FI7ob3QRmy8UioPEILE9lmZQyDoDrgtBxGGrRXj5q9jYAgPmVnEY539B
   WZ8/0Qd29a/UplxD5QdR9dsRaC8MsB2PTbRycypbcfPZ1AofP7YtzCKdS
   HaQkjppODpZ4vVZ7WuYDYXsuIxcjZRFU3TQU4tgiyQ5n8v43Sg+9bER52
   Kf0GsoJ9rKwQGklmZdmjNyUvnJcrnmVR3dr6Zfl1JQtSLxnW+QFkIVrwS
   g==;
X-CSE-ConnectionGUID: mHpOW1faQCC77K26FFV05w==
X-CSE-MsgGUID: gM+WzI8jTnimGfrSyWr3Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67464789"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67464789"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:01:59 -0700
X-CSE-ConnectionGUID: iCVeVDcZSguedVPvO1GnIg==
X-CSE-MsgGUID: rPVV21LWTqG3HlsE3kXlFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184892900"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:01:51 -0700
Message-ID: <59ae9957-88a8-4777-9bd2-196e8b4eb8ac@linux.intel.com>
Date: Mon, 27 Oct 2025 17:01:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/25] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
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
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-14-seanjc@google.com>
 <5dea4a3d-c7b7-48f0-b2d5-7597e0cd5f00@linux.intel.com>
 <aPuqYz3ly5a3__mf@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aPuqYz3ly5a3__mf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/25/2025 12:33 AM, Sean Christopherson wrote:
> On Fri, Oct 24, 2025, Binbin Wu wrote:
>>
>> On 10/17/2025 8:32 AM, Sean Christopherson wrote:
>>> Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spte() as
>>> providing a one-off helper for effectively three lines of code is at best a
>>> wash, and splitting the code makes the comment for smp_rmb()  _extremely_
>>> confusing as the comment talks about reading kvm->arch.pre_fault_allowed
>>> before kvm_tdx->state, but the immediately visible code does the exact
>>> opposite.
>>>
>>> Opportunistically rewrite the comments to more explicitly explain who is
>>> checking what, as well as _why_ the ordering matters.
>>>
>>> No functional change intended.
>>>
>>> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>>
>> One nit below.
>>
>> [...]
>>> +	/*
>>> +	 * If the TD isn't finalized/runnable, then userspace is initializing
>>> +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
>>> +	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.ADD.
>>> +	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all mapped pages
>>                                                                     ^
>>                                                  Nit: Is pre-mapped better?
> Yeah, updated (and then it gets deleted a few commits later :-) ).
Oh, right, nr_premapped will be dropped later.

Since the whole nr_premapped will be dropped, do we still need a cleanup patch
like patch 12 which will be dropped finally?

