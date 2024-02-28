Return-Path: <kvm+bounces-10172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBC786A453
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 01:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECA6228D0D9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3E6210D;
	Wed, 28 Feb 2024 00:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I79RQkRv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65C41852;
	Wed, 28 Feb 2024 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709079299; cv=none; b=TshFQYehgUp+na5ItJhU26bpF84Dslp1GVTANfMHuKWE8a+GAdm+jVnOMp9Ju5WV9cCkC1y1zg0Y9yigNUkBUA8AAPMeBRT9yZ60gu6IzL/vcmFu7f2WRiXksVRJXXLNFr+g+RIeOEmkSRYEYhxej+qMKe2MZo/IviRf/1P4EjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709079299; c=relaxed/simple;
	bh=rx8auOqwAhy8kMX7uwjsnwlR7SlEVNwlATa6UTNue6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLrLkVfPvVXWIT2J5Z6RFJFA48dmEa5Rnrk+v1EDarryoIfsZy5/RMKwUx0ad/bGhPXi+D+duhgoq4JLu5MX0OCeq3vUN1Hm/ohvWKNTW3gVbM3pQyhtRc+7LauAucJ0z9wCfiFkWRok0q95rmWQlYQBjx3xmAni3kPMSOnMPQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I79RQkRv; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709079298; x=1740615298;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rx8auOqwAhy8kMX7uwjsnwlR7SlEVNwlATa6UTNue6E=;
  b=I79RQkRv3EdJ0Zc0kxSylFjd2E7hbYH6GLLbFlAHmtVOiqu6s++EGCkp
   paXbz6/OvKbkBX449Obi/gQziPM6ylRzZHkdJrvteBS3JmcS9MYgdxLBK
   u3+xSCPU33xmJ+y7VF4Z1RlrplmwUuncngwJ7TxhCOlkfyh8euR/uDvEf
   o2wPYuciqznsXy5YkFGAEK1aeuwFzioHnhcEiPedOCC2FQPZq+axouChl
   8wUQlXVOl3rMFoq9/WjRqI5fwS+HoeRaLaGD2kPkpa6FFU24nN5FyK2PE
   +LYc7hwTRCOOGPuxudT7A8oYzgPW0MTHoyutWxRPMgfchD4EUFGHxUTDO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3617028"
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="3617028"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 16:14:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="11890341"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 16:14:49 -0800
Message-ID: <75d37243-e2a3-421a-b74f-ccbe307fef96@intel.com>
Date: Wed, 28 Feb 2024 08:14:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/11] KVM: selftests: Allow tagging protected memory
 in guest page tables
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Andrew Jones
 <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>,
 Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>,
 Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
References: <20240223004258.3104051-1-seanjc@google.com>
 <20240223004258.3104051-8-seanjc@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240223004258.3104051-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/2024 8:42 AM, Sean Christopherson wrote:
...
> diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> new file mode 100644
> index 000000000000..218f5cdf0d86
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> +#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H

Since the file name is changed from kvm_host.h (in v7) to 
kvm_util_arch.h, we need to update it as well.

Ditto for other archs

> +struct kvm_vm_arch {};
> +
> +#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H



