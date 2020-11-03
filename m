Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66A62A3CA9
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 07:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKCGMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 01:12:47 -0500
Received: from mga18.intel.com ([134.134.136.126]:42433 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgKCGMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 01:12:47 -0500
IronPort-SDR: jESKfE7+rU7U9IVR1F60q5nifyN4rCL+8w7GYh2/zqfm+1Qct23J2JxY9joSiT3a76W5f1LycO
 RWGRdBkk7ndQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="156784134"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="156784134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 22:12:46 -0800
IronPort-SDR: xNIyDGLfoFK7i4p3oARDq1lrrWYtrHxt+zWGPYWrnjYPZMV0pMjBM4ajqmiHH9yNMOpDWTq8NO
 fl+0TvZJdMpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="353094900"
Received: from shzintpr02.sh.intel.com (HELO [0.0.0.0]) ([10.109.19.68])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2020 22:12:43 -0800
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALMp9eTrsz4fq19HXGjfQF3GmsQ7oqGW9GXVnMYXtwnPmJcsOA@mail.gmail.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <d4388899-665f-8012-c609-8162fa7015ae@intel.com>
Date:   Tue, 3 Nov 2020 14:12:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTrsz4fq19HXGjfQF3GmsQ7oqGW9GXVnMYXtwnPmJcsOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/20 6:53 AM, Jim Mattson wrote:
> On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
>>
>> There are some cases that malicious virtual machines can cause CPU stuck
>> (event windows don't open up), e.g., infinite loop in microcode when
>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>> hardware CPU can't be used by host or other VM.
>>
>> To resolve those cases, it can enable a notify VM exit if no
>> event window occur in VMX non-root mode for a specified amount of
>> time (notify window).
>>
>> Expose a module param for setting notify window, default setting it to
>> the time as 1/10 of periodic tick, and user can set it to 0 to disable
>> this feature.
>>
>> TODO:
>> 1. The appropriate value of notify window.
>> 2. Another patch to disable interception of #DB and #AC when notify
>> VM-Exiting is enabled.
>>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Do you have test cases?
> 
Not yet, because we are waiting real silicon to do some test. I should 
add RFC next time before I test it in hardware.
