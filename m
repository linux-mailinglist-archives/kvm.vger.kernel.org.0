Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6357D91
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 09:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0H6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 03:58:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:36728 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfF0H6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 03:58:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 00:58:32 -0700
X-IronPort-AV: E=Sophos;i="5.63,423,1557212400"; 
   d="scan'208";a="156158752"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 27 Jun 2019 00:58:29 -0700
Subject: Re: [PATCH v9 11/17] kvm/vmx: Emulate MSR TEST_CTL
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-12-git-send-email-fenghua.yu@intel.com>
 <b52b0f72-e242-68b1-640c-85759bdce869@linux.intel.com>
 <alpine.DEB.2.21.1906270901120.32342@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
Message-ID: <fa53c72c-b1af-7d77-d39c-a9401dc65e27@linux.intel.com>
Date:   Thu, 27 Jun 2019 15:58:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906270901120.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/2019 3:12 PM, Thomas Gleixner wrote:
> 
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
> 
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top
> 
> A: Yes
> Q: Should I trim all irrelevant context?
> 

Sorry about this.
Won't do it anymore.

> On Thu, 27 Jun 2019, Xiaoyao Li wrote:
>>
>> Do you have any comments on this one as the policy of how to expose split lock
>> detection (emulate TEST_CTL) for guest changed.
>>
>> This patch makes the implementation as below:
>>
>> Host	|Guest	|Actual value in guest	|split lock happen in guest
>> ------------------------------------------------------------------
>> on	|off	|	on		|report #AC to userspace
>> 	|on	|	on		|inject #AC back to guest
>> ------------------------------------------------------------------
>> off	|off	|	off		|No #AC
>> 	|on	|	on		|inject #AC back to guest
> 
> A: Because it's way better to provide implementation details and useless
>     references to the SDM.
> 
> Q: What's the reason that this table is _NOT_ part of the changelog?
> 

will add it in next version.

>> In case 2, when split lock detection of both host and guest on, if there is a
>> split lock is guest, it will inject #AC back to userspace. Then if #AC is from
>> guest userspace apps, guest kernel sends SIGBUS to userspace apps instead of
>> whole guest killed by host. If #AC is from guest kernel, guest kernel may
>> clear it's split lock bit in test_ctl msr and re-execute the instruction, then
>> it goes into case 1, the #AC will report to host userspace, e.g., QEMU.
> 
> The real interesting question is whether the #AC on split lock prevents the
> actual bus lock or not. If it does then the above is fine.
> 
> If not, then it would be trivial for a malicious guest to set the
> SPLIT_LOCK_ENABLE bit and "handle" the exception pro forma, return to the
> offending instruction and trigger another one. It lowers the rate, but that
> doesn't make it any better.
> 
> The SDM is as usual too vague to be useful. Please clarify.
>

This feature is to ensure no bus lock (due to split lock) in hardware, 
that to say, when bit 29 of TEST_CTL is set, there is no bus lock due to 
split lock can be acquired.

> Thanks,
> 
> 	tglx
> 
