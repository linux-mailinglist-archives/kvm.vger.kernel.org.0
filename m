Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4A1302086
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 03:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbhAYCnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jan 2021 21:43:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:8483 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbhAYCnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jan 2021 21:43:12 -0500
IronPort-SDR: L9e98l/WCdsGEpP6sPdij86GvGfP/EKvHS//65ne+58ONOvACUpIYn9KHq7qIXn9to0Bt7prwB
 MQKtVERw/Q3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="198427923"
X-IronPort-AV: E=Sophos;i="5.79,372,1602572400"; 
   d="scan'208";a="198427923"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2021 18:41:10 -0800
IronPort-SDR: TR20KBR/8CvLXHWV/Xpyr7sXuW2iA7heH/n3hUOXi7M/lGpqwTvMMPFuA52qa60fCjrqe9zq5H
 zlx+ghhtJqIg==
X-IronPort-AV: E=Sophos;i="5.79,372,1602572400"; 
   d="scan'208";a="471752637"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2021 18:41:08 -0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        kvm <kvm@vger.kernel.org>, Wei Wang <wei.w.wang@intel.com>
References: <EEC2A80E7137D84ABF791B01D40FA9A601EC200E@DGGEMM506-MBX.china.huawei.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <584b4e9a-37e7-1f2a-0a67-42034329a9dc@linux.intel.com>
Date:   Mon, 25 Jan 2021 10:41:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <EEC2A80E7137D84ABF791B01D40FA9A601EC200E@DGGEMM506-MBX.china.huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ kvm@vger.kernel.org

Hi Liuxiangdong,

On 2021/1/22 18:02, Liuxiangdong (Aven, Cloud Infrastructure Service 
Product Dept.) wrote:
> Hi Like,
> 
> Some questions about 
> https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/ <https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/>

Thanks for trying the PEBS feature in the guest,
and I assume you have correctly applied the QEMU patches for guest PEBS.

> 
> 1)Test in IceLake

In the [PATCH v3 10/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, 
DTES64, we only support Ice Lake with the following x86_model(s):

#define INTEL_FAM6_ICELAKE_X		0x6A
#define INTEL_FAM6_ICELAKE_D		0x6C

you can check the eax output of "cpuid -l 1 -1 -r",
for example "0x000606a4" meets this requirement.

> 
> HOST:
> 
> CPU family:                      6
> 
> Model:                           106
> 
> Model name:                      Intel(R) Xeon(R) Platinum 8378A CPU $@ $@
> 
> microcode: sig=0x606a6, pf=0x1, revision=0xd000122

As long as you get the latest BIOS from the provider,
you may check 'cat /proc/cpuinfo | grep code | uniq' with the latest one.

> 
> Guest:  linux kernel 5.11.0-rc2

I assume it's the "upstream tag v5.11-rc2" which is fine.

> 
> We can find pebs/intel_pt flag in guest cpuinfo, but there still exists 
> error when we use perf

Just a note, intel_pt and pebs are two features and we can write
pebs records to intel_pt buffer with extra hardware support.
(by default, pebs records are written to the pebs buffer)

You may check the output of "dmesg | grep PEBS" in the guest
to see if the guest PEBS cpuinfo is exposed and use "perf record
–e cycles:pp" to see if PEBS feature actually  works in the guest.

> 
> # perf record –e cycles:pp
> 
> Error:
> 
> cycles:pp: PMU Hardware doesn’t support sampling/overflow-interrupts. Try 
> ‘perf stat’
> 
> Could you give some advice?

If you have more specific comments or any concerns, just let me know.

> 
> 2)Test in Skylake
> 
> HOST:
> 
> CPU family:                      6
> 
> Model:                           85
> 
> Model name:                      Intel(R) Xeon(R) Gold 6146 CPU @
> 
>                                    3.20GHz
> 
> microcode        : 0x2000064
> 
> Guest: linux 4.18
> 
> we cannot find intel_pt flag in guest cpuinfo because 
> cpu_has_vmx_intel_pt() return false.

You may check vmx_pebs_supported().

> 
> SECONDARY_EXEC_PT_USE_GPA/VM_EXIT_CLEAR_IA32_RTIT_CTL/VM_ENTRY_LOAD_IA32_RTIT_CTL 
> are both disable.
> 
> Is it because microcode is not supported?
> 
> And, isthere a new macrocode which can support these bits? How can we get this?

Currently, this patch set doesn't support guest PEBS on the Skylake
platforms, and if we choose to support it, we will let you know.

---
thx,likexu

> 
> Thanks,
> 
> Liuxiangdong
> 

