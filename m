Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADE1942A6
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgCZPJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:09:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:17880 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbgCZPJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:09:27 -0400
IronPort-SDR: 7x7LOdjTPs40A6ZKdaqVSeQFEbmalSDR3389wllgNs2T+t365kccNKU0rrNgXVAgF6rePud2GE
 KN6x0HIZxMoA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 08:09:26 -0700
IronPort-SDR: 0olWpR3BrHOQAdLf02zYkwm6exIzj8RlT59MYX5rIQSqQ8WWjOXXO4S2Rk0kt1UhRQJefA2hw2
 ZTFvsFleDGzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,308,1580803200"; 
   d="scan'208";a="394014406"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.99]) ([10.249.169.99])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 08:09:22 -0700
Subject: Re: [PATCH v6 8/8] kvm: vmx: virtualize split lock detection
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
 <20200324151859.31068-9-xiaoyao.li@intel.com>
 <87eethz2p6.fsf@nanos.tec.linutronix.de>
 <88b01989-25cd-90af-bfe8-c236bd5d1dbf@intel.com>
 <87d08zxtgl.fsf@nanos.tec.linutronix.de>
 <1d98bddd-a6a4-2fcc-476b-c9b19f65c6b6@intel.com>
 <87a743xj0n.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <e58484ac-e355-299d-131c-6e8c12b0b1d0@intel.com>
Date:   Thu, 26 Mar 2020 23:09:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87a743xj0n.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/26/2020 10:55 PM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> On 3/26/2020 7:10 PM, Thomas Gleixner wrote:
>> If the host has it disabled, !split_lock_detect_on() is true, it skips
>> following check due to ||
>>
>> if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK)) {
>> 	inject #AC back to guest
and 	return 1;

> 
> That'd be a regular #AC, right?

Yes.

>> } else {
>> 	if (guest_alignment_check_enabled() || guest_sld_on())
>> 		inject #AC back to guest
and 		return 1;

> Here is clearly an else path missing.

the else path is fall through.

i.e. calling handle_user_split_lock().

If cannot handle, it falls through to report #AC to user space (QEMU)

>> }
> 

If there is no problem with the above. So what's the problem of the 
original?

