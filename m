Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BE7D05C9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 05:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfJIDPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 23:15:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:42057 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfJIDPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 23:15:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 20:15:18 -0700
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="197891410"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.204]) ([10.239.196.204])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 08 Oct 2019 20:15:15 -0700
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
 <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
 <20191008121140.GN2294@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <d492e08e-bf14-0a8b-bc8c-397f8893ddb5@linux.intel.com>
Date:   Wed, 9 Oct 2019 11:14:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191008121140.GN2294@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/10/8 20:11, Peter Zijlstra wrote:
> On Tue, Oct 01, 2019 at 08:33:45PM +0800, Like Xu wrote:
>> Hi Peter,
>>
>> On 2019/10/1 16:23, Peter Zijlstra wrote:
>>> On Mon, Sep 30, 2019 at 03:22:57PM +0800, Like Xu wrote:
>>>> +	union {
>>>> +		u8 event_count :7; /* the total number of created perf_events */
>>>> +		bool enable_cleanup :1;
>>>
>>> That's atrocious, don't ever create a bitfield with base _Bool.
>>
>> I saw this kind of usages in the tree such as "struct
>> arm_smmu_master/tipc_mon_state/regmap_irq_chip".
> 
> Because other people do tasteless things doesn't make it right.
> 
>> I'm not sure is this your personal preference or is there a technical
>> reason such as this usage is not incompatible with union syntax?
> 
> Apparently it 'works', so there is no hard technical reason, but
> consider that _Bool is specified as an integer type large enough to
> store the values 0 and 1, then consider it as a base type for a
> bitfield. That's just disguisting.

It's reasonable. Thanks.

> 
> Now, I suppose it 'works', but there is no actual benefit over just
> using a single bit of any other base type.
> 
>> My design point is to save a little bit space without introducing
>> two variables such as "int event_count & bool enable_cleanup".
> 
> Your design is questionable, the structure is _huge_, and your union has
> event_count:0 and enable_cleanup:0 as the same bit, which I don't think
> was intentional.
> 
> Did you perhaps want to write:
> 
> 	struct {
> 		u8 event_count : 7;
> 		u8 event_cleanup : 1;
> 	};
> 
> which has a total size of 1 byte and uses the low 7 bits as count and the
> msb as cleanup.

Yes, my union here is wrong and let me fix it in the next version.

> 
> Also, the structure has plenty holes to stick proper variables in
> without further growing it.

Yes, we could benefit from it.

> 
>> By the way, is the lazy release mechanism looks reasonable to you?
> 
> I've no idea how it works.. I don't know much about virt.
> 

