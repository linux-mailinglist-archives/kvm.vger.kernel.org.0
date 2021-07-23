Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F133D347E
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 08:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhGWFfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 01:35:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:37245 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhGWFfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 01:35:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10053"; a="211538879"
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="211538879"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 23:16:06 -0700
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="471004329"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.133]) ([10.238.0.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 23:16:01 -0700
Subject: Re: [PATCH 0/5] IPI virtualization support for VM
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <CANRm+Cy=ncU-H7duei5q+CG+pm-kXvG8N8CiUQavQ3OEpDj9eg@mail.gmail.com>
 <d96aa6dc-0638-f77e-f412-e2af52053d2c@intel.com>
 <CANRm+CyinezdL4udNv1fkCymCUdOjG7wjBPKsbcMTVw0pAbcjA@mail.gmail.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <d0fa2542-8c64-f6ab-a864-b71f64d50304@intel.com>
Date:   Fri, 23 Jul 2021 14:15:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CyinezdL4udNv1fkCymCUdOjG7wjBPKsbcMTVw0pAbcjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/2021 3:37 PM, Wanpeng Li wrote:
> On Mon, 19 Jul 2021 at 15:26, Zeng Guang <guang.zeng@intel.com> wrote:
>> On 7/16/2021 5:25 PM, Wanpeng Li wrote:
>>> On Fri, 16 Jul 2021 at 15:14, Zeng Guang <guang.zeng@intel.com> wrote:
>>>> Current IPI process in guest VM will virtualize the writing to interrupt
>>>> command register(ICR) of the local APIC which will cause VM-exit anyway
>>>> on source vCPU. Frequent VM-exit could induce much overhead accumulated
>>>> if running IPI intensive task.
>>>>
>>>> IPI virtualization as a new VT-x feature targets to eliminate VM-exits
>>>> when issuing IPI on source vCPU. It introduces a new VM-execution
>>>> control - "IPI virtualization"(bit4) in the tertiary processor-based
>>>> VM-exection controls and a new data structure - "PID-pointer table
>>>> address" and "Last PID-pointer index" referenced by the VMCS. When "IPI
>>>> virtualization" is enabled, processor emulateds following kind of writes
>>>> to APIC registers that would send IPIs, moreover without causing VM-exits.
>>>> - Memory-mapped ICR writes
>>>> - MSR-mapped ICR writes
>>>> - SENDUIPI execution
>>>>
>>>> This patch series implement IPI virtualization support in KVM.
>>>>
>>>> Patches 1-3 add tertiary processor-based VM-execution support
>>>> framework.
>>>>
>>>> Patch 4 implement interrupt dispatch support in x2APIC mode with
>>>> APIC-write VM exit. In previous platform, no CPU would produce
>>>> APIC-write VM exit with exit qulification 300H when the "virtual x2APIC
>>>> mode" VM-execution control was 1.
>>>>
>>>> Patch 5 implement IPI virtualization related function including
>>>> feature enabling through tertiary processor-based VM-execution in
>>>> various scenario of VMCS configuration, PID table setup in vCPU creation
>>>> and vCPU block consideration.
>>>>
>>>> Document for IPI virtualization is now available at the latest "Intel
>>>> Architecture Instruction Set Extensions Programming Reference".
>>>>
>>>> Document Link:
>>>> https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
>>>>
>>>> We did experiment to measure average time sending IPI from source vCPU
>>>> to the target vCPU completing the IPI handling by kvm unittest w/ and
>>>> w/o IPI virtualization. When IPI virtualizatin enabled, it will reduce
>>>> 22.21% and 15.98% cycles comsuming in xAPIC mode and x2APIC mode
>>>> respectly.
>>>>
>>>> KMV unittest:vmexit/ipi, 2 vCPU, AP runs without halt to ensure no VM
>>>> exit impact on target vCPU.
>>>>
>>>>                   Cycles of IPI
>>>>                   xAPIC mode              x2APIC mode
>>>>           test    w/o IPIv  w/ IPIv       w/o IPIv  w/ IPIv
>>>>           1       6106      4816          4265      3768
>>>>           2       6244      4656          4404      3546
>>>>           3       6165      4658          4233      3474
>>>>           4       5992      4710          4363      3430
>>>>           5       6083      4741          4215      3551
>>>>           6       6238      4904          4304      3547
>>>>           7       6164      4617          4263      3709
>>>>           8       5984      4763          4518      3779
>>>>           9       5931      4712          4645      3667
>>>>           10      5955      4530          4332      3724
>>>>           11      5897      4673          4283      3569
>>>>           12      6140      4794          4178      3598
>>>>           13      6183      4728          4363      3628
>>>>           14      5991      4994          4509      3842
>>>>           15      5866      4665          4520      3739
>>>>           16      6032      4654          4229      3701
>>>>           17      6050      4653          4185      3726
>>>>           18      6004      4792          4319      3746
>>>>           19      5961      4626          4196      3392
>>>>           20      6194      4576          4433      3760
>>>>
>>>> Average cycles  6059      4713.1        4337.85   3644.8
>>>> %Reduction                -22.21%                 -15.98%
>>> Commit a9ab13ff6e (KVM: X86: Improve latency for single target IPI
>>> fastpath) mentioned that the whole ipi fastpath feature reduces the
>>> latency from 4238 to 3293 around 22.3% on SKX server, why your IPIv
>>> hardware acceleration is worse than software emulation? In addition,
>> Actually this performance data was measured on the basis of fastpath
>> optimization while cpu runs at base frequency.
>>
>> As a result, IPI virtualization could have extra 15.98% cost reduction
>> over IPI fastpath process in x2apic mode.
> I observed that adaptive advance lapic timer and adaptive halt-polling
> will influence kvm-unit-tests/vmexit.flat IPI testing score, could you
> post the score after disabling these features as commit a9ab13ff6e
> (KVM: X86: Improve latency for single target IPI fastpath) mentioned？
> In addition, please post the hackbench(./hackbench -l 1000000) and ipi
> microbenchmark scores.

We modified unittest to make AP runing with idle loop instead of hlt . 
This eliminates the impact
from adaptive halt-polling. So far we don't observe the influence from 
adaptive advance lapic timer
by test either. vmexit/ipi test should not involve lapic timer.

We post the hackbench and ipi microbenchmark score in patch V2 for your 
reference.

Thanks.

>
>      Wanpeng
