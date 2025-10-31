Return-Path: <kvm+bounces-61653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D9295C23A17
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C6DDB4F0D7C
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 07:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B4132AACE;
	Fri, 31 Oct 2025 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="goZspn5d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF333329C4F;
	Fri, 31 Oct 2025 07:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761897514; cv=none; b=dGLyR0fNwDydJzac6lsbi+Bo1IErFHCArmLMk4XWV6vHrF9AinVgkRVtPKprzwWfQgz7jevF5EXWhjlnkUqA9d4QjtXnU7b9F3qIKN4Hj+wmJs1w38QFT3D40dza/6SpZTQbFp+bHk7ro+0/6WOhzG3FBljz7dAeWIk2u8Ai6z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761897514; c=relaxed/simple;
	bh=rzM0b8qPEYkMq5nIoO4tMjMsIEGrMoYlxde7BXZgKfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HIogGFfNUKplNjSoFbbOA0M7H97Uv+ex7ea+WK3xNdb8q7hp4Iuwp6CdLoK2Zsq75FU0a6DETz7PnnFBzCyeal7+LzI8jlGhCh12m7P/asHDtMU3UARIqfgTOuleiaV4MQ1++hBGgI4hUOKtceNC/U4FVPRMtMhouOJ8Yb8GUaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=goZspn5d; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761897513; x=1793433513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rzM0b8qPEYkMq5nIoO4tMjMsIEGrMoYlxde7BXZgKfY=;
  b=goZspn5dnwSdx0wnGIBedLEsVmCijQR8zOYDAJ9DYziwKsyIJyYBEysK
   9rmBTMXeIkJW8t94ZLfZGI/bH6NQh1aXyOtVQQF5K268be1bEl972jb1W
   DTTNvLO7voXC/gPxSFH4D9OEtIQb7Yby5JgOWBuJlsoKb0EIDZP3salof
   /EOu764ODGwOAYplkyRe5aUZuD4mrJZxspR9m5M70YBsCtdSyLayEWecp
   S13125gqwWd10Np1sqThsaEDwQPA8514P/Wfx4s8Bx9WoLObGJ67+jZ07
   jBp1f1sPtcuTqRWTYw6RCQrXTdE4Uk/m03NCvMApNYRK38lNbqpxKkeZa
   w==;
X-CSE-ConnectionGUID: VBey73xERvO0gqfsJjj/eQ==
X-CSE-MsgGUID: 6wXurUJPRYqWBosLmB8j3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="75401443"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="75401443"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 00:58:32 -0700
X-CSE-ConnectionGUID: aelFfb7/T7+TXvXFUL/t7w==
X-CSE-MsgGUID: o2Ju4geKSZSKLBD3vX8YRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="186108753"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 00:58:25 -0700
Message-ID: <7e43061a-b901-4e8f-8ee9-57d67aaf4f38@linux.intel.com>
Date: Fri, 31 Oct 2025 15:58:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/28] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
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
 <20251030200951.3402865-5-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Add and use a new API for mapping a private pfn from guest_memfd into the
> TDP MMU from TDX's post-populate hook instead of partially open-coding the
> functionality into the TDX code.  Sharing code with the pre-fault path
> sounded good on paper, but it's fatally flawed as simulating a fault loses
> the pfn, and calling back into gmem to re-retrieve the pfn creates locking
> problems, e.g. kvm_gmem_populate() already holds the gmem invalidation
> lock.
>
> Providing a dedicated API will also removing several MMU exports that
> ideally would not be exposed outside of the MMU, let alone to vendor code.
> On that topic, opportunistically drop the kvm_mmu_load() export.  Leave
> kvm_tdp_mmu_gpa_is_mapped() alone for now; the entire commit that added
> kvm_tdp_mmu_gpa_is_mapped() will be removed in the near future.
>
> Gate the API on CONFIG_KVM_GUEST_MEMFD=y as private memory _must_ be backed
> by guest_memfd.  Add a lockdep-only assert to that the incoming pfn is
> indeed backed by guest_memfd, and that the gmem instance's invalidate lock
> is held (which, combined with slots_lock being held, obviates the need to
> check for a stale "fault").
>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


