Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162C82A3CC0
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 07:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgKCGYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 01:24:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:53522 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgKCGYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 01:24:32 -0500
IronPort-SDR: 1Dtmk1tdDVAsU3gXt1g5PBq0UtUO/BDorc2kugtHxJHKYKLQskwToHO+Myl3Dhpcf85hFSjRnG
 wQa0JfwziHXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="155993800"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="155993800"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 22:24:28 -0800
IronPort-SDR: /kmhGLNnzYaQ+04Ndb6V/0sv8KG0lxtDXF442YpiDYyGOG2j7kXZDb4r4LxT/J67mXqjqZ5ZDl
 JhcIs6IvIypQ==
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="470669617"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.118]) ([10.239.13.118])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 22:24:24 -0800
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Tao Xu <tao3.xu@intel.com>, Jim Mattson <jmattson@google.com>
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
        LKML <linux-kernel@vger.kernel.org>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALMp9eTrsz4fq19HXGjfQF3GmsQ7oqGW9GXVnMYXtwnPmJcsOA@mail.gmail.com>
 <d4388899-665f-8012-c609-8162fa7015ae@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <24fd6383-2360-8a1a-3c4c-1a3ee1b1db1c@intel.com>
Date:   Tue, 3 Nov 2020 14:24:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <d4388899-665f-8012-c609-8162fa7015ae@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/2020 2:12 PM, Tao Xu wrote:
> 
> 
> On 11/3/20 6:53 AM, Jim Mattson wrote:
>> On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
>>>
>>> There are some cases that malicious virtual machines can cause CPU stuck
>>> (event windows don't open up), e.g., infinite loop in microcode when
>>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>>> hardware CPU can't be used by host or other VM.
>>>
>>> To resolve those cases, it can enable a notify VM exit if no
>>> event window occur in VMX non-root mode for a specified amount of
>>> time (notify window).
>>>
>>> Expose a module param for setting notify window, default setting it to
>>> the time as 1/10 of periodic tick, and user can set it to 0 to disable
>>> this feature.
>>>
>>> TODO:
>>> 1. The appropriate value of notify window.
>>> 2. Another patch to disable interception of #DB and #AC when notify
>>> VM-Exiting is enabled.
>>>
>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Do you have test cases?
>>

yes we have. The nested #AC (CVE-2015-5307) is a known test case, though 
we need to tweak KVM to disable interception #AC for it.

> Not yet, because we are waiting real silicon to do some test. I should 
> add RFC next time before I test it in hardware.

