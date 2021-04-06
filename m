Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4084A354C29
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 07:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242582AbhDFFOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 01:14:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:35436 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229808AbhDFFOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 01:14:50 -0400
IronPort-SDR: J1XWIxW8FcRoXgOwybzjS4Zgbenxsw/oM3qTaNliG7cZKDpskCFdwwKSs976PhHZx05CEpPLKI
 M5+a9sdW+jxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="189769885"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="189769885"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 22:14:43 -0700
IronPort-SDR: FQu7ewQkvFRmUhJFYhyikjPRL7SKJwWn+m4eOsgZ6RKoMQmy4coMCVDuAj42onYZyiXF0tqMSw
 CrXiOTxornmw==
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="421039576"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 22:14:40 -0700
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     andi@firstfloor.org, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, kan.liang@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei.w.wang@intel.com, x86@kernel.org, Like Xu <like.xu@intel.com>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
Date:   Tue, 6 Apr 2021 13:14:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <606BD46F.7050903@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Xiangdong,

On 2021/4/6 11:24, Liuxiangdong (Aven, Cloud Infrastructure Service Product 
Dept.) wrote:
> Hi，like.
> Some questions about this new pebs patches set：
> https://lore.kernel.org/kvm/20210329054137.120994-2-like.xu@linux.intel.com/
>
> The new hardware facility supporting guest PEBS is only available
> on Intel Ice Lake Server platforms for now.

Yes, we have documented this "EPT-friendly PEBS" capability in the SDM
18.3.10.1 Processor Event Based Sampling (PEBS) Facility

And again, this patch set doesn't officially support guest PEBS on the Skylake.

>
>
> AFAIK， Icelake supports adaptive PEBS and extended PEBS which Skylake 
> doesn't.
> But we can still use IA32_PEBS_ENABLE MSR to indicate general-purpose 
> counter in Skylake.

For Skylake, only the PMC0-PMC3 are valid for PEBS and you may
mask the other unsupported bits in the pmu->pebs_enable_mask.

> Is there anything else that only Icelake supports in this patches set?

The PDIR counter on the Ice Lake is the fixed counter 0
while the PDIR counter on the Sky Lake is the gp counter 1.

You may also expose x86_pmu.pebs_vmx for Skylake in the 1st patch.

>
>
> Besides, we have tried this patches set in Icelake.  We can use pebs(eg: 
> "perf record -e cycles:pp")
> when guest is kernel-5.11, but can't when kernel-4.18.  Is there a 
> minimum guest kernel version requirement?

The Ice Lake CPU model has been added since v5.4.

You may double check whether the stable tree(s) code has
INTEL_FAM6_ICELAKE in the arch/x86/include/asm/intel-family.h.

>
>
> Thanks,
> Xiangdong Liu

