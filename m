Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948BAFC091
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 08:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfKNHNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 02:13:30 -0500
Received: from mga05.intel.com ([192.55.52.43]:19847 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfKNHN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 02:13:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 23:13:29 -0800
X-IronPort-AV: E=Sophos;i="5.68,302,1569308400"; 
   d="scan'208";a="198721968"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.126]) ([10.239.196.126])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 13 Nov 2019 23:13:25 -0800
Subject: Re: [PATCH v4 5/6] KVM: x86/vPMU: Reuse perf_event to avoid
 unnecessary pmc_reprogram_counter
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kan.liang@intel.com,
        wei.w.wang@intel.com, LKML <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
References: <20191027105243.34339-1-like.xu@linux.intel.com>
 <20191027105243.34339-6-like.xu@linux.intel.com>
 <CANRm+Cz3-k6Bct0JAN=m1emT5j4NgULjURyHz0vCDabq00nk4Q@mail.gmail.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <d0341842-3acd-5a9d-2b75-ab214fe9b659@linux.intel.com>
Date:   Thu, 14 Nov 2019 15:13:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CANRm+Cz3-k6Bct0JAN=m1emT5j4NgULjURyHz0vCDabq00nk4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Wanpeng,

On 2019/11/14 11:51, Wanpeng Li wrote:
> On Mon, 28 Oct 2019 at 21:06, Like Xu <like.xu@linux.intel.com> wrote:
>>
>> The perf_event_create_kernel_counter() in the pmc_reprogram_counter() is
>> a heavyweight and high-frequency operation, especially when host disables
>> the watchdog (maximum 21000000 ns) which leads to an unacceptable latency
> 
> Why when host disables the watchdog,
> perf_event_create_kernel_counter() is more heavyweight and
> high-frequency operation?
> 
>      Wanpeng
> 

- Fist, let me assume you do have experienced the fact that the perf 
behavior on guest for multiple hardware events is extremely sluggish when 
you disable watchdog on host. The setting of host watchdog is
the uncontrollability the patch series wants to eliminate for vPMU users.

- Disabling host watchdog brings higher frequency is imprecise. In legacy 
vPMU code, the operation is high-frequency regardless of the host watchdog 
setting. The exact frequency depends on perf sampling frequency and guest 
pmu driver pattern.

- The sched_clock() time consumed by perf_event_create_kernel_counter() is 
tested on various x86 platforms and the values suddenly become larger when 
and only when host disables watchdog. Sometimes watchdog damages the 
accuracy. In the early stages of exploration, we found if host disables 
watchdog, the synchronize_rcu() from account_event() in perf_event_alloc() 
becomes much more heavyweight and it seems to be a general necessary 
mechanism. The deeper reason behind this is undefined.

Thanks,
Like Xu
