Return-Path: <kvm+bounces-60799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE1CBFA226
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:57:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 644AE19A38B5
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 05:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46757190477;
	Wed, 22 Oct 2025 05:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E7Jfqqcd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32082472A8;
	Wed, 22 Oct 2025 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112632; cv=none; b=gkNqE3uwOnIeJLO95wUtXlNlbxiGNBlyLhqi6mPVQ4cY+zQISJZS9r3mZI9d8GB3V98HpQrfYmfRbhKl/QI7OUBq0BGJ8PdZ5CcoN0hUAphNKEyF/FCiccg8CiQ6t/AZrbwZaW/3q5WnUH3QsG1KdOhcp1aBT/D6QVSR6qVwMmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112632; c=relaxed/simple;
	bh=Oq4fzkS01zCv2I4qOypTEqukIE12MkuzMGCj+rV1CCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BWDaBXdhwePiNdl1YjmBz/6uTMQvkIThYwoY4NNe2QnKzOo3fzHn7SS1y4//ru8A9CAxN8DS16gH5Z68lbYVsoULk/V2Gbx9a+KyV5rvHo38ugjh6oieiKL7WrMbessWf8+bPh+CmFMFkOmIlYej24+o83QVNfV2MczMiPGsuKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E7Jfqqcd; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761112631; x=1792648631;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Oq4fzkS01zCv2I4qOypTEqukIE12MkuzMGCj+rV1CCw=;
  b=E7Jfqqcdu7VQT1dxrFmwMMNAG5K7CoSj6nOrzt4x7aIA+SIH9WASa5dI
   i1AP78MKcZ87csLhzI+funJzjC1R+n7awfOxP2gYyMUNU5k7rgJeaoXVB
   wpzZ9yfNenup1BpwBpvRAcoDhSzIBCK1Mv+q0Mi3bF1clrloQOrP/k1Is
   4csnRM4NjzKFLc4rvl4RRjtrGgtf/Oq3nTGydaLfxZKovYO6Mk+b90t5s
   5Tfw9lBgIXzkp9TYnhE/1rZ8st4YLBIfEoGkS2L7mKs/TBQGyySTzMzi5
   4WixOG036XIQOZ7TvC27lkSBtBke8uDHVqoQeSmNEfGfvVnRYzBuLN6z0
   A==;
X-CSE-ConnectionGUID: nm06NyxuQnmq9chDrNiywQ==
X-CSE-MsgGUID: GdOklP4rQz2N8fyiqvH+4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62281249"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="62281249"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:57:10 -0700
X-CSE-ConnectionGUID: jQ221r4UTleoxdP+jV1Nkg==
X-CSE-MsgGUID: d9hLZVuOTp+rHjN7swLSrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="184184728"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:57:02 -0700
Message-ID: <bfe00290-6ab3-4c09-b0bf-46bb7af09d60@linux.intel.com>
Date: Wed, 22 Oct 2025 13:57:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/25] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_page_prefault()
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
 <20251017003244.186495-7-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251017003244.186495-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> Rename kvm_tdp_map_page() to kvm_tdp_page_prefault() now that it's used
> only by kvm_arch_vcpu_pre_fault_memory().
>
> No functional change intended.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

