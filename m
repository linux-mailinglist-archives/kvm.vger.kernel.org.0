Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440983DD70A
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhHBN0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:26:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:55701 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233818AbhHBN0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 09:26:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="193736130"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="193736130"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 06:25:50 -0700
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="520564738"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.136]) ([10.249.168.136])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 06:25:46 -0700
Subject: Re: [RFC PATCH v2 05/69] KVM: TDX: Add architectural definitions for
 structures and values
To:     Erdem Aktas <erdemaktas@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86 <x86@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <d29b2ac2090f20e8de96888742feb413f597f1dc.1625186503.git.isaku.yamahata@intel.com>
 <CAAYXXYy=fn9dUMjY6b6wgCHSTLewnTZLKb00NMupDXSWbNC9OQ@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <1057bbfe-c73e-a182-7696-afc59a4786d8@intel.com>
Date:   Mon, 2 Aug 2021 21:25:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAAYXXYy=fn9dUMjY6b6wgCHSTLewnTZLKb00NMupDXSWbNC9OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/31/2021 9:04 AM, Erdem Aktas wrote:
> On Fri, Jul 2, 2021 at 3:05 PM <isaku.yamahata@intel.com> wrote:
>> +/* Management class fields */
>> +enum tdx_guest_management {
>> +       TD_VCPU_PEND_NMI = 11,
>> +};
>> +
>> +/* @field is any of enum tdx_guest_management */
>> +#define TDVPS_MANAGEMENT(field)        BUILD_TDX_FIELD(32, (field))
> 
> I am a little confused with this. According to the spec, PEND_NMI has
> a field code of 0x200000000000000B
> I can understand that 0x20 is the class code and the PEND_NMI field code is 0xB.
> On the other hand, for the LAST_EXIT_TSC the field code is  0xA00000000000000A.

> Based on your code and the table in the spec, I can see that there is
> an additional mask (1ULL<<63) for readonly fields

No. bit 63 is not for readonly fields, but for non_arch fields.

Please see 18.7.1 General definition

> Is this information correct and is this included in the spec? I tried
> to find it but somehow I do not see it clearly defined.
> 
>> +#define TDX1_NR_TDCX_PAGES             4
>> +#define TDX1_NR_TDVPX_PAGES            5
>> +
>> +#define TDX1_MAX_NR_CPUID_CONFIGS      6
> Why is this just 6? I am looking at the CPUID table in the spec and
> there are already more than 6 CPUID leaves there.

This is the number of CPUID config reported by TDH.SYS.INFO. Current KVM 
only reports 6 leaves.

>> +#define TDX1_MAX_NR_CMRS               32
>> +#define TDX1_MAX_NR_TDMRS              64
>> +#define TDX1_MAX_NR_RSVD_AREAS         16
>> +#define TDX1_PAMT_ENTRY_SIZE           16
>> +#define TDX1_EXTENDMR_CHUNKSIZE                256
> 
> I believe all of the defined variables above need to be enumerated
> with TDH.SYS.INFO.

No. Only TDX1_MAX_NR_TDMRS, TDX1_MAX_NR_RSVD_AREAS and 
TDX1_PAMT_ENTRY_SIZE can be enumerated from TDH.SYS.INFO.

- TDX1_MAX_NR_CMRS is described in 18.6.3 CMR_INFO, which tells

   TDH.SYS.INFO leaf function returns a MAX_CMRS(32) entry array
   of CMR_INFO entries.

- TDX1_EXTENDMR_CHUNKSIZE is describe in 20.2.23 TDH.MR.EXTEND

>> +#define TDX_TDMR_ADDR_ALIGNMENT        512
> Is TDX_TDMR_ADDR_ALIGNMENT used anywhere or is it just for completeness?

It's the leftover during rebase. We will clean it up.

>> +#define TDX_TDMR_INFO_ALIGNMENT        512
> Why do we have alignment of 512, I am assuming to make it cache line
> size aligned for efficiency?

It should be leftover too.

SEAMCALL TDH.SYS.INFO requires each cmr info in CMR_INFO_ARRAY to be 
512B aligned

> 
>> +#define TDX_TDSYSINFO_STRUCT_ALIGNEMNT 1024
> 
> typo: ALIGNEMNT -> ALIGNMENT
> 
> -Erdem
> 

