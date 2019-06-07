Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1DC3875C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 11:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfFGJt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 05:49:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:64258 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbfFGJtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 05:49:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 02:49:55 -0700
X-ExtLoop1: 1
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.139.208]) ([10.249.139.208])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2019 02:49:52 -0700
Subject: Re: [patch 0/3] cpuidle-haltpoll driver (v2)
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LDhMKNbcODwqHDhcKZ?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20190603225242.289109849@amt.cnet>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <6c411948-9e32-9f41-351e-c9accd1facb0@intel.com>
Date:   Fri, 7 Jun 2019 11:49:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603225242.289109849@amt.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/2019 12:52 AM, Marcelo Tosatti wrote:
> The cpuidle-haltpoll driver allows the guest vcpus to poll for a specified
> amount of time before halting. This provides the following benefits
> to host side polling:
>
>          1) The POLL flag is set while polling is performed, which allows
>             a remote vCPU to avoid sending an IPI (and the associated
>             cost of handling the IPI) when performing a wakeup.
>
>          2) The HLT VM-exit cost can be avoided.
>
> The downside of guest side polling is that polling is performed
> even with other runnable tasks in the host.
>
> Results comparing halt_poll_ns and server/client application
> where a small packet is ping-ponged:
>
> host                                        --> 31.33
> halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
> halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)
>
> For the SAP HANA benchmarks (where idle_spin is a parameter
> of the previous version of the patch, results should be the
> same):
>
> hpns == halt_poll_ns
>
>                            idle_spin=0/   idle_spin=800/    idle_spin=0/
>                            hpns=200000    hpns=0            hpns=800000
> DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
> InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
> DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)	   1.29   (-3.7%)
> UpdateC00T03 (1 thread)   4.72           4.18 (-12%)	   4.53   (-5%)
>
> V2:
>
> - Move from x86 to generic code (Paolo/Christian).
> - Add auto-tuning logic (Paolo).
> - Add MSR to disable host side polling (Paolo).
>
>
>
First of all, please CC power management patches (including cpuidle, 
cpufreq etc) to linux-pm@vger.kernel.org (there are people on that list 
who may want to see your changes before they go in) and CC cpuidle 
material (in particular) to Peter Zijlstra.

Second, I'm not a big fan of this approach to be honest, as it kind of 
is a driver trying to play the role of a governor.

We have a "polling state" already that could be used here in principle 
so I wonder what would be wrong with that.  Also note that there seems 
to be at least some code duplication between your code and the "polling 
state" implementation, so maybe it would be possible to do some things 
in a common way?


