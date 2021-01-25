Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E67303264
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 04:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbhAYM5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 07:57:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:5384 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbhAYMyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 07:54:16 -0500
IronPort-SDR: EzCSf1UTVaoAg66S8X5xdI4mPotAfAT+XruT49cMsrZo9qGiB2GWPaKPqA/fdssAAJyDd4JXSI
 jqTyOzXASRQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="177147235"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="177147235"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 04:53:33 -0800
IronPort-SDR: tWqBdNMhV3hcViy9JOaGmcT+5DWyuLq+FZG/MIYJlpqeviRwZ4SeY/JqdPCEH9QophG81Wz/RK
 16TbnkbIEhyg==
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="387359615"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.168.247]) ([10.249.168.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 04:53:29 -0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
 <YAHkOiQsxMfOMYvp@google.com>
 <YAqhPPkexq+dQ5KD@hirez.programming.kicks-ass.net>
 <eb30d86f-6492-d6e3-3a24-f58c724f68fd@linux.intel.com>
 <YA6nxuM5Stlolk5x@hirez.programming.kicks-ass.net>
 <076a5c7b-de2e-daf9-e6c0-5a42fb38aaa3@intel.com>
 <YA62/DV7reRvVyYk@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <e78cee6c-5d05-753e-1265-0b0e06c201a7@intel.com>
Date:   Mon, 25 Jan 2021 20:53:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YA62/DV7reRvVyYk@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/25 20:18, Peter Zijlstra wrote:
> On Mon, Jan 25, 2021 at 08:07:06PM +0800, Xu, Like wrote:
>
>> So under the premise that counter cross-mapping is allowed,
>> how can hypercall help fix it ?
> Hypercall or otherwise exposing the mapping, will let the guest fix it
> up when it already touches the data. Which avoids the host from having
> to access the guest memory and is faster, no?
- as you may know, the mapping table is changing rapidly from
the time records to be rewritten to the time records to be read;

- the patches will modify the records before it is notified via PMI
which means it's transparent to normal guests (including Windows);

- a malicious guest would ignore the exposed mapping and the
hypercall and I don't think it can solve the leakage issue at all;

- make the guest aware of that hypercall or mapping requires more code changes
in the guest side; but now we can make it on the KVM side and we also know that
cross-mapping case rarely happens, and the overhead is acceptable based on 
our tests;

Please let me know if you or Sean are not going to
buy in the PEBS records rewrite proposal in the patch 13 - 17.

---
thx,likexu
