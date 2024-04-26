Return-Path: <kvm+bounces-16087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 392448B427C
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 01:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3969282E53
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 23:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40A63BBC5;
	Fri, 26 Apr 2024 23:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QATyuGCd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398A13A1C4;
	Fri, 26 Apr 2024 23:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714172785; cv=none; b=TzkD84UEFDoXeH/wMiAudjzGf/yLa199slKFtbisZYScG4x3f59H0S+WtCs3A8gqgHVka5DyEeHZeFtBDXfu5dRq8NM7W0323Qr2lfiempNZZxjUOX0yG0AtQH7ADbrKK/evCFvh/taowsWQDJLxdUlZCipDI/9peIlfqUG++Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714172785; c=relaxed/simple;
	bh=cKKbL4cjFxBEMaMkwZoYnLJ7hvLWzVbZoU0lhnkwidc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s3nTDId/FSBprnTBMSibQ4kB9pX1Wi05QKa5bVfzs0lO0kFZtAzbGpjsYvLtSL3Q3LhNRHmeYxtB/Y2urz7sU2vh/QUDq8n4iZt0rYyU0QpJDxNeG/3rzFMFNtNiRyf5968zLDXBAG3cgA4p+dq+TKw8eBF0xXjCRRXfTEhJQ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QATyuGCd; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714172783; x=1745708783;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cKKbL4cjFxBEMaMkwZoYnLJ7hvLWzVbZoU0lhnkwidc=;
  b=QATyuGCdLK3kqreQ99tR4R2hHLMzADOH458ScRDcOG5SrIoccUn4EoxN
   h3IDfdGO1MxlTVdXWxvyYpxHZ5CYQR/8uX1fQu5HG18YvNPHekj7NX3Xj
   e/Qp+xB8eNJ/y6cu8hT0NjUzA88QwC86s9qnIzAUgNyTWl7Zx7fjbkORV
   UMNasKPDr8wfZK814fc7vbtFys07GR40e5CKQBVidCbRYA98p5+NjKIaR
   /4t11FEdC6tWEfTBazfA4sYnGQ9Oh8Elh/yy5x/icrFdIRvuf6RjZT1Rd
   FInQIVMh+cZamxopU0MBcmG8wvubGd/RLD90JgA/7po0GIJqhrsVoCObN
   A==;
X-CSE-ConnectionGUID: yx0SJGWiR2m7XyPSOM8uog==
X-CSE-MsgGUID: 2zAh+vxaSP65Ix9UQcIELQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="12860890"
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="12860890"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 16:06:22 -0700
X-CSE-ConnectionGUID: uCBuxsRLQTSyNLKx3Rn2Nw==
X-CSE-MsgGUID: NhqNp2HSRGaicrVXUBYEDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="63036776"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.50]) ([10.24.10.50])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 16:06:23 -0700
Message-ID: <f5a80896-e1aa-4f23-a739-5835f7430f78@intel.com>
Date: Fri, 26 Apr 2024 16:06:22 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com,
 pbonzini@redhat.com, erdemaktas@google.com, vkuznets@redhat.com,
 seanjc@google.com, vannapurve@google.com, jmattson@google.com,
 mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com,
 rick.p.edgecombe@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/25/2024 3:07 PM, Reinette Chatre wrote:
> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> new file mode 100644
> index 000000000000..5100b28228af
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> @@ -0,0 +1,166 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test configure of APIC bus frequency.
> + *
> + * Copyright (c) 2024 Intel Corporation
> + *
> + * To verify if the APIC bus frequency can be configured this test starts

Nit: some typos here?

> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
> +
> +	vm = __vm_create(VM_SHAPE_DEFAULT, 1, 0);

Use vm_create() instead?

