Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51941D9674
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgESMkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 08:40:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:7366 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgESMkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 08:40:12 -0400
IronPort-SDR: 6FW52os4Cqdppnqxtk8go5qa+ytKpuW9k8GMAB5rcse/HSNhWIiS/XID9+v3JaI2tmGths1wuM
 1/k4su+x7p6Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 05:40:11 -0700
IronPort-SDR: x4mU38ekOVVnhCLzj4ikBS00IORLsjiwhezhOLTwcov5Upmvli3C5Co0Ceq4yImlh1N1IOrj7G
 u+WhCFuAXheQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="288944436"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.98]) ([10.249.171.98])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 05:40:08 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 08/11] KVM: x86/pmu: Emulate LBR feature via guest LBR
 event
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-9-like.xu@linux.intel.com>
 <20200519110355.GI279861@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <9d65806b-ec38-0ad7-b216-48ddf30ac361@intel.com>
Date:   Tue, 19 May 2020 20:40:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519110355.GI279861@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/19 19:03, Peter Zijlstra wrote:
> On Thu, May 14, 2020 at 04:30:51PM +0800, Like Xu wrote:
>> @@ -6698,6 +6698,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   
>>   	if (vcpu_to_pmu(vcpu)->version)
>>   		atomic_switch_perf_msrs(vmx);
>> +
>>   	atomic_switch_umwait_control_msr(vmx);
>>   
>>   	if (enable_preemption_timer)
> Is this where the test to see if any of the KVM events went into ERROR
> state should go?
Yes, I chose the same location to do LBR availability check in the next 
patch 0010.

Actually for normal vPMU counters and their events,
I'm not sure whether pr_warn() should also be used widely.

The current approach is to keep vPMC silent when it may be inaccurate.

I may need @Paolo's attitude on this issue.

Thanks,
Like Xu
>
> 	if (event->state == PERF_EVENT_STATE_ERROR) {
> 		pr_warn("unhappy, someone stole our counter\n");
> 	}
>
> like..

