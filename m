Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B710D973E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406143AbfJPQZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:25:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:53038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392349AbfJPQZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:25:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 09:25:33 -0700
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="189729232"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.58]) ([10.255.31.58])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Oct 2019 09:25:29 -0700
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
 <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <bea889c5-1599-1eb8-ff3a-3bde1e58afa3@intel.com>
Date:   Thu, 17 Oct 2019 00:25:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/2019 11:37 PM, Paolo Bonzini wrote:
> On 16/10/19 16:43, Thomas Gleixner wrote:
>>
>> N | #AC       | #AC enabled | SMT | Ctrl    | Guest | Action
>> R | available | on host     |     | exposed | #AC   |
>> --|-----------|-------------|-----|---------|-------|---------------------
>>    |           |             |     |         |       |
>> 0 | N         |     x       |  x  |   N     |   x   | None
>>    |           |             |     |         |       |
>> 1 | Y         |     N       |  x  |   N     |   x   | None
> 
> So far so good.
> 
>> 2 | Y         |     Y       |  x  |   Y     |   Y   | Forward to guest
>>
>> 3 | Y         |     Y       |  N  |   Y     |   N   | A) Store in vCPU and
>>    |           |             |     |         |       |    toggle on VMENTER/EXIT
>>    |           |             |     |         |       |
>>    |           |             |     |         |       | B) SIGBUS or KVM exit code
> 
> (2) is problematic for the SMT=y case, because of what happens when #AC
> is disabled on the host---safe guests can start to be susceptible to
> DoS.
> 
> For (3), which is the SMT=n case,, the behavior is the same independent of
> guest #AC.
> 
> So I would change these two lines to:
> 
>    2 | Y         |     Y       |  Y  |   N     |   x   | On first guest #AC,
>      |           |             |     |         |       | disable globally on host.
>      |           |             |     |         |       |
>    3 | Y         |     Y       |  N  |   Y     |   x   | Switch MSR_TEST_CTRL on
>      |           |             |     |         |       | enter/exit, plus:
>      |           |             |     |         |       | A) #AC forwarded to guest.
>      |           |             |     |         |       | B) SIGBUS or KVM exit code
>

I just want to get confirmed that in (3), we should split into 2 case:

a) if host has it enabled, still apply the constraint that guest is 
forcibly enabled? so we don't switch MSR_TEST_CTL.

b) if host has it disabled, we can switch MSR_TEST_CTL on enter/exit.
