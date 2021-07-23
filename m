Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5ED3D351B
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 09:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhGWGgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 02:36:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:54299 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhGWGgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 02:36:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10053"; a="191418868"
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="191418868"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 00:16:47 -0700
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="471023868"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.133]) ([10.238.0.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 00:16:41 -0700
Subject: Re: [PATCH v2 0/6] IPI virtualization support for VM
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
References: <20210723051626.18364-1-guang.zeng@intel.com>
 <CANRm+CywPSiW=dniYEnUhYnK0NGGnnxV53AdC0goivndn6KR5g@mail.gmail.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <4e8f8b7f-0b20-5c2a-f23d-3f5d5321dd3a@intel.com>
Date:   Fri, 23 Jul 2021 15:16:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CywPSiW=dniYEnUhYnK0NGGnnxV53AdC0goivndn6KR5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/2021 2:11 PM, Wanpeng Li wrote:
> On Fri, 23 Jul 2021 at 13:41, Zeng Guang <guang.zeng@intel.com> wrote:
>
> --------------------------------------
> IPI microbenchmark:
> (https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com)
>
> 2 vCPUs, 1:1 pin vCPU to pCPU, guest VM runs with idle=poll, x2APIC mode
> Improve the performance for unicast ipi is as expected, however, I
> wonder whether the broadcast performance is worse than PV
> IPIs/Thomas's IPI shorthands(IPI shorthands are supported by upstream
> linux apic/x2apic driver). The hardware acceleration is not always
> outstanding on AMD(https://lore.kernel.org/kvm/CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com/),
> how about your Intel guys? Please try a big VM at least 96 vCPUs as
> below or more bigger.

Intel IPIv target to accelerate unicast ipi process, not benefit to 
broadcast performance.

As to IPI benchmark, it's not big different to test with large or small 
scale of vCPUs. In essential, Normal IPI test try
to send ipi to any other online CPU in sequence. The cost on IPI process 
itself should be similar.

>> Result with IPIv enabled:
>>
>> Dry-run:                         0,             272798 ns
>> Self-IPI:                  5094123,           11114037 ns
>> Normal IPI:              131697087,          173321200 ns
>> Broadcast IPI:                   0,          155649075 ns
>> Broadcast lock:                  0,          161518031 ns
>>
>> Result with IPIv disabled:
>>
>> Dry-run:                         0,             272766 ns
>> Self-IPI:                  5091788,           11123699 ns
>> Normal IPI:              145215772,          174558920 ns
>> Broadcast IPI:                   0,          175785384 ns
>> Broadcast lock:                  0,          149076195 ns
>>
>>
>> As IPIv can benefit unicast IPI to other CPU, Noraml IPI test case gain
>> about 9.73% time saving on average out of 15 test runs when IPIv is
>> enabled.
>>
>>                  w/o IPIv                w/ IPIv
>> Normal IPI:     145944306.6 ns          131742993.1 ns
>> %Reduction                              -9.73%
>>
>> --------------------------------------
>> hackbench:
>>
>> 8 vCPUs, guest VM free run, x2APIC mode
>> ./hackbench -p -l 100000
>>
>>                  w/o IPIv        w/ IPIv
>> Time:           91.887          74.605
>> %Reduction:                     -18.808%
>>
>> 96 vCPUs, guest VM free run, x2APIC mode
>> ./hackbench -p -l 1000000
>>
>>                  w/o IPIv        w/ IPIv
>> Time:           287.504         235.185
>> %Reduction:                     -18.198%
> Good to know this.
>
>      Wanpeng
