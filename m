Return-Path: <kvm+bounces-61662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FE7C23F76
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF630189E7AF
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9265532E122;
	Fri, 31 Oct 2025 08:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kmsoxXtL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59E932AAD0;
	Fri, 31 Oct 2025 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901031; cv=none; b=JpTvVF5eEXj4V9QexGP9Xqp0iDai+YzZSOjoUs4+ce8/PEhkgkiBtyqMnpQfUJjZMFJQ36uvZLurbHCbNKgZ84uMlfxvGpzhH4E5YhfkCQRybrDbwOVs6phy7EfZYTBqMCINp+lbaPgo91VbnId7Wh8ZZ43A6EDHo2BhTgqaFQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901031; c=relaxed/simple;
	bh=4KtmtUmeRKY0mhGFlHsvUKmdbP8tr/tefUK44+GBirI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iI4FHiikgKWa3jlCF0SX5d9Y3gfwRBiSWP3YfHOfMMmTRj1epL0GKEDL9/YT1fVe7Pltz3wkzj4Ra3zS7/DS8FuREe7wVHdnIDG4JOy60Xg0LZHpIxPNnl85EaHGxblqBxNmIgDzJPBQXBA2Vzs+NguAzPiGpJk+cygalCQcNzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kmsoxXtL; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901030; x=1793437030;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4KtmtUmeRKY0mhGFlHsvUKmdbP8tr/tefUK44+GBirI=;
  b=kmsoxXtLm5seRBblXpIeX24B9+tvv74UDZfIwB9mubmQEe2CFPBIFEDg
   2XPT5QBUQP26OX74Qm92KzYJ5BysNX2CY5A++24rJhjNh5LcYxWRzrYOM
   AcdNgUE8k9hftAcbb8xvRBzaHKzqyjAXHK9rnX5eO6c8fduw3DaCrolWX
   yyHZwrxbB7EP7UkExeo6m9x819yHcHlzk0CdsrAKYejHYV4l9Efj6RJpl
   XZwPPqylrXdu4lfVtBJ/ni31u5W6rb4jYDpj43A1ubZOU3NNsX3Ctc+vT
   WYuGJLgWYPShdAs2bZ6JseH2wN+WpZ2Ut/nokOv85XqyzkCtor+8Dy7TF
   w==;
X-CSE-ConnectionGUID: x7VCRS38Qc+rD/jlQ7amTQ==
X-CSE-MsgGUID: vj7cSTVnS8itcZpvlxKW0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63942707"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="63942707"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:57:08 -0700
X-CSE-ConnectionGUID: sPC6mEPlSqSwx3TQdrZz6Q==
X-CSE-MsgGUID: BsJwtL+UTb27i21msflWIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186118722"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:56:55 -0700
Message-ID: <88d479a0-e849-49d6-86e7-8cd00daccee0@linux.intel.com>
Date: Fri, 31 Oct 2025 16:56:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/28] KVM: TDX: Fold tdx_sept_zap_private_spte() into
 tdx_sept_remove_private_spte()
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
 <20251030200951.3402865-18-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Do TDH_MEM_RANGE_BLOCK directly in tdx_sept_remove_private_spte() instead
> of using a one-off helper now that the nr_premapped tracking is gone.
>
> Opportunistically drop the WARN on hugepages, which was dead code (see the
> KVM_BUG_ON() in tdx_sept_remove_private_spte()).
>
> No functional change intended.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


