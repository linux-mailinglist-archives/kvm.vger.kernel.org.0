Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC4E1EDBF6
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 05:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFDDzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 23:55:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:34717 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgFDDzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 23:55:35 -0400
IronPort-SDR: xWJKvnjjWtZ0NALSCQpfHO7XCHPmPy82xhGzFp9qCel4BH0/xbVy2Qhjcc3RG1x1TehI6bGx26
 +Dk+BjF7u/6Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 20:55:34 -0700
IronPort-SDR: vsv62uYmJxsnpuJhSY9ikvOBFjgXEbIiyTOGu4Mh/HyK94t0GAM7DbTZZAdIQiRRoX/KuBbFy/
 0qsct/Yd439w==
X-IronPort-AV: E=Sophos;i="5.73,471,1583222400"; 
   d="scan'208";a="445358915"
Received: from unknown (HELO [10.239.13.99]) ([10.239.13.99])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 20:55:33 -0700
Subject: Re: [PATCH] KVM: x86: Assign correct value to array.maxnent
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200604024304.14643-1-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <95f888b8-eed5-cb31-57a4-148d7708b7cb@intel.com>
Date:   Thu, 4 Jun 2020 11:55:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200604024304.14643-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/2020 10:43 AM, Xiaoyao Li wrote:
> Delay the assignment of array.maxnent to use correct value for the case
> cpuid->nent > KVM_MAX_CPUID_ENTRIES.
> 
> Fixes: e53c95e8d41e ("KVM: x86: Encapsulate CPUID entries and metadata in struct")
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 253b8e875ccd..befff01d100c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -870,7 +870,6 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>   
>   	struct kvm_cpuid_array array = {
>   		.nent = 0,
> -		.maxnent = cpuid->nent,
>   	};
>   	int r, i;
>   
> @@ -887,6 +886,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>   	if (!array.entries)
>   		return -ENOMEM;
>   
> +	array.maxnent = cpuid->nent;

Miss the fact that maxnent is const, V2 is coming.

> +
>   	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
>   		r = get_cpuid_func(&array, funcs[i], type);
>   		if (r)
> 

